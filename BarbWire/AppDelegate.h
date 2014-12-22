//
//  AppDelegate.h
//  BarbWire
//
//  Created by Adam Kaplan on 12/18/14.
//  Copyright (c) 2014 Adam Kaplan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Test : NSObject
- (NSString *)description;
- (void)test;
@end

@interface AppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic) Test *target;

@end
