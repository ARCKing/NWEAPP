//
//  RankPeopleVC.m
//  NewApp
//
//  Created by gxtc on 2017/5/25.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "RankPeopleVC.h"

@interface RankPeopleVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong)UITableView * userRankTableView;
@property (nonatomic,assign)userRankType currentUserRankType;
@property (nonatomic,copy)NSString * currentUserRank_cid;
@property (nonatomic,assign)NSInteger  currentUserRankPage;

@property (nonatomic,strong)NetWork * net;


@property (nonatomic,copy)NSString * uid;

@property (nonatomic,copy)NSString * token;

@property (nonatomic,strong)NSMutableArray * userDataArray;

@end

@implementation RankPeopleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NetWork * net = [NetWork shareNetWorkNew];
    self.net = net ;
    self.currentUserRankPage = 1;
    
    [self addUI];
}



- (void)addUI{

    [super addUI];

    self.titleLabel.text = @"排行榜";
    
    [self addTableViewNew];
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
    
    [self.userRankTableView.mj_header beginRefreshing];
}


- (void)addTableViewNew{
    
    UITableView * tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWith, ScreenHeight - 64) style:UITableViewStylePlain];
    tableview.showsVerticalScrollIndicator = NO;
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableFooterView = [[UIView alloc]init];
    
    tableview.emptyDataSetSource = self;
    tableview.emptyDataSetDelegate = self;

    [self.view addSubview:tableview];
    self.userRankTableView = tableview;
    
            
    MJRefreshNormalHeader * MJ_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJreloadData)];
            
    MJ_header.stateLabel.textColor =[UIColor colorWithRed:0.0 green:207.0/255.0 blue:1.0 alpha:1.0];
            
    MJ_header.lastUpdatedTimeLabel.textColor = [UIColor colorWithRed:0.0 green:207.0/255.0 blue:1.0 alpha:1.0];
            
    tableview.mj_header = MJ_header;
    
    
    
    MJRefreshAutoNormalFooter * foot = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJLoadDataMore)];
    
    foot.stateLabel.hidden=YES;
    
    tableview.mj_footer = foot;

            
    [tableview.mj_header beginRefreshing];
            

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"select:%ld",indexPath.row);
    
    /*
        UserRankModel * model = self.userDataArray[indexPath.row];
        PersonHomeVC * vc = [[PersonHomeVC alloc]init];
        vc.uid = model.uid;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    */
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
            UserRankCell * cell = [tableView dequeueReusableCellWithIdentifier:@"user"];
        if (cell == nil) {
            
            cell = [[UserRankCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"user"];
        }

    
        NSString * number = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    
        NSInteger number2 = indexPath.row + 1;
    
        if (number2 > 99) {
        
            number = @"99+";
        
            cell.numberRankLabel.font = [UIFont systemFontOfSize:8.0];
            
        }else{
        
            cell.numberRankLabel.font = [UIFont systemFontOfSize:13.0];

        }
    
        cell.numberRankLabel.text = number;
        
        //        [cell.numberRankLabel sizeToFit];
        if (indexPath.row == 0) {
            
            cell.numberRankLabel.backgroundColor = [UIColor redColor];
        }else if (indexPath.row == 1){
            
            cell.numberRankLabel.backgroundColor = [UIColor orangeColor];
        }else if (indexPath.row == 2){
            
            cell.numberRankLabel.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:164.0/255.0 blue:96.0/255.0 alpha:1.0];
        }else{
            
            cell.numberRankLabel.backgroundColor = [UIColor lightGrayColor];
        }
        
        UserRankModel * model = self.userDataArray[indexPath.row];
        
        [cell setDataWithModel:model andType:userRankType_money andHidenReview:NO];
        
        return cell;
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.userDataArray.count;
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return ScreenWith/5;
    
    
}

#pragma mark- MJ
/**MJre*/
-(void)MJreloadData{
    
    
    NSString *   type = @"money";
    
    __weak RankPeopleVC * weakSelf = self;
    
    
        [self.net userRankListGetFromNetWithType:type andTime:@"all" andPage:1];
        
        self.net.userRankBK=^(NSString * code,NSString * message,NSString * str,NSArray * dataArray,NSArray * data){
            
            weakSelf.userDataArray = [NSMutableArray arrayWithArray:dataArray];
            
            [weakSelf.userRankTableView reloadData];
            
            [weakSelf.userRankTableView.mj_header endRefreshing];
            
            NSLog(@"%@",dataArray);
        };
    
    
}


/**MJload*/
- (void)MJLoadDataMore{
    
    NSString *   type = @"money";
    
    __weak RankPeopleVC * weakSelf = self;
    
    self.currentUserRankPage += 1;
    
        [self.net userRankListGetFromNetWithType:type andTime:@"all" andPage:self.currentUserRankPage];
        
        self.net.userRankBK=^(NSString * code,NSString * message,NSString * str,NSArray * dataArray,NSArray * data){
            
            [weakSelf.userDataArray addObjectsFromArray:dataArray];
            
            [weakSelf.userRankTableView reloadData];
            
            [weakSelf.userRankTableView.mj_footer endRefreshing];
            
            NSLog(@"%@",dataArray);
            
        };
        
    
}

@end
