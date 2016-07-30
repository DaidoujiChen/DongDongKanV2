//
//  AppDelegate.m
//  DongDongKanV2
//
//  Created by DaidoujiChen on 2016/7/28.
//  Copyright © 2016年 DaidoujiChen. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.window.contentViewController = [MainViewController new];
}

@end
