//
//  VideoVC.m
//  NewApp
//
//  Created by gxtc on 17/2/13.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "VideoVC.h"

@interface VideoVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray * videoListArray;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,assign)NSInteger  currentPage;
@end

@implementation VideoVC


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentPage = 1;
    
    self.videoListArray = [NSMutableArray new];
    
    [self addUI];
    
    
}

- (void)addUI{
    
    self.navigationBarView = [self NavBarViewNew];
    self.navigationBarView.backgroundColor =[UIColor whiteColor];
    [self addTitleLabelNew];
    self.titleLabel.text = @"视频";
    [self addLineNew];
    [self tableViewNew];
    
}


#pragma mark- 下拉刷新
- (void)MJdataReload{

    self.currentPage = 1;
    [self getVideoListIsReload:YES andPage:1];

}


#pragma mark- 上拉加载
- (void)MJdataLoadMore{

    self.currentPage += 1;
    [self getVideoListIsReload:NO andPage:self.currentPage];


}


- (void)getVideoListIsReload:(BOOL)isReload andPage:(NSInteger)page{

    
    NSString * pageStr = [NSString stringWithFormat:@"%ld",page];
    
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net getVideoListFromNetWithPage:pageStr];
    
    __weak VideoVC * weakSelf = self;
    net.videoListBK=^(NSString * code,NSString * message,NSString * str,NSArray * dataArray,NSArray * aray){
    
        
        if (isReload) {
            
            weakSelf.videoListArray = [NSMutableArray arrayWithArray:dataArray];
            
            [self.tableView reloadData];
            
            [weakSelf.tableView.mj_header endRefreshing];

        }else{
        
            [weakSelf.videoListArray addObjectsFromArray:dataArray];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];

        }
        
       
    };
    
}


- (void)tableViewNew{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenWith, ScreenHeight - 64 - 49) style:UITableViewStylePlain];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.rowHeight = ScreenWith/4 + 20;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [[UIView alloc]init];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    
//    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJdataReload)];
    
    MJRefreshNormalHeader * MJ_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJdataReload)];
    
    MJ_header.stateLabel.textColor =[UIColor colorWithRed:0.0 green:207.0/255.0 blue:1.0 alpha:1.0];
    
    MJ_header.lastUpdatedTimeLabel.textColor = [UIColor colorWithRed:0.0 green:207.0/255.0 blue:1.0 alpha:1.0];
    
    tableView.mj_header = MJ_header;
    
    
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJdataLoadMore)];
    
    [tableView.mj_header beginRefreshing];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    MineOneTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell = [[MineOneTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    ArticleListModel * model = self.videoListArray[indexPath.row];
    
    cell.articleListModel = model;
    
    return cell;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.videoListArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    ArticleListModel * model = self.videoListArray[indexPath.row];
    
    WKWebViewController * wk = [[WKWebViewController alloc]init];
    wk.isPost = NO;
    wk.isVideo = YES;
    wk.articleModel = model;
    
    wk.article_id = [NSString stringWithFormat:@"%d",model.id];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wk animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
@end
