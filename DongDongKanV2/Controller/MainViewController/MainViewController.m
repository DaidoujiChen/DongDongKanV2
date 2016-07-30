//
//  MainViewController.m
//  DongDongKanV2
//
//  Created by DaidoujiChen on 2016/7/30.
//  Copyright © 2016年 DaidoujiChen. All rights reserved.
//

#import "MainViewController.h"
#import "PlayerWindow.h"
#import "PositionManager.h"

@interface MainViewController ()

@property (weak) IBOutlet AnimateWebView *webView;

@property (nonatomic, strong) PlayerWindow *playerWindow;

@end

@implementation MainViewController

#pragma mark - AnimateWebViewDelegate

- (void)validURLs:(NSArray<NSURL *> *)validURLs {
    if (validURLs.count) {
        if (!self.playerWindow) {
            self.playerWindow = [[PlayerWindow alloc] initWithFrame:[PositionManager frameForKey:@"PlayerWindowFrame"]];
        }
        self.playerWindow.title = self.webView.currentTitle;
        [self.playerWindow playFromURL:validURLs.lastObject];
        [self.playerWindow makeKeyAndOrderFront:NSApp];
    }
}

#pragma mark - Instance Method

- (void)storeFinalWindowsFrame {
    if (self.playerWindow) {
        [self.playerWindow windowShouldClose:self.playerWindow];
    }
    [PositionManager setFrame:self.view.window.frame forKey:@"MainWindowFrame"];
}

@end
