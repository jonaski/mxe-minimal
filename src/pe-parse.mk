# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pe-parse
$(PKG)_WEBSITE  := https://github.com/trailofbits/pe-parse
$(PKG)_DESCR    := Principled, lightweight C/C++ PE parser
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 29a9c8f
$(PKG)_CHECKSUM := fffab5ea68c6b1df90eebfc9f465fa80b36268dd3d2c8d166b7199692fa09fad
$(PKG)_GH_CONF  := trailofbits/pe-parse/branches/master
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := cc

# unpack in pe-util for native and cross build
$(PKG)_DEPS_$(BUILD)  :=
$(PKG)_BUILD_$(BUILD) :=

define $(PKG)_BUILD
    # build and install the cross-library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_COMMAND_LINE_TOOLS=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # test cmake find_package() example
    mkdir '$(BUILD_DIR).cmake'
    cd '$(BUILD_DIR).cmake' && $(TARGET)-cmake '$(SOURCE_DIR)/examples/peaddrconv'
    $(MAKE) -C '$(BUILD_DIR).cmake' -j '$(JOBS)'
    $(INSTALL) -m755 '$(BUILD_DIR).cmake/peaddrconv.exe' '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe'
endef
