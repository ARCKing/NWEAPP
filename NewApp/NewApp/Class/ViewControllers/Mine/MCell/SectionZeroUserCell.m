//
//  SectionZeroUserCell.m
//  NewApp
//
//  Created by gxtc on 17/2/16.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "SectionZeroUserCell.h"

@interface SectionZeroUserCell()


@end

@implementation SectionZeroUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addUI];
        
    }
    
    return self;
}


- (void)addUI{
    
    [self scrollViewNew];
    
    [self loginViewNew:self.scrollView];
    [self unLoginViewNew:self.scrollView];
    
}

- (void)scrollViewNew{

    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenWith/4)];
    [self.contentView addSubview:scrollView];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = NO;
    scrollView.contentSize = CGSizeMake(ScreenWith * 2, 0);
    
        

    self.scrollView = scrollView;
    
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setSelected:)];
    [scrollView addGestureRecognizer:tapGR];
}


- (void)loginViewNew:(UIScrollView *)scrollView{
    UIView * loginView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenWith/4)];
    [scrollView addSubview:loginView];
    
    UIImageView * iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, ScreenWith/4 - 30, ScreenWith/4 - 30)];
    [loginView addSubview:iconImageView];
    iconImageView.backgroundColor = [UIColor clearColor];
    iconImageView.image = [UIImage imageNamed:@"head_icon"];
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15 + ScreenWith/4 - 30 + 10, 20, ScreenWith/2, 15)];
    [loginView addSubview:nameLabel];
    nameLabel.textAlignment = NSTextAlignmentLeft;
//    nameLabel.backgroundColor = [UIColor orangeColor];
    nameLabel.font = [UIFont systemFontOfSize:14.0];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.text = @"159****4712";
    
    /*
    UIImageView * sexImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15 + ScreenWith/4 - 30 + ScreenWith/4, 20, 15, 15)];
    [loginView addSubview:sexImageView];
    sexImageView.image = [UIImage imageNamed:@"sex_male"];
//    sexImageView.backgroundColor = [UIColor redColor];
    
    UILabel * lvLabel = [[UILabel alloc]initWithFrame:CGRectMake(15 + ScreenWith/4 - 30 + ScreenWith/4 + 15 + 5, 20, 30, 15)];
    [loginView addSubview:lvLabel];
    lvLabel.text = @"Lv1";
    lvLabel.textColor = [UIColor whiteColor];
    lvLabel.font = [UIFont systemFontOfSize:14];
    lvLabel.textAlignment = NSTextAlignmentCenter;
    lvLabel.backgroundColor = [UIColor orangeColor];
    lvLabel.layer.cornerRadius = 3;
    lvLabel.clipsToBounds = YES;
    
//    UIImageView * readArticleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15 + ScreenWith/4 - 30, ScreenWith/8, ScreenWith/4, 20)];
//    [self.contentView addSubview:readArticleImageView];
//    readArticleImageView.image = [UIImage imageNamed:@"feed_detail_button2_normal"];

    
    UILabel * todayReadLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 20)];
    
    todayReadLabel.attributedText = [self addCellInsertAttributedText1:@"今日阅读篇" andText2:@"0" andIndex:4 andColor1:[UIColor blackColor] andColor2:[UIColor cyanColor] andFont2:14.0 andFont2:14.0];
    
    [todayReadLabel sizeToFit];
    todayReadLabel.center = CGPointMake(25 + todayReadLabel.bounds.size.width/2 + ScreenWith/4 - 30, ScreenWith/5 - 10);
    [loginView addSubview:todayReadLabel];

    UILabel * allReadLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, ScreenWith/3, 20)];
    [loginView addSubview:allReadLabel];
    allReadLabel.text = @"总阅读0篇";
    allReadLabel.center = CGPointMake(todayReadLabel.center.x + ScreenWith/6 + 10 + todayReadLabel.bounds.size.width/2,todayReadLabel.center.y);
    allReadLabel.textColor = [UIColor lightGrayColor];
    allReadLabel.font = [UIFont systemFontOfSize:13];
//    allReadLabel.backgroundColor = [UIColor orangeColor];
    
    */
    
    /*
    self.sex = sexImageView;
    self.lvLabel = lvLabel;
    self.todayReadLabel = todayReadLabel;
    self.totalReadLabel = allReadLabel;
    */
    
    
    UILabel * ID = [self addCellRootLabelNewWithFram:CGRectMake(0, 0, ScreenWith/2, ScreenWith/10) andBackGroundColor:[UIColor clearColor] andTextColor:[UIColor blackColor] andFont:15.0 andTitle:@"编号:------" andNSTextAlignment:NSTextAlignmentLeft];
    [loginView addSubview:ID];
//    ID.layer.borderWidth = 1.0;
//    ID.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    ID.clipsToBounds = YES;
    
    ID.center =CGPointMake(25 + ID.bounds.size.width/2 + ScreenWith/4 - 30, ScreenWith/5 - 10);
    

    
    UIImageView * QrCode = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"erweima"]];
    QrCode.frame = CGRectMake(0, 0, ScreenWith/15, ScreenWith/15);
    QrCode.center = CGPointMake(ScreenWith - 30 - ScreenWith/30, ScreenWith/8);
    [loginView addSubview:QrCode];
    
    self.userIconImage = iconImageView;
    self.nameLabel = nameLabel;
    self.IDLabel = ID;
    self.QRimage = QrCode;
    
}


- (void)unLoginViewNew:(UIScrollView *)scrollView{
    UIView * unLoginView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWith, 0, ScreenWith, ScreenWith/4)];
    [scrollView addSubview:unLoginView];

    
    UIImageView * iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, ScreenWith/4 - 30, ScreenWith/4 - 30)];
    [unLoginView addSubview:iconImageView];
    iconImageView.backgroundColor = [UIColor clearColor];
    iconImageView.image = [UIImage imageNamed:@"head_icon"];
    
    UILabel * text = [[UILabel alloc]initWithFrame:CGRectMake(15 + ScreenWith/4 - 30, ScreenWith/8 - 10, ScreenWith/4, 20)];
    [unLoginView addSubview:text];
    text.textAlignment = NSTextAlignmentCenter;
    //    nameLabel.backgroundColor = [UIColor orangeColor];
    text.font = [UIFont systemFontOfSize:15];
    text.textColor = [UIColor blackColor];
    text.text = @"未登录";

    
    UIButton * bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [unLoginView addSubview:bt];
    bt.frame = CGRectMake(ScreenWith - ScreenWith/5 - 30, ScreenWith/8 - 15, ScreenWith/5, 30);
    [bt setTitle:@"登录/注册" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1] forState:UIControlStateNormal];
    bt.backgroundColor = [UIColor clearColor];
    bt.titleLabel.font = [UIFont systemFontOfSize:15];
    bt.layer.cornerRadius = 2.0;
    bt.clipsToBounds = YES;
    bt.layer.borderColor = [UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1].CGColor;
    bt.layer.borderWidth = 1.0;
    [bt sizeToFit];
    self.loginBt = bt;
}


/**
 *添加富文本
 */
- (NSMutableAttributedString *)addAttributedText:(NSString *)str andArticleNum:(NSString *)num{
    
    NSMutableAttributedString * attributrdString1 = [[NSMutableAttributedString alloc]initWithString:str];
    NSMutableAttributedString * attributrdString2 = [[NSMutableAttributedString alloc]initWithString:num];

    
    NSRange range1 = [str rangeOfString:str];
    NSRange range2 = [num rangeOfString:num];

    [attributrdString1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, range1.length)];
    
    [attributrdString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, range1.length)];
    
    [attributrdString2 addAttribute:NSForegroundColorAttributeName value:[UIColor cyanColor] range:NSMakeRange(0,range2.length)];
    [attributrdString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, range2.length)];
    
    
    [attributrdString1 insertAttributedString:attributrdString2 atIndex:3];
    
    return attributrdString1;
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
