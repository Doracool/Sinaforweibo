//
//  FindVC.m
//  SoftLink
//
//  Created by qingyun on 16/1/18.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "FindVC.h"
#import "Account.h"
@interface FindVC ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *login;

@end

@implementation FindVC


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[Account shareAccount] isLogin]) {
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        //登录之后,退出登录，还能再次显示登录按钮
        self.navigationItem.rightBarButtonItem = self.login;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
