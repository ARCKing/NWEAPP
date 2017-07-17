//
//  TestCenterModel.h
//  NewApp
//
//  Created by gxtc on 17/3/2.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestCenterModel : NSObject

//@property(nonatomic,strong)ArticleListModel * heightModel;

@property(nonatomic,strong)NSMutableArray * heightModelArray;

@property(nonatomic,copy)NSString * sign_num;
@property(nonatomic,copy)NSString * signDay_num;
@property(nonatomic,copy)NSString * hb_new_hb_num;
@property(nonatomic,copy)NSString * feedback_num;
@property(nonatomic,copy)NSString * read_num;
@property(nonatomic,copy)NSString * up_data_num;
@property(nonatomic,copy)NSString * comment_num;


@property(nonatomic,copy)NSString * sum_money;
@property(nonatomic,copy)NSString * signDay_money;
@property(nonatomic,copy)NSString * hb_new_hb_money;
@property(nonatomic,copy)NSString * feedback_money;
@property(nonatomic,copy)NSString * read_money;
@property(nonatomic,copy)NSString * up_data_money;
@property(nonatomic,copy)NSString * comment_money;
@property(nonatomic,copy)NSString * inviter_money;
@property(nonatomic,copy)NSString * share_money;

@property(nonatomic,copy)NSString * type;

@property(nonatomic,strong)NSArray * sign_money;

@property(nonatomic,copy)NSString * prentice;
@property(nonatomic,copy)NSString * superior;



- (instancetype)initWithDict:(NSDictionary * )dict;



+ (instancetype)allocWithDict:(NSDictionary * )dict;
@end
