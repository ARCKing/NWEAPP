//
//  AddressVC.m
//  NewApp
//
//  Created by gxtc on 17/2/21.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "AddressVC.h"

@interface AddressVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tebleView;
@end

@implementation AddressVC


- (void)viewWillAppear:(BOOL)animated{


    NetWork * net = [NetWork shareNetWorkNew];
    
    [net mineDetailDataFromNet];
    
    __weak AddressVC * weakSelf = self;
    
    net.MineDetailDataBK=^(NSString * code,NSString * message,NSString * str,NSArray * dataArray,NSArray * data){
        
        if ([code isEqualToString:@"1"]) {
            
            if (dataArray.count > 0) {
                
                weakSelf.model = dataArray[0];
                
            }
            
            
            if (weakSelf.model) {
                
                
                [weakSelf.tebleView reloadData];
                
            }
        }
    };

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addUI];
    
}

- (void)addUI{
    
    
    [self addNavBarNew];
    [self addTableViewNew];
}



- (void)addNavBarNew{
    
    self.navigationBarView = [self NavBarViewNew];
    self.navigationBarView.backgroundColor =[UIColor whiteColor];
    [self addTitleLabelNew];
    [self addLeftBarButtonNew];
    self.titleLabel.text = @"我的地址";
    [self addLineNew];
    
}


- (void)addTableViewNew{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWith, ScreenHeight-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = ScreenWith/6;
    tableView.tableFooterView = [[UIView alloc]init];
    
    
    self.tebleView = tableView;
    
    [self.view addSubview:tableView];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EditiAddressVC * vc = [[EditiAddressVC alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
    }
    
    NSString * name_phone = [NSString stringWithFormat:@"%@ %@",self.model.name,self.model.rephone];
    NSString * address = [NSString stringWithFormat:@"%@ %@",self.model.region,self.model.address_address];
    
    cell.textLabel.text = name_phone;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.text = address;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

@end
