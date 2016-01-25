//
//  Account.m
//  SoftLink
//
//  Created by qingyun on 16/1/18.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "Account.h"
#import "NSString+Documents.h"
#import "Common.h"
@interface Account ()<NSCoding>

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSDate *exprision;

@end

@implementation Account

+(instancetype)shareAccount
{
    static Account *account;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *filePath = [NSString DocumentsFilePath:kFileName];
        account = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        //如果第一次运行文件,文件为空,那么解档出来的对象也是空
        if (!account) {
            account = [[Account alloc] init];
        }
    });
    return account;
}

-(void)saveAccountInfo:(NSDictionary *)info
{
    self.token = info[@"access_token"];
    self.uid = info[@"uid"];
    double expiresIn = [info[@"expires_in"] doubleValue];
    self.exprision = [[NSDate date] dateByAddingTimeInterval:expiresIn];
    
    NSString *filePath = [NSString DocumentsFilePath:kFileName];
    
    [NSKeyedArchiver archiveRootObject:self toFile:filePath];  
    
}

-(BOOL)isLogin
{
    //有token并且token有效，那么就是登录状态
    if (self.token && [self.exprision compare:[NSDate date]] == NSOrderedDescending) {
        return YES;
    }
    return NO;
}


-(NSMutableDictionary *)requestParams
{
    if ([self isLogin]) {
        return [NSMutableDictionary dictionaryWithObject:self.token forKey:@"access_token"];
    }
    return nil;
}

-(void)logout
{
    //清楚本地数据
    self.token = nil;
    self.uid = nil;
    self.exprision = nil;
    
    //删除归档文件
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[NSString DocumentsFilePath:kFileName] error:&error];
}
#pragma mark - coding

//解档
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.token = [aDecoder decodeObjectForKey:@"access_token"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.exprision = [aDecoder decodeObjectForKey:@"expires_in"];
    }
    return self;
}

//归档
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.token forKey:@"access_token"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.exprision forKey:@"expires_in"];
}
@end
