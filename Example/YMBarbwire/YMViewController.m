//
//  YMViewController.m
//  YMBarbwire
//
//  Created by adamkaplan on 12/24/2014.
//  Copyright (c) 2014 adamkaplan. All rights reserved.
//

#import "YMViewController.h"
#import "YMCrazyPants.h"
#import <YMBarbwire/UIView+YMBarbwire.h>
#import <YMBarbwire.h>

@interface MyCrazyPants : YMCrazyPants @end
@implementation MyCrazyPants @end

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
    return;
    
    
    
    Class class = [YMCrazyPants class];
    NSThread *thread = [NSThread currentThread];
    [YMBarbwire wireInstancesOfClass:class selector:@selector(charRet) thread:thread];
    [YMBarbwire wireInstancesOfClass:class selector:@selector(intRet) thread:thread];
    [YMBarbwire wireInstancesOfClass:class selector:@selector(shortRet) thread:thread];
    [YMBarbwire wireInstancesOfClass:class selector:@selector(longRet) thread:thread];
    [YMBarbwire wireInstancesOfClass:class selector:@selector(longLongRet) thread:thread];
    [YMBarbwire wireInstancesOfClass:class selector:@selector(unsignedCharRet) thread:thread];
    [YMBarbwire wireInstancesOfClass:class selector:@selector(unsignedIntRet) thread:thread];
    [YMBarbwire wireInstancesOfClass:class selector:@selector(unsignedShortRet) thread:thread];
    [YMBarbwire wireInstancesOfClass:class selector:@selector(unsignedLongRet) thread:thread];
    [YMBarbwire wireInstancesOfClass:class selector:@selector(unsignedLongLongRet) thread:thread];
    [YMBarbwire wireInstancesOfClass:class selector:@selector(floatRet) thread:thread];
    [YMBarbwire wireInstancesOfClass:class selector:@selector(doubleRet) thread:thread];
    [YMBarbwire wireInstancesOfClass:class selector:@selector(boolRet) thread:thread];
    [YMBarbwire wireInstancesOfClass:class selector:@selector(voidRet:) thread:thread];
    [YMBarbwire wireInstancesOfClass:class selector:@selector(charPointerRet) thread:thread];
    [YMBarbwire wireInstancesOfClass:class selector:@selector(idRet) thread:thread];
    [YMBarbwire wireInstancesOfClass:class selector:@selector(classRet) thread:thread];
    [YMBarbwire wireInstancesOfClass:class selector:@selector(selectorRet) thread:thread];
    //[YMBarbwire wireInstancesOfClass:class selector:@selector(arrayRet) thread:thread];
    [YMBarbwire wireInstancesOfClass:class selector:@selector(structRet) thread:thread];
    [YMBarbwire wireInstancesOfClass:class selector:@selector(unionRet) thread:thread];
    [YMBarbwire wireInstancesOfClass:class selector:@selector(typePointerRet) thread:thread];
    [YMBarbwire wireInstancesOfClass:class selector:@selector(fpRet) thread:thread];

    YMCrazyPants *barb = [YMCrazyPants new];
    [self runTest:barb];
    
    //YMCrazyPants *barbSubclass = [MyCrazyPants new];
    //[self runTest:barbSubclass];
}

- (void)runTest:(YMCrazyPants *)pants {

    char charVal = [pants charRet];
    NSAssert(charVal == 'A', @"char val");
    
    int intVal = [pants intRet];
    NSAssert(intVal == INT_MAX - 0xAA, @"int");
    
    short shortVal = [pants shortRet];
    NSAssert(shortVal == SHRT_MAX - 0x2, @"short");
    
    long longVal = [pants longRet];
    NSAssert(longVal == LONG_MAX - 0xBB, @"long");
    
    long long longLongVal = [pants longLongRet];
    NSAssert(longLongVal == LONG_LONG_MAX - 0xCC, @"long long");
    
    unsigned char unsignedCharVal = [pants unsignedCharRet];
    NSAssert(unsignedCharVal == 'P', @"unsigned char");
    
    unsigned int unsignedIntVal = [pants unsignedIntRet];
    NSAssert(unsignedIntVal == INT_MAX - 0xF, @"unsigned int");
    
    unsigned short unsignedShortVal = [pants unsignedShortRet];
    NSAssert(unsignedShortVal == SHRT_MAX - 0x4, @"unsigned short");
    
    unsigned long unsignedLongVal = [pants unsignedLongRet];
    NSAssert(unsignedLongVal == LONG_MAX - 0xDD, @"unsigned long");
    
    unsigned long long unsignedLongLongVal = [pants unsignedLongLongRet];
    NSAssert(unsignedLongLongVal == LONG_LONG_MAX - 0xEE, @"unsigned long long");
    
    float floatVal = [pants floatRet];
    NSAssert(floatVal == MAXFLOAT, @"float");
    
    double doubleVal = [pants doubleRet];
    NSAssert(doubleVal == 1e295, @"double");
    
    bool boolVal = [pants boolRet];
    NSAssert(!boolVal, @"bool");
    
    [pants voidRet:self];
    
    char *charPointerVal = [pants charPointerRet];
    NSAssert(0 == strcmp(charPointerVal, "ABCD"), @"char ptr");
    
    id idVal = [pants idRet];
    NSAssert(idVal == pants, @"id");
    
    Class classVal = [pants classRet];
    NSAssert(classVal == [pants class], @"class");
    
    SEL selectorVal = [pants selectorRet];
    NSAssert(selectorVal == @selector(selectorRet), @"selector");
    
    struct_t structVal = [pants structRet];
    NSAssert(structVal.a == UINT64_MAX && structVal.f == UINT64_MAX, @"struct");
    
    union_t unionVal = [pants unionRet];
    NSAssert(unionVal.i == 256 && unionVal.a == 256 && unionVal.b == 0 && unionVal.c[1] == '\x01', @"union");
    
    long *typePointerVal = [pants typePointerRet];
    NSAssert(*typePointerVal == 9410472, @"type ptr");
    
    char(*fpVal)(int) = [pants fpRet];
    NSAssert(fpVal(10) == 'A'+10, @"fun ptr");
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
