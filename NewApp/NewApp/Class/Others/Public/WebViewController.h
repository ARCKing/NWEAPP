//
//  WebViewController.h
//  NewApp
//
//  Created by gxtc on 17/2/17.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "RootViewController.h"

@interface WebViewController : RootViewController
@property (nonatomic,copy)NSString * urlString;

@property (nonatomic,assign)BOOL isPost;

@property (nonatomic,copy)NSString * article_id;

@property (nonatomic,assign)BOOL isArticle;

@property (nonatomic,strong)ArticleListModel * articleModel;


@property (nonatomic,strong)HistoryRedModel * historyModel;

/**是否已收藏*/
@property (nonatomic,assign)BOOL isAlreadyCollection;

@property (nonatomic,assign)BOOL isNewTeach;

@end
