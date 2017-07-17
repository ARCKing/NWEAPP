//
//  ShareRecordVC.m
//  NewApp
//
//  Created by gxtc on 2017/6/7.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "ShareRecordVC.h"

@interface ShareRecordVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,assign)NSInteger page;

@end

@implementation ShareRecordVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray new];
    self.page = 1;
    
    [self addUI];
    
}


- (void)addUI{
    [super addUI];
    self.titleLabel.text = @"我的分享";
    
    [self tableViewNew];
}


- (void)getdataFromNetIsRefresh:(BOOL)refresh{
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net NetShareRecordWithPage:self.page];
    
    __weak ShareRecordVC * weakSelf = self;
    
    net.shareRecordBK= ^(NSString * code,NSString * message,NSString * str ,NSArray * dataArray,NSArray * data){
        
        if (dataArray.count > 0) {
            
            if (refresh) {
                
                weakSelf.dataArray = [NSMutableArray arrayWithArray:dataArray];
                
                
            }else{
                
                [weakSelf.dataArray addObjectsFromArray:dataArray];
                
            }
            
        }
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        [weakSelf.tableView reloadData];
        
        
    };
    
}

////设置空白页
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"icon_noD"];
}

//设置垂直位置
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    
    return -ScreenWith/3;
    
}


// 是否 允许点击,默认是YES
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView{
    return YES;
}


// 点击中间的图片和文字时调用
- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView{
    NSLog(@"点击了view");
    
    [self.tableView.mj_header beginRefreshing];
}


- (void)tableViewNew{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenWith, ScreenHeight - 64 ) style:UITableViewStylePlain];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.rowHeight = ScreenWith/4 + 20;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [[UIView alloc]init];
    
    tableView.emptyDataSetSource = self;
    tableView.emptyDataSetDelegate = self;
    
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    
    MJRefreshNormalHeader * MJ_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJreloadData)];
    
    MJ_header.stateLabel.textColor =[UIColor colorWithRed:0.0 green:207.0/255.0 blue:1.0 alpha:1.0];
    
    MJ_header.lastUpdatedTimeLabel.textColor = [UIColor colorWithRed:0.0 green:207.0/255.0 blue:1.0 alpha:1.0];
    
    tableView.mj_header = MJ_header;
    
    
    MJRefreshAutoNormalFooter * foot = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJLoadDataMore)];
    
    foot.stateLabel.hidden=YES;
    
    tableView.mj_footer = foot;
    
    
    [tableView.mj_header beginRefreshing];
    
}


- (void)MJreloadData{
    
    self.page = 1;
    [self getdataFromNetIsRefresh:YES];
}

- (void)MJLoadDataMore{
    
    self.page += 1;
    [self getdataFromNetIsRefresh:NO];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MineOneTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        cell = [[MineOneTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.isShareRecord = YES;
    }
    
    ArticleListModel * model = self.dataArray[indexPath.row];
    
    cell.articleListModel = model;
    
    
    return cell;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ArticleListModel * model = self.dataArray[indexPath.row];
    
    WKWebViewController * web = [[WKWebViewController alloc]init];
    web.article_id = [NSString stringWithFormat:@"%d",model.id];
    web.isPost = NO;
    web.articleModel = model;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
    
    
}

@end
