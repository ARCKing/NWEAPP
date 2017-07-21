//
//  ImportArticleController.m
//  NewApp
//
//  Created by gxtc on 2017/7/21.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "ImportArticleController.h"

@interface ImportArticleController ()
@property (weak, nonatomic) IBOutlet UIButton *addLinkButton;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;
@property (strong,nonatomic) UIPasteboard * pasteboard;

@property (weak, nonatomic) IBOutlet UILabel *chanceTitleLabel;

@property (nonatomic,strong) UIButton * importNowBt;


@property (nonatomic,copy)NSString * selectedClassifyChannel;
@property (nonatomic,copy)NSString * pastedLink;

@end

@implementation ImportArticleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addUI];
}


- (void)addUI{

    self.addLinkButton.layer.borderWidth = 1.0;
    self.addLinkButton.layer.borderColor = [UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    [self.view addSubview:self.articleClassfy];
    
    [self.view addSubview:self.importNowBt];
}

-(ImpoartArticleClassify *)articleClassfy{

    if (!_articleClassfy) {
        
        
        NSArray * titarr = @[@"社会",@"军事",@"推荐",@"最新",@"星座",@"两性",@"娱乐",@"社会",@"军事",@"推荐",@"最新",@"星座",@"两性",@"娱乐"];
        
        NSInteger lineNum = titarr.count/5;
        
        NSInteger num = titarr.count%5;
        
        if (num!= 0) {
            
            num = 1;
        }
        
        lineNum = lineNum + num;
        
        
        
        _articleClassfy = [[ImpoartArticleClassify alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(self.chanceTitleLabel.frame)+5   , ScreenWith - 20, lineNum * ScreenWith/10 + (lineNum-1)*10)];
        
        _articleClassfy.titleArr = @[@"社会",@"军事",@"推荐",@"最新",@"星座",@"两性",@"娱乐",@"社会",@"军事",@"推荐",@"最新",@"星座",@"两性",@"娱乐"];
        
        __weak ImportArticleController * weakSelf = self;
        
        _articleClassfy.selectBK = ^(NSInteger index) {
        
            weakSelf.selectedClassifyChannel = weakSelf.articleClassfy.titleArr[index];
            
        };
        
        
    }
    return _articleClassfy;
}


- (IBAction)addLinkButtonAction:(id)sender {
    
    NSString * link = self.pasteboard.string;
    
    self.linkLabel.text = link;
    
    self.pastedLink = link;
}


- (UIButton *)importNowBt{

    if (!_importNowBt) {
        
        _importNowBt = [self addRootButtonTypeTwoNewFram:CGRectMake(30, CGRectGetMaxY(self.articleClassfy.frame) + ScreenWith/15, ScreenWith - 60, ScreenWith/10) andImageName:nil andTitle:@"马上导入" andBackGround:[UIColor whiteColor] andTitleColor:[UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:1.0 alpha:1.0] andFont:17.0 andCornerRadius:1.0];
        _importNowBt.layer.borderWidth = 1.0;
        _importNowBt.layer.borderColor = [UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:1.0 alpha:1.0].CGColor;
        
        [_importNowBt addTarget:self action:@selector(importArticleNowAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _importNowBt;
}


- (void)importArticleNowAction{


    NSLog(@"importArticleNowAction--%@--%@",self.pastedLink,self.selectedClassifyChannel);

}


- (UIPasteboard *)pasteboard{

    if (!_pasteboard) {
        
        _pasteboard = [UIPasteboard generalPasteboard];
        
    }
    return _pasteboard;
}


- (IBAction)popBackButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)rightButtonAction:(id)sender {
}


@end
