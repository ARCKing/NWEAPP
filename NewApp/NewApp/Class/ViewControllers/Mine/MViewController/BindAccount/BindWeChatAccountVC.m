//
//  BindWeChatAccountVC.m
//  NewApp
//
//  Created by gxtc on 2017/5/23.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "BindWeChatAccountVC.h"

@interface BindWeChatAccountVC ()
@property(nonatomic,retain)UIView * navView;
@property(nonatomic,strong)UIScrollView * scrollView;

@property(nonatomic,retain)UIView * alertShowBgView;

@property(nonatomic,strong)UIButton * button;

@property(nonatomic,strong)UILabel * label;


@property(nonatomic,assign)BOOL isBind;
@property(nonatomic,assign)BOOL isWXBind;
@property(nonatomic,copy)NSString * exchange_publicno;

@end

@implementation BindWeChatAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self weiXinBangDingStatus];
    
    [self addUI];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatScrollView];
    
}


- (void)addUI{

    [super addUI];

    self.titleLabel.text = @"绑定微信账号";
}


#pragma mark- 微信绑定状态与信息
- (void)weiXinBangDingStatus{
    
    __weak BindWeChatAccountVC * weakSelf = self;
    
    NetWork * net = [[NetWork alloc]init];
    
    [net NetBindWeiChatAccountFinishProgress];
    
    //bind, wxbind, exchange_publicno,
    net.bindWeiChatAccountFinishProgressBK = ^(NSString * bind, NSString * wxbind, NSString * exchange_publicno, NSArray * data1, NSArray * data2) {
        
        NSLog(@"%@=%@=%@",bind,wxbind,exchange_publicno);
        
        if ([bind isEqualToString:@"1"]) {
            
            weakSelf.isBind = YES;
            [weakSelf.button setTitle:@"已完成授权" forState:UIControlStateNormal];
        }
        
        
        if ([wxbind isEqualToString:@"1"]) {
            
            weakSelf.isWXBind = YES;
        }
        
        weakSelf.label.text = exchange_publicno;
        weakSelf.exchange_publicno = exchange_publicno;
    };
    
}


#pragma mark- buttonAction
- (void)buttonAction:(UIButton *)button{
    if (button.tag == 3000) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (button.tag == 3344){
        
        NSLog(@"去绑定微信");
        NSLog(@"我是微信登录");
        NSLog(@"%s",__func__);
        
        [self RootGetAuthWithUserInfoFromWechat];
        
        
        
        
    }else if (button.tag == 4455){
        
        NSLog(@"完成绑定");
        [self finishBindWeiChatAccount];
    }
}



- (void)finishBindWeiChatAccount{

    __weak BindWeChatAccountVC * weakSelf = self;
    
    NetWork * net =[[NetWork alloc]init];

    [net NetBindWeiChatAccountStepSecond];

    net.bindWeiChatAccountSecondBK = ^(NSString *code, NSString *message) {
        
        [weakSelf showSystemAlterViewWithTitle:@"绑定状态" andMessage:message];
    };
}




- (void)RootBindWeiChatAccountWith:(NSString *)access_token andOpenid:(NSString *)openid andUnionid:(NSString *)unionid{

    NetWork * net = [[NetWork alloc]init];

    [net NetBindWeiChatAccountWith:access_token andOpenid:openid andUnionid:unionid];

    __weak BindWeChatAccountVC * weakSelf = self;
    
    net.bindWeiChatAccountBK = ^(NSString * code, NSString *message) {
        
        if ([code isEqualToString:@"1"]) {
            
        }
        
        [weakSelf showSystemAlterViewWithTitle:@"授权状态" andMessage:message];

    };
    
    
}


- (void)showSystemAlterViewWithTitle:(NSString *)title andMessage:(NSString *)message{

    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];

    [alert show];
}



#pragma mark- 绑定微信
- (void)bangDingWeiXin:(NSNotification *)notificiation{
    
    
}



- (void)aleratShow:(NSString *)message{
    
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width / 2, self.view.bounds.size.width/4)];
    label.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    label.font = [UIFont systemFontOfSize:14];
    label.layer.cornerRadius = 10;
    label.clipsToBounds = YES;
    
    
    [UIView animateWithDuration:3 animations:^{
        
        label.alpha = 0;
    }];
    
}







//微信安装提示
- (void)setupAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}






#pragma mark- scrollViewCreat
- (void)creatScrollView{
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, ScreenWith, ScreenHeight - 64)];
    self.scrollView.contentSize = CGSizeMake(0, ScreenHeight +1+ScreenWith/2);
    [self.view addSubview:self.scrollView];
    
    
    UIImageView * imgvView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenHeight /2)];
    imgvView.image = [UIImage imageNamed:@"bg_wx"];
    [self.scrollView addSubview:imgvView];
    
    
    UILabel * label0 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWith/8, ScreenWith/8)];
    label0.center = CGPointMake(ScreenWith/2, CGRectGetMaxY(imgvView.frame)+ScreenWith/8);
    label0.text = [NSString stringWithFormat:@"第一步"];
    label0.textColor = [UIColor whiteColor];
    label0.textAlignment = NSTextAlignmentCenter;
    label0.backgroundColor = [UIColor colorWithRed:25/255.0 green:142/255.0 blue:246/255.0 alpha:1];
    label0.layer.cornerRadius = ScreenWith/16;
    label0.clipsToBounds = YES;
    label0.font = [UIFont systemFontOfSize:11];
    [self.scrollView addSubview:label0];
    
    UILabel * label00 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenWith/10)];
    label00.center = CGPointMake(ScreenWith/2, CGRectGetMaxY(label0.frame)+ScreenWith/10);
    label00.text = [NSString stringWithFormat:@"点击下方按钮前往微信授权绑定"];
    label00.textColor = [UIColor blackColor];
    label00.textAlignment = NSTextAlignmentCenter;
    label00.font = [UIFont systemFontOfSize:15];
    [self.scrollView addSubview:label00];
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(ScreenWith/4, CGRectGetMaxY(label00.frame) + 20, ScreenWith/2, ScreenWith/10);
    [button1 setTitle:@"去绑定微信" forState:UIControlStateNormal];
    [button1 setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:99.0/255.0 blue:71.0/255.0 alpha:1.0]];
    button1.layer.cornerRadius = 5;
    [self.scrollView addSubview:button1];
    button1.tag = 3344;
    [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.button = button1;
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWith/8, ScreenWith/8)];
    label.center = CGPointMake(ScreenWith/2, CGRectGetMaxY(button1.frame)+ScreenWith/8);
    label.text = [NSString stringWithFormat:@"第二步"];
    label.font = [UIFont systemFontOfSize:11];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor colorWithRed:25/255.0 green:142/255.0 blue:246/255.0 alpha:1];
    label.layer.cornerRadius = ScreenWith/16;
    label.clipsToBounds = YES;
    [self.scrollView addSubview:label];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame)+ScreenWith/15, ScreenWith - 40, ScreenWith/8)];
    label2.text = [NSString stringWithFormat:@"请前往微信里添加【招财兔】为好友或长按复制下框账号前往微信添加好友"];
    label2.numberOfLines = 0;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:15];
    label2.textColor = [UIColor blackColor];
    [self.scrollView addSubview:label2];
    
    UIImageView * imgvView2 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWith/4, CGRectGetMaxY(label2.frame)+ScreenWith/15, ScreenWith/2, ScreenWith/10)];
    imgvView2.image = [UIImage imageNamed:@"03.png"];
    [self.scrollView addSubview:imgvView2];
    imgvView2.userInteractionEnabled = YES;
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,ScreenWith/2, ScreenWith/10)];
    label3.text = [NSString stringWithFormat:@"-----"];
    label3.numberOfLines = 0;
    self.label = label3;
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = [UIFont systemFontOfSize:16];
    label3.textColor = [UIColor greenColor];
    [imgvView2 addSubview:label3];
    
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(30, CGRectGetMaxY(imgvView2.frame) + ScreenWith/10, ScreenWith - 60, ScreenWith/10);
    [button2 setTitle:@"完成绑定" forState:UIControlStateNormal];
    [button2 setBackgroundColor:[UIColor orangeColor]];
    button2.layer.cornerRadius = 5;
    [self.scrollView addSubview:button2];
    button2.tag = 4455;
    [button2 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addLongGuest:imgvView2];
}


#pragma mark-添加手势
- (void)addLongGuest:(UIImageView *)view{
    UILongPressGestureRecognizer * longPressGuest = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGuestAction:)];
    longPressGuest.minimumPressDuration = 1;
    
    [view addGestureRecognizer:longPressGuest];
}


- (void)longGuestAction:(UILongPressGestureRecognizer *)sender{
    
    if (self.exchange_publicno == nil) {
        
        self.exchange_publicno = @"shouzla168";
    }
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        NSLog(@"长按复制");
        
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:@"%@", self.exchange_publicno];
        
        
        if (pasteboard.string != nil) {
            
            [self alerateViewShow];
        }
        
        
    }
}


- (void)alerateViewShow{
    
    UIView * bgView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:bgView];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    self.alertShowBgView = bgView;
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith - 20, ScreenHeight/3)];
    view.center = CGPointMake(ScreenWith/2, ScreenHeight/2);
    [bgView addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 10;
    
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (ScreenWith-20)/3, ScreenHeight/12)];
    title.center = CGPointMake(view.frame.size.width/2, ScreenHeight/24);
    title.text = @"微转啦";
    title.textColor = [UIColor blackColor];
    title.backgroundColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [view addSubview:title];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight/12, ScreenWith - 20, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:line];
    
    UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(line.frame), ScreenWith - 20 -30, ScreenHeight/10)];
    detailLabel.text = @"已复制微转啦资讯公众号，请到微信里添加关注公众号";
    detailLabel.font = [UIFont systemFontOfSize:15];
    detailLabel.numberOfLines = 2;
    detailLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:detailLabel];
    
    UIButton * cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(10, ScreenHeight/3 - 15 - ScreenHeight/13, (view.frame.size.width - 30)/2, ScreenHeight/14);
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancleButton.tag = 4404;
    [view addSubview:cancleButton];
    cancleButton.layer.borderWidth = 0.5;
    cancleButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cancleButton.clipsToBounds = YES;
    cancleButton.layer.cornerRadius = 10;
    
    UIButton * sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(20 + (view.frame.size.width - 30)/2, ScreenHeight/3 - 15 - ScreenHeight/13, (view.frame.size.width - 30)/2, ScreenHeight/14);
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    sureButton.tag = 5505;
    [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    sureButton.layer.borderWidth = 0.5;
    //    sureButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    sureButton.clipsToBounds = YES;
    sureButton.layer.cornerRadius = 10;
    sureButton.backgroundColor = [UIColor orangeColor];
    [view addSubview:sureButton];
    
    
    [cancleButton addTarget:self action:@selector(alerateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [sureButton addTarget:self action:@selector(alerateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)alerateButtonAction:(UIButton *)bt{
    
    if (bt.tag == 4404) {
        NSLog(@"取消");
        [self.alertShowBgView removeFromSuperview];
        
    }else if (bt.tag == 5505){
        
        NSLog(@"确定");
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"]];
        
        
        [self.alertShowBgView removeFromSuperview];
        
    }
    
    
}


@end
