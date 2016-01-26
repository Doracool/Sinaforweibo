//
//  StatusFooterView.m
//  SoftLink
//
//  Created by qingyun on 16/1/26.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "StatusFooterView.h"
#import "Common.h"
#import "StatusModel.h"

@implementation StatusFooterView

-(void)awakeFromNib
{
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = [UIColor lightGrayColor];
}

-(void)bandingStatus:(StatusModel *)info
{
    [self.retwitter setTitle:[info.reposts_count stringValue] forState:UIControlStateNormal];
    [self.comment setTitle:[info.comments_count stringValue] forState:UIControlStateNormal];
    [self.like setTitle:[info.attitudes_count stringValue] forState:UIControlStateNormal];
}


@end
