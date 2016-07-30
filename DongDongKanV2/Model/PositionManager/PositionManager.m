//
//  PositionManager.m
//  DongDongKanV2
//
//  Created by DaidoujiChen on 2016/7/31.
//  Copyright © 2016年 DaidoujiChen. All rights reserved.
//

#import "PositionManager.h"

@implementation PositionManager

+ (void)setFrame:(NSRect)frame forKey:(NSString *)key {
    NSValue *value = [NSValue valueWithRect:frame];
    NSData *archiverData = [NSKeyedArchiver archivedDataWithRootObject:value];
    [[NSUserDefaults standardUserDefaults] setObject:archiverData forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSRect)frameForKey:(NSString *)key {
    NSData *archiverData = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (archiverData) {
        NSValue *value = [NSKeyedUnarchiver unarchiveObjectWithData:archiverData];
        return value.rectValue;
    }
    else {
        return NSZeroRect;
    }
}

@end
