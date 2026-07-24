ifneq ($(shell $(CC) -dumpmachine 2>/dev/null | grep 'x86_64'), )
IS_X64 = 1
endif

USE_ASM = 1

ifdef USE_ASM
ifdef IS_X64
USE_LZMA_DEC_ASM=1
endif
ifdef IS_ARM64
USE_LZMA_DEC_ASM=1
endif
endif

ifdef USE_LZMA_DEC_ASM

LZMA_DEC_OPT_OBJS= $O/LzmaDecOpt.o

endif
