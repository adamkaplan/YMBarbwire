//
//  AppDelegate-x86-64.s
//  Barbwire
//
//  Created by Adam Kaplan on 12/15/14.
//  Copyright (c) 2014 Adam Kaplan. All rights reserved.
//
#include <TargetConditionals.h>

#if __x86_64__  &&  TARGET_IPHONE_SIMULATOR

/////////////////////////////////////////////////////////////////////
//Names for relative labels
/////////////////////////////////////////////////////////////////////

#define YAssertationFailed Y1

/////////////////////////////////////////////////////////////////////
// Names for parameter registers.
/////////////////////////////////////////////////////////////////////

#define a1  rdi
#define a1d edi
#define a1b dil
#define a2  rsi
#define a2d esi
#define a2b sil
#define a3  rdx
#define a3d edx
#define a4  rcx
#define a4d ecx
#define a5  r8
#define a5d r8d
#define a6  r9
#define a6d r9d
#define tmp r11

/////////////////////////////////////////////////////////////////////
//
// SaveRegisters
//
// Pushes a stack frame and saves all registers that might contain
// parameter values.
//
// On entry:
//		stack = ret
//
// On exit: 
//		%rsp is 16-byte aligned
//	
/////////////////////////////////////////////////////////////////////

.macro SaveRegisters

	push %rbp
    .cfi_def_cfa_offset 16
	.cfi_offset rbp, -16

	mov	%rsp, %rbp
    .cfi_def_cfa_register rbp

	
	sub	$$0x80+8, %rsp		// +8 for alignment

	movdqa	%xmm0, -0x80(%rbp)
	push	%rax			// might be xmm parameter count
	movdqa	%xmm1, -0x70(%rbp)
	push	%a1
	movdqa	%xmm2, -0x60(%rbp)
	push	%a2
	movdqa	%xmm3, -0x50(%rbp)
	push	%a3
	movdqa	%xmm4, -0x40(%rbp)
	push	%a4
	movdqa	%xmm5, -0x30(%rbp)
	push	%a5
	movdqa	%xmm6, -0x20(%rbp)
	push	%a6
	movdqa	%xmm7, -0x10(%rbp)
	
.endmacro

/////////////////////////////////////////////////////////////////////
//
// RestoreRegisters
//
// Pops a stack frame pushed by SaveRegisters
//
// On entry:
//		%rbp unchanged since SaveRegisters
//
// On exit: 
//		stack = ret
//	
/////////////////////////////////////////////////////////////////////

.macro RestoreRegisters

	movdqa	-0x80(%rbp), %xmm0
	pop	%a6
	movdqa	-0x70(%rbp), %xmm1
	pop	%a5
	movdqa	-0x60(%rbp), %xmm2
	pop	%a4
	movdqa	-0x50(%rbp), %xmm3
	pop	%a3
	movdqa	-0x40(%rbp), %xmm4
	pop	%a2
	movdqa	-0x30(%rbp), %xmm5
	pop	%a1
	movdqa	-0x20(%rbp), %xmm6
	pop	%rax
	movdqa	-0x10(%rbp), %xmm7
	
	//leave
    add	$$0x80+8, %rsp		// +8 for alignment
    mov %rbp, %rsp
    pop %rbp
	.cfi_def_cfa rsp, 8
	//.cfi_same_value rbp

.endmacro

//////////////////////////////////////////////////////////////////////
//
// ENTRY		functionName
//
// Assembly directives to begin an exported function.
//
// Takes: functionName - name of the exported function
//////////////////////////////////////////////////////////////////////

.macro ENTRY
	.text
	.globl	_$0
_$0:
	.cfi_startproc
.endmacro

//////////////////////////////////////////////////////////////////////
//
// END_ENTRY	functionName
//
// Assembly directives to end an exported function.  Just a placeholder,
// a close-parenthesis for ENTRY, until it is needed for something.
//
// Takes: functionName - name of the exported function
//////////////////////////////////////////////////////////////////////

.macro END_ENTRY
	.cfi_endproc
LExit_$0:
.endmacro

//////////////////////////////////////////////////////////////////////
//
// _messengerHook
//
// Save all argument registers, call the checker method, restore
// registers and jump into the target function (which is returned
// by the checker method)
//
//////////////////////////////////////////////////////////////////////

ENTRY messengerHook

    //int3
    SaveRegisters
    call _barbwire_msgSend
    movq %rax, %tmp
    RestoreRegisters

    //testq %tmp, %tmp
    //je YAssertationFailed
    jmpq *%tmp

YAssertationFailed:
    ret

END_ENTRY messengerHook

//////////////////////////////////////////////////////////////////////
//
// messengerHook_stret
//
// Save all argument registers, call the checker method, restore
// registers and jump into the target function (which is returned
// by the stret checker method)
//
//////////////////////////////////////////////////////////////////////

ENTRY messengerHook_stret

    SaveRegisters
    call _barbwire_msgSend_stret
    movq %rax, %tmp
    RestoreRegisters

    //testq %tmp, %tmp
    //je YAssertationFailedStret
    jmpq *%tmp

YAssertationFailedStret:
    ret

END_ENTRY messengerHook_stret

#endif
