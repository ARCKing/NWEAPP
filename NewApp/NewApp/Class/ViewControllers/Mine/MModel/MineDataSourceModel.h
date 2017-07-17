//
//  MineDataSourceModel.h
//  NewApp
//
//  Created by gxtc on 17/3/9.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "JSONModel.h"

@interface MineDataSourceModel : JSONModel


@property (nonatomic,assign)int id;
@property (nonatomic,copy)NSString <Optional> * today_read;
@property (nonatomic,copy)NSString <Optional> * sum_read;
@property (nonatomic,copy)NSString <Optional> * residue_money;
@property (nonatomic,copy)NSString <Optional> * nickname;
@property (nonatomic,copy)NSString <Optional> * level;
@property (nonatomic,copy)NSString <Optional> * sex;
@property (nonatomic,copy)NSString <Optional> * headimgurl;
@property (nonatomic,copy)NSString <Optional> * hb_new_hb;
@property (nonatomic,copy)NSString <Optional> * username;
@property (nonatomic,copy)NSString <Optional> * type;
@property (nonatomic,copy)NSString <Optional> * prentice;

@property (nonatomic,copy)NSString <Optional> * today_income;
@property (nonatomic,copy)NSString <Optional> * today_prentice;

//@property (nonatomic,copy)NSString <Optional> * uc_id;
//@property (nonatomic,copy)NSString <Optional> * sum_money;
//@property (nonatomic,copy)NSString <Optional> * prentice_sum_money;
//@property (nonatomic,copy)NSString <Optional> * openid;
//@property (nonatomic,copy)NSString <Optional> * is_auth;
//@property (nonatomic,copy)NSString <Optional> * is_bind;
//@property (nonatomic,copy)NSString <Optional> * phone;
//@property (nonatomic,copy)NSString <Optional> * province;
//@property (nonatomic,copy)NSString <Optional> * city;
//@property (nonatomic,copy)NSString <Optional> * country;
//@property (nonatomic,copy)NSString <Optional> * privilege;
//@property (nonatomic,copy)NSString <Optional> * unionid;
//@property (nonatomic,copy)NSString <Optional> * state;
//@property (nonatomic,copy)NSString <Optional> * inputtime;
//@property (nonatomic,copy)NSString <Optional> * lasttime;
//@property (nonatomic,copy)NSString <Optional> * inviter;

//@property (nonatomic,copy)NSString <Optional> * feedback;
//@property (nonatomic,copy)NSString <Optional> * is_inviter_re;
//@property (nonatomic,copy)NSString <Optional> * sign;
//@property (nonatomic,copy)NSString <Optional> * comment;
//@property (nonatomic,copy)NSString <Optional> * status_wake;
//@property (nonatomic,copy)NSString <Optional> * read_count;
//@property (nonatomic,copy)NSString <Optional> * share_count;
//@property (nonatomic,copy)NSString <Optional> * member_id;
//@property (nonatomic,copy)NSString <Optional> * avatar_100;
//@property (nonatomic,copy)NSString <Optional> * avatar_200;
//@property (nonatomic,copy)NSString <Optional> * day;

//@property (nonatomic,copy)NSDictionary <Optional> * today_info;
//@property (nonatomic,copy)NSString <Optional> * today_income;
//@property (nonatomic,copy)NSString <Optional> * today_prentice;
//
//
//@property (nonatomic,copy)NSDictionary <Optional> * yesterDay_info;
//@property (nonatomic,copy)NSString <Optional> * yesterDay_income;
//
//
//@property (nonatomic,copy)NSDictionary <Optional> * invite_income;
//@property (nonatomic,copy)NSString <Optional> * invite_income_sum_;


//@property (nonatomic,copy)NSString <Optional> * member_auth;

//@property (nonatomic,copy)NSString <Optional> * rate;
//@property (nonatomic,copy)NSString <Optional> * prentice_num;
//@property (nonatomic,copy)NSString <Optional> * task_Money;
//
//



@end
