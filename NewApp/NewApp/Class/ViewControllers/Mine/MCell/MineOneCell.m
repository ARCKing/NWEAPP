//
//  MineOneCell.m
//  NewApp
//
//  Created by gxtc on 17/2/16.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "MineOneCell.h"

@interface MineOneCell()

@property (nonatomic,strong)UILabel * titleLabel;

@end

@implementation MineOneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addUI];
        
    }
    
    return self;
}


- (void)addUI{
    
    UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(15, ScreenWith/32, ScreenWith/16, ScreenWith/16)];
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(15 + ScreenWith/16 + 15, (ScreenWith/8 - 20)/2, ScreenWith/4, 20)];
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = [UIColor blackColor];
    
    [self.contentView addSubview:icon];
    [self.contentView addSubview:title];
    
    self.iconImageView = icon;
    self.titleLabel = title;
    
//    title.backgroundColor = [UIColor redColor];
//    icon.backgroundColor = [UIColor orangeColor];
    
}

- (void)addIcon:(NSString *)icon andTitle:(NSString *)title{

    self.iconImageView.image = [UIImage imageNamed:icon];
    self.titleLabel.text = title;
    
}


/**
 *金币
 */
- (void)showUserGoldAmount:(NSString *)goldNumber{
    

    if (!self.goldLabel) {
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 20)];
        self.goldLabel = label;
        
        [self.contentView addSubview:label];
        
        label.textAlignment = NSTextAlignmentRight;
        self.goldLabel.attributedText = [self addAttributedGoldNumber:goldNumber];
        [self.goldLabel sizeToFit];
        
        label.center = CGPointMake(ScreenWith - 28 - label.frame.size.width/2, ScreenWith/16 -3);

    }
    
    self.goldLabel.attributedText = [self addAttributedGoldNumber:goldNumber];
    [self.goldLabel sizeToFit];
     self.goldLabel.center = CGPointMake(ScreenWith - 28 -  self.goldLabel.frame.size.width/2, ScreenWith/16 -3);

    
}


/**
 *添加富文本
 */
- (NSMutableAttributedString *)addAttributedGoldNumber:(NSString *)num {
    
    NSMutableAttributedString * attributrdString = [[NSMutableAttributedString alloc]initWithString:num];
    
    
    NSRange range1 = [num rangeOfString:num];
    
    [attributrdString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, range1.length)];
    
    [attributrdString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, range1.length)];
    
    
    //   label图片对象设置
    NSTextAttachment * attch1 = [[NSTextAttachment alloc]init];
    
    attch1.image = [UIImage imageNamed:@"user_exchange_mark"];
    //    位置
    attch1.bounds = CGRectMake(0, -3, 22,22);
    
    
    //    转变成富文本对象
    NSAttributedString * imgString = [NSAttributedString attributedStringWithAttachment:attch1];
    
    [attributrdString insertAttributedString:imgString atIndex:0];
    
    
    return attributrdString;
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
