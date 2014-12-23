//
//  BarbwireConfig.h
//  Barbwire
//
//  Created by Adam Kaplan on 12/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarbwireConfig : NSObject {
    @package
    __unsafe_unretained dispatch_queue_t queuePointer;
    __unsafe_unretained NSThread *threadPointer;
    IMP functionImp;
}

@end
