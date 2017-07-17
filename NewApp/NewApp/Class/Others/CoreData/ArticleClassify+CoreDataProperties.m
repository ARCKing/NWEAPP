//
//  ArticleClassify+CoreDataProperties.m
//  NewApp
//
//  Created by gxtc on 17/3/15.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "ArticleClassify+CoreDataProperties.h"

@implementation ArticleClassify (CoreDataProperties)

+ (NSFetchRequest<ArticleClassify *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ArticleClassify"];
}

@dynamic c_id;
@dynamic is_select;
@dynamic title;

@end
