//
//  NSObject+Barbwire.m
//  Barbwire
//
//  Created by Adam Kaplan on 12/23/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "NSObject+Barbwire.h"
#import "Barbwire.h"

@implementation NSObject (BarbwireClass)

+ (void)wire:(SEL)selector thread:(NSThread *)thread {
    [Barbwire wire:self selector:selector thread:thread];
}

+ (void)wire:(SEL)selector queue:(dispatch_queue_t)queue {
    [Barbwire wire:self selector:selector queue:queue];
}

@end

@implementation NSObject (BarbwireInstance)

- (void)wire:(SEL)selector thread:(NSThread *)thread {
    [Barbwire wire:self selector:selector thread:thread];
}

- (void)wire:(SEL)selector queue:(dispatch_queue_t)queue {
    [Barbwire wire:self selector:selector queue:queue];
}

@end
