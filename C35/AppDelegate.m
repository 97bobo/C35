//
//  AppDelegate.m
//  C35
//
//  Created by TimeMachine on 2018/3/29.
//  Copyright © 2018年 TimeMachine. All rights reserved.
//

#import "AppDelegate.h"
#import "LGWebViewController.h"
#import <AFNetworking.h>
#import "NetWorkStatusManager.h"
#import "ViewController.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import <AVOSCloud.h>

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate
{
    UIView *launchView;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:stageValue]  == nil) {
        //保存一个闯关模式成绩
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:stageValue];
        
    }
    //leancloud初始化
    [AVOSCloud setApplicationId:@"6rtTMCxP7Kl1VdnvwrMMQsfV-gzGzoHsz" clientKey:@"TtpCDg6QhQQo8f9jnI1BbYFx"];
    
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //开启错误日志统计
    [JPUSHService crashLogON];
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    //    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"588624da65246e56dbfa163e"
                          channel:@"App Store"
                 apsForProduction:YES
            advertisingIdentifier:nil];
    

//    [self checkoShouwVC];
    
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    //
    //        launchView = viewController.view;
    //        launchView.frame = [UIScreen mainScreen].bounds;
    //        [self.window addSubview:launchView];
    //        [self.window bringSubviewToFront:launchView];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    
    NetWorkStatusManager *netManager = [NetWorkStatusManager manager];
    netManager.NetStatusChange = ^(NetworkStatus status) {
        if (status != NotReachable) {
            
            [self checkoShouwVC];
            
        }
    };
    
    if (netManager.currentStatus == NotReachable) {
        return YES;
    }
    
    [self checkoShouwVC];
    
    return YES;
}

-(void)checkoShouwVC
{
    AVQuery *query = [AVQuery queryWithClassName:@"ShowControl"];
    [query orderByDescending:@"createdAt"];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isOnline"]) {//已经上线了
        
        NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"showURL"];
        
        LGWebViewController *webVC = [[LGWebViewController alloc] init];
        
        webVC.url = url;
        
//        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        self.window.rootViewController = webVC;
        
        [self.window makeKeyAndVisible];
        
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            AVObject *object = objects.firstObject;
            [[NSUserDefaults standardUserDefaults] setBool:[[object objectForKey:@"isOnline"] boolValue] forKey:@"isOnline"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if ([[object objectForKey:@"isOnline"] boolValue]) {
                
                NSString *url = [object objectForKey:@"showURL"];
                NSString *urlLocal = [[NSUserDefaults standardUserDefaults] objectForKey:@"showURL"];
                
                if ([url isEqualToString:urlLocal]) {
                    return ;
                }
                [[NSUserDefaults standardUserDefaults] setObject:url forKey:@"showURL"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                LGWebViewController *webVC = [[LGWebViewController alloc] init];
                
                webVC.url = url;
                
//                self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                
                self.window.rootViewController = webVC;
                [self.window makeKeyAndVisible];
                
            }else{
                ViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GameHomeVC"];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
                //
                //        launchView = viewController.view;
                //        launchView.frame = [UIScreen mainScreen].bounds;
                //        [self.window addSubview:launchView];
                //        [self.window bringSubviewToFront:launchView];
//                self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                self.window.rootViewController = nav;
                [self.window makeKeyAndVisible];
            }
        }
        
    }];
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

/** 极光推送注册失败回调 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
//    LGLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


#pragma mark- JPUSHRegisterDelegate

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10以上 点击推送走这个方法
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required,userInfo是
    /*{
     "status" = 1,
     "orderId" = 17,
     "_j_msgid" = 36028797545517863,
     "id" = MTc=,
     "aps" = {
     alert = "有新的用户来啦！请进入APP查看是否接受该用户！";
     badge = 1;
     sound = happy;
     },
     "_j_business" = 1,
     "_j_uid" = 6554961791,
     "info" = 有新的用户来啦！请进入APP查看是否接受该用户！,
     }*/
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:LGNotificationKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:LGNotificationReceiveNotification object:userInfo];
    completionHandler();  // 系统要求执行这个方法
}

// iOS 7~9 点击推送走这个方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:LGNotificationKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:LGNotificationReceiveNotification object:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
