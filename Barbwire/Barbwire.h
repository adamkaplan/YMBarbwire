//
//  Barbwire.h
//  Barbwire
//
//  Created by Adam Kaplan on 12/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Barbwire : NSObject

+ (void)wire:(id)target selector:(SEL)selector thread:(NSThread *)thread;

+ (void)wire:(id)target selector:(SEL)selector queue:(dispatch_queue_t)queue;

@end
