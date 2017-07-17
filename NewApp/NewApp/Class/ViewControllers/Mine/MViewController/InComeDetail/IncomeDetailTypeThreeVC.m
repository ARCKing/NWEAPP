//
//  IncomeDetailTypeThreeVC.m
//  NewApp
//
//  Created by gxtc on 2017/6/3.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "IncomeDetailTypeThreeVC.h"

@interface IncomeDetailTypeThreeVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,strong)UITableView * tableView;
@end

@implementation IncomeDetailTypeThreeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = [NSMutableArray new];
    
    [self addUI];
    
    
}




- (void)addUI{
    
    [super addUI];
    self.titleLabel.text = @"收益明细";
    self.titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationBarView.backgroundColor = [UIColor colorWithRed:0.0 green:191.0/255.0 blue:1.0 alpha:1.0];
    [self.leftNavBarButton setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    
    [self addRightBarButtonNew];
    
    [self addTableViewNew];
}

- (void)addTableViewNew{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWith, ScreenHeight - 64) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    tableView.rowHeight = ScreenWith/5 + 15;
    
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView = tableView;
    
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IncomeDetailTypeTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        cell = [[IncomeDetailTypeTwoCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
      
}


@end
