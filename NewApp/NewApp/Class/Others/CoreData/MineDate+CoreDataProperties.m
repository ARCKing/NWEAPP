//
//  MineDate+CoreDataProperties.m
//  NewApp
//
//  Created by gxtc on 17/3/16.
//  Copyright © 2017年 gxtc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "MineDate+CoreDataProperties.h"

@implementation MineDate (CoreDataProperties)

+ (NSFetchRequest<MineDate *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MineDate"];
}

@dynamic mine_id;
@dynamic today_read;
@dynamic sum_read;
@dynamic residue_money;
@dynamic nickname;
@dynamic level;
@dynamic sex;
@dynamic headimgurl;
@dynamic hb_new_hb;
@dynamic username;

@end
