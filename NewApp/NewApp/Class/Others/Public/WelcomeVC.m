//
//  WelcomeVC.m
//  NewApp
//
//  Created by gxtc on 17/3/17.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "WelcomeVC.h"

@interface WelcomeVC ()


@end

@implementation WelcomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray * images = @[@"ydy_01",@"ydy_02",@"zhaocaitu_launch"];
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenHeight)];
    scrollView.contentSize = CGSizeMake(ScreenWith * 3, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    
    [self.view addSubview:scrollView];

    
    for (int i = 0; i < 3; i++) {
        
        UIImageView * imagev = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWith * i, 0, ScreenWith, ScreenHeight)];
        imagev.image = [UIImage imageNamed:images[i]];
        
        [scrollView addSubview:imagev];
    }
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(ScreenWith * 2, ScreenHeight *2/3, ScreenWith, ScreenHeight/3);
    
    [scrollView addSubview:button];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(endWelcomeAvtion) forControlEvents:UIControlEventTouchUpInside];
    
    
}



- (void)endWelcomeAvtion{

    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary * dic = [defaults objectForKey:@"userInfo"];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:dic];
    dict[@"welcome"] = @"1";
    dict[@"firstHongBao"] = @"0";
    
    NSDictionary * newDic = [NSDictionary dictionaryWithDictionary:dict];
    
    [defaults setObject:newDic forKey:@"userInfo"];
    
    [defaults synchronize];
    
    NSLog(@"立即体验");
    
    NSLog(@"%@",newDic);


    self.appDelegate.window.rootViewController = self.tab;
    [self.appDelegate.window makeKeyAndVisible];

}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
