//
//  RankVC.m
//  NewApp
//
//  Created by gxtc on 17/2/13.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "RankVC.h"

@interface RankVC ()<UITableViewDelegate,UITableViewDataSource>
/**
 *滑条
 */
@property (nonatomic,strong)UIView * SelectButtonline;

/**
 *列表滚动视图
 */
@property (nonatomic,strong)UIScrollView * tableScrollView;

/**
 *存放按钮数组
 */
@property (nonatomic,strong)NSArray * articleRankFourButtonArray;
@property (nonatomic,strong)NSArray * userRankFourButtonArray;


/**tableView*/
@property (nonatomic,strong)UITableView * articleRankTableView;
@property (nonatomic,strong)UITableView * userRankTableView;


@property (nonatomic,strong)NetWork * net;

//状态 redbool为蹿红，week为周榜，all为总榜
//类型 read 阅读 share 分享 money 收入
@property (nonatomic,assign)ArticleRankType currentArticleRankType;
@property (nonatomic,assign)userRankType currentUserRankType;

//当前c_id
@property (nonatomic,copy)NSString * currentUserRank_cid;
@property (nonatomic,copy)NSString * currentArticleRank_cid;

//当前页码
@property (nonatomic,assign)NSInteger  currentArticleRankPage;
@property (nonatomic,assign)NSInteger  currentUserRankPage;


@property (nonatomic,strong)NSMutableArray * articleChannelArray;

@property (nonatomic,strong)NSMutableArray * channelTitle;
@property (nonatomic,strong)NSMutableArray * channel_cid;

@property (nonatomic,strong)NSMutableArray * buttonSaveArray;

//爆文榜list
@property (nonatomic,strong)UIView * channelListView;
@property (nonatomic,assign)BOOL isShowListView;
@property (nonatomic,copy)NSString * currentUserRankTime;


//用户榜list
@property (nonatomic,strong)UIView * userListView;
@property (nonatomic,assign)BOOL isShowUserListView;


@property (nonatomic,copy)NSString * uid;
@property (nonatomic,copy)NSString * token;

@property (nonatomic,assign) BOOL isArticleRank;
@property (nonatomic,assign) BOOL isUserRank;

//列表数据源
@property (nonatomic,strong)NSMutableArray * articleDataArray;
@property (nonatomic,strong)NSMutableArray * userDataArray;

@property (nonatomic,assign)BOOL hidenIs;
@property (nonatomic,strong)UIButton * incomeRankButton;

@end

@implementation RankVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hidenIs = YES;
    
    [self dataInit];
    
    
    // Do any additional setup after loading the view.
    
    [self addUI];
    
    [self getArticleChannelFromNet];
    
    [self hidenWhenReview];
}



#pragma mark- 审核隐藏
/**审核隐藏*/
- (void)hidenWhenReview{
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net hidenWhenReviewFromNet];
    
    __weak RankVC * weakSelf = self;
    
    net.hidenWhenReviewBK = ^(NSString * code, NSString * data) {
        
        
        if ([data isEqualToString:@"1"]) {
            
            [weakSelf.incomeRankButton setTitle:@"收入榜" forState:UIControlStateNormal];
            
            weakSelf.hidenIs = NO;
            
        }else{
            
            weakSelf.hidenIs = YES;
            
        }
        
        
    };
    
}




/**数据初始化*/
- (void)dataInit{

    self.net = [NetWork shareNetWorkNew];
    
    self.articleChannelArray = [NSMutableArray new];
    self.channel_cid = [NSMutableArray new];
    self.channelTitle = [NSMutableArray new];
    self.buttonSaveArray = [NSMutableArray new];
    
    self.currentArticleRankType = articleRankType_redboll;
    self.currentUserRankType = userRankType_share;
    
    self.isShowListView = NO;

    self.currentArticleRankPage = 1;
    self.currentUserRankPage = 1;
    
    self.isArticleRank = YES;
    self.isUserRank = YES;
    
    self.articleDataArray = [NSMutableArray new];
    self.userDataArray = [NSMutableArray new];
}


- (void)getTokenAndUid{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary * userInfo = [defaults objectForKey:@"userInfo"];
    
    self.uid = userInfo[@"uid"];
    self.token = userInfo[@"token"];
    
}


- (void)addUI{

    
    [self addNavBarViewNew];
    [self tableScrollViewNew];
    [self fourButtonNew];
//    [self tableViewNew];
 
}

- (void)getArticleChannelFromNet{


    [self.net getArticleChannelClassifyFromNet];
    
    __weak RankVC * weakSelf = self;
    self.net.articleClassifyBK=^(NSString * code,NSString * message,NSString * ss,NSArray * dataArray,NSArray * arr){
    
        weakSelf.articleChannelArray = [NSMutableArray arrayWithArray:dataArray];
        
        NSLog(@"%@",dataArray);
        
        
        if (dataArray.count > 0) {
            
            for (ArticleClassifyModel * model in dataArray) {
                
                [weakSelf.channelTitle addObject:model.title];
                [weakSelf.channel_cid addObject:model.c_id];
                
            }
            
        }
        
        NSLog(@"%@",weakSelf.channelTitle);
        NSLog(@"%@",weakSelf.channel_cid);
        
        [weakSelf tableViewNew];
        
    };
    
}


#pragma mark- 用户ListView
- (void)userListViewNew{


    //按钮高度
    CGFloat bt_h = ScreenWith / 10;
    CGFloat bt_w = ScreenWith/4 - 3;

    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(1, 64 + ScreenWith/10, bt_w, 3 * bt_h)];
    view.backgroundColor =[ UIColor whiteColor];
    
//    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    view.layer.borderWidth = 0.5;
    
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowOpacity = 0.8;
    
    
    self.userListView = view;
    
    NSArray * title = @[@"今日",@"本周",@"总榜"];
    
    for (int i = 0; i < 3; i ++) {
        
        UIButton * bt = [self addRootButtonTypeTwoNewFram:CGRectMake(0, bt_h * i, bt_w, bt_h) andImageName:@"" andTitle:title[i] andBackGround:[UIColor whiteColor] andTitleColor:[UIColor lightGrayColor] andFont:16.0 andCornerRadius:0.0];
        [bt addTarget:self action:@selector(userListViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:bt];
        [bt setTitleColor:[UIColor cyanColor] forState:UIControlStateSelected];
        
        bt.tag = 5200 + i;
        
        
        if (i == 0){
            
            bt.selected = YES;
        }
    }

}

- (void)userListViewButtonAction:(UIButton * )bt{

    NSLog(@"%ld",bt.tag);
    NSLog(@"%@",bt.titleLabel.text);

    
    UIButton * fourButton_one =  self.userRankFourButtonArray[0];
    
    [fourButton_one setTitle:bt.titleLabel.text forState:UIControlStateNormal];
    
    
    UIButton * todayBt = [(UIButton *)self.userListView viewWithTag:5200];
    
    UIButton * weekBt = [(UIButton *)self.userListView viewWithTag:5201];

    UIButton * allBt = [(UIButton *)self.userListView viewWithTag:5202];

    if (bt.tag == 5200) {
        
        self.currentUserRankTime = @"day";
        
        todayBt.selected = YES;
        weekBt.selected = NO;
        allBt.selected = NO;
        
    }else if (bt.tag == 5201) {
        self.currentUserRankTime = @"week";

        todayBt.selected = NO;
        weekBt.selected = YES;
        allBt.selected = NO;

    }else{
        self.currentUserRankTime = @"all";

        todayBt.selected = NO;
        weekBt.selected = NO;
        allBt.selected = YES;

    }
    
    
    self.isShowUserListView = NO;
    [self.userListView removeFromSuperview];
    
    self.isArticleRank = NO;
    self.isUserRank = YES;
    
    [self.userRankTableView.mj_header beginRefreshing];
    
    
}



- (void)channelListViewNew{

    NSInteger channelCount = self.channelTitle.count;
    
    //按钮高度
    CGFloat bt_h = ScreenWith / 10;
    CGFloat bt_w = ScreenWith/5;
    //按钮行数
    NSInteger row = channelCount/5;
    NSInteger row_one = channelCount%5;
    
    if (row_one > 0) {
        
        row = row + 1;

    }
    
//    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 64 + ScreenWith/10, ScreenWith, row * bt_h)];
    
    UIView * view = [[UIView alloc]init];
    view.bounds = CGRectMake(0, 0,ScreenWith, row * bt_h);
    view.layer.position = CGPointMake(0, 64 + ScreenWith/10);
    view.layer.anchorPoint = CGPointMake(0, 0);
    
    view.backgroundColor =[ UIColor whiteColor];
    
    view.layer.shadowOpacity = 0.8;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    
    self.channelListView = view;
    
    
    for (int i = 0; i < channelCount; i ++) {
    
        UIButton * bt = [self addRootButtonTypeTwoNewFram:CGRectMake(bt_w * (i%5), bt_h *(i/5), bt_w, bt_h) andImageName:@"" andTitle:self.channelTitle[i] andBackGround:[UIColor whiteColor] andTitleColor:[UIColor lightGrayColor] andFont:16.0 andCornerRadius:0.0];
        [bt addTarget:self action:@selector(channelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:bt];
        [bt setTitleColor:[UIColor cyanColor] forState:UIControlStateSelected];
        
        bt.tag = 4200 + i;
        
        [self.buttonSaveArray addObject:bt];
        
        
        if (i == 0){
        
            bt.selected = YES;
        }
    }

    

}

#pragma mark- channelListViewButtonAction
- (void)channelButtonAction:(UIButton *)bt{

    NSLog(@"%@",bt.titleLabel.text);
    
    bt.selected = YES;
    
    UIButton * fourButton_one =  self.articleRankFourButtonArray[0];
    
    [fourButton_one setTitle:bt.titleLabel.text forState:UIControlStateNormal];
    
    
    NSInteger currentIndex = bt.tag - 4200;
    
    self.currentArticleRank_cid = self.channel_cid[currentIndex];
    
    
    NSLog(@"%@",self.currentArticleRank_cid);
    
    for (UIButton * button in self.buttonSaveArray) {
        
        if (bt.tag == button.tag) {
            
            
        }else{
        
            button.selected = NO;
            
            
        }
        
    }
    
    
    self.isShowListView = NO;
    [self.channelListView removeFromSuperview];
    self.isArticleRank = YES;
    self.isUserRank = NO;
    
    [self.articleRankTableView.mj_header beginRefreshing];
    
    
}



#pragma mark- MJ
/**MJre*/
-(void)MJreloadData{

    
    NSString * type ;
    
    __weak RankVC * weakSelf = self;
    
    if (self.isArticleRank == YES ) {
        
        if (self.currentArticleRankType == articleRankType_redboll) {
            
            type = @"redboll";
            
        }else if (self.currentArticleRankType == articleRankType_week) {
            
            type = @"week";
            
        }else{
            type = @"all";
            
        }
        
        
        [self.net articleRankListGetDataWithType:type andPage:1 andC_id:self.currentArticleRank_cid];

        self.net.articleRankBK=^(NSString * code ,NSString * message,NSString * str,NSArray * dataArray,NSArray * data){
        
            weakSelf.articleDataArray = [NSMutableArray arrayWithArray:dataArray];
        
            NSLog(@"%@",dataArray);
            
            [weakSelf.articleRankTableView reloadData];
            
            
            [weakSelf.articleRankTableView.mj_header endRefreshing];
        };
        
        
    }
    
    
    if(self.isUserRank == YES){
    
        if (self.currentUserRankType == userRankType_read) {
            
            type = @"read";
            
        }else if (self.currentUserRankType == userRankType_share) {
            
            type = @"share";
            
        }else{
            type = @"money";
            
        }
        
        
        [self.net userRankListGetFromNetWithType:type andTime:self.currentUserRankTime andPage:1];
        
        self.net.userRankBK=^(NSString * code,NSString * message,NSString * str,NSArray * dataArray,NSArray * data){
            
            weakSelf.userDataArray = [NSMutableArray arrayWithArray:dataArray];
            
            [weakSelf.userRankTableView reloadData];
            
            [weakSelf.userRankTableView.mj_header endRefreshing];

            NSLog(@"%@",dataArray);
        };
    }
    
}


/**MJload*/
- (void)MJLoadDataMore{

    NSString * type ;
    
    __weak RankVC * weakSelf = self;
    
    if (self.isArticleRank == YES) {
        
        if (self.currentArticleRankType == articleRankType_redboll) {
            
            type = @"redboll";
            
        }else if (self.currentArticleRankType == articleRankType_week) {
            
            type = @"week";
            
        }else{
            type = @"all";
            
        }
        
        
        [self.net articleRankListGetDataWithType:type andPage:(self.currentArticleRankPage + 1) andC_id:self.currentArticleRank_cid];
        
        self.net.articleRankBK=^(NSString * code ,NSString * message,NSString * str,NSArray * dataArray,NSArray * data){
            
            [weakSelf.articleDataArray addObjectsFromArray:dataArray];
            
            NSLog(@"%@",dataArray);
            
            [weakSelf.articleRankTableView reloadData];
            
            
            [weakSelf.articleRankTableView.mj_footer endRefreshing];
        };
        
        
    }
    
    
    if(self.isUserRank == YES){
        
        if (self.currentUserRankType == userRankType_read) {
            
            type = @"read";
            
        }else if (self.currentUserRankType == userRankType_share) {
            
            type = @"share";
            
        }else{
            type = @"money";
            
        }
        
        
        [self.net userRankListGetFromNetWithType:type andTime:self.currentUserRankTime andPage:self.currentUserRankPage + 1];
        
        self.net.userRankBK=^(NSString * code,NSString * message,NSString * str,NSArray * dataArray,NSArray * data){
        
            [weakSelf.userDataArray addObjectsFromArray:dataArray];
            
            [weakSelf.userRankTableView reloadData];
    
            [weakSelf.userRankTableView.mj_footer endRefreshing];
            
            NSLog(@"%@",dataArray);

        };
        
    }

}



#pragma mark- navBarView
- (void)addNavBarViewNew{
    
    self.navigationBarView = [self NavBarViewNew];
    self.navigationBarView.backgroundColor = [UIColor whiteColor];
    
    [self navBarButtonNew];
    [self selectButtonLineNew];
}

#pragma mark- NavBarButton+Line
- (void)navBarButtonNew{

    NSArray * titles = @[@"爆文榜",@"用户榜"];
    for (int i = 0; i < 2; i++) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(ScreenWith * 3/10 + ScreenWith/5*i, 64-30-5, ScreenWith/5, 30);
        [button addTarget:self action:@selector(navBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateSelected];
        button.tag = 1001 + i;
        [self.navigationBarView addSubview:button];
        
        if (i == 0) {
            button.selected = YES;
        }
    }

}

- (void)navBarButtonAction:(UIButton *)bt{

    NSLog(@"%@",bt.titleLabel.text);
    bt.selected = YES;

    UIButton * bt1 = (UIButton *)[self.navigationBarView viewWithTag:1001];
    UIButton * bt2 = (UIButton *)[self.navigationBarView viewWithTag:1002];

    if (bt.tag == 1001) {
        
        self.isArticleRank = YES;
        self.isUserRank = NO;
        
        bt2.selected = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.SelectButtonline.frame = CGRectMake(ScreenWith * 3/10, 64-3, ScreenWith/5, 3);
        }];
        
        self.tableScrollView.contentOffset = CGPointMake(0, 0);
        
        
        if (self.isShowUserListView) {
            
            self.isShowUserListView = NO;
            [self.userListView removeFromSuperview];
        }

        
        
    }else {
        
        self.isArticleRank = NO;
        self.isUserRank = YES;
        
        bt1.selected = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.SelectButtonline.frame = CGRectMake(ScreenWith * 3/10 + ScreenWith/5, 64-3, ScreenWith/5, 3);

        }];
        
        self.tableScrollView.contentOffset = CGPointMake(ScreenWith, 0);

        
        if (self.isShowListView) {
            
            self.isShowListView = NO;
            [self.channelListView removeFromSuperview];
        }
        
        
    }
    
    
    
}

- (void)selectButtonLineNew{

    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(ScreenWith * 3/10, 64-3, ScreenWith/5, 3)];
    line.layer.cornerRadius = 1.0;
    line.clipsToBounds = YES;
    line.backgroundColor = [UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0];
    [self.navigationBarView addSubview:line];
    self.SelectButtonline = line;
}


#pragma maek- tableScrollView
- (void)tableScrollViewNew{

    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, ScreenWith, ScreenHeight - 49 - 64)];
    scrollView.scrollEnabled = NO;
    scrollView.contentSize = CGSizeMake(ScreenWith * 2, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    self.tableScrollView = scrollView;
    [self.view addSubview:scrollView];
//    scrollView.backgroundColor = [UIColor redColor];
}


#pragma mark- fourButton
- (void)fourButtonNew{

    UIView * bgView0 = [self fourButtonBackGroundViewNew];
    UIView * bgView1 = [self fourButtonBackGroundViewNew];

    [self addArticleRankFourButtonNew:bgView0 andFrame:CGRectMake(0, 0, ScreenWith, ScreenWith/10)];
    [self addUserRankleFourButtonNew:bgView1 andFrame:CGRectMake(ScreenWith, 0, ScreenWith, ScreenWith/10)];
}

- (UIView *)fourButtonBackGroundViewNew{
    UIView * bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0];
    return bgView;
}

- (void)addArticleRankFourButtonNew:(UIView *)bgView andFrame:(CGRect)fram{
    bgView.frame = fram;
    [self.tableScrollView addSubview:bgView];
    
    NSArray * title = @[@"推荐",@"蹿红",@"七天",@"总榜"];
    [self addButton:bgView andTitle:title andTag:1000 andSEL:@selector(articleRankFourButtonAction:)];
    
}

- (void)addUserRankleFourButtonNew:(UIView *)bgView andFrame:(CGRect)fram{
    bgView.frame = fram;
    [self.tableScrollView addSubview:bgView];
    
    NSArray * title = @[@"今日",@"分享榜",@"阅读榜",@"总榜"];
    [self addButton:bgView andTitle:title andTag:2000 andSEL:@selector(userRankFourButtonAction:)];

    
}

- (void)addButton:(UIView *)bgView andTitle:(NSArray *)title andTag:(NSInteger)tag andSEL:(SEL)buttonSelector{

    NSMutableArray * array = [NSMutableArray new];
    
    for (int i = 0; i < 4; i++) {
        UIButton * Bt = [UIButton buttonWithType:UIButtonTypeCustom];
        Bt.frame = CGRectMake(i * ScreenWith/4, 0, ScreenWith/4, ScreenWith/10);
        Bt.tag = tag + i;
        [Bt setTitle:title[i] forState:UIControlStateNormal];
        [Bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [Bt setTitleColor:[UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateSelected];
        Bt.titleLabel.font = [UIFont systemFontOfSize:15];
        [Bt addTarget:self action:buttonSelector forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:Bt];
        
        if (i != 3) {
            [self addline:Bt andBgView:bgView];
        }
        
        [array addObject:Bt];
        
        if (i == 1) {
            Bt.selected = YES;
        }
        
        
        if (i == 0) {
            UIImageView * imagev = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sanjiao"]];
            imagev.frame = CGRectMake(ScreenWith/4 - 15, ScreenWith/10 - 15, 10, 10);
            [Bt addSubview:imagev];
        }
        
        
        if (Bt.tag == 2003) {
            self.incomeRankButton = Bt;
        }
        
        
        
    }
    
    
    if (tag == 1000) {
        self.articleRankFourButtonArray = [NSArray arrayWithArray:array];
    }else{
        self.userRankFourButtonArray = [NSArray arrayWithArray:array];

    }
    
}


- (void)addline:(UIButton *)bt andBgView:(UIView *)bgView{
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bt.frame) - 1, 8, 1, ScreenWith/10 - 16)];
    line.backgroundColor = [UIColor redColor];
    [bgView addSubview:line];
}

#pragma mark- 爆文榜Button
- (void)articleRankFourButtonAction:(UIButton *)bt{
    NSLog(@"%@",bt.titleLabel.text);
    NSLog(@"%ld",bt.tag);

    
    [self buttonSelect:bt andButtonArray:self.articleRankFourButtonArray];
    
    if (bt.tag == 1000) {
        NSLog(@"%@",bt.titleLabel.text);

        self.currentArticleRankType = articleRankType_redboll;
        
        if (self.channelListView == nil) {
            
            [self channelListViewNew];
        }
        
        if (self.isShowListView == NO) {
            
            
            self.channelListView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 0.0000001);
            
            [UIView animateWithDuration:0.3 animations:^{
                
                self.channelListView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);

            }];
            
            
            
            [self.view addSubview:self.channelListView];
            
            self.isShowListView = YES;
            
        }else{
            
            self.isShowListView = NO;
            [self.channelListView removeFromSuperview];
        }
        
        

    }else if (bt.tag == 1001){
        NSLog(@"%@",bt.titleLabel.text);

        self.currentArticleRankType = articleRankType_redboll;

    }else if (bt.tag == 1002){
        NSLog(@"%@",bt.titleLabel.text);
        self.currentArticleRankType = articleRankType_week;

    }
    else if (bt.tag == 1003){
        NSLog(@"%@",bt.titleLabel.text);
        self.currentArticleRankType = articleRankType_all;

    }

    if (bt.tag != 1000) {
        
        [self.articleRankTableView.mj_header beginRefreshing];
    
    }
}

#pragma mark- 用户榜Button
- (void)userRankFourButtonAction:(UIButton *)bt{
    NSLog(@"%@",bt.titleLabel.text);
    
    [self buttonSelect:bt andButtonArray:self.userRankFourButtonArray];
    
    NSLog(@"%ld",bt.tag);

    
    if (bt.tag == 2000) {
        
        
        
        if (self.userListView == nil) {
        
            [self userListViewNew];
            self.isShowUserListView = YES;
            [self.view addSubview:self.userListView];
        
        }else if (self.isShowUserListView == YES){
        
            self.isShowUserListView = NO;
            [self.userListView removeFromSuperview];
        
        }else{
        
            self.isShowUserListView = YES;
        
            [self.view addSubview:self.userListView];
        }
        
        
    }else if (bt.tag == 2001){
    
        self.currentUserRankType = userRankType_share;

        if (self.isShowUserListView == YES) {
            
            self.isShowUserListView = NO;
            
            [self.userListView removeFromSuperview];
        }
    
    }else if (bt.tag == 2002){
        
        self.currentUserRankType = userRankType_read;

        
    
        if (self.isShowUserListView == YES) {
            self.isShowUserListView = NO;

            [self.userListView removeFromSuperview];
        }
        
    }else{
    
        self.currentUserRankType = userRankType_money;

        if (self.isShowUserListView == YES) {
            self.isShowUserListView = NO;
            [self.userListView removeFromSuperview];
        }
    
    }
    
    
    if (bt.tag != 2000) {
       [self.userRankTableView.mj_header beginRefreshing];
    }
    
}

- (void)buttonSelect:(UIButton *)bt andButtonArray:(NSArray *)btArray{

    for (UIButton * button in btArray) {
        
        if (bt.tag == 2000 || bt.tag == 1000) {
            
        }else if(button.tag == bt.tag){
            
            button.selected = YES;
            
            if (bt.tag > 1000) {
                
                if (bt.tag == 1001) {
                    self.currentArticleRankType = articleRankType_redboll;
                    
                }else if (bt.tag == 1002){
                    self.currentArticleRankType = articleRankType_week;

                
                }else{
                    self.currentArticleRankType = articleRankType_all;

                }
                
                
            }else if (bt.tag > 2000){
            
                if (bt.tag == 2001) {
                    
                    self.currentUserRankType = userRankType_share;
                    
                }else if (bt.tag == 2002){
                    
                    self.currentUserRankType = userRankType_read;

                }else{
                    self.currentUserRankType = userRankType_money;

                }

            
            }
            
            
            
        }else{
            button.selected = NO;
            
        }
    }

}


#pragma mark- tableView + delegate
- (void)tableViewNew{

    [self addTableViewNew];
}

- (void)addTableViewNew{
    
    for (int i = 0; i < 2; i++) {
    
        UITableView * tableview = [[UITableView alloc]initWithFrame:CGRectMake(ScreenWith * i, ScreenWith/10, ScreenWith, ScreenHeight -49 - 64 - ScreenWith/10) style:UITableViewStylePlain];
        tableview.showsVerticalScrollIndicator = NO;
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.tag = 3000 + i;
        tableview.tableFooterView = [[UIView alloc]init];
        
        if (i == 0) {
        
            self.isArticleRank = YES;
            
            self.articleRankTableView = tableview;
            
//            tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJreloadData)];
            
            
            MJRefreshNormalHeader * MJ_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJreloadData)];
            
            MJ_header.stateLabel.textColor =[UIColor colorWithRed:0.0 green:207.0/255.0 blue:1.0 alpha:1.0];
            
            MJ_header.lastUpdatedTimeLabel.textColor = [UIColor colorWithRed:0.0 green:207.0/255.0 blue:1.0 alpha:1.0];
            
            tableview.mj_header = MJ_header;
            
            
            tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJLoadDataMore)];
            
            [tableview.mj_header beginRefreshing];
            
            
            
        }else{
            
            self.isUserRank = YES;
            self.userRankTableView = tableview;
//            tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJreloadData)];
            
            MJRefreshNormalHeader * MJ_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJreloadData)];
            
            MJ_header.stateLabel.textColor =[UIColor colorWithRed:0.0 green:207.0/255.0 blue:1.0 alpha:1.0];
            
            MJ_header.lastUpdatedTimeLabel.textColor = [UIColor colorWithRed:0.0 green:207.0/255.0 blue:1.0 alpha:1.0];
            
            tableview.mj_header = MJ_header;
            
            tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJLoadDataMore)];
            
            [tableview.mj_header beginRefreshing];
            
        }
        
        
        
            tableview.rowHeight = ScreenWith/4 + 20;
//            tableview.rowHeight = ScreenWith/5;

        [self.tableScrollView addSubview:tableview];
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"select:%ld",indexPath.row);
    
    if (tableView.tag == 3000) {
    
        ArticleListModel * model = self.articleDataArray[indexPath.row];
        
        WKWebViewController * wk = [[WKWebViewController alloc]init];
        wk.article_id = [NSString stringWithFormat:@"%d",model.id];
        wk.isPost = NO;
        wk.isVideo = NO;
        wk.articleModel = model;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wk animated:YES];
        self.hidesBottomBarWhenPushed = NO;

    }else{
    
        UserRankModel * model = self.userDataArray[indexPath.row];
    
        PersonHomeVC * vc = [[PersonHomeVC alloc]init];
        vc.hidenIs = self.hidenIs;
        vc.uid = model.uid;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView.tag == 3000) {
        
        ArticleRankCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil) {
            
            cell =[[ArticleRankCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        
        ArticleListModel * model = self.articleDataArray[indexPath.row];
        
        cell.model = model;
        
        cell.numberRankLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
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
        
        
        return cell;
    }else{
    
        UserRankCell * cell = [tableView dequeueReusableCellWithIdentifier:@"user"];
        if (cell == nil) {
            
            cell = [[UserRankCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"user"];
        }
        
        cell.numberRankLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
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
        
        [cell setDataWithModel:model andType:self.currentUserRankType andHidenReview:self.hidenIs];
        
        return cell;
    }
   
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    
    
    if (tableView.tag == 3000) {
        
        return self.articleDataArray.count;
    }
    else{
    
        return self.userDataArray.count;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 3001) {
        
        return ScreenWith/5;
    }else{
    
    
        return ScreenWith/4 + 20;
    }

}


//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//    if (self.isShowUserListView == YES && self.userListView){
//        
//        self.isShowUserListView = NO;
//        [self.userListView removeFromSuperview];
//        
//    }
//    
//}

@end
