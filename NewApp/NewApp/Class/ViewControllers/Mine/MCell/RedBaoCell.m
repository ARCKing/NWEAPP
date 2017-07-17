//
//  RedBaoCell.m
//  NewApp
//
//  Created by gxtc on 2017/6/8.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "RedBaoCell.h"

@interface RedBaoCell()



@property (nonatomic,strong)UILabel * z_number;
@property (nonatomic,strong)UILabel * z_money;
@property (nonatomic,strong)UILabel * gift_money;
@property (nonatomic,strong)UILabel * limit;

@property (nonatomic,strong)UIView * lightGray;
@property (nonatomic,strong)UIView * orange;

@end

@implementation RedBaoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        
        [self addUI];
    }
    
    return self;
}



- (void)setModel:(RedBaoModel *)model{

    
    if (self.getFinish) {
        
        [self.orange addSubview:self.lightGray];
    
    }else{
    
        [self.lightGray removeFromSuperview];
    }
    
    
    NSString * num = [NSString stringWithFormat:@"%@个,",model.z_number];
    self.z_number.attributedText = [self addCellAppandRootAttributedText1:@"累计发放" andText2:num andColor1:[UIColor lightGrayColor] andColor2:[UIColor redColor] andFont2:16.0 andFont2:16.0];
    
    NSString * money = [NSString stringWithFormat:@"%@元",model.z_money];
    self.z_money.attributedText = [self addCellAppandRootAttributedText1:@"合计" andText2:money andColor1:[UIColor lightGrayColor] andColor2:[UIColor redColor] andFont2:16.0 andFont2:16.0];

    self.gift_money.text = [NSString stringWithFormat:@"%@元",model.gift_money];
    
    self.limit.text = [NSString stringWithFormat:@"要求每天转发收入>%@元",model.limit];
    
}


- (void)addUI{
    
    UIView * BGView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, ScreenWith - 20, ScreenWith/2)];
    BGView.backgroundColor = [UIColor whiteColor];
    BGView.layer.borderWidth = 1.0;
    BGView.layer.borderColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0].CGColor;
    BGView.layer.cornerRadius = 3.0;
    
    [self.contentView addSubview:BGView];
    
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(15, ScreenWith/20, ScreenWith - 50, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [BGView addSubview:line];
    
    UILabel * label1 = [self addCellRootLabelNewWithFram:CGRectMake((ScreenWith - 20)/3, 0, (ScreenWith - 20)/3, ScreenWith/10) andBackGroundColor:[UIColor whiteColor] andTextColor:[UIColor redColor] andFont:16.0 andTitle:@"每天抢红包" andNSTextAlignment:NSTextAlignmentCenter];
    [BGView addSubview:label1];
    
    
    UILabel * label2 = [self addCellRootLabelNewWithFram:CGRectMake(0, CGRectGetMaxY(label1.frame), (ScreenWith - 20)/2, ScreenWith/12) andBackGroundColor:[UIColor whiteColor] andTextColor:[UIColor redColor] andFont:16.0 andTitle:@"累计发放30918个" andNSTextAlignment:NSTextAlignmentRight];
    [BGView addSubview:label2];
    self.z_number = label2;
    
    
    UILabel * label22 = [self addCellRootLabelNewWithFram:CGRectMake((ScreenWith - 20)/2, CGRectGetMaxY(label1.frame), (ScreenWith - 20)/2, ScreenWith/12) andBackGroundColor:[UIColor whiteColor] andTextColor:[UIColor redColor] andFont:16.0 andTitle:@",合计4386.74元" andNSTextAlignment:NSTextAlignmentLeft];
    [BGView addSubview:label22];
    self.z_money = label22;

    
    UIView * orange = [[UIView alloc]initWithFrame:CGRectMake((ScreenWith - 20)/4, CGRectGetMaxY(label2.frame), (ScreenWith - 20)/2, ScreenWith/5)];
    orange.backgroundColor = [UIColor orangeColor];
    [BGView addSubview:orange];
    self.orange = orange;
    
    UIView * lightGray = [[UIView alloc]initWithFrame:CGRectMake(0,0, (ScreenWith - 20)/2, ScreenWith/5)];
    lightGray.backgroundColor = [UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:0.8];
    self.lightGray = lightGray;
    
    
    
    
    UILabel * label3 = [self addCellRootLabelNewWithFram:CGRectMake((ScreenWith - 20)/4, CGRectGetMaxY(orange.frame), (ScreenWith - 20)/2, ScreenWith/15) andBackGroundColor:[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0] andTextColor:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0] andFont:14.0 andTitle:@"要求:每天转发收入>8元" andNSTextAlignment:NSTextAlignmentCenter];
    [BGView addSubview:label3];
    self.limit = label3;
    
    UIImageView * imageB = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_redB"]];
    imageB.frame = CGRectMake(10, 10, ScreenWith/8, ScreenWith/7);
    [orange addSubview:imageB];
    
    
    UILabel * label4 = [self addCellRootLabelNewWithFram:CGRectMake(CGRectGetMaxX(imageB.frame), 10, (ScreenWith - 20)/2 - ScreenWith/8 - 10, ScreenWith/15) andBackGroundColor:[UIColor clearColor] andTextColor:[UIColor whiteColor] andFont:14.0 andTitle:@"金额随机" andNSTextAlignment:NSTextAlignmentLeft];
    [orange addSubview:label4];
    
    UILabel * label44 = [self addCellRootLabelNewWithFram:CGRectMake(CGRectGetMaxX(imageB.frame), 10 + ScreenWith/15, (ScreenWith - 20)/2 - ScreenWith/8 - 10, ScreenWith/15) andBackGroundColor:[UIColor clearColor] andTextColor:[UIColor whiteColor] andFont:14.0 andTitle:@"0.8元-10元" andNSTextAlignment:NSTextAlignmentLeft];
    [orange addSubview:label44];
    
    self.gift_money = label44;
    
//    UIButton * bt = [self addCellRootButtonNewFram:CGRectMake(0, 0, (ScreenWith - 20)/2, ScreenWith/5) andImageName:nil andTitle:nil andBackGround:[UIColor clearColor] andTitleColor:[UIColor clearColor] andFont:0.0 andCornerRadius:0.0];
//    [orange addSubview:bt];
    
    
}



@end
