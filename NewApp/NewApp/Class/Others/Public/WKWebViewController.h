//
//  WKWebViewController.h
//  NewApp
//
//  Created by gxtc on 17/2/17.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "RootViewController.h"
#import "ArticleListModel.h"

#import "HistoryRedModel.h"

#import "PersonCenterModel.h"

@interface WKWebViewController : RootViewController

@property (nonatomic,copy)NSString * urlString;

@property (nonatomic,assign)BOOL isPost;//是否是Post
@property (nonatomic,assign)BOOL isVideo;//是否是video


@property (nonatomic,assign)BOOL isNewTeach;

@property (nonatomic,assign)BOOL isPushAPNS;//推送

@property (nonatomic,assign)BOOL isHeightPrice;//高价文章



@property (nonatomic,copy)NSString * article_id;//文章，视屏id
//@property (nonatomic,copy)NSString * article_title;
//@property (nonatomic,copy)NSString * article_content;
//@property (nonatomic,copy)NSString * article_url;
//@property (nonatomic,copy)NSString * article_share_Count;
//@property (nonatomic,copy)NSString * article_comment_Count;
//@property (nonatomic,copy)NSString * article_view_Count;
//@property (nonatomic,copy)NSString * article_thumb;
//@property (nonatomic,copy)NSString * article_link;
//@property (nonatomic,copy)NSString * article_slink;


@property (nonatomic,strong)ArticleListModel * articleModel;

@property (nonatomic,strong)HistoryRedModel * historyModel;

@property (nonatomic,strong)PersonCenterModel * pModel;


/**是否已收藏*/
@property (nonatomic,assign)BOOL isAlreadyCollection;

@end
