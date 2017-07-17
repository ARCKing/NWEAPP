//
//  ChouJiangListCell.h
//  NewApp
//
//  Created by gxtc on 2017/5/26.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "RootTableViewCell.h"
#import "ChouJiangModel.h"
@interface ChouJiangListCell : RootTableViewCell

@property (nonatomic,strong)UILabel * timeLabel;
@property (nonatomic,strong)UILabel * titleLabel;


@property (nonatomic,strong)ChouJiangModel * model;

@end
