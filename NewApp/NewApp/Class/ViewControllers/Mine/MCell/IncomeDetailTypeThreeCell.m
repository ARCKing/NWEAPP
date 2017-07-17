//
//  IncomeDetailTypeThreeCell.m
//  NewApp
//
//  Created by gxtc on 2017/6/3.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "IncomeDetailTypeThreeCell.h"

@interface IncomeDetailTypeThreeCell()

@property(nonatomic,strong)UILabel * title1;

@property(nonatomic,strong)UILabel * title2;

@end

@implementation IncomeDetailTypeThreeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self addUI];
    }
    
    return self;
}



- (void)setTitleMessage:(NSString *)title1 andTitle2:(NSString *)title2{

   
    self.title1.text = title1;
    
    if ([title2 isEqualToString:@""]) {
        
        title2 = @"0.00";
    }
    
    
    title2 = [title2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    self.title2.text = [NSString stringWithFormat:@"%@元",title2];




}

- (void)addUI{

    UILabel * title1 = [self addCellRootLabelNewWithFram:CGRectMake(10, 0, ScreenWith/3, ScreenWith/8) andBackGroundColor:[UIColor clearColor] andTextColor:[UIColor blackColor] andFont:18.0 andTitle:@"累计转发收入" andNSTextAlignment:NSTextAlignmentLeft];
    
    UILabel * title2 = [self addCellRootLabelNewWithFram:CGRectMake(ScreenWith - ScreenWith/2 - 35, 0, ScreenWith/2, ScreenWith/8) andBackGroundColor:[UIColor clearColor] andTextColor:[UIColor redColor] andFont:16.0 andTitle:@"0.00元" andNSTextAlignment:NSTextAlignmentRight];

    
    self.title1 = title1;
    self.title2 = title2;
    
    [self.contentView addSubview:title1];
    [self.contentView addSubview:title2];
    
}


@end
