//
//  CommentListCell.h
//  NewApp
//
//  Created by gxtc on 17/3/2.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "RootTableViewCell.h"
#import "CommentListModel.h"

@interface CommentListCell : RootTableViewCell

@property (nonatomic,strong)UILabel * detailComentTextLabel;

@property (nonatomic,strong) UILabel * numberLabel;

@property (nonatomic,strong)UIButton * respondButton;

@property (nonatomic,strong)UIButton * zanButton;

@property (nonatomic,strong)CommentListModel * model;



@property (nonatomic,strong) UILabel * nickNameLabel;
@property (nonatomic,strong)UILabel * timeLabel;
@property (nonatomic,strong)UIImageView * imageV;

@property (nonatomic,strong)UILabel * respondLabel;





@end
