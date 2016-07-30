//
//  StreamingURLParser.h
//  DongDongKanV2
//
//  Created by DaidoujiChen on 2016/7/28.
//  Copyright © 2016年 DaidoujiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StreamingURLParserCallback)(NSArray *streamingURLs);

@interface StreamingURLParser : NSObject

+ (void)streamingURLFrom:(NSString *)urlString completion:(StreamingURLParserCallback)completion;

@end
