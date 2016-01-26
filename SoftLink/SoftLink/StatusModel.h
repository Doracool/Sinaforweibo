//
//  StatusModel.h
//  SoftLink
//
//  Created by qingyun on 16/1/26.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;
@interface StatusModel : NSObject
@property (nonatomic, strong) NSDate *created_at;
//created_at	string	微博创建时间
@property (nonatomic, strong) NSNumber *statusID;
//id	int64	微博ID
@property (nonatomic, strong) NSString *text;
//text	string	微博信息内容
@property (nonatomic, strong) NSString *source;
//source	string	微博来源
@property (nonatomic, strong) UserModel *user;
//user	object	微博作者的用户信息字段 详细
@property (nonatomic, strong) StatusModel *retweeted_status;
//retweeted_status	object	被转发的原微博信息字段，当该微博为转发微博时返回 详细
@property (nonatomic, strong) NSNumber *reposts_count;
//reposts_count	int	转发数
@property (nonatomic, strong) NSNumber *comments_count;
//comments_count	int	评论数
@property (nonatomic, strong) NSNumber *attitudes_count;
//attitudes_count	int	表态数
@property (nonatomic, strong) NSArray *pic_urls;
//微博配图的缩略图
@property (nonatomic) NSString *timeAgo;
-(instancetype)initWithDictionary:(NSDictionary *)info;

@end
