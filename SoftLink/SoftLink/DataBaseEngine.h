//
//  DataBaseEngine.h
//  SoftLink
//
//  Created by qingyun on 16/1/28.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseEngine : NSObject
//保存从网络上获取的微博数据
+(void)saveStatuses:(NSArray *)statuses;

//查询存储的数据
+(NSArray *)selectedStatuses;
@end
