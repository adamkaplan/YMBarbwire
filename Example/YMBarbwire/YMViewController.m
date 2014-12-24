//
//  YMViewController.m
//  YMBarbwire
//
//  Created by adamkaplan on 12/24/2014.
//  Copyright (c) 2014 adamkaplan. All rights reserved.
//

#import "YMViewController.h"
#import <YMBarbwire/UIView+YMBarbwire.h>

@interface YMViewController () {
    dispatch_queue_t _queue;
}
@end

@implementation YMViewController

- (void)testViewBarb {
    [UIView wireAll];
    
    dispatch_async(_queue, ^{
        NSAssert(![NSThread isMainThread], @"Sometimes GCD picks the main thread");
        self.view.frame = CGRectZero; // FAIL
    });
    
    //[NSThread detachNewThreadSelector:@selector(printDesc) toTarget:self withObject:nil];
}

- (void)printDesc {
    NSLog(@"View %ld", (long)self.view.tag);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _queue = dispatch_queue_create("Queue", DISPATCH_QUEUE_CONCURRENT);
    
    [self testViewBarb];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
