//
//  IncomeDetailVC.m
//  NewApp
//
//  Created by gxtc on 17/2/23.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "IncomeDetailVC.h"

@interface IncomeDetailVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,assign)NSInteger page1;
@property (nonatomic,assign)NSInteger page2;
@property (nonatomic,assign)NSInteger page3;
@property (nonatomic,assign)NSInteger page4;


@property (nonatomic,strong)UITableView * tableView1;
@property (nonatomic,strong)UITableView * tableView2;
@property (nonatomic,strong)UITableView * tableView3;
@property (nonatomic,strong)UITableView * tableView4;

@property (nonatomic,strong)NSMutableArray * dataArray1;
@property (nonatomic,strong)NSMutableArray * dataArray2;
@property (nonatomic,strong)NSMutableArray * dataArray3;
@property (nonatomic,strong)NSMutableArray * dataArray4;



@property (nonatomic,strong)ProfitMemberModel * memberModel ;

@property (nonatomic,assign)BOOL isMJRefresh;


/**今日已获得收益*/
@property(nonatomic,strong)UILabel * todayIncom;
/**今日广告分成*/
@property(nonatomic,strong)UILabel * todayAdcIncom;

/**昨日收入*/
@property(nonatomic,strong)UILabel * yestodayIncom;

/**昨日广告分成*/
@property(nonatomic,strong)UILabel * yestodayAdvIncom;

/**我的收入*/
@property(nonatomic,strong)UILabel * sum_money;

@property(nonatomic,strong)UIScrollView * scrollView;

@property(nonatomic,strong)UIView * cube;
@end

@implementation IncomeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    self.page1 = 1;
    self.page2 = 1;
    self.page3 = 1;
    self.page4 = 1;

    
    self.isMJRefresh = YES;
    
    
    self.dataArray1 = [NSMutableArray new];
    self.dataArray2 = [NSMutableArray new];
    self.dataArray3 = [NSMutableArray new];
    self.dataArray4 = [NSMutableArray new];

    [self addUI];
    
}

- (void)addUI{
    [super addUI];
    self.titleLabel.text = @"";
    [self addRightBarButtonNew];
    [self scrollViewCreatNew];
    [self tableViewNew];
    [self addHeadViewNew];

    [self scrollViewCubeNewWithTpe:self.type];
}



- (void)scrollViewCubeNewWithTpe:(NSInteger)type{

    UIView * cube = [[UIView alloc]initWithFrame:CGRectMake(ScreenWith/6 * (type - 1), 4, ScreenWith/6, 26)];
    cube.layer.borderWidth = 1.0;
    cube.layer.borderColor = [UIColor colorWithRed:0.0 green:191.0/255.0 blue:1.0 alpha:1.0].CGColor;
    cube.backgroundColor = [UIColor clearColor];
    cube.layer.cornerRadius = 13.0;
    
    UIView * view = [self.navigationBarView viewWithTag:115599];
    [view addSubview:cube];
    
    self.cube = cube;
}



- (void)rightBarButtonAction{

    NSLog(@"晒晒");
    
    ShaiShaiMyIncomeVC * vc = [[ShaiShaiMyIncomeVC alloc]init];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}



/**收益明细*/
- (void)getProfitDetailFromNetWithType:(NSInteger)type{

    NetWork * net = [NetWork shareNetWorkNew];

    NSInteger page = 0;
    
    if (type == 1) {
        
        page = self.page1;
        
    }else if(type == 2){
        
        page = self.page2;
        
    }else if (type == 3){
    
        page = self.page3;
    }else if (type == 4){
        
        page = self.page4;
    }
    
    
    [net profitDetailFromNetWithPage:page andType:type];
    
    __weak IncomeDetailVC * weakSelf =self;
    
    net.profitDetailBK=^(NSString * code,NSString * messgae,NSString * str,NSArray * dataArray,NSArray * data){
    
        if (dataArray.count > 0) {

            if (weakSelf.isMJRefresh) {
            
                if (type == 1) {
                    weakSelf.dataArray1 = [NSMutableArray arrayWithArray:dataArray];
                    
                }else if(type == 2){
                
                    weakSelf.dataArray2 = [NSMutableArray arrayWithArray:dataArray];

                }else if(type == 3){
                    
                    weakSelf.dataArray3 = [NSMutableArray arrayWithArray:dataArray];

                }else if(type == 4){
                    
                    weakSelf.dataArray4 = [NSMutableArray arrayWithArray:dataArray];
                    
                }
                
                
            }else{
            
                if (type == 1) {
                    
                    [weakSelf.dataArray1 addObjectsFromArray:dataArray];
                    
                }else if (type == 2){
                    
                    [weakSelf.dataArray2 addObjectsFromArray:dataArray];

                }else if(type == 3){
                    
                    [weakSelf.dataArray3 addObjectsFromArray:dataArray];
                    
                }else if(type == 4){
                    
                    [weakSelf.dataArray4 addObjectsFromArray:dataArray];
                    
                }
                
            }
            
        }
        
        if (type == 1) {
            
            [weakSelf.tableView1 reloadData];
            [weakSelf.tableView1.mj_header endRefreshing];
            [weakSelf.tableView1.mj_footer endRefreshing];
            
        }else if(type == 2){
            
            [weakSelf.tableView2 reloadData];
            [weakSelf.tableView2.mj_header endRefreshing];
            [weakSelf.tableView2.mj_footer endRefreshing];
            
        }else if(type == 3){
            
            [weakSelf.tableView3 reloadData];
            [weakSelf.tableView3.mj_header endRefreshing];
            [weakSelf.tableView3.mj_footer endRefreshing];
        }else if(type == 4){
            
            [weakSelf.tableView4 reloadData];
            [weakSelf.tableView4.mj_header endRefreshing];
            [weakSelf.tableView4.mj_footer endRefreshing];
        }

    
    };
    
}



- (void)MJreloadData{
    
    self.isMJRefresh = YES;
    
    
    if (self.type == 1) {
    
        self.page1 = 1;
        
    }else if(self.type == 2){
    
        self.page2 = 1;
        
    }else if (self.type == 3){
        
        self.page3 = 1;

    
    }else if (self.type == 4){
        
        self.page4 = 1;
        
        
    }
    
    
    [self getProfitDetailFromNetWithType:self.type];
}



- (void)MJLoadMoreData{
    
    self.isMJRefresh = NO;
    
    if (self.type == 1) {
        
        self.page1 += 1;
        
    }else if (self.type == 2){
        
        self.page2 += 1;
        
    }else if (self.type == 3){
    
        self.page3 += 1;

    }else if (self.type == 4){
        
        self.page4 += 1;
        
    }
    
    [self getProfitDetailFromNetWithType:self.type];
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if (scrollView.tag == 778899) {
        
        CGFloat x = scrollView.contentOffset.x;
        
        x = x/ScreenWith;
        
        if (x == 0) {
            
            self.type = 1;

            
            [self.tableView1.mj_header beginRefreshing];
            
            
            
        }else if(x == 1){
            
            self.type = 2;
            
            [self.tableView2.mj_header beginRefreshing];

        }else if (x == 2){
        
            self.type = 3;

            [self.tableView3.mj_header beginRefreshing];

        }else if (x == 3){
            
            self.type = 4;
            
            [self.tableView4.mj_header beginRefreshing];
            
        }

        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.cube.frame = CGRectMake(ScreenWith/6 * (self.type - 1), 4, ScreenWith/6, 26);

        }];
        

        
        
    }
    
}

- (void)scrollViewCreatNew{
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, ScreenWith, ScreenHeight - 64)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(ScreenWith * 4, 0);
    scrollView.backgroundColor = [UIColor lightGrayColor];
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.tag = 778899;
    scrollView.delegate = self;
    
    scrollView.contentOffset = CGPointMake(self.type * ScreenWith - ScreenWith, 0);
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;

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
    
    if (scrollView.tag ==112233) {
        
        [self.tableView1.mj_header beginRefreshing];;

        
    }else if (scrollView.tag == 112234){
    
        [self.tableView2.mj_header beginRefreshing];;

    }else if (scrollView.tag == 112235){
    
        [self.tableView3.mj_header beginRefreshing];;

    }else if (scrollView.tag == 112236){
        
        [self.tableView4.mj_header beginRefreshing];;
        
    }
    
}






- (void)tableViewNew{
    
    for (int i = 0; i<4; i++) {
        
    
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(ScreenWith * i,0, ScreenWith, ScreenHeight - 64) style:UITableViewStylePlain];
        tableView.showsVerticalScrollIndicator = NO;
        
//        tableView.rowHeight = ScreenWith/9;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        
        tableView.dataSource = self;
        tableView.delegate = self;
        [self.scrollView addSubview:tableView];
        tableView.tag = 112233+i;
    
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;

        MJRefreshAutoNormalFooter * foot = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJLoadMoreData)];
        
        foot.stateLabel.hidden=YES;

        
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJreloadData)];
        tableView.mj_footer = foot;

        
        if (i == 0) {
            self.tableView1 = tableView;
            
        }else if(i == 1){
        
            self.tableView2 = tableView;
            
        }else if(i == 2){
        
            self.tableView3 = tableView;

        }else if(i == 3){
            
            self.tableView4 = tableView;
            
        }
        
        
        if (self.type == 1 && i ==0) {
            
            [tableView.mj_header beginRefreshing];

        }else if (self.type == 2 && i ==1){
            
            [tableView.mj_header beginRefreshing];

        
        }else if (self.type == 3 && i ==2){
            
            [tableView.mj_header beginRefreshing];

        }else if (self.type == 4 && i ==3){
            
            [tableView.mj_header beginRefreshing];
            
        }

        
        
    }
}


- (void)addHeadViewNew{
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(ScreenWith/6, 24, ScreenWith*2/3, 44)];
    view.backgroundColor = [UIColor clearColor];
    view.tag = 115599;
//    view.layer.shadowOffset = CGSizeMake(0, 0);
//    view.layer.shadowOpacity = 0.5;
//    view.layer.shadowColor = [UIColor colorWithRed:0.0/255.0 green:191.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
    
    UIButton * bt1 = [self addRootButtonTypeTwoNewFram:CGRectMake(0, 0, ScreenWith*2/12, 34) andImageName:nil andTitle:@"任务" andBackGround:[ UIColor clearColor] andTitleColor:[UIColor  colorWithRed:0.0/255.0 green:191.0/255.0 blue:255.0/255.0 alpha:1.0] andFont:15.0 andCornerRadius:5.0];
    
    [view addSubview:bt1];
    bt1.tag = 778898;
    
    UIButton * bt2 = [self addRootButtonTypeTwoNewFram:CGRectMake(CGRectGetMaxX(bt1.frame), 0, (ScreenWith )*2/12, 34) andImageName:nil andTitle:@"邀请" andBackGround:[UIColor clearColor] andTitleColor:[UIColor  colorWithRed:0.0/255.0 green:191.0/255.0 blue:255.0/255.0 alpha:1.0] andFont:15.0 andCornerRadius:5.0];
    
    [view addSubview:bt2];
    bt2.tag = 778899;
    
    
    UIButton * bt3 = [self addRootButtonTypeTwoNewFram:CGRectMake(CGRectGetMaxX(bt2.frame),0, (ScreenWith)*2/12, 34) andImageName:nil andTitle:@"签到" andBackGround:[ UIColor clearColor] andTitleColor:[UIColor  colorWithRed:0.0/255.0 green:191.0/255.0 blue:255.0/255.0 alpha:1.0] andFont:15.0 andCornerRadius:5.0];
   
    [view addSubview:bt3];
    bt3.tag = 778900;

    
    UIButton * bt4 = [self addRootButtonTypeTwoNewFram:CGRectMake(CGRectGetMaxX(bt3.frame),0, (ScreenWith)*2/12, 34) andImageName:nil andTitle:@"其他" andBackGround:[ UIColor clearColor] andTitleColor:[UIColor  colorWithRed:0.0/255.0 green:191.0/255.0 blue:255.0/255.0 alpha:1.0] andFont:15.0 andCornerRadius:5.0];
    
    [view addSubview:bt4];
    bt4.tag = 778901;
    
    
    
    [bt1 addTarget:self action:@selector(twoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bt2 addTarget:self action:@selector(twoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bt3 addTarget:self action:@selector(twoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bt4 addTarget:self action:@selector(twoButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    
    [self.navigationBarView addSubview:view];
}

#pragma mark- 收益按钮
- (void)twoButtonAction:(UIButton *)bt{

    
    if (bt.tag == 778898) {
        
        self.type = 1;
        
        self.scrollView.contentOffset = CGPointMake(0,0);
        
        [self.tableView1.mj_header beginRefreshing];

        
        
    }else if(bt.tag == 778899){
    
        self.type = 2;
        
        self.scrollView.contentOffset = CGPointMake(ScreenWith,0);

        [self.tableView2.mj_header beginRefreshing];
        
    }else if(bt.tag == 778900){
    
        self.type = 3;
        
        self.scrollView.contentOffset = CGPointMake(ScreenWith * 2,0);
        
        [self.tableView3.mj_header beginRefreshing];

        
    }else if(bt.tag == 778901){
        
        self.type = 4;
        
        self.scrollView.contentOffset = CGPointMake(ScreenWith * 3,0);
        
        [self.tableView4.mj_header beginRefreshing];
        
        
    }

    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.cube.frame = CGRectMake(ScreenWith/6 * (self.type - 1), 4, ScreenWith/6, 26);
        
    }];
    
    
//    [self getProfitDetailFromNetWithType:self.type];

}


- (UILabel *)dataDetail:(NSString *)title andMoney1:(NSString *)money andLabelFram:(CGRect)fram{

    
    UILabel * achive = [[UILabel alloc]initWithFrame:fram];

    return achive;
}




#pragma mark- tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 112233) {

            IncomeDetailTypeTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_one"];
            if (cell == nil) {
            
                cell = [[IncomeDetailTypeTwoCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell_one"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

            }
        
            TaskAndInviateIncomeModel * model = self.dataArray1[indexPath.row];
        
        [cell setIconURL:self.iconURL AndModelData:model];
        
            return cell;

    }else if(tableView.tag == 112234){
    
    
        IncomeDetailTypeTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_two"];
        if (cell == nil) {
            
            cell = [[IncomeDetailTypeTwoCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell_two"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        TaskAndInviateIncomeModel * model = self.dataArray2[indexPath.row];
        
        [cell setIconURL:self.iconURL AndModelData:model];

        return cell;
    
    }else if(tableView.tag == 112235){
        
        IncomeDetailTypeTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_three"];
        if (cell == nil) {
            
            cell = [[IncomeDetailTypeTwoCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell_three"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        TaskAndInviateIncomeModel * model = self.dataArray3[indexPath.row];
        [cell setIconURL:self.iconURL AndModelData:model];

        
        return cell;

    
    }else{
        
        IncomeDetailTypeTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_four"];
        if (cell == nil) {
            
            cell = [[IncomeDetailTypeTwoCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell_four"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        TaskAndInviateIncomeModel * model = self.dataArray4[indexPath.row];
        [cell setIconURL:self.iconURL AndModelData:model];
        
        
        return cell;
        

    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   return ScreenWith/5 + 15;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 112233) {
        
        return self.dataArray1.count;
        
    }else if(tableView.tag == 112234){
        
        return self.dataArray2.count;
        
    }else if(tableView.tag == 112235){
        
        return self.dataArray3.count;

    }else{
        return self.dataArray4.count;

    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark- 分组高度
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
   
    return ScreenWith/8;//section头部高度
        
    
}


//section头部视图
- (UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray * titles = @[@"任务收益",@"人民币/元"];
    
        UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenWith/8)];
        view.backgroundColor = [UIColor whiteColor];
        view.backgroundColor = [UIColor whiteColor];
    
        view.layer.shadowOffset = CGSizeMake(0, 0);
        view.layer.shadowOpacity = 0.8;
        view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        /*
        UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWith/2, 20)];
        label.backgroundColor = [UIColor whiteColor];
        label.text = @"     收支明细";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor blackColor];
        [view addSubview:label];
        */
        
        for (int i = 0; i < 2; i++) {
        UILabel * label2=[[UILabel alloc] init];
        label2.backgroundColor = [UIColor whiteColor];
        label2.text = titles[i];
        label2.font = [UIFont systemFontOfSize:15];
        label2.textColor = [UIColor blackColor];
            
            if (i == 0) {
                label2.textAlignment = NSTextAlignmentLeft;
                label2.frame = CGRectMake(20, 0, ScreenWith/2 - 20, ScreenWith/8);
            }else{
                label2.textAlignment = NSTextAlignmentRight;
                label2.frame = CGRectMake(ScreenWith/2, 0, ScreenWith/2 - 20, ScreenWith/8);

            }
            
        [view addSubview:label2];
            
            
            if (tableView.tag == 112234 && i == 0 ) {
                
                label2.text = @"邀请收益";
            }
            
            if (tableView.tag == 112235 && i == 0 ) {
                
                label2.text = @"签到收益";
            }

            
            if (tableView.tag == 112236 && i == 0 ) {
                
                label2.text = @"其他收益";
            }
        }
        return view ;
    
}


//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
        return 0.1;
    
}
//section底部视图
- (UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}





@end

