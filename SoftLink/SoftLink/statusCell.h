//
//  statusCell.h
//  SoftLink
//
//  Created by qingyun on 16/1/18.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StatusModel;
@interface statusCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *source;
@property (weak, nonatomic) IBOutlet UIView *imageSup;
@property (weak, nonatomic) IBOutlet UILabel *Recontent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageSupHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ReImageHeight;
@property (weak, nonatomic) IBOutlet UIView *ReimageSup;
@property (weak, nonatomic) IBOutlet UILabel *content;
//@property (nonatomic, assign) NSInteger titleHeight;

-(void)bandingStatus:(StatusModel *)info;
@end
