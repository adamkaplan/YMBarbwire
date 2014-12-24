//
//  AppDelegate-arm64.s
//  Barbwire
//
//  Created by Adam Kaplan on 12/19/14.
//  Copyright (c) 2014 Adam Kaplan. All rights reserved.
//
#ifdef __arm64__

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#include <arm/arch.h>
#pragma clang diagnostic pop


//////////////////////////////////////////////////////////////////////
// Names for relative labels
//////////////////////////////////////////////////////////////////////

#define YAssertationFailed 100

//////////////////////////////////////////////////////////////////////
//
// ENTRY		functionName
//
// Assembly directives to begin an exported function.
//
// Takes: functionName - name of the exported function
//////////////////////////////////////////////////////////////////////

.macro ENTRY /* name */
	.text
	.align 5
	.globl    _$0
_$0:
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

.macro END_ENTRY /* name */
LExit_$0:
.endmacro

/////////////////////////////////////////////////////////////////////
//
// SaveRegisters
//
// Pushes a stack frame and saves all registers that might contain
// parameter values.
//	
/////////////////////////////////////////////////////////////////////

.macro SaveRegisters
	stp	fp, lr, [sp, #-16]!
	mov	fp, sp

    // save parameter registers: x0..x8, q0..q7
    sub	sp, sp, #(10*8 + 8*16)
    stp	q0, q1, [sp, #(0*16)]
    stp	q2, q3, [sp, #(2*16)]
    stp	q4, q5, [sp, #(4*16)]
    stp	q6, q7, [sp, #(6*16)]
    stp	x0, x1, [sp, #(8*16+0*8)]
    stp	x2, x3, [sp, #(8*16+2*8)]
    stp	x4, x5, [sp, #(8*16+4*8)]
    stp	x6, x7, [sp, #(8*16+6*8)]
    str	x8,     [sp, #(8*16+8*8)]

.endmacro

/////////////////////////////////////////////////////////////////////
//
// RestoreRegisters
//
// Pops a stack frame pushed by SaveRegisters
/////////////////////////////////////////////////////////////////////

.macro RestoreRegisters

    // restore registers and return
    ldp	q0, q1, [sp, #(0*16)]
    ldp	q2, q3, [sp, #(2*16)]
    ldp	q4, q5, [sp, #(4*16)]
    ldp	q6, q7, [sp, #(6*16)]
    ldp	x0, x1, [sp, #(8*16+0*8)]
    ldp	x2, x3, [sp, #(8*16+2*8)]
    ldp	x4, x5, [sp, #(8*16+4*8)]
    ldp	x6, x7, [sp, #(8*16+6*8)]
    ldr	x8,     [sp, #(8*16+8*8)]

    mov	sp, fp
    ldp	fp, lr, [sp], #16

.endmacro

//////////////////////////////////////////////////////////////////////
//
// The Callback!
//
// Save all argument registers, call the checker method, restore
// registers and jump into the target function (which is returned
// by the checker method)
//
//////////////////////////////////////////////////////////////////////

ENTRY messengerHookAsm

    SaveRegisters                   // Save parameter registers
    bl _barbWireTestFunction        // Call function hook
    mov x9, x0                      // Save the return register
    RestoreRegisters                // Restore parameter registers

    cbz x9, YAssertationFailed      // If assert, return
    br x9                           // Otherwise call original function

YAssertationFailed:
    ret

END_ENTRY messengerHookAsm

#endif