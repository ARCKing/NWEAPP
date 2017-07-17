//
//  IncomeDetailCell.m
//  NewApp
//
//  Created by gxtc on 17/2/23.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "IncomeDetailCell.h"


@interface IncomeDetailCell()

@property(nonatomic,strong)UILabel * title;
@property(nonatomic,strong)UILabel * coinLabel;
@property(nonatomic,strong)UILabel * moneyLabel;
@property(nonatomic,strong)UILabel * timeLabel;

@end

@implementation IncomeDetailCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addUI];
        
    }
    
    return self;
}


- (void)setModel:(ProfitDetailModel *)model{


    self.title.text = [NSString stringWithFormat:@"[ %@ ]",model.remark];
    self.coinLabel.attributedText = [self Label1:[NSString stringWithFormat:@"%@()",model.money] andLabel2:@"+1"];
//    self.moneyLabel.text = model.o_money;

    self.timeLabel.text = [self cellArticleTime:model.addtime];
    self.timeLabel.numberOfLines = 1;
    [self.timeLabel sizeToFit];
}



- (void)setModel1:(TaskAndInviateIncomeModel *)model1{

    self.title.text = [NSString stringWithFormat:@"[ %@ ]",model1.remark];
    self.coinLabel.attributedText = [self Label1:[NSString stringWithFormat:@"%@()",model1.money] andLabel2:@"+1"];
//    self.moneyLabel.text = model1.o_money;
    
    self.timeLabel.text = [self cellArticleTime:model1.addtime];
    self.timeLabel.numberOfLines = 1;
    [self.timeLabel sizeToFit];

}


- (void)addUI{

    UILabel * titleLabel = [self addCellRootLabelNewWithFram:CGRectMake(20, 0, ScreenWith/2 -20, ScreenWith/16) andBackGroundColor:[UIColor clearColor] andTextColor:[UIColor blackColor] andFont:12 andTitle:@"[点赞记录]" andNSTextAlignment:NSTextAlignmentLeft];
    self.title = titleLabel;
    
    UILabel * dateLabel = [self addCellRootLabelNewWithFram:CGRectMake(20, ScreenWith/16, ScreenWith/2 -20, ScreenWith/16) andBackGroundColor:[UIColor clearColor] andTextColor:[UIColor lightGrayColor] andFont:12 andTitle:@"2017-02-23" andNSTextAlignment:NSTextAlignmentLeft];
    self.timeLabel = dateLabel;
    
    
    UILabel * coinAndTimes = [self newLabeNewLabel1:@"+20()" andLabel2:@"+1"];
    coinAndTimes.frame = CGRectMake(ScreenWith /2, ScreenWith/32, ScreenWith/2 - 20, ScreenWith/16);
    coinAndTimes.textAlignment = NSTextAlignmentRight;
    self.coinLabel = coinAndTimes;
    
    /*
    UILabel * redLabel = [self addCellRootLabelNewWithFram:CGRectMake(ScreenWith * 2/3, ScreenWith/32, ScreenWith/3, ScreenWith/16) andBackGroundColor:[UIColor clearColor] andTextColor:[UIColor redColor] andFont:12 andTitle:@"￥0.02" andNSTextAlignment:NSTextAlignmentCenter];
    self.moneyLabel = redLabel;
    */
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:dateLabel];
    [self.contentView addSubview:coinAndTimes];
//    [self.contentView addSubview:redLabel];

}


- (UILabel *)newLabeNewLabel1:(NSString *)str1 andLabel2:(NSString *)str2{

    NSRange  range = [str1 rangeOfString:str1];
    
    
    UILabel * label = [[UILabel alloc]init];
    
    NSMutableAttributedString * strNew = [self addCellInsertAttributedText1:str1 andText2:str2 andIndex:range.length-1 andColor1:[UIColor blackColor] andColor2:[UIColor redColor] andFont2:12 andFont2:12];

    label.attributedText = strNew;
    
    return label;
}


- (NSAttributedString * )Label1:(NSString *)str1 andLabel2:(NSString *)str2{

    NSRange  range = [str1 rangeOfString:str1];

    NSMutableAttributedString * strNew = [self addCellInsertAttributedText1:str1 andText2:str2 andIndex:range.length-1 andColor1:[UIColor blackColor] andColor2:[UIColor redColor] andFont2:12 andFont2:12];

    return strNew;
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
