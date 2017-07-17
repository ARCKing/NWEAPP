//
//  MemberModel.h
//  NewApp
//
//  Created by gxtc on 17/3/8.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "JSONModel.h"

@interface MemberModel : JSONModel


@property(nonatomic,assign)int id;
@property(nonatomic,copy)NSString <Optional>* sex;
@property(nonatomic,copy)NSString <Optional>* share_count;
@property(nonatomic,copy)NSString <Optional>* headimgurl;
@property(nonatomic,copy)NSString <Optional>* nickname;
@property(nonatomic,copy)NSString <Optional>* member_id;
@property(nonatomic,copy)NSString <Optional>* sum_money;
@property(nonatomic,copy)NSString <Optional>* level;

@end
