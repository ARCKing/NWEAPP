//
//  RespondToMineModel.h
//  NewApp
//
//  Created by gxtc on 17/3/13.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "JSONModel.h"

@interface RespondToMineModel : JSONModel

@property (nonatomic,assign)int id;
@property (nonatomic,copy)NSString <Optional> * uid;
@property (nonatomic,copy)NSString <Optional> * aid;
@property (nonatomic,copy)NSString <Optional> * content;
@property (nonatomic,copy)NSString <Optional> * rel_id;
@property (nonatomic,copy)NSString <Optional> * addtime;

@property (nonatomic,copy)NSDictionary <Optional> * tourist;
@property (nonatomic,copy)NSString <Optional> * tourist_headimgurl;
@property (nonatomic,copy)NSString <Optional> * tourist_nickname;

@property (nonatomic,copy)NSDictionary <Optional> * comment;
@property (nonatomic,copy)NSString <Optional> * comment_content;
@property (nonatomic,copy)NSString <Optional> * comment_nickname;

@property (nonatomic,copy)NSDictionary <Optional> * article;
@property (nonatomic,copy)NSString <Optional> * article_id;
@property (nonatomic,copy)NSString <Optional> * article_title;
@end
