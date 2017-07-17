//
//  PersonCommentCell.m
//  NewApp
//
//  Created by gxtc on 17/3/6.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "PersonCommentCell.h"

@implementation PersonCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        [self addUI];
        
    }
    
    
    return self;
}



- (void)setPModel:(PersonCenterModel *)pModel{

    self.nickNameLabel.text = pModel.username;
    self.timeLabel.text = [self cellFinallyTime:pModel.addtime];
    self.detailComentTextLabel.text = pModel.content;

    NSDictionary * article = pModel.article;

    if (article) {
        self.articleTitleLabel.text = [NSString stringWithFormat:@"原文:%@",article[@"title"]];

    }else{
    
        self.articleTitleLabel.text = [NSString stringWithFormat:@""];
    }
}



- (void)addUI{
    
    
    UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, ScreenWith/8, ScreenWith/8)];
    icon.layer.cornerRadius = icon.bounds.size.width/2;
    icon.backgroundColor = [UIColor clearColor];
    icon.image = [UIImage imageNamed:@"head_icon"];
    [self.contentView addSubview:icon];
    self.imageV = icon;
    
    UILabel * nickName = [self addCellRootLabelNewWithFram:CGRectMake(CGRectGetMaxX(icon.frame)+5, 6, ScreenWith, 20) andBackGroundColor:[UIColor whiteColor] andTextColor:[UIColor blackColor] andFont:13.0 andTitle:@"你" andNSTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:nickName];
    self.nickNameLabel = nickName;
    
    
    UILabel * time = [self addCellRootLabelNewWithFram:CGRectMake(CGRectGetMinX(nickName.frame), CGRectGetMaxY(nickName.frame)+5, 150, 10) andBackGroundColor:[UIColor whiteColor] andTextColor:[UIColor lightGrayColor] andFont:10.0 andTitle:@"1小时内" andNSTextAlignment:NSTextAlignmentLeft];
    self.timeLabel = time;
    [self.contentView addSubview:time];
    
    
    UILabel * detailTexts = [self addCellRootLabelNewWithFram:CGRectMake(CGRectGetMinX(nickName.frame),CGRectGetMaxY(time.frame)+5, ScreenWith * 3/4, 30) andBackGroundColor:[UIColor whiteColor] andTextColor:[UIColor lightGrayColor] andFont:15.0 andTitle:@"现在的人到那里也要预防小偷" andNSTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:detailTexts];
    self.detailComentTextLabel = detailTexts;
    [detailTexts sizeToFit];
    
    
    UILabel * detailTitle = [self addCellRootLabelNewWithFram:CGRectMake(CGRectGetMinX(nickName.frame),CGRectGetMaxY(detailTexts.frame)+5, ScreenWith * 3/4, 20) andBackGroundColor:[UIColor lightGrayColor] andTextColor:[UIColor blackColor] andFont:12.0 andTitle:@"现在的人到那里也要预防小偷" andNSTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:detailTitle];
//    [detailTitle sizeToFit];
    detailTitle.numberOfLines = 1;
    self.articleTitleLabel = detailTitle;

    
    
    //    nickName.backgroundColor = [UIColor orangeColor];
    //    respondBt.backgroundColor =[UIColor redColor];
    //    zanBt.backgroundColor =[UIColor cyanColor];
    //    number.backgroundColor = [UIColor redColor];
    //    time.backgroundColor = [UIColor orangeColor];
    //    detailTexts.backgroundColor = [UIColor purpleColor];
    
    
}


@end
