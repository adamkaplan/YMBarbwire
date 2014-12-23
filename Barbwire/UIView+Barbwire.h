//
//  UIView+Barbwire.h
//  Barbwire
//
//  Created by Adam Kaplan on 12/23/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Barbwire)

// Guard all methods of UIView, ensuring that they are accessed from the application's main thread.
// Methods of superclasses of UIView that are not overridden by UIView are not included.
//
// UIView documentation (as of Dec 2014) states the following:
//
// "You should always call the methods of the UIView class from code running in the main thread
//  of your application. The only time this may not be strictly necessary is when creating the view
//  object itself but all other manipulations should occur on the main thread."
//
// For this reason, all methods on UIView should be completely covered. Although an argument can
// be made for not guarding getters, in reality the black-box implementation of a getter may include
// code which mutates internal state.
//
// This method only needs to be called one time to protect all existing and future UIView instances.
//
+ (void)wireAll;

@end
