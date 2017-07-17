//
//  systemMessageModel.h
//  NewApp
//
//  Created by gxtc on 17/3/13.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "JSONModel.h"

@interface systemMessageModel : JSONModel

@property (nonatomic,assign)int id;

@property (nonatomic,copy)NSString <Optional> * title;
@property (nonatomic,copy)NSString <Optional> * ptime;
@property (nonatomic,copy)NSString <Optional> * content;
@property (nonatomic,copy)NSString <Optional> * read;

@end
