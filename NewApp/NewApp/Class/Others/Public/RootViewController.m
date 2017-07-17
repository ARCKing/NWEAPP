//
//  RootViewController.m
//  NewApp
//
//  Created by gxtc on 17/2/13.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()<UITextViewDelegate>

@property (strong,nonatomic)UILabel * showMessageLabel;

@property (strong,nonatomic)UIButton * shareButton;

@end

@implementation RootViewController


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
}


#pragma mark-设备标识号
- (NSString *)RootGetDeciceUUID{
    
    NSString * uuid = [GSKeyChainDataManager readUUID];
    
    NSLog(@"GSKeyChainDataManager = %@",uuid);
    
    if (!uuid) {
        
        NSString *deviceUUID = [[UIDevice currentDevice].identifierForVendor UUIDString];
        
        [GSKeyChainDataManager saveUUID:deviceUUID];
        
        uuid = deviceUUID;
        
        NSLog(@"GSKeyChainDataManager = %@",[GSKeyChainDataManager readUUID]);
        
    }
    
    return uuid;
}



- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];

}



- (void)NoNet{

    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];

    NSString * netStatus = dict[@"net"];
    
    NSLog(@"%@",dict);
    
    
    if ([netStatus isEqualToString:@"1"]) {
        
        [self.noNetView removeFromSuperview];
        
    }else if (self.noNetView == nil) {
        
        [self NoNetViewNew];
        
    }else{
    
        
        [self.view addSubview:self.noNetView];
        
        [self.view bringSubviewToFront:self.noNetView];

    }
    
}


- (void)userDefaultsNoNet:(BOOL)ok{

    if (ok) {
        
        [self.noNetView removeFromSuperview];

    }else{
    
        if (self.noNetView == nil) {
            
            [self NoNetViewNew];
        
        }else{
    
            [self.view addSubview:self.noNetView];
            
            [self.view bringSubviewToFront:self.noNetView];
        }
    }


}



- (BOOL)netBool{

    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSLog(@"%@",dict);
    
    NSString * netStatus = dict[@"net"];

    if ([netStatus isEqualToString:@"1"]) {

        return YES;
        
    }else{
    
        return NO;
    }
    
}


- (void)NoNetViewNew{


    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenHeight)];
    view.backgroundColor = [UIColor whiteColor];
    self.noNetView = view;
    
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWith/2 - ScreenWith/10, ScreenHeight/3, ScreenWith/5,ScreenWith/5)];
    image.image =[UIImage imageNamed:@"noNet"];
    
    
    UILabel * label = [self addRootLabelWithfram:CGRectMake(ScreenWith/2 - ScreenWith/8, CGRectGetMaxY(image.frame)+10, ScreenWith/4, ScreenWith/15) andTitleColor:[UIColor lightGrayColor] andFont:16.0 andBackGroundColor:[UIColor clearColor] andTitle:@"网络异常"];
    label.textAlignment = NSTextAlignmentCenter;
    
    UIButton * bt = [self addRootButtonTypeTwoNewFram:CGRectMake(ScreenWith/2 - ScreenWith/8,CGRectGetMaxY(label.frame)+10, ScreenWith/4, ScreenWith/10) andImageName:nil andTitle:@"点击设置" andBackGround:[UIColor clearColor] andTitleColor:[UIColor lightGrayColor] andFont:16.0 andCornerRadius:2.0];
    bt.layer.borderWidth = 1.0;
    bt.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [bt addTarget:self action:@selector(NoNetAction) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:image];
    [view addSubview:label];
    [view addSubview:bt];
    
    [self.view addSubview:view];
    
    [self.view bringSubviewToFront:view];
}


- (void)NoNetAction{

    NSLog(@"网络异常，点我刷新！！！！！");

    //prefs:root=MOBILE_DATA_SETTINGS_ID
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    
    NSURL *url10 = [NSURL URLWithString:[NSString stringWithFormat:@"App-Prefs:root=MOBILE_DATA_SETTINGS_ID"]];

    NSURL *url9 = [NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=MOBILE_DATA_SETTINGS_ID"]];

    if ([[UIApplication sharedApplication] canOpenURL:url10]) {
        
        [[UIApplication sharedApplication] openURL:url10];
        
    }else if ([[UIApplication sharedApplication] canOpenURL:url9]){
    
        [[UIApplication sharedApplication] openURL:url9];

    }else{
    
        [[UIApplication sharedApplication] openURL:url];

    }
    
    
}





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isComment = YES;
    
    [self rootCheckLoginToken];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
#pragma mark- 添加网络监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoNet) name:@"NoNet" object:nil];
    
}


- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


/**审核隐藏状态监测*/
- (void)rootReviewStateCheckFromNet{
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net hidenWhenReviewFromNet];
    
    __weak RootViewController * weakSelf = self;
    
    net.hidenWhenReviewBK = ^(NSString * code, NSString * data) {
        
        if ([data isEqualToString:@"1"]) {
            
            [weakSelf.shareButton setTitle:@"分享赚" forState:UIControlStateNormal];
            
        }
        
    };
    
}



- (void)addUI{

    [self addNavBarNew];
}


/**网络状态监测*/
- (void)checkNetWorkingStatus{

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * dic = [defaults objectForKey:@"userInfo"];
    NSString * netStatus = dic[@"net"];
    
    if ([netStatus isEqualToString:@"1"]) {
    
        self.netStatus = YES;
        
    }else{
    
        self.netStatus = NO;
    }
}


- (void)addNavBarNew{
    
    self.navigationBarView = [self NavBarViewNew];
    self.navigationBarView.backgroundColor =[UIColor whiteColor];
    [self addTitleLabelNew];
    [self addLeftBarButtonNew];
    [self addLineNew];
    
}




- (void)viewWillLayoutSubviews{
    if (self.navigationBarView) {
        self.navigationBarView.frame = CGRectMake(0, 0, ScreenWith, 64);
        [self.view addSubview:self.navigationBarView];
    }

}

- (UIView *)NavBarViewNew{
    UIView * barView = [[UIView alloc]init];
    barView.backgroundColor = [UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1];
    return barView;
}



- (void)addLeftBarButtonNew{
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 25, 34, 34);
    [self.navigationBarView addSubview:leftButton];
    [leftButton addTarget:self action:@selector(leftBarButtonAction) forControlEvents:UIControlEventTouchUpInside];

    [leftButton setImage:[UIImage imageNamed:@"leftArrows"] forState:UIControlStateNormal];
    
    self.leftNavBarButton = leftButton;
    
//    leftButton.backgroundColor = [UIColor orangeColor];
}


- (void)addRightBarButtonNew{
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(ScreenWith - ScreenWith/12 , 30, ScreenWith/12, ScreenWith/15);
    [self.navigationBarView addSubview:rightButton];
    [rightButton addTarget:self action:@selector(rightBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"threePoint"] forState:UIControlStateNormal];

//    rightButton.backgroundColor = [UIColor orangeColor];
}


- (void)addRightBarClearButtonNew:(NSString *)titles{
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(ScreenWith - ScreenWith/5 - 5 , 30, ScreenWith/5, ScreenWith/15);
    [self.navigationBarView addSubview:rightButton];
    [rightButton addTarget:self action:@selector(rightBarClearButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:titles forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    //    rightButton.backgroundColor = [UIColor orangeColor];
}

- (void)leftBarButtonAction{
    NSLog(@"left");
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)rightBarButtonAction{
    NSLog(@"right");
    

    
}


- (void)rightBarClearButtonAction{
    NSLog(@"clear");

}

- (void)addTitleLabelNew{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWith * 3 /4, 20)];
    label.center = CGPointMake(ScreenWith/2, 32 + 10);
    label.font = [UIFont systemFontOfSize:16];
//    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.navigationBarView addSubview:label];
    label.text = @"Loading...";
    self.titleLabel = label;
}


- (void)addLineNew{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 63.5, ScreenWith, 0.5)];
    view.backgroundColor = [UIColor colorWithRed:18.0/255.0 green:139.0/255.0 blue:214.0/255.0 alpha:1];
    [self.navigationBarView addSubview:view];
}





- (NSMutableAttributedString *)addAppandRootAttributedText:(NSString *)str andArticleNum:(NSString *)num
                                                 andColor1:(UIColor *)color1
                                                  andColor2:(UIColor *)color2{
    
    NSMutableAttributedString * attributrdString1 = [[NSMutableAttributedString alloc]initWithString:str];
    NSMutableAttributedString * attributrdString2 = [[NSMutableAttributedString alloc]initWithString:num];
    
    
    NSRange range1 = [str rangeOfString:str];
    NSRange range2 = [num rangeOfString:num];
    
    [attributrdString1 addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0, range1.length)];
    
    [attributrdString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, range1.length)];
    
    [attributrdString2 addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(0,range2.length)];
    [attributrdString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, range2.length)];
    
    
    [attributrdString1 appendAttributedString:attributrdString2];
    
    return attributrdString1;
}



- (NSMutableAttributedString *)addRootAttributedText:(NSString *)str andArticleNum:(NSString *)num{
    
    NSMutableAttributedString * attributrdString1 = [[NSMutableAttributedString alloc]initWithString:str];
    NSMutableAttributedString * attributrdString2 = [[NSMutableAttributedString alloc]initWithString:num];
    
    
    NSRange range1 = [str rangeOfString:str];
    NSRange range2 = [num rangeOfString:num];
    
    [attributrdString1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, range1.length)];
    
    [attributrdString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, range1.length)];
    
    [attributrdString2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1] range:NSMakeRange(0,range2.length)];
    [attributrdString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, range2.length)];
    
    
    [attributrdString1 insertAttributedString:attributrdString2 atIndex:4];
    
    return attributrdString1;
}


- (UIButton *)addRootButtonNewFram:(CGRect)fram andSel:(SEL)sel andTitle:(NSString *)title{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = fram;
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.layer.cornerRadius = fram.size.height/2;
    button.clipsToBounds = YES;
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UILabel *)addRootLabelWithfram:(CGRect)fram andTitleColor:(UIColor *)color andFont:(CGFloat)size andBackGroundColor:(UIColor *)backColor andTitle:(NSString *)text{
    
    UILabel * label = [[UILabel alloc]initWithFrame:fram];
    label.backgroundColor = backColor;
    label.textColor = color;
    label.text =  text;
    label.font = [UIFont systemFontOfSize:size];
    
    return label;
}



- (NSMutableAttributedString *)addRootAppandAttributedText1:(NSString *)text1 andText2:(NSString *)text2
                                                      andColor1:(UIColor *)color1
                                                      andColor2:(UIColor *)color2
                                                       andFont1:(CGFloat)font1 andFont2:(CGFloat)font2{
    
    NSMutableAttributedString * attributrdString1 = [[NSMutableAttributedString alloc]initWithString:text1];
    NSMutableAttributedString * attributrdString2 = [[NSMutableAttributedString alloc]initWithString:text2];
    
    
    NSRange range1 = [text1 rangeOfString:text1];
    NSRange range2 = [text2 rangeOfString:text2];
    
    [attributrdString1 addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0, range1.length)];
    
    [attributrdString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font1] range:NSMakeRange(0, range1.length)];
    
    [attributrdString2 addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(0,range2.length)];
    [attributrdString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font2] range:NSMakeRange(0, range2.length)];
    
    
    [attributrdString1 appendAttributedString:attributrdString2];
    
    return attributrdString1;
}



- (NSMutableAttributedString *)addRootInsertAttributedText1:(NSString *)text1 andText2:(NSString *)text2 andIndex:(NSUInteger)index andColor1:(UIColor *)color1
    andColor2:(UIColor *)color2 andFont1:(CGFloat)font1 andFont2:(CGFloat)font2{
    
    NSMutableAttributedString * attributrdString1 = [[NSMutableAttributedString alloc]initWithString:text1];
    NSMutableAttributedString * attributrdString2 = [[NSMutableAttributedString alloc]initWithString:text2];
    
    
    NSRange range1 = [text1 rangeOfString:text1];
    NSRange range2 = [text2 rangeOfString:text2];
    
    [attributrdString1 addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0, range1.length)];
    
    [attributrdString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font1] range:NSMakeRange(0, range1.length)];
    
    [attributrdString2 addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(0,range2.length)];
    [attributrdString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font2] range:NSMakeRange(0, range2.length)];
    
    
    [attributrdString1 insertAttributedString:attributrdString2 atIndex:index];
    
    return attributrdString1;
}


/**
 *图文合成
 */
- (UIImage *)addRootComposeTextAndImageWithText:(NSString *)text angImage:(UIImage *)image andTextPoint:(CGPoint)textPoint
                                    andFontName:(NSString *)fontName andFontSize:(CGFloat)fontSize
                                   andTextColor:(UIColor *)color{
    
    CGSize size= CGSizeMake (image. size . width , image. size . height ); // 画布大小
    
    UIGraphicsBeginImageContextWithOptions (size, NO , 0.0 );
    
    [image drawAtPoint : CGPointMake ( 0 , 0 )];
    
    // 获得一个位图图形上下文
    
    CGContextRef context= UIGraphicsGetCurrentContext ();
    
    CGContextDrawPath (context, kCGPathStroke );
                                                                                            //@"Arial-BoldMT"
    [text drawAtPoint : textPoint withAttributes : @{ NSFontAttributeName :[ UIFont fontWithName : fontName size : fontSize ], NSForegroundColorAttributeName :color } ];
    
    //画自己想画的内容。。。。。
    
    // 返回绘制的新图形
    
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
    
    UIGraphicsEndImageContext ();
    
    
    return newImage;
    
}


#pragma mark- 二维码
/**
 *生成二维码
 */
- (UIImageView *)QrCodeWithViewFram:(CGRect)fram andCodeString:(NSString *)codeString{
    
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认
    [filter setDefaults];
    
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    NSString *dataString = codeString;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    // 5.显示二维码
    //    self.imageView.image = [UIImage imageWithCGImage:outputImage];
    
    UIImageView * codeImageView = [[UIImageView alloc]initWithFrame:fram];
    //显示二维码
    codeImageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:ScreenWith/2];
    
    return codeImageView;
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    
    /**控制生成的二维码大小*/
    CGFloat scale = MIN(size/CGRectGetWidth(extent) * 1.3, size/CGRectGetHeight(extent) * 1.3);
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    
    UIImage * img = [UIImage imageWithCGImage:scaledImage];
    
    CGImageRelease(scaledImage);
    CGColorSpaceRelease(cs);
    return img;
}



#pragma mark- 二图叠加
/**
 *二图合成
 */
- (UIImage *)addDownImages:(UIImage *)image1 andUpImage:(UIImage *)image2 andUpImageFram:(CGRect)fram{
    
    UIImage * downImage = image1;
    UIImage * upImage = image2;
    
    UIGraphicsBeginImageContext(downImage.size);
    
    [downImage drawInRect:CGRectMake(0, 0, downImage.size.width, downImage.size.height)];
    [upImage drawInRect:fram];
    
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

/**
 *返回上一级页面
 */
- (void)popVC{

    [self.navigationController popViewControllerAnimated:YES];
}



//黑色提示框====
- (void)rootShowTheBlackMessageAleterNewWithFram:(CGRect)fram{
    
    self.showMessageLabel =  [self addRootLabelWithfram:fram andTitleColor:[UIColor whiteColor] andFont: 12 andBackGroundColor:[UIColor blackColor] andTitle:@"Message"];
    self.showMessageLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.showMessageLabel];
}


- (void)rootShowTheBlackMessageAlter:(NSString *)message{
    
    self.showMessageLabel.text = message;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.showMessageLabel.frame = CGRectMake(ScreenWith/2 - 50, 64, 100, 30);
    } completion:^(BOOL finished) {
        
        [self performSelector:@selector(rootDissmissMessageAleart) withObject:nil afterDelay:1.5];
        
    }];
}

- (void)rootDissmissMessageAleart{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.showMessageLabel.frame = CGRectMake(ScreenWith/2 - 50, -30, 100, 30);
        
    }];
}



#pragma mark- 时间戳计算
- (NSString *)rootFinallyTime:(NSString *)yetTime{
    
    NSDate * nowDate = [NSDate date];
    
    NSTimeInterval now = [nowDate timeIntervalSince1970];
    NSTimeInterval yet = [yetTime doubleValue];
    
    //    NSLog(@"yet = %.f",yet);
    //    NSLog(@"now = %.f",now);
    
    
    NSTimeInterval newTime = now - yet;
    //    NSLog(@"new = %.f",newTime);
    
    NSString * mm = [NSString stringWithFormat:@"%.2f",newTime/60];
    NSString * hh = [NSString stringWithFormat:@"%.2f",newTime/60/60];
    NSString * dd = [NSString stringWithFormat:@"%.2f",newTime/60/60/24];
    NSString * MM = [NSString stringWithFormat:@"%.2f",newTime/60/60/24/30];
    
    
    //    NSLog(@"mm =%@",mm);
    //    NSLog(@"hh =%@",hh);
    //    NSLog(@"dd =%@",dd);
    //    NSLog(@"MM =%@",MM);
    
    NSString * date;
    
    if ([MM floatValue] >= 1) {
        
        date = [NSString stringWithFormat:@"发布于%.f个月前",[MM floatValue]];
        
    }else if ([dd floatValue] >= 1) {
        
        date = [NSString stringWithFormat:@"发布于%.f天前",[dd floatValue]];
        
    }else if ([hh floatValue] >= 1) {
        
        date = [NSString stringWithFormat:@"发布于%.f小时前",[hh floatValue]];
        
    }else if ([mm floatValue] >= 1) {
        
        date = [NSString stringWithFormat:@"发布于%.f分钟前",[mm floatValue]];
        
    }else {
        
        date = [NSString stringWithFormat:@"发布于%.f秒前",newTime];
    }
    
    //    NSLog(@"%@",date);
    
    return date;
}


#pragma mark- 友盟QQ图片分享
- (void)shareImageToQQandQZoneWithImage:(UIImage *)image andType:(UMSocialPlatformType)type{


    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
//    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    [shareObject setShareImage:image];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];

}


#pragma mark- 分享-评论
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
                          andTitle:(NSString *)title
                        andContent:(NSString *)content
                            andUrl:(NSString *)webUrl
                     andThumbImage:(UIImage *)thumbImage
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:thumbImage];
    
//    shareObject.thumbImage = @"https://zqw.2662126.com/app/article/detail/id/126";
    
    //    [shareObject setThumbImage:[NSURL URLWithString:@"http://img.2662126.com/thumb/20170217/58a66ba81fa79.jpg@1e_226w_156h_1c_0i_1o_1x.png"]];
    
    //设置网页地址
    shareObject.webpageUrl =webUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error 分享失败! %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
            NSLog(@"分享成功");
            
        }
    }];
}



- (void)rootWebBottomViewNew{
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - ScreenWith/5 - 15, ScreenWith, ScreenWith/5 + 15)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
  
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:line];
    
    /*
    UIButton * commentBt = [self addRootButtonNewFram:CGRectMake(10, (ScreenWith/8 - ScreenWith/13)/2, ScreenWith/2, ScreenWith/13) andSel:@selector(rootWriteCommentButtonAction) andTitle:@"写评论..."];
    commentBt.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    [commentBt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    commentBt.layer.cornerRadius = ScreenWith/26;
    [bottomView addSubview:commentBt];
    
    
    UIButton * imageBt = [self addRootButtonNewFram:CGRectMake(CGRectGetMaxX(commentBt.frame) + 10, (ScreenWith/8 - 22)/2, 22, 22) andSel:@selector(rootCommentButtonAction) andTitle:@""];
    [imageBt setImage:[UIImage imageNamed:@"talk"] forState:UIControlStateNormal];
    [bottomView addSubview:imageBt];
    
    UILabel * comment = [self addRootLabelWithfram:CGRectMake(CGRectGetMaxX(imageBt.frame), 8, 40, 10) andTitleColor:[UIColor redColor] andFont:10.0 andBackGroundColor:[UIColor clearColor] andTitle:@"0"];
    self.commentCount = comment;
    comment.layer.cornerRadius = 3.0;
    comment.textAlignment = NSTextAlignmentLeft;
    [bottomView addSubview:comment];
    */
    
    UILabel * label = [self addRootLabelWithfram:CGRectMake(0, 1, ScreenWith, ScreenWith/10) andTitleColor:[UIColor lightGrayColor] andFont:14.0 andBackGroundColor:[UIColor clearColor] andTitle:@"分享到朋友圈,有人阅读即可获得相应奖励"];
    label.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:label];
    
    UIButton * shareButton = [self addRootButtonNewFram:CGRectMake(30, ScreenWith/10, ScreenWith - 60, ScreenWith/10) andSel:@selector(rootShareButtonAction) andTitle:@"分享赚钱"];
    shareButton.backgroundColor = [UIColor redColor];
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareButton.layer.cornerRadius = 2.0;
    [bottomView addSubview:shareButton];
    
    
//    [shareButton setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    
    self.shareButton = shareButton;
    
    
//    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(shareButton.frame), (ScreenWith/8 - ScreenWith/20)/2, 1, ScreenWith/20)];
//    line2.backgroundColor = [UIColor lightGrayColor];
//    [bottomView addSubview:line2];

    
}


- (void)rootShareButtonAction{

    NSLog(@"rootShareButtonAction");
}


- (void)rootCommentButtonAction{
    NSLog(@"rootCommentButtonAction");
    
    
    ComentListVC * vc = [[ComentListVC alloc]init];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}


- (void)rootWriteCommentButtonAction{
    NSLog(@"rootWriteCommentButtonAction");

}

- (void)rootCancleButtonAction{
    NSLog(@"rootCancleButtonAction");

}

- (void)rootAdvCancleButtonAction{
    NSLog(@"rootAdvCancleButtonAction");
}


- (void)rootWeiXinShareButtonAction:(UIButton *)bt{
    NSLog(@"rootWeiXinShareButtonAction");

}

- (void)rootQQShareButtonAction{
    NSLog(@"qq");

}

- (void)rootQzoneShareButtonAction{
    NSLog(@"qzone");
}

- (void)rootCopyLinkButtonAction{

    NSLog(@"copy");
}


- (void)rootShareEnterButtonAction{

    NSLog(@"确定");
}




- (void)rootLocationWeiXinShareWithImage:(UIImage *)image andImageUrl:(NSString *)imageUrl andString:(NSString *)str andUrl:(NSString *)url{

    NSArray *  activityIteam;
    
    if (image && str && url) {
        
        activityIteam = @[image,str,[NSURL URLWithString:url]];
        
    }else if (image){
        
        activityIteam = @[image];

    }else{
    
        return;
    }
    
    
    
    UIActivityViewController * activity = [[UIActivityViewController alloc]initWithActivityItems:activityIteam applicationActivities:nil];
    
    [self presentViewController:activity animated:YES completion:nil];
    
    activity.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError){
    
        if (completed) {
            NSLog(@"分享成功!");
        }else{
            
            NSLog(@"分享失败!");
        }
        
    };
    
}

- (UIButton *)addRootButtonTypeTwoNewFram:(CGRect)fram andImageName:(NSString * )imageName andTitle:(NSString *)title
                            andBackGround:(UIColor *)color1 andTitleColor:(UIColor *)color2 andFont:(CGFloat)font
                          andCornerRadius:(CGFloat)radius{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = fram;
    button.backgroundColor = color1;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color2 forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    button.layer.cornerRadius = radius;
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.clipsToBounds = YES;
    
    return button;
}



/*
- (void)addRootBarRigthShareViewNew{
    
    self.rightShareViewIsShow = YES;
    
    if (self.rightShareView) {
        
        [self.view addSubview:self.rightShareView];

        return;
    }
    
    NSArray * images = @[@"shares",@"unselstar",@"waring"];
    NSArray * titles = @[@"分享",@"收藏",@"举报"];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(ScreenWith *3/4 - 10, 66, ScreenWith/4, ScreenWith/3)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowOpacity = 0.8;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    self.rightShareView = view;
    
    [self.view addSubview:view];
    for (int i = 0; i < 3; i++) {
        
        
        UIButton * bt= [self addRootButtonTypeTwoNewFram:CGRectMake(0, ScreenWith/9 * i, ScreenWith/4, ScreenWith/9) andImageName:images[i] andTitle:titles[i] andBackGround:[UIColor whiteColor] andTitleColor:[UIColor lightGrayColor] andFont:16
                                         andCornerRadius:0.0];
        
        bt.imageEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
        bt.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -6);
        
        [view addSubview:bt];
        
        if (i == 0) {
            
            self.rightShareViewShareButton = bt;
            
        }else if (i == 1){
        
            self.rightShareViewcollectionButton = bt;

        }else{
            
            self.rightShareViewcollectionButton = bt;

        }
        
        
    }
    
}

*/


- (void)rootCollectionArticleButtonAction{

    NSLog(@"rootCollectionArticleButtonAction");
}

- (void)rootWarningButtonAction{

    NSLog(@"rootWarningButtonAction");

}


#pragma mark- 验证Token
/**验证Token*/
- (void)rootCheckLoginToken{

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



/**HUD文本提示框*/
- (void)rootShowMBPhudWith:(NSString *)message andShowTime:(NSTimeInterval)time{
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:16.0];
    hud.label.numberOfLines = 0;
    [hud hideAnimated:YES afterDelay:time];

};



#pragma mark- 评论输入框
/**评论输入框*/
- (void)addRootCommentViewNew{
    UIView * commentView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWith, ScreenWith/2)];
    commentView.backgroundColor = [UIColor whiteColor];
    commentView.layer.shadowOpacity = 0.8;
    commentView.layer.shadowOffset = CGSizeMake(0, 0);
    commentView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    
    
    UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, ScreenWith - 20, ScreenWith/3)];
    textView.layer.cornerRadius = 3.0;
    textView.backgroundColor = [UIColor clearColor];
    textView.clipsToBounds = YES;
    textView.layer.borderWidth = 1.0;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.font = [UIFont systemFontOfSize:16.0];
    
    textView.delegate = self;
    
    UILabel * placeHoldLabel = [self addRootLabelWithfram:CGRectMake(10, 12, ScreenWith - 20, ScreenWith/10) andTitleColor:[UIColor lightGrayColor] andFont:15.0 andBackGroundColor:[UIColor whiteColor] andTitle:@"  请文明发言，遵守评论规则。被选为神回复有额外奖励!"];
    placeHoldLabel.numberOfLines = 0;
    
    UIButton * cancleBt = [self addRootButtonTypeTwoNewFram:CGRectMake(10, ScreenWith/2 - 10 - 25, 50, 25) andImageName:@"" andTitle:@"取消" andBackGround:[UIColor whiteColor] andTitleColor:[UIColor blackColor] andFont:14.0 andCornerRadius:2.0];
    cancleBt.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cancleBt.layer.borderWidth = 1.0;
    
    UIButton * publishBt = [self addRootButtonTypeTwoNewFram:CGRectMake(ScreenWith - 10 - 50,  ScreenWith/2 - 10 - 25, 50, 25) andImageName:@"" andTitle:@"发布" andBackGround:[UIColor lightGrayColor] andTitleColor:[UIColor whiteColor] andFont:14.0 andCornerRadius:2.0];

      UILabel * worldNumber = [self addRootLabelWithfram:CGRectMake(CGRectGetMinX(publishBt.frame) - 10 - ScreenWith/3, ScreenWith/2 - 12 - 25, ScreenWith/3, 30) andTitleColor:[UIColor lightGrayColor] andFont:14.0 andBackGroundColor:[UIColor whiteColor] andTitle:@"0/200"];
    worldNumber.textAlignment = NSTextAlignmentRight;
    
    
    
    
    [commentView addSubview:placeHoldLabel];
    
    [commentView addSubview:textView];
    
    [commentView addSubview:cancleBt];
    
    [commentView addSubview:publishBt];

    [commentView addSubview:worldNumber];

    [self.view addSubview:commentView];
    
    self.commentView = commentView;
    self.textView = textView;
    self.placeHolderLabel = placeHoldLabel;
    self.commentViewCancleButton = cancleBt;
    self.commentViewPushButton = publishBt;
    self.woeldNumberLabel = worldNumber;
    
    
    [cancleBt addTarget:self action:@selector(rootCommentViewCancleButtonAvtion) forControlEvents:UIControlEventTouchUpInside];
    [publishBt addTarget:self action:@selector(rootCommentViewPushButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
}



- (void)rootCommentViewCancleButtonAvtion{
    
    NSLog(@"rootCommentViewCancleButtonAvtion");
}


- (void)rootCommentViewPushButtonAction{
    
    NSLog(@"rootCommentViewPushButtonAction");

}

#pragma mark- 时间计算
/**时间戳计算*/
- (NSString * )rootArticleTime:(NSString *)times{

    NSString *str=times;//时间戳
    //    NSTimeInterval time=[str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSTimeInterval time=[str doubleValue];
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * dateStr = [dateFormatter stringFromDate: detaildate];
    
    return dateStr;
}








#pragma mark-复制链接
/**复制链接*/
- (void)rootCopyLinkWith:(NSString *)link{
    
    NSLog(@"复制分享链接");
    
    if (link == nil) {
        
        link = @"0";
    }
    
    
    NSString * url = link;
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = url;
    
    if ((pasteboard.string != nil) && ![link isEqualToString:@"0"]) {
        
        UIAlertController * alertControll = [UIAlertController alertControllerWithTitle:@"复制成功" message:nil preferredStyle: UIAlertControllerStyleAlert];
        
        [self presentViewController:alertControll animated:YES completion:^{
            
            NSLog(@"提示框来了!");
            
        }];
        
        [self performSelector:@selector(removeAlerateFromSuperView:) withObject:self afterDelay:1];
        
        
    }else {
        UIAlertController * alertControll = [UIAlertController alertControllerWithTitle:@"复制失败" message:nil preferredStyle: UIAlertControllerStyleAlert];
        
        [self presentViewController:alertControll animated:YES completion:^{
            
            NSLog(@"提示框来了!");
            
        }];
        
        [self performSelector:@selector(removeAlerateFromSuperView:) withObject:self afterDelay:1];
        
    }
    
}

//提示框消失
- (void)removeAlerateFromSuperView:(UIAlertController *)alertControll{
    
    [alertControll dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark- 微信登录授权
- (void)RootGetAuthWithUserInfoFromWechat
{
    
    __weak RootViewController * weakSelf = self;
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
            NSLog(@"失败:%@",error);
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息-----注意这里的uid为unionID
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.gender);
            
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
            
            [weakSelf RootBindWeiChatAccountWith:resp.accessToken andOpenid:resp.openid andUnionid:resp.uid];
            
        }
    }];
}


- (void)RootBindWeiChatAccountWith:(NSString *)access_token andOpenid:(NSString *)openid andUnionid:(NSString *)unionid{



}








/**网络监测*/
- (void)RootAFNetworkStatus{
    //1.创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    __weak RootViewController * weakSelf = self;
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:{
                /*
                NSLog(@"未知网络状态");
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"未知网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                */
                
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"无网络");
                
                
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"无网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                
                
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"蜂窝数据网");
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"正在使用蜂窝数据网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                
                
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"WiFi网络");
                
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"网络" message:@"WiFi网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
               
            }
                
                break;
                
            default:
                break;
        }
        
    }] ;
    
}



#pragma mark- 获取当前网络状态
/**获取当前网络状态*/
- (BOOL)RootCurrentNetState{
    
    
    //    AFNetworkReachabilityStatusUnknown          = -1,
    //    AFNetworkReachabilityStatusNotReachable     = 0,
    //    AFNetworkReachabilityStatusReachableViaWWAN = 1,
    //    AFNetworkReachabilityStatusReachableViaWiFi = 2,
    
    
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    if (status == AFNetworkReachabilityStatusNotReachable) {
        
        return NO;
        
    }else{
        
        return YES;
    }
    
    
}

@end
