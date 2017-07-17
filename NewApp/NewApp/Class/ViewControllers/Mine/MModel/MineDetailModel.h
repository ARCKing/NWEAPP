//
//  MineDetailModel.h
//  NewApp
//
//  Created by gxtc on 17/3/16.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "JSONModel.h"

@interface MineDetailModel : JSONModel
@property(nonatomic,copy)NSString <Optional> * headimgurl;
@property(nonatomic,copy)NSString <Optional> * nickname;
@property(nonatomic,copy)NSString <Optional> * sex;
@property(nonatomic,copy)NSDictionary <Optional> * address;

@property(nonatomic,copy)NSString <Optional> * name;
@property(nonatomic,copy)NSString <Optional> * rephone;
@property(nonatomic,copy)NSString <Optional> * region;
@property(nonatomic,copy)NSString <Optional> * address_address;

@end
