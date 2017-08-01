//
//  ImportArticleModel.h
//  NewApp
//
//  Created by gxtc on 2017/8/1.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "JSONModel.h"

@interface ImportArticleModel : JSONModel

@property (nonatomic,copy)NSString <Optional> * thumb;
@property (nonatomic,copy)NSString <Optional> * title;
@property (nonatomic,copy)NSString <Optional> * article_id;
@property (nonatomic,copy)NSString <Optional> * state;
@property (nonatomic,copy)NSString <Optional> * addtime;


@end
