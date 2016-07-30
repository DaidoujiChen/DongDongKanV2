//
//  AppDelegate.m
//  DongDongKanV2
//
//  Created by DaidoujiChen on 2016/7/28.
//  Copyright © 2016年 DaidoujiChen. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "PositionManager.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.window.contentViewController = [MainViewController new];
    NSRect windowFrame = [PositionManager frameForKey:@"MainWindowFrame"];
    if (!NSEqualRects(windowFrame, NSZeroRect)) {
        [self.window setFrame:windowFrame display:YES];
    }
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    MainViewController *mainViewController = (MainViewController *)self.window.contentViewController;
    [mainViewController storeFinalWindowsFrame];
}

@end
