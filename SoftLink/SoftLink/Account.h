//
//  Account.h
//  SoftLink
//
//  Created by qingyun on 16/1/18.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

+(instancetype)shareAccount;

//保存登陆信息
-(void)saveAccountInfo:(NSDictionary *)info;

//判断登录状态
-(BOOL)isLogin;

//包含token的可变字典
-(NSMutableDictionary *)requestParams;

//退出登录
-(void)logout;
@end
