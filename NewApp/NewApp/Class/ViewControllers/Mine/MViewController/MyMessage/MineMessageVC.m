//
//  MineMessageVC.m
//  NewApp
//
//  Created by gxtc on 17/2/20.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "MineMessageVC.h"

@interface MineMessageVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)UIView * line;

@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * systemDataArray;


@property (nonatomic,strong)UITableView * respondMineTableView;
@property (nonatomic,strong)UITableView * systemTableView;

@property (nonatomic,assign)NSInteger  respondPage;
@property (nonatomic,assign)NSInteger  systemMessagePage;

@property (nonatomic,assign)BOOL isRespondToMineMessage;
@property (nonatomic,assign)BOOL isRespondRefresh;
@property (nonatomic,assign)BOOL issystemRefresh;

@end

@implementation MineMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.respondPage = 1;
    self.systemMessagePage = 1;
    self.isRespondToMineMessage = YES;
    
    self.issystemRefresh = NO;
    self.isRespondRefresh = NO;
    
    self.dataArray = [NSMutableArray new];
    self.systemDataArray = [NSMutableArray new];
    
    
    [self addUI];
    
  }

- (void)addUI{
    
    
    [self addNavBarNew];
    [self addButtonNew];
    [self scrollViewNew];
    [self lineNew];
}


/**我的回复*/
- (void)myRespondDataGetFromNet{

    NetWork * net = [NetWork shareNetWorkNew];
    
    __weak MineMessageVC * weakSelf = self;
    
    [net getMyRespondDataFromNetWithPage:self.respondPage];
    
    net.myRespondDataBK=^(NSString * code,NSString * message,NSString * str,NSArray * dataArray,NSArray * data){
    
        if (dataArray.count > 0) {
            
            
            if (self.isRespondRefresh) {
                
                weakSelf.dataArray = [NSMutableArray arrayWithArray:dataArray];
                
                [weakSelf.respondMineTableView reloadData];

            }else{
            
                [weakSelf.dataArray addObjectsFromArray:dataArray];
                [weakSelf.respondMineTableView reloadData];

            }
            
        }
    
        [weakSelf.respondMineTableView.mj_header endRefreshing];
        [weakSelf.respondMineTableView.mj_footer endRefreshing];
        
        
        
    };
    
}



/**系统消息*/
- (void)systemMessageDataGetFromNet{

    
    NetWork * net = [NetWork shareNetWorkNew];
    
    __weak MineMessageVC * weakSelf = self;
    
    [net getSystemMessageFromNetWithPage:self.systemMessagePage];

    net.systemMessageDataBK=^(NSString * code,NSString * message,NSString * str,NSArray * dataArray,NSArray * data){
    
        if (dataArray.count > 0) {
            
            if (self.issystemRefresh) {
                
                CoreDataManger * CDManger = [CoreDataManger shareCoreDataManger];

                BOOL isSucceed = [CDManger deleteAllSystemMessageData];
                
                if (isSucceed) {
                    
                    [CDManger insertIntoDataWithsystemMessage:dataArray andPage:@"1"];
                    
                }
                
                weakSelf.systemDataArray = [NSMutableArray arrayWithArray:dataArray];
                
                [weakSelf.systemTableView reloadData];

            }else{
            
                
                [weakSelf.systemDataArray addObjectsFromArray:dataArray];
                
                [weakSelf.systemTableView reloadData];

            }
            
            
            
        }
    
        [weakSelf.systemTableView.mj_header endRefreshing];
        [weakSelf.systemTableView.mj_footer endRefreshing];
        
    };
    
}



- (void)MJreloadData{
    
    if (self.isRespondToMineMessage) {
        self.respondPage = 1;
        self.isRespondRefresh = YES;
        
        [self myRespondDataGetFromNet];

    }else{
        
        self.issystemRefresh = YES;
        self.systemMessagePage = 1;
        [self systemMessageDataGetFromNet];

    }

}



- (void)MJLoadMoreData{

    
    if (self.isRespondToMineMessage) {
        self.isRespondRefresh = NO;
        self.respondPage ++;
        [self myRespondDataGetFromNet];
        

    }else{
        self.issystemRefresh = NO;
        self.systemMessagePage ++;
        [self systemMessageDataGetFromNet];

    }
    
}






- (void)addNavBarNew{

    self.navigationBarView = [self NavBarViewNew];
    self.navigationBarView.backgroundColor =[UIColor whiteColor];
    [self addTitleLabelNew];
    [self addLeftBarButtonNew];
    self.titleLabel.text = @"我的消息";
    [self addLineNew];

}


#pragma mark- buttonNew
- (void)addButtonNew{

    for (int i = 0; i < 2; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(ScreenWith/2 * i, 64, ScreenWith/2, ScreenWith/13);
        if (i == 0) {
            [button setTitle:@"回复我的" forState:UIControlStateNormal];
            button.selected = YES;
        }else{
            [button setTitle:@"系统通知" forState:UIControlStateNormal];
        }
        [button setTitleColor:[UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = 1000 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)buttonAction:(UIButton *)button{
    UIButton * bt1 = (UIButton *)[self.view viewWithTag:1000];
    UIButton * bt2 = (UIButton *)[self.view viewWithTag:1001];

    if (button.tag == 1000) {
        bt1.selected = YES;
        bt2.selected = NO;
        
        self.isRespondToMineMessage = YES;
        
        self.scrollView.contentOffset = CGPointMake(0, 0);

        [UIView animateWithDuration:0.2 animations:^{
            self.line.frame = CGRectMake(0, 64 +ScreenWith/13 - 1, ScreenWith/2, 1);
 
        }];
    
    }else{
        
        self.isRespondToMineMessage = NO;

        
        bt1.selected = NO;
        bt2.selected = YES;
        self.scrollView.contentOffset = CGPointMake(ScreenWith, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.line.frame = CGRectMake(ScreenWith/2, 64 +ScreenWith/13 - 1, ScreenWith/2, 1);
            
        }];
    }

}

#pragma mark- scrollViewNew
- (void)scrollViewNew{
    [self addScrollViewNew];
    [self addTableViewNew];
}

- (void)addScrollViewNew{
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64 + ScreenWith/13, ScreenWith, ScreenHeight-64-ScreenWith/13)];
    scrollView.contentSize = CGSizeMake(ScreenWith * 2, 0);
    scrollView.scrollEnabled = NO;
    scrollView.backgroundColor = [UIColor cyanColor];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];

}

- (void)addTableViewNew{
    
    for (int i = 0; i < 2; i ++) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(i * ScreenWith, 0, ScreenWith, ScreenHeight-64 - ScreenWith/13) style:UITableViewStylePlain];
        tableView.tag = 1100 + i;
        tableView.delegate = self;
        tableView.dataSource = self;
//        tableView.rowHeight = ScreenWith/7;
        tableView.tableFooterView = [[UIView alloc]init];
        [self.scrollView addSubview:tableView];
        
        
        if (i == 0) {
         
            self.respondMineTableView = tableView;
            
            tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJreloadData)];
            tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJLoadMoreData)];
            [tableView.mj_header beginRefreshing];
            
            
        }else{
            self.systemTableView = tableView;
            
            tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJreloadData)];
            tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJLoadMoreData)];
            
            
            
            CoreDataManger * CDManger = [CoreDataManger shareCoreDataManger];
            
            NSArray * array = [CDManger checkAllSystemMessage];
            
            if (array.count > 0) {
                
                self.systemDataArray = [NSMutableArray arrayWithArray:array];
                
                [self.systemTableView reloadData];
                
            }else{
            
                [self systemMessageDataGetFromNet];

            
            }
            
        }
        
    }
}






#pragma mark- lineNew
- (void)lineNew{

    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 64 +ScreenWith/13 - 1, ScreenWith/2, 1)];
    self.line = line;
    line.backgroundColor = [UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1];
    [self.view addSubview:line];
    
}

#pragma mark- tableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (tableView.tag == 1100) {
        
        RespondMineCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld_cell",indexPath.row ]];
        
        if (cell == nil) {
            cell = [[RespondMineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%ld_cell",indexPath.row]];
            
            cell.selectionStyle = UITableViewCellAccessoryNone;
        }
        
        RespondToMineModel * model = self.dataArray[indexPath.row];
        
        cell.model = model;
        cell.numberLabel.text = [NSString stringWithFormat:@"%ld",self.dataArray.count - indexPath.row];
        
        
        NSString * name = model.comment_nickname;
        NSString * content = model.comment_content;
        
        NSString * str = [NSString stringWithFormat:@"\n  %@:\n  %@\n",name,content];
        
        CGRect respondStr_fram = [str boundingRectWithSize:CGSizeMake(ScreenWith*3/4, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil];

        cell.respondLabel.frame = CGRectMake(CGRectGetMaxX(cell.imageV.frame)+5,CGRectGetMaxY(cell.timeLabel.frame) + 5, ScreenWith * 3/4, respondStr_fram.size.height);
        cell.respondLabel.text = str;
        cell.respondLabel.layer.borderWidth = 1.0;
        cell.respondLabel.layer.borderColor = [UIColor orangeColor].CGColor;
        [cell.contentView addSubview:cell.respondLabel];
        
        
        CGRect contentr_fram = [model.content boundingRectWithSize:CGSizeMake(ScreenWith*3/4, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil];

        cell.detailComentTextLabel.frame = CGRectMake(CGRectGetMaxX(cell.imageV.frame)+5,CGRectGetMaxY(cell.respondLabel.frame) + 5, ScreenWith * 3/4, contentr_fram.size.height);
        cell.detailComentTextLabel.text = model.content;
        
        cell.detailComentTextLabel.layer.borderWidth = 1.0;
        cell.detailComentTextLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [cell.contentView addSubview:cell.detailComentTextLabel];
        
        
        cell.articleLabel.frame = CGRectMake(CGRectGetMaxX(cell.imageV.frame)+5,CGRectGetMaxY(cell.detailComentTextLabel.frame) + 5, ScreenWith *4/5, ScreenWith/15 );
        cell.articleLabel.text = [NSString stringWithFormat:@" 文章:%@",model.article_title];
        [cell.contentView addSubview:cell.articleLabel];
        return cell;

    }else{
    
    
        SystemMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_one"];
        if (cell == nil) {
        cell = [[SystemMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_one"];
        }
        
        systemMessageModel * model = self.systemDataArray[indexPath.row];
        cell.model = model;
        return cell;
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView.tag == 1100) {
        
        
        RespondToMineModel * model = self.dataArray[indexPath.row];
        
        NSString * name = model.comment_nickname;
        NSString * content = model.comment_content;
        NSString * str = [NSString stringWithFormat:@"\n  %@:\n  %@\n",name,content];
        
        
        CGRect respondStr_fram = [str boundingRectWithSize:CGSizeMake(ScreenWith*3/4, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil];

        CGRect contentr_fram = [model.content boundingRectWithSize:CGSizeMake(ScreenWith*3/4, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil];
        
        CGFloat total_H = respondStr_fram.size.height + contentr_fram.size.height + ScreenWith/15;
        
        
        return ScreenWith/6 + 5 + total_H;
        
    }else{
        return ScreenWith/7;

    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    if (tableView.tag == 1100) {
        
        
        
    }else{
    
        systemMessageModel * model = self.systemDataArray[indexPath.row];
        
        
        MineDetailMessageVC * vc = [[MineDetailMessageVC alloc]init];
        vc.messageID = [NSString stringWithFormat:@"%d",model.id];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    
    }
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (tableView.tag == 1100) {
        return self.dataArray.count;
    }else{
        
        return self.systemDataArray.count;
    }
}

@end

