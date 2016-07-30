//
//  PlayerWindow.h
//  DongDongKanV2
//
//  Created by DaidoujiChen on 2016/7/30.
//  Copyright © 2016年 DaidoujiChen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol PlayerWindowDelegate;

@interface PlayerWindow : NSWindow

@property (nonatomic, weak) id<PlayerWindowDelegate> keyboardPressDelegate;

@end

@protocol PlayerWindowDelegate <NSObject>

- (void)keyboardPress:(NSString *)pressKey;

@end
