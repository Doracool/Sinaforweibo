//
//  UINavigationController+notifation.m
//  SoftLink
//
//  Created by qingyun on 16/1/25.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "UINavigationController+notifation.h"
#import "Common.h"
@implementation UINavigationController (notifation)


-(void)showNotification:(NSString *)notification
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, KscreenBounds.size.width, 30)];
    label.backgroundColor = [UIColor orangeColor];
    label.text = notification;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [self.view insertSubview:label belowSubview:self.navigationBar];
    
    [UIView animateWithDuration:0.25 animations:^{
        label.frame = CGRectOffset(label.frame, 0, 30);
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:0.2 delay:1 options:0 animations:^{
            label.frame = CGRectOffset(label.frame, 0, -30);

        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}
@end
