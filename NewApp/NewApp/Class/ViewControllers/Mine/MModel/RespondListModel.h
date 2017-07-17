//
//  RespondListModel.h
//  NewApp
//
//  Created by gxtc on 17/3/20.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "JSONModel.h"

@interface RespondListModel : JSONModel

@property(nonatomic,assign) int id;
@property(nonatomic,copy)NSString <Optional> * uid;
@property(nonatomic,copy)NSString <Optional> * content;
@property(nonatomic,copy)NSString <Optional> * addtime;

@property(nonatomic,copy)NSString <Optional> * headimgurl;
@end
