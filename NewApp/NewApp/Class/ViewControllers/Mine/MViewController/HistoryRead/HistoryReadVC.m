//
//  HistoryReadVC.m
//  NewApp
//
//  Created by gxtc on 17/2/22.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "HistoryReadVC.h"

@interface HistoryReadVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)UILabel * readCountLabel;
@end

@implementation HistoryReadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray new];
    
    [self addUI];
    
    [self checkHistoryReadArticleFromCoreData];
}

////数据请求
//- (void)gatDataFromNet{
//
//    NetWork * net = [NetWork shareNetWorkNew];
//    
//    __weak HistoryReadVC * weakSelf = self;
//    
//    [net userHistoryRedShowListWithUidAndToken];
//    
//    net.historyArticleReadListBK=^(NSString * code,NSString * message,NSString * readCount,NSArray * data1,NSArray * data2){
//    
//        weakSelf.dataArray = [NSMutableArray arrayWithArray:data1];
//        
//        weakSelf.readCountLabel.attributedText = [weakSelf addRootAttributedText:@"您阅读了篇文章" andArticleNum:readCount];
//        
//        [weakSelf.tableView reloadData];
//    };
//}


/**查找数据库*/
- (void)checkHistoryReadArticleFromCoreData{

    CoreDataManger * CDManger = [CoreDataManger shareCoreDataManger];
    
    NSArray * list = [CDManger checkArticleHestoryReadRecordList];
    
    if (list.count > 0) {
        
        self.dataArray = [NSMutableArray arrayWithArray:list];
        
        NSString * count = [NSString stringWithFormat:@"%ld",list.count];
        
        self.readCountLabel.attributedText = [self addRootAttributedText:@"您阅读了篇文章" andArticleNum:count];

        
        [self.tableView reloadData];
    }

}



- (void)rightBarClearButtonAction{
    NSLog(@"clear - 清除");
    
    CoreDataManger * CDManger = [CoreDataManger shareCoreDataManger];
    BOOL isClear = [CDManger deleteAllHestoryReadRecord];
    
    if (isClear) {
        
        [self.dataArray removeAllObjects];
        self.readCountLabel.attributedText = [self addRootAttributedText:@"您阅读了篇文章" andArticleNum:@"0"];

        [self.tableView reloadData];
    }
}



- (void)addUI{
    [super addUI];
    self.titleLabel.text = @"历史阅读";
    [self addRightBarClearButtonNew:@"清除"];
    
    UILabel * label =  [self addTableHeadViewWithArticleNumber:@"0"];
    
    self.readCountLabel = label;
    
    [self tableViewNew:label];
}


- (UILabel *)addTableHeadViewWithArticleNumber:(NSString *)articleNumber{

    UILabel * ReadLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenWith/8)];
    ReadLabel.textAlignment = NSTextAlignmentCenter;
    ReadLabel.attributedText = [self addRootAttributedText:@"您阅读了篇文章" andArticleNum:articleNumber];
    
    return ReadLabel;
}


- (void)tableViewNew:(UIView *)headView{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenWith, ScreenHeight - 64 ) style:UITableViewStylePlain];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.rowHeight = ScreenWith/9;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableHeaderView = headView;
    tableView.tableFooterView = [[UIView alloc]init];
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    HistoryRedModel * model = self.dataArray[indexPath.row];
    
    cell.textLabel.text = model.title;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
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
