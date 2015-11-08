LOCAL_DIR  := csrc
LOCAL_SRC  := $(wildcard $(LOCAL_DIR)/*.c)
LOCAL_PROG := $(subst .c,,$(subst $(LOCAL_DIR)/,$(BINDIR)/,$(LOCAL_SRC)))
LOCAL_OBJ  := $(subst .c,.o,$(LOCAL_SRC))

$(BINDIR)/c_teststring: $(LOCAL_DIR)/c_teststring.o $(LIBRARIES)
	$(CC) -o $@ $^

$(BINDIR)/c_testrand: $(LOCAL_DIR)/c_testrand.o $(LIBRARIES)
	$(CC) -o $@ $^

$(BINDIR)/c_testprint: $(LOCAL_DIR)/c_testprint.o $(LIBRARIES)
	$(CC) -o $@ $^

$(BINDIR)/c_testchartypes: $(LOCAL_DIR)/c_testchartypes.o $(LIBRARIES)
	$(CC) -o $@ $^

PROGRAMS	+= $(LOCAL_PROG)
OBJECTS	    += $(LOCAL_OBJ)
