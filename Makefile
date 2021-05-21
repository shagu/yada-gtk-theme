define replace
	@echo -e "$(3): $(1) -> $(2)"
	@find arc-theme/ -type f -exec sed -i "s/$(1)/$(2)/gI" {} \;
endef

define step
	@echo -e "\e[1;34m::\e[0;1m $(1)\e[0m"
endef

accent = "\#8AB4F8"

all: clean fetch colors name meson release theme

clean:
	$(call step,"Cleanup")
	rm -rf arc-theme

fetch:
	$(call step,"Fetch Upstream Arc")
	git submodule init
	git submodule update
	git submodule update --recursive --remote

colors:
	$(call step,"Replace Colors")
	$(call replace,"#383C4A","#1a1a1a","Background [Main]")
	$(call replace,"#404552","#212121","Background [Widgets]")
	$(call replace,"#444A58","#212121","Button")
	$(call replace,"#3E4350","#000000","Button [Inactive]")
	$(call replace,"#505666","${accent}","Button [Highlight]")
	$(call replace,"#767B87","${accent}","Scrollbar [Slider]")
	$(call replace,"#3E434F","#1a1a1a","Scrollbar [Background]")
	$(call replace,"#2F343F","#1a1a1a","Headerbar")
	$(call replace,"#5294e2","${accent}","Selection")
	$(call replace,"#D3DAE3","#eeeeee","Font Color")

name:
	$(call step,"Replacing Name")
	$(call replace,"Arc-Dark","yada-gtk","Main Theme")
	$(call replace,"Arc","yada-gtk","Leftovers")

meson:
	$(call step,"Theme Build")
	cd arc-theme && meson setup --prefix=`dirname \`pwd\`` -Dvariants=dark build/
	cd arc-theme && meson install -C build/

release:
	$(call step,"Build Theme Release Package")
	mkdir -p release
	cd share/themes && tar cfJ ../../release/yada-gtk.tar.xz yada-gtk
	
theme:
	$(call step,"Update Yada Theme")
	cp -rf share/themes/yada-gtk/* .
