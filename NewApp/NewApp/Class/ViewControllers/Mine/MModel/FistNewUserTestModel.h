//
//  FistNewUserTestModel.h
//  NewApp
//
//  Created by gxtc on 17/3/9.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "JSONModel.h"

@interface FistNewUserTestModel : JSONModel

@property (nonatomic,assign)int id;
@property (nonatomic,copy)NSString <Optional> * read_count;
@property (nonatomic,copy)NSString <Optional> * invite_friend;
@property (nonatomic,copy)NSString <Optional> * sign_money;
@property (nonatomic,copy)NSString <Optional> * member_id;
@property (nonatomic,copy)NSString <Optional> * comment;
@property (nonatomic,copy)NSString <Optional> * up;
@property (nonatomic,copy)NSString <Optional> * share_count;
@property (nonatomic,copy)NSString <Optional> * stauts;

@end
