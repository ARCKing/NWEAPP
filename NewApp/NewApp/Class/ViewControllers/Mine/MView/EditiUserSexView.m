//
//  EditiUserSexView.m
//  NewApp
//
//  Created by gxtc on 17/2/21.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "EditiUserSexView.h"

@implementation EditiUserSexView

- (instancetype)initWithFrame:(CGRect)frame{
    
    
    if (self = [super initWithFrame:frame]) {
        
        //        self.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
        self.backgroundColor = [UIColor whiteColor];
        
        [self addUI];
    }
    return self;
}



- (void)addUI{

    NSArray * sex = @[@"男",@"女"];
    NSArray * icon = @[@"sex_male",@"sex_woman"];
    
    for (int i = 0; i < 2; i++) {
        
        UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:icon[i]]];
        image.frame = CGRectMake(0,0, ScreenWith/10, ScreenWith/10);
        image.center = CGPointMake(ScreenWith/20 + 20, ScreenWith/5 * i + 64);
        [self addSubview:image];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:sex[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(0,0, ScreenWith/6, ScreenWith/6);
        button.center = CGPointMake(ScreenWith - ScreenWith/12 - 20, ScreenWith/5 * i + 64);
        button.layer.cornerRadius = ScreenWith/12;
        button.clipsToBounds = YES;
//        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor lightGrayColor];
        
        button.tag = 1110 + i;
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        
        [self addSubview:button];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith/3, 0.5)];
        if (i == 0) {
            line.backgroundColor = [UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0];

            self.manButton = button;
            
        }else{
            line.backgroundColor = [UIColor magentaColor];

            self.womanButton = button;
        }
        
        line.center = CGPointMake(ScreenWith/2, ScreenWith/5 * i + 64);
        [self addSubview:line];
    
//        if (i == 1) {
//            button.backgroundColor = [UIColor lightGrayColor];
//        }
    }
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    button.frame = CGRectMake(0,0, ScreenWith/2, 30);
    button.center = CGPointMake(ScreenWith/2, ScreenWith/2 + ScreenWith/12);
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    button.backgroundColor = [UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTintColor:[UIColor whiteColor]];
    [self addSubview:button];

    self.saveSexButton = button;
}



@end
