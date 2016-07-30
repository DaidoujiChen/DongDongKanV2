//
//  PositionManager.h
//  DongDongKanV2
//
//  Created by DaidoujiChen on 2016/7/31.
//  Copyright © 2016年 DaidoujiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PositionManager : NSObject

+ (void)setFrame:(NSRect)frame forKey:(NSString *)key;
+ (NSRect)frameForKey:(NSString *)key;

@end
