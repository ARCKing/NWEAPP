//
//  EditiAddressVC.m
//  NewApp
//
//  Created by gxtc on 17/2/21.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "EditiAddressVC.h"

@interface EditiAddressVC ()<UITextFieldDelegate>

@property (nonatomic,strong)UITextField * nameField;
@property (nonatomic,strong)UITextField * phoneField;
@property (nonatomic,strong)UITextField * areaField;
@property (nonatomic,strong)UITextField * detailField;

@property (nonatomic,strong)NSString * name;
@property (nonatomic,strong)NSString * phone;
@property (nonatomic,strong)NSString * area;
@property (nonatomic,strong)NSString * detailarea;


@end

@implementation EditiAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addUI];
    
}

- (void)addUI{
    
    
    [self addNavBarNew];
    [self addTextFieldNew];
}



- (void)addNavBarNew{
    
    self.navigationBarView = [self NavBarViewNew];
    self.navigationBarView.backgroundColor =[UIColor whiteColor];
    [self addTitleLabelNew];
    [self addLeftBarButtonNew];
    self.titleLabel.text = @"地址编辑";
    [self addLineNew];
    
}

- (void)addTextFieldNew{
    
    NSArray * placeHolder = @[@"名字",@"11位手机号",@"地区信息",@"街道门牌号"];
    NSArray * title = @[@"收货人",@"联系电话",@"所在地区",@"详细地址"];
    for (int i = 0; i < 4; i++) {
        
        UILabel * titles = [[UILabel alloc]initWithFrame:CGRectMake(10, 15 + (45) * i + 64, ScreenWith/5, 45)];
        titles.font = [UIFont systemFontOfSize:15];
        titles.textColor = [UIColor lightGrayColor];
        titles.text = title[i];
        [self.view addSubview:titles];
        
        UITextField * field = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWith/5 + 10, 15 + (45) * (i) + 64, ScreenWith*2/3, 45)];
        field.backgroundColor = [UIColor clearColor];
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.placeholder = placeHolder[i];
        field.font = [UIFont systemFontOfSize:14];
        field.delegate = self;
        [self.view addSubview:field];
        field.tag = 1200+i;
        
        if (i == 0) {
            
            self.nameField = field;
            
        }else if (i == 1){
            
            self.phoneField = field;
            
        }else if (i == 2){
            
            self.areaField = field;
            
        }else if (i == 3){
            
            self.detailField = field;
        }
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(15, 15 + (45) * (i + 1) + 64, ScreenWith - 30, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0];
        line.tag = 1300 + i;
        [self.view addSubview:line];
        
    }
    
    UIView * line = (UIView *)[self.view viewWithTag:1303];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    button.frame = CGRectMake(ScreenWith /3, 15 + CGRectGetMaxY(line.frame), ScreenWith/3, 40);
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTintColor:[UIColor whiteColor]];
    [self.view addSubview:button];

    
}

- (void)buttonAction{
    
    
    NSLog(@"%@=%@=%@=%@",self.name,self.phone,self.area,self.detailarea);
    NSLog(@"保存");
    
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    __weak EditiAddressVC * weakSelf = self;
    
    [net changeMineDataFromNetWithType:@"address" andSex:nil andNickName:nil andAddressName:self.name andRephone:self.phone andRegion:self.area andAddress:self.detailarea];
    
    net.changeMineDataBK=^(NSString * code,NSString * message){
    
        [weakSelf rootShowMBPhudWith:message andShowTime:0.5];
    
    };
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing");
    
    self.name = self.nameField.text;
    self.phone = self.phoneField.text;
    self.area = self.areaField.text;
    self.detailarea = self.detailField.text;
    
    
    NSLog(@"%@=%@=%@=%@",self.name,self.phone,self.area,self.detailarea);
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"0");

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self textFieldResignFirst];
}


- (void)textFieldResignFirst{

    [self.nameField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    [self.areaField resignFirstResponder];
    [self.detailField resignFirstResponder];
    
}

@end
