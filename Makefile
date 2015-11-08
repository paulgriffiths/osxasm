MKFLPATH    := $(realpath $(lastword $(MAKEFILE_LIST)))
MKFLDIR     := $(dir $(MKFLPATH))
LIBDIR      := $(MKFLDIR)lib
BINDIR      := $(MKFLDIR)bin
INCLDIR     := $(MKFLDIR)include
LIBRARIES   :=
OBJECTS	    :=
PROGRAMS    :=

AS          := as
ASFLAGS	    := -g -arch x86_64 -I$(INCLDIR)
CC          := cc
CFLAGS      := -std=c99 -pedantic -Wall -Wextra -I$(INCLDIR)
RM          := rm -f
LD          := ld
LDFLAGS     := -Llib -e _entrypoint
LDLIBS	    := -lpgasm

default: all

%.o : %.c
	 $(CC) -c $(CFLAGS) -o $*.o $*.c

%.o : %.s
	 $(AS) $(ASFLAGS) -o $*.o $*.s

include libsrc/module.mk
include src/module.mk
include csrc/module.mk

all: $(PROGRAMS)

clean:
	$(RM) *.o $(PROGRAMS) $(LIBRARIES) $(OBJECTS)
