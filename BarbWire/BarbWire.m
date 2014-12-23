//
//  BarbWire.m
//  BarbWire
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

+ (void)wire:(id<NSObject>)target selector:(SEL)selector thread:(NSThread *)thread {
    
    BarbwireConfig *config = [BarbwireConfig new];
    config->threadPointer = thread;

    [self p_wire:target selector:selector config:config];
}

+ (void)wire:(id<NSObject>)target selector:(SEL)selector queue:(dispatch_queue_t)queue {

    BarbwireConfig *config = [BarbwireConfig new];
    config->queuePointer = queue;
    
    [self p_wire:target selector:selector config:config];
}

#pragma mark - Private

+ (void)p_wire:(id<NSObject>)target selector:(SEL)selector config:(BarbwireConfig *)config {
    Class clazz = object_getClass(target);
    
    // Get a reference to the original method for this instance to be verified
    //Method method = class_getClassMethod(self, selector); // Handle class methods?
    Method method = class_getInstanceMethod(clazz, selector);
    if (!method) {
        return;
    }
    
    // Swizzle in the verifier method
    IMP imp = class_replaceMethod(clazz, selector, (ObjCDispatchSignature)messengerHookAsm, method_getTypeEncoding(method));
    if (!imp) {
        // If a new method was added (via subclassing), imp is NULL. Use superclass method as functionImp.
        imp = method_getImplementation(method);
    }
    
    // Store allowed barb wire configuration into this object
    config->functionImp = imp;
    
    objc_setAssociatedObject(target, BarbWireConfigKey, config, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
