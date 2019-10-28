SHELL := /bin/bash

all: _site

clean:
	rm -rf _site _concepts

distclean: clean
	rm -rf concepts_data concepts glossary.csv

# Don't remove _data/info.yaml since osgeo-termbase can't generate it yet
	#_data/info.yaml

data: _data/info.yaml _concepts

glossary.csv:
	bundle exec osgeo-termbase-fetchcsv glossary.csv

concepts_data: glossary.csv
	bundle exec osgeo-termbase-csv2yaml glossary.csv
	mv concepts concepts_data

_site: data | bundle
	bundle exec jekyll build

bundle:
	bundle

# Make collection YAML files into adoc files
_concepts: concepts_data
	mkdir -p $@
	for filename in $</*.yaml; do \
	    [ -e "$$filename" ] || continue; \
			newpath=$${filename//$<\/concept-/$@\/}; \
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
