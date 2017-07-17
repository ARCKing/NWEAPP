//
//  MineDate+CoreDataProperties.h
//  NewApp
//
//  Created by gxtc on 17/3/16.
//  Copyright © 2017年 gxtc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "MineDate+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MineDate (CoreDataProperties)

+ (NSFetchRequest<MineDate *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *mine_id;
@property (nullable, nonatomic, copy) NSString *today_read;
@property (nullable, nonatomic, copy) NSString *sum_read;
@property (nullable, nonatomic, copy) NSString *residue_money;
@property (nullable, nonatomic, copy) NSString *nickname;
@property (nullable, nonatomic, copy) NSString *level;
@property (nullable, nonatomic, copy) NSString *sex;
@property (nullable, nonatomic, copy) NSString *headimgurl;
@property (nullable, nonatomic, copy) NSString *hb_new_hb;
@property (nullable, nonatomic, copy) NSString *username;

@end

NS_ASSUME_NONNULL_END
