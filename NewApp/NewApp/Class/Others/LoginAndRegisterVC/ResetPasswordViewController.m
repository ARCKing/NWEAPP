//
//  ResetPasswordViewController.m
//  NewApp
//
//  Created by gxtc on 17/2/15.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "ResetPasswordViewController.h"

@interface ResetPasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *enterButton;

@property (weak, nonatomic) IBOutlet UIButton *DXmessageButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *DXfield;
@property (weak, nonatomic) IBOutlet UITextField *passWordField;

@property (nonatomic,copy)NSString * phone;
@property (nonatomic,copy)NSString * DX;
@property (nonatomic,copy)NSString * passWord;

@property (assign,nonatomic)NSInteger  timeCount;
@property (strong,nonatomic)NSTimer * btTime;
@property (strong,nonatomic)UILabel * messageLabel;


@property (nonatomic,strong)UIView * imageCodeBGview;
@property (nonatomic,copy)NSString * imageCoder;
@property (nonatomic,strong)UIImageView * imageCodev;
@property (nonatomic,strong)UITextField * imageCodeField;
@property (nonatomic,strong)UIButton * imageCodeEnterBt;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeCount =0;
    
    [self showTheBlackMessageAleterNewWithFram:CGRectMake(ScreenWith/2 - 50, -30, 100, 30)];
}

- (IBAction)popButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



//倒计时

- (void)addTimeNew{
    
    if (self.btTime == nil) {
        self.btTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeBtTitle) userInfo:nil repeats:YES];
        self.timeCount = 60;
    }
    
}


- (void)changeBtTitle{
    
    [self.DXmessageButton setTitle:[NSString stringWithFormat:@"%ldS",self.timeCount--] forState:UIControlStateNormal];
    
    if (self.timeCount == 0) {
        
        [self stopTimes];
        
        [self.DXmessageButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}


- (void)stopTimes{
    [self.btTime invalidate];
    self.btTime = nil;
    
    self.DXmessageButton.backgroundColor = [UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0];
    self.DXmessageButton.enabled = YES;
}


//黑色提示框====
- (void)showTheBlackMessageAleterNewWithFram:(CGRect)fram{
    
    self.messageLabel =  [self addRootLabelWithfram:fram andTitleColor:[UIColor whiteColor] andFont: 12 andBackGroundColor:[UIColor blackColor] andTitle:@"Message"];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.messageLabel];
}


- (void)showTheBlackMessageAlter:(NSString *)message{
    
    self.messageLabel.text = message;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.messageLabel.frame = CGRectMake(ScreenWith/2 - 50, 64, 100, 30);
    } completion:^(BOOL finished) {
        
        [self performSelector:@selector(dissmissMessageAleart) withObject:nil afterDelay:1.5];
        
    }];
}

- (void)dissmissMessageAleart{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.messageLabel.frame = CGRectMake(ScreenWith/2 - 50, -30, 100, 30);
        
    }];
}

//==========
- (void)enterButtonCanEnable{
    
    
    if (self.phone.length == 11 && self.DX.length >= 4 && self.passWord.length >=6) {
        
        self.enterButton.backgroundColor =[ UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0];
        self.enterButton.enabled = YES;
        
    }else{
        
        self.enterButton.backgroundColor =[ UIColor lightGrayColor];
        self.enterButton.enabled = NO;
    }
    
    
}

#pragma mark- buttonAction
- (IBAction)DXmessageButtonAction:(id)sender {
    NSLog(@"获取验证码!");
   
    [self getImageCoderFromNet];
}

- (IBAction)sureButtonAction:(id)sender {
    NSLog(@"确定按钮!");
    [self outOfFistRespond];
    NetWork *net = [NetWork shareNetWorkNew];
    
    [net findBackUserWithPhone:self.phone andDXstring:self.DX andPassword:self.passWord];
    
    __weak ResetPasswordViewController * weakSelf = self;
    
    net.findBackPassWordBK = ^(NSString * code,NSString * message){
        
        if ([code isEqualToString:@"1"]) {
            
            [weakSelf showTheBlackMessageAlter:message];
            
            [weakSelf performSelector:@selector(popVC) withObject:nil afterDelay:1.7];
            
        }else{
            
            [weakSelf showTheBlackMessageAlter:message];
        }
        
    };
    

    
    
}

- (void)popVC{

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- textField
- (IBAction)phoneNumberEditingDidEnd:(id)sender {
    NSLog(@"手机号码输入结束!");
    self.phone = self.phoneField.text;

}

- (IBAction)DXmessageEditingDidEnd:(id)sender {
    NSLog(@"短信验证码输入结束!");
    self.DX = self.DXfield.text;

}

- (IBAction)passWorldEditingDidEnd:(id)sender {
    NSLog(@"密码输入结束!");
    self.passWord = self.passWordField.text;

}

- (IBAction)phoneDidChange:(id)sender {
    
    self.phone = self.phoneField.text;
    
    if (self.phone.length == 11 && self.timeCount < 1) {
        
        self.DXmessageButton.backgroundColor = [UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0];
        self.DXmessageButton.enabled = YES;
    }else{
        
        self.DXmessageButton.backgroundColor = [UIColor lightGrayColor];
        self.DXmessageButton.enabled = NO;
        
    }

}
- (IBAction)DXdidChange:(id)sender {
    self.DX = self.DXfield.text;
    [self enterButtonCanEnable];

}

- (IBAction)passWordDidChange:(id)sender {
    self.passWord = self.passWordField.text;
    
    [self enterButtonCanEnable];
}


- (void)outOfFistRespond{

    [self.phoneField resignFirstResponder];
    [self.DXfield resignFirstResponder];
    [self.passWordField resignFirstResponder];
    [self.imageCodeField resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self outOfFistRespond];
}


#pragma mark- 验证码
/**图片验证码*/
- (void)getImageCoderFromNet{
    
    //    NSString * url = @"http://wz.lgmdl.com/App/Member/getyzm";
    
    
    UIView * imageCodeBgView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWith/6, ScreenWith/3, ScreenWith*2/3, ScreenWith*2/3)];
    imageCodeBgView.backgroundColor = [UIColor colorWithRed:0.0 green:191.0/255.0 blue:1.0 alpha:1.0];
    [self.view addSubview:imageCodeBgView];
    imageCodeBgView.layer.cornerRadius = 5.0;
    self.imageCodeBGview = imageCodeBgView;
    
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, ScreenWith*2/3 - 30, ScreenWith/4)];
    //    [imageV sd_setImageWithURL:[NSURL URLWithString:url]];
    [imageCodeBgView addSubview:imageV];
    imageV.userInteractionEnabled = YES;
    self.imageCodev = imageV;
    [self refreshImageCode];
    
    
    UIButton * refreshBt = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBt.frame = CGRectMake(0, 0, ScreenWith*2/3 - 30, ScreenWith/4);
    refreshBt.backgroundColor = [UIColor clearColor];
    [imageV addSubview:refreshBt];
    [refreshBt addTarget:self action:@selector(refreshImageCode) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel * placeHolder = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame), ScreenWith *2/3, ScreenWith/10)];
    placeHolder.backgroundColor = [UIColor clearColor];
    placeHolder.text = @"看不清？点击图片刷新";
    placeHolder.textAlignment = NSTextAlignmentCenter;
    placeHolder.textColor = [UIColor whiteColor];
    placeHolder.font = [UIFont systemFontOfSize:15];
    [imageCodeBgView addSubview:placeHolder];
    
    UITextField * field = [[UITextField alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(placeHolder.frame), ScreenWith*2/3 - 30, ScreenWith/11)];
    field.placeholder = @"请输入图片上的验证码";
    field.backgroundColor = [UIColor whiteColor];
    field.textAlignment = NSTextAlignmentCenter;
    field.layer.cornerRadius = 3.0;
    field.delegate = self;
    field.tag = 5000;
    self.imageCodeField = field;
    [field becomeFirstResponder];
    
    [imageCodeBgView addSubview:field];
    
    
    UIButton * cancleBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBt setTitle:@"确定" forState:UIControlStateNormal];
    cancleBt.frame = CGRectMake(15, CGRectGetMaxY(field.frame) + ScreenWith/20, ScreenWith*2/3 - 30, ScreenWith/10);
    [imageCodeBgView addSubview:cancleBt];
    cancleBt.backgroundColor = [UIColor colorWithRed:102.0/255.0 green:205.0/255.0 blue:170.0/255.0 alpha:1.0];
    cancleBt.layer.cornerRadius = 3.0;
    [cancleBt addTarget:self action:@selector(enterFinishAction) forControlEvents:UIControlEventTouchUpInside];
    self.imageCodeEnterBt = cancleBt;
    
    
}



/**获取图片*/
- (void)refreshImageCode{
    
    self.imageCodev.image = [UIImage imageNamed:@"img_loading.jpg"];
    
    NSString * url = @"http://zqw.2662126.com/App/Member/getyzm/phone/";
    
    NSString * URL = [NSString stringWithFormat:@"%@%@",url,self.phone];
    
    //    [self.imageCodev sd_setImageWithURL:[NSURL URLWithString:URL]];
    
    SDWebImageManager * manger = [SDWebImageManager sharedManager];
    
    __weak ResetPasswordViewController * weakSelf = self;
    
    [manger.imageDownloader downloadImageWithURL:[NSURL URLWithString:URL] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        weakSelf.imageCodev.image = image;
        
    }];
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.imageCoder = textField.text;
}


- (void)enterFinishAction{
    
    [self.imageCodeBGview removeFromSuperview];
    
    NSLog(@"图片验证码%@",self.imageCoder);
    
    NSString * code = self.imageCoder;
    NSString * phone = self.phone;
    NSString * type = @"find-password";
    NSString * key = @"Vf26Y#oBH#!6M37!*#XfW";
    
    NSString * sourceString = [NSString stringWithFormat:@"code=%@&phone=%@&type=%@&key=%@",code,phone,type,key];
    
    NSString * md5Code = [MD5Tool MD5ForUpper32Bate:sourceString];

    NetWork *net = [NetWork shareNetWorkNew];
    
    [net getDXWithPhone:self.phone andType:1 withMD5Code:md5Code andImageCode:code];
    __weak ResetPasswordViewController * weakSelf = self;
    
    net.findPassWordDXmessageBK=^(NSString * code,NSString * message){
        
        [weakSelf showTheBlackMessageAlter:message];
        
        
        if ([code isEqualToString:@"1"]) {
            
            
            weakSelf.DXmessageButton.backgroundColor = [UIColor lightGrayColor];
            weakSelf.DXmessageButton.enabled = NO;
            [weakSelf addTimeNew];
        }
        
    };

}
@end
