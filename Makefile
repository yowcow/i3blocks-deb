PACKAGE := i3blocks
VERSION := 1.5

PKG_VER := $(VERSION)-1
ARCH := amd64
ARTIFACT := i3blocks_$(PKG_VER)_$(ARCH)
URL := https://github.com/vivien/i3blocks/archive/refs/tags/$(VERSION).tar.gz

all: $(ARTIFACT)/usr $(ARTIFACT)/etc $(ARTIFACT)/DEBIAN/control

$(ARTIFACT)/DEBIAN/control: DEBIAN/control $(ARTIFACT)/DEBIAN
	cat $< \
		| sed 's/{{PKG_VER}}/$(PKG_VER)/g' \
		| sed 's/{{ARCH}}/$(ARCH)/g' \
		> $@

$(ARTIFACT)/%:
	mkdir -p $@

build:
	$(MAKE) build-src
	$(MAKE) build-deb

build-src: i3blocks_$(VERSION)
	cd $< && \
		./autogen.sh && \
		./configure --prefix=$(abspath $(ARTIFACT)/usr) && \
		make && \
		make BASH_COMPLETION_DIR=$(abspath $(ARTIFACT)/usr/share/bash-completion/completions) sysconfdir=$(abspath $(ARTIFACT)/etc) install

i3blocks_$(VERSION): i3blocks_$(VERSION).tar.gz
	mkdir -p $@
	tar -xzf $< --strip-components 1 -C $@

i3blocks_$(VERSION).tar.gz:
	curl -L $(URL) -o $@

build-deb: $(ARTIFACT)
	dpkg-deb --build --root-owner-group $<

clean:
	rm -rf $(ARTIFACT)

realclean: clean
	rm -rf i3blocks_*

.PHONY: all build build-src build-deb clean realclean
