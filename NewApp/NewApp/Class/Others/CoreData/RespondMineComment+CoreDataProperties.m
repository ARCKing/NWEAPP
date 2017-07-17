//
//  RespondMineComment+CoreDataProperties.m
//  NewApp
//
//  Created by gxtc on 17/3/28.
//  Copyright © 2017年 gxtc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "RespondMineComment+CoreDataProperties.h"

@implementation RespondMineComment (CoreDataProperties)

+ (NSFetchRequest<RespondMineComment *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"RespondMineComment"];
}

@dynamic rmc_id;
@dynamic aid;
@dynamic content;
@dynamic rel_id;
@dynamic addtime;
@dynamic tourist_headimgurl;
@dynamic tourist_nickname;
@dynamic comment_content;
@dynamic comment_nickname;
@dynamic article_id;
@dynamic article_title;
@dynamic page;

@end
