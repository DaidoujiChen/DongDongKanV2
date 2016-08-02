//
//  PlayerWindow.m
//  DongDongKanV2
//
//  Created by DaidoujiChen on 2016/7/30.
//  Copyright © 2016年 DaidoujiChen. All rights reserved.
//

#import "PlayerWindow.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PositionManager.h"

@interface AVPlayerView (Private)

- (BOOL)isFullScreen;
- (void)enterFullScreen:(id)something;
- (void)exitFullScreen:(id)something;

@end

@interface PlayerWindow ()

@property (nonatomic, strong) AVPlayerView *avPlayerView;

@end

@implementation PlayerWindow

#pragma mark - NSWindowDelegate

- (BOOL)windowShouldClose:(NSWindow *)window {
    [self clearIfPlayerExist];
    [PositionManager setFrame:window.frame forKey:@"PlayerWindowFrame"];
    return YES;
}

#pragma mark - Private Instance Method

- (void)keyDown:(NSEvent *)theEvent {
    NSString *pressKey = theEvent.characters;
    if (self.avPlayerView.player) {
        if ([pressKey isEqualToString:@" "]) {
            [self playToggle];
        }
        else if ([pressKey.lowercaseString isEqualToString:@"f"]) {
            [self fullscreenToggle];
        }
    }
}

- (void)clearIfPlayerExist {
    if (self.avPlayerView) {
        [self.avPlayerView.player pause];
        [self.avPlayerView removeFromSuperview];
        self.avPlayerView = nil;
    }
}

#pragma mark * Toggle

- (void)playToggle {
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

- (void)fullscreenToggle {
    if ([self.avPlayerView isFullScreen]) {
        [self.avPlayerView exitFullScreen:self.avPlayerView];
    }
    else {
        [self.avPlayerView enterFullScreen:self.avPlayerView];
    }
}

#pragma mark - Instance Method

- (void)playFromURL:(NSURL *)url {
    [self clearIfPlayerExist];
    
    self.avPlayerView = [[AVPlayerView alloc] initWithFrame:self.contentView.bounds];
    self.avPlayerView.showsFullScreenToggleButton = YES;
    AVAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVPlayerItem *avPlayerItem = [AVPlayerItem playerItemWithAsset:avAsset];
    self.avPlayerView.player = [AVPlayer playerWithPlayerItem:avPlayerItem];
    [self.contentView addSubview:self.avPlayerView];
    [self.avPlayerView.player play];
    
    self.avPlayerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[videoContainView]-(0)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{ @"videoContainView": self.avPlayerView }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[videoContainView]-(0)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{ @"videoContainView": self.avPlayerView }]];
}

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(NSRect)frame {
    
    // set player window frame
    NSRect newFrame = frame;
    if (NSEqualRects(newFrame, NSZeroRect)) {
        newFrame.size = NSMakeSize(320, 240);
        NSRect screenFrame = [NSApplication sharedApplication].mainWindow.screen.frame;
        newFrame.origin.x = (NSWidth(screenFrame) - NSWidth(newFrame)) / 2;
        newFrame.origin.y = (NSHeight(screenFrame) - NSHeight(newFrame)) / 2;
    }
    
    // masks
    NSUInteger maskStyle = NSBorderlessWindowMask | NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask;
    
    // create window
    self = [super initWithContentRect:newFrame styleMask:maskStyle backing:NSBackingStoreBuffered defer:NO];
    if (self) {
        self.delegate = self;
        self.releasedWhenClosed = NO;
        self.backgroundColor = [NSColor clearColor];
    }
    return self;
}

@end
