//
//  WebViewController.m
//  NewApp
//
//  Created by gxtc on 17/2/17.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
@property (nonatomic,strong)UIWebView * webView;
@property(nonatomic,strong)NJKWebViewProgress * progress;
@property(nonatomic,strong)NJKWebViewProgressView * progressView;

@property (nonatomic,strong)MainShareView * shareView;

@end

@implementation WebViewController


- (void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [self registerForKeyboardNotifications];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self addUI];
    
    [self WebNwe];
    
    if (self.isPost) {
        
        [self WebPostRequest];
        
    }else{
        
        [self WebGetRequest];

    }

}


- (void)addUI{
    
    [self addNavBarViewNew];
    
    if (!self.isNewTeach) {
        
        [self rootWebBottomViewNew];
        
    }

}


/**添加本地历史阅读记录*/
- (void)addCoreDataWithArticleHestoryRead{

    CoreDataManger * CDManger = [CoreDataManger shareCoreDataManger];
    
    [CDManger insertReadHestoryWithArticle:self.articleModel];


}



///**添加历史阅读*/
//- (void)addHistoryReadToNet{
//    
//    NetWork * net = [NetWork shareNetWorkNew];
//    
//    if (self.isArticle) {
//        
//        NSString * title = self.articleModel.title;
//        
//        if (title == nil) {
//            
//            title = self.historyModel.title;
//        }
//
//        
//        [net userHistoryRedAddArticleWithUidAndTokenAndID:self.article_id andTitle:title];
//        
//    }else{
//        
//        [net userHistoryRedAddArticleWithUidAndTokenAndID:self.article_id andTitle:self.videoModel.title];
//        
//    }
//    
//}


#pragma mark- 分享
-  (void)rightBarButtonAction{
    
    
    [self.shareView.shareBottomView removeFromSuperview];

    MainShareView * shareV;
    
    if (self.shareView == nil) {
        
        shareV = [[MainShareView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenHeight)];
        
        self.shareView  = shareV;
        [self.shareView.shareBottomView removeFromSuperview];
        
        [self.view addSubview:shareV];
        
    }else{
        
        shareV =  self.shareView ;
        [self.shareView.shareBottomView removeFromSuperview];
        
        [self.view addSubview:shareV];
        
    }
    
    [shareV addBarRigthShareViewNew];
    
    
    [shareV.rightShareViewShareButton addTarget:self action:@selector(rootShareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [shareV.rightShareViewcollectionButton addTarget:self action:@selector(rootCollectionArticleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [shareV.rightShareViewWarningButton addTarget:self action:@selector(rootWarningButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net userIsOrNotCollectionArticleWithArticleAid:self.article_id];
    
    __weak WebViewController * weakSelf = self;
    
    net.userIsOrNotCollectionBK = ^(NSString * code,NSString * message,NSString * isOrNot,NSArray * arr1,NSArray * arr2){
        
        
        if ([isOrNot isEqualToString:@"1"]) {
            
            [weakSelf.shareView.rightShareViewcollectionButton setImage:[UIImage imageNamed:@"selstar"] forState:UIControlStateNormal];
            
            weakSelf.isAlreadyCollection = YES;
        }else{
            
            weakSelf.isAlreadyCollection = NO;
        }
        
        
        
    };

}


- (void)rootCollectionArticleButtonAction{
    
    [self.shareView.rightShareView removeFromSuperview];
    [self.shareView.shareBottomView removeFromSuperview];
    [self.shareView removeFromSuperview];
    
    
    
    NetWork * net = [NetWork shareNetWorkNew];
    __weak WebViewController * weakSelf = self;
    
    if (self.isAlreadyCollection) {
        
        [net userCancleCollectionArticleWithArticleAid:self.article_id];
        
        net.userCancleCollectionBK=^(NSString * code,NSString * message){
            
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = message;
            [hud hideAnimated:YES afterDelay:2.f];
            
            if ([code isEqualToString:@"1"]) {
                
                [weakSelf.shareView.rightShareViewcollectionButton setImage:[UIImage imageNamed:@"unselstar"] forState:UIControlStateNormal];
                
            }
            
        };
        
    }else{
        
        [net userAddCollectionArticleWithArticleAid:self.article_id];
        
        //收藏
        net.userAddCollectinBK=^(NSString * code,NSString * message){
            
            NSLog(@"%@",message);
            
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = message;
            [hud hideAnimated:YES afterDelay:2.f];
            
            if ([code isEqualToString:@"1"]) {
                
                [weakSelf.shareView.rightShareViewcollectionButton setImage:[UIImage imageNamed:@"selstar"] forState:UIControlStateNormal];
                
            }
        };
    }
}


- (void)rootWarningButtonAction{
    
    [self.shareView.rightShareView removeFromSuperview];
    [self.shareView.shareBottomView removeFromSuperview];
    [self.shareView removeFromSuperview];
    
    
}



- (void)rootShareButtonAction{
    
    [self.shareView.rightShareView removeFromSuperview];

    
    MainShareView * shareV;
    
    if (self.shareView == nil) {
        
        shareV = [[MainShareView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenHeight)];
        
        self.shareView  = shareV;
        
        
        [self.view addSubview:shareV];
        
    }else{
        
        shareV =  self.shareView ;
        [self.view addSubview:shareV];
        
    }
    
    [shareV addBottomShareViewNew];
    
    [shareV.WeiXinShareButton addTarget:self action:@selector(rootWeiXinShareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    shareV.WeiXinShareButton.tag = 1110;

    [shareV.WeiXinFriendShareButton addTarget:self action:@selector(rootWeiXinShareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    shareV.WeiXinFriendShareButton.tag = 2220;

    
    [shareV.QQShareButton addTarget:self action:@selector(rootQQShareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [shareV.QzoneShareButton addTarget:self action:@selector(rootQzoneShareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [shareV.cancleButton addTarget:self action:@selector(rootCancleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
}


//取消分享
- (void)rootCancleButtonAction{
    [self.shareView.rightShareView removeFromSuperview];
    [self.shareView.shareBottomView removeFromSuperview];
    [self.shareView removeFromSuperview];

    
}

- (void)rootWeiXinShareButtonAction:(UIButton *)bt{
    
    [self.shareView removeFromSuperview];
    
    
    if (bt.tag == 1110) {
        self.shareView.shareType = WeiXinShareType;
        
    }else{
        self.shareView.shareType = WeiXinFriendShareType;
        
    }
    
    
       
}

- (void)rootQQShareButtonAction{
    [self.shareView removeFromSuperview];
    
}

- (void)rootQzoneShareButtonAction{
    [self.shareView removeFromSuperview];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.shareView.rightShareView removeFromSuperview];
    [self.shareView.shareBottomView removeFromSuperview];
    [self.shareView removeFromSuperview];
}


#pragma mark- init
- (void)addNavBarViewNew{
    
    self.navigationBarView = [self NavBarViewNew];
    self.navigationBarView.backgroundColor = [UIColor whiteColor];
    [self addLineNew];
    
    [self addLeftBarButtonNew];
    
    if (!self.isNewTeach) {
        
        [self addRightBarButtonNew];
        
    }
    
    [self addTitleLabelNew];
}

#pragma mark- 创建WKWeb
- (void)WebNwe{
    
    UIWebView * web = [[UIWebView alloc]init];
    web.frame = CGRectMake(0, 64, ScreenWith, ScreenHeight - 64);
//    web.delegate = self;
    self.webView =  web;
    [self.view addSubview:web];
    
    
    
    self.webView.scalesPageToFit = YES;
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    
#pragma mark- NJWebView
    self.progress = [[NJKWebViewProgress alloc]init];
    self.webView.delegate = self.progress;
    self.progress.webViewProxyDelegate = self;
    self.progress.progressDelegate = self;
    
    
    
    CGFloat progressBarHeight = 1.f;
    CGRect barFrame = CGRectMake(0, 63,ScreenWith, progressBarHeight);
    
    self.progressView = [[NJKWebViewProgressView alloc]initWithFrame:barFrame];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleWidth;
    [self.progressView setProgress:0 animated:YES];
    
    [self.navigationBarView addSubview:self.progressView];
}


#pragma mark- WKWebPost
- (void)WebPostRequest{
    
//    NSString * textUrl = @"http://wz.lgmdl.com/App/Read/category";
//    NSString * textBody = @"/token=60e39694eeb1534d1f637447965bdb3e&uid=30000002&cid=1";
    //
    
    //token=60e39694eeb1534d1f637447965bdb3e&uid=30000002&cid=1
    
    NSString *urlStr;

    if (self.isArticle) {
    
      urlStr =  [NSString stringWithFormat:@"%@/app/article/detail",DomainURL];
    }else{
      urlStr = [NSString stringWithFormat:@"%@/app/article/video",DomainURL];
    
    }
    
    NSLog(@"%@",urlStr);
    
    NSString * body = [NSString stringWithFormat:@"/id=%@",self.article_id];
    
    NSLog(@"%@",self.article_id);
    NSLog(@"%@",body);

    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSLog(@"%@",request);
    
    [self.webView loadRequest:request];

    
}

#pragma mark- WkWebGet
- (void)WebGetRequest{
    
    
    NSString *urlStr;
    
    if (self.isArticle) {
        
        
        [self addCoreDataWithArticleHestoryRead];
        
        urlStr =  [NSString stringWithFormat:@"%@/app/article/detail/id/%@",DomainURL,self.article_id];
    }else{
        urlStr = [NSString stringWithFormat:@"%@/app/article/video/id/%@",DomainURL,self.article_id];
        
    }


    
    if (self.urlString) {
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
        
    }else{
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
        
    }

}

#pragma mark- NJKWebViewProgressDelegate
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
    
    
    
    
    [self.progressView setProgress:progress animated:YES];
    self.titleLabel.text = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];


}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

    NSLog(@"webFinish");
}



#pragma mark- 注册键盘监听
- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWillShown:(NSNotification*)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    CGFloat keyBoard_h = keyboardSize.height;
//    CGFloat keyBoard_w = keyboardSize.width;
    
    //输入框位置动画加载
    [UIView animateWithDuration:duration animations:^{
        
        self.commentView.frame = CGRectMake(0, ScreenHeight - keyBoard_h - ScreenWith/2, ScreenWith, ScreenWith/2);
    }];
}
//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    
}


#pragma mark- 评论框
- (void)rootWriteCommentButtonAction{
    [super rootWriteCommentButtonAction];
    
    [self addRootCommentViewNew];
    
    [self.textView becomeFirstResponder];
}



- (void)rootCommentViewPushButtonAction{
    [super rootCommentViewPushButtonAction];
    
    NSLog(@"评论:%@",self.commentString);
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    
    [net writeCommentAndRespondWithTypr:commentType_comment andContent:self.commentString andID:@"" andAID:self.article_id andRelation:@"" andRelname:@""];
    
    __weak WebViewController * weakSelf = self;
    net.commentBK=^(NSString * code,NSString * message){
        
        [weakSelf rootShowMBPhudWith:message andShowTime:1.0];
        
    };
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.textView resignFirstResponder];
        self.commentView.frame = CGRectMake(0, ScreenHeight, ScreenWith, ScreenWith/2);
        
    }completion:^(BOOL finished) {
        
        
    }];
    
}


- (void)rootCommentViewCancleButtonAvtion{
    [super rootCommentViewCancleButtonAvtion];
    
    [self.textView resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.commentView.frame = CGRectMake(0, ScreenHeight, ScreenWith, ScreenWith/2);
        
    }completion:^(BOOL finished) {
        
        
    }];
}



- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    NSLog(@"1 textViewDidChangeSelection");
    
    NSLog(@"%@",textView.text);
    
    NSUInteger worldLength = [textView.text length];
    
    self.woeldNumberLabel.text = [NSString stringWithFormat:@"%ld/200",worldLength];
    
    self.commentString = textView.text;
    
    
    if (worldLength > 0) {
        self.placeHolderLabel.hidden = YES;
    }else{
        
        self.placeHolderLabel.hidden = NO;
    }
    
}


- (void)textViewDidEndEditing:(UITextView *)textView{
    
    NSLog(@"2 textViewDidEndEditing");
    
    NSUInteger worldLength = [textView.text length];
    
    self.commentString = textView.text;
    
    self.woeldNumberLabel.text = [NSString stringWithFormat:@"%ld/200",worldLength];
    
    NSLog(@"%ld",worldLength);
}




@end
