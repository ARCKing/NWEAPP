//
//  CoreDataManger.h
//  NewApp
//
//  Created by gxtc on 17/3/15.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "MineDataSourceModel.h"

@interface CoreDataManger : NSObject
@property (nonatomic,strong)AppDelegate * appDelegate;

@property (nonatomic, strong) NSPersistentContainer *persistentContainer;

@property (nonatomic,strong)NSManagedObjectContext * manageObjectContext;

//@property (nonatomic,strong)NSFetchRequest * fetchRequest;



/** 单例创建CoreDataManger*/
+ (instancetype)shareCoreDataManger;


//======================插入
#pragma mark-插入文章频道
/** 插入文章频道*/
- (BOOL )insertIntoDataWithArticalClassTheSelect:(NSArray *)select andTheUnselect:(NSArray *)unSelect;


#pragma mark- 插入系统消息
/**插入系统消息*/
- (BOOL )insertIntoDataWithsystemMessage:(NSArray *)messageArray andPage:(NSString *)page;



#pragma mark- 插入阅读文章记录
/**插入文章阅读记录*/
- (BOOL)insertReadHestoryWithArticle:(ArticleListModel *)article;


#pragma mark- 插入我的资料
/**插入我的资料*/
- (BOOL)insertMineDataWithMineDataModel:(MineDataSourceModel *)mineModel;


//=======================查找


#pragma mark- 查找我的资料
/**查找我的资料*/
- (MineDataSourceModel *)checkMineDataSource;

#pragma mark- 查找所有频道
- (NSArray *)checkArticleList;


#pragma mark- 查找选中频道
- (NSArray *)checkSelectArticleCharnel;

#pragma mark- 查找[没选中]频道
- (NSArray *)checkUnSelectArticleCharnel;


#pragma mark- 查找所有系统消息
- (NSArray *)checkAllSystemMessage;

#pragma mark- 查找阅读记录
/**查找阅读记录*/
- (NSArray *)checkArticleHestoryReadRecordList;

//=======================删除
#pragma mark- 删除所有数据
/**删除所有文章频道数据*/
- (void)deleteAllArticleClassData;

#pragma mark-删除所有系统消息
/**删除所有系统消息*/
- (BOOL)deleteAllSystemMessageData;

#pragma mark-删除所有阅读记录
/**删除所有阅读记录*/
- (BOOL)deleteAllHestoryReadRecord;

#pragma mark- 删除我的资料
/**删除我的资料*/
- (BOOL)deleteMineDataSource;


#pragma mark- 回复我的
/**插入回复我的数据*/
- (void)coreDataInsertRespondMineCommentWithData:(NSArray *)dataArray withPage:(NSString *)page;

/**查找回复我的*/
- (NSArray *)coreDataCheckRespondMineCommentData;

/**删除回复我的*/
- (BOOL)coreDataDelleteRespondMineCommentData;


@end
