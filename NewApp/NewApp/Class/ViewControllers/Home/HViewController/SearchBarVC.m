//
//  SearchBarVC.m
//  NewApp
//
//  Created by gxtc on 17/2/20.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "SearchBarVC.h"

@interface SearchBarVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)UISearchBar * searchBar;

@property(nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation SearchBarVC


- (void)viewWillAppear:(BOOL)animated{
    
    //self.navigationController.navigationBar.hidden = NO;
    
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataArray = [NSMutableArray new];
    [self addUI];
    
    
}



#pragma mark- 搜索框网络请求
- (void)searchBarResoultFromNetWithTitle:(NSString *)title{
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net articleSearchGetDataFromNetWithTitle:title];
    
    net.searchArticleDataBK=^(NSString * ceod ,NSString * message,NSString * s,NSArray * dataArray,NSArray * arr){
    
        NSLog(@"%@",dataArray);
    
        self.dataArray = [NSMutableArray arrayWithArray:dataArray];
        
        [self.tableView reloadData];
    };
}


- (void)addUI{
    
    self.navigationBarView = [self NavBarViewNew];
    self.navigationBarView.backgroundColor =[UIColor whiteColor];
    [self addLeftBarButtonNew];
    [self addLineNew];
    [self rightButtonNew];
    [self seaBarNew];
    
}


- (void)seaBarNew{

    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(ScreenWith/2 - ScreenWith*3/8, 22, ScreenWith*3/4, 40)];
    [self.navigationBarView addSubview:_searchBar];
    //  _searchBar.barTintColor = [UIColor colorWithRed:255/255.0 green:199/255.0 blue:58/255.0 alpha:1];
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    //去掉边框//==!!
    //    [_searchBar setBackgroundImage:[[UIImage alloc]init]];
    
    _searchBar.placeholder = @"输入关键词";
    _searchBar.delegate = self;
    [self tableView];

}

- (void)rightButtonNew{

    UIButton * bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(ScreenWith - ScreenWith/10 - 5, 27, ScreenWith/10, 30);
    bt.titleLabel.font = [UIFont systemFontOfSize:15];
    [bt setTitle:@"取消" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bt setTitleColor:[UIColor colorWithRed:18.0/255.0 green:139.0/255.0 blue:214.0/255.0 alpha:1] forState:UIControlStateNormal];
    [self.navigationBarView addSubview:bt];
}


- (void)rightButtonAction{
    NSLog(@"收回键盘");
    [_searchBar resignFirstResponder];

}

#pragma mark- searchaBarDelgate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSLog(@"正在搜索");
    
    [_searchBar resignFirstResponder];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    NSLog(@"编辑");
    
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSLog(@"输入改变-网络请求");
    [self searchBarResoultFromNetWithTitle:searchText];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    NSLog(@"收回键盘");
    [_searchBar resignFirstResponder];
    
}

//懒加载tableView
- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWith, ScreenHeight -64) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.rowHeight = ScreenWith/4 +20;
    }
    
    return _tableView;
    
}

#pragma mark- tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineOneTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        cell = [[MineOneTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
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
    
    [self.searchBar resignFirstResponder];
    
    ArticleListModel * model = self.dataArray[indexPath.row];

    WKWebViewController * vc = [[WKWebViewController alloc]init];
    
    vc.article_id = [NSString stringWithFormat:@"%d",model.id];
    vc.isPost = NO;
    vc.articleModel = model;
    vc.isVideo = NO;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self.searchBar resignFirstResponder];

}


@end
