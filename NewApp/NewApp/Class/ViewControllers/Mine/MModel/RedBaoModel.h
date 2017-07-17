//
//  RedBaoModel.h
//  NewApp
//
//  Created by gxtc on 2017/6/8.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "JSONModel.h"

@interface RedBaoModel : JSONModel


@property(nonatomic,assign) int id;
@property(nonatomic,copy)NSString <Optional> * uid;
@property(nonatomic,copy)NSString <Optional> * sum_money;
@property(nonatomic,copy)NSString <Optional> * headimgurl;
@property(nonatomic,copy)NSString <Optional> * addtime;

@property(nonatomic,copy)NSString <Optional> * z_number;
@property(nonatomic,copy)NSString <Optional> * z_money;
@property(nonatomic,copy)NSString <Optional> * limit;
@property(nonatomic,copy)NSString <Optional> * gift_money;
@property(nonatomic,copy)NSString <Optional> * is_red;
@property(nonatomic,copy)NSString <Optional> * num;
@property(nonatomic,copy)NSString <Optional> * share_money;


@end
