//
//  ChouJiangListVC.m
//  NewApp
//
//  Created by gxtc on 2017/5/26.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "ChouJiangListVC.h"

@interface ChouJiangListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic,strong)UIView * tableHeadView;
@property (nonatomic,assign)BOOL isRefresh;
@property (nonatomic,assign)NSInteger page;

@end

@implementation ChouJiangListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.page = 1;
    
    [self addUI];
}


- (void)addUI{
    [super addUI];
    self.titleLabel.text = @"中奖记录";
    [self tableViewCreatNew];
}

- (void)MJ_refreshData{
    
    self.isRefresh = YES;
    self.page = 1;
    
    [self getDataFromNet];
}


- (void)MJ_loadMoreData{
    
    self.isRefresh = NO;
    self.page += 1;
    
    [self getDataFromNet];
}


- (void)getDataFromNet{

    NetWork * net =[NetWork shareNetWorkNew];

    [net ChouJiangListGetFromNetWithPage:self.page];
    
    __weak ChouJiangListVC * weakSelf = self;
    
    net.ChouJiangListModelDataBK = ^(NSString *code, NSString *message, NSString *str, NSArray * dataArray, NSArray *arr) {
       
        if ([code isEqualToString:@"1"]) {
            
            if (dataArray.count > 0) {
                
                if (self.isRefresh == YES) {
                    
                    weakSelf.dataArray = [NSMutableArray arrayWithArray:dataArray];

                }else{
                
                    [weakSelf.dataArray addObjectsFromArray:dataArray];
                
                }
            
                [weakSelf.tableView reloadData];

            }
            
        }
        
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
    };
    
    
}


#pragma mark- tableViewCreat
- (void)tableViewCreatNew{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWith, ScreenHeight - 64) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.rowHeight = ScreenWith/10;
    self.tableView.showsVerticalScrollIndicator = NO;
//    self.tableView.tableHeaderView = self.tableHeadView;
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJ_refreshData)];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJ_loadMoreData)];
    
    [self.tableView.mj_header beginRefreshing];
    
}


- (void)secontionHeadViewCreatNew{
    
    self.tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenWith/8)];
    self.tableHeadView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:192.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    
    UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWith/2 - 10, ScreenWith/8)];
    timeLabel.text = @"时间";
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.backgroundColor = [UIColor clearColor];
    [self.tableHeadView addSubview:timeLabel];
    
    UILabel * modeLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWith/2, 0, ScreenWith/2 - 10, ScreenWith/8)];
    
    modeLabel.text = @"详情";
    modeLabel.textColor = [UIColor whiteColor];
    [self.tableHeadView addSubview:modeLabel];
    modeLabel.backgroundColor = [UIColor clearColor];
    modeLabel.textAlignment = NSTextAlignmentRight;

    
}



#pragma mark- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cell_id = @"cell_id";
    
    ChouJiangListCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    
    if (cell == nil) {
        
        cell = [[ChouJiangListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    
    
    ChouJiangModel * model = self.dataArray[indexPath.row];
    
    if (model) {
        
        cell.model = model;
    }
    
    
    if (indexPath.row % 2 == 0) {
        cell.contentView.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:1.0 alpha:0.5];
        cell.timeLabel.textColor = [UIColor whiteColor];
        cell.titleLabel.textColor = [UIColor whiteColor];

    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        cell.timeLabel.textColor = [UIColor lightGrayColor];
        cell.titleLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
    
    
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ScreenWith/10;
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (self.tableHeadView == nil) {
        
        [self secontionHeadViewCreatNew];
    }

    return self.tableHeadView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return ScreenWith/8;

}



@end
