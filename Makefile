RM ?= rm
LN ?= ln
ECHO ?= echo
SIZE ?= size
OBJCOPY ?= objcopy

BUILD = build

############################### targets #################################

default: $(BUILD) $(BUILD)/firmware.bin
all: $(BUILD) $(BUILD)/firmware.bin
clean:
	$(RM) -f build/*
run: all
	( cd ../microwatt && \
	$(LN) -s ../microhello/build/firmware.bin simple_ram_behavioural.bin && \
	./core_tb > /dev/null )
runrun: all
	( cd ../microwatt && $(RM) simple_ram_behavioural.bin )
	$(MAKE) run

############################## machinery ################################

ARCH = $(shell uname -m)
ifneq ("$(ARCH)", "ppc64")
ifneq ("$(ARCH)", "ppc64le")
	CROSS_COMPILE = powerpc64le-linux-
endif
endif

INC += -I.

CC ?= $(CROSS_COMPILE)gcc
CFLAGS = $(INC) -g -Wall -std=c99
CFLAGS += -msoft-float -mno-string -mno-multiple -mno-vsx -mno-altivec -mlittle-endian -fno-stack-protector -mstrict-align -ffreestanding
CFLAGS += -Os
CFLAGS += -fdata-sections -ffunction-sections

LD ?= $(CROSS_COMPILE)ld
LDFLAGS = -N -T powerpc.lds

LIBS =

SRC_C = \
	main.c \
	uart_core.c \
        string.c

OBJ = $(addprefix $(BUILD)/, $(SRC_C:.c=.o))

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<
$(BUILD)/head.o : $(BUILD) head.S
	$(CC) head.S -c -o $(BUILD)/head.o

$(BUILD)/firmware.elf: $(OBJ) $(BUILD)/head.o powerpc.lds
	$(LD) $(LDFLAGS) -o $@ $^ $(LIBS)
	$(SIZE) $@

$(BUILD)/firmware.bin: $(BUILD)/firmware.elf
	$(OBJCOPY) -O binary $^ $(BUILD)/firmware.bin

$(BUILD)/firmware.map: $(BUILD)/firmware.elf
	nm $^ | sort > $(BUILD)/firmware.map

