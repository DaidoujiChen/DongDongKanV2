//
//  RuntimeHelper.m
//  DaiSlicer
//
//  Created by DaidoujiChen on 2016/7/1.
//  Copyright © 2016年 DaidoujiChen. All rights reserved.
//

#import "RuntimeHelper.h"
#import <objc/runtime.h>

@implementation RuntimeHelper

#pragma mark - Private Class Method

+ (void)listMethodsIn:(Class)aClass isInstance:(BOOL)isInstance {
    Class targetClass;
    if (isInstance) {
        targetClass = aClass;
    }
    else {
        targetClass = objc_getMetaClass(class_getName(aClass));
    }
    
    unsigned int methodCount;
    Method *methodList = class_copyMethodList(targetClass, &methodCount);
    for (unsigned int i = 0; i < methodCount; i++) {
        if (isInstance) {
            NSLog(@"%s Instance : %s, %s, %p", class_getName(aClass), sel_getName(method_getName(methodList[i])), method_getTypeEncoding(methodList[i]), method_getImplementation(methodList[i]));
        }
        else {
            NSLog(@"%s Class : %s, %s, %p", class_getName(aClass), sel_getName(method_getName(methodList[i])), method_getTypeEncoding(methodList[i]), method_getImplementation(methodList[i]));
        }
    }
    free(methodList);
}

#pragma mark - Class Method

+ (void)methodsIn:(id)obj {
    Class aClass;
    if (object_isClass(obj)) {
        aClass = obj;
    }
    else {
        aClass = object_getClass(obj);
    }
    
    [self listMethodsIn:aClass isInstance:YES];
    [self listMethodsIn:aClass isInstance:NO];
}

@end
