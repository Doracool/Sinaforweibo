//
//  MainVC.m
//  SoftLink
//
//  Created by qingyun on 16/1/16.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "MainVC.h"
#import "Common.h"
#import "Account.h"
@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.tintColor = [UIColor orangeColor];
    
    if (![[Account shareAccount] isLogin]) {
        self.selectedIndex = 3;
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:kLoginSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:kLogoutSuccess object:nil];
}


-(void)login:(NSNotification *)notifi{
    self.selectedIndex = 0;
}

-(void)logout:(NSNotification *)notifi
{
    self.selectedIndex = 3;
    
    //显示登录界面
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"login"];
    [self presentViewController:vc animated:YES completion:nil];
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
