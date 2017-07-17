//
//  ChouJiangListCell.m
//  NewApp
//
//  Created by gxtc on 2017/5/26.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "ChouJiangListCell.h"

@interface ChouJiangListCell()


@end


@implementation ChouJiangListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        [self addUI];
        
    }

    return self;
}


- (void)addUI{

    UILabel *  label1 = [self addCellRootLabelNewWithFram:CGRectMake(10, 0, ScreenWith/2 - 10, ScreenWith/10) andBackGroundColor:[UIColor clearColor] andTextColor:[UIColor lightGrayColor] andFont:14.0 andTitle:@"----" andNSTextAlignment:NSTextAlignmentLeft];
    label1.numberOfLines = 0;
    
    UILabel *  label2 = [self addCellRootLabelNewWithFram:CGRectMake(ScreenWith/2, 0, ScreenWith/2 - 10, ScreenWith/10) andBackGroundColor:[UIColor clearColor] andTextColor:[UIColor blackColor] andFont:15.0 andTitle:@"--------" andNSTextAlignment:NSTextAlignmentRight];
    label2.numberOfLines = 0;
    
    
    self.timeLabel = label1;
    self.titleLabel = label2;
    
    [self.contentView addSubview:label1];
    [self.contentView addSubview:label2];
}



- (void)setModel:(ChouJiangModel *)model{

    NSString * timeString = [self cellArticleTime:model.addtime];
    
    self.timeLabel.text = timeString;
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.remark];
}

@end
