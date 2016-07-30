//
//  MainViewController.m
//  DongDongKanV2
//
//  Created by DaidoujiChen on 2016/7/30.
//  Copyright © 2016年 DaidoujiChen. All rights reserved.
//

#import "MainViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PositionManager.h"

@interface AVPlayerView (Private)

- (BOOL)isFullScreen;
- (void)enterFullScreen:(id)something;
- (void)exitFullScreen:(id)something;

@end

@interface MainViewController ()

@property (weak) IBOutlet WebView *webView;

@property (nonatomic, strong) AVPlayerView *avPlayerView;
@property (nonatomic, strong) PlayerWindow *playerWindow;
@property (nonatomic, strong) NSString *animateTitle;

@end

@implementation MainViewController

#pragma mark - PlayerWindowDelegate

- (void)keyboardPress:(NSString *)pressKey {
    if (self.avPlayerView.player) {
        if ([pressKey isEqualToString:@" "]) {
            AVPlayer *player = self.avPlayerView.player;
            if (player) {
                if (player.rate != 0) {
                    [player pause];
                }
                else {
                    [player play];
                }
            }
        }
        else if ([pressKey.lowercaseString isEqualToString:@"f"]) {
            if ([self.avPlayerView isFullScreen]) {
                [self.avPlayerView exitFullScreen:self.avPlayerView];
            }
            else {
                [self.avPlayerView enterFullScreen:self.avPlayerView];
            }
        }
    }
}

#pragma mark - NSWindowDelegate

- (BOOL)windowShouldClose:(NSWindow *)window {
    [self clearIfPlayerExist];
    [PositionManager setFrame:window.frame forKey:@"PlayerWindowFrame"];
    return YES;
}

#pragma mark - WebResourceLoadDelegate

- (void)webView:(WebView *)sender resource:(id)identifier didFinishLoadingFromDataSource:(WebDataSource *)dataSource {
    NSString *title = [[sender stringByEvaluatingJavaScriptFromString:@"document.title"] stringByReplacingOccurrencesOfString:@" - 巴哈姆特動畫瘋" withString:@""];
    if (![self.animateTitle isEqualToString:title]) {
        self.animateTitle = title;
    }
}

- (id)webView:(WebView *)sender identifierForInitialRequest:(NSURLRequest *)request fromDataSource:(WebDataSource *)dataSource {
    
    // 取得帶有 .m3u8 的網址
    if ([request.URL.absoluteString containsString:@".m3u8"]) {
        [sender.mainFrame stopLoading];
        
        // 處理網址
        NSString *fixedURLString = [self fixedURLString:request.URL.absoluteString];
        
        // 拆解所有影片的 url
        __weak MainViewController *weakSelf = self;
        [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:fixedURLString] completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error) {
                NSString *videosString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSArray *videos = [videosString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSMutableArray *validVideos = [NSMutableArray array];
                for (NSString *video in videos) {
                    if ([video containsString:@"token"]) {
                        [validVideos addObject:[NSString stringWithFormat:@"%@/%@", [fixedURLString stringByDeletingLastPathComponent], video]];
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf) {
                        __strong MainViewController *storngSelf = weakSelf;
                        [storngSelf playFromURLs:validVideos];
                    }
                });
            }
        }] resume];
    }
    
    return [NSProcessInfo processInfo].globallyUniqueString;
}

#pragma mark - Private Instance Method

- (void)clearIfPlayerExist {
    if (self.avPlayerView) {
        [self.avPlayerView.player pause];
        [self.avPlayerView removeFromSuperview];
        self.avPlayerView = nil;
    }
}

- (PlayerWindow *)createWindow {
    PlayerWindow *newWindow = self.playerWindow;
    if (!newWindow) {
        
        // set player window frame
        NSRect newFrame = [PositionManager frameForKey:@"PlayerWindowFrame"];
        if (NSEqualRects(newFrame, NSZeroRect)) {
            newFrame.size = NSMakeSize(320, 240);
            newFrame.origin.x = NSWidth(self.view.window.screen.frame) / 2 - NSWidth(newFrame) / 2;
            newFrame.origin.y = NSHeight(self.view.window.screen.frame) / 2 - NSHeight(newFrame) / 2;
        }
        
        // masks
        NSUInteger maskStyle = NSBorderlessWindowMask | NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask;
        
        // create window
        newWindow = [[PlayerWindow alloc] initWithContentRect:newFrame styleMask:maskStyle backing:NSBackingStoreBuffered defer:NO];
        newWindow.delegate = self;
        newWindow.keyboardPressDelegate = self;
        newWindow.releasedWhenClosed = NO;
        newWindow.backgroundColor = [NSColor clearColor];
        [newWindow makeKeyAndOrderFront:NSApp];
        self.playerWindow = newWindow;
    }
    else {
        [newWindow makeKeyAndOrderFront:NSApp];
    }
    newWindow.title = self.animateTitle;
    return newWindow;
}

- (NSString *)fixedURLString:(NSString *)urlString {
    NSRange targetImString = [urlString rangeOfString:@"?stream="];
    NSString *splitURLString = [urlString substringFromIndex:targetImString.location + targetImString.length];
    splitURLString = [splitURLString stringByReplacingOccurrencesOfString:@"%3A" withString:@":"];
    splitURLString = [splitURLString stringByReplacingOccurrencesOfString:@"%2F" withString:@"/"];
    splitURLString = [splitURLString stringByReplacingOccurrencesOfString:@"%26" withString:@"&"];
    splitURLString = [splitURLString stringByReplacingOccurrencesOfString:@"%3F" withString:@"?"];
    splitURLString = [splitURLString stringByReplacingOccurrencesOfString:@"%3D" withString:@"="];
    return splitURLString;
}

- (void)playFromURLs:(NSArray *)urls {
    if (urls.count) {
        PlayerWindow *newWindow = [self createWindow];
        [self clearIfPlayerExist];
        
        self.avPlayerView = [[AVPlayerView alloc] initWithFrame:newWindow.contentView.bounds];
        self.avPlayerView.showsFullScreenToggleButton = YES;
        AVAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:urls[urls.count - 1]] options:nil];
        AVPlayerItem *avPlayerItem = [AVPlayerItem playerItemWithAsset:avAsset];
        self.avPlayerView.player = [AVPlayer playerWithPlayerItem:avPlayerItem];
        [newWindow.contentView addSubview:self.avPlayerView];
        [self.avPlayerView.player play];
        
        self.avPlayerView.translatesAutoresizingMaskIntoConstraints = NO;
        [newWindow.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[videoContainView]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{ @"videoContainView": self.avPlayerView }]];
        [newWindow.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[videoContainView]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{ @"videoContainView": self.avPlayerView }]];
    }
}

#pragma mark - Instance Method

- (void)storeFinalWindowsFrame {
    if (self.playerWindow) {
        [self windowShouldClose:self.playerWindow];
    }
    [PositionManager setFrame:self.view.window.frame forKey:@"MainWindowFrame"];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // webview 顯示來源
    self.webView.resourceLoadDelegate = (id<WebResourceLoadDelegate>)self;
    self.webView.customUserAgent = @"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.76 Mobile Safari/537.36";
    [self.webView.mainFrame loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ani.gamer.com.tw/"]]];
}

@end
