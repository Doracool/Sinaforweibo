//
//  AppDelegate.m
//  SoftLink
//
//  Created by qingyun on 16/1/15.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginVc.h"
#import "ViewController.h"
#import "Common.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 
    self.window = [[UIWindow alloc] initWithFrame:KscreenBounds];
    self.window.rootViewController = [self instantiateRottViewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(UIViewController *)instantiateRottViewController
{
    NSString *currentVersion = [[NSBundle  mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    
//    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
//    
//    NSString *appRun = [users objectForKey:Appear];
    
    //根据应用情况 第一次打开显示引导页 再次打开是首页
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userAppear = [user objectForKey:Appear];
    
    if ([userAppear isEqualToString:currentVersion]) {
        //之前已经运行过
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"nav"];
        return vc;
    }else{
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"first"];
        return vc;
    }
    return nil;
    
}

-(void)guideEnd
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"nav"];
    self.window.rootViewController = vc;
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    
    [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:Appear];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
