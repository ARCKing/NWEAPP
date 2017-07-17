//
//  ChouJiangModel.h
//  NewApp
//
//  Created by gxtc on 2017/5/26.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "JSONAPI.h"

@interface ChouJiangModel : JSONModel

@property (nonatomic,assign)int id;
@property (nonatomic,copy)NSString <Optional> * uid;
@property (nonatomic,copy)NSString <Optional> * gift;
@property (nonatomic,copy)NSString <Optional> * addtime;
@property (nonatomic,copy)NSString <Optional> * status;
@property (nonatomic,copy)NSString <Optional> * remark;

@end
