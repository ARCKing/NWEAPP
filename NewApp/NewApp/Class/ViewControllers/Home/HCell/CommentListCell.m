//
//  CommentListCell.m
//  NewApp
//
//  Created by gxtc on 17/3/2.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "CommentListCell.h"

@interface CommentListCell()


@end


@implementation CommentListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        [self addUI];
        
    }
    

    return self;
}



- (void)setModel:(CommentListModel *)model{

    self.nickNameLabel.text = model.username;
    self.detailTextLabel.text = model.content;
    
    self.timeLabel.text = [self cellFinallyTime:model.addtime];


    NSInteger up = [model.up integerValue];
    
    [self.zanButton setTitle:[NSString stringWithFormat:@"%ld赞",up] forState:UIControlStateNormal];
    
}





- (void)addUI{


    UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 6, ScreenWith/12, ScreenWith/12)];
    icon.layer.cornerRadius = icon.bounds.size.width/2;
    icon.image = [UIImage imageNamed:@"head_icon"];
    [self.contentView addSubview:icon];
    self.imageV = icon;
    
    UILabel * nickName = [self addCellRootLabelNewWithFram:CGRectMake(CGRectGetMaxX(icon.frame)+5, 6, ScreenWith, 20) andBackGroundColor:[UIColor whiteColor] andTextColor:[UIColor blackColor] andFont:13.0 andTitle:@"" andNSTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:nickName];
    self.nickNameLabel = nickName;
    
    UIButton * respondBt = [self addCellRootButtonNewFram:CGRectMake(ScreenWith - 58, 6, 40, 20) andImageName:@"" andTitle:@"回复" andBackGround:[UIColor whiteColor] andTitleColor:[UIColor lightGrayColor] andFont:12.0 andCornerRadius:3.0];
    [self.contentView addSubview:respondBt];
    self.respondButton = respondBt;
    respondBt.layer.borderColor = [UIColor lightGrayColor].CGColor;
    respondBt.layer.borderWidth = 1.0;
    respondBt.clipsToBounds = YES;
    
    UIButton * zanBt = [self addCellRootButtonNewFram:CGRectMake(CGRectGetMinX(respondBt.frame) - 45, 6, 40, 20) andImageName:@"" andTitle:@"赞" andBackGround:[UIColor whiteColor] andTitleColor:[UIColor lightGrayColor] andFont:12.0 andCornerRadius:3.0];
    [self.contentView addSubview:zanBt];
    self.zanButton = zanBt;
    zanBt.layer.borderColor = [UIColor lightGrayColor].CGColor;
    zanBt.layer.borderWidth = 1.0;
    zanBt.clipsToBounds = YES;
    
    UILabel * number = [self addCellRootLabelNewWithFram:CGRectMake(CGRectGetMinX(zanBt.frame)- 102, 6, 100, 20) andBackGroundColor:[UIColor whiteColor] andTextColor:[UIColor blackColor] andFont:15.0 andTitle:@"1" andNSTextAlignment:NSTextAlignmentRight];
    self.numberLabel = number;
    [self.contentView addSubview:number];
    number.layer.cornerRadius = 3.0;
    number.clipsToBounds = YES;
//    number.backgroundColor = [UIColor redColor];
    
    UILabel * time = [self addCellRootLabelNewWithFram:CGRectMake(CGRectGetMinX(nickName.frame), CGRectGetMaxY(nickName.frame) + 5, 150, 10) andBackGroundColor:[UIColor whiteColor] andTextColor:[UIColor lightGrayColor] andFont:10.0 andTitle:@"1小时内" andNSTextAlignment:NSTextAlignmentLeft];
    self.timeLabel = time;
    [self.contentView addSubview:time];

    
    
    
    
    
    UILabel * detailTexts = [self addCellRootLabelNewWithFram:CGRectMake(CGRectGetMinX(nickName.frame),self.contentView.bounds.size.height - 20, ScreenWith * 3/4, 30) andBackGroundColor:[UIColor whiteColor] andTextColor:[UIColor blackColor] andFont:15.0 andTitle:@"" andNSTextAlignment:NSTextAlignmentLeft];
    self.detailComentTextLabel = detailTexts;


    UILabel * respondLabel = [self addCellRootLabelNewWithFram:CGRectMake(5,5, ScreenWith * 3/4, 30) andBackGroundColor:[UIColor whiteColor] andTextColor:[UIColor lightGrayColor] andFont:12.0 andTitle:@"我是回复" andNSTextAlignment:NSTextAlignmentLeft];
    
    self.respondLabel = respondLabel;
   
    
}


@end
