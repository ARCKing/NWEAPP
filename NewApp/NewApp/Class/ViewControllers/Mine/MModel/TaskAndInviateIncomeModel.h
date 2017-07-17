//
//  TaskAndInviateIncomeModel.h
//  NewApp
//
//  Created by gxtc on 2017/5/31.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "JSONModel.h"

@interface TaskAndInviateIncomeModel : JSONModel

@property(nonatomic,assign) int id;
@property(nonatomic,copy)NSString <Optional> * member_id;
@property(nonatomic,copy)NSString <Optional> * action;
@property(nonatomic,copy)NSString <Optional> * money;
@property(nonatomic,copy)NSString <Optional> * addtime;

@property(nonatomic,copy)NSString <Optional> * remark;
@property(nonatomic,copy)NSString <Optional> * re_member_id;
@property(nonatomic,copy)NSString <Optional> * account_state;
@property(nonatomic,copy)NSString <Optional> * type;
@property(nonatomic,copy)NSString <Optional> * o_money;


@end
