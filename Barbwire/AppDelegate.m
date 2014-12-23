//
//  AppDelegate.m
//  Barbwire
//
//  Created by Adam Kaplan on 12/18/14.
//  Copyright (c) 2014 Adam Kaplan. All rights reserved.
//

#import "AppDelegate.h"
#import "Barbwire.h"


@interface Test : NSObject
+ (BOOL)pop:(int)count;
- (void)test;
@end

@implementation Test
+ (BOOL)pop:(int)count {
    NSLog(@"Pop %d", count);
    return 0;
}
- (void)test {
    NSLog(@"Test: %@", self);
}
/*
- (NSString *)description {
    return [@"(Custom Description) " stringByAppendingString:[super description]];
}
 */
@end

static Test *target;

#
#pragma mark - Implementation
#

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Manually test....
    target = [Test new];
    //[Barbwire wire:target selector:@selector(test) thread:[NSThread mainThread]];
    //[Barbwire wire:target selector:@selector(description) thread:[NSThread mainThread]];
    [Barbwire wire:target selector:@selector(description) queue:dispatch_get_main_queue()];
    [Barbwire wire:[Test class] selector:@selector(pop:) queue:dispatch_get_main_queue()];
    [Barbwire wire:[Test class] selector:@selector(description) queue:dispatch_get_main_queue()];
    
    [target test]; // PASS
    
    [Test pop:1]; // PASS
    
    NSLog(@"Pass desc: %@", [Test description]); // PASS
    
    [NSThread detachNewThreadSelector:@selector(die) toTarget:self withObject:nil];
    
    return YES;
}

- (void)die {
    [NSThread sleepForTimeInterval:2.5];
    
    //[target test]; // FAIL

    //[Test pop:20]; // FAIL
    
    NSLog(@"Fail desc: %@", [Test description]); // FAIL
}

@end
