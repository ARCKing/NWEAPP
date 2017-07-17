//
//  RespondMineCell.m
//  NewApp
//
//  Created by gxtc on 17/3/13.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "RespondMineCell.h"

@implementation RespondMineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        [self addUI];
        
    }
    
    
    return self;
}



- (void)setModel:(RespondToMineModel *)model{
    
    self.nickNameLabel.text = model.tourist_nickname;
    
    self.timeLabel.text = [self cellFinallyTime:model.addtime];
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.tourist_headimgurl] placeholderImage:[UIImage imageNamed:@"key"]];
    
    
}





- (void)addUI{
    
    
    UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 6, ScreenWith/12, ScreenWith/12)];
    icon.layer.cornerRadius = icon.bounds.size.width/2;
    icon.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:icon];
    self.imageV = icon;
    
    UILabel * nickName = [self addCellRootLabelNewWithFram:CGRectMake(CGRectGetMaxX(icon.frame)+5, 6, ScreenWith, 20) andBackGroundColor:[UIColor whiteColor] andTextColor:[UIColor blackColor] andFont:13.0 andTitle:@"" andNSTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:nickName];
    self.nickNameLabel = nickName;
    
    
    UILabel * number = [self addCellRootLabelNewWithFram:CGRectMake(ScreenWith - 30, 6, 20, 20) andBackGroundColor:[UIColor lightGrayColor] andTextColor:[UIColor whiteColor] andFont:15.0 andTitle:@"1" andNSTextAlignment:NSTextAlignmentCenter];
    self.numberLabel = number;
    [self.contentView addSubview:number];
    number.layer.cornerRadius = 3.0;
    number.clipsToBounds = YES;
    //    number.backgroundColor = [UIColor redColor];
    
    UILabel * time = [self addCellRootLabelNewWithFram:CGRectMake(CGRectGetMinX(nickName.frame), CGRectGetMaxY(nickName.frame) + 5, 150, 10) andBackGroundColor:[UIColor whiteColor] andTextColor:[UIColor lightGrayColor] andFont:10.0 andTitle:@"1小时内" andNSTextAlignment:NSTextAlignmentLeft];
    self.timeLabel = time;
    [self.contentView addSubview:time];
    
    
    
    
    UILabel * respondLabel = [self addCellRootLabelNewWithFram:CGRectMake(5,5, ScreenWith * 3/4, 30) andBackGroundColor:[UIColor whiteColor] andTextColor:[UIColor lightGrayColor] andFont:13.0 andTitle:@"我是回复" andNSTextAlignment:NSTextAlignmentLeft];
    
    self.respondLabel = respondLabel;
    
    
    UILabel * detailTexts = [self addCellRootLabelNewWithFram:CGRectMake(CGRectGetMinX(nickName.frame),self.contentView.bounds.size.height - 20, ScreenWith * 3/4, 30) andBackGroundColor:[UIColor whiteColor] andTextColor:[UIColor blackColor] andFont:14.0 andTitle:@"" andNSTextAlignment:NSTextAlignmentLeft];
    self.detailComentTextLabel = detailTexts;
    
    
    UILabel * articleLabel = [self addCellRootLabelNewWithFram:CGRectMake(10, 0, ScreenWith *3/4, ScreenWith/15) andBackGroundColor:[UIColor blackColor] andTextColor:[UIColor whiteColor] andFont:14.0 andTitle:@"我是文章标题" andNSTextAlignment:NSTextAlignmentLeft];
    articleLabel.layer.cornerRadius = ScreenWith/30;
    articleLabel.clipsToBounds = YES;
    self.articleLabel = articleLabel;
    
    
}


@end
