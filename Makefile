# select your arch
ARCH=ARM
#ARCH=X86_64

ifeq ($(ARCH), ARM)
	# iOS
	DEVROOT=/Developer/Platforms/iPhoneOS.platform/Developer
	SDKROOT=$(DEVROOT)/SDKs/iPhoneOS5.0.sdk
	ARCHFLAGS=-arch armv6 -arch armv7
	CFLAGS=-isysroot $(SDKROOT) -std=c99 -fPIC $(ARCHFLAGS) -DARM
	LDFLAGS=-isysroot $(SDKROOT) $(ARCHFLAGS) -lobjc
	CC=$(DEVROOT)/usr/bin/gcc
	STRIP=$(DEVROOT)/usr/bin/strip
	NM=$(DEVROOT)/usr/bin/nm
else
	# MacOSX
	CFLAGS=-std=c99 -fPIC
	LDFLAGS=-lobjc
	CC=/usr/bin/gcc
	STRIP=/usr/bin/strip
	NM=/usr/bin/nm
endif

OBJDIR = obj
CSRC = objc-tracer.c
SSRC = hijack.S
TARGET=objc-tracer.dylib
EXPORT_SYMBOLS=_objc_msgSend

OBJ = $(CSRC:%.c=$(OBJDIR)/%.o) $(SSRC:%.S=$(OBJDIR)/%.o)

all: $(TARGET)

$(OBJDIR)/.exists:
	@if [ ! -d $(OBJDIR) ]; then mkdir -p "$(OBJDIR)"; fi
	@touch $(OBJDIR)/.exists

$(OBJDIR)/%.o: %.c objc_funcs.h
	@echo "[CC ] $<"
	@$(CC) $(CFLAGS) -c -o $@ $<

hijack.S:
	@ln -s hijack_$(shell echo $(ARCH) | tr A-Z a-z).S $@

$(OBJDIR)/hijack.o: hijack.S objc_funcs.h
	@echo "[CC ] $<"
	@$(CC) $(CFLAGS) -c -o $@ $<

$(TARGET): $(OBJDIR)/.exists $(OBJ)
	@echo "[LINK] $@"
	@$(CC) $(LDFLAGS) -shared -o $@ $(OBJ)
	@echo "[STRIP] $@"
	@$(NM) $@ | grep "T $(EXPORT_SYMBOLS)" | cut -d ' ' -f 3  > $@.syms
	@$(STRIP) -arch all -s $@.syms -u $@ || rm $@

clean:
	rm -f hijack.S
	rm -f $(OBJ)
	rm -rf "$(OBJDIR)"
	rm -f *.syms
	rm -f $(TARGET)

.PHONY: clean

