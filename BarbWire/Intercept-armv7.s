//
//  AppDelegate-armv7.s
//  BarbWire
//
//  Created by Adam Kaplan on 12/19/14.
//  Copyright (c) 2014 Adam Kaplan. All rights reserved.
//
#ifdef __arm__
	
#include <arm/arch.h>

#ifndef _ARM_ARCH_7
#   error requires armv7
#endif

.syntax unified

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
	.thumb
	.globl    _$0
	.thumb_func
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
    stmfd	sp!, {r0-r3,lr}         // Push return & parameter registers onto the stack
    blx _barbWireTestFunction       // Call test function hook
    mov r12, r0                     // Save the return value
    ldmfd	sp!, {r0-r3,lr}         // Pop return & parameter registers from the stack

    cbz r0, YAssertationFailed      // If assert, simply return from here (already dead)
    //bkpt 1
    bx r12                          // Call original function

YAssertationFailed:
    bx lr

END_ENTRY messengerHookAsm

#endif