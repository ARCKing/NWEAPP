//
//  EditDetailDataVC.m
//  NewApp
//
//  Created by gxtc on 17/2/21.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "EditDetailDataVC.h"

@interface EditDetailDataVC ()<UITextFieldDelegate>

@property (nonatomic,strong)EditiUserSexView * sexView;
@property (nonatomic,strong)EditUserNameView * nameView;

@property (nonatomic,copy)NSString * currentSex;

@property (nonatomic,copy)NSString * currentNickName;

@end

@implementation EditDetailDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addUI];
    
}

- (void)addUI{
    
    
    [self addNavBarNew];
    
    [self addEditiView:self.type];
}



- (void)addNavBarNew{
    
    self.navigationBarView = [self NavBarViewNew];
    self.navigationBarView.backgroundColor =[UIColor whiteColor];
    [self addTitleLabelNew];
    [self addLeftBarButtonNew];
    self.titleLabel.text = self.titleString;
    [self addLineNew];
    
}


-(void)addEditiView:(NSInteger)type{

    
    if (type == 1) {
        EditUserNameView * view = [[EditUserNameView alloc]initWithFrame:CGRectMake(0, 64, ScreenWith, ScreenHeight-64.0)];
        self.nameView = view;
        view.field.delegate = self;
        [view.saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:view];

    }else{
        EditiUserSexView * view = [[EditiUserSexView alloc]initWithFrame:CGRectMake(0, 64, ScreenWith, ScreenHeight-64.0)];
        self.sexView = view;
        
        [view.manButton addTarget:self action:@selector(buttonActionSex:) forControlEvents:UIControlEventTouchUpInside];
        [view.womanButton addTarget:self action:@selector(buttonActionSex:) forControlEvents:UIControlEventTouchUpInside];
        [view.saveSexButton addTarget:self action:@selector(savSexAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:view];

       }
}


- (void)buttonActionSex:(UIButton *)sex{
    
    if (sex.tag == 1110) {
        NSLog(@"男");
        
       self.sexView.manButton.backgroundColor = [UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0];
       self.sexView.womanButton.backgroundColor = [UIColor lightGrayColor];
        
        self.currentSex = @"1";
        
    }else if (sex.tag == 1111){
        NSLog(@"女");
        self.sexView.manButton.backgroundColor = [UIColor lightGrayColor];
        self.sexView.womanButton.backgroundColor = [UIColor magentaColor];
        
        self.currentSex = @"2";
    }
    
    
}


- (void)savSexAction{

    NSLog(@"保存性别:%@",self.currentSex);

    NetWork * net = [NetWork shareNetWorkNew];
    
    [net changeMineDataFromNetWithType:@"sex" andSex:self.currentSex andNickName:nil andAddressName:nil andRephone:nil andRegion:nil andAddress:nil];
    __weak EditDetailDataVC * weakSelf = self;

    net.changeMineDataBK=^(NSString * code,NSString * message){
    
        NSLog(@"%@",message);
        
        [weakSelf rootShowMBPhudWith:message andShowTime:0.5];
    };
    
}

- (void)saveAction{

    [self.nameView.field resignFirstResponder];

    NSLog(@"保存名字:%@",self.currentNickName);

    NetWork * net = [NetWork shareNetWorkNew];

    [net changeMineDataFromNetWithType:@"nickname" andSex:nil andNickName:self.currentNickName andAddressName:nil andRephone:nil andRegion:nil andAddress:nil];

    __weak EditDetailDataVC * weakSelf = self;
    net.changeMineDataBK=^(NSString * code,NSString * message){
        
        NSLog(@"%@",message);
        
        [weakSelf rootShowMBPhudWith:message andShowTime:0.5];


    };
}



- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSLog(@"%@",textField.text);
    
    self.currentNickName = textField.text;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.nameView.field resignFirstResponder];
}


@end
