//
//  AliPayWithDrawRecordVC.m
//  NewApp
//
//  Created by gxtc on 17/3/17.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "AliPayWithDrawRecordVC.h"

@interface AliPayWithDrawRecordVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UIView * tableHeadView;

@property (nonatomic,strong)UITableView * tableView;

@property(nonatomic,assign)NSInteger currentIndexRow;
@property(nonatomic,assign)NSInteger lastIndexRow;

@property(nonatomic,retain)ExchangeRecordCell * cell;
@property(nonatomic,retain)ExchangeRecordCell * LastCell;

@property(nonatomic,strong)NSMutableArray * cashRecordArray;

@property (nonatomic,assign)NSInteger page;

@property(nonatomic,assign)BOOL isRefresh;

@property (nonatomic,assign)BOOL isOpen;


@end

@implementation AliPayWithDrawRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.page = 1;
    [self addUI];
    
    self.currentIndexRow = 10110;
    self.lastIndexRow = 10110;
}

- (void)addUI{
    [super addUI];
    self.titleLabel.text = @"提现记录";
    [self tableViewCreatNew];
}

- (void)MJ_refreshData{
    
    self.isRefresh = YES;
    self.page = 1;
    
    [self aliPayWithDrawRecordFromNetWithPage:self.page];

}


- (void)MJ_loadMoreData{
    
    self.isRefresh = NO;
    self.page ++;
    
    [self aliPayWithDrawRecordFromNetWithPage:self.page];
}


- (void)aliPayWithDrawRecordFromNetWithPage:(NSInteger)page{

    NetWork * net = [NetWork shareNetWorkNew];
    [net AliPayWithDrawRecordWithPage:page];
    
    __weak AliPayWithDrawRecordVC * weakSelf = self;
    
    net.aliPayWithDrawRecordBK=^(NSString * code,NSString * message,NSString * str,NSArray * dataArray,NSArray * array){
        if (dataArray.count > 0) {
            
            if (self.isRefresh) {
                
                weakSelf.cashRecordArray = [NSMutableArray arrayWithArray:dataArray];
                
            }else{
            
                [weakSelf.cashRecordArray addObjectsFromArray:dataArray];
                
            }
            
            [weakSelf.tableView reloadData];
            
            
        }
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];

    
    };
    
    
    net.netFailBK = ^{
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    };
    
    
}



- (void)tableHeadViewCreatNew{
    
    self.tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenWith/8)];
    self.tableHeadView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWith/4-10, ScreenWith/8)];
    timeLabel.text = @"时间";
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.backgroundColor = [UIColor whiteColor];
    [self.tableHeadView addSubview:timeLabel];
    
    UILabel * modeLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWith/4, 0, ScreenWith/4, ScreenWith/8)];
    
    modeLabel.text = @"方式";
    modeLabel.textColor = [UIColor blackColor];
    [self.tableHeadView addSubview:modeLabel];
    modeLabel.backgroundColor = [UIColor whiteColor];
    modeLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel * cashLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWith/2 + ScreenWith/16, 0, ScreenWith/4, ScreenWith/8)];
    
    cashLabel.text = @"金额(元)";
    cashLabel.textColor = [UIColor blackColor];
    [self.tableHeadView addSubview:cashLabel];
    cashLabel.backgroundColor = [UIColor whiteColor];
    
    UILabel * stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWith -ScreenWith/4 + 30 - 10, 0, ScreenWith/4 -30, ScreenWith/8)];
    [self.tableHeadView addSubview:stateLabel];
    stateLabel.text = @"状态";
    stateLabel.textColor = [UIColor blackColor];
    stateLabel.backgroundColor = [UIColor whiteColor];
    stateLabel.textAlignment = NSTextAlignmentRight;
    
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, ScreenWith/8, ScreenWith, 1)];
    line.backgroundColor =[UIColor lightGrayColor];
    [self.tableHeadView addSubview:line];
    
}


#pragma mark- tableViewCreat
- (void)tableViewCreatNew{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWith, ScreenHeight - 64) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = ScreenWith/7;
    [self tableHeadViewCreatNew];
    
    self.tableView.tableHeaderView = self.tableHeadView;
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJ_refreshData)];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJ_loadMoreData)];
    
    [self.tableView.mj_header beginRefreshing];
    
}


#pragma mark- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.cashRecordArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cell_id = @"cell_id";
    
    AliPayWithDrawRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (cell == nil) {
        cell = [[AliPayWithDrawRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_id"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    withDrawCashRecordModel * model = self.cashRecordArray[indexPath.row];
    
    if ([model.note isEqualToString:@""]) {
        
        cell.reasonImgView.alpha = 0;
    }else{
        
        cell.reasonImgView.alpha = 1;
        
    }
    
    cell.model= model;
    
    return cell;
    
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    withDrawCashRecordModel * model = self.cashRecordArray[indexPath.row];
    
    if ([model.note isEqualToString:@""]) {
        
        return;
    }
    
    
    
    ExchangeRecordCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    
    self.currentIndexRow = indexPath.row;
    
    if (cell.isShow == YES) {
        
        cell.isShow = !cell.isShow;
        
        cell.reasonLabel.alpha = 0;
        
        
        cell.reasonImgView.transform = CGAffineTransformIdentity;
        
        self.isOpen = NO;

        
    }else{
        
        cell.isShow = !cell.isShow;
        
        self.isOpen = YES;

        
        [UIView animateWithDuration:1 animations:^{
            cell.reasonLabel.alpha = 1;
            
        }];
        
        
        cell.reasonImgView.transform = CGAffineTransformIdentity;
        
        cell.reasonImgView.transform = CGAffineTransformMakeRotation(M_PI);
        
    }
    
    
    if (self.LastCell && self.LastCell != cell) {
        
        if (self.LastCell.isShow) {
            
            self.LastCell.reasonLabel.alpha = 0;
            
            self.LastCell.isShow = NO;
            
            self.LastCell.reasonImgView.transform = CGAffineTransformIdentity;
            
        }
        
    }
    
    
    self.LastCell = cell;
    
    
    [tableView beginUpdates];
    [tableView endUpdates];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    withDrawCashRecordModel * model = self.cashRecordArray[indexPath.row];
    
    
    
    if (self.currentIndexRow == indexPath.row) {
        
        
        if ((self.lastIndexRow == self.currentIndexRow || [model.note isEqualToString:@""])&& self.isOpen == NO) {
            
            self.lastIndexRow = 10000;
            
            return ScreenWith/7;
            
        }else if (self.isOpen == NO && self.lastIndexRow == 10000){
            
            return ScreenWith/7;
            
        }else{
            
            self.lastIndexRow = self.currentIndexRow;
            
            return ScreenWith/5;
        }
        
    }else{
        
        return ScreenWith/7;
    }
    
}


@end
