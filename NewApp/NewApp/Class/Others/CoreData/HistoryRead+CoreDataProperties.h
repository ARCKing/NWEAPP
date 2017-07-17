//
//  HistoryRead+CoreDataProperties.h
//  NewApp
//
//  Created by gxtc on 17/3/20.
//  Copyright © 2017年 gxtc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "HistoryRead+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface HistoryRead (CoreDataProperties)

+ (NSFetchRequest<HistoryRead *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *addtime;
@property (nullable, nonatomic, copy) NSString *article_id;
@property (nullable, nonatomic, copy) NSString *comment;
@property (nonatomic) BOOL is_article;
@property (nullable, nonatomic, copy) NSString *read_price;
@property (nullable, nonatomic, copy) NSString *share_count;
@property (nullable, nonatomic, copy) NSString *share_num;
@property (nullable, nonatomic, copy) NSString *thumb;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *view_count;
@property (nullable, nonatomic, copy) NSString *link;
@property (nullable, nonatomic, copy) NSString *slink;

@end

NS_ASSUME_NONNULL_END
