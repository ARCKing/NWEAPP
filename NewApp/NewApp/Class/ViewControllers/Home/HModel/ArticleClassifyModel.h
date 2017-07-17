//
//  ArticleClassifyModel.h
//  NewApp
//
//  Created by gxtc on 17/2/27.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "JSONModel.h"

@interface ArticleClassifyModel : JSONModel

@property (nonatomic,copy)NSString <Optional>* c_id;
@property (nonatomic,copy)NSString <Optional>* title;
@property (nonatomic,copy)NSString <Optional>* url;

@end
