//
//  HistoryRedModel.h
//  NewApp
//
//  Created by gxtc on 17/2/24.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "JSONModel.h"

@interface HistoryRedModel : JSONModel
@property (nonatomic,assign)int id;
@property (nonatomic,copy)NSString <Optional> * title;
@end
