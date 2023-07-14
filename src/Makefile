SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

SITE := benary.org
PREFIX := /usr/local

default: website
.PHONY: default

website: openpgpkey/$(SITE) index.json
.PHONY: website

openpgpkey:
	mkdir -p $@

openpgpkey/$(SITE): key openpgpkey
	env GNUPGHOME=./.gnupg gpg --import key/*.asc
	env GNUPGHOME=./.gnupg gpg --list-options show-only-fpr-mbox --list-key | env GNUPGHOME=./.gnupg gpg-wks-client -v --install-key

clean:
	rm -rf ./.gnupg
	rm -rf ./opengpgkey
.PHONY: clean

install: website
	install -v -D -m644 index.json $(PREFIX)/share/benaryorg-website/www/index.json
	install -v -D -m644 evil $(PREFIX)/share/benaryorg-website/www/evil
	(cd openpgpkey/$(SITE)/ && find . -type f -exec install -v -D -m644 {} $(PREFIX)/share/benaryorg-website/www/.well-known/openpgpkey/{} ";")
.PHONY: install
