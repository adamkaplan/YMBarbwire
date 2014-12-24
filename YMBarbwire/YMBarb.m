//
//  YMBarb.m
//  YMBarbwire
//
//  Created by Adam Kaplan on 12/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "YMBarb.h"
#import "YMBarbConfig.h"
#import <objc/runtime.h>

/*
 This file should be compiled with ARC-disabled for performance reasons.
 */

#define __BW_PRAGMA_PUSH_NO_WARNINGS    _Pragma("clang diagnostic push") _Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"")
#define __BW_PRAGMA_POP_NO_WARNINGS     _Pragma("clang diagnostic pop")


void* barbWireTestFunction(__unsafe_unretained id self, SEL _cmd/*, ...*/) {

    __unsafe_unretained YMBarbConfig *config = objc_getAssociatedObject(self, _cmd);
    if (!config) {
        // If the object instance didn't have any config, check it's class instance.  "wireAll"
        // impls will store the global configs in the class instance itself. Can this cause
        // class vs instance selector conflicts? If so, can we fix?
        __unsafe_unretained Class clazz = object_getClass(self);
        if (clazz != self) {
            config = objc_getAssociatedObject(clazz, _cmd);
            if (!config) {
                return nil;
            }
        }
    }
    
    if (config->threadPointer) {
        NSAssert(config->threadPointer == [NSThread currentThread], // should be equals:?
                 @"-[%s %s] must be called on thread %@ (was %@)",
                 object_getClassName(self), sel_getName(_cmd), config->threadPointer, [NSThread currentThread]);
        
        return config->functionImp;
    }
    
    if (config->queuePointer) {
        __BW_PRAGMA_PUSH_NO_WARNINGS // ignore dispatch_get_current_queue() deprecation (allowed for debugging per docs)
        NSAssert(config->queuePointer == dispatch_get_current_queue(),
                 @"-[%s %s] must be called on queue %@ (was %@)",
                 object_getClassName(self), sel_getName(_cmd), config->queuePointer, dispatch_get_current_queue());
        __BW_PRAGMA_POP_NO_WARNINGS
        
        return config->functionImp;
    }
    
    return config->functionImp;
}
