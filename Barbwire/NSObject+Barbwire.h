//
//  NSObject+Barbwire.h
//  Barbwire
//
//  Created by Adam Kaplan on 12/23/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BarbwireClass)

+ (void)wire:(SEL)selector thread:(NSThread *)thread;

+ (void)wire:(SEL)selector queue:(dispatch_queue_t)queue;

@end

@interface NSObject (BarbwireInstance)

- (void)wire:(SEL)selector thread:(NSThread *)thread;

- (void)wire:(SEL)selector queue:(dispatch_queue_t)queue;

@end
