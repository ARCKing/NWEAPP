//
//  FriendListVC.m
//  NewApp
//
//  Created by gxtc on 17/3/14.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "FriendListVC.h"
#import "myPrenticeCell.h"

#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define SCREEN_W [UIScreen mainScreen].bounds.size.width

@interface FriendListVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)NSMutableArray * listOneDataArray;
@property(nonatomic,strong)NSMutableArray * listTwoDataArray;


//@property(nonatomic,assign)NSInteger page;


@property(nonatomic,assign)BOOL isRefresh;

/**徒弟列表*/
@property(nonatomic,assign)BOOL listOne;

@property(nonatomic,assign)NSInteger pageOne;
@property(nonatomic,assign)NSInteger pageTwo;

@end

@implementation FriendListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.listOne = YES;
    self.pageOne = 1;
    self.pageTwo = 1;
    
    self.view.backgroundColor =[UIColor whiteColor];
//    self.page = 1;
    
    self.listOneDataArray = [NSMutableArray new];
    self.listTwoDataArray = [NSMutableArray new];

    [self addUI];
    
    
    
//    [self tableViewCreat];
    
}






- (void)addUI{

    [super addUI];

    self.titleLabel.text = @"师徒列表";
    
    [self twoButtonCreatNew];
}




- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)MJ_refreshData{
    
    self.isRefresh = YES;
    
//    self.page = 1;
    
    
    
    if (self.listOne == YES) {
        self.pageOne = 1;
        [self myPrenticeListFromNet:self.pageOne];

    }else{
        self.pageTwo = 1;
        [self myDiscipleListFromNetWithPage:self.pageTwo];
        
    }
    
    
    
}


- (void)MJ_loadMoreData{
    
    self.isRefresh = NO;
    
    
    if (self.listOne == YES) {
        
        self.pageOne ++;
        [self myPrenticeListFromNet:self.pageOne];
        

    }else{
        
        self.pageTwo ++;
        [self myDiscipleListFromNetWithPage:self.pageOne];
        

    }
}


/**徒弟列表*/
- (void)myPrenticeListFromNet:(NSInteger)page{
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net fiendListFromNetWithPage:page];
    
    __weak FriendListVC * weakSelf = self;
    
    net.frientListBK=^(NSString * code,NSString * message,NSString * str,NSArray * dataArray,NSArray * arr){
    
        if (dataArray.count > 0) {
           
            if (self.isRefresh) {
                
                weakSelf.listOneDataArray = [NSMutableArray arrayWithArray:dataArray];
                
            }else{
            
            
                [weakSelf.listOneDataArray addObjectsFromArray:dataArray];
                

            }
    
        }
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    
    };
}


/**徒孙列表*/
- (void)myDiscipleListFromNetWithPage:(NSInteger)page{

    NetWork * net = [NetWork shareNetWorkNew];
    
    [net discipleListGetFormNetWithPage:page];
    
    __weak FriendListVC * weakSelf = self;
    
    net.discipleListBK=^(NSString * code,NSString * message,NSString * str,NSArray * dataArray,NSArray * arr){
        
        if (dataArray.count > 0) {
            
            if (self.isRefresh) {
                
                weakSelf.listTwoDataArray = [NSMutableArray arrayWithArray:dataArray];
                
            }else{
                
                
                [weakSelf.listTwoDataArray addObjectsFromArray:dataArray];
                
                
            }
            
            
        }
        
        [weakSelf.tableView reloadData];

        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
    };

}



- (void)twoButtonCreatNew{

    NSArray * titleArray = @[@"徒弟列表",@"徒孙列表"];
    
    for (int i = 0; i<2; i++) {
        
        UIButton * bt = [self addRootButtonTypeTwoNewFram:CGRectMake(i * SCREEN_W/2, 64, SCREEN_W/2, SCREEN_W/10) andImageName:nil andTitle:titleArray[i] andBackGround:[UIColor whiteColor] andTitleColor:[UIColor blackColor] andFont:16.0 andCornerRadius:0.0];
        [bt addTarget:self action:@selector(twoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        bt.tag = i + 12345;
        [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        if (i == 0) {
            
            bt.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:178.0/255.0 blue:170.0/255.0 alpha:1.0];
            bt.selected = YES;
        }
        
        [self.view addSubview:bt];
    }
    

    [self tableViewCreat];

}



- (void)twoButtonAction:(UIButton *)bt{

    
    if (bt.tag == 12345) {
        
        self.listOne = YES;
        UIButton * bt2 = (UIButton *)[self.view viewWithTag:12346];
        bt.selected = YES;
        bt.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:178.0/255.0 blue:170.0/255.0 alpha:1.0];
        bt2.backgroundColor = [UIColor whiteColor];
        bt2.selected = NO;

        if (self.listOneDataArray.count > 0) {
            
            [self.tableView reloadData];

        }else{
        
            [self.tableView.mj_header beginRefreshing];
        }
        
    }else{
    
        self.listOne = NO;
        UIButton * bt1 = (UIButton *)[self.view viewWithTag:12345];
        bt.selected = YES;
        bt.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:178.0/255.0 blue:170.0/255.0 alpha:1.0];
        bt1.backgroundColor = [UIColor whiteColor];
        bt1.selected = NO;

        if (self.listTwoDataArray.count > 0) {
            
            [self.tableView reloadData];
            
        }else{

            [self.tableView.mj_header beginRefreshing];
        }
        
    }

    
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


- (void)tableViewCreat{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + SCREEN_W/10, SCREEN_W, SCREEN_H-64 - SCREEN_W/10) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = SCREEN_W/5;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJ_refreshData)];
    
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;

    
    MJRefreshAutoNormalFooter * foot = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJ_loadMoreData)];
    
    foot.stateLabel.hidden=YES;
    
    self.tableView.mj_footer = foot;
    

    [self.tableView.mj_header beginRefreshing];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (self.listOne == YES) {
        
        return self.listOneDataArray.count;
    }
    
    return self.listTwoDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    myPrenticeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        cell = [[myPrenticeCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    FriendListModel * model;
    
    if (self.listOne == YES) {
        
        model = self.listOneDataArray[indexPath.row];
        model.listType = @"1";
    }else{
        model = self.listTwoDataArray[indexPath.row];
        model.listType = @"2";
    }
    
    cell.model = model;
    return cell;
}

@end
