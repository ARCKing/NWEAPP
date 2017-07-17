//
//  UserRankModel.h
//  NewApp
//
//  Created by gxtc on 17/3/6.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "JSONModel.h"

@interface UserRankModel : JSONModel

@property(nonatomic,copy)NSString <Optional>* uid;
@property(nonatomic,copy)NSString <Optional>* share_count;
@property(nonatomic,copy)NSString <Optional>* headimgurl;
@property(nonatomic,copy)NSString <Optional>* name;

@property(nonatomic,copy)NSString <Optional>* read_count;

@property(nonatomic,copy)NSString <Optional>* sum_money;

@end
