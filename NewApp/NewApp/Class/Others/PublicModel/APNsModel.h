//
//  APNsModel.h
//  NewApp
//
//  Created by gxtc on 17/3/22.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "JSONModel.h"

@interface APNsModel : JSONModel

@property(nonatomic,strong)NSString <Optional> * alert;


@property(nonatomic,strong)NSString <Optional> * state;
@property(nonatomic,strong)NSString <Optional> * thumb;
@property(nonatomic,strong)NSString <Optional> * title;
@property(nonatomic,strong)NSString <Optional> * type;
@property(nonatomic,assign)int id;



@end
