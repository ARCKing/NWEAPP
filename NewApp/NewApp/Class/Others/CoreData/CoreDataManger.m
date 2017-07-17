//
//  CoreDataManger.m
//  NewApp
//
//  Created by gxtc on 17/3/15.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "CoreDataManger.h"

#import "ArticleClassify+CoreDataClass.h"
#import "HistoryRead+CoreDataClass.h"
#import "MineDate+CoreDataClass.h"
#import "SystemMessage+CoreDataClass.h"

@interface CoreDataManger()

@end

static CoreDataManger * CDManger;

@implementation CoreDataManger

+ (instancetype)shareCoreDataManger{
    
    if (CDManger == nil) {
        
        CDManger = [[CoreDataManger alloc]init];
        
        CDManger.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
//        CDManger.persistentContainer = CDManger.appDelegate.persistentContainer;
    
        CDManger.manageObjectContext = CDManger.appDelegate.managedObjectContext;
        
        
        
        //数据库路径
        NSString * PATH = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
        NSLog(@"%@",PATH);
        
    }
    return CDManger;
}


+ (instancetype)alloc{
    
    if (CDManger == nil) {
        
        CDManger = [super alloc];
    }
    return CDManger;
    
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    if (CDManger == nil) {
        
        CDManger = [super allocWithZone:zone];
    }
    return CDManger;
}


//================================================


#pragma mark-插入文章频道
/** 插入文章频道*/
- (BOOL )insertIntoDataWithArticalClassTheSelect:(NSArray *)select andTheUnselect:(NSArray *)unSelect{
    
    NSError * error1 = nil;
    NSError * error2 = nil;
    BOOL isSucceed = NO;
    
    for (ArticleClassifyModel * model in select) {
        
        ArticleClassify * AM = [NSEntityDescription insertNewObjectForEntityForName:@"ArticleClassify" inManagedObjectContext:self.manageObjectContext];
        
        AM.title = [NSString stringWithFormat:@"%@",model.title];
        AM.c_id = [NSString stringWithFormat:@"%@",model.c_id];
        AM.is_select = YES;
        
        isSucceed = [self.manageObjectContext save:&error1];
        
        NSLog(@"%d",AM.is_select);

    }
    
    
    if (unSelect.count == 0) {
        
    }else{
        
        for (ArticleClassifyModel * model in unSelect) {
            
            ArticleClassify * AM = [NSEntityDescription insertNewObjectForEntityForName:@"ArticleClassify" inManagedObjectContext:self.manageObjectContext];
            
            AM.title = [NSString stringWithFormat:@"%@",model.title];
            AM.c_id = [NSString stringWithFormat:@"%@",model.c_id];
            AM.is_select = NO;
            
            isSucceed = [self.manageObjectContext save:&error2];
            
            
            NSLog(@"%d",AM.is_select);
        }
        
        
    }
    
    
    if (isSucceed == YES) {
        NSLog(@"1插入成功");
    }else{
        NSLog(@"error1=%@",error1);
        NSLog(@"error2=%@",error2);
        
    }
    
    
    
    return isSucceed;
}



#pragma mark- 查找所有频道
- (NSArray *)checkArticleList{
    
    NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"ArticleClassify"];
    
    NSArray * array = [self.manageObjectContext executeFetchRequest:fetch error:nil];
    
    NSInteger num = array.count;
    
    
    if(num == 0){
        
        return nil;
    }
    
    NSMutableArray * muArray = [[NSMutableArray alloc]init];
    
    for (ArticleClassify * AM in array) {
        
        ArticleClassifyModel * model = [[ArticleClassifyModel alloc]init];
        
        model.title = AM.title;
        model.c_id = AM.c_id;
        
        [muArray addObject:model];
    }
    
    
    return muArray;
}



#pragma mark- 查找[选中]频道
- (NSArray *)checkSelectArticleCharnel{
    
    NSMutableArray * muArray = [[NSMutableArray alloc]init];
    
    NSFetchRequest * ftRequest = [NSFetchRequest fetchRequestWithEntityName:@"ArticleClassify"];
    ftRequest.predicate = [NSPredicate predicateWithFormat:@"is_select = '1'"];
    
    NSArray * array = [self.manageObjectContext executeFetchRequest:ftRequest error:nil];
    
    NSInteger num = array.count;
    
    
    for (ArticleClassify * am in array) {
        
        ArticleClassifyModel * model = [[ArticleClassifyModel alloc]init];
        
        model.title = am.title;
        model.c_id = am.c_id;
        
        [muArray addObject:model];
    }
    
    
    
    if(num == 0){
        
        return nil;
    }else{
        
        NSLog(@"查找成功!");
        
    }
    
    
    
    NSLog(@"%@",muArray);
    
    
    
    return muArray;
}


#pragma mark- 查找[没选中]频道
- (NSArray *)checkUnSelectArticleCharnel{
    
    NSMutableArray * muArray = [[NSMutableArray alloc]init];
    
    NSFetchRequest * ftRequest = [NSFetchRequest fetchRequestWithEntityName:@"ArticleClassify"];
    ftRequest.predicate = [NSPredicate predicateWithFormat:@"is_select = '0'"];
    
    NSArray * array = [self.manageObjectContext executeFetchRequest:ftRequest error:nil];
    
    NSInteger num = array.count;
    
    
    for (ArticleClassify * am in array) {
        
        ArticleClassifyModel * model = [[ArticleClassifyModel alloc]init];
        
        model.title = am.title;
        model.c_id = am.c_id;
        
        [muArray addObject:model];
    }
    
    
    
    if(num == 0){
        
        return nil;
    }else{
        
        NSLog(@"查找成功!");
        
    }
    
    
    NSLog(@"%@",muArray);
    
    
    
    return muArray;
}



#pragma mark-删除所有频道数据
/**删除所有文章频道数据*/
- (void)deleteAllArticleClassData{
    
    NSFetchRequest * ftRequest = [NSFetchRequest fetchRequestWithEntityName:@"ArticleClassify"];
    NSArray * array = [self.manageObjectContext executeFetchRequest:ftRequest error:nil];
    
    for (ArticleClassify * AM in array) {
        
        [self.manageObjectContext deleteObject:AM];
        
    }
    
    BOOL is = [self.manageObjectContext save:nil];
    
    if (is == YES) {
        
        NSLog(@"删除所有数据成功");
        
    }else{
        NSLog(@"删除失败");
        
    }
    
}


#pragma mark- 插入阅读文章记录
/**插入文章阅读记录*/
- (BOOL)insertReadHestoryWithArticle:(ArticleListModel *)article{

    
    NSError * error1 = nil;
    
    BOOL isSucceed = NO;
    
    
    HistoryRead * HR = [NSEntityDescription insertNewObjectForEntityForName:@"HistoryRead" inManagedObjectContext:self.manageObjectContext];
        
    HR.title = [NSString stringWithFormat:@"%@",article.title];
    HR.article_id = [NSString stringWithFormat:@"%d",article.id];
    HR.is_article = YES;
    HR.thumb = [NSString stringWithFormat:@"%@",article.thumb];
    HR.read_price = [NSString stringWithFormat:@"%@",article.read_price];
    HR.share_num = [NSString stringWithFormat:@"%@",article.share_num];
    HR.view_count = [NSString stringWithFormat:@"%@",article.view_count];
    HR.addtime = [NSString stringWithFormat:@"%@",article.addtime];
    
    NSString * comment = [NSString stringWithFormat:@"%@",article.comment];
    
    if ([comment isEqualToString:@"(null)"] || comment == nil) {
        comment = @"0";
    }
    HR.comment = [NSString stringWithFormat:@"%@",comment];
    
    HR.share_count = [NSString stringWithFormat:@"%@",article.share_count];
    HR.slink = [NSString stringWithFormat:@"%@",article.slink];
    HR.link = [NSString stringWithFormat:@"%@",article.link];
    isSucceed = [self.manageObjectContext save:&error1];
        
    
    if (isSucceed == YES) {
        NSLog(@"1插入成功");
    }else{
        NSLog(@"error1=%@",error1);
    }

    return isSucceed;
}


#pragma mark-删除所有阅读记录
/**删除所有阅读记录*/
- (BOOL)deleteAllHestoryReadRecord{
    
    NSFetchRequest * ftRequest = [NSFetchRequest fetchRequestWithEntityName:@"HistoryRead"];
    NSArray * array = [self.manageObjectContext executeFetchRequest:ftRequest error:nil];
    
    for (HistoryRead * HR in array) {
        
        [self.manageObjectContext deleteObject:HR];
        
    }
    
    BOOL is = [self.manageObjectContext save:nil];
    
    if (is == YES) {
        
        NSLog(@"删除所有数据成功");
        
    }else{
        NSLog(@"删除失败");
        
    }
    
    return is;
}



#pragma mark- 查找阅读记录
/**查找阅读记录*/
- (NSArray *)checkArticleHestoryReadRecordList{
    
    NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"HistoryRead"];
    
    NSArray * array = [self.manageObjectContext executeFetchRequest:fetch error:nil];
    
    NSInteger num = array.count;
    
    
    if(num == 0){
        
        return nil;
    }
    
    NSMutableArray * muArray = [[NSMutableArray alloc]init];
    
    for (HistoryRead * HR in array) {
        
        ArticleListModel * model = [[ArticleListModel alloc]init];
        
        model.title = HR.title;
        model.id = [HR.article_id intValue];
        model.thumb = HR.thumb;
        model.read_price = HR.read_price;
        model.share_num = HR.share_num;
        model.share_count = HR.share_count;
        model.view_count = HR.view_count;
        model.addtime = HR.addtime;
        model.comment = HR.comment;
        model.link = HR.link;
        model.slink = HR.slink;
        
        [muArray addObject:model];
    }
    
    
    return muArray;
}


#pragma mark- 删除我的资料
/**删除我的资料*/
- (BOOL)deleteMineDataSource{
    
    NSFetchRequest * ftRequest = [NSFetchRequest fetchRequestWithEntityName:@"MineDate"];
    NSArray * array = [self.manageObjectContext executeFetchRequest:ftRequest error:nil];
    
    for (MineDate * MD in array) {
        
        [self.manageObjectContext deleteObject:MD];
        
    }
    
    BOOL is = [self.manageObjectContext save:nil];
    
    if (is == YES) {
        
        NSLog(@"删除所有数据成功");
        
    }else{
        NSLog(@"删除失败");
        
    }
    
    return is;

}


#pragma mark- 插入我的资料
/**插入我的资料*/
- (BOOL)insertMineDataWithMineDataModel:(MineDataSourceModel *)mineModel{

    NSError * error1 = nil;
    
    BOOL isSucceed = NO;
    
    
    MineDate * MD = [NSEntityDescription insertNewObjectForEntityForName:@"MineDate" inManagedObjectContext:self.manageObjectContext];
    
    MD.mine_id = [NSString stringWithFormat:@"%d",mineModel.id];
    MD.today_read = [NSString stringWithFormat:@"%@",mineModel.today_read];
    MD.sum_read = [NSString stringWithFormat:@"%@",mineModel.sum_read];
    MD.residue_money = [NSString stringWithFormat:@"%@",mineModel.residue_money];
    MD.nickname = [NSString stringWithFormat:@"%@",mineModel.nickname];
    MD.level = [NSString stringWithFormat:@"%@",mineModel.level];
    MD.sex = [NSString stringWithFormat:@"%@",mineModel.sex];
    MD.headimgurl = [NSString stringWithFormat:@"%@",mineModel.headimgurl];
    MD.hb_new_hb = [NSString stringWithFormat:@"%@",mineModel.hb_new_hb];
    MD.username = [NSString stringWithFormat:@"%@",mineModel.username];

    isSucceed = [self.manageObjectContext save:&error1];
    
    
    if (isSucceed == YES) {
        NSLog(@"1插入成功");
    }else{
        NSLog(@"error1=%@",error1);
    }
    
    return isSucceed;
}


//=======================查找


#pragma mark- 查找我的资料
/**查找我的资料*/
- (MineDataSourceModel *)checkMineDataSource{
    
    NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"MineDate"];
    
    NSArray * array = [self.manageObjectContext executeFetchRequest:fetch error:nil];
    
    NSInteger num = array.count;
    
    
    if(num == 0){
        
        return nil;
    }
    
    MineDate * MD = array[0];
    
    MineDataSourceModel * model = [[MineDataSourceModel alloc]init];
    
    model.id = [MD.mine_id intValue];
    model.today_read =MD.today_read;
    model.sum_read = MD.sum_read;
    model.residue_money = MD.residue_money;
    model.nickname = MD.nickname;
    model.level = MD.level;
    model.sex = MD.sex;
    model.headimgurl = MD.headimgurl;
    model.username = MD.username;
    model.hb_new_hb = MD.hb_new_hb;
    
    return model;
}


#pragma mark- 系统消息
#pragma mark- 插入系统消息
/**插入系统消息*/
- (BOOL )insertIntoDataWithsystemMessage:(NSArray *)messageArray andPage:(NSString *)page{

    
    NSError * error1 = nil;
    
    BOOL isSucceed = NO;
    
    for (systemMessageModel * model in messageArray) {
        
        SystemMessage * SM = [NSEntityDescription insertNewObjectForEntityForName:@"SystemMessage" inManagedObjectContext:self.manageObjectContext];

        SM.m_id = [NSString stringWithFormat:@"%d",model.id];
        SM.title = model.title;
        SM.ptime = model.ptime;
        SM.content = model.content;
        SM.read = model.read;
    
        isSucceed = [self.manageObjectContext save:&error1];
        
        if (isSucceed == NO) {
            
            break;
        }
    }
    
    
    if (isSucceed == YES) {
        NSLog(@"1插入成功");
    }else{
        NSLog(@"error1=%@",error1);
    }
    
    return isSucceed;
}


#pragma mark- 查找所有系统消息
- (NSArray *)checkAllSystemMessage{

    NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"SystemMessage"];
    
    NSArray * array = [self.manageObjectContext executeFetchRequest:fetch error:nil];
    
    NSInteger num = array.count;
    
    
    if(num == 0){
        
        return nil;
    }
    

    NSMutableArray * dataArray = [NSMutableArray new];
    
    for (SystemMessage * SM in array) {
        
        systemMessageModel * model = [[systemMessageModel alloc]init];
        model.id = [SM.m_id intValue];
        model.title = SM.title;
        model.content = SM.content;
        model.ptime = SM.ptime;
        model.read = SM.read;
        
        [dataArray addObject:model];
    }
    
    
    return dataArray;
}



#pragma mark-删除所有系统消息
/**删除所有系统消息*/
- (BOOL)deleteAllSystemMessageData{
    
    NSFetchRequest * ftRequest = [NSFetchRequest fetchRequestWithEntityName:@"SystemMessage"];
    NSArray * array = [self.manageObjectContext executeFetchRequest:ftRequest error:nil];
    
    for (SystemMessage * SM in array) {
        
        [self.manageObjectContext deleteObject:SM];
        
    }
    
    BOOL is = [self.manageObjectContext save:nil];
    
    if (is == YES) {
        
        NSLog(@"删除所有数据成功");
        
    }else{
        NSLog(@"删除失败");
        
    }
    
    return is;

}



#pragma mark- 回复我的
/**插入回复我的数据*/
- (void)coreDataInsertRespondMineCommentWithData:(NSArray *)dataArray withPage:(NSString *)page{

}

/**查找回复我的*/
- (NSArray *)coreDataCheckRespondMineCommentData{

    return nil;
}

/**删除回复我的*/
- (BOOL)coreDataDelleteRespondMineCommentData{

    return YES;
}


@end
