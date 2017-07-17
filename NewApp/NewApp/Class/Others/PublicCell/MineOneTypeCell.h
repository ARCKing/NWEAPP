//
//  MineOneTypeCell.h
//  NewApp
//
//  Created by gxtc on 17/2/14.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleListModel.h"
#import "PersonCenterModel.h"
#import "RootTableViewCell.h"
@interface MineOneTypeCell : RootTableViewCell

@property (nonatomic,strong)ArticleListModel * articleListModel;

@property (nonatomic,strong)PersonCenterModel * personModel;


@property (nonatomic,assign)BOOL isShareRecord;

@end
