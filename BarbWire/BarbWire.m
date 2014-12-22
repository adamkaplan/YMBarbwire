//
//  BarbWire.m
//  BarbWire
//
//  Created by Adam Kaplan on 12/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "Barbwire.h"
#import <objc/runtime.h>

//////////////////////////////////////////////////////////////////////
// Data Definitions
//////////////////////////////////////////////////////////////////////
#pragma mark - Global Definitions

#if OBJC_OLD_DISPATCH_PROTOTYPES
typedef id(*ObjCDispatchSignature)(id,SEL,...);
#else
typedef void(*ObjCDispatchSignature)(void);
#endif

/* A basic struct would be more efficient, but we'd need to override dealloc to free it... and that is not fun.
struct BarbwireConfig {
    __unsafe_unretained dispatch_queue_t queuePointer;
    __unsafe_unretained NSThread *threadPointer;
    IMP functionImp;
    IMP destructorImp;
};
typedef struct BarbwireConfig BarbwireConfig;
*/
@interface BarbwireConfig : NSObject {
    @package
    __unsafe_unretained dispatch_queue_t queuePointer;
    __unsafe_unretained NSThread *threadPointer;
    IMP functionImp;
    IMP destructorImp;
}
@end

@implementation BarbwireConfig
@end

//////////////////////////////////////////////////////////////////////
// Static Variables
//////////////////////////////////////////////////////////////////////

static const void *BarbWireConfigKey = @"BarbWireConfigKey";

//////////////////////////////////////////////////////////////////////
// C-Function Prototypes
//////////////////////////////////////////////////////////////////////
#pragma mark - C Functions

extern id messengerHookAsm(id, SEL, ...);
void* barbWireTestFunction(id me, SEL sel, ...);

//////////////////////////////////////////////////////////////////////
// C-Function Implementations
//////////////////////////////////////////////////////////////////////

void* barbWireTestFunction(id me, SEL sel, ...) {
    
    // Objects cannot be disposed of between objc_msgSend and this method
    __unsafe_unretained BarbwireConfig *config = objc_getAssociatedObject(me, BarbWireConfigKey);
    if (!config) {
        return nil;
    }
    
    if (config->threadPointer != [NSThread currentThread]) {
        NSCAssert(false, @"-[%p %@] must be called on thread %@, not %@",
                  me, NSStringFromSelector(sel), config->threadPointer, [NSThread currentThread]);
        return nil;
    }
    else {
        NSLog(@"Ok! %p", config->functionImp);
        return config->functionImp;
    }
}

//////////////////////////////////////////////////////////////////////
// Barbwire Implementations
//////////////////////////////////////////////////////////////////////

@implementation Barbwire

#pragma mark - Public

+ (void)wire:(id<NSObject>)target selector:(SEL)selector thread:(NSThread *)thread {
    
    BarbwireConfig *config = [BarbwireConfig new];
    config->queuePointer = NULL;
    config->threadPointer = thread;

    [self p_wire:target selector:selector config:config];
}

+ (void)wire:(id<NSObject>)target selector:(SEL)selector queue:(dispatch_queue_t)queue {

    BarbwireConfig *config = [BarbwireConfig new];
    config->queuePointer = queue;
    config->threadPointer = NULL;
    
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
    IMP imp = method_setImplementation(method, (ObjCDispatchSignature)messengerHookAsm);
    
    // Store allowed barb wire configuration into this object
    config->functionImp = imp;
    //®NSLog(@"%p", imp);
    
    objc_setAssociatedObject(target, BarbWireConfigKey, config, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
