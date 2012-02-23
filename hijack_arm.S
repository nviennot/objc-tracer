.macro HIJACK
.section	__TEXT,__text,regular,pure_instructions
.globl _$0
.align 4
_$0:
  stmdb	sp!, {r0-r12, lr}
  bl	_msg_debug_$1
  bl	_func_init
  ldmia	sp!, {r0-r12, lr}
  stmdb sp!, {r0, pc}
  ldr	r0, reloc_$0
reloc_pc_$0:
  ldr	r0, [pc, r0]
  ldr	r0, [r0]
  str   r0, [sp, #4]
  ldmia sp!, {r0, pc}

.align 4
reloc_$0:
  .long _old_$0$non_lazy_ptr-(reloc_pc_$0+8)
.section	__DATA,__nl_symbol_ptr,non_lazy_symbol_pointers
_old_$0$non_lazy_ptr:
	.indirect_symbol	_old_$0
	.long	0
.endmacro

#define FUNC(symbol, prototype) HIJACK symbol, prototype
#include "objc_funcs.h"
