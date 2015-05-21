//
//  YMBarb.h
//  YMBarbwire
//
//  Created by Adam Kaplan on 12/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

// Excluding unused arguments & bypassing ARC yields a huge reduction in asm prologue overhead

void* barbwire_msgSend(__unsafe_unretained id me, SEL sel/*, ...*/);

//void* barbwire_msgSend_stret(void *st_addr, __unsafe_unretained id me, SEL sel/*, ...*/);

//void* barbwire_msgSend_fpret(void *fp, __unsafe_unretained id me, SEL sel/*, ...*/);
