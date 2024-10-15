DEV_ROCKS = "luacov 0.15.0" "busted 2.1.2-3" "luacheck 0.20.0"
LUA_PROJECT = luacov-sonarcloud
VERSION = 1.0.0-1

rockspec:
	cp rockspec.template ${LUA_PROJECT}-$(VERSION).rockspec

setup: rockspec
	@for rock in $(DEV_ROCKS) ; do \
		if luarocks list --porcelain $$rock | grep -q "installed" ; then \
			echo $$rock already installed, skipping ; \
		else \
			echo $$rock not found, installing via luarocks... ; \
			luarocks install $$rock ; \
		fi \
	done;

check:
	cd $(PROJECT_FOLDER)
	@for rock in $(DEV_ROCKS) ; do \
		if luarocks list --porcelain $$rock | grep -q "installed" ; then \
			echo $$rock is installed ; \
		else \
			echo $$rock is not installed ; \
		fi \
	done;

install:
	-@luarocks remove $(LUA_PROJECT)
	luarocks make

test:
	cd $(PROJECT_FOLDER) && busted spec/ ${ARGS}

coverage:
	cd $(PROJECT_FOLDER) && busted spec/ -c && luacov && luacov-cobertura -o cobertura.xml

package:
	luarocks make --pack-binary-rock

lint:
	cd $(PROJECT_FOLDER) && luacheck -q .
