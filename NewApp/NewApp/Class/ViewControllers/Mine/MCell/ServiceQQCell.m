//
//  ServiceQQCell.m
//  NewApp
//
//  Created by gxtc on 2017/6/3.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "ServiceQQCell.h"

@interface ServiceQQCell()



@end

@implementation ServiceQQCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addUI];
    }
    
    return self;
}


- (void)setDataWithQQNumber:(NSString *)QQ{

    self.QQLabel.text = [NSString stringWithFormat:@"%@",QQ];

}


- (void)addUI{

    UIImageView * imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"QQQ"]];
    imageV.frame = CGRectMake(ScreenWith/2 - ScreenWith/20, ScreenWith/8 - ScreenWith/10, ScreenWith/10, ScreenWith/10);
    [self.contentView addSubview:imageV];
 
    UILabel * qq = [self addCellRootLabelNewWithFram:CGRectMake(0, ScreenWith/8, ScreenWith, ScreenWith/8) andBackGroundColor:[UIColor clearColor] andTextColor:[UIColor colorWithRed:1.0 green:99.0/255.0 blue:71.0/255.0 alpha:1.0] andFont:20.0 andTitle:@"--- --- " andNSTextAlignment:NSTextAlignmentCenter];
    self.QQLabel = qq;
    [self.contentView addSubview:qq];
}


@end
