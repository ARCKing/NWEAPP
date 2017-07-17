//
//  withDrawCashRecordModel.h
//  NewApp
//
//  Created by gxtc on 17/3/14.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "JSONModel.h"

@interface withDrawCashRecordModel : JSONModel

@property (nonatomic,copy)NSString <Optional> * addtime;
@property (nonatomic,copy)NSString <Optional> * bank_name;
@property (nonatomic,copy)NSString <Optional> * cash_amount;
@property (nonatomic,copy)NSString <Optional> * status;
@property (nonatomic,copy)NSString <Optional> * note;


@end
