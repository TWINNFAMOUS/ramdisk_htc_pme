# Commands to build boot.img

all: bootimage

MKBOOTIMG := tools/mkbootimg/mkbootimg
$(MKBOOTIMG):
	make -C tools/mkbootimg

MKBOOTFS := tools/mkbootfs/mkbootfs
$(MKBOOTFS):
	make -j1 -C tools/mkbootfs

BOOT_IMAGE_OUT := boot.img
KERNEL_IMAGE   := Image.gz
RAMDISK        := initramfs.cpio.gz
DEVTREE        := dt.img

BOARD_KERNEL_PAGESIZE    := 4096
BOARD_KERNEL_BASE        := 0x80000000
BOARD_KERNEL_TAGS_OFFSET := 0x02000000
BOARD_RAMDISK_OFFSET     := 0x02200000
BOARD_KERNEL_CMDLINE     := 'console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 user_debug=31 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 cma=20M@0-0xffffffff androidboot.hardware=qcom androidkey.dummy=1'

.PHONY: ramdisk FORCE_RDISK
ramdisk: $(RAMDISK)
FORCE_RDISK:

RAMDISK_ROOT := rootdir

$(RAMDISK): $(MKBOOTFS) FORCE_RDISK
	$(MKBOOTFS) $(RAMDISK_ROOT) | gzip -9 -n >$@

MKBOOTIMG_ARGS := --kernel $(KERNEL_IMAGE) --ramdisk $(RAMDISK) --dt $(DEVTREE) \
    --base $(BOARD_KERNEL_BASE) --ramdisk_offset $(BOARD_RAMDISK_OFFSET) \
	--tags_offset $(BOARD_KERNEL_TAGS_OFFSET) --cmdline $(BOARD_KERNEL_CMDLINE) \
	--pagesize $(BOARD_KERNEL_PAGESIZE)

.PHONY: bootimage
bootimage: $(BOOT_IMAGE_OUT)

$(BOOT_IMAGE_OUT): $(KERNEL_IMAGE) $(RAMDISK) $(DEVTREE) $(MKBOOTIMG)
	$(MKBOOTIMG) $(MKBOOTIMG_ARGS) -o $@

clean:
	rm -f $(BOOT_IMAGE_OUT) $(RAMDISK)
