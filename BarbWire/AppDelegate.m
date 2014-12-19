//
//  AppDelegate.m
//  BarbWire
//
//  Created by Adam Kaplan on 12/18/14.
//  Copyright (c) 2014 Adam Kaplan. All rights reserved.
//

#import "AppDelegate.h"
#import <objc/runtime.h>

#if OBJC_OLD_DISPATCH_PROTOTYPES
typedef id(*ObjCDispatchSignature)(id,SEL,...);
#else
typedef void(*ObjCDispatchSignature)(void);
#endif

static IMP imp;
static const void *AllowedThreadKey = @"AllowedThreadKey";

extern id callbackAssemblyMonster(id, SEL, ...);

void* testMethod(id me, SEL sel, ...);
void* testMethod(id me, SEL sel, ...) {
    
    NSThread *allowedThread = objc_getAssociatedObject(me, AllowedThreadKey);
    if (allowedThread != [NSThread currentThread]) {
        NSCAssert(false, @"-[%@ %@] must be called on thread %@, not %@",
                  me, NSStringFromSelector(sel), allowedThread, [NSThread currentThread]);
        return nil;
    }
    else {
        NSValue *fpointer = objc_getAssociatedObject(me, sel);
        NSLog(@"%p", [fpointer pointerValue]);
        return [fpointer pointerValue];
    }
}

@implementation AppDelegate

+ (id)foo:(int)num {
    NSLog(@"In foo with %d", num);
    return nil;
}

+ (void)load {
    // Store allowed thread
    objc_setAssociatedObject(self, AllowedThreadKey, [NSThread currentThread], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // Store pointer to the original function
    SEL selector = @selector(foo:);
    Method method = class_getClassMethod(self, selector);
    imp = method_getImplementation(method);
    
    NSValue *fpointer = [NSValue valueWithPointer:imp];
    objc_setAssociatedObject(self, selector, fpointer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // Swizzle in the verifier method
    method_setImplementation(method, (ObjCDispatchSignature)callbackAssemblyMonster);
    
    // Manually test....
    [self foo:6];
    
    [NSThread detachNewThreadSelector:@selector(die) toTarget:self withObject:nil];
}

+ (void)die {
    [NSThread sleepForTimeInterval:2.5];
    [self foo:0xbadf00d];
}

@end
