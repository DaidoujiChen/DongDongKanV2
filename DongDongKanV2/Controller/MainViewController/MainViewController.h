//
//  MainViewController.h
//  DongDongKanV2
//
//  Created by DaidoujiChen on 2016/7/30.
//  Copyright © 2016年 DaidoujiChen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AnimateWebView.h"

@interface MainViewController : NSViewController <NSWindowDelegate, AnimateWebViewDelegate>

- (void)storeFinalWindowsFrame;

@end
