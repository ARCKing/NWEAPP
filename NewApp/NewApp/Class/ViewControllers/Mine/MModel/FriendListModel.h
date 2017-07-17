//
//  FriendListModel.h
//  NewApp
//
//  Created by gxtc on 17/3/14.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "JSONModel.h"

@interface FriendListModel : JSONModel

@property(nonatomic,copy)NSString <Optional> * phone;
@property(nonatomic,copy)NSString <Optional> * headimgurl;
@property(nonatomic,copy)NSString <Optional> * inviter_money;
@property(nonatomic,copy)NSString <Optional> * sum_money;
@property(nonatomic,copy)NSString <Optional> * inputtime;
@property(nonatomic,copy)NSString <Optional> * is_inviter_re;
@property(nonatomic,copy)NSString <Optional> * uid;

@property(nonatomic,copy)NSString <Optional> * listType;
@end
