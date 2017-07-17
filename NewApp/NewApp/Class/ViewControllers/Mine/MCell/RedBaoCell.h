//
//  RedBaoCell.h
//  NewApp
//
//  Created by gxtc on 2017/6/8.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "RootTableViewCell.h"
#import "RedBaoModel.h"
@interface RedBaoCell : RootTableViewCell

@property (nonatomic,strong)RedBaoModel * model;

@property (nonatomic,assign)BOOL getFinish;

@end
