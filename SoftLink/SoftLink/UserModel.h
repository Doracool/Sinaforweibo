//
//  UserModel.h
//  SoftLink
//
//  Created by qingyun on 16/1/26.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, strong) NSNumber *userId;//id	int64	用户UID
@property (nonatomic, strong) NSString *screen_name;//screen_name	string	用户昵称
//location	string	用户所在地
@property (nonatomic, strong) NSString *userDescription;//description	string	用户个人描述
@property (nonatomic, strong) NSString  *profile_image_url;//profile_image_url	string	用户头像地址（中图），50×50像素
@property (nonatomic, strong) NSString *avatar_hd;//avatar_hd	string	用户头像地址（高清），高清头像原图

-(instancetype)initWithDictionary:(NSDictionary *)info;
@end
