//
//  YMCrazyPants.m
//  YMBarbwire
//
//  Created by Adam Kaplan on 2/24/15.
//  Copyright (c) 2015 adamkaplan. All rights reserved.
//

#import "YMCrazyPants.h"

@implementation YMCrazyPants

- (char)charRet {
    return 'A';
}

- (int)intRet {
    return INT_MAX - 0xAA;
}

- (short)shortRet {
    return SHRT_MAX - 0x2;
}

- (long)longRet {
    return LONG_MAX - 0xBB;
}

- (long long)longLongRet {
    return LONG_LONG_MAX - 0xCC;
}

- (unsigned char)unsignedCharRet {
    return 'P';
}

- (unsigned int)unsignedIntRet {
    return INT_MAX - 0xF;
}

- (unsigned short)unsignedShortRet{
    return SHRT_MAX - 0x4;
}

- (unsigned long)unsignedLongRet {
    return LONG_MAX - 0xDD;
}

- (unsigned long long)unsignedLongLongRet {
    return LONG_LONG_MAX - 0xEE;
}

- (float)floatRet {
    return MAXFLOAT;
}

- (double)doubleRet {
    return 1e295;
}

- (bool)boolRet {
    return false;
}

- (void)voidRet:(id)s {
    NSLog(@"VOID!!! %@", s);
    return;
}

- (char *)charPointerRet {
    return "ABCD";
}

- (id)idRet {
    return self;
}

- (Class)classRet {
    return [self class];
}

- (SEL)selectorRet {
    return _cmd;
}

- (int **)arrayRet {
    //int *arr = malloc(sizeof(char)*8);
    int arr[1][1];
    return arr;
}

- (struct_t)structRet {
    struct_t t = { .a = UINT64_MAX, .b = UINT64_MAX, .c = UINT64_MAX, .d = UINT64_MAX, .e = UINT64_MAX, .f = UINT64_MAX };
    return t;
}

- (union_t)unionRet {
    union_t u;// = { .i = 2, .f = 5.3, .c = 'd' };
    u.i = 256;
    return u;
}

- (long *)typePointerRet {
    long *l = malloc(sizeof(long));
    *l = 9410472;
    return l;
}

char fromA(int i) {
    return 'A'+i;
}

- (char(*)(int))fpRet {
    return fromA;
}

@end
