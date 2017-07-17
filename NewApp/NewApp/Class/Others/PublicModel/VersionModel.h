//
//  VersionModel.h
//  NewApp
//
//  Created by gxtc on 17/4/5.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "JSONModel.h"

@interface VersionModel : JSONModel

@property(nonatomic,strong)NSString <Optional> * version_number;
@property(nonatomic,strong)NSString <Optional> * remarks;
//@property(nonatomic,strong)NSString <Optional> * down_url;
//@property(nonatomic,strong)NSString <Optional> * mandatory_update;
@property(nonatomic,strong)NSString <Optional> * addtime;

@end
