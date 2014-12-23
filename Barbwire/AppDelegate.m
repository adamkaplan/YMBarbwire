//
//  AppDelegate.m
//  Barbwire
//
//  Created by Adam Kaplan on 12/18/14.
//  Copyright (c) 2014 Adam Kaplan. All rights reserved.
//

#import "AppDelegate.h"
#import "NSObject+Barbwire.h"
#import "UIView+Barbwire.h"
#import <CoreGraphics/CoreGraphics.h>

static dispatch_queue_t queue;

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
    queue = dispatch_queue_create("Queue", DISPATCH_QUEUE_CONCURRENT);

    UIView *v = [[UIView alloc] init];
    [UIView wireAll];
    
    dispatch_async(queue, ^{
        v.frame = CGRectZero;
        //v.hidden = YES; // FAIL
    });
    return YES;
    
    // Manually test....
    target = [Test new];
    //[target wire:@selector(test) thread:[NSThread mainThread]];
    //[target wire:@selector(description) thread:[NSThread mainThread]];
    //[target wire:@selector(description) queue:dispatch_get_main_queue()];
    [Test wire:@selector(pop:) queue:dispatch_get_main_queue()];
    [Test wire:@selector(description) queue:dispatch_get_main_queue()];

    Test *testBg = [Test new];
    [testBg wire:@selector(test) queue:queue];
    //[Barbwire wire:testBg selector:@selector(pop:) queue:queue]; // FAIL
    
    
    [Test pop:1]; // PASS
    [target test]; // PASS
    //[testBg test]; // FAIL
    NSLog(@"Pass desc: %@", [Test description]); // PASS
    
    [NSThread detachNewThreadSelector:@selector(die) toTarget:self withObject:nil];
    return YES;
}

- (void)die {
    [NSThread sleepForTimeInterval:2.5];
    
    //[target test]; // FAIL

    //[Test pop:20]; // FAIL
    
    NSLog(@"Pass desc: %@", [target description]); // PASS
    
    NSLog(@"Fail desc: %@", [Test description]); // FAIL
}

@end
