//
//  AnimateWebView.h
//  DongDongKanV2
//
//  Created by DaidoujiChen on 2016/7/31.
//  Copyright © 2016年 DaidoujiChen. All rights reserved.
//

#import <WebKit/WebKit.h>

@protocol AnimateWebViewDelegate;

@interface AnimateWebView : WebView <WebResourceLoadDelegate>

@property (nonatomic, weak) IBOutlet id<AnimateWebViewDelegate> animateDelegate;
@property (nonatomic, strong) NSString *currentTitle;

@end

@protocol AnimateWebViewDelegate <NSObject>

- (void)validURLs:(NSArray<NSURL *> *)validURLs;

@end
