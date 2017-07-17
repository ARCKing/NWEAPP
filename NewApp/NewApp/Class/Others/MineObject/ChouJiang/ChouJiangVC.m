//
//  ChouJiangVC.m
//  NewApp
//
//  Created by gxtc on 2017/5/19.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "ChouJiangVC.h"
#import "ChouJiangLuckView.h"

@interface ChouJiangVC ()

@end

@implementation ChouJiangVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addUI];
    
    ChouJiangLuckView * cj = [[ChouJiangLuckView alloc]initWithFrame:CGRectMake(0, 64, ScreenWith, ScreenHeight - 64)];
    cj.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cj];
    
    [cj getDataSource];
    
    
    
    UIButton * bt = [self addRootButtonNewFram:CGRectMake(0, 0, ScreenWith/4, ScreenWith/10) andSel:@selector(goToHtml) andTitle:@"抽奖规则"];
    bt.center = CGPointMake(ScreenWith/2, ScreenWith * 2/3);
    bt.layer.cornerRadius = 0.0;
    bt.backgroundColor = [UIColor clearColor];
    bt.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [bt setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.view addSubview:bt];
    
}



- (void)goToHtml{

    WKWebViewController * vc = [[WKWebViewController alloc]init];
    
    vc.urlString = [NSString stringWithFormat:@"%@/App/Index/guize.html",DomainURL];
    vc.isNewTeach = YES;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];


}



- (void)addUI{

    [super addUI];

    self.titleLabel.text = @"幸运抽奖";
    
    [self addRightBarClearButtonNew:@"中奖纪录"];
}



- (void)rightBarClearButtonAction{

    ChouJiangListVC * vc = [[ChouJiangListVC alloc]init];

    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
