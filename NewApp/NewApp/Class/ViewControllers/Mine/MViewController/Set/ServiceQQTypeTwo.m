//
//  ServiceQQTypeTwo.m
//  NewApp
//
//  Created by gxtc on 2017/6/17.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "ServiceQQTypeTwo.h"

@interface ServiceQQTypeTwo ()

@property (nonatomic,assign)NSInteger type;

@property (nonatomic,copy)NSString * QQ;

@end

@implementation ServiceQQTypeTwo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.type = 0;
    
    [self addUI];
    
}

- (void)addUI{
    
    [super addUI];
    
    self.titleLabel.text = @"QQ";
    
    [self QQImage];
    
    [self usDataMessage];
    
    
    
}

//640454654

- (void)QQImage{
    
    UIImageView * qqImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith/8, ScreenWith/8)];
    qqImage.center = CGPointMake(ScreenWith/2, 69 + ScreenWith/16);
    qqImage.image = [UIImage imageNamed:@"QQQ"];
    [self.view addSubview:qqImage];
}


- (void)QQ1WithQQ1:(NSString *)qq{

    UILabel * label = [self addRootLabelWithfram:CGRectMake(0, 64 + ScreenWith/8, ScreenWith, ScreenWith/8) andTitleColor:[UIColor redColor] andFont:17.0 andBackGroundColor:[UIColor clearColor] andTitle:qq];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];

}



- (void)button1{
    UIButton * bt = [self addRootButtonNewFram:CGRectMake(ScreenWith/6, 64 + ScreenWith/8 + ScreenWith/8, ScreenWith*2/3, ScreenWith/10) andSel:@selector(buttonAction1) andTitle:@"联系客服"];
    bt.backgroundColor = [UIColor clearColor];
    bt.layer.cornerRadius = 0.0;
    bt.layer.borderWidth = 1.0;
    bt.layer.borderColor = [UIColor colorWithRed:0 green:191.0/255.0 blue:1.0 alpha:1.0].CGColor;
    [bt setTitleColor:[UIColor colorWithRed:0 green:191.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [self.view addSubview:bt];
}


- (void)QQ1WithQQ2:(NSString *)qq{
    
    UILabel * label = [self addRootLabelWithfram:CGRectMake(0, 64 + ScreenWith/8 + ScreenWith/8 + ScreenWith/8, ScreenWith, ScreenWith/8) andTitleColor:[UIColor redColor] andFont:17.0 andBackGroundColor:[UIColor clearColor] andTitle:qq];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
}


- (void)button2{
    UIButton * bt = [self addRootButtonNewFram:CGRectMake(ScreenWith/6, 64 + ScreenWith/8 + ScreenWith/8 + ScreenWith/8 + ScreenWith/8, ScreenWith*2/3, ScreenWith/10) andSel:@selector(buttonAction2) andTitle:@"加群"];
    bt.backgroundColor = [UIColor clearColor];
    bt.layer.cornerRadius = 0.0;
    bt.layer.borderWidth = 1.0;
    bt.layer.borderColor = [UIColor colorWithRed:0 green:191.0/255.0 blue:1.0 alpha:1.0].CGColor;
    [bt setTitleColor:[UIColor colorWithRed:0 green:191.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [self.view addSubview:bt];
}



- (void)buttonAction1{

    [self qqChatActionWitnUin:self.QQ];

}



- (void)qqChatActionWitnUin:(NSString *)uin{
    
    NSLog(@"qqChat");
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    // 提供uin, 你所要联系人的QQ号码
    NSString *qqstr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",self.QQ];
    NSURL *url = [NSURL URLWithString:qqstr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}




//640454654
- (void)buttonAction2{
    
    [self joinGroup:@"640454654" key:@""];
    
}


//加群
- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key{
    
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", groupUin,key];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    else return NO;
}


-(void)usDataMessage{
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net aboutUsMessageFromNet];
    
    __weak ServiceQQTypeTwo * weakSelf = self;
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    net.aboutUsBK= ^(NSString * code,NSString * message,NSString * str, NSArray * dataArray,NSArray * data){
        
        [hud hideAnimated:YES];
        
        if (dataArray.count > 0) {
            
            AboutUsModel * model = dataArray[0];
            
            NSLog(@"%@",model);
            
            if (weakSelf.type == 0) {
                
                weakSelf.QQ = model.kf_qq;
                
                [weakSelf QQ1WithQQ1:weakSelf.QQ];
                
                [weakSelf button1];
                
                [weakSelf QQ1WithQQ2:[NSString stringWithFormat:@"%@",model.gf]];

                [weakSelf button2];
                
            }else{
                

            }
            
        }
        
    };
    
}

@end
