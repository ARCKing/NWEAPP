//
//  NetWork.m
//  NewApp
//
//  Created by gxtc on 17/2/24.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "NetWork.h"
#import <UMMobClick/MobClick.h>
#import <UserNotifications/UserNotifications.h>
#import "UMessage.h"

@interface NetWork()

//@property (nonatomic,strong)NSUserDefaults * userDefaults;

@end

static NetWork * net;

@implementation NetWork


+(instancetype)shareNetWorkNew{
    
    if (net == nil) {
        
        net = [[NetWork alloc]init];
        
       
    }
    
    return net;
}

+ (instancetype)alloc{

    if (net == nil) {
        
        net = [super alloc];
    }
    
    return net;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{

    if (net == nil) {
        net = [super allocWithZone:zone];
    }
    return net;
}

//=================================================


#pragma mark- 注册新用户
- (void)regisNewUserWithPhone:(NSString *)phone andDXstring:(NSString *)DX andPassword:(NSString *)passWord
                   andInviter:(NSString *)inviter andOpinId:(NSString *)openId
               andAccessToken:(NSString *)accessToken andDeviceId:(NSString *)deviceID{
    

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"phone"] = phone;
    dic[@"password"] = passWord;
    dic[@"code"] = DX;
    dic[@"inviter"] = inviter;
    dic[@"openid"] = openId;
    dic[@"access_token"] = accessToken;
    dic[@"deviceId"] = deviceID;
    NSLog(@"%@",dic);
    
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Member/register",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        self.userRegisterBK(code,message);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];


    
}


#pragma mark- 获取短信
- (void)getDXWithPhone:(NSString *)phone andType:(NSInteger)type withMD5Code:(NSString *)MD5 andImageCode:(NSString *)code{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"phone"] = phone;
    dic[@"sign"] = MD5;
    dic[@"code"] = code;
    
    if (type == 0) {
        dic[@"type"] = @"register";

    }else{
        dic[@"type"] = @"find-password";

    }
    
    NSLog(@"%@",dic);
    
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Member/sendSms",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];

        if (type == 0) {
            self.userDXmessageBK(code,message);

        }else{
            self.findPassWordDXmessageBK(code,message);

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
    



}
#pragma mark- 用户登录
- (void)userLoginWithPhone:(NSString *)phone andPassWord:(NSString *)passWord{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"phone"] = phone;
    dic[@"password"] = passWord;
    NSLog(@"%@",dic);
    
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Member/login",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        if ([code isEqualToString: @"1"]) {
            
            if (responseObject[@"data"] != [NSNull null]) {
                
                NSDictionary * dic = responseObject[@"data"];
                NSString * uid = dic[@"uid"];
                NSString * token = dic[@"token"];
                
                
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                
                NSDictionary * dics = [defaults objectForKey:@"userInfo"];
                
                NSMutableDictionary * muDic = [NSMutableDictionary dictionaryWithDictionary:dics];
                
                muDic[@"uid"] = uid;
                muDic[@"token"] = token;
                muDic[@"login"] = @"1";
                [defaults setObject:[NSDictionary dictionaryWithDictionary:muDic] forKey:@"userInfo"];
                
                [defaults synchronize];

                NSLog(@"uid=%@ token=%@",uid,token);
                
                [MobClick profileSignInWithPUID:uid];
                
                [UMessage setAlias:uid type:kUMessageAliasTypeWeiXin response:^(id responseObject, NSError *error) {
                }];
            }
            
        }
        
        self.userLoginBK(code,message);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
    


}


#pragma mark- 找回重置密码
- (void)findBackUserWithPhone:(NSString *)phone andDXstring:(NSString *)DX andPassword:(NSString *)passWord{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"phone"] = phone;
    dic[@"password"] = passWord;
    dic[@"code"] = DX;
    NSLog(@"%@",dic);
    
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Member/findPassword",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        self.findBackPassWordBK(code,message);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
    


}
#pragma mark- 退出登录
- (void)outOfLoginWithTokenAndUid{
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
   
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    
    NSLog(@"%@",dic);
    
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Member/logout",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        
        if ([code isEqualToString:@"1"]) {
            
            
            [UMessage removeAlias:dict[@"uid"] type:kUMessageAliasTypeWeiXin response:^(id responseObject, NSError *error) {
            }];
            
            
            NSUserDefaults * defaul = [NSUserDefaults standardUserDefaults];

            
            NSDictionary * dic = [defaul objectForKey:@"userInfo"];
            
            NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:dic];
            dict[@"login"] = @"0";
            
            [defaul setObject:[NSDictionary dictionaryWithDictionary:dict] forKey:@"userInfo"];
            
            [defaul synchronize];
            
            NSLog(@"%@",defaul);
        }

        
        
        self.outLoginBK(code,message);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}

#pragma mark- 上传头像
- (void)userIconUpLoadToPhp:(NSData *)data{
    NSUserDefaults * defaul = [NSUserDefaults standardUserDefaults];
    
    NSDictionary * dic = [defaul objectForKey:@"userInfo"];
    
    NSString * uid = dic[@"uid"];
    NSString * token = dic[@"token"];
    
    NSDictionary * dict = @{@"uid":uid,@"token":token};
    NSLog(@"%@",dict);
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/member/avatar",DomainURL];
    
    
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    [manger POST:urls parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        /**
         *  appendPartWithFileData   //  指定上传的文件
         *  name                    //  指定在服务器中获取对应文件或文本时的key
         *  fileName                //  指定上传文件的原始文件名
         *  mimeType                //  指定文件的类型
         */
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Success: %@", responseObject[@"code"]);
        
        NSLog(@"message: %@", responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];

        self.userIconUpLoadBK(code,message);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@",error);
    }];

}

#pragma mark- 历史阅读

- (void)userHistoryRedAddArticleWithUidAndTokenAndID:(NSString *)Article_id andTitle:(NSString *)title{
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    dic[@"id"] = Article_id;
    dic[@"title"] = title;
    NSLog(@"%@",dic);
    
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Member/readCache",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSLog(@"添加历史阅读%@",code);
        NSLog(@"%@",message);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}


/**显示历史阅读记录*/
- (void)userHistoryRedShowListWithUidAndToken{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    
    NSLog(@"%@",dic);
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Member/readList",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        NSString * count = @"0";
        
        NSMutableArray * dataArray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
            
            if (responseObject[@"data"] != [NSNull null]) {
                
                NSArray * data = responseObject[@"data"];
                
                for (NSDictionary * dic in data) {
                    
                    HistoryRedModel * model = [[HistoryRedModel alloc]initWithDictionary:dic error:nil];
                    
                    [dataArray addObject:model];
                }
            }
            
            count = [NSString stringWithFormat:@"%@",responseObject[@"count"]];
            
        }
        
        self.historyArticleReadListBK(code,message,count,dataArray,nil);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];


}


#pragma mark- 文章分类
- (void)getArticleChannelClassifyFromNet{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Article/getClass",DomainURL];
    
    [manger POST:urls parameters:nil  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSMutableArray * muarray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
            
            if (responseObject[@"data"] != [NSNull null]) {
                
                NSArray * array = responseObject[@"data"];
                
                for (NSDictionary *dic in array) {
                    ArticleClassifyModel * model = [[ArticleClassifyModel alloc]initWithDictionary:dic error:nil];;
                    [muarray addObject:model];
                    
                }
            }
        }
        
        self.articleClassifyBK(code,message,nil,muarray,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];


}


#pragma mark- 文章列表
- (void)getArticleListFromNetWithC_id:(NSString * )c_id andPageIndex:(NSString *)pageIndex andUid:(NSString *)uid andType:(NSString *)type{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];

    
#pragma mark-设置超时时间
    // 设置超时时间为10秒,不能设置为0秒，无效
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 5.0f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"c_id"] = c_id;
    dic[@"pageIndex"] = pageIndex;
    dic[@"uid"] = uid;
    
    if (type) {
        
        dic[@"type"] = type;
    }
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Article/article",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSMutableArray * muarray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
            
            if (responseObject[@"data"] != [NSNull null]) {
                
                NSArray * array = responseObject[@"data"];
                
                for (NSDictionary *dic in array) {
                    ArticleListModel * model = [[ArticleListModel alloc]initWithDictionary:dic error:nil];;
                    [muarray addObject:model];
                    
                }
            }
        }
        
        self.articleListBK(code,message,nil,muarray,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
        if (error.code == - 1001) {
            
            NSLog(@"网络请求超时！！！！！");
            
            
            self.netFailBK();
            
        }
        
        
    }];



}

#pragma mark-视频列表
- (void)getVideoListFromNetWithPage:(NSString *)page{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"page"] = page;
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Article/videoList",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSMutableArray * muarray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
            
            if (responseObject[@"data"] != [NSNull null]) {
                
                NSArray * array = responseObject[@"data"];
                
                for (NSDictionary *dic in array) {
                    ArticleListModel * model = [[ArticleListModel alloc]initWithDictionary:dic error:nil];;
                    [muarray addObject:model];
                    
                }
            }
        }
        
        self.videoListBK(code,message,nil,muarray,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}

#pragma mark- 收藏
/**添加收藏*/
- (void)userAddCollectionArticleWithArticleAid:(NSString *)aid{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    dic[@"aid"] = aid;
    dic[@"deviceid"] = @"iOS";
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Collection/addMemberCollection",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
                
        self.userAddCollectinBK(code,message);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}

/**取消收藏*/
- (void)userCancleCollectionArticleWithArticleAid:(NSString *)aid{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    dic[@"aid"] = aid;
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Collection/cancelMemberCollection",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        
        self.userCancleCollectionBK(code,message);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}

/**显示收藏*/
- (void)userAllCollectionArticleListWithPage:(NSInteger)page{
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    dic[@"page"] = [NSString stringWithFormat:@"%ld",page];
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Collection/index",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSMutableArray * dataArray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
            
            if (responseObject[@"data"] != [NSNull null]) {
                
                NSArray * data = responseObject[@"data"];
                
                for (NSDictionary * dic in data) {
                    
                    ArticleListModel * model = [[ArticleListModel alloc]initWithDictionary:dic error:nil];
                    
                    [dataArray addObject:model];
                }
            }
        }
        
        self.userArticleCollectionListBK(code,message,nil,dataArray,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}

/**是否收藏*/
- (void)userIsOrNotCollectionArticleWithArticleAid:(NSString *)aid{
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    dic[@"aid"] = aid;
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Collection/isCollection",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSString * data = @"0";
        
        NSMutableArray * dataArray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
        
            data = responseObject[@"data"];
        }
        
        NSDictionary * article = responseObject[@"article"];
        
        NSString * read_price = [NSString stringWithFormat:@"%@",article[@"read_price"]];
        NSString * sum_money = [NSString stringWithFormat:@"%@",article[@"sum_money"]];
        
        if (read_price == nil || [read_price isEqualToString:@"<null>"]) {
            
            read_price = @"0.00";
        }
        
        
        if (sum_money == nil || [sum_money isEqualToString:@"<null>"]) {
            
            sum_money = @"0.00";
        }
        
        [dataArray addObject:read_price];
        [dataArray addObject:sum_money];
        
        self.userIsOrNotCollectionBK(code,message,data,dataArray,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}


#pragma mark- 验证登录
/**验证token*/
- (void)checkLoginToken{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Member/checkLoginToken",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        if (![code isEqualToString:@"1"] || code == nil) {
            
            NSMutableDictionary * newDic = [NSMutableDictionary dictionaryWithDictionary:dict];
            
            newDic[@"login"] = @"0";
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:newDic] forKey:@"userInfo"];
        }
        
        self.checkLoginTokenBK(code,message);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}


#pragma mark- 签到
- (void)userRegisterEveryDay{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/mission/sign",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        NSString * amount ;
        
        if ([code isEqualToString:@"1"]) {
          amount  = [NSString stringWithFormat:@"%@",responseObject[@"amount"]];
        }else{
          amount = @"0";
        }
        
        self.registerEveryDayBK(code,message,amount,nil,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];



}

#pragma mark- 任务中心数据请求
- (void)testCenterDataFromNet{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    NSLog(@"%@",dic);
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/mission/missionCenter",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];

        
        NSMutableArray * dataArray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
            
            if(responseObject[@"data"] != [NSNull null]){
            
                TestCenterModel * model = [TestCenterModel allocWithDict:responseObject[@"data"]];
            
                [dataArray addObject:model];
            }
            
        }
        
        self.testCenterBK(code,message,nil,dataArray,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}



#pragma mark- 支付宝
/**支付宝提现金额*/
- (void)aliPayCashGetFromNet{
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Exchange/alipay",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        
        NSMutableArray * dataArray = [NSMutableArray new];
        NSString * currentMoney;
        
        if ([code isEqualToString:@"1"]) {
            
            currentMoney = [NSString stringWithFormat:@"%@",responseObject[@"money"]];
            
            if(responseObject[@"data"] != [NSNull null]){
                
                NSArray * data = responseObject[@"data"];
                
                NSLog(@"%@",data);
                
                for (int i = 0; i < (int)data.count; i ++) {
                    
                    NSString * cash = [NSString stringWithFormat:@"%@",data[i]];
                    
                    [dataArray addObject:cash];
                }
            }
            
        }
        
        if (currentMoney == nil) {
            
            currentMoney = @"0.00";
        }
        
        self.aliPayCashBK(code,message,currentMoney,dataArray,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}

/**支付宝提现申请*/
- (void)aliPayCashOrderGetFromNetWithMoney:(NSString *)price andAliPayAccount:(NSString *)alipay
                                   andName:(NSString *)realname
                               andPassWord:(NSString *)password{
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    dic[@"realname"] = realname;
    dic[@"alipay"] = alipay;
    dic[@"price"] = price;
    dic[@"password"] = password;

    NSString * urls = [NSString stringWithFormat:@"%@/App/Exchange/handleAlipay",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        self.aliPayWithDrawOrderBK(code,message);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}




#pragma mark- 文章搜索
/**文章搜索*/
- (void)articleSearchGetDataFromNetWithTitle:(NSString *)title{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"title"] = title;
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Article/search",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSMutableArray * dataArray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
            
            if(responseObject[@"data"] != [NSNull null]){
                
                NSArray * data = responseObject[@"data"];
                
                for (NSDictionary * dics in data) {
                    
                    ArticleListModel * model = [[ArticleListModel alloc]initWithDictionary:dics error:nil];
                
                    [dataArray addObject:model];
                }
                
            }
            
        }
        
        self.searchArticleDataBK(code,message,nil,dataArray,nil);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}


#pragma mark- 文章排行榜
/**文章排行榜*/
- (void)articleRankListGetDataWithType:(NSString *)type andPage:(NSInteger)page andC_id:(NSString *)c_id{

//状态 redbool为蹿红，week为周榜，all为总榜

    
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"type"] = type;
    dic[@"page"] = [NSString stringWithFormat:@"%ld",page];
    dic[@"c_id"] = c_id;
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Article/getclickban",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSMutableArray * dataArray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
            
            if(responseObject[@"data"] != [NSNull null]){
                
                NSArray * data = responseObject[@"data"];
                
                for (NSDictionary * dics in data) {
                    
                    ArticleListModel * model = [[ArticleListModel alloc]initWithDictionary:dics error:nil];
                    
                    [dataArray addObject:model];
                }
                
            }
            
        }
        
        self.articleRankBK(code,message,nil,dataArray,nil);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

    
    
}

#pragma mark- 用户排行
/**用户排行*/
- (void)userRankListGetFromNetWithType:(NSString *)type andTime:(NSString * )time andPage:(NSInteger)page{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"type"] = type;
    dic[@"page"] = [NSString stringWithFormat:@"%ld",page];
    dic[@"time"] = time;
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Index/Ranking",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSMutableArray * dataArray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
            
            if(responseObject[@"data"] != [NSNull null]){
                
                NSArray * data = responseObject[@"data"];
                
                for (NSDictionary * dics in data) {
                    
                    UserRankModel  * model = [[UserRankModel alloc]initWithDictionary:dics error:nil];
                    
                    [dataArray addObject:model];
                }
                
            }
            
        }
        
        self.userRankBK(code,message,nil,dataArray,nil);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}

#pragma mark- 写评论或回复
/**评论回复点赞*/
- (void)writeCommentAndRespondWithTypr:(NSInteger)type
                                andContent:(NSString *)content
                                andID:(NSString *)ID
                                andAID:(NSString *)aid
                                andRelation:(NSString *)relation
                                andRelname:(NSString *)relname{

    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];;

    if (type == commentType_comment) {          //评论

        dic[@"type"] = @"comment";
        dic[@"aid"] = aid;
        dic[@"content"] = content;

    }else if (type == commentType_responds){    //回复

        dic[@"type"] = @"comment";
        dic[@"id"]=ID;
        dic[@"aid"] = aid;
        dic[@"content"] = content;
        dic[@"relation"] = relation;
        dic[@"relname"] = relname;
    }else{                                      //点赞
        dic[@"type"] = @"up";
        dic[@"id"]=ID;
    }
    
    
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/mission/comment",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        
        self.commentBK(code,message);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

    
    
}


#pragma mark-评论列表
/**评论列表*/
- (void)getCommentListDataFromNetWithAid:(NSString *)aid andPage:(NSInteger)page{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];

    dic[@"aid"]= aid;
    dic[@"page"] = [NSString stringWithFormat:@"%ld",page];
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Index/comList",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSMutableArray * dataArray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
            
            if (responseObject[@"data"] != [NSNull null]) {
                
                NSArray * data = responseObject[@"data"];
                
                for (NSDictionary * dict in data) {
                    
                    CommentListModel * model = [[CommentListModel alloc]initWithDictionary:dict error:nil];
                    
                    [dataArray addObject:model];
                }
                
                
                
                NSLog(@"%@",dataArray);
            }
            
            
        }

        self.commentListBK(code,message,nil,dataArray,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
    

}

#pragma mark- 个人主页
/**个人主页*/
//类型 share 分享 comment 评论 colletion 收藏
- (void)personCenterDataGetFromNetWith:(NSInteger)page andType:(NSString *)type andUid:(NSString *)uid{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = uid;
    dic[@"page"] =[NSString stringWithFormat:@"%ld",page];
    dic[@"type"] = type;
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Index/UserCenter",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSMutableArray * dataArray = [NSMutableArray new];
        
        MemberModel * member;

        
        NSLog(@"responseObject=%@",responseObject);

        
        if ([code isEqualToString:@"1"]) {
            
            if (responseObject[@"data"] != [NSNull null]) {
                
                NSArray * data = responseObject[@"data"];
                
                if (data.count > 0) {
                
                    for (NSDictionary * dict in data) {
                    
                        PersonCenterModel * pModel = [[PersonCenterModel alloc]initWithDictionary:dict error:nil];
                    
                        [dataArray addObject:pModel];
                    }
                
                }
                
                NSLog(@"%@",dataArray);
            }
            
            
            if (responseObject[@"member"] != [NSNull null]) {
                
                NSDictionary * memberDic = responseObject[@"member"];
                
                 member = [[MemberModel alloc]initWithDictionary:memberDic error:nil];
                
                NSLog(@"%@",member);

            }
            
        }
        
        self.personHomeBK(code,message,nil,dataArray,@[member]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}


#pragma mark- 新手任务
/**新手任务*/
- (void)personNewTestStatue{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/mission/getNewTask",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        
        NSMutableArray * dataArray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
            
            if(responseObject[@"data"] != [NSNull null]){
                
                NSDictionary * data = responseObject[@"data"];
                
                FistNewUserTestModel * model = [[FistNewUserTestModel alloc]initWithDictionary:data error:nil];
                
                [dataArray addObject:model];
            }
            
        }
        
        self.personNewTestBK(code,message,nil,dataArray,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];


}


#pragma mark- 领取新手任务
/**领取新手任务*/
- (void)personNewTestFinish{


    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/mission/giveNewMission",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        
        self.personNewTestFinishBK(code,message);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];


}



#pragma mark- 我的数据（用户中心）
/**我的*/
- (void)getMineDataSource{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Index/index",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        
        NSMutableArray * dataArray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
            
            if(responseObject[@"data"] != [NSNull null]){
                
                NSDictionary * data = responseObject[@"data"];
        
                //============================
                NSDictionary * member = data[@"member"];
                
                if (responseObject[@"member"] != [NSNull null]) {
                    
                    MineDataSourceModel * model = [[MineDataSourceModel alloc]initWithDictionary:member error:nil];
                    model.today_read = [NSString stringWithFormat:@"%@",data[@"today_read"]];
                    model.sum_read = [NSString stringWithFormat:@"%@",data[@"sum_read"]];
                    model.type = [NSString stringWithFormat:@"%@",data[@"type"]];
                    model.prentice = [NSString stringWithFormat:@"%@",data[@"prentice"]];
                    
                    
                    NSDictionary * today_info = member[@"today_info"];
                    model.today_income = [NSString stringWithFormat:@"%@",today_info[@"today_income"]];
                    model.today_prentice = [NSString stringWithFormat:@"%@",today_info[@"today_prentice"]];

                    
                    if (model.today_read == nil) {
                        
                        model.today_read = @"0";
                    }
                    
                    
                    if (model.sum_read == nil) {
                        
                        model.sum_read = @"0";
                    }
                    
                    
                    model.hb_new_hb = member[@"new_hb"];
                    
                    NSLog(@"%@",model);
                    
                    [dataArray addObject:model];
                }
                
            
            }
            
        }
        
        self.mineDataSourceBK(code,message,nil,dataArray,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}


#pragma mark-广告推广语
/**广告推广语*/
- (void)advStringGetDataFromNet{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];

    
    NSString * urls = [NSString stringWithFormat:@"%@/App/share/getAds",DomainURL];
    
    [manger POST:urls parameters:nil  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        
        NSMutableArray * dataArray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
            
            if(responseObject[@"data"] != [NSNull null]){
                
                NSArray * data = responseObject[@"data"];
                
                for (NSDictionary * dic in data) {
                    
                    AdvStringModel * model = [[AdvStringModel alloc]initWithDictionary:dic error:nil];
                    
                    [dataArray addObject:model];
                }
            }
            
        }
        
        self.advStringBK(code,message,nil,dataArray,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}

#pragma mark- 我的回复
- (void)getMyRespondDataFromNetWithPage:(NSInteger)page{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    dic[@"page"] = [NSString stringWithFormat:@"%ld",page];
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Member/getComment",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        
        NSMutableArray * dataArray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
            
            if(responseObject[@"data"] != [NSNull null]){
                
                NSArray * data = responseObject[@"data"];
                
                for (NSDictionary * dic in data) {
                    
                    RespondToMineModel * model = [[RespondToMineModel alloc]initWithDictionary:dic error:nil];
                    
                    if (model.tourist) {
                        
                        model.tourist_nickname = model.tourist[@"nickname"];
                        model.tourist_headimgurl = model.tourist[@"headimgurl"];
                    }
                    
                    if (model.comment) {
                        model.comment_content = model.comment[@"content"];
                        model.comment_nickname = model.comment[@"nickname"];
                    }
                    
                    if (model.article) {
                        
                        model.article_id = model.article[@"id"];
                        model.article_title = model.article[@"title"];
                    }
                    
                    if (model) {
                        
                        [dataArray addObject:model];
                        
                    }
                }
                
            }
            
        }
        
        self.myRespondDataBK(code,message,nil,dataArray,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}



#pragma merk- 系统通知
/**系统通知*/
- (void)getSystemMessageFromNetWithPage:(NSInteger)page{

    NSString * urls = [NSString stringWithFormat:@"%@/App/Notice/index",DomainURL];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"page"] = [NSString stringWithFormat:@"%ld",page];
    
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    [manger GET:urls parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject[@"code"]);
        NSLog(@"%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];

        NSMutableArray * dataArray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
            
            if(responseObject[@"data"] != [NSNull null]){
                
                NSArray * data = responseObject[@"data"];

                for (NSDictionary * dic in data) {
                
                    systemMessageModel * model = [[systemMessageModel alloc]initWithDictionary:dic error:nil];
                    
                    if (model) {
                        
                        [dataArray addObject:model];
                        
                    }
                }
            
            }
            
            self.systemMessageDataBK(code,message,nil,dataArray,nil);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}


#pragma merk- 系统通知详情
/**系统通知详情*/
- (void)systemMessageDetailFromNetWithID:(NSString *)ID{

    NSString * urls = [NSString stringWithFormat:@"%@/App/Notice/detail",DomainURL];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"id"] = [NSString stringWithFormat:@"%@",ID];

    
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    [manger GET:urls parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject[@"code"]);
        NSLog(@"%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSMutableArray * dataArray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
            
            if(responseObject[@"data"] != [NSNull null]){
                
                NSDictionary * data = responseObject[@"data"];
               
                NSLog(@"%@",responseObject[@"data"]);
                
                systemMessageModel * model = [[systemMessageModel alloc]initWithDictionary:data error:nil];
                
                if (model) {
                    
                    [dataArray addObject:model];
                    
                }
            }
            self.systemMessageDetailBK(code,message,nil,dataArray,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];


}




#pragma mark- 收益明细
/**收益明细*/
- (void)profitDetailFromNetWithPage:(NSInteger)page andType:(NSInteger)type{


    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    dic[@"page"] = [NSString stringWithFormat:@"%ld",page];
    dic[@"type"] = [NSString stringWithFormat:@"%ld",type];
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Profit/profit",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        
        NSMutableArray * dataArray = [NSMutableArray new];

        if ([code isEqualToString:@"1"]) {
         
            NSArray * data = responseObject[@"data"];
            
            if (data.count > 0) {
                
                for (NSDictionary * dics in data) {
                    
                    TaskAndInviateIncomeModel * model = [[TaskAndInviateIncomeModel alloc]initWithDictionary:dics error:nil];
                    [dataArray addObject:model];
                }
                
            }
            
        }
        
        
        self.profitDetailBK(code,message,nil,dataArray,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];


}


#pragma mark- 关于我们
/**关于我们*/

- (void)aboutUsMessageFromNet{


    NSString * urls = [NSString stringWithFormat:@"%@/App/Index/about",DomainURL];
    
    
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    [manger GET:urls parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject[@"code"]);
        NSLog(@"%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSMutableArray * dataArray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
            
            if(responseObject[@"data"] != [NSNull null]  ){
                
                    NSDictionary * data = responseObject[@"data"];
                
                if (data) {

                    AboutUsModel * model = [[AboutUsModel alloc]initWithDictionary:data error:nil];
                
                        if (model) {
                    
                            [dataArray addObject:model];
                        }
                
                }
            }
            
            self.aboutUsBK(code,message,nil,dataArray,nil);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}




#pragma mark- 徒弟列表
/**徒弟列表*/
- (void)fiendListFromNetWithPage:(NSInteger)page{


    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    dic[@"page"] = [NSString stringWithFormat:@"%ld",page];
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Prentice/getInviterList",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        
        NSMutableArray * dataArray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
            
            if(responseObject[@"data"] != [NSNull null]){
                
                NSArray * data = responseObject[@"data"];
                
                for (NSDictionary * dic in data) {
                    
                    
                    FriendListModel * model = [[FriendListModel alloc]initWithDictionary:dic error:nil];
                    
                    if (model) {
                        
                        [dataArray addObject:model];
                    }
                    
                }
                
            }
            
        }
        
        self.frientListBK(code,message,nil,dataArray,nil);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];


}



#pragma mark- 提现记录
/**提现记录*/
- (void)AliPayWithDrawRecordWithPage:(NSInteger)page{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    
#pragma mark-设置超时时间
    // 设置超时时间为10秒,不能设置为0秒，无效
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 5.0f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    dic[@"page"] = [NSString stringWithFormat:@"%ld",page];
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Exchange/record",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        
        NSMutableArray * dataArray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
            
            if(responseObject[@"data"] != [NSNull null]){
                
                NSArray * data = responseObject[@"data"];
                
                for (NSDictionary * dic in data) {
                    
                    
                    withDrawCashRecordModel * model = [[withDrawCashRecordModel alloc]initWithDictionary:dic error:nil];
                    
                    if (model) {
                        
                        [dataArray addObject:model];
                    }
                    
                }
                
            }
            
        }
        
        self.aliPayWithDrawRecordBK(code,message,nil,dataArray,nil);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
        if (error.code == - 1001) {
            
            NSLog(@"网络请求超时！！！！！");
            
            
            self.netFailBK();
            
        }

    }];


}



#pragma mark- 收徒链接(晒)
/**收徒链接(晒)*/
- (void)shouTuLinkMessageFromNet{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Prentice/getInviterUrl",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
//        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        
        NSString * sum_money;
        NSString * url;
        NSString * imgurl;
        
        if ([code isEqualToString:@"1"]) {
            
            if(responseObject[@"data"] != [NSNull null]){
                
                NSDictionary * data = responseObject[@"data"];
                
                if (data) {
                    
                    sum_money = [NSString stringWithFormat:@"%@",data[@"sum_money"]];
                    url = [NSString stringWithFormat:@"%@",data[@"url"]];
                    imgurl = [NSString stringWithFormat:@"%@",data[@"imgurl"]];
                    
                }
                
            }
            
        }
        
        self.shouTuLinkMessageBK(sum_money,url,imgurl,nil,nil);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];


}


#pragma mark- 我的资料
/**我的资料*/
- (void)mineDetailDataFromNet{


    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Member/getUserData",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSMutableArray * dataArray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
            
            if(responseObject[@"data"] != [NSNull null]){
                
                NSDictionary * data = responseObject[@"data"];
                
                if (data) {
                    
                    MineDetailModel * model = [[MineDetailModel alloc]initWithDictionary:data error:nil];
                    
                    if (model) {
                        
                        NSDictionary * address = model.address;
                        
                        if (address) {
                            model.name = address[@"name"];
                            model.rephone = address[@"rephone"];
                            model.region = address[@"region"];
                            model.address_address = address[@"address"];
                        }
                        
                        
                        [dataArray addObject:model];
                    }
                    
                }
                
            }
        }
        
            self.MineDetailDataBK(code,message,nil,dataArray,nil);
            
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];


}

#pragma mark- 修改资料
/**修改资料*/
- (void)changeMineDataFromNetWithType:(NSString *)type
                               andSex:(NSString *)sex
                          andNickName:(NSString *)nickName
                       andAddressName:(NSString *)name
                           andRephone:(NSString *)rephone
                            andRegion:(NSString *)region
                           andAddress:(NSString *)address{


    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    dic[@"type"] = type;
    
    if ([type isEqualToString:@"nickname"]) {
        
        dic[@"nickname"] = nickName;
        
    }else if ([type isEqualToString:@"sex"]){
        dic[@"sex"] = sex;
    
    }else if ([type isEqualToString:@"address"]){
    
        dic[@"name"] = name;
        dic[@"rephone"] = rephone;
        dic[@"region"] = region;
        dic[@"address"] = address;
    }
    

    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Member/changeMember",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
      
        self.changeMineDataBK(code,message);
        
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];


}


#pragma mark- 我的邀请码-邀请链接
/**我的邀请码-邀请链接*/
- (void)mineInviateCodeAndInviateLink{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Prentice/inviteHtml",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSMutableArray * array = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
            
            NSDictionary * data = responseObject[@"data"];
            if (data) {
            
                NSString * inviter = [NSString stringWithFormat:@"%@",data[@"inviter"]];
                NSString * url = data[@"url"];
                NSString * prentice = data[@"prentice"];
                NSString * superior = data[@"superior"];
                NSString * prentice_sum_money = data[@"prentice_sum_money"];
                NSString * disciple_sum_money = data[@"disciple_sum_money"];
                NSString * font = data[@"font"];

                
                [array addObject:inviter];
                [array addObject:url];
                [array addObject:prentice];
                [array addObject:superior];
                [array addObject:prentice_sum_money];
                [array addObject:disciple_sum_money];
                [array addObject:font];

            }
        }
        
        self.mineInviateCodeAndInviteLinkBK(code,message,nil,array,nil);

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];


}

#pragma mark- 提交邀请码
/**提交邀请码*/
- (void)iniateCodePushAndinviateCode:(NSString *)code{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    dic[@"inviter"] = code;
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Prentice/setInviterUser",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        
        self.inviateCodePushBK(code,message);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];


}



#pragma mark- 反馈列表
/**反馈列表*/
- (void)respondListFromNetWithPage:(NSInteger)page{


    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    dic[@"page"] = [NSString stringWithFormat:@"%ld",page];
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/mission/backList",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSMutableArray * dataArray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
         
            if (responseObject[@"data"] != [NSNull null]) {
                
                NSArray * data = responseObject[@"data"];
                
                if (data.count > 0) {
                    
                    for (NSDictionary * dic in data) {
                        
                        RespondListModel * model = [[RespondListModel alloc]initWithDictionary:dic error:nil];
                        
                        model.headimgurl = responseObject[@"headimgurl"];
                        
                        [dataArray addObject:model];
                    }
                    
                    
                }
                
            }
            
            
        }
        
        
        self.respondListBK(code,message,nil,dataArray,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

    
}

#pragma mark- 提交反馈
/**提交反馈*/
- (void)respondSendToNetWithContent:(NSString *)content{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    dic[@"content"] = content;
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/mission/feedback",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        
        self.respondSendBk(code,message);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}


#pragma -mark 推送文章的分享链接
/**推送文章的分享链接*/
- (void)pushArticleShareAndSlinkWithID:(NSString *)ID{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
//    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"id"] = ID;
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Article/getShareUser",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
//        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSString * slink;
        NSString * share;
        
        if ([code isEqualToString:@"1"]) {
            
            if (responseObject[@"data"] != [NSNull null]) {
                
                NSDictionary * data = responseObject[@"data"];
                
                if (data && data[@"slink"] && data[@"share"]) {
                    
                    slink = data[@"slink"];
                    share = data[@"share"];
                
                }
            }
            
        }
        
        self.pushArticleShareAndSlinkBK(code,share,slink,nil,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];


}

#pragma mark- 获取高收益文章的收益
/**获取高收益文章的收益*/
- (void)getHeightPriceArticleMoneyWithArticleID:(NSString * )aid andPrice:(NSString *)read_price{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"aid"] = aid;
    dic[@"read_price"] = read_price;
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/mission/shareNow",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        self.getHeightPriceArticleMoneyBK(code,message);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];


}


#pragma mark- 版本更新
/**版本更新*/
- (void)checkNewVersionFromNet{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
//    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
//    NSMutableDictionary * dic = [NSMutableDictionary new];
   
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Index/IOSUpload",DomainURL];
    
    [manger POST:urls parameters:nil  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSMutableArray * dataArray = [NSMutableArray new];
        
        if ([code isEqualToString: @"1"]) {
            
            if (responseObject[@"data"] != [NSNull null]) {
                
                NSDictionary * data = responseObject[@"data"];
                
                if (data) {
                    
                    VersionModel * model = [[VersionModel alloc]initWithDictionary:data error:nil];
                
                    [dataArray addObject:model];
                }
            }
        }
        
        self.checkNewVewsionBK(code,message,nil,dataArray,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}


#pragma mark- 获取自动跳转分享链接
/**自动跳转分享链接*/
- (void)getAutoShareLinkFromNetWithShareType:(NSString *)type andAid:(NSString *)aid andUid:(NSString *)uid{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
//    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
//    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    dic[@"uid"] = uid;
    dic[@"type"] = type;
    dic[@"id"] = aid;
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Article/gshare",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * uc;
        NSString * qq;
        NSString * ys;

        if ([code isEqualToString:@"1"]) {
            
            if (responseObject[@"data"] != [NSNull null]) {
                
                NSDictionary * data = responseObject[@"data"];
                
                if (data) {
                    
                    uc = [NSString stringWithFormat:@"%@",data[@"uc"]];
                    qq = [NSString stringWithFormat:@"%@",data[@"qq"]];
                    ys = [NSString stringWithFormat:@"%@",data[@"ys"]];

                }
                
            }
        }
        
        self.getAutonShareLinkBK(uc,qq,ys,nil,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}


#pragma mark- 联系我们qq号获取
/**联系我们qq号获取*/
- (void)getQQnumberFromNet{

    NSString * urls = [NSString stringWithFormat:@"%@/App/Index/wabout",DomainURL];
    
    
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    [manger GET:urls parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject[@"code"]);
        NSLog(@"%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
//        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSString * QQ;
        NSString * Key;
        if ([code isEqualToString:@"1"]) {
            
            if(responseObject[@"data"] != [NSNull null]  ){
                
                NSDictionary * data = responseObject[@"data"];
                
                if (data) {

                    NSDictionary * ios = data[@"ios"];
                    
                    QQ = [NSString stringWithFormat:@"%@",ios[@"qq"]];
                    Key = [NSString stringWithFormat:@"%@",ios[@"key"]];
                    
                }
            }
            
        }
        
        self.QQnumberLinkGetBK(code, QQ, Key, nil, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

    
}

#pragma mark- 审核隐藏
/**审核隐藏 data = 1 显示 ；data=0 隐藏 */
- (void)hidenWhenReviewFromNet{
    NSString * urls = [NSString stringWithFormat:@"%@/App/Index/get_state",DomainURL];
    
    
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    [manger GET:urls parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject[@"code"]);
        NSLog(@"%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        //        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSString * data = @"0";
        
        if ([code isEqualToString:@"1"]) {
            
            data = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
        }
        
        self.hidenWhenReviewBK(code, data);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}


#pragma mark- 徒孙列表
/**徒孙列表*/
- (void)discipleListGetFormNetWithPage:(NSInteger)page{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    dic[@"page"] = [NSString stringWithFormat:@"%ld",page];
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Prentice/getInviterLists",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSMutableArray * dataArray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
            
            if(responseObject[@"data"] != [NSNull null]){
                
                NSArray * data = responseObject[@"data"];
                
                for (NSDictionary * dic in data) {
                    
                    
                    FriendListModel * model = [[FriendListModel alloc]initWithDictionary:dic error:nil];
                    
                    if (model) {
                        
                        [dataArray addObject:model];
                    }
                    
                }
                
            }
            
        }

        self.discipleListBK(code, message, nil, dataArray, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}



#pragma mark- 微信授权绑定
- (void)NetBindWeiChatAccountWith:(NSString *)access_token andOpenid:(NSString *)openid andUnionid:(NSString *)unionid{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    dic[@"access_token"] = access_token;
    dic[@"openid"] = openid;
    dic[@"unionid"] = unionid;

    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Member/wxbinding",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        self.bindWeiChatAccountBK(code, message);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];


}


#pragma mark- 微信授权绑定第二步/完成
/**微信授权绑定第二步/完成*/
- (void)NetBindWeiChatAccountStepSecond{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    NSString * urls = [NSString stringWithFormat:@"%@/App/Member/subscribeBind",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        self.bindWeiChatAccountSecondBK(code, message);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}

#pragma maek- 微信账号绑定完成度
/**微信账号绑定完成度*/
- (void)NetBindWeiChatAccountFinishProgress{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    NSString * urls = [NSString stringWithFormat:@"%@/App/Member/bind",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
//        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSString * bind = @"0";
        NSString * wxbind = @"0";
        NSString * exchange_publicno = @"0";
        
        if ([code isEqualToString:@"1"]) {
            
            NSDictionary * data = responseObject[@"data"];
            
            if (![data isEqual: [NSNull null]]) {
                
                bind = [NSString stringWithFormat:@"%@",data[@"bind"]];
                wxbind = [NSString stringWithFormat:@"%@",data[@"wxbind"]];
                exchange_publicno = data[@"exchange_publicno"];
            }
        }
        
        self.bindWeiChatAccountFinishProgressBK(bind, wxbind, exchange_publicno, nil, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}


#pragma mark- 微信/支付宝-可提现金额数据
/**微信支付宝，可提现金额   0-微信  1-支付宝*/
- (void)NetWeiChatAndAliPayCashNumberWithType:(NSString *)type{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    
    NSString * urls;
    NSString * weiChatUrl = [NSString stringWithFormat:@"%@/App/Exchange/wxpay",DomainURL];
    NSString * aliPayUrl = [NSString stringWithFormat:@"%@/App/Exchange/alipay",DomainURL];

    if ([type isEqualToString:@"0"]) {
        urls = weiChatUrl;
    }else if ([type isEqualToString:@"1"]){
        urls = aliPayUrl;
    }
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSMutableArray * dataCash = [NSMutableArray new];
        if ([code isEqualToString:@"1"]) {
        
            NSArray * data = responseObject[@"data"];
            
            if (data.count > 0 && data) {
            
                for (NSObject * obc in data) {
                    
                    NSString * cash = [NSString stringWithFormat:@"%@",obc];
                    
                    [dataCash addObject:cash];
                }

            
            }
            
        }
        
        self.WeiChatAndAliPayCashNumberBK(code, message, type, dataCash, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];



}


#pragma mark- 微信提现申请
/**微信提现申请*/
- (void)NetWeiChatGetCashOrderWithCash:(NSString *)price{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    dic[@"price"] = price;
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Exchange/handleWxpay",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        self.weiChatGetCashOrderBK(code, message);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}


#pragma mark- 中奖纪录
- (void)ChouJiangListGetFromNetWithPage:(NSInteger)page{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    dic[@"page"] = [NSString stringWithFormat:@"%ld",page];
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/mission/draw_list",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSMutableArray * dataArray = [NSMutableArray new];
        if ([code isEqualToString:@"1"]) {
            
            NSArray * data = responseObject[@"data"];
            
            if (data.count > 0) {
                
                for (NSDictionary * dicM in data) {
                 
                    ChouJiangModel * model = [[ChouJiangModel alloc]initWithDictionary:dicM error:nil];
                    
                    [dataArray addObject:model];
                }
                
            }
            
        }
        
        self.ChouJiangListModelDataBK(code, message, nil, dataArray, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];


}

/**文章内价格*/
- (void)NetArticlePriceWithAid:(NSString *)aid andUid:(NSString *)uid{

    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    uid = dict[@"uid"];
    
    
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"aid"] = aid;
    dic[@"uid"] = uid;
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Course/isArticle",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
//        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSString * read_price = @"0.00";
        NSString * sum_money = @"0.00";
        
        if ([code isEqualToString:@"1"]) {
            
            NSDictionary * data = responseObject[@"data"];
            
            if ((![data isEqual:[NSNull null]]) && data != nil) {
            
                read_price = [NSString stringWithFormat:@"%@",data[@"read_price"]];
                sum_money = [NSString stringWithFormat:@"%@",data[@"sum_money"]];
                
                }
            
            if ([sum_money isEqualToString:@"<null>"] || [sum_money isEqualToString:@"(null)"]) {
                
                sum_money = @"0.00";
            }
            
            
            
        }
        
        self.articlePriceBK(code, read_price, sum_money, nil, nil);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];


}


#pragma mark- 活动公告
- (void)NetActivityNotice{
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
  
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Index/get_hd",DomainURL];
    
    [manger POST:urls parameters:nil  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        //        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSString * imgUrl = @"0";
        NSString * wz = @"0";
        
        if ([code isEqualToString:@"1"]) {
            
            NSDictionary * data = responseObject[@"data"];
            
            imgUrl = [NSString stringWithFormat:@"%@",data[@"imgUrl"]];
            wz = [NSString stringWithFormat:@"%@",data[@"wz"]];
        }
        
        self.activityNoticeBK(code, imgUrl, wz, nil, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
    
}

#pragma mark- 每月收益
//每月收益
- (void)NetinComeMonthDataFromNet{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Profit/MonthData",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        
        NSMutableArray * dataArray1 = [NSMutableArray new];
        
        NSArray * dataArray2 = @[@"累计转发",@"累计提成",@"累计签到",@"其他",@"累计提现"];
        
        if ([code isEqualToString:@"1"]) {
            
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                
                NSDictionary * data = responseObject[@"data"];
                
                NSString * forward = [NSString stringWithFormat:@"%@",data[@"forward"]];
                NSString * into = [NSString stringWithFormat:@"%@",data[@"into"]];
                NSString * sign = [NSString stringWithFormat:@"%@",data[@"sign"]];
                NSString * exchan = [NSString stringWithFormat:@"%@",data[@"exchan"]];
                NSString * other = [NSString stringWithFormat:@"%@",data[@"other"]];
                
                [dataArray1 addObject:forward];
                [dataArray1 addObject:into];
                [dataArray1 addObject:sign];
                [dataArray1 addObject:other];
                [dataArray1 addObject:exchan];
            }
        }
        
        self.incomeMonthBK(code, message, nil, dataArray1, dataArray2);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}


#pragma mark- 输入邀请码类型2
- (void)NetInviateCodeTypeTwo{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Prentice/getInviterData",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        NSLog(@"responseObject=%@",responseObject);

        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        NSString * inviate = @"0";
        
        if ([code isEqualToString:@"1"]) {
    
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                
                NSDictionary * data = responseObject[@"data"];
                
                inviate = [NSString stringWithFormat:@"%@",data[@"inviter"]];
                
                if ([inviate isEqualToString:@"<null>"] || [inviate isEqualToString:@"(null)"] || [inviate isEqualToString:@""]) {
                    
                    inviate = @"0";
                }
            }
            
    
        }
        
        
        self.inviateCodeTypeTwoBK(code, message, inviate, nil, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];


}



#pragma mark- 分享纪录
/**分享纪录*/
- (void)NetShareRecordWithPage:(NSInteger)page{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    dic[@"page"] = [NSString stringWithFormat:@"%ld",page];
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/Collection/shareUserList",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        NSLog(@"responseObject=%@",responseObject);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        NSMutableArray * dataArray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
            
            NSArray * data = responseObject[@"data"];
            
            if (data.count > 0) {
                
                for (NSDictionary * dicm in data) {
                    
                    ArticleListModel * model = [[ArticleListModel alloc]initWithDictionary:dicm error:nil];
                    
                    [dataArray addObject:model];
                }
                
                
            }
            
        }
        
        self.shareRecordBK(code, message, nil, dataArray, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];


}


#pragma mark- 用户红包信息
- (void)userRedBaoMessage{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/mission/RedUser",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        NSLog(@"responseObject=%@",responseObject);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        NSMutableArray * dataArray = [NSMutableArray new];
        
        if ([code isEqualToString:@"1"]) {
            
            NSDictionary * data = responseObject[@"data"];
            
            if (![data isEqual:[NSNull null]]) {
                
                RedBaoModel * model = [[RedBaoModel alloc]initWithDictionary:data error:nil];
                
                
                NSLog(@"%@",model);
                
                [dataArray addObject:model];
            }
        }
        
        self.RedBaoMessageBK(code, message, nil, dataArray, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}


#pragma mark- 领取红包
- (void)getRedBao{

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    //    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"uid"] = dict[@"uid"];
    dic[@"token"] = dict[@"token"];
    
    NSString * urls = [NSString stringWithFormat:@"%@/App/mission/markRed",DomainURL];
    
    [manger POST:urls parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"code=%@",responseObject[@"code"]);
        NSLog(@"message=%@",responseObject[@"message"]);
        NSLog(@"responseObject=%@",responseObject);
        
        NSString * code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString * message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        NSString * amount = [NSString stringWithFormat:@"%@",responseObject[@"amount"]];
        
        if (amount == nil || [amount isEqualToString:@"<null>"] || [amount isEqualToString:@"(null)"]) {
            
            amount = @"0";
        }

        self.GetRedBaoBK(code, message, amount, nil, nil);

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}
@end
