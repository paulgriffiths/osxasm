LOCAL_DIR  := src
LOCAL_SRC  := $(wildcard $(LOCAL_DIR)/*.s)
LOCAL_PROG := $(subst .s,,$(subst src/,$(BINDIR)/,$(LOCAL_SRC)))
LOCAL_OBJ  := $(subst .s,.o,$(LOCAL_SRC))

#$(BINDIR)/testatoi: $(LOCAL_DIR)/testatoi.o $(LIBRARIES)
#	$(LD) -o $@ $^

#$(BINDIR)/primes: $(LOCAL_DIR)/primes.o $(LIBRARIES)
#	$(LD) -o $@ $^

$(BINDIR)/guesser: $(LOCAL_DIR)/guesser.o $(LIBRARIES)
	$(LD) -o $@ $^ $(LDFLAGS)

#$(BINDIR)/testinput: $(LOCAL_DIR)/testinput.o $(LIBRARIES)
#	$(LD) -o $@ $^

#$(BINDIR)/rand: $(LOCAL_DIR)/rand.o $(LIBRARIES)
#	$(LD) -o $@ $^

$(BINDIR)/hello: $(LOCAL_DIR)/hello.o $(LIBRARIES)
	$(LD) -e _entrypoint -o $@ $^ $(LDFLAGS)

#$(BINDIR)/strtest: $(LOCAL_DIR)/strtest.o $(LIBRARIES)
#	$(LD) -o $@ $^

#$(BINDIR)/testchartype: $(LOCAL_DIR)/testchartype.o $(LIBRARIES)
#	$(LD) -o $@ $^

PROGRAMS	+= $(LOCAL_PROG)
OBJECTS	    += $(LOCAL_OBJ)
