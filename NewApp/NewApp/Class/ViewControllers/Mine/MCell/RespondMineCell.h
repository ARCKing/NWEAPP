//
//  RespondMineCell.h
//  NewApp
//
//  Created by gxtc on 17/3/13.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "RootTableViewCell.h"
#import "RespondToMineModel.h"

@interface RespondMineCell : RootTableViewCell

@property (nonatomic,strong)UILabel * detailComentTextLabel;

@property (nonatomic,strong) UILabel * numberLabel;

@property (nonatomic,strong)RespondToMineModel * model;


@property (nonatomic,strong) UILabel * nickNameLabel;
@property (nonatomic,strong)UILabel * timeLabel;
@property (nonatomic,strong)UIImageView * imageV;

@property (nonatomic,strong)UILabel * respondLabel;
@property (nonatomic,strong)UILabel * articleLabel;
@end
