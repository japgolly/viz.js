VIZ_VERSION        := $(shell node -p "require('./package.json').version")
GRAPHVIZ_VERSION   := 2.44.0
EMSCRIPTEN_VERSION := 1.39.19
ACTUAL_EMCC_VER    := $(shell emcc --version | head -1 | perl -pe 's/.+ (1\.[0-9\.]+)( .+)?$$/$$1/')
PREFIX_LITE        = $(abspath ./target/prefix/lite)

GRAPHVIZ_SOURCE_URL = "https://gitlab.com/api/v4/projects/graphviz%2Fgraphviz/repository/archive.tar.gz?sha=$(GRAPHVIZ_VERSION)"

EMCC_OPTS += -Oz
EMCC_OPTS += -g0
EMCC_OPTS += --memory-init-file 0
EMCC_OPTS += -s ALLOW_MEMORY_GROWTH=1
EMCC_OPTS += -s ASSERTIONS=0
EMCC_OPTS += -s ENVIRONMENT=web,worker
EMCC_OPTS += -s EXPORT_NAME=VizModule
EMCC_OPTS += -s MODULARIZE=0
EMCC_OPTS += -s NO_DYNAMIC_EXECUTION=1
EMCC_OPTS += -s SINGLE_FILE=0
EMCC_OPTS += -s USE_ZLIB=1
EMCC_OPTS += -s WASM=1

# .PHONY: all deps deps-full deps-lite clean clobber expat–full graphviz-full graphviz-lite

.PHONY: default clean setup deps-lite

default: dist

setup: deps-lite node_modules

node_modules:
	yarn

deps-lite: | target/deps/lite/graphviz-$(GRAPHVIZ_VERSION)
	mkdir -p target/{deps,prefix}/lite
	grep $(GRAPHVIZ_VERSION) target/deps/lite/graphviz-$(GRAPHVIZ_VERSION)/appveyor.yml
	cd target/deps/lite/graphviz-$(GRAPHVIZ_VERSION) && ./autogen.sh
	cd target/deps/lite/graphviz-$(GRAPHVIZ_VERSION) && ./configure --quiet
	cd target/deps/lite/graphviz-$(GRAPHVIZ_VERSION)/lib/gvpr && make --quiet mkdefs CFLAGS="-w"
	mkdir -p target/deps/lite/graphviz-$(GRAPHVIZ_VERSION)/FEATURE
	cp hacks/FEATURE/sfio hacks/FEATURE/vmalloc target/deps/lite/graphviz-$(GRAPHVIZ_VERSION)/FEATURE
	cd target/deps/lite/graphviz-$(GRAPHVIZ_VERSION) && emconfigure ./configure --quiet --without-sfdp --disable-ltdl --enable-static --disable-shared --prefix=$(PREFIX_LITE) --libdir=$(PREFIX_LITE)/lib CFLAGS="-Oz -w"
	cd target/deps/lite/graphviz-$(GRAPHVIZ_VERSION) && emmake make --quiet lib plugin
	cd target/deps/lite/graphviz-$(GRAPHVIZ_VERSION)/lib && emmake make --quiet install
	cd target/deps/lite/graphviz-$(GRAPHVIZ_VERSION)/plugin && emmake make --quiet install

target/deps/lite/graphviz-$(GRAPHVIZ_VERSION): target/deps/lite/graphviz-$(GRAPHVIZ_VERSION).tar.gz
	mkdir -p $@
	tar -zxf target/deps/lite/graphviz-$(GRAPHVIZ_VERSION).tar.gz --strip-components 1 -C $@

target/deps/lite/graphviz-$(GRAPHVIZ_VERSION).tar.gz:
	mkdir -p target/deps/lite
	curl --fail --location $(GRAPHVIZ_SOURCE_URL) -o $@

clean:
	rm -rf target/{lite,golly} dist

target/lite/render.js: src/boilerplate/pre-module-lite.js target/lite/module.js src/boilerplate/post-module.js
	sed -e s/{{VIZ_VERSION}}/$(VIZ_VERSION)/ \
		-e s/{{GRAPHVIZ_VERSION}}/$(GRAPHVIZ_VERSION)/ \
		-e s/{{EMSCRIPTEN_VERSION}}/$(EMSCRIPTEN_VERSION)/ \
		$^ > $@

target/lite/module.js: src/viz.c
ifneq ($(EMSCRIPTEN_VERSION),$(ACTUAL_EMCC_VER))
	$(error Expected emcc version is [$(EMSCRIPTEN_VERSION)], installed is [$(ACTUAL_EMCC_VER)])
else
	mkdir -p target/lite
	emcc -D VIZ_LITE $(EMCC_OPTS) \
		-s EXPORTED_FUNCTIONS="['_vizRenderFromString', '_vizCreateFile', '_vizSetY_invert', '_vizSetNop', '_vizLastErrorMessage', '_dtextract', '_dtopen', '_dtdisc']" \
		-s EXTRA_EXPORTED_RUNTIME_METHODS="['ccall', 'UTF8ToString']" \
		-o $@ $< \
		-I$(PREFIX_LITE)/include \
		-I$(PREFIX_LITE)/include/graphviz \
		-L$(PREFIX_LITE)/lib \
		-L$(PREFIX_LITE)/lib/graphviz \
		-lgvplugin_core \
		-lgvplugin_dot_layout \
		-lcgraph \
		-lgvc \
		-lgvpr \
		-lpathplan \
		-lxdot \
		-lcdt
endif

dist: dist/viz.js dist/viz.wasm

dist/viz.js: src/golly-pre.js target/lite/render.js src/golly-post.js rollup.config.golly.js
	mkdir -p dist target/golly
	cat src/golly-pre.js target/lite/render.js src/golly-post.js | sed -e 's/["'"'"']module.wasm["'"'"']/""/' > target/golly/viz.js
	node_modules/.bin/rollup --config rollup.config.golly.js

dist/viz.wasm: target/lite/module.wasm
	mkdir -p dist
	cp target/lite/module.wasm dist/viz.wasm


# ======================================================================================================================================================

# EXPAT_VERSION      := 2.2.9
# EXPAT_SOURCE_URL    = "https://github.com/libexpat/libexpat/releases/download/R_2_2_9/expat-2.2.9.tar.bz2"

# all: full.render.js lite.render.js viz.js viz.es.js golly

# deps: deps-full deps-lite

# deps-full: expat-full graphviz-full

# deps-lite: graphviz-lite

# clobber: | clean
# 	rm -rf build-main build-full build-lite $(PREFIX_FULL) $(PREFIX_LITE)

# viz.es.js: src/boilerplate/pre-main.js build-main/viz.es.js
# 	sed -e s/{{VIZ_VERSION}}/$(VIZ_VERSION)/ -e s/{{EXPAT_VERSION}}/$(EXPAT_VERSION)/ -e s/{{GRAPHVIZ_VERSION}}/$(GRAPHVIZ_VERSION)/ -e s/{{EMSCRIPTEN_VERSION}}/$(EMSCRIPTEN_VERSION)/ $^ > $@

# build-main/viz.es.js: src/index.js .babelrc
# 	mkdir -p build-main
# 	node_modules/.bin/rollup --config rollup.config.es.js


# viz.js: src/boilerplate/pre-main.js build-main/viz.js
# 	sed -e s/{{VIZ_VERSION}}/$(VIZ_VERSION)/ -e s/{{EXPAT_VERSION}}/$(EXPAT_VERSION)/ -e s/{{GRAPHVIZ_VERSION}}/$(GRAPHVIZ_VERSION)/ -e s/{{EMSCRIPTEN_VERSION}}/$(EMSCRIPTEN_VERSION)/ $^ > $@

# build-main/viz.js: src/index.js .babelrc
# 	mkdir -p build-main
# 	node_modules/.bin/rollup --config rollup.config.js


# full.render.js: src/boilerplate/pre-module-full.js build-full/module.js src/boilerplate/post-module.js
# 	sed -e s/{{VIZ_VERSION}}/$(VIZ_VERSION)/ -e s/{{EXPAT_VERSION}}/$(EXPAT_VERSION)/ -e s/{{GRAPHVIZ_VERSION}}/$(GRAPHVIZ_VERSION)/ -e s/{{EMSCRIPTEN_VERSION}}/$(EMSCRIPTEN_VERSION)/ $^ > $@

# build-full/module.js: src/viz.c
# 	emcc --version | grep $(EMSCRIPTEN_VERSION)
# 	emcc $(EMCC_OPTS) -s EXPORTED_FUNCTIONS="['_vizRenderFromString', '_vizCreateFile', '_vizSetY_invert', '_vizSetNop', '_vizLastErrorMessage', '_dtextract']" -s EXTRA_EXPORTED_RUNTIME_METHODS="['Pointer_stringify', 'ccall', 'UTF8ToString']" -o $@ $< -I$(PREFIX_FULL)/include -I$(PREFIX_FULL)/include/graphviz -L$(PREFIX_FULL)/lib -L$(PREFIX_FULL)/lib/graphviz -lgvplugin_core -lgvplugin_dot_layout -lgvplugin_neato_layout -lcgraph -lgvc -lgvpr -lpathplan -lexpat -lxdot -lcdt


# $(PREFIX_FULL):
# 	mkdir -p $(PREFIX_FULL)

# expat-full: | build-full/expat-$(EXPAT_VERSION) $(PREFIX_FULL)
# 	grep $(EXPAT_VERSION) build-full/expat-$(EXPAT_VERSION)/expat_config.h
# 	cd build-full/expat-$(EXPAT_VERSION) && emconfigure ./configure --quiet --disable-shared --prefix=$(PREFIX_FULL) --libdir=$(PREFIX_FULL)/lib CFLAGS="-Oz -w"
# 	cd build-full/expat-$(EXPAT_VERSION) && emmake make --quiet -C lib all install

# graphviz-full: | build-full/graphviz-$(GRAPHVIZ_VERSION) $(PREFIX_FULL)
# 	grep $(GRAPHVIZ_VERSION) build-full/graphviz-$(GRAPHVIZ_VERSION)/appveyor.yml
# 	cd target/deps/lite/graphviz-$(GRAPHVIZ_VERSION) && ./autogen.sh
# 	cd build-full/graphviz-$(GRAPHVIZ_VERSION) && ./configure --quiet
# 	cd build-full/graphviz-$(GRAPHVIZ_VERSION)/lib/gvpr && make --quiet mkdefs CFLAGS="-w"
# 	mkdir -p build-full/graphviz-$(GRAPHVIZ_VERSION)/FEATURE
# 	cp hacks/FEATURE/sfio hacks/FEATURE/vmalloc build-full/graphviz-$(GRAPHVIZ_VERSION)/FEATURE
# 	cd build-full/graphviz-$(GRAPHVIZ_VERSION) && emconfigure ./configure --quiet --without-sfdp --disable-ltdl --enable-static --disable-shared --prefix=$(PREFIX_FULL) --libdir=$(PREFIX_FULL)/lib CFLAGS="-Oz -w"
# 	cd build-full/graphviz-$(GRAPHVIZ_VERSION) && emmake make --quiet lib plugin
# 	cd build-full/graphviz-$(GRAPHVIZ_VERSION)/lib && emmake make --quiet install
# 	cd build-full/graphviz-$(GRAPHVIZ_VERSION)/plugin && emmake make --quiet install


# build-full/expat-$(EXPAT_VERSION): sources/expat-$(EXPAT_VERSION).tar.bz2
# 	mkdir -p $@
# 	tar -jxf sources/expat-$(EXPAT_VERSION).tar.bz2 --strip-components 1 -C $@

# build-full/graphviz-$(GRAPHVIZ_VERSION): sources/graphviz-$(GRAPHVIZ_VERSION).tar.gz
# 	mkdir -p $@
# 	tar -zxf sources/graphviz-$(GRAPHVIZ_VERSION).tar.gz --strip-components 1 -C $@

# sources:
# 	mkdir -p sources

# sources/expat-$(EXPAT_VERSION).tar.bz2: | sources
# 	curl --fail --location $(EXPAT_SOURCE_URL) -o $@
