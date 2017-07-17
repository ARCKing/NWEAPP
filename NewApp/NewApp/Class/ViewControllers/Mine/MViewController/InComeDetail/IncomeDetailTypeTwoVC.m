//
//  IncomeDetailTypeTwoVC.m
//  NewApp
//
//  Created by gxtc on 2017/6/3.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "IncomeDetailTypeTwoVC.h"

@interface IncomeDetailTypeTwoVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSMutableArray * dataArray1;

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,copy)NSString * iconURL;
@end

@implementation IncomeDetailTypeTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = [NSMutableArray new];
    self.dataArray1 = [NSMutableArray new];
    
    [self addUI];
    
    [self dataSourceFromNet];
    
    [self getMineDataFromNet];
    
    
}

#pragma mark- 我的信息
- (void)getMineDataFromNet{
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net getMineDataSource];
    
    __weak IncomeDetailTypeTwoVC * weakSelf = self;
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    net.mineDataSourceBK = ^(NSString * code, NSString * message, NSString * str, NSArray * dataArray, NSArray * arr) {
        
        [hud hideAnimated:YES];
        
        if ([code isEqualToString:@"1"]) {
            
            if (dataArray.count > 0) {
                
                MineDataSourceModel * model = dataArray[0];
                weakSelf.iconURL = model.headimgurl;
            }
            
        }
        
    };
}



- (void)MJrefreshData{


    [self dataSourceFromNet];


}




- (void)dataSourceFromNet{
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net NetinComeMonthDataFromNet];
    
    __weak IncomeDetailTypeTwoVC * weakSelf = self;
    
    net.incomeMonthBK = ^(NSString * code, NSString * message, NSString *str, NSArray * data, NSArray *arr) {
        
        if ([code isEqualToString: @"1"]) {
            
            if (data.count > 0) {
                
                weakSelf.dataArray = [NSMutableArray arrayWithArray:data];
                weakSelf.dataArray1 = [NSMutableArray arrayWithArray:arr];
                
                
                [weakSelf.tableView reloadData];
            }
        }
        
        
        [weakSelf.tableView.mj_header endRefreshing];
        
    };
}



- (void)addUI{
    
    [super addUI];
    self.titleLabel.text = @"收益明细";
    self.titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationBarView.backgroundColor = [UIColor colorWithRed:0.0 green:191.0/255.0 blue:1.0 alpha:1.0];
    [self.leftNavBarButton setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    
//    [self addRightBarButtonNew];
 
    [self addTableViewNew];
}

- (void)addTableViewNew{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWith, ScreenHeight - 64) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
//    tableView.rowHeight = ScreenWith/5 + 15;
    
    tableView.rowHeight = ScreenWith/8;
    
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJrefreshData)];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    IncomeDetailTypeThreeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (cell == nil) {
        cell = [[IncomeDetailTypeThreeCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [cell setTitleMessage:self.dataArray1[indexPath.row] andTitle2:self.dataArray[indexPath.row]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSInteger type = 1;
    
    
    if (indexPath.row == 0 ) {
        type = 1;
    }else if (indexPath.row == 1){
        type = 2;
    }else if (indexPath.row == 2){
        type = 3;
    }else if (indexPath.row == 3){
        type = 4;
    }
    
    
    if (indexPath.row != 4) {

        IncomeDetailVC * VC =[[IncomeDetailVC alloc]init];
        VC.iconURL = self.iconURL;
        VC.type = type;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        
    }else{
        
        AliPayWithDrawRecordVC * VC =[[AliPayWithDrawRecordVC alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
    
    }
    
    
    

}


@end
