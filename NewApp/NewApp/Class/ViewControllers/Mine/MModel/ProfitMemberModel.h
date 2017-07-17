//
//  ProfitMemberModel.h
//  NewApp
//
//  Created by gxtc on 17/3/13.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "JSONModel.h"

@interface ProfitMemberModel : JSONModel

@property (nonatomic,copy)NSString <Optional> * sum_money;
@property (nonatomic,copy)NSString <Optional> * today_income;
@property (nonatomic,copy)NSString <Optional> * yesterDay_income;
@property (nonatomic,copy)NSString <Optional> * today_gg;
@property (nonatomic,copy)NSString <Optional> * yesterDay_gg;

@end
