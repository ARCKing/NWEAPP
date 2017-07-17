//
//  IncomeDetailTypeTwoCell.m
//  NewApp
//
//  Created by gxtc on 2017/6/3.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "IncomeDetailTypeTwoCell.h"

@interface IncomeDetailTypeTwoCell()

@property(nonatomic,strong)UIImageView * icon;
@property(nonatomic,strong)UILabel * nickName;
@property(nonatomic,strong)UILabel * titless;
@property(nonatomic,strong)UILabel * money;
@property(nonatomic,strong)UILabel * time;

@end

@implementation IncomeDetailTypeTwoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        
        [self addUI];
    }
    
    return self;
}


- (void)setIconURL:(NSString *)url AndModelData:(TaskAndInviateIncomeModel *)model{

    [self.icon sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"head_icon"]];

    self.nickName.text = @"我";
    
    self.time.text = [self cellArticleTime:model.addtime];
    
    self.titless.text = model.remark;
    
    self.money.text = model.money;
}


- (void)addUI{
    
    UIView * BGView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, ScreenWith - 20, ScreenWith/5)];
    BGView.backgroundColor = [UIColor whiteColor];
    
    BGView.layer.borderWidth = 1.0;
    BGView.layer.borderColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0].CGColor;
    BGView.layer.cornerRadius = 3.0;

    [self.contentView addSubview:BGView];
    
    
    UIImageView * icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"head_icon"]];
    icon.frame = CGRectMake(10, 10, ScreenWith/5 - 20, ScreenWith/5 - 20);
    icon.layer.cornerRadius = ScreenWith/10 - 10;
    icon.clipsToBounds = YES;
    [BGView addSubview:icon];
    
    
    UILabel * nickName = [self addCellRootLabelNewWithFram:CGRectMake(CGRectGetMaxX(icon.frame)+10, ScreenWith/10 - ScreenWith/15, ScreenWith/7, ScreenWith/15) andBackGroundColor:[UIColor clearColor] andTextColor:[UIColor redColor] andFont:14.0 andTitle:@"我" andNSTextAlignment:NSTextAlignmentLeft];
    
    UILabel * time = [self addCellRootLabelNewWithFram:CGRectMake(CGRectGetMaxX(nickName.frame)+10, ScreenWith/10- ScreenWith/15, ScreenWith/2, ScreenWith/15) andBackGroundColor:[UIColor clearColor] andTextColor:[UIColor lightGrayColor] andFont:12.0 andTitle:@"05-19 10:44" andNSTextAlignment:NSTextAlignmentLeft];

    UILabel * titles = [self addCellRootLabelNewWithFram:CGRectMake(CGRectGetMaxX(icon.frame)+10, ScreenWith/10, ScreenWith/2, ScreenWith/15) andBackGroundColor:[UIColor clearColor] andTextColor:[UIColor blackColor] andFont:15.0 andTitle:@"幸运抽奖-幸运抽奖" andNSTextAlignment:NSTextAlignmentLeft];

    UILabel * money = [self addCellRootLabelNewWithFram:CGRectMake(ScreenWith-20-ScreenWith/5 - 10, ScreenWith/10 - ScreenWith/20, ScreenWith/5, ScreenWith/15) andBackGroundColor:[UIColor clearColor] andTextColor:[UIColor redColor] andFont:13.0 andTitle:@"+0.43元" andNSTextAlignment:NSTextAlignmentRight];

    
    [BGView addSubview:nickName];
    [BGView addSubview:time];
    [BGView addSubview:titles];
    [BGView addSubview:money];
    
    self.icon = icon;
    self.time = time;
    self.titless = titles;
    self.money = money;
    self.nickName = nickName;
}

@end
