ASM = nasm
BUILD_DIR = build
SRC_DIR = src

.PHONY: all clean

all: $(BUILD_DIR)/carlinhoos.iso

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)/iso_root

$(BUILD_DIR)/boot.bin: $(SRC_DIR)/boot/boot.asm | $(BUILD_DIR)
	$(ASM) -f bin $< -o $@

$(BUILD_DIR)/kernel.bin: $(SRC_DIR)/kernel/kernel.asm | $(BUILD_DIR)
	$(ASM) -f bin $< -o $@

$(BUILD_DIR)/carlinhoos.img: $(BUILD_DIR)/boot.bin $(BUILD_DIR)/kernel.bin
	dd if=/dev/zero of=$@ bs=512 count=2880
	dd if=$(BUILD_DIR)/boot.bin of=$@ conv=notrunc bs=512 count=1
	dd if=$(BUILD_DIR)/kernel.bin of=$@ conv=notrunc bs=512 seek=1 count=4

$(BUILD_DIR)/carlinhoos.iso: $(BUILD_DIR)/carlinhoos.img
	mkdir -p $(BUILD_DIR)/iso_root
	cp $(BUILD_DIR)/carlinhoos.img $(BUILD_DIR)/iso_root/
	xorriso -as mkisofs \
		-iso-level 3 \
		-b carlinhoos.img \
		-no-emul-boot \
		-boot-load-size 4 \
		-o $@ \
		$(BUILD_DIR)/iso_root

clean:
	rm -rf $(BUILD_DIR)
