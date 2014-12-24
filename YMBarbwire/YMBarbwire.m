//
//  Barbwire.m
//  Barbwire
//
//  Created by Adam Kaplan on 12/22/14.
//  Copyright (c) 2014 Adam Kaplan. All rights reserved.
//

#import "YMBarbwire.h"
#import "YMBarbConfig.h"

#import <objc/runtime.h>


//////////////////////////////////////////////////////////////////////
#pragma mark - C Functions
//////////////////////////////////////////////////////////////////////

extern id messengerHookAsm(id, SEL, ...);

//////////////////////////////////////////////////////////////////////
// Barbwire Implementations
//////////////////////////////////////////////////////////////////////

@implementation YMBarbwire

#pragma mark - Public

+ (void)wire:(id)target selector:(SEL)selector thread:(NSThread *)thread {
    [self p_wire:target selector:selector thread:thread queue:nil modifyMetaClass:YES];
}

+ (void)wire:(id)target selector:(SEL)selector queue:(dispatch_queue_t)queue {
    [self p_wire:target selector:selector thread:nil queue:queue modifyMetaClass:YES];
}

+ (void)wireInstancesOfClass:(Class)target selector:(SEL)selector thread:(NSThread *)thread {
    [self p_wire:target selector:selector thread:thread queue:nil modifyMetaClass:NO];
}

#pragma mark - Private

+ (void)p_wire:(id)target selector:(SEL)selector thread:(NSThread *)thread queue:(dispatch_queue_t)queue modifyMetaClass:(BOOL)modifyMetaClass {
    
    // Need a reference to the original method for this instance to be verified.
    // If target is a class, it's "class" will be itself such that [obj class] == [[obj class] class]
    //      This behavior is used to determine if a class or an instance was passed into target
    // If a class was passed in, operate on it's "meta class" instead. A class is actually an instance
    //      of it's meta class. Therefore a class method is an instance method of some meta class.
    Class clazz = [target class];
    if (modifyMetaClass && clazz == target && !class_isMetaClass(clazz)) {
        clazz = objc_getMetaClass(class_getName(clazz));
    }
    
    Method method = class_getInstanceMethod(clazz, selector);
    if (!method) {
        char prefix = clazz == target ? '+' : '-';
        NSAssert(false, @"Barbwire cannot wire method that does not exist %c[%@ %@]", prefix, clazz, NSStringFromSelector(selector));
    }
    
    // Swizzle in the verifier method
    IMP imp = method_getImplementation(method);
    if (imp != (IMP)messengerHookAsm) {
        IMP replacedImp = class_replaceMethod(clazz, selector, (IMP)messengerHookAsm, method_getTypeEncoding(method));
        if (replacedImp) {
            // If a new method was added (via subclassing), imp is NULL. Chain to the superclass' method.
            imp = replacedImp;
        }
    }
    
    // Associate the proper barbwire configuration
    YMBarbConfig *config = objc_getAssociatedObject(target, selector);
    if (!config) {
        config = [YMBarbConfig new];
        objc_setAssociatedObject(target, selector, config, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    // Easy to blindly set both. One should always be NULL.
    config->threadPointer = thread;
    config->queuePointer = queue;
    config->functionImp = imp;
}

@end
