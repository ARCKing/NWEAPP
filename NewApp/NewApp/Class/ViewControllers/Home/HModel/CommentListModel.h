//
//  CommentListModel.h
//  NewApp
//
//  Created by gxtc on 17/3/7.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "JSONModel.h"

@interface CommentListModel : JSONModel

@property (nonatomic,assign)int id;
@property (nonatomic,copy)NSString <Optional> * uid;
@property (nonatomic,copy)NSString <Optional> * aid;
@property (nonatomic,copy)NSString <Optional> * content;
@property (nonatomic,copy)NSString <Optional> * relation;
@property (nonatomic,copy)NSString <Optional> * up;
@property (nonatomic,copy)NSString <Optional> * good;
@property (nonatomic,copy)NSString <Optional> * addtime;
@property (nonatomic,copy)NSString <Optional> * username;
@property (nonatomic,copy)NSString <Optional> * relname;
@property (nonatomic,copy)NSString <Optional> * rel_id;

@property (nonatomic,copy)NSDictionary <Optional> * rel_comment;

@end
