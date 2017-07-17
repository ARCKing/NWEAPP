//
//  ExchangeCenterVC.m
//  聊天界面
//
//  Created by root on 17/3/12.
//  Copyright © 2017年 root. All rights reserved.
//

#import "ExchangeCenterVC.h"

#define Screen_W [UIScreen mainScreen].bounds.size.width
#define Screen_H [UIScreen mainScreen].bounds.size.height



@interface ExchangeCenterVC()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)ExchangeCenterCell * exchangeCell;

@property(nonatomic,strong)UICollectionView * collectionView;

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,strong)UIScrollView * scrollView;

@property(nonatomic,strong)NSTimer * timer;


/**userInfo*/
@property (nonatomic,copy)NSString * uid;
@property (nonatomic,copy)NSString * token;
@property (nonatomic,copy)NSString * isLogin;

@end

@implementation ExchangeCenterVC


- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [self stopTime];

}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self getTokenAndUid];
    
    [self addTimeNew];

}


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.view.backgroundColor =[ UIColor whiteColor];
    
    [self addUI];
    
    [self addCollectionViewCreatNew];
    
}


- (void)getTokenAndUid{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary * userInfo = [defaults objectForKey:@"userInfo"];
    
    self.uid = userInfo[@"uid"];
    self.token = userInfo[@"token"];
    self.isLogin = userInfo[@"login"];
}

- (void)addUI{

    [super addUI];
    
    self.titleLabel.text = @"兑换中心";

    [self addRightBarClearButtonNew:@"兑换记录"];
}


- (void)addCollectionViewCreatNew{

    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    //设置头尾部视图高度
    flowLayout.headerReferenceSize = CGSizeMake(0, 200);
    //    flowLayout.footerReferenceSize = CGSizeMake(0, 50);
    
    self.collectionView = [[UICollectionView alloc ]initWithFrame:CGRectMake(0, 64, Screen_W,Screen_H - 64) collectionViewLayout:flowLayout];
    
    //必须这样注册cell
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    
    //头部视图注册
    [self.collectionView registerClass:[UICollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCell"];

}


//个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 0;
    
}

//组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}



//cell内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ExchangeCenterCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    //复用问题解决方法
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (Screen_W - 15)/2, ((Screen_W - 15)/2)*2/3)];
    imageV.backgroundColor = [UIColor cyanColor];
    [cell addSubview:imageV];

    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame), (Screen_W - 15)/2, ((Screen_W - 15)/2)/6)];
    label1.textColor = [UIColor blackColor];
    label1.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    label1.backgroundColor = [UIColor orangeColor];
    label1.font = [UIFont systemFontOfSize:16.0];

    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame), (Screen_W - 15)/4, ((Screen_W - 15)/2)/6)];
    label2.textColor = [UIColor blackColor];
    label2.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    label2.backgroundColor = [UIColor purpleColor];
    label2.font = [UIFont systemFontOfSize:15.0];

    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake((Screen_W - 15)/4, CGRectGetMaxY(label1.frame), (Screen_W - 15)/4, ((Screen_W - 15)/2)/6)];
    label3.textColor = [UIColor blackColor];
    label3.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    label3.backgroundColor = [UIColor cyanColor];
    label3.textAlignment = NSTextAlignmentRight;
    label3.font = [UIFont systemFontOfSize:13.0];
    
    [cell addSubview:label1];
    [cell addSubview:label2];
    [cell addSubview:label3];

    
    return cell;
}


//每个collectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((Screen_W - 15)/2, (Screen_W - 15)/2);
    
}

//边界宽度
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
    
}


//最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
    
}

//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"=====-----------------=====================");
    
    if (![self.isLogin isEqualToString:@"1"]) {
        
        [self goToLogineVC];
        
        return;
    }
    
}



//跳转登录
- (void)goToLogineVC{
    
    LoginViewController * vc = [[LoginViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}



//添加头尾部视图的方法（无复用问题）
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCell" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor redColor];
        
        
        [headerView addSubview:[self addScrollViewNew]];
        [headerView addSubview:[self addButtonNew]];
        
        reusableview = headerView;
        
    }
    
    return reusableview;
}


- (UIView *)addScrollViewNew{


    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(-0.5, 0, Screen_W + 1, 50)];
    view.backgroundColor =[UIColor whiteColor];
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 0.5;
    
    UIImageView * imageV= [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    imageV.backgroundColor = [UIColor whiteColor];
    imageV.image = [UIImage imageNamed:@"laba"];
    [view addSubview:imageV];
    
    NSArray * phones = @[@"136****8355 成功兑换了 30元",
                         
                         @"138****7452 成功兑换了 30元",
                         @"159****2657 成功兑换了 30元",
                         @"182****6356 成功兑换了 30元",
                         @"138****7432 成功兑换了 30元",
                         @"139****4457 成功兑换了 30元",
                         @"186****8855 成功兑换了 30元",
                         @"138****7452 成功兑换了 30元",
                         @"159****2757 成功兑换了 30元",
                         @"187****4376 成功兑换了 30元",
                         @"158****8432 成功兑换了 30元",
                         
                         @"136****8355 成功兑换了 30元"
                         
                         ];
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(50, 0, Screen_W-50, 50)];
    self.scrollView = scrollView;
    scrollView.contentSize = CGSizeMake(0, 50 * 12);
    [view addSubview:scrollView];
    
    for (int i = 0; i< 12; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 50 *i, Screen_W - 50, 50)];
        label.text = phones[i];
        label.textColor = [UIColor redColor];
        label.backgroundColor = [UIColor clearColor];
        [scrollView addSubview:label];
    }
    
    
    return view;
}


- (void)addTimeNew{

    if (self.timer == nil) {
    
    NSTimer * time = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeScrollViewOfSet) userInfo:nil repeats:YES];
    
        [[NSRunLoop mainRunLoop] addTimer:time forMode:NSRunLoopCommonModes];
        self.timer = time;
    }

}


- (void)stopTime{

    [self.timer invalidate];
    self.timer = nil;

}


- (void)changeScrollViewOfSet{


    [UIView animateWithDuration:0.3 animations:^{
    
    
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentOffset.y + 50);
    
        
        
        
    }completion:^(BOOL finished) {
        
        if (self.scrollView.contentOffset.y == 50 * 11) {
            
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }
    }];
    

}



- (UIButton *)addButtonNew{

    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(withDrawAction) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor =[UIColor whiteColor];
    button.frame = CGRectMake(0, 50, Screen_W, 150);
    [button setImage:[UIImage imageNamed:@"bg_alipay.jpg"] forState:UIControlStateNormal];
    return button;
}



- (void)withDrawAction{

    NSLog(@"提现");
    
    
    if (![self.isLogin isEqualToString:@"1"]) {
        
        [self goToLogineVC];
        
        return;
    }

    
    AliPayWithDrawVC * vc = [[AliPayWithDrawVC alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)rightBarClearButtonAction{

    if (![self.isLogin isEqualToString:@"1"]) {
        
        [self goToLogineVC];
        
        return;
    }


    ExchangeRecordVC * vc = [[ExchangeRecordVC alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    

}


@end
