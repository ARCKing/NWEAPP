//
//  WKWebViewController.m
//  NewApp
//
//  Created by gxtc on 17/2/17.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>

@interface WKWebViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic,strong)WKWebView * wkwebView;
@property (nonatomic, strong)WKWebViewConfiguration *wkConfig;


@property (nonatomic,strong)AFSecurityPolicy * securityPolicy;

@property (nonatomic,strong)MainShareView * shareView;

@property (nonatomic,strong)UIImage * locationShareImage;


@property (nonatomic,copy)NSString * slink;//获取推送时的原生分享链接
@property (nonatomic,copy)NSString * share;//获取推送时的分享链接


@property (nonatomic,copy)NSString * uid;
@property (nonatomic,assign)BOOL isLogin;

@property (nonatomic,assign)BOOL isQQShare;



@property (nonatomic,strong)UILabel * read_price;
@property (nonatomic,strong)UILabel * sum_money;
//    "read_price": "0.08",
//    "sum_money": "0.100"

@property (nonatomic, strong) UIProgressView *progressView;


@end

@implementation WKWebViewController


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];

    self.isLogin = [self isLoaginOrNotLogin];
    
}

/**检查登录状态*/
- (BOOL)isLoaginOrNotLogin{


    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];

    NSDictionary * dict = [defaults objectForKey:@"userInfo"];

    NSString * login = dict[@"login"];
    
    if ([login isEqualToString:@"1"]) {
        
        self.uid = dict[@"uid"];
        
        return YES;
    }else{
    
        return NO;
    }


}



- (void)viewWillDisappear:(BOOL)animated{

    [[NSNotificationCenter defaultCenter] removeObserver:self];


}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    
    if (self.isPushAPNS) {
        
        [self getPushshareAndSlink];
    }
    
    [self getShareImage];
    
    
    
    [self addUI];
    
    
    if (self.isPost) {
        
        [self WKWebPostRequest];

    }else{
    
        [self WKWebGetRequest];
        
    }
    
    
    
}






/**获取推送分享链接*/
- (void)getPushshareAndSlink{

    NetWork * net = [NetWork shareNetWorkNew];
    [net pushArticleShareAndSlinkWithID:self.article_id];
    
    __weak WKWebViewController * weakSelf = self;
    
    net.pushArticleShareAndSlinkBK=^(NSString * code,NSString * share,NSString * slink,NSArray * arr,NSArray * arrr){
    
        if ([code isEqualToString:@"1"]) {
            
            if (share && slink && ![share isEqualToString:@""] && ![slink isEqualToString:@"1"]) {
                
                weakSelf.articleModel.slink = slink;
                weakSelf.articleModel.link = share;
                
            }else{
                NSString * share = [NSString stringWithFormat:@"http://zqw.2662126.com/App/Share/share.html?id=%@",weakSelf.article_id];
                NSString * slink = [NSString stringWithFormat:@"http://zqw.2662126.com/detail.html?id=%@",weakSelf.article_id];

                weakSelf.articleModel.slink = slink;
                weakSelf.articleModel.link = share;

            }
            
            
        }else{
        
            NSString * share = [NSString stringWithFormat:@"http://zqw.2662126.com/App/Share/share.html?id=%@",weakSelf.article_id];
            NSString * slink = [NSString stringWithFormat:@"http://zqw.2662126.com/detail.html?id=%@",weakSelf.article_id];
            
            weakSelf.articleModel.slink = slink;
            weakSelf.articleModel.link = share;

        
        }
    
    };
}


/**获取分享缩略图*/
- (void)getShareImage{

    
    SDWebImageManager * manger = [SDWebImageManager sharedManager];
    
    __weak WKWebViewController * weakSelf = self;
    
    [manger.imageDownloader downloadImageWithURL:[NSURL URLWithString:self.articleModel.thumb] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        
        weakSelf.locationShareImage = image;
        
    }];
    
    


}




/**添加本地历史阅读记录*/
- (void)addCoreDataWithArticleHestoryRead{
    
    CoreDataManger * CDManger = [CoreDataManger shareCoreDataManger];
    
    [CDManger insertReadHestoryWithArticle:self.articleModel];
    
}



//红色导航栏
- (void)redNavBarViewCreatNew{

    UIView * redV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, 64)];
    redV.backgroundColor = [UIColor redColor];
    
    UILabel * heighPrice = [self addRootLabelWithfram:CGRectMake(ScreenWith/4, 20, ScreenWith/2, 44) andTitleColor:[UIColor whiteColor] andFont:16.0 andBackGroundColor:[UIColor clearColor] andTitle:@"转发获取高收益"];
    heighPrice.textAlignment = NSTextAlignmentCenter;
    [redV addSubview:heighPrice];
    
    UIButton * backBt = [self addRootButtonNewFram:CGRectMake(0, 27, 30, 30) andSel:@selector(redBarBackBt) andTitle:nil];
    backBt.layer.cornerRadius = 0.0;
    backBt.backgroundColor = [UIColor clearColor];
    [backBt setBackgroundImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [redV addSubview:backBt];
    
    [self.view addSubview:redV];
}


- (void)redBarBackBt{

    [self.navigationController popViewControllerAnimated:YES];

}

- (void)addUI{

    
    
    if (self.isHeightPrice) {
        
        [self redNavBarViewCreatNew];
        
    }else{
    
        [self addNavBarViewNew];

    }
    
    
    
    [self WKwebNwe];

    [self progressNew];

    if (!self.isNewTeach) {
        
        [self priceViewCreatNew];

        
        [self rootWebBottomViewNew];
        
//        [self rootReviewStateCheckFromNet];
        
    }
}



- (void)progressNew{

    /*
     *2.初始化progressView
     */
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, 2)];
    self.progressView.backgroundColor = [UIColor blueColor];
    
//    self.progressView.progressTintColor = [UIColor blackColor];
    
    self.progressView.progressTintColor = [UIColor colorWithRed:0.0/255.0 green:191.0/255.0 blue:255.0/255.0 alpha:1.0];
//     self.progressView.progressTintColor = [UIColor lightGrayColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    
    /*
     *3.添加KVO，WKWebView有一个属性estimatedProgress，就是当前网页加载的进度，所以监听这个属性。
     */
    [self.wkwebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];


}


///**添加历史阅读*///改成本地缓存
//- (void)addHistoryReadToNet{
//
//    NetWork * net = [NetWork shareNetWorkNew];
//    
//    if (self.isArticle) {
//        
//        NSString * title = self.articleModel.title;
//        
//        if (title == nil) {
//            
//            title = self.historyModel.title;
//        }
//        
//        
//        [net userHistoryRedAddArticleWithUidAndTokenAndID:self.article_id andTitle:title];
//        
//    }else{
//        
//        [net userHistoryRedAddArticleWithUidAndTokenAndID:self.article_id andTitle:self.videoModel.title];
//
//    }
//    
//}


#pragma mark- 导航栏的分享

-  (void)rightBarButtonAction{

    
    [self.shareView.shareBottomView removeFromSuperview];

    MainShareView * shareV;
    
    if (self.shareView == nil) {
        
        shareV = [[MainShareView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenHeight)];
        
        self.shareView  = shareV;

        [self.view addSubview:shareV];
        
    }else{
        
        shareV =  self.shareView ;
        
        [self.view addSubview:shareV];

    }

    [shareV addBarRigthShareViewNew];

    [shareV.rightShareViewShareButton addTarget:self action:@selector(rootShareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [shareV.rightShareViewcollectionButton addTarget:self action:@selector(rootCollectionArticleButtonAction) forControlEvents:UIControlEventTouchUpInside];

    [shareV.rightShareViewWarningButton addTarget:self action:@selector(rootWarningButtonAction) forControlEvents:UIControlEventTouchUpInside];

    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net userIsOrNotCollectionArticleWithArticleAid:self.article_id];
    
    __weak WKWebViewController * weakSelf = self;

    net.userIsOrNotCollectionBK = ^(NSString * code,NSString * message,NSString * isOrNot,NSArray * arr1,NSArray * arr2){
    

        if ([isOrNot isEqualToString:@"1"]) {

            [weakSelf.shareView.rightShareViewcollectionButton setImage:[UIImage imageNamed:@"selstar"] forState:UIControlStateNormal];

            weakSelf.isAlreadyCollection = YES;
        }else{
        
            weakSelf.isAlreadyCollection = NO;
        }
        
        
        if (arr1.count == 2) {
            
            
        }

        
    };
    
    
}


#pragma mark- 价格显示板
- (void)priceViewCreatNew{

    UIView * priceView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWith, ScreenWith/8)];
    [self.view addSubview:priceView];
    priceView.backgroundColor = [UIColor whiteColor];
    
//    priceView.layer.shadowOffset = CGSizeMake(0, 2);
//    priceView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    priceView.layer.shadowOpacity = 0.8;
    
   
    
    NSArray * array1 = @[@"0.00元",@"0.00元",@"无上限"];
    NSArray * array2 = @[@"阅读单价",@"已获得",@"最高可得"];



    for (int i = 0; i < 3; i++) {
        UILabel * label = [self addRootLabelWithfram:CGRectMake(ScreenWith/3 * i, 0, ScreenWith/3, ScreenWith/16) andTitleColor:[UIColor redColor] andFont:14.0 andBackGroundColor:[UIColor whiteColor] andTitle:array1[i]];
        label.textAlignment = NSTextAlignmentCenter;
        [priceView addSubview:label];
        
        if (i == 0) {
        
            self.read_price = label;
            
        }else if ( i == 1){
        
            self.sum_money = label;
        }
        
    }
    
    
    for (int i = 0; i < 3; i++) {
        UILabel * label = [self addRootLabelWithfram:CGRectMake(ScreenWith/3 * i, ScreenWith/16, ScreenWith/3, ScreenWith/16) andTitleColor:[UIColor lightGrayColor] andFont:15.0 andBackGroundColor:[UIColor whiteColor] andTitle:array2[i]];
        label.textAlignment = NSTextAlignmentCenter;
        [priceView addSubview:label];
    }
    
    for (int i = 0; i < 2; i++) {
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(ScreenWith/3 * i + ScreenWith/3, ScreenWith/32, 1, ScreenWith/16)];
        view.backgroundColor = [UIColor lightGrayColor];
        [priceView addSubview:view];
    }
    
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenWith/8 - 1, ScreenWith, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [priceView addSubview:line];

    
    [self articlePriceGetFromnNet];
}


#pragma mark- 价格面板数据请求1
- (void)articlePriceGetFromnNet{
    
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net NetArticlePriceWithAid:self.article_id andUid:self.uid];
    
    __weak WKWebViewController * weakSelf = self;
    
    net.articlePriceBK = ^(NSString * code, NSString *read_price, NSString *sum_money, NSArray * arr1, NSArray *arr2) {
        
            weakSelf.read_price.text = [NSString stringWithFormat:@"%@元",read_price];
            weakSelf.sum_money.text = [NSString stringWithFormat:@"%@元",sum_money];

    };
    
}


#pragma mark- 价格面板数据请求0
- (void)priceViewDataGetfromNet{

    NetWork * net = [NetWork shareNetWorkNew];
    
    [net userIsOrNotCollectionArticleWithArticleAid:self.article_id];
    
    __weak WKWebViewController * weakSelf = self;
    
    net.userIsOrNotCollectionBK = ^(NSString * code,NSString * message,NSString * isOrNot,NSArray * arr1,NSArray * arr2){
        
        if (arr1.count == 2) {
            
            weakSelf.read_price.text = [NSString stringWithFormat:@"%@元",arr1[0]];
            weakSelf.sum_money.text = [NSString stringWithFormat:@"%@元",arr1[1]];
            
        }
        
    };

}



- (void)rootCommentButtonAction{
    NSLog(@"rootCommentButtonAction");
    
    ComentListVC * vc = [[ComentListVC alloc]init];
    vc.aid = self.article_id;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
//    [self presentViewController:vc animated:YES completion:nil];
    
    
}


/**收藏*/
- (void)bottomViewCollectionAction{
    
    [self.shareView.rightShareView removeFromSuperview];
    [self.shareView.shareBottomView removeFromSuperview];
    [self.shareView removeFromSuperview];

    
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net userAddCollectionArticleWithArticleAid:self.article_id];
    
    //收藏
    net.userAddCollectinBK=^(NSString * code,NSString * message){
        
        NSLog(@"%@",message);
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = message;
        [hud hideAnimated:YES afterDelay:2.f];
        
    };
}





- (void)rootCollectionArticleButtonAction{

    [self.shareView.rightShareView removeFromSuperview];
    [self.shareView.shareBottomView removeFromSuperview];
    [self.shareView removeFromSuperview];

    
    
    NetWork * net = [NetWork shareNetWorkNew];
    __weak WKWebViewController * weakSelf = self;

    if (self.isAlreadyCollection) {
        
        [net userCancleCollectionArticleWithArticleAid:self.article_id];
        
        net.userCancleCollectionBK=^(NSString * code,NSString * message){
        
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = message;
            [hud hideAnimated:YES afterDelay:2.f];
            
            if ([code isEqualToString:@"1"]) {
                
                [weakSelf.shareView.rightShareViewcollectionButton setImage:[UIImage imageNamed:@"unselstar"] forState:UIControlStateNormal];
                
            }

        };
        
    }else{

        [net userAddCollectionArticleWithArticleAid:self.article_id];
    
        //收藏
        net.userAddCollectinBK=^(NSString * code,NSString * message){
    
            NSLog(@"%@",message);
        
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = message;
            [hud hideAnimated:YES afterDelay:2.f];
        
            if ([code isEqualToString:@"1"]) {
            
                [weakSelf.shareView.rightShareViewcollectionButton setImage:[UIImage imageNamed:@"selstar"] forState:UIControlStateNormal];

            }
        };
    }
}


- (void)rootWarningButtonAction{
    
    [self.shareView.rightShareView removeFromSuperview];
    [self.shareView.shareBottomView removeFromSuperview];
    [self.shareView removeFromSuperview];


    [self rootShowMBPhudWith:@"感谢您的反馈，我们会及时处理!" andShowTime:1.0];
    
}


- (void)rootShareButtonAction{

    [self.shareView.rightShareView removeFromSuperview];

    
    if (self.isLogin == NO) {
        
        UIAlertController * alterController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还未登录，是否登录？" preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction * action0 = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            LoginViewController * vc = [[LoginViewController alloc]init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"继续分享" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [self addBottomShareViewNew];
        }];
        
        [alterController addAction:action0];
        [alterController addAction:action1];

        [self presentViewController:alterController animated:YES completion:nil];
        
    }else{
    
        [self addBottomShareViewNew];
    }
}

//添加底部分享
- (void)addBottomShareViewNew{

    MainShareView * shareV;
    
    if (self.shareView == nil) {
        
        shareV = [[MainShareView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenHeight)];
        
        self.shareView  = shareV;
        
        [self.view addSubview:shareV];
        
    }else{
        
        shareV =  self.shareView ;
        
        [self.view addSubview:shareV];
        
    }
    
    [shareV addBottomShareViewNew];
    
    [shareV.WeiXinShareButton addTarget:self action:@selector(rootWeiXinShareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    shareV.WeiXinShareButton.tag = 1110;
    
    [shareV.WeiXinFriendShareButton addTarget:self action:@selector(rootWeiXinShareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    shareV.WeiXinFriendShareButton.tag = 2220;
    
//    [shareV.QQShareButton addTarget:self action:@selector(rootQQShareButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    
//    [shareV.QzoneShareButton addTarget:self action:@selector(rootQzoneShareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [shareV.LinkCopyButton addTarget:self action:@selector(linkCopyButtonAction) forControlEvents:UIControlEventTouchUpInside];

    
    
    [shareV.cancleButton addTarget:self action:@selector(rootCancleButtonAction) forControlEvents:UIControlEventTouchUpInside];

    [shareV.collectionButton addTarget:self action:@selector(bottomViewCollectionAction) forControlEvents:UIControlEventTouchUpInside];

    
}


//复制链接
- (void)linkCopyButtonAction{

    [self getAutoShareLinkWithType:@"wechat_friend" andWeiXinShare:NO];
    
    
}

//取消分享
- (void)rootCancleButtonAction{
    
    [self.shareView.rightShareView removeFromSuperview];
    [self.shareView.shareBottomView removeFromSuperview];
    [self.shareView removeFromSuperview];

}


#pragma mark- 获取分享自动跳转链接
-(void)getAutoShareLinkWithType:(NSString *)type andWeiXinShare:(BOOL)isWeiXinShare{

    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NetWork * net = [NetWork shareNetWorkNew];
    [net getAutoShareLinkFromNetWithShareType:type andAid:self.article_id andUid:self.uid];
    
    __weak WKWebViewController * weakSelf = self;
    net.getAutonShareLinkBK=^(NSString * uc,NSString * qq,NSString * ys,NSArray * arr1,NSArray * arr2){
    
        [hud hideAnimated:YES];
        
        if (uc && qq && ys) {
            
            if (isWeiXinShare) {
                
                [weakSelf QQbrowserShareOrUCbroeserShareOrYSshareWithUClink:uc andQQlink:qq AndYSLink:ys];

            }else{
            
//                [weakSelf QQandQZoneShareWithYSshareLink:ys];
                
                
                NSString * title = weakSelf.articleModel.title;
                
                [weakSelf rootCopyLinkWith:[NSString stringWithFormat:@"%@\n%@",title,ys]];
                
                [weakSelf.shareView removeFromSuperview];
                
            }
            
        }
        
    };

}

//浏览器分享
- (void)QQbrowserShareOrUCbroeserShareOrYSshareWithUClink:(NSString *)uc andQQlink:(NSString *)qq AndYSLink:(NSString *)ys{

    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"ucbrowser://"]] ){
        
        
        if (self.isHeightPrice) {
            
//            [self getHeightPriceMoney];
        }
        
        
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"ucbrowser://%@",uc]]];
        
        
    }else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mttbrowser://"]] ){
        
        if (self.isHeightPrice) {
            
//            [self getHeightPriceMoney];
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mttbrowser://url=%@",qq]]];
        
        
    }else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqqbrowser://"]]){
        
        
        if (self.isHeightPrice) {
            
//            [self getHeightPriceMoney];
        }
        
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqqbrowser://url=%@",qq]]];
        
    }else{
        
        if (self.locationShareImage == nil) {
            
            self.locationShareImage = [UIImage imageNamed:@"icon_180"];
        }
        
     
        [self rootLocationWeiXinShareWithImage:self.locationShareImage andImageUrl:self.articleModel.thumb andString:self.articleModel.title andUrl:ys];
        
    }
    

}


//QQ分享
- (void)QQandQZoneShareWithYSshareLink:(NSString *)ys{
    
    if (self.locationShareImage == nil) {
        
        self.locationShareImage = [UIImage imageNamed:@"icon_180"];
    }
    
    if (self.isQQShare) {
        
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            
            [self shareWebPageToPlatformType:UMSocialPlatformType_QQ andTitle:self.articleModel.title andContent:self.articleModel.title andUrl:ys andThumbImage:self.locationShareImage];

        }else{
            
            [self rootLocationWeiXinShareWithImage:self.locationShareImage andImageUrl:nil andString:self.articleModel.title andUrl:ys];

        }
        
        
        
    }else{
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            
            [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone andTitle:self.articleModel.title andContent:self.articleModel.title andUrl:ys andThumbImage:self.locationShareImage];

        }else{
            
            [self rootLocationWeiXinShareWithImage:self.locationShareImage andImageUrl:nil andString:self.articleModel.title andUrl:ys];
        }
    
    }


}




- (void)rootWeiXinShareButtonAction:(UIButton *)bt{

    //sharetype:
    //分享状态：wechat_moments 微信朋友圈， wechat_friend 微信好友，qq_mobile QQ好友，qq_zone QQ空间
    
    
    
    
    
    NSString * shareType;
    
    if (bt.tag == 1110) {
        shareType =  @"wechat_friend";
    }else{
        shareType =  @"wechat_moments";

    }
    
    [self.shareView removeFromSuperview];
    
    
    [self getAutoShareLinkWithType:shareType andWeiXinShare:YES];
    
    
    
    /*
    NSString * shareLink;
    NSString * locationShareLink;
    NSString * title;
    NSString * iconUrl;
    
    
        shareLink = self.articleModel.link;
        locationShareLink = self.articleModel.slink;
        title = self.articleModel.title;
        iconUrl = self.articleModel.thumb;
    
 
    if (shareLink == nil && self.isPushAPNS) {
        
        
        NSString * share = [NSString stringWithFormat:@"http://zqw.2662126.com/App/Share/share.html?id=%@",self.article_id];
        
        shareLink = share;
    }
    
    if (locationShareLink == nil && self.isPushAPNS) {
        
        NSString * slink = [NSString stringWithFormat:@"http://zqw.2662126.com/detail.html?id=%@",self.article_id];

        locationShareLink = slink;
    }
    
    
    if (self.isLogin && self.isPushAPNS) {
        
        shareLink = [NSString stringWithFormat:@"%@&uid=%@",shareLink,self.uid];
        
        locationShareLink = [NSString stringWithFormat:@"%@&uid=%@",locationShareLink,self.uid];
        
        
        if (bt.tag ==1110) {
            
            shareLink = [NSString stringWithFormat:@"%@&sharetype=wechat_friend",shareLink];
            
        }else{
        
            shareLink = [NSString stringWithFormat:@"%@&sharetype=wechat_moments",shareLink];

        }
        
    }else if(self.isPushAPNS){
    

        
        if (bt.tag ==1110) {
            
            shareLink = [NSString stringWithFormat:@"%@&sharetype=wechat_friend",shareLink];
            
        }else{
            
            shareLink = [NSString stringWithFormat:@"%@&sharetype=wechat_moments",shareLink];
            
        }

    
    }
    
    
    
    
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mttbrowser://"]] && !self.isPushAPNS){
            
            
            if (self.isHeightPrice) {
                
                [self getHeightPriceMoney];
            }
            
            
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mttbrowser://url=%@",shareLink]]];
            
            
        }else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqqbrowser://"]] &&!self.isPushAPNS){
            
            if (self.isHeightPrice) {
                
                [self getHeightPriceMoney];
            }
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqqbrowser://url=%@",shareLink]]];
            
            
        }else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"ucbrowser://"]]){
            
           
            if (self.isHeightPrice) {
                
                [self getHeightPriceMoney];
            }
            
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"ucbrowser://%@",shareLink]]];

        }else{
    
        if (self.locationShareImage == nil) {
            
            self.locationShareImage = [UIImage imageNamed:@"lg"];
        }
        
         [self rootLocationWeiXinShareWithImage:self.locationShareImage andImageUrl:iconUrl andString:title andUrl:locationShareLink];
        
        }*/

    
    
   

}


#pragma mark- 获取高价收益
/**获取高价收益*/
- (void)getHeightPriceMoney{

    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net getHeightPriceArticleMoneyWithArticleID:self.article_id andPrice:self.articleModel.read_price];
    
    net.getHeightPriceArticleMoneyBK=^(NSString * code,NSString * message){
        
        
        
        UIAlertController * alterController = [UIAlertController alertControllerWithTitle:@"收益提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        
    
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];

        
        [alterController addAction:action];
        
        [self presentViewController:alterController animated:YES completion:nil];

    };

}


- (void)rootQQShareButtonAction{
    [self.shareView removeFromSuperview];
    
    NSString * shareType = @"qq_mobile";
    self.isQQShare = YES;
    
    [self getAutoShareLinkWithType:shareType andWeiXinShare:NO];
    
    
    
    
    
    /*
    if (self.locationShareImage == nil) {
        
        self.locationShareImage = [UIImage imageNamed:@"lg"];
    }
    
    if (self.articleModel.slink == nil) {
        
        self.articleModel.slink = [NSString stringWithFormat:@"http://zqw.2662126.com/detail.html?id=%@",self.article_id];
    }
    
    if (self.articleModel.link == nil) {
        
        self.articleModel.link = [NSString stringWithFormat:@"http://zqw.2662126.com/App/Share/share.html?id=%@",self.article_id];
    }
    
    
    
    if (self.isPushAPNS && self.isLogin) {
        
        self.articleModel.slink = [NSString stringWithFormat:@"%@&uid=%@",self.articleModel.slink,self.uid];
        
        self.articleModel.link = [NSString stringWithFormat:@"%@&uid=%@",self.articleModel.link,self.uid];

    }
    
    
    
    
    [self shareWebPageToPlatformType:UMSocialPlatformType_QQ andTitle:self.articleModel.title andContent:self.articleModel.title andUrl:self.articleModel.slink andThumbImage:self.locationShareImage];
    */
}

- (void)rootQzoneShareButtonAction{
    [self.shareView removeFromSuperview];

    NSString * shareType = @"qq_zone";
    self.isQQShare = NO;
    
    [self getAutoShareLinkWithType:shareType andWeiXinShare:NO];

    /*
    if (self.locationShareImage == nil) {
        
        self.locationShareImage = [UIImage imageNamed:@"lg"];
    }

    
    
    if (self.articleModel.slink == nil) {
        
        self.articleModel.slink = [NSString stringWithFormat:@"http://zqw.2662126.com/detail.html?id=%@",self.article_id];
    }
    
    if (self.articleModel.link == nil) {
        
        self.articleModel.link = [NSString stringWithFormat:@"http://zqw.2662126.com/App/Share/share.html?id=%@",self.article_id];
    }

    
    if (self.isPushAPNS && self.isLogin) {
        
        self.articleModel.slink = [NSString stringWithFormat:@"%@&uid=%@",self.articleModel.slink,self.uid];
        
        self.articleModel.link = [NSString stringWithFormat:@"%@&uid=%@",self.articleModel.link,self.uid];
        
    }

    
    
    [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone andTitle:self.articleModel.title andContent:self.articleModel.title andUrl:self.articleModel.slink andThumbImage:self.locationShareImage];
    */
}


- (void)addNavBarViewNew{
    
    self.navigationBarView = [self NavBarViewNew];
    self.navigationBarView.backgroundColor = [UIColor whiteColor];
    [self addLineNew];
    
    [self addLeftBarButtonNew];
    
    if (!self.isNewTeach) {
        
//        [self addRightBarButtonNew];

    }
    
    
    [self addTitleLabelNew];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    
    [self.shareView.rightShareView removeFromSuperview];
    [self.shareView.shareBottomView removeFromSuperview];
    [self.shareView removeFromSuperview];
    
}




/*
#pragma mark- AFsecurityPolicy
- (void)AFsecurityPolicyTest{
    
    //    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"creditcard.cmbc.com.cn" ofType:@"cer"];
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"baidu.com" ofType:@"cer"];
    
    NSData *cerDat = [NSData dataWithContentsOfFile:cerPath];
    
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // 客户端是否信任自建证书(非法证书)
    securityPolicy.allowInvalidCertificates= YES;
    // 是否在证书域字段中验证域名
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = [[NSSet alloc]initWithObjects:cerDat, nil];
    
    self.securityPolicy = securityPolicy;
    
    //    AFHTTPSessionManager * httpManger = [AFHTTPSessionManager manager];
    //    httpManger.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    httpManger.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    httpManger.securityPolicy = securityPolicy;
}
*/
 
#pragma mark- 创建WKWeb
- (void)WKwebNwe{
    
    
    
    if (self.isNewTeach) {
        
        WKWebView * web = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, ScreenWith, ScreenHeight - 64) configuration:self.wkConfig];
        
        self.wkwebView =  web;

        
    }else{
        
        WKWebView * web = [[WKWebView alloc]initWithFrame: CGRectMake(0, 64 + ScreenWith/8, ScreenWith, ScreenHeight - 64 - ScreenWith/5 - 15) configuration:self.wkConfig];

        self.wkwebView =  web;

    }
    
    self.wkwebView.navigationDelegate = self;
    self.wkwebView.UIDelegate = self;
    
    [self.view addSubview:self.wkwebView];
    
   

}

- (WKWebViewConfiguration *)wkConfig {
    if (!_wkConfig) {
        _wkConfig = [[WKWebViewConfiguration alloc] init];
        _wkConfig.allowsInlineMediaPlayback = YES;
//        _wkConfig.allowsPictureInPictureMediaPlayback = YES;
    }
    return _wkConfig;
}

#pragma mark- WKWebPost
- (void)WKWebPostRequest{
    
    // 获取JS所在的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JSPost" ofType:@"html"];
    // 获得html内容
    NSString *html = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    // 加载js
    [self.wkwebView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];

    //设置网页标题监听
    [self.wkwebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}


// 调用JS发送POST请求
- (void)PostRequestWithJS {
    
    
//    NSString * textUrl = @"http://wz.lgmdl.com/App/Read/category";
//    NSString * textBody = @"/token=60e39694eeb1534d1f637447965bdb3e&uid=30000002&cid=1";

    
    
    // 发送POST的参数
//    NSString *postData = @"\"id\":\"30000002\",\"token\":\"60e39694eeb1534d1f637447965bdb3e\"";

    NSString * postData = [NSString stringWithFormat:@"id=%@",self.article_id];
    
    // 请求的页面地址
    NSString *urlStr = [NSString stringWithFormat:@"%@/app/article/detail",DomainURL];
    // 拼装成调用JavaScript的字符串
    NSString *jscript = [NSString stringWithFormat:@"post('%@', {%@});", urlStr, postData];
    
     NSLog(@"Javascript: %@", jscript);
    // 调用JS代码
    [self.wkwebView evaluateJavaScript:jscript completionHandler:^(id object, NSError * _Nullable error) {
        
        NSLog(@"%@",error);
        NSLog(@"%@",object);
    }];
}


#pragma mark- WkWebGet
- (void)WKWebGetRequest{
    
    
    if (self.isNewTeach) {
        
        [self.wkwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
        
        //设置网页标题监听
        [self.wkwebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
     
        return;
    }
    
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];

    NSString * login = dict[@"login"];
    NSString * uid = dict[@"uid"];
    
    BOOL isLogin = NO ;
    
    
    if ([login isEqualToString:@"1"]) {
        
        isLogin = YES;
    }
    
    
    
    
    NSString *urlStr;
    
    NSString * comment = self.articleModel.comment;

    if (comment == nil) {
        
        comment = @"0";
    }
        
        [self addCoreDataWithArticleHestoryRead];
    
    
        self.commentCount.text = [NSString stringWithFormat:@"%@",comment];

    
    if (self.isVideo) {
        
        urlStr =  [NSString stringWithFormat:@"%@/app/article/video/id/%@",DomainURL,self.article_id];

    }else{
    
        urlStr =  [NSString stringWithFormat:@"%@/app/article/detail/id/%@",DomainURL,self.article_id];
    }
    
    
    if (isLogin) {
        
        urlStr = [NSString stringWithFormat:@"%@/uid/%@",urlStr,uid];
        
    }
    
    
    [self.wkwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
        
    
    
    //设置网页标题监听
    [self.wkwebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}


#pragma mark- https
/**
 *加载 https时调用
 */

//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
//    
//    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//        
//        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
//        
//        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
//        
//}}


#pragma mark- WKWeb.title
//网页标题监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    
    
    if ([keyPath isEqualToString:@"title"]) {
        
        self.titleLabel.text = self.wkwebView.title;
        
    }else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.wkwebView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
    
    
   
}


- (void)dealloc{
    //释放监听对象
    [self.wkwebView removeObserver:self forKeyPath:@"title"];
    
    [self.wkwebView removeObserver:self forKeyPath:@"estimatedProgress"];

}

#pragma mark- 注册键盘监听
- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWillShown:(NSNotification*)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    CGFloat keyBoard_h = keyboardSize.height;
//    CGFloat keyBoard_w = keyboardSize.width;
    
    //输入框位置动画加载
    [UIView animateWithDuration:duration animations:^{

        self.commentView.frame = CGRectMake(0, ScreenHeight - keyBoard_h - ScreenWith/2, ScreenWith, ScreenWith/2);
    
    }];
}
//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    
    
//    [UIView animateWithDuration:0.2 animations:^{
//        
//        self.commentView.frame = CGRectMake(0, ScreenHeight - ScreenWith/2, ScreenWith, ScreenWith/2);
//        
//    }];
    
    
}

#pragma mark- 评论框
- (void)rootWriteCommentButtonAction{
    [super rootWriteCommentButtonAction];

    [self addRootCommentViewNew];
    
    [self.textView becomeFirstResponder];
}



- (void)rootCommentViewPushButtonAction{
    [super rootCommentViewPushButtonAction];
    
    NSLog(@"评论:%@",self.commentString);
    
    NetWork * net = [NetWork shareNetWorkNew];

    
    [net writeCommentAndRespondWithTypr:commentType_comment andContent:self.commentString andID:@"" andAID:self.article_id andRelation:@"" andRelname:@""];
    
    __weak WKWebViewController * weakSelf = self;
    net.commentBK=^(NSString * code,NSString * message){
    
        [weakSelf rootShowMBPhudWith:message andShowTime:1.0];
    
    };
    
    
    [UIView animateWithDuration:0.5 animations:^{
    
        [self.textView resignFirstResponder];
        self.commentView.frame = CGRectMake(0, ScreenHeight, ScreenWith, ScreenWith/2);
        
    }completion:^(BOOL finished) {
        
        
    }];
    
}


- (void)rootCommentViewCancleButtonAvtion{
    [super rootCommentViewCancleButtonAvtion];

    [self.textView resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.commentView.frame = CGRectMake(0, ScreenHeight, ScreenWith, ScreenWith/2);
        
    }completion:^(BOOL finished) {
        
        
    }];
}



- (void)textViewDidChangeSelection:(UITextView *)textView{

    NSLog(@"1 textViewDidChangeSelection");

    NSLog(@"%@",textView.text);

    NSUInteger worldLength = [textView.text length];

    self.woeldNumberLabel.text = [NSString stringWithFormat:@"%ld/200",worldLength];

    self.commentString = textView.text;

    
    if (worldLength > 0) {
        self.placeHolderLabel.hidden = YES;
    }else{
    
        self.placeHolderLabel.hidden = NO;
    }
    
}


- (void)textViewDidEndEditing:(UITextView *)textView{

    NSLog(@"2 textViewDidEndEditing");

    NSUInteger worldLength = [textView.text length];
    
    self.commentString = textView.text;

    self.woeldNumberLabel.text = [NSString stringWithFormat:@"%ld/200",worldLength];
    
    NSLog(@"%ld",worldLength);
}


#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    NSLog(@"didStartProvisionalNavigation");
    
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"didCommitNavigation");
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"didFinishNavigation");
    
    if (self.isPost) {
        
        [self PostRequestWithJS];

    }
    
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"didFailProvisionalNavigation");
    
}

/*

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"didReceiveServerRedirectForProvisionalNavigation");
    
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}




#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}

*/
@end
