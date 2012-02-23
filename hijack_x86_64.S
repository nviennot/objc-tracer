.macro HIJACK
.globl _$0
_$0:
  push %rax # slot for the address of real msgSend
  push %rax

  push %rcx
  push %rdx
  push %rdi
  push %rsi
  push %r8
  push %r9
  push %r10
  push %r11
  push %r11
  call _msg_debug_$1
  call _func_init
  pop %r11
  pop %r11
  pop %r10
  pop %r9
  pop %r8
  pop %rsi
  pop %rdi
  pop %rdx
  pop %rcx

  mov _old_$0@GOTPCREL(%rip), %rax
  mov (%rax), %rax
  mov %rax, 8(%rsp)
  pop %rax
  ret
.endmacro

#define FUNC(symbol, prototype) HIJACK symbol, prototype;
#include "objc_funcs.h"
