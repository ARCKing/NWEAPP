//
//  ArticleClassify+CoreDataProperties.h
//  NewApp
//
//  Created by gxtc on 17/3/15.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "ArticleClassify+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ArticleClassify (CoreDataProperties)

+ (NSFetchRequest<ArticleClassify *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *c_id;
@property (nonatomic) BOOL is_select;
@property (nullable, nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
