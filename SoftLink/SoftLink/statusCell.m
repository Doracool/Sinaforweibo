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
#import "UIButton+WebCache.h"
#import "UserModel.h"
#import "StatusModel.h"
#import "SDPhotoBrowser.h"

@interface statusCell ()<SDPhotoBrowserDelegate>
@property (nonatomic, strong) UIButton *btn;
@end

@implementation statusCell


-(void)bandingStatus:(StatusModel *)info
{
    NSString *urlString = info.user.profile_image_url;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:urlString]];
//    self.name.text = info[@"user"][@"name"];
//    self.time.text = info[@"created_at"];
//    self.source.text = info[@"source"];
//    self.content.text = info[@"text"];
//    NSDictionary *reTwitter = info[@"retweeted_status"];
    self.name.text = info.user.screen_name;
    self.time.text = info.timeAgo;
    self.source.text = info.source;
    self.content.text = info.text;
    StatusModel *reTwitter = info.retweeted_status;
    self.Recontent.text = reTwitter.text;
//    self.Recontent.text = info[@"retweeted_status"][@"text"];
    
    [self layoutImages:reTwitter.pic_urls forView:self.ReimageSup Height:self.ReImageHeight];
    
    if (reTwitter) {
        //有转发微博的时候
        //设置imageSup的高度为0
        [self layoutImages:nil forView:self.imageSup Height:self.imageSupHeight];
    }
        [self layoutImages:info.pic_urls forView:self.imageSup Height:self.imageSupHeight];

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
        _btn = [[UIButton alloc] initWithFrame:CGRectMake(idx%3*(90 + 5), (idx/3*(90 + 5)), 120, 120)];
//        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn sd_setImageWithURL:[NSURL URLWithString:imgUrl] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
        
        _btn.tag = idx;
        //添加显示
        [view addSubview:_btn];
    }];
    
}
/*
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        _btn.frame = CGRectMake(idx%3*(95), (idx/3*95), 90, 90);
    }];
}
 */

-(void)showImage:(UIButton *)sender{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = sender.superview;//父视图
    browser.imageCount = sender.superview.subviews.count;
    browser.currentImageIndex = (int)sender.tag;
    browser.delegate = self;
    [browser show];
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
//返回的临时小图
-(UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIView *superView;
    if (self.imageSup.subviews.count != 0) {
        superView = self.imageSup;
    }else{
        superView = self.ReimageSup;
    }
    
    //响应的Button
    UIButton *button = superView.subviews[index];
    return [button imageForState:UIControlStateNormal];
}

-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    UIView *superView;
    if (self.imageSup.subviews.count != 0) {
        superView = self.imageSup;
    }else{
        superView = self.ReimageSup;
    }
    
    //响应的button
    UIButton *button = superView.subviews[index];
    //缩略图地址
    NSString *string = [button sd_imageURLForState:UIControlStateNormal].absoluteString;
    //大图的url地址
    string = [string stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:string];
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
