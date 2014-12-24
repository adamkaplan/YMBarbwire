//
//  YMBarbwire.h
//  YMBarbwire
//
//  Created by Adam Kaplan on 12/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMBarbwire : NSObject

// Add barbwire to an object. If the object is a Class, only class methods may be guarded
// Prefer using the `queue` version of this method. Queues are generally preferable to threads.
+ (void)wire:(id)target selector:(SEL)selector thread:(NSThread *)thread;

+ (void)wire:(id)target selector:(SEL)selector queue:(dispatch_queue_t)queue;

// Guard all instances – current and future – of the given class.
// Use this method to directly modify the class object. This would be used in edge cases like UIView,
// where every instance has the same exact config (main thread only). It should be unusual to use
// this method directly.
+ (void)wireInstancesOfClass:(Class)target selector:(SEL)selector thread:(NSThread *)thread;

@end
