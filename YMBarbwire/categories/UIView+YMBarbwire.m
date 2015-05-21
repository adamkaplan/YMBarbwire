//
//  UIView+Barbwire.m
//  Barbwire
//
//  Created by Adam Kaplan on 12/23/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "UIView+YMBarbwire.h"
#import "YMBarbwire.h"
#import <objc/runtime.h>

static NSArray *prefixBlacklist;

@implementation UIView (Barbwire)

+ (void)wireAll {
    if (!prefixBlacklist) {
        prefixBlacklist = @[ @"alloc", @"init",
                             @"description",
                             @"retain", @"release", @"autorelease" ];
    }
    
    NSThread *mainThread = [NSThread mainThread];
    unsigned int count;
    char returnTypeEncoding;
    Method *methods = class_copyMethodList(self, &count);
    
    for (int index = 0; index < count; index++) {
        Method method = methods[index];
        SEL selector = method_getName(method);
        const char *name = sel_getName(selector);
        
        if (strchr(name, '_')) { // skip methods with underscores.
            continue;
        }
        
        // Skip methods returning that can return values that do not fit within a 64-bit register;
        // that is, methods that could compile into the stret (structure) or fpret (function ptr)
        // return variants of objc_msgSend.
        //
        // Note: this can be worked around in the future, by reverse engineering Clang's logic for
        //      deciding when to use the specialized function calling conventions.
        returnTypeEncoding = '\0';
        method_getReturnType(method, &returnTypeEncoding, 1);
        if (returnTypeEncoding == '['           // Array
            || returnTypeEncoding == '{'        // Struct
            || returnTypeEncoding == '('        // Union
            || returnTypeEncoding == '?') {     // Function pointer "among other things" (?)
            NSLog(@"Skipping method: %@", NSStringFromSelector(selector));
            continue;
        }
        
        // Skip methods with disallowed prefixes
        size_t length = strlen(name);
        BOOL skip = NO;
        
        for (NSString *prefix in prefixBlacklist) {
            if (prefix.length <= length && 0 == strncmp(prefix.UTF8String, name, prefix.length)) {
                skip = YES;
                break;
            }
        }
        
        if (skip) {
            continue;
        }
        
        [YMBarbwire wireInstancesOfClass:self selector:selector thread:mainThread];
    }
    
    free(methods);
}

@end
