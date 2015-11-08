LOCAL_DIR  := libsrc
LOCAL_LIB  := $(LIBDIR)/libpgasm.a
LOCAL_SRC  := $(wildcard $(LOCAL_DIR)/*.s)
LOCAL_OBJ  := $(subst .s,.o,$(LOCAL_SRC))

$(LOCAL_LIB): $(LOCAL_OBJ)
	@$(AR) $(ARFLAGS) $@ $^

LIBRARIES  += $(LOCAL_LIB)
OBJECTS	   += $(LOCAL_OBJ)
