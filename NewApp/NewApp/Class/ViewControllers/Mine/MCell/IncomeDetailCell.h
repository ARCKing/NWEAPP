//
//  IncomeDetailCell.h
//  NewApp
//
//  Created by gxtc on 17/2/23.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootTableViewCell.h"
#import "ProfitDetailModel.h"
#import "TaskAndInviateIncomeModel.h"

@interface IncomeDetailCell : RootTableViewCell

@property (nonatomic,strong)ProfitDetailModel * model;

@property (nonatomic,strong)TaskAndInviateIncomeModel * model1;

@end
