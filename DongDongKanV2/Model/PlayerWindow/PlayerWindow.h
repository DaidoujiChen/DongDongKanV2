//
//  PlayerWindow.h
//  DongDongKanV2
//
//  Created by DaidoujiChen on 2016/7/30.
//  Copyright © 2016年 DaidoujiChen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol PlayerWindowDelegate;

@interface PlayerWindow : NSWindow <NSWindowDelegate>

@property (nonatomic, weak) id<PlayerWindowDelegate> keyboardPressDelegate;

- (instancetype)initWithFrame:(NSRect)frame;
- (void)playFromURL:(NSURL *)url;

@end

@protocol PlayerWindowDelegate <NSObject>

- (void)keyboardPress:(NSString *)pressKey;

@end
