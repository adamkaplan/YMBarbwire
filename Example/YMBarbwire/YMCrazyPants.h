//
//  YMCrazyPants.h
//  YMBarbwire
//
//  Created by Adam Kaplan on 2/24/15.
//  Copyright (c) 2015 adamkaplan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct _struct_t {
    uint64_t a;
    uint64_t b;
    uint64_t c;
    uint64_t d;
    uint64_t e;
    uint64_t f;
} struct_t;

typedef union _union_t {
    int i;
    struct {
        unsigned short a;
        unsigned short b;
    };
    char c[4];
    //unsigned int bit_field_t : 8;
} union_t;

//unsigned int bit_field_t : 8;

@interface YMCrazyPants : NSObject

- (char)charRet;
- (int)intRet;
- (short)shortRet;
- (long)longRet;
- (long long)longLongRet;
- (unsigned char)unsignedCharRet;
- (unsigned int)unsignedIntRet;
- (unsigned short)unsignedShortRet;
- (unsigned long)unsignedLongRet;
- (unsigned long long)unsignedLongLongRet;
- (float)floatRet;
- (double)doubleRet;
- (bool)boolRet;
- (void)voidRet:(id)s;
- (char *)charPointerRet;
- (id)idRet;
- (Class)classRet;
- (SEL)selectorRet;
- (int **)arrayRet; // int[]?
- (struct_t)structRet;
- (union_t)unionRet;
/* A bit field of num bits ???? */
- (long *)typePointerRet;
- (char(*)(int))fpRet;

@end
