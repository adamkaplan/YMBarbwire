//
//  AppDelegate.m
//  BarbWire
//
//  Created by Adam Kaplan on 12/18/14.
//  Copyright (c) 2014 Adam Kaplan. All rights reserved.
//

#import "AppDelegate.h"
#import "Barbwire.h"

@implementation Test
- (void)test {
    NSLog(@"I'm here, %@", self);
}
- (NSString *)description {
    return @"I am";
}
@end
static Test *target;

//////////////////////////////////////////////////////////////////////
// Class Implementation
//////////////////////////////////////////////////////////////////////
#pragma mark - Implementation

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Manually test....
    target = [Test new];
    [Barbwire wire:target selector:@selector(test) thread:[NSThread mainThread]];
    
    //NSLog(@"%@", target);
    [target test];
    
    [NSThread detachNewThreadSelector:@selector(die) toTarget:self withObject:nil];
    
    return YES;
}

- (void)die {
    [NSThread sleepForTimeInterval:2.5];
    //[self foo:0xbadf00d];
    [target test];
    //NSLog(@"%@", self.target);
}

@end
