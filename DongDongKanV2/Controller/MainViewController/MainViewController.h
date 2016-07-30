//
//  MainViewController.h
//  DongDongKanV2
//
//  Created by DaidoujiChen on 2016/7/30.
//  Copyright © 2016年 DaidoujiChen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "PlayerWindow.h"

@interface MainViewController : NSViewController <NSWindowDelegate, PlayerWindowDelegate>

- (void)storeFinalWindowsFrame;

@end
