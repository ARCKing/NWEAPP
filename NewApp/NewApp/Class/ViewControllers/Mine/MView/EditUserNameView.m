//
//  EditUserNameView.m
//  NewApp
//
//  Created by gxtc on 17/2/21.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "EditUserNameView.h"

@interface EditUserNameView()
@end

@implementation EditUserNameView


- (instancetype)initWithFrame:(CGRect)frame{


    if (self = [super initWithFrame:frame]) {
        
//        self.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
        self.backgroundColor = [UIColor whiteColor];
        
        [self addUI];
    }
    return self;
}



- (void)addUI{

    UITextField * field = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, ScreenWith - 20, 35)];
    field.backgroundColor = [UIColor whiteColor];
    field.layer.cornerRadius = 5;
    [field setClearButtonMode:UITextFieldViewModeWhileEditing];
    field.layer.borderWidth = 1;
    field.layer.borderColor = [UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0].CGColor;
    self.field = field;
    [self addSubview:field];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    button.frame = CGRectMake(ScreenWith /3, 10 + 15 + 35, ScreenWith/3, 30);
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    button.backgroundColor = [UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTintColor:[UIColor whiteColor]];
    
    self.saveButton = button;
    
    [self addSubview:button];
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.field resignFirstResponder];
//    
//}



@end
