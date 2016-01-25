//
//  ViewController.m
//  SoftLink
//
//  Created by qingyun on 16/1/15.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"
#import "LoginVc.h"
#import "AppDelegate.h"
@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollVIew;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)loginBtn:(UIButton *)sender {
    
    [_scrollVIew removeFromSuperview];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate guideEnd];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        self.pageControl.currentPage = self.scrollVIew.contentOffset.x/self.view.frame.size.width;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = self.scrollVIew.contentOffset.x/self.view.frame.size.width;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
