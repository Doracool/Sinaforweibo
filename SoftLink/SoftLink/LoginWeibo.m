//
//  LoginWeibo.m
//  SoftLink
//
//  Created by qingyun on 16/1/16.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "LoginWeibo.h"
#import "Common.h"
#import <AFHTTPSessionManager.h>
#import "Account.h"
@interface LoginWeibo ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LoginWeibo
- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *url = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@&response_type=code",kAppKey,kRedirectURI];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [self.webView loadRequest:request];
    
    [self.webView setDelegate:self];
}

#pragma mark - webView delegate 


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //取出请求的url地址
    NSString *urlString = request.URL.absoluteString;
    NSLog(@"%@",urlString);
    
    //以回调地址开头的url
    if ([urlString hasPrefix:kRedirectURI]) {
        NSArray *result = [urlString componentsSeparatedByString:@"code="];
        
        //取到服务器返回的code
        
        NSString *code = result.lastObject;
        NSString *urlString = @"https://api.weibo.com/oauth2/access_token";
        
        NSDictionary *params = @{@"client_id":kAppKey,
                                 @"client_secret":AppSecret,
                                 @"grant_type":@"authorization_code",
                                 @"code":code,
                                 @"redirect_uri":kRedirectURI};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        
        [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            [[Account shareAccount] saveAccountInfo:responseObject];
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccess object:nil];
            
            
            //webView 的缓存删除
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            NSArray *array = storage.cookies;
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [storage deleteCookie:obj];
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError *  error) {
            NSLog(@"%@",error);
        }];
        
        
    }
    return YES;
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
