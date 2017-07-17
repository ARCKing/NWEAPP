//
//  SectionThreeCell.m
//  NewApp
//
//  Created by gxtc on 17/3/11.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "SectionThreeCell.h"

@implementation SectionThreeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addUI];
        
    }
    
    return self;
}


- (void)addUI{
    
    
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(10, (ScreenWith/8 - 20)/2, 20, 20)];
    [self.contentView addSubview:image];
    image.backgroundColor = [UIColor whiteColor];
    
    
    UILabel * title = [self addCellRootLabelNewWithFram:CGRectMake(10 + 20 + 5, (ScreenWith/8 - 20)/2, ScreenWith/4, 20) andBackGroundColor:[UIColor clearColor] andTextColor:[UIColor lightGrayColor] andFont:15.0 andTitle:@"标题" andNSTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:title];
   
    
    
    UILabel * coinLabel = [self addCellRootLabelNewWithFram:CGRectMake(ScreenWith - ScreenWith/4 - 20, (ScreenWith/8 - 20)/2, ScreenWith/4, 20) andBackGroundColor:[UIColor clearColor] andTextColor:[UIColor lightGrayColor] andFont:13.0 andTitle:@"+5000金币" andNSTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:coinLabel];
    
    /*
    UILabel * middleLabel = [self addCellRootLabelNewWithFram:CGRectMake(CGRectGetMinX(coinLabel.frame) - ScreenWith/5, (ScreenWith/8 - 20)/2, ScreenWith/5, 20) andBackGroundColor:[UIColor clearColor] andTextColor:[UIColor lightGrayColor] andFont:13.0 andTitle:@"无限制" andNSTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:middleLabel];
    */

    
    UILabel * explainLabel = [self addCellRootLabelNewWithFram:CGRectMake(30, ScreenWith/8, ScreenWith - 60, 10) andBackGroundColor:[UIColor clearColor] andTextColor:[UIColor lightGrayColor] andFont:13.0 andTitle:@"解释" andNSTextAlignment:NSTextAlignmentLeft];
    
    [self.contentView addSubview:explainLabel];
    
    explainLabel.alpha = 0;
    
    self.icon = image;
    self.title = title;
    self.coinLabel = coinLabel;
//    self.middleLabel = middleLabel;
    self.explainLabel = explainLabel;
    
}

@end
