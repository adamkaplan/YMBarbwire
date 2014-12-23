//
//  UIView+Barbwire.m
//  Barbwire
//
//  Created by Adam Kaplan on 12/23/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "UIView+Barbwire.h"
#import "Barbwire.h"
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
    Method *methods = class_copyMethodList(self, &count);
    
    for (int index = 0; index < count; index++) {
        Method method = methods[index];
        SEL selector = method_getName(method);
        const char *name = sel_getName(selector);
        
        if (*name == '_') { // skip methods that begin with an underscore such as "_internalInit"
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
        
        [Barbwire wireInstancesOfClass:self selector:selector thread:mainThread];
    }
    
    free(methods);
}

@end
