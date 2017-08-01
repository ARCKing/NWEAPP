//
//  LoginView.m
//  NewApp
//
//  Created by gxtc on 2017/8/1.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView


- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        [self addLoginViewNewWithTitle:nil];
        
    }
    
    return self;
}

- (void)addLoginViewNewWithTitle:(NSString *)title{
    
    /*
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, 64)];
    titleLabel.backgroundColor = [UIColor colorWithRed:0 green:191.0/255.0 blue:1.0 alpha:1.0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    */
    
    
    UIImageView * imagev = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_un_login"]];
    imagev.frame = CGRectMake(ScreenWith/4, ScreenWith/4, ScreenWith/3, ScreenWith/4);
    imagev.center = CGPointMake(ScreenWith/2,ScreenWith/2);
    [self addSubview:imagev];
    
    UIButton * bt = [self addViewRootButtonNewFram:CGRectMake(ScreenWith*2/5, CGRectGetMaxY(imagev.frame) + ScreenWith/12, ScreenWith/5, ScreenWith/12) andImageName:nil andTitle:@"点我登录" andBackGround: [UIColor clearColor]andTitleColor: [UIColor blackColor] andFont:16.0 andCornerRadius:2.0];
    bt.layer.cornerRadius = 3.0;
    bt.layer.backgroundColor = [UIColor clearColor].CGColor;
    bt.layer.borderWidth = 1.0;
    bt.layer.borderColor = [UIColor colorWithRed:0 green:191.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    [self addSubview:bt];
    
    self.loginBt = bt;
    
}



@end
