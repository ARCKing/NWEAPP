//
//  ArticleRankCell.m
//  NewApp
//
//  Created by gxtc on 17/2/16.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "ArticleRankCell.h"

@interface ArticleRankCell()

@property(nonatomic,strong)UILabel * headTitleLabel;
@property(nonatomic,strong)UILabel * LittleTitleLabel;
@property(nonatomic,strong)UIImageView * rightImageView;


@end

@implementation ArticleRankCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addUI];
        
    }
    
    return self;
}


- (void)addUI{
    
 
    
    UILabel * title1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenWith *2/3 - 20, ScreenWith/8)];
    title1.numberOfLines = 0;
    title1.textColor = [UIColor blackColor];
    title1.font = [UIFont systemFontOfSize:16];
    
    UILabel * title2 = [[UILabel alloc]initWithFrame:CGRectMake(10, ScreenWith/4 - 15, ScreenWith/2, 15)];
    title2.textColor = [UIColor lightGrayColor];
    title2.font = [UIFont systemFontOfSize:13];
    
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWith - ScreenWith/3, 10, ScreenWith/3 - 10, ScreenWith/4)];
    
    UILabel * number = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWith/22, ScreenWith/22)];
    number.textColor = [UIColor whiteColor];
    number.font = [UIFont systemFontOfSize:13];
    number.textAlignment = NSTextAlignmentCenter;
    number.layer.cornerRadius = 3.0;
    number.clipsToBounds = YES;

    
    //    title1.backgroundColor = [UIColor redColor];
    //    title2.backgroundColor = [UIColor purpleColor];
    //    imageV.backgroundColor = [UIColor orangeColor];
    
    
    [self.contentView addSubview:title1];
    [self.contentView addSubview:title2];
    [self.contentView addSubview:imageV];
    [title1 addSubview:number];
    
    
    self.headTitleLabel = title1;
    self.LittleTitleLabel = title2;
    self.rightImageView = imageV;
    self.numberRankLabel = number;
    
    NSString * str = @"收到公司大股东是广东省公司的收到广东省啊沙发上个人购房对方得分为丰富";
    title1.text = [NSString stringWithFormat:@"     %@",str];
    title2.text = @"凤凰科技 阅读3872";
    imageV.image = [UIImage imageNamed:@"launchImage.jpg"];
    number.text = @"1";
    number.backgroundColor = [UIColor orangeColor];
}


- (void)setModel:(ArticleListModel *)model{

    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"img_loading.jpg"]];

    self.headTitleLabel.text = [NSString stringWithFormat:@"     %@", model.title];
    self.LittleTitleLabel.text = [NSString stringWithFormat:@"阅读:%@",model.view_count];
    
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
