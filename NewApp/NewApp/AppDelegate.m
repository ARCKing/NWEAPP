//
//  AppDelegate.m
//  NewApp
//
//  Created by gxtc on 17/2/13.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "AppDelegate.h"
#import "WelcomeVC.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UMMobClick/MobClick.h>
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>


#define USHARE_DEMO_APPKEY @"5861e5daf5ade41326001eab"

//#define UMessage_APPKEY @"58d0e9d48f4a9d17660001e6"

#define UMessage_APPKEY @"593a3d47f43e480a04001dd4"


#define IOS_VERSION_OF_DEVICE [[[UIDevice currentDevice]systemVersion]floatValue]


@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self checkIsLogin];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.rootViewController = [[TabBarController alloc]init];
//    [self.window makeKeyAndVisible];
//    return YES;
    
    
    //=================UMShare=======================================
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMessage_APPKEY];
    
    [self configUSharePlatforms];
    
   //================================================================
    
    
    //==================UMMobClick===================================
    
    UMConfigInstance.appKey = UMessage_APPKEY;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    
    //=================UMessage======================================
    
    [UMessage setAlias:@"test@test.com" type:kUMessageAliasTypeSina response:^(id responseObject, NSError *error) {
    }];
    
    //适配Https
//    [UMessage startWithAppkey:UMessage_APPKEY launchOptions:launchOptions httpsEnable:YES];
    
    
    [UMessage startWithAppkey:UMessage_APPKEY launchOptions:launchOptions];
    
    //注册通知
    [UMessage registerForRemoteNotifications];

    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    
    [UMessage setLogEnabled:YES];

    
    //==============================================================
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary * dic = [defaults objectForKey:@"userInfo"];

//    NSString * welcomes = dic[@"welcome"];
    
    NSLog(@"%@",dic);
    
    
    self.window.rootViewController = [[TabBarController alloc]init];
    [self.window makeKeyAndVisible];

    
    /*
    if ([welcomes isEqualToString:@"1"]) {
        
        self.window.rootViewController = [[TabBarController alloc]init];
        [self.window makeKeyAndVisible];
        
    }else{
    
    
        TabBarController * tab = [[TabBarController alloc]init];
        WelcomeVC * welcome = [[WelcomeVC alloc]init];
        
        welcome.appDelegate = self;
        welcome.tab = tab;
        
        self.window.rootViewController =welcome;
        [self.window makeKeyAndVisible];
        
        
    }*/
    
#pragma mark- 版本更新
    //======版本更新提示========
    
     [self checkNewVersion];
    
    //==============Push===================
    
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];

    NSLog(@"userInfo = %@",userInfo);
    

    
    if (userInfo) {
    
        self.userInfo = userInfo;
    }
    
    [self isNetWorking];
    
    
    
    return YES;
}




- (void)checkIsLogin{


    NetWork * net = [NetWork shareNetWorkNew];
    
    [net checkLoginToken];
        
    net.checkLoginTokenBK=^(NSString * code,NSString * message){
        
        NSLog(@"%@",message);
        
        if (![code isEqualToString:@"1"]) {
            
            NSLog(@"验证Token = %@",message);
            
            
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"userInfo"]];
            
            dic[@"login"] = @"0";
            
            NSDictionary * dicNew = [NSDictionary dictionaryWithDictionary:dic];
            
            [defaults setObject:dicNew forKey:@"userInfo"];
            
            [defaults synchronize];
            
        }
        
        
    };

}






//===版本更新提示======

- (void)checkNewVersion{

    //CFBundleShortVersionString - version
    //CFBundleVersion - Build
    
    
    NSString * currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSLog(@"[当前版本号:%@]",currentVersion);

    NetWork * net = [NetWork shareNetWorkNew];
    
    [net checkNewVersionFromNet];
    
    net.checkNewVewsionBK=^(NSString * code,NSString * message,NSString * str,NSArray * dataArray,NSArray * arr){
    
        if (dataArray.count > 0) {
            
            VersionModel * model = dataArray[0];
            
            NSString * newVersion = model.version_number;
            

            
            if ([currentVersion compare: newVersion] == NSOrderedAscending) {
                
                UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"有新版本啦!"
                                                                message:model.remarks
                                                               delegate:self
                                                      cancelButtonTitle:@"忽略"
                                                    otherButtonTitles:@"去更新", nil];
                alter.tag = 111111;
                
                [alter show];
            }
            
            
        }
        
    };
}







//网络监听======================
- (void)isNetWorking{

//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];

    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        NSUserDefaults * defaulte = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:[defaulte objectForKey:@"userInfo"]];
        
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:{
                NSLog(@"未知网络状态");
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"未知网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
                
                dic[@"net"] = @"1";
                
                
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"无网络");
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"无网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
                
                dic[@"net"] = @"0";
                
                
                
                

            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"蜂窝数据网");
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"正在使用蜂窝数据网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
                
                dic[@"net"] = @"1";

                
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"WiFi网络");
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"网络" message:@"WiFi网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
                
                dic[@"net"] = @"1";

            }
                
                break;
                
            default:
                break;
        }
        
        
        NSDictionary * newDic = [NSDictionary dictionaryWithDictionary:dic];
        
        NSLog(@"%@",newDic);
        
        [defaulte setObject:newDic forKey:@"userInfo"];
        
        [defaulte synchronize];
        
        NSLog(@"%@",[defaulte objectForKey:@"userInfo"]);

        [[NSNotificationCenter defaultCenter] postNotificationName:@"NoNet" object:nil];

    }];
    
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];

}




//=========================================UMShare====================================
- (void)configUSharePlatforms
{
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置微信的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
    
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx2d427621df75f322" appSecret:@"9d94e7ec0105c54a603bafdcc1f46962" redirectURL:@"http://mobile.umeng.com/social"];

    
}



//#define __IPHONE_10_0    100000
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响。
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#endif

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
//=================================================================================




//===================================UMessage======================================



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
//    [UMessage registerDeviceToken:deviceToken];
    
    
//    NSLog(@"iphon:devicetoken =%@",deviceToken);
    
    NSLog(@"deviceToken=%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                              stringByReplacingOccurrencesOfString: @">" withString: @""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""]);

    
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{

    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);

}



//iOS10新增：处理前台收到通知的代理方法 [点击前台通知栏]
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;

    self.userInfo = userInfo;
    APNsModel * model = [self apnsModelWithUserInfo:userInfo];

    NSLog(@"userInfo = %@",userInfo);

    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];

        
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        
        [self showPushMessageAlertViewWithContent:model];

        
        
    
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
//    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}



//iOS10新增：处理后台点击通知栏的代理方法 [杀死下也走这个方法]
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    self.userInfo = userInfo;
    APNsModel * model = [self apnsModelWithUserInfo:userInfo];

    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        [self showPushMessageAlertViewWithContent:model];


        
    }else{
        //应用处于后台时的本地推送接受
    }
}




//ios10 在此接收前台通知栏

//iOS10 以下 使用这个方法接收通知 app在  [前台或者后台] 的时候用didReceiveRemoteNotification：
//                              【杀死下，不走这个方法！】【杀死下走上面的方法】
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{

    
    NSLog(@"userInfo = %@",userInfo);
    
    self.userInfo = userInfo;
    
    APNsModel * model = [self apnsModelWithUserInfo:userInfo];
    
    //关闭U-Push自带的弹出框
    [UMessage setAutoAlert:NO];

    [UMessage didReceiveRemoteNotification:userInfo];
    
    
        self.userInfo = userInfo;
        //定制自定的的弹出框
        //判断是后台
        if([UIApplication sharedApplication].applicationState == UIApplicationStateInactive)
        {
           
            NSLog(@"后台？");

            
            [self showPushMessageAlertViewWithContent:model];
            
        }
    
    
    
        //判断是前台
        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        {
    
            NSLog(@"前台");
        
            [self showPushMessageAlertViewWithContent:model];

    }
    
}



/**推送消息提示框*/
- (void)showPushMessageAlertViewWithContent:(APNsModel *)model{

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"新消息"
                                                     message:model.title
                                                    delegate:self
                                           cancelButtonTitle:@"忽略"
                                           otherButtonTitles:@"查看",nil];
    
    
    [alert show];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    
    if (alertView.tag == 111111) {
        
        if (buttonIndex == 1) {
            
            NSLog(@"下载");
            
//            NSString * url = @"https://itunes.apple.com/us/app/%E7%9F%A5%E4%BA%86-%E9%98%85%E8%AF%BB%E8%B5%84%E8%AE%AF/id1221771642?l=zh&ls=1&mt=8";
            
            
            //http://zqw.2662126.com/Web/show/app.html
            
             NSString * url = @"http://zqw.2662126.com/Web/show/app.html";
            
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            
        }else{
            
            NSLog(@"忽略");
            
        }

        
        return;
    }
    
    
    
    if (buttonIndex == 1) {
    
        NSLog(@"查看");
    
        [self pushToWkWebViewControllWithUserInfo:self.userInfo];
        
    }else{
    
        NSLog(@"忽略");

    
    }


}


//解析成模型
- (APNsModel *)apnsModelWithUserInfo:(NSDictionary *)userInfo{

    NSDictionary * aps = userInfo[@"aps"];
    NSString * alert = aps[@"alert"];
    
    NSDictionary * content_available = aps[@"content-available"];
    APNsModel * model = [[APNsModel alloc]initWithDictionary:content_available error:nil];
    model.alert = alert;
    NSLog(@"%@",model);
    
    return model;
}


//提示框跳转
- (void)pushToWkWebViewControllWithUserInfo:(NSDictionary *)userInfo{

    
    APNsModel * model = [self apnsModelWithUserInfo:userInfo];
    
    ArticleListModel * article = [[ArticleListModel alloc]init];
    
    article.id = model.id;
    article.title = model.title;
    article.thumb = model.thumb;
    
    UIViewController * currentVC = [self currentVC];
    WKWebViewController * wk = [[WKWebViewController alloc]init];
    wk.isPost = NO;
    wk.isVideo = NO;
    wk.article_id = [NSString stringWithFormat:@"%d",model.id];
    wk.articleModel = article;
    wk.isPushAPNS = YES;
    
    BOOL isFirstVc = currentVC.navigationController.childViewControllers.count > 1 ? YES : NO;
    
    currentVC.hidesBottomBarWhenPushed = YES;
    [currentVC.navigationController pushViewController:wk animated:YES];

    
    if (isFirstVc) {
        
    }else{
    
        currentVC.hidesBottomBarWhenPushed = NO;

    }
    
    

}


/**直接跳转*/
- (void)pushVcDirectWithUserInfo:(NSDictionary *)userInfo{

    APNsModel * model = [self apnsModelWithUserInfo:userInfo];
    
    ArticleListModel * article = [[ArticleListModel alloc]init];
    
    article.id = model.id;
    article.title = model.title;
    article.thumb = model.thumb;
    
    WKWebViewController * wk = [[WKWebViewController alloc]init];
    wk.isPost = NO;
    wk.isVideo = NO;
    wk.article_id = [NSString stringWithFormat:@"%d",model.id];
    wk.articleModel = article;
    wk.isPushAPNS = YES;
    
    [self.window.rootViewController presentViewController:wk animated:YES completion:nil];
    
}




//获取当前视图控制器
- (UIViewController *)currentVC{

    UITabBarController * tab = (UITabBarController *)self.window.rootViewController;
    
    UINavigationController * nav = tab.selectedViewController;
    
    UIViewController * currentVC = nav.visibleViewController;
    
    return currentVC;
}




//=================================================================================


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
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"NewApp"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
    
    
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }

    
    
    
    
    
}


//=========================================ios10 下 coreData =============

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "xqp.___" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"NewApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NewApp.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    NSDictionary * optins = @{NSMigratePersistentStoresAutomaticallyOption:@(YES),
                              NSInferMappingModelAutomaticallyOption:@(YES)};
    
    
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:optins error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}





@end
