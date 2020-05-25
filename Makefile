SHELL := /bin/bash

all: _site

clean:
	rm -rf _site

distclean: clean

# Don't remove _data/info.yaml since osgeo-termbase can't generate it yet
	#_data/info.yaml

data: _source/_data/info.yaml

_site: data | bundle
	bundle exec jekyll build

bundle:
	bundle

serve:
	bundle exec jekyll serve

update-init:
	git submodule update --init

update-modules:
	git submodule foreach git pull origin master

.PHONY: data bundle all open serve distclean clean update-init update-modules
