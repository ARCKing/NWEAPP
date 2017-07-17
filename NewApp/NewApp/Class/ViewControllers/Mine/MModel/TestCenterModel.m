//
//  TestCenterModel.m
//  NewApp
//
//  Created by gxtc on 17/3/2.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "TestCenterModel.h"

@implementation TestCenterModel



- (instancetype)initWithDict:(NSDictionary * )dict{

    if (self = [super init]) {
        
        self.heightModelArray = [NSMutableArray new];
        
        self.sum_money = [NSString stringWithFormat:@"%@",dict[@"sum_money"]];
        
        if (self.sum_money == nil) {
            
            self.sum_money = @"0";
        }
        
        
        self.type = [NSString stringWithFormat:@"%@",dict[@"type"]];
        
        
        
        //签到连续天数
        self.sign_num = [NSString stringWithFormat:@"%@",dict[@"sign_num"]];
        
        if (self.sign_num == nil) {
            
            self.sign_num = @"0";
        }
        
        
        //tudi
        self.prentice = [NSString stringWithFormat:@"%@",dict[@"prentice"]];
        
        if (self.prentice == nil) {
            
            self.prentice = @"0";
        }
        

        
        //tusun
        self.superior = [NSString stringWithFormat:@"%@",dict[@"superior"]];
        
        if (self.superior == nil) {
            
            self.superior = @"0";
        }
        

        
        
        
        NSArray * height_ad = dict[@"height_ad"];
        
        if ((int)height_ad.count > 0) {
            
            for (NSDictionary * dic in height_ad) {
                
                ArticleListModel * heightModel = [[ArticleListModel alloc]initWithDictionary:dic error:nil];
                
                [self.heightModelArray addObject:heightModel];
            }
        }
        
        
        
        //今日签到信息
        if (dict[@"signDay"] != [NSNull null]) {
            
            NSDictionary * signDay = dict[@"signDay"];
            
            self.signDay_num = [NSString stringWithFormat:@"%@",signDay[@"num"]];
            self.signDay_money = [NSString stringWithFormat:@"%@",signDay[@"money"]];
        }
        
        
        //首次登陆
        if (dict[@"new_hb"] != [NSNull null]) {
            NSDictionary * new_hb = dict[@"new_hb"];
            self.hb_new_hb_num = [NSString stringWithFormat:@"%@",new_hb[@"num"]];
            self.hb_new_hb_money = [NSString stringWithFormat:@"%@",new_hb[@"money"]];

        }
        
        //有奖反馈
        if (dict[@"feedback"] != [NSNull null]) {
            NSDictionary * feedback = dict[@"feedback"];
            self.feedback_num = [NSString stringWithFormat:@"%@",feedback[@"num"]];
            self.feedback_money = [NSString stringWithFormat:@"%@",feedback[@"money"]];

        }
        
        //每日阅读
        if (dict[@"read"] != [NSNull null]) {
            NSDictionary * read = dict[@"read"];
            self.read_num = [NSString stringWithFormat:@"%@",read[@"num"]];
            self.read_money = [NSString stringWithFormat:@"%@",read[@"money"]];
        }
        
        //赞
        if (dict[@"up_data"] != [NSNull null]) {
            NSDictionary * up_data = dict[@"up_data"];
            self.up_data_num = [NSString stringWithFormat:@"%@",up_data[@"num"]];
            self.up_data_money =[NSString stringWithFormat:@"%@", up_data[@"money"]];
        }
        
        //评论
        if (dict[@"comment"] != [NSNull null]) {
            NSDictionary * comment = dict[@"comment"];
            self.comment_num = [NSString stringWithFormat:@"%@",comment[@"num"]];
            self.comment_money = [NSString stringWithFormat:@"%@",comment[@"money"]];
        }

        //邀请
        if (dict[@"inviter_money"] != [NSNull null]) {
            
            self.inviter_money = [NSString stringWithFormat:@"%@",dict[@"inviter_money"]];

        }
        
        //分享
        if (dict[@"share_money"] != [NSNull null]) {
            
            self.share_money = [NSString stringWithFormat:@"%@",dict[@"share_money"]];

        }
        
        
        //连续签到天数
        if (dict[@"sign_money"] != [NSNull null]) {
            
            NSArray * array = dict[@"sign_money"];
            if (array.count > 0) {
                
                self.sign_money = [NSArray arrayWithArray:array];
            }
        }
        
        
        
        
        
    }
    
    return self;
}



+ (instancetype)allocWithDict:(NSDictionary * )dict{


    return [[TestCenterModel alloc]initWithDict:dict];
}

@end
