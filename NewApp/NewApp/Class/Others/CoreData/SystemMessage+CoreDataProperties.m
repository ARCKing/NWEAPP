//
//  SystemMessage+CoreDataProperties.m
//  NewApp
//
//  Created by gxtc on 17/3/28.
//  Copyright © 2017年 gxtc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "SystemMessage+CoreDataProperties.h"

@implementation SystemMessage (CoreDataProperties)

+ (NSFetchRequest<SystemMessage *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SystemMessage"];
}

@dynamic m_id;
@dynamic title;
@dynamic read;
@dynamic ptime;
@dynamic content;
@dynamic page;

@end
