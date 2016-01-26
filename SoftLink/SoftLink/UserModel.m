//
//  UserModel.m
//  SoftLink
//
//  Created by qingyun on 16/1/26.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "UserModel.h"
#import "Common.h"
@implementation UserModel

-(instancetype)initWithDictionary:(NSDictionary *)info
{
    if (self = [super init]) {
        //属性设置
        self.userId = info[kUserID];
        self.screen_name = info[kUserInfoName];
        self.userDescription = info[kUserDescription];
        self.profile_image_url = info[kUserProfileImageURL];
        self.avatar_hd = info[kUserAvatarHd];
    }
    return self;
}
@end
