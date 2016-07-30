//
//  AnimateWebView.m
//  DongDongKanV2
//
//  Created by DaidoujiChen on 2016/7/31.
//  Copyright © 2016年 DaidoujiChen. All rights reserved.
//

#import "AnimateWebView.h"

@implementation AnimateWebView

#pragma mark - WebResourceLoadDelegate

- (void)webView:(WebView *)sender resource:(id)identifier didFinishLoadingFromDataSource:(WebDataSource *)dataSource {
    NSString *title = [[sender stringByEvaluatingJavaScriptFromString:@"document.title"] stringByReplacingOccurrencesOfString:@" - 巴哈姆特動畫瘋" withString:@""];
    if (![self.currentTitle isEqualToString:title]) {
        self.currentTitle = title;
    }
}

- (id)webView:(WebView *)sender identifierForInitialRequest:(NSURLRequest *)request fromDataSource:(WebDataSource *)dataSource {
    
    // 取得帶有 .m3u8 的網址
    if ([request.URL.absoluteString containsString:@".m3u8"]) {
        [sender.mainFrame stopLoading];
        
        // 處理網址
        NSString *fixedURLString = [self fixedURLString:request.URL.absoluteString];
        
        // 拆解所有影片的 url
        __weak AnimateWebView *weakSelf = self;
        [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:fixedURLString] completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error) {
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSArray *lines = [responseString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSMutableArray<NSURL *> *validURLs = [NSMutableArray array];
                for (NSString *line in lines) {
                    if ([line containsString:@"token"]) {
                        NSURL *validURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [fixedURLString stringByDeletingLastPathComponent], line]];
                        if (validURL) {
                            [validURLs addObject:validURL];
                        }
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf) {
                        __strong AnimateWebView *storngSelf = weakSelf;
                        if (storngSelf.animateDelegate && [storngSelf.animateDelegate respondsToSelector:@selector(validURLs:)]) {
                            [storngSelf.animateDelegate validURLs:validURLs];
                        }
                    }
                });
            }
        }] resume];
    }
    return [NSProcessInfo processInfo].globallyUniqueString;
}

#pragma mark - Private Instance Method

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

#pragma mark - Life Cycle

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        
        // webview 顯示來源
        self.resourceLoadDelegate = (id<WebResourceLoadDelegate>)self;
        self.customUserAgent = @"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.76 Mobile Safari/537.36";
        [self.mainFrame loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ani.gamer.com.tw/"]]];
    }
    return self;
}

@end
