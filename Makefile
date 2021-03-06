PKGNAME := yowcow-i3blocks
PKGVERSION := 1.5
PKGRELEASE := 3
ARCH := amd64

URL := https://github.com/vivien/i3blocks
PKGSOURCE := $(URL)/archive/refs/tags/$(PKGVERSION).tar.gz
SOURCEDIR := $(PKGNAME)_$(PKGVERSION)

ARTIFACT := $(PKGNAME)_$(PKGVERSION)-$(PKGRELEASE)_$(ARCH).deb

all: $(SOURCEDIR)
	cd $< && \
		./autogen.sh && \
		./configure --prefix=/usr && \
		make

$(SOURCEDIR): $(SOURCEDIR).tar.gz
	mkdir -p $@
	tar xzf $< --strip-components 1 -C $@

%.tar.gz:
	curl -L $(PKGSOURCE) -o $@

build: $(ARTIFACT)

$(ARTIFACT): $(SOURCEDIR)/$(ARTIFACT)
	mv $< $@

$(SOURCEDIR)/$(ARTIFACT):
	cd $(dir $@) && \
		checkinstall \
			-D \
			--maintainer yowcow@gmail.com \
			--summary "i3blocks for i3wm" \
			--pkgname $(PKGNAME) \
			--pkgversion $(PKGVERSION) \
			--pkgrelease $(PKGRELEASE) \
			--arch $(ARCH) \
			--pkgsource $(URL) \
			--recommends i3 \
			--conflicts i3blocks \
			-y \
			make BASH_COMPLETION_DIR=/usr/share/bash-completion/completions sysconfdir=/etc install

clean:
	rm -rf $(SOURCEDIR)

realclean: clean
	rm -rf *.tar.gz *.deb

.PHONY: all build clean realclean
