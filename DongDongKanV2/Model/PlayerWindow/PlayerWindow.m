//
//  PlayerWindow.m
//  DongDongKanV2
//
//  Created by DaidoujiChen on 2016/7/30.
//  Copyright © 2016年 DaidoujiChen. All rights reserved.
//

#import "PlayerWindow.h"

@implementation PlayerWindow

- (void)keyDown:(NSEvent *)theEvent {
    if (self.keyboardPressDelegate && [self.keyboardPressDelegate respondsToSelector:@selector(keyboardPress:)]) {
        [self.keyboardPressDelegate keyboardPress:theEvent.characters];
    }
}

@end
