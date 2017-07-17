//
//  LoginViewController.m
//  NewApp
//
//  Created by gxtc on 17/2/15.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWorldTextField;
@property (weak, nonatomic) IBOutlet UIButton *forgetPassWorldButton;


@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic,copy)NSString * phone;
@property (nonatomic,copy)NSString * passWorld;

@property (strong,nonatomic)UILabel * messageLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showTheBlackMessageAleterNewWithFram:CGRectMake(ScreenWith/2 - 50, -30, 100, 30)];
}


#pragma mark- ButtonAction
- (IBAction)forgetPassWorldButtonAction:(id)sender {
    [self outOfFistRespond];

    NSLog(@"忘记密码!");
    
    
    ResetPasswordViewController * vc = [[ResetPasswordViewController alloc]init];
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)loginButtonAction:(id)sender {
    [self outOfFistRespond];

    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net userLoginWithPhone:self.phone andPassWord:self.passWorld];
    
    __weak LoginViewController * weakSelf = self;
    
    net.userLoginBK=^(NSString * code,NSString *message){
    
        
        [hud hideAnimated:YES];
        
        if ([code isEqualToString:@"1"]) {
            
            [weakSelf showTheBlackMessageAlter:message];
            
            [weakSelf performSelector:@selector(popVC) withObject:nil afterDelay:1.7];
            
        }else{
            
            [weakSelf showTheBlackMessageAlter:message];
        }

    };
    
    NSLog(@"登录!");

}


- (void)popVC{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registerButtonAction:(id)sender {
    [self outOfFistRespond];

    NSLog(@"注册!");
    
    RegisterViewController * vc = [[RegisterViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark- 取消
- (IBAction)popButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}


#pragma mark- TextField
- (IBAction)phoneNumberEditingDidEnd:(id)sender {
    NSLog(@"手机号输入结束!");
    self.phone = self.phoneTextField.text;
}


- (IBAction)passWorldEditingDidEnd:(id)sender {
    
    NSLog(@"密码输入结束!");
    self.passWorld = self.passWorldTextField.text;


}

- (IBAction)phoneDidChange:(id)sender {
    self.phone = self.phoneTextField.text;
    if (self.phone.length == 11 && self.passWorld.length >= 6) {
        
        self.loginButton.backgroundColor = [UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0];
        self.loginButton.enabled =YES;
    }else{
        self.loginButton.backgroundColor = [UIColor lightGrayColor];
        self.loginButton.enabled =NO;
    }
}


- (IBAction)passWorldDidChange:(id)sender {
    self.passWorld = self.passWorldTextField.text;
    
    
    if (self.phone.length == 11 && self.passWorld.length >= 6) {
        
        self.loginButton.backgroundColor = [UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0];
        self.loginButton.enabled =YES;
    }else{
        self.loginButton.backgroundColor = [UIColor lightGrayColor];
        self.loginButton.enabled =NO;
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self outOfFistRespond];
}

- (void)outOfFistRespond{

    [self.phoneTextField resignFirstResponder];
    [self.passWorldTextField resignFirstResponder];
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
//#pragma mark- 微信登录授权




@end
