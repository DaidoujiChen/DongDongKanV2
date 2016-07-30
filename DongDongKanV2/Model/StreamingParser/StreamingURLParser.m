//
//  StreamingURLParser.m
//  DongDongKanV2
//
//  Created by DaidoujiChen on 2016/7/28.
//  Copyright © 2016年 DaidoujiChen. All rights reserved.
//

#import "StreamingURLParser.h"
#import <WebKit/WebKit.h>
#import <objc/runtime.h>

@implementation StreamingURLParser

#pragma mark - WebResourceLoadDelegate

+ (id)webView:(WebView *)sender identifierForInitialRequest:(NSURLRequest *)request fromDataSource:(WebDataSource *)dataSource {
    
    // 取得帶有 .m3u8 的網址
    if ([request.URL.absoluteString containsString:@".m3u8"]) {
        
        // 處理網址
        NSString *fixedURLString = [self fixedURLString:request.URL.absoluteString];
        
        // 拆解所有影片的 url
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
                    StreamingURLParserCallback completion = [self completion];
                    completion(validVideos);
                    [[self internalWebView].mainFrame stopLoading];
                    [self setInternalWebView:nil];
                    [self setCompletion:nil];
                });
            }
        }] resume];
    }
    
    return [NSProcessInfo processInfo].globallyUniqueString;
}

#pragma mark - Private Class Method

+ (void)setInternalWebView:(WebView *)internalWebView {
    objc_setAssociatedObject(self, @selector(internalWebView), internalWebView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (WebView *)internalWebView {
    return objc_getAssociatedObject(self, _cmd);
}

+ (void)setCompletion:(StreamingURLParserCallback)completion {
    objc_setAssociatedObject(self, @selector(completion), completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (StreamingURLParserCallback)completion {
    return objc_getAssociatedObject(self, _cmd);
}

+ (NSString *)fixedURLString:(NSString *)urlString {
    NSRange targetImString = [urlString rangeOfString:@"?stream="];
    NSString *splitURLString = [urlString substringFromIndex:targetImString.location + targetImString.length];
    splitURLString = [splitURLString stringByReplacingOccurrencesOfString:@"%3A" withString:@":"];
    splitURLString = [splitURLString stringByReplacingOccurrencesOfString:@"%2F" withString:@"/"];
    splitURLString = [splitURLString stringByReplacingOccurrencesOfString:@"%26" withString:@"&"];
    splitURLString = [splitURLString stringByReplacingOccurrencesOfString:@"%3F" withString:@"?"];
    splitURLString = [splitURLString stringByReplacingOccurrencesOfString:@"%3D" withString:@"="];
    return splitURLString;
}

#pragma mark - Class Method

+ (void)streamingURLFrom:(NSString *)urlString completion:(StreamingURLParserCallback)completion {
    if ([self internalWebView]) {
        [[self internalWebView].mainFrame stopLoading];
    }
    WebView *webView = [[WebView alloc] initWithFrame:CGRectZero];
    webView.resourceLoadDelegate = (id<WebResourceLoadDelegate>)self;
    webView.customUserAgent = @"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.76 Mobile Safari/537.36";
    [webView.mainFrame loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    [self setInternalWebView:webView];
    [self setCompletion:completion];
}

@end
