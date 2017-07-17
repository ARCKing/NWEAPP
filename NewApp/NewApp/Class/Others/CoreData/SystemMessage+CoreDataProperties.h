//
//  SystemMessage+CoreDataProperties.h
//  NewApp
//
//  Created by gxtc on 17/3/28.
//  Copyright © 2017年 gxtc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "SystemMessage+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SystemMessage (CoreDataProperties)

+ (NSFetchRequest<SystemMessage *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *m_id;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *read;
@property (nullable, nonatomic, copy) NSString *ptime;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *page;

@end

NS_ASSUME_NONNULL_END
