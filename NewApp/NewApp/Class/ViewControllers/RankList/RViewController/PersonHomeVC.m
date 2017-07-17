//
//  PersonHomeVC.m
//  NewApp
//
//  Created by gxtc on 17/3/6.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "PersonHomeVC.h"

@interface PersonHomeVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;

/**数据源*/
@property (nonatomic,strong)NSMutableArray * shareDataArray;
@property (nonatomic,strong)NSMutableArray * collectionDataArray;
@property (nonatomic,strong)NSMutableArray * commentDataArray;
@property (nonatomic,strong)MemberModel * member;


//类型 share 分享 comment 评论 colletion 收藏
@property (nonatomic,copy)NSString * type;

/**110-分享 111-收藏 112-评论*/
@property (nonatomic,assign)NSInteger currentType;
@property (nonatomic,assign)NSInteger page;


/**tablHeadView数据*/
@property (nonatomic,strong)UIImageView * iconImage;
@property (nonatomic,strong)UILabel * phongLabel;
@property (nonatomic,strong)UIImageView * sex;
@property (nonatomic,strong)UILabel * LV;
@property (nonatomic,strong)UILabel * totalLabel;




@end

@implementation PersonHomeVC


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    self.currentType = 110;
    self.page = 1;
    self.type = @"share";
    
    self.shareDataArray = [NSMutableArray new];
    self.commentDataArray = [NSMutableArray new];
    self.collectionDataArray = [NSMutableArray new];

    
    [self addUI];
}

- (void)addUI{
    [super addUI];
    
    UIImageView * bg = [self bgImageViewNew];
    [self.view addSubview:bg];
    
    self.titleLabel.text = @"个人主页";
    [self tableViewNewWithHeadView:[self tableViewHeadViewNew]];
    
   
    
}


-(void)getDataFromNet{


    
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net personCenterDataGetFromNetWith:self.page andType:self.type andUid:self.uid];
    
    __weak PersonHomeVC * weakSelf = self;
    
    net.personHomeBK = ^(NSString * code,NSString * message,NSString * str,NSArray * dataArray,NSArray * data){
    
        
        if (data.count > 0 && data) {
            
            weakSelf.member = data[0];
            
            [weakSelf setMemberData:weakSelf.member];
        }
        
        if (weakSelf.currentType == 110) {
            
            if (weakSelf.page == 1) {
                self.shareDataArray = [NSMutableArray arrayWithArray:dataArray];

            }else{
            
                [self.shareDataArray addObjectsFromArray:dataArray];
            }
        
        }else if (weakSelf.currentType == 111){
            if (weakSelf.page == 1) {
                self.collectionDataArray = [NSMutableArray arrayWithArray:dataArray];
                
            }else{
                
                [self.collectionDataArray addObjectsFromArray:dataArray];
            }

        
        }else{
            if (weakSelf.page == 1) {
                
                self.commentDataArray = [NSMutableArray arrayWithArray:dataArray];
                
            }else{
                
                [self.commentDataArray addObjectsFromArray:dataArray];
            }

        }
    
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        [weakSelf.tableView reloadData];

    };
    
}


- (void)setMemberData:(MemberModel *)member{


    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:member.headimgurl] placeholderImage:[UIImage imageNamed:@"head_icon"]];
    self.phongLabel.text = member.nickname;

    if ([member.sex isEqualToString:@"1"]) {
    
        self.sex.image = [UIImage imageNamed:@"sex_male"];
    }else{
        self.sex.image = [UIImage imageNamed:@"sex_woman"];

    }
    
    self.LV.text = [NSString stringWithFormat:@"LV%@",member.level];
    
    NSString * share = [NSString stringWithFormat:@"%@",member.share_count];
    NSString * money = [NSString stringWithFormat:@"%@",member.sum_money];
    
    self.totalLabel.text = [NSString stringWithFormat:@"总分享:%@ | 总收入:%@",share,money];
    
}




#pragma mark- 下拉刷新
- (void)MJdataReload{
    
    self.page = 1;
    
    
    [self getDataFromNet];
}


#pragma mark- 上拉加载
- (void)MJdataLoadMore{
    
    self.page += 1;
    
    [self getDataFromNet];
}





- (UIImageView * )bgImageViewNew{


    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"launchImage.jpg"]];
    imageView.frame = CGRectMake(0, 64, ScreenWith, ScreenHeight-64);
    
    return imageView;
}


- (void)tableViewNewWithHeadView:(UIView *)headView{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenWith, ScreenHeight - 64 ) style:UITableViewStylePlain];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableHeaderView = headView;
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.backgroundColor = [UIColor whiteColor];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJdataReload)];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJdataLoadMore)];
    
    [tableView.mj_header beginRefreshing];
}


- (UIView *)tableViewHeadViewNew{

    UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenWith * 2/5 +10)];
    view.backgroundColor = [UIColor clearColor];
    view.image = [UIImage imageNamed:@"personhomepic.jpg"];
    
    
    UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith/5, ScreenWith/5)];
    icon.backgroundColor = [UIColor clearColor];
    icon.image = [UIImage imageNamed:@"head_icon"];
    icon.layer.cornerRadius = ScreenWith/10;
    icon.clipsToBounds = YES;
    icon.center = CGPointMake(ScreenWith/2, ScreenWith/10 + 10);
    [view addSubview:icon];
    
    
    UILabel * nameLabel = [self addRootLabelWithfram:CGRectMake(10, CGRectGetMaxY(icon.frame) + 10, ScreenWith/2 - 10, 20) andTitleColor:[UIColor whiteColor] andFont:17.0 andBackGroundColor:[UIColor clearColor] andTitle:@"***********"];
    [view addSubview:nameLabel];
    nameLabel.textAlignment = NSTextAlignmentRight;
    
    UIImageView * sexImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWith/2 + 10,CGRectGetMaxY(icon.frame) + 12, 16, 16)];
    sexImage.image =[ UIImage imageNamed:@"sex_male"];
    [view addSubview:sexImage];
    
    
    UILabel * level = [self addRootLabelWithfram:CGRectMake(CGRectGetMaxX(sexImage.frame )+10, CGRectGetMaxY(icon.frame) + 10, 50, 20) andTitleColor:[UIColor whiteColor] andFont:17.0 andBackGroundColor:[UIColor clearColor] andTitle:@"LV0"];
    
    [view addSubview:level];
    
    
    UILabel * shareAndMoney = [self addRootLabelWithfram:CGRectMake(0, CGRectGetMaxY(nameLabel.frame) + 10, ScreenWith, 20) andTitleColor:[UIColor whiteColor] andFont:17.0 andBackGroundColor:[UIColor clearColor] andTitle:@"总分享 ****  | 总收入 ******"];
    
    if (self.hidenIs == YES) {
        
        shareAndMoney.hidden = YES;
    }
    
    shareAndMoney.textAlignment = NSTextAlignmentCenter;
    [view addSubview:shareAndMoney];
    
    
    self.iconImage = icon;
    self.phongLabel = nameLabel;
    self.sex = sexImage;
    self.LV = level;
    self.totalLabel = shareAndMoney;
    
    
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    
    if (self.currentType == 110) {
        
        MineOneTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_one"];
        if (cell == nil) {
            
            cell = [[MineOneTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_one"];
            
        }

        if (self.shareDataArray.count > 0) {
            
            PersonCenterModel * model = self.shareDataArray[indexPath.row];
        
            cell.personModel = model;
        }
        
        return cell;

    }else if (self.currentType == 111){
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_two"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell_two"];
        }
        
        if (self.collectionDataArray.count > 0) {
            
            PersonCenterModel * model = self.collectionDataArray[indexPath.row];

            NSLog(@"%@",model);

            cell.textLabel.text = model.title;
            cell.detailTextLabel.text =[NSString stringWithFormat:@"阅读:%@",model.view_count];
        }
        return cell;


    }else{
        
        PersonCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_three"];
        
        if (cell == nil) {
            
            cell = [[PersonCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_three"];
        }

        if (self.commentDataArray.count > 0) {
    
            PersonCenterModel * model = self.commentDataArray[indexPath.row];

            cell.pModel = model;
        }
        return cell;

    }

    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (self.currentType == 110) {
        
        return ScreenWith/6;
    }else if (self.currentType == 111){
        
        return ScreenWith/6;
    }else{
        
        return ScreenWith/4 + 10;
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.currentType == 110) {
        
        return self.shareDataArray.count;
        
    }else if (self.currentType == 111){
    
        return self.collectionDataArray.count;
    }else{
    
        return self.commentDataArray.count;
        
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了%ld",indexPath.row);
    
    PersonCenterModel * model;
    
    if (self.currentType == 110) {
        
       model = self.shareDataArray[indexPath.row];

    }else if (self.currentType == 111){
        
        model = self.collectionDataArray[indexPath.row];
    }else{
    
        model = self.commentDataArray[indexPath.row];
    }

    
    if (self.currentType == 110 || self.currentType == 111) {
        
        ArticleListModel * articleModel = [[ArticleListModel alloc]init];
        articleModel.id = model.id;
        articleModel.title = model.title;
        articleModel.thumb = model.thumb;
        articleModel.url = model.url;
        
        WKWebViewController * wk = [[WKWebViewController alloc]init];
        wk.isPost = NO;
        wk.pModel = model;
        wk.article_id = [NSString stringWithFormat:@"%d",model.id];
        wk.urlString = model.url;
        wk.articleModel = articleModel;
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wk animated:YES];
        
    }else{
        
        ComentListVC * vc = [[ComentListVC alloc]init];
        vc.aid = model.aid;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
  
    
    
}



#pragma mark- 分组高度
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ScreenWith/9;//section头部高度
}


//section头部视图
- (UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, 1)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowOpacity = 0.7;
    
    UISegmentedControl * seg = [self addSegmentedControl];
    
    [view addSubview:seg];
    return view ;
}


#pragma mark- 选择器
- (UISegmentedControl *)addSegmentedControl{

    NSArray * titles = @[@"分享",@"收藏",@"评论"];
    
    UISegmentedControl * segment = [[UISegmentedControl alloc]initWithItems:titles];
    
    segment.frame = CGRectMake(10,(ScreenWith/9 - ScreenWith/13)/2,ScreenWith - 20, ScreenWith/13);
    
    
    
    if (self.currentType == 110) {
        
        segment.selectedSegmentIndex = 0;

        
    }else if(self.currentType == 111){
        
        segment.selectedSegmentIndex = 1;
        


    }else{
        segment.selectedSegmentIndex = 2;
        
    
    }
    
    
    
    
    segment.tintColor = [UIColor colorWithRed:0.0 green:217/255.0 blue:225.0/255.0 alpha:1.0];
    [segment addTarget:self action:@selector(segmentedSelect:) forControlEvents:UIControlEventValueChanged];
    return segment;
}


- (void)segmentedSelect:(UISegmentedControl *)segmented{
    
    NSInteger index = segmented.selectedSegmentIndex;
    
    
    if (index == 0) {
        NSLog(@"分享");
        self.type = @"share";

        self.currentType = 110;
        
        
        if (self.shareDataArray.count > 0) {
            
            [self.tableView reloadData];
        }else{
        
            [self.tableView.mj_header beginRefreshing];
        }
        
        
        
        
    }else if (index == 1){
        NSLog(@"收藏");
        self.currentType = 111;
        self.type = @"colletion";

        if (self.collectionDataArray.count > 0) {
            
            [self.tableView reloadData];
        }else{
            
            [self.tableView.mj_header beginRefreshing];
        }

    }else{
        NSLog(@"评论");
        self.currentType = 112;
        self.type = @"comment";

        if (self.commentDataArray.count > 0) {
            
            [self.tableView reloadData];
        }else{
            
            [self.tableView.mj_header beginRefreshing];
        }

    }
    
    
    
    
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
