//
//  MineQRCodeVC.m
//  NewApp
//
//  Created by gxtc on 2017/5/24.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "MineQRCodeVC.h"

@interface MineQRCodeVC ()

@property(nonatomic,copy)NSString * inviateUrl;

@end

@implementation MineQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self addUI];
    
    [self inviateLink];
}

- (void)addUI{
    [super addUI];
    
    self.navigationBarView.backgroundColor = [UIColor blackColor];
    self.titleLabel.text = @"我的二维码";
    self.titleLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:191.0/255.0 blue:255.0/255.0 alpha:1.0];
    
}




- (void)inviateLink{

    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net mineInviateCodeAndInviateLink];
    
    __weak MineQRCodeVC * weakSelf = self;
    
    net.mineInviateCodeAndInviteLinkBK=^(NSString * code,NSString * message,NSString * str,NSArray * arr1,NSArray * arr2){
        
        [hud hideAnimated:YES];
        
        if ([code isEqualToString:@"1"]) {
            
            if (arr1.count > 0) {
                
                weakSelf.inviateUrl = arr1[1];
                
                [weakSelf QRBGViewCreatNew];

            }
        }
    };


}


- (void)QRBGViewCreatNew{

    UIView * BGView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWith, ScreenHeight - 64)];
    BGView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.6];
    [self.view addSubview:BGView];
    
    UIView * whiteBGView = [[UIView alloc]initWithFrame:CGRectMake(20, ScreenWith/6, ScreenWith - 40, ScreenHeight*2/3)];
    whiteBGView.backgroundColor = [UIColor whiteColor];
    whiteBGView.layer.cornerRadius = 2.0;
    whiteBGView.layer.borderWidth = 1;
    whiteBGView.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:191.0/255.0 blue:255.0/255.0 alpha:0.5].CGColor;
    [BGView addSubview:whiteBGView];

    
    UIImageView * imageIconView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, ScreenWith/6, ScreenWith/6)];
    [imageIconView sd_setImageWithURL:[NSURL URLWithString:self.mineModel.headimgurl]];
    [whiteBGView addSubview:imageIconView];
    
    
    CGSize size =[self.mineModel.nickname sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    UILabel * nickName = [self addRootLabelWithfram:CGRectMake(CGRectGetMaxX(imageIconView.frame)+15, 20, size.width, ScreenWith/12) andTitleColor:[UIColor blackColor] andFont:16.0 andBackGroundColor:[UIColor clearColor] andTitle:self.mineModel.nickname];
    [whiteBGView addSubview:nickName];
    
    
    UIImageView * sex = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetMaxX(nickName.frame))+10, 20 + ScreenWith/48, ScreenWith/20, ScreenWith/20)];
    [whiteBGView addSubview:sex];

    if ([self.mineModel.sex isEqualToString:@"1"]) {
        
        sex.image = [UIImage imageNamed:@"sex_male"];
        
    }else{
        
       sex.image = [UIImage imageNamed:@"sex_woman"];

    }
    
    
    UILabel * ID = [self addRootLabelWithfram:CGRectMake(CGRectGetMaxX(imageIconView.frame)+15, CGRectGetMaxY(nickName.frame), ScreenWith/2, ScreenWith/12) andTitleColor:[UIColor lightGrayColor] andFont:14.0 andBackGroundColor:[UIColor clearColor] andTitle:[NSString stringWithFormat:@"编号:%@",self.mineModel.username]];
    [whiteBGView addSubview:ID];
    
  UIImageView * qrCode = [self addQRCodeImageViewNewWithView:whiteBGView andimage:imageIconView andInviateLink:self.inviateUrl];
    
    
    UIImageView * imageIconView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith/12, ScreenWith/12)];
    [imageIconView2 sd_setImageWithURL:[NSURL URLWithString:self.mineModel.headimgurl]];
    imageIconView2.center = CGPointMake(ScreenWith/4, ScreenWith/4);
    [qrCode addSubview:imageIconView2];
    
    
    UILabel * little = [self addRootLabelWithfram:CGRectMake(0, CGRectGetMaxY(qrCode.frame) + ScreenWith/20,ScreenWith-40, ScreenWith/10) andTitleColor:[UIColor lightGrayColor] andFont:14.0 andBackGroundColor:[UIColor clearColor] andTitle:@"扫一扫上面的二维码图案"];
    little.textAlignment = NSTextAlignmentCenter;
    [whiteBGView addSubview:little];

    
}



#pragma mark- 二维码
/**二维码*/
- (UIImageView *)addQRCodeImageViewNewWithView:(UIView * )view andimage:(UIImageView *)image andInviateLink:(NSString *)urlLink{
    
    UIImageView * QRCode = [self QrCodeWithViewFram:CGRectMake((ScreenWith - 40 - ScreenWith/2)/2,CGRectGetMaxY(image.frame) + ScreenWith/8,(ScreenWith)/2,(ScreenWith )/2) andCodeString:urlLink];
    
    [view addSubview:QRCode];
    
    return QRCode;
}

@end
