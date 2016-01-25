//
//  statusCell.m
//  SoftLink
//
//  Created by qingyun on 16/1/18.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "statusCell.h"
#import "HomeVC.h"
#import "UIImageView+WebCache.h"
#import "Common.h"
@implementation statusCell


-(void)bandingStatus:(NSDictionary *)info
{
    NSString *urlString = info[@"user"][@"profile_image_url"];
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
//    UIImage *image = [UIImage imageWithData:data];
//    [self.icon setImage:image];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:urlString]];
    self.name.text = info[@"user"][@"name"];
    self.time.text = info[@"created_at"];
    self.source.text = info[@"source"];
    self.content.text = info[@"text"];
    
    NSDictionary *reTwitter = info[@"retweeted_status"];
    
    self.Recontent.text = info[@"retweeted_status"][@"text"];
    
    [self layoutImages:reTwitter[@"pic_urls"] forView:self.ReimageSup Height:self.ReImageHeight];
    
    if (reTwitter) {
        //有转发微博的时候
        //设置imageSup的高度为0
        [self layoutImages:nil forView:self.imageSup Height:self.imageSupHeight];
    }
        [self layoutImages:info[@"pic_urls"] forView:self.imageSup Height:self.imageSupHeight];

}
/**
 *  要显示的的图片
 *
 *  @param images           图片的张数
 *  @param view             父视图
 *  @param heightConstraint 约束
 */
- (void)layoutImages:(NSArray *)images forView:(UIView *)view Height:(NSLayoutConstraint *)heightConstraint
{
    //移除子视图
    NSArray *subViews = view.subviews;
    [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //根数图片显示需要的高度调整Views的高度
    CGFloat height = [self imageSuperViewHeight:images.count];
    
    heightConstraint.constant = height;
    
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //obj 是一个字典
        NSString *imgUrl = [obj objectForKey:@"thumbnail_pic"];
        
        //初始化一个imageview
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(idx%3*(90 + 5), (idx/3*(90 + 5)), 90, 90)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
//        UIImage *image = [UIImage imageWithData:data];
//        imageView.image = image;
        
        //添加显示
        [view addSubview:imageView];
    }];
    
}

//根据图片的张数确定图片显示需要的总高度
-(CGFloat)imageSuperViewHeight:(NSInteger)count
{
    //没有图片的时候返回0
    if (count <= 0) {
        return 0;
    }
    //显示的行数
    NSInteger line = ceil(count/3.f);
    
    //计算需要显示的高度
    CGFloat heigh = line * 90 + (line - 1) * 5;
    return heigh;
    
    
}



- (void)awakeFromNib {
    //
    self.content.preferredMaxLayoutWidth = KscreenBounds.size.width - 8 - 8;
    
    self.Recontent.preferredMaxLayoutWidth = self.content.preferredMaxLayoutWidth;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
