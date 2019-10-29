SHELL := /bin/bash

all: _site

clean:
	rm -rf _site _concepts

distclean: clean
	rm -rf concepts_data concepts

# Don't remove _data/info.yaml since osgeo-termbase can't generate it yet
	#_data/info.yaml

data: _data/info.yaml _concepts

_site: data | bundle
	bundle exec jekyll build

bundle:
	bundle

# Make collection YAML files into adoc files
_concepts:
	mkdir -p $@
	for filename in osgeo-glossary/concepts/*.yaml; do \
	    [ -e "$$filename" ] || continue; \
			newpath=$${filename//osgeo-glossary\/concepts\/concept-/$@\/}; \
	    cp $$filename $${newpath//yaml/adoc}; \
			echo "---" >> $${newpath//yaml/adoc}; \
	done

serve:
	bundle exec jekyll serve

update-init:
	git submodule update --init

update-modules:
	git submodule foreach git pull origin master

.PHONY: data bundle all open serve distclean clean update-init update-modules
