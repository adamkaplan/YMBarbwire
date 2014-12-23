//
//  Intercept.h
//  Barbwire
//
//  Created by Adam Kaplan on 12/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

// Excluding unused arguments & bypassing ARC yields a huge reduction in asm prologue overhead
void* barbWireTestFunction(__unsafe_unretained id me, SEL sel/*, ...*/);