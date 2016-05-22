CC = gcc
CFLAGS = -Wall -Wextra -pedantic -std=gnu11 -I.
LFLAGS = -lc -lm

ifeq ($(DEBUG),1)
    CFLAGS += -g -O0
else
    CLFAGS += -O3
endif

all: mkbootfs

mkbootfs: mkbootfs.o fs_config.o
	$(CC) $(LFLAGS) $^ -o $@

%.o: %.c android_filesystem_config.h android_filesystem_capability.h
	$(CC) -c $(CFLAGS) $< -o $@

.PHONY: clean

clean:
	rm -f *.o mkbootfs
