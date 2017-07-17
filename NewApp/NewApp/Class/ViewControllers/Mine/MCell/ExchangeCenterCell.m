//
//  ExchangeCenterCell.m
//  聊天界面
//
//  Created by root on 17/3/20.
//  Copyright © 2017年 root. All rights reserved.
//

#import "ExchangeCenterCell.h"

#define Screen_W [UIScreen mainScreen].bounds.size.width
#define Screen_H [UIScreen mainScreen].bounds.size.height

@implementation ExchangeCenterCell


//- (instancetype)initWithFrame:(CGRect)frame{
//
//
//    self = [super initWithFrame:frame];
//    
//    if (self) {
//        
//        [self addUI];
//    }
//
//    return self;
//}



- (void)addUI{

    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (Screen_W - 15)/2, ((Screen_W - 15)/2)*2/3)];
    imageV.backgroundColor = [UIColor cyanColor];
    [self.contentView.layer addSublayer:imageV.layer];
    
}


@end
