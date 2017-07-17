//
//  ArticleListModel.h
//  NewApp
//
//  Created by gxtc on 17/2/27.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "JSONModel.h"

@interface ArticleListModel : JSONModel
@property (nonatomic,assign)int id;
@property (nonatomic,copy)NSString <Optional> * title;
@property (nonatomic,copy)NSString <Optional> * thumb;
@property (nonatomic,copy)NSString <Optional> * read_price;
@property (nonatomic,copy)NSString <Optional> * share_num;
@property (nonatomic,copy)NSString <Optional> * share_sum;
@property (nonatomic,copy)NSString <Optional> * view_count;
@property (nonatomic,copy)NSString <Optional> * share_count;
@property (nonatomic,copy)NSString <Optional> * addtime;

@property (nonatomic,copy)NSString <Optional> * url;
@property (nonatomic,copy)NSString <Optional> * comment;

@property (nonatomic,copy)NSString <Optional> * link;
@property (nonatomic,copy)NSString <Optional> * slink;



@property (nonatomic,copy)NSString <Optional> * c_id;
@property (nonatomic,copy)NSString <Optional> * title_short;
@property (nonatomic,copy)NSString <Optional> * abstract;
@property (nonatomic,copy)NSString <Optional> * video;
@property (nonatomic,copy)NSString <Optional> * gshare;
@property (nonatomic,copy)NSString <Optional> * share;

@property (nonatomic,copy)NSString <Optional> * height;


@property (nonatomic,copy)NSString <Optional> * aid;
@property (nonatomic,copy)NSString <Optional> * uid;

@end
