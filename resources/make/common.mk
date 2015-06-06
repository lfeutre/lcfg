ifeq ($(shell which erl),)
$(error Can't find Erlang executable 'erl')
exit 1
endif
OS := $(shell uname -s)
ifeq ($(OS),Linux)
HOST=$(HOSTNAME)
endif
ifeq ($(OS),Darwin)
HOST = $(shell scutil --get ComputerName)
endif

LIB = $(PROJECT)
DEPS = ./deps
BIN_DIR = ./bin
SOURCE_DIR = ./src
OUT_DIR = ./ebin
TEST_DIR = ./test
TEST_OUT_DIR = ./.eunit
SCRIPT_PATH=$(DEPS)/lfe/bin:.:./bin:"$(PATH)":/usr/local/bin
ifeq ($(shell which lfetool),)
LFETOOL=$(BIN_DIR)/lfetool
else
LFETOOL=lfetool
endif
RELEASE_DIR = ./release
RELX_CFG = $(RELEASE_DIR)/relx.config
ERL_LIBS = $(shell pwd):$(shell $(LFETOOL) info erllibs)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

get-lfetool: $(BIN_DIR)
	curl -L -o ./lfetool https://raw.githubusercontent.com/lfe/lfetool/dev-v1/lfetool && \
	chmod 755 ./lfetool && \
	mv ./lfetool $(BIN_DIR)

copy-appsrc:
	@mkdir -p $(OUT_DIR)
	@cp src/$(PROJECT).app.src ebin/$(PROJECT).app

get-version:
	@echo "Erlang/OTP, LFE, & library versions:"
	@ERL_LIBS=$(ERL_LIBS) PATH=$(SCRIPT_PATH) erl \
	-eval "lfe_io:format(\"~p~n\",['$(PROJECT)-util':'get-versions'()])." \
	-noshell -s erlang halt

get-erllibs:
	@echo "ERL_LIBS from lfetool:"
	@ERL_LIBS=$(ERL_LIBS) $(LFETOOL) info erllibs

get-codepath:
	@echo "Code path:"
	@ERL_LIBS=$(ERL_LIBS) \
	erl -eval "io:format(\"~p~n\", [code:get_path()])." -noshell -s erlang halt

debug: get-erllibs get-codepath

get-deps:
	@echo "Getting dependencies ..."
	@lfetool download deps || \
	(which rebar.cmd >/dev/null 2>&1 && rebar.cmd get-deps || rebar get-deps)

clean-ebin:
	@echo "Cleaning ebin dir ..."
	@rm -f $(OUT_DIR)/*.beam

clean-eunit:
	-@PATH=$(SCRIPT_PATH) $(LFETOOL) tests clean

compile-tests: clean-eunit
	@PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) $(LFETOOL) tests build

repl: compile
	@which clear >/dev/null 2>&1 && clear || printf "\033c"
	@echo "Starting an LFE REPL ..."
	@PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) $(LFETOOL) repl lfe +pc unicode

repl-no-deps: compile-no-deps
	@which clear >/dev/null 2>&1 && clear || printf "\033c"
	@echo "Starting an LFE REPL ..."
	@PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) $(LFETOOL) repl lfe +pc unicode

shell: compile
	@which clear >/dev/null 2>&1 && clear || printf "\033c"
	@echo "Starting an Erlang shell ..."
	@PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) erl +pc unicode

shell-no-deps: compile-no-deps
	@which clear >/dev/null 2>&1 && clear || printf "\033c"
	@echo "Starting an Erlang shell ..."
	@PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) erl +pc unicode

compile: get-deps clean-ebin copy-appsrc
	@echo "Compiling project code and dependencies ..."
	@which rebar.cmd >/dev/null 2>&1 && \
	PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) rebar.cmd compile || \
	PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) rebar compile
	@make compile-appsrc

compile-no-deps: clean-ebin
	@echo "Compiling only project code ..."
	@which rebar.cmd >/dev/null 2>&1 && \
	PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) \
	rebar.cmd compile skip_deps=true || \
	PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) rebar compile skip_deps=true
	@make compile-appsrc

compile-appsrc:
	@echo "Generating app.src file ..."
	-@PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) lfe -eval \
	'(lcfg-appsrc:write "ebin/$(PROJECT).app")'

clean: clean-ebin clean-eunit
	@which rebar.cmd >/dev/null 2>&1 && rebar.cmd clean || rebar clean

check-unit-only: clean-eunit
	@PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) $(LFETOOL) tests unit

check-integration-only: clean-eunit
	@PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) $(LFETOOL) tests integration

check-system-only: clean-eunit
	@PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) $(LFETOOL) tests system

check-unit-with-deps: get-deps compile compile-tests check-unit-only
check-unit: compile-no-deps check-unit-only
check-integration: compile check-integration-only
check-system: compile check-system-only
check-all-with-deps: compile check-unit-only check-integration-only \
	check-system-only
check-all: get-deps compile-no-deps clean-eunit
	@PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) $(LFETOOL) tests all

check: check-unit-with-deps

check-travis: compile compile-tests check-unit-only

$(RELEASE_DIR):
	@echo "Creating release directory ..."
	@mkdir -p $(RELEASE_DIR)

relx-config:
	@echo "Generating relx.config file ..."
	-@PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) lfe -eval \
	'(lcfg-relx:write "$(RELX_CFG)")'

rel: compile $(RELEASE_DIR) relx-config
	@echo "Creating release ..."
	-@PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) \
	relx -c $(RELX_CFG) -o $(RELEASE_DIR)

clean-release:
	@echo "Removing relx.config file ..."
	-@rm  -rf $(RELEASE_DIR)

push-all:
	@echo "Pushing code to github ..."
	git push --all
	git push --tags
	@#git push upstream --all
	@#git push upstream --tags
	git push backup --all
	git push backup --tags
