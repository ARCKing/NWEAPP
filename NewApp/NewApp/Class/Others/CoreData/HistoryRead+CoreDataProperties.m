//
//  HistoryRead+CoreDataProperties.m
//  NewApp
//
//  Created by gxtc on 17/3/20.
//  Copyright © 2017年 gxtc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "HistoryRead+CoreDataProperties.h"

@implementation HistoryRead (CoreDataProperties)

+ (NSFetchRequest<HistoryRead *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"HistoryRead"];
}

@dynamic addtime;
@dynamic article_id;
@dynamic comment;
@dynamic is_article;
@dynamic read_price;
@dynamic share_count;
@dynamic share_num;
@dynamic thumb;
@dynamic title;
@dynamic view_count;
@dynamic link;
@dynamic slink;

@end
