//
//  ChannelMangerVC.m
//  NewApp
//
//  Created by gxtc on 17/3/14.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "ChannelMangerVC.h"
#import "buttonOrderView.h"

@interface ChannelMangerVC ()

@property (nonatomic,strong)UIButton * orderButton;
@property (nonatomic,strong)UIButton * finishButton;

@property (nonatomic,strong)NSArray * selectArray;
@property (nonatomic,strong)NSArray * unSelectArray;

@property (nonatomic,strong)buttonOrderView * orderView;

@end

@implementation ChannelMangerVC


- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];

}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addUI];
}


- (void)addUI{

    [super addUI];
    self.titleLabel.text = @"频道管理";

    
    [self buttonViewNew];
    
    buttonOrderView * btOrderView = [[buttonOrderView alloc]initWithFrame:CGRectMake(0, 64 + ScreenWith/10, ScreenWith, ScreenHeight - 64 - ScreenWith/10)];
    btOrderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btOrderView];
    
    self.orderView = btOrderView;
    self.selectArray = btOrderView.selectArray;
    self.unSelectArray =  btOrderView.unSelectArray;
    
    [btOrderView.lineButton addTarget:self action:@selector(buttonFinishAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}


- (void)buttonFinishAction{

    NSLog(@"频道管理完成!");

    NSLog(@"%@",self.selectArray);
    NSLog(@"%@",self.unSelectArray);
    
    
    NSMutableArray * selModel = [NSMutableArray new];
    NSMutableArray * unSelModel = [NSMutableArray new];
    
    for (UIButton * bt in self.selectArray) {
        
        ArticleClassifyModel * model = [[ArticleClassifyModel alloc]init];
        model.title = bt.titleLabel.text;
        model.c_id = [NSString stringWithFormat:@"%ld",bt.tag - 2200];
        
        [selModel addObject:model];
    }
    
    
    for (UIButton * bt in self.unSelectArray) {
        
        ArticleClassifyModel * model = [[ArticleClassifyModel alloc]init];
        model.title = bt.titleLabel.text;
        model.c_id = [NSString stringWithFormat:@"%ld",bt.tag - 1100];
        
        [unSelModel addObject:model];
    }
    
    
    NSLog(@"%@",selModel);
    NSLog(@"%@",unSelModel);
    
    
    
    CoreDataManger * CDManger = [CoreDataManger shareCoreDataManger];
    
    [CDManger deleteAllArticleClassData];
    
    [CDManger insertIntoDataWithArticalClassTheSelect:selModel andTheUnselect:unSelModel];
    
    
    self.channelMangerFinishBK();
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


- (void)buttonOrderAtion{

    NSLog(@"频道排序!");
    
    [self.orderView addGest];

}


- (void)buttonViewNew{

    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWith, ScreenWith/10)];
    view.backgroundColor = [UIColor colorWithRed:0.0 green:207.0/255.0 blue:1.0 alpha:1.0];
//    view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view];

    UILabel * label1 = [self addRootLabelWithfram:CGRectMake(20, 0, ScreenWith/4, ScreenWith/10) andTitleColor:[UIColor blackColor] andFont:15.0 andBackGroundColor:[UIColor clearColor] andTitle:@"我的频道"];
    [view addSubview:label1];
    
    
    UILabel * label2 = [self addRootLabelWithfram:CGRectMake(20 + ScreenWith/4 + 10, 0, ScreenWith/2, ScreenWith/10) andTitleColor:[UIColor blackColor] andFont:13.0 andBackGroundColor:[UIColor clearColor] andTitle:@"点击排序可拖动"];
    [view addSubview:label2];
    
    UIButton * orderButton = [self addRootButtonTypeTwoNewFram:CGRectMake(ScreenWith - 70, (ScreenWith/10 - ScreenWith/15)/2, 50, ScreenWith/15) andImageName:@"" andTitle:@"排序" andBackGround:[UIColor clearColor] andTitleColor:[UIColor whiteColor] andFont:15.0 andCornerRadius:3.0];
    orderButton.layer.borderWidth = 1.0;
    orderButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [orderButton addTarget:self action:@selector(buttonOrderAtion) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:orderButton];
    
    
}

@end
