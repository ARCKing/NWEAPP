//
//  PersonCommentCell.h
//  NewApp
//
//  Created by gxtc on 17/3/6.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "RootTableViewCell.h"
#import "PersonCenterModel.h"

@interface PersonCommentCell : RootTableViewCell

@property (nonatomic,strong)UILabel * detailComentTextLabel;

@property (nonatomic,strong)UIImageView * imageV;
@property (nonatomic,strong)UILabel * timeLabel;


@property (nonatomic,strong) UILabel * numberLabel;
@property (nonatomic,strong) UILabel * nickNameLabel;
@property (nonatomic,strong) PersonCenterModel * pModel;

@property (nonatomic,strong)UILabel * articleTitleLabel;

@end
