//
//  RespondMineComment+CoreDataProperties.h
//  NewApp
//
//  Created by gxtc on 17/3/28.
//  Copyright © 2017年 gxtc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "RespondMineComment+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface RespondMineComment (CoreDataProperties)

+ (NSFetchRequest<RespondMineComment *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *rmc_id;
@property (nullable, nonatomic, copy) NSString *aid;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *rel_id;
@property (nullable, nonatomic, copy) NSString *addtime;
@property (nullable, nonatomic, copy) NSString *tourist_headimgurl;
@property (nullable, nonatomic, copy) NSString *tourist_nickname;
@property (nullable, nonatomic, copy) NSString *comment_content;
@property (nullable, nonatomic, copy) NSString *comment_nickname;
@property (nullable, nonatomic, copy) NSString *article_id;
@property (nullable, nonatomic, copy) NSString *article_title;
@property (nullable, nonatomic, copy) NSString *page;

@end

NS_ASSUME_NONNULL_END
