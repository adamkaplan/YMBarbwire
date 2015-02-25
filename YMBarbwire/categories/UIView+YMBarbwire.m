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
        
        returnTypeEncoding = '\0';
        method_getReturnType(method, &returnTypeEncoding, 1);
        if (returnTypeEncoding == 'v') {
            NSLog(@"Method: %@", NSStringFromSelector(selector));
        }
        //if (returnTypeEncoding == '?' || returnTypeEncoding == '{') {
            if (false
//               returnTypeEncoding == 'c'
//            || returnTypeEncoding == 'i'
//            || returnTypeEncoding == 's'
//            || returnTypeEncoding == 'l'
//            || returnTypeEncoding == 'q'
//            || returnTypeEncoding == 'C'
//            || returnTypeEncoding == 'I'
//            || returnTypeEncoding == 'S'
//            || returnTypeEncoding == 'L'
//            || returnTypeEncoding == 'Q'
//            || returnTypeEncoding == 'f'
//            || returnTypeEncoding == 'd'
//            || returnTypeEncoding == 'B'
//            || returnTypeEncoding == 'v' // <--- no UI
//            || returnTypeEncoding == '*'
//            || returnTypeEncoding == '@'
//            || returnTypeEncoding == '#'    // stret?
//            || returnTypeEncoding == ':'    // stret?
//            || returnTypeEncoding == '['    // stret?
//            || returnTypeEncoding == '{'    // stret
//            || returnTypeEncoding == '('    // stret
//            || returnTypeEncoding == 'bs'
//            || returnTypeEncoding == '^'
//            || returnTypeEncoding == '?'  // fpret
        ) { continue; }
        
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
