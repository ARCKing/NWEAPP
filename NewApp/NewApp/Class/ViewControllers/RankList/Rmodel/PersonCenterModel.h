//
//  PersonCenterModel.h
//  NewApp
//
//  Created by gxtc on 17/3/8.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "JSONModel.h"

@interface PersonCenterModel : JSONModel


//share
@property(nonatomic,assign)int id;
@property(nonatomic,copy)NSString <Optional>* sex;
@property(nonatomic,copy)NSString <Optional>* share_count;
@property(nonatomic,copy)NSString <Optional>* headimgurl;
@property(nonatomic,copy)NSString <Optional>* nickname;
@property(nonatomic,copy)NSString <Optional>* member_id;
@property(nonatomic,copy)NSString <Optional>* sum_money;
@property(nonatomic,copy)NSString <Optional>* level;


//comment
@property(nonatomic,copy)NSString <Optional>* uid;
@property(nonatomic,copy)NSString <Optional>* aid;
@property(nonatomic,copy)NSString <Optional>* content;
@property(nonatomic,copy)NSString <Optional>* relation;
@property(nonatomic,copy)NSString <Optional>* addtime;
@property(nonatomic,copy)NSString <Optional>* up;
@property(nonatomic,copy)NSString <Optional>* good;
@property(nonatomic,copy)NSString <Optional>* username;
@property(nonatomic,copy)NSString <Optional>* relname;
@property(nonatomic,copy)NSString <Optional>* rel_id;
@property(nonatomic,copy)NSDictionary <Optional>* article;

//collection
@property(nonatomic,copy)NSString <Optional>* title;
@property(nonatomic,copy)NSString <Optional>* thumb;
@property(nonatomic,copy)NSString <Optional>* view_count;
@property(nonatomic,copy)NSString <Optional>* url;



@end
