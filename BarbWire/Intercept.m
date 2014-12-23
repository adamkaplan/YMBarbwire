//
//  Intercept.c
//  BarbWire
//
//  Created by Adam Kaplan on 12/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "Intercept.h"
#import "BarbwireConfig.h"
#import <objc/runtime.h>

/*
 This file should be compiled with ARC-disabled for performance reasons.
 */

#define __BW_PRAGMA_PUSH_NO_WARNINGS    _Pragma("clang diagnostic push") _Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"")
#define __BW_PRAGMA_POP_NO_WARNINGS     _Pragma("clang diagnostic pop")


void* barbWireTestFunction(__unsafe_unretained id self, __unsafe_unretained SEL _cmd/*, ...*/) {
    
    // Objects cannot be disposed of between objc_msgSend and this method
    __unsafe_unretained BarbwireConfig *config = objc_getAssociatedObject(self, BarbWireConfigKey);
    if (!config) {
        return nil;
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
    
    return nil;
}
