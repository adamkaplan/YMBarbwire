//
//  Barbwire.m
//  Barbwire
//
//  Created by Adam Kaplan on 12/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "Barbwire.h"
#import "BarbwireConfig.h"
#import <objc/runtime.h>
#import <pthread/pthread.h>

//////////////////////////////////////////////////////////////////////
// Data Definitions
//////////////////////////////////////////////////////////////////////
#pragma mark - Global Definitions

#if OBJC_OLD_DISPATCH_PROTOTYPES
typedef id(*ObjCDispatchSignature)(id,SEL,...);
#else
typedef void(*ObjCDispatchSignature)(void);
#endif

//////////////////////////////////////////////////////////////////////
// C-Function Prototypes
//////////////////////////////////////////////////////////////////////
#pragma mark - C Functions

extern id messengerHookAsm(id, SEL, ...);

//////////////////////////////////////////////////////////////////////
// Barbwire Implementations
//////////////////////////////////////////////////////////////////////

@implementation Barbwire

#pragma mark - Public

+ (void)wire:(id)target thread:(NSThread *)thread {
    
}

+ (void)wire:(id)target queue:(dispatch_queue_t)queue {
    
}

+ (void)wire:(id)target selector:(SEL)selector thread:(NSThread *)thread {
    [self p_wire:target selector:selector thread:thread queue:nil];
}

+ (void)wire:(id)target selector:(SEL)selector queue:(dispatch_queue_t)queue {
    [self p_wire:target selector:selector thread:nil queue:queue];
}

#pragma mark - Private

+ (void)p_wire:(id)target selector:(SEL)selector thread:(NSThread *)thread queue:(dispatch_queue_t)queue {
    Class clazz = object_getClass(target);

    // Get a reference to the original method for this instance to be verified
    //Method method = class_getClassMethod(self, selector); // Handle class methods? They seem to work.
    Method method = class_getInstanceMethod(clazz, selector);
    if (!method) {
        char prefix = [target class] == target ? '+' : '-';
        NSAssert(false, @"Barbwire cannot wire method that does not exist %c[%@ %@]", prefix, [target class], NSStringFromSelector(selector));
    }
    
    // Swizzle in the verifier method
    IMP imp = class_replaceMethod(clazz, selector, (ObjCDispatchSignature)messengerHookAsm, method_getTypeEncoding(method));
    if (!imp) {
        // If a new method was added (via subclassing), imp is NULL. Use superclass method as functionImp.
        imp = method_getImplementation(method);
    }
    
    BarbwireConfig *config = objc_getAssociatedObject(target, selector);
    if (!config) {
        config = [BarbwireConfig new];
        objc_setAssociatedObject(target, selector, config, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    // Easy to blindly set both. One should always be NULL.
    config->threadPointer = thread;
    config->queuePointer = queue;
    config->functionImp = imp;
}

@end
