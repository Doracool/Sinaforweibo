//
//  StatusModel.m
//  SoftLink
//
//  Created by qingyun on 16/1/26.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "StatusModel.h"
#import "Common.h"
#import "UserModel.h"
@implementation StatusModel


-(instancetype)initWithDictionary:(NSDictionary *)info
{
    if (self = [super init]) {
        //设置属性
        NSString *dateString = info[kStatusCreateTime];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"EEE MMM dd HH:mm:ss zzz yyyy";
        NSDate *date = [dateFormatter dateFromString:dateString];
        
        self.created_at = date;
        
//        self.created_at = info[kStatusCreateTime];
        self.statusID = info[kStatusID];
        self.text = info[kStatusText];
        self.source = [self sourceFromHTML:info[kStatusSource]];
        NSDictionary *userInfo = info[kStatusUserInfo];
        self.user = [[UserModel alloc] initWithDictionary:userInfo];
        NSDictionary *restatus = info[kStatusRetweetStatus];
        if (restatus) {
            self.retweeted_status = [[StatusModel alloc] initWithDictionary:restatus];
        }
        self.reposts_count = info[kStatusRepostsCount];
        self.comments_count = info[kStatusCommentsCount];
        self.attitudes_count = info[kStatusAttitudesCount];
        self.pic_urls = info[kStatusPicUrls];
    }
    return self;
}

-(NSString *)sourceFromHTML:(NSString *)html{
    
    if (!html || [html isKindOfClass:[NSNull class]] || [html isEqualToString:@""]) {
        return nil;
    }
    //定义一个正则表达式
    NSString *regExStr = @">.*<";
    NSError *error;
    //初始化一个正则表达式对象
    NSRegularExpression *repression = [NSRegularExpression regularExpressionWithPattern:regExStr options:0 error:&error];
    
    //查找符合条件的结果
    NSTextCheckingResult *result = [repression firstMatchInString:html options:0 range:NSMakeRange(0, html.length)];
    
    if (result) {
        NSRange range = result.range;
        NSString *source = [html substringWithRange:NSMakeRange(range.location + 1, range.length - 2)];
        return source;
    }
    
    return nil;
}

-(NSString *)timeAgo
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.created_at];
    if (interval < 60) {
        return  @"刚刚";
    }else if (interval < 60*60){
        return [NSString stringWithFormat:@"%d 分钟前",(int)interval/60];
    }else if (interval < 60*60*24){
        return [NSString stringWithFormat:@"%d 小时前",(int)interval/(60*60)];
    }else if (interval < 60*60*24*30){
        return [NSString stringWithFormat:@"%d 天前",(int)interval/(60*60*24)];
    }else{
        return [NSDateFormatter localizedStringFromDate:self.created_at dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    }
}
@end
