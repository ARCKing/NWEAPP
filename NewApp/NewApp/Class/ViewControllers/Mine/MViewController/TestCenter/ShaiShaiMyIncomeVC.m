//
//  ShaiShaiMyIncomeVC.m
//  NewApp
//
//  Created by gxtc on 17/2/23.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "ShaiShaiMyIncomeVC.h"

@interface ShaiShaiMyIncomeVC ()

@property (nonatomic,strong)MBProgressHUD * HUD;

@property (nonatomic,copy)NSString * sum_money;
@property (nonatomic,copy)NSString * url;
@property (nonatomic,copy)NSString * imagurl;

@property (nonatomic,strong)UIImage * backGroundImage;
@property (nonatomic,strong)UIImage * shareImage;

@property (nonatomic,strong)MainShareView * shareView;
@end

@implementation ShaiShaiMyIncomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addUI];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD = hud;
    
    [self getDataFromNet];
}


//img_share_income.jpg

#pragma mark- 晒晒数据请求

- (void)getDataFromNet{

    NetWork * net = [NetWork shareNetWorkNew];

    [net shouTuLinkMessageFromNet];

    __weak ShaiShaiMyIncomeVC * weakSelf = self;
    
    net.shouTuLinkMessageBK=^(NSString * sum_money,NSString * url,NSString * imgurl ,NSArray * arr,NSArray * arrs){
    

        if (sum_money && url && imgurl) {
            
            weakSelf.sum_money = sum_money;
            weakSelf.url = url;
            weakSelf.imagurl = imgurl;
            
            

           
            SDWebImageManager * manger = [SDWebImageManager sharedManager];
            
            [manger.imageDownloader downloadImageWithURL:[NSURL URLWithString:imgurl] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                
                [weakSelf.HUD hideAnimated:YES];

                
                weakSelf.backGroundImage = image;
                
                [weakSelf creatImage];

            }];
            
        }
        
    
    };
}


- (void)addUI{
    [super addUI];
    self.titleLabel.text = @"晒晒我的收入";
    
}


- (void)creatImage{

    [self addImageViewNew];
    
    UIButton * shareBt = [self addRootButtonNewFram:CGRectMake(0, ScreenHeight - ScreenWith/8, ScreenWith, ScreenWith/8) andSel:@selector(shareButtonAction) andTitle:@"分享给好友"];
    shareBt.titleLabel.textColor =[ UIColor whiteColor];
    shareBt.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
    shareBt.layer.cornerRadius = 0.0;
    [self.view addSubview:shareBt];

    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [shareBt addSubview:line];
    
}



- (void)shareButtonAction{

    NSLog(@"分享");
    
    /*
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
    
    [shareV.QQShareButton addTarget:self action:@selector(rootQQShareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [shareV.QzoneShareButton addTarget:self action:@selector(rootQzoneShareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [shareV.cancleButton addTarget:self action:@selector(rootCancleButtonAction) forControlEvents:UIControlEventTouchUpInside];

    */
    
    //直接原生分享
    [self rootLocationWeiXinShareWithImage:self.shareImage andImageUrl:nil andString:nil andUrl:nil];

}



//取消分享
- (void)rootCancleButtonAction{
    
    [self.shareView.rightShareView removeFromSuperview];
    [self.shareView.shareBottomView removeFromSuperview];
    [self.shareView removeFromSuperview];
    
}


- (void)rootWeiXinShareButtonAction:(UIButton *)bt{
    
    [self.shareView removeFromSuperview];
    
    NSLog(@"微信分享！");
    
    
     [self rootLocationWeiXinShareWithImage:self.shareImage andImageUrl:nil andString:nil andUrl:nil];
    
    
}

- (void)rootQQShareButtonAction{
    [self.shareView removeFromSuperview];
    
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        [self shareImageToQQandQZoneWithImage:self.shareImage andType:UMSocialPlatformType_QQ];

    }else{
    
        [self rootLocationWeiXinShareWithImage:self.shareImage andImageUrl:nil andString:nil andUrl:nil];

    }
    
    
}

- (void)rootQzoneShareButtonAction{
    [self.shareView removeFromSuperview];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        
        [self shareImageToQQandQZoneWithImage:self.shareImage andType:UMSocialPlatformType_Qzone];
        
    }else{
        
        [self rootLocationWeiXinShareWithImage:self.shareImage andImageUrl:nil andString:nil andUrl:nil];
        
    }
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    [self.shareView.rightShareView removeFromSuperview];
    [self.shareView.shareBottomView removeFromSuperview];
    [self.shareView removeFromSuperview];
    
}











- (void)addImageViewNew{

    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, ScreenWith, ScreenHeight-64)];
    [self.view addSubview:imageV];

//    UIImage * image = [UIImage imageNamed:@"img_share_income.jpg"];
    
    UIImage * image = self.backGroundImage;

    
    CGSize size= CGSizeMake (image. size . width , image. size . height ); // 大小

    //图文合成
//    UIImage * newImage = [self addRootComposeTextAndImageWithText:[NSString stringWithFormat:@"￥:%@",self.sum_money] angImage:image andTextPoint:CGPointMake(size.width/3 - 20, size.width/4 - 10) andFontName:@"ArialRoundedMTBold" andFontSize:50 andTextColor:[UIColor redColor]];
    
    
    //二维码合成
    UIImageView * code = [self QrCodeWithViewFram:CGRectMake(0, 0, ScreenWith/2, ScreenWith /2) andCodeString:self.url];
//    code.center = CGPointMake(ScreenWith/2, ScreenHeight/2 + ScreenWith/4);
    
    CGSize size2= CGSizeMake (code.image. size . width*3/4,code.image. size . height*3/4); // 大小

    NSInteger screenWW = CurrentDeviceScreen;
    
    if (screenWW == 0) {
        
         size2= CGSizeMake (code.image. size . width,code.image. size . height); // 大小

    }else if (screenWW == 1) {
    
         size2= CGSizeMake (code.image. size . width*5/6,code.image. size . height*5/6); // 大小

    }else if (screenWW == 2){
    
         size2= CGSizeMake (code.image. size . width*3/4,code.image. size . height*3/4); // 大小

    }
    
    
    //合成新的分享二维码图
    UIImage * imageNew = [self addDownImages:image andUpImage:code.image andUpImageFram:CGRectMake(size.width - size2.width, size.height - size2.height,size2.width,size2.height)];
    
    imageV.image = imageNew;
    
    self.shareImage = imageNew;
}








@end
