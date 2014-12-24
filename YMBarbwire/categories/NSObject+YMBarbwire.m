//
//  NSObject+Barbwire.m
//  Barbwire
//
//  Created by Adam Kaplan on 12/23/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "NSObject+YMBarbwire.h"
#import "YMBarbwire.h"

@implementation NSObject (YMBarbwire)

+ (void)wire:(SEL)selector thread:(NSThread *)thread {
    [YMBarbwire wire:self selector:selector thread:thread];
}

+ (void)wire:(SEL)selector queue:(dispatch_queue_t)queue {
    [YMBarbwire wire:self selector:selector queue:queue];
}

@end

@implementation NSObject (BarbwireInstance)

- (void)wire:(SEL)selector thread:(NSThread *)thread {
    [YMBarbwire wire:self selector:selector thread:thread];
}

- (void)wire:(SEL)selector queue:(dispatch_queue_t)queue {
    [YMBarbwire wire:self selector:selector queue:queue];
}

@end
