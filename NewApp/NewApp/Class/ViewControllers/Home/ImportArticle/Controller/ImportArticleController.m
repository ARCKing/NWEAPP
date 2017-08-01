//
//  ImportArticleController.m
//  NewApp
//
//  Created by gxtc on 2017/7/21.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "ImportArticleController.h"

@interface ImportArticleController ()
@property (weak, nonatomic) IBOutlet UIButton *addLinkButton;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;
@property (strong,nonatomic) UIPasteboard * pasteboard;

@property (weak, nonatomic) IBOutlet UILabel *chanceTitleLabel;

@property (nonatomic,strong) UIButton * importNowBt;


@property (nonatomic,copy)NSString * selectedClassifyChannel;
@property (nonatomic,copy)NSString * selectedClassifyC_id;
@property (nonatomic,copy)NSString * pastedLink;


@property (nonatomic,strong)NSMutableArray * channelTitle;
@property (nonatomic,strong)NSMutableArray * channelC_id;

@end

@implementation ImportArticleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.channelC_id = [NSMutableArray new];
    self.channelTitle = [NSMutableArray new];
    
    [self addUI];
    
    [self articleClassifyGetFromNet];
}


- (void)articleClassifyGetFromNet{

    NetWork * net = [NetWork shareNetWorkNew];

    [net getArticleChannelClassifyFromNet];

    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak ImportArticleController * weakSelf = self;
    
    net.articleClassifyBK = ^(NSString *code, NSString *message, NSString *srt, NSArray *data1, NSArray *data2) {
        
        
        [hud hideAnimated:YES];
        
        NSLog(@"%@",data1);
        
        for (ArticleClassifyModel * model in data1) {
            
            NSInteger c_id = [model.c_id integerValue];

            if (c_id > 0 && c_id != 19) {
                
                [weakSelf.channelC_id addObject:model.c_id];
                [weakSelf.channelTitle addObject:model.title];
            }
    
        }
    
        [weakSelf.view addSubview:weakSelf.articleClassfy];
        
        [weakSelf.view addSubview:weakSelf.importNowBt];
        
    };
}



- (void)addUI{

    self.addLinkButton.layer.borderWidth = 1.0;
    self.addLinkButton.layer.borderColor = [UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    
}

-(ImpoartArticleClassify *)articleClassfy{

    if (!_articleClassfy) {
        
        
//        NSArray * titarr = @[@"社会",@"军事",@"推荐",@"最新",@"星座",@"两性",@"娱乐",@"社会",@"军事",@"推荐",@"最新",@"星座",@"两性",@"娱乐"];
        
        NSInteger lineNum = self.channelTitle.count/5;
        
        NSInteger num = self.channelTitle.count%5;
        
        if (num!= 0) {
            
            num = 1;
        }
        
        lineNum = lineNum + num;
        
        
        
        _articleClassfy = [[ImpoartArticleClassify alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(self.chanceTitleLabel.frame)+5   , ScreenWith - 20, lineNum * ScreenWith/10 + (lineNum-1)*10)];
        
        _articleClassfy.titleArr = self.channelTitle;
        
        __weak ImportArticleController * weakSelf = self;
        
        _articleClassfy.selectBK = ^(NSInteger index) {
        
            weakSelf.selectedClassifyChannel = weakSelf.channelTitle[index];
            weakSelf.selectedClassifyC_id = weakSelf.channelC_id[index];
        };
        
        
    }
    return _articleClassfy;
}


- (IBAction)addLinkButtonAction:(id)sender {
    
    NSString * link = self.pasteboard.string;
    
    self.linkLabel.text = link;
    
    self.pastedLink = link;
}


- (UIButton *)importNowBt{

    if (!_importNowBt) {
        
        _importNowBt = [self addRootButtonTypeTwoNewFram:CGRectMake(30, CGRectGetMaxY(self.articleClassfy.frame) + ScreenWith/15, ScreenWith - 60, ScreenWith/10) andImageName:nil andTitle:@"马上导入" andBackGround:[UIColor whiteColor] andTitleColor:[UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:1.0 alpha:1.0] andFont:17.0 andCornerRadius:1.0];
        _importNowBt.layer.borderWidth = 1.0;
        _importNowBt.layer.borderColor = [UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:1.0 alpha:1.0].CGColor;
        
        [_importNowBt addTarget:self action:@selector(importArticleNowAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _importNowBt;
}


- (void)importArticleNowAction{


    NSLog(@"importArticleNowAction Link=--%@-- title=--%@-- c_id=%@",self.pastedLink,self.selectedClassifyChannel,self.selectedClassifyC_id);

    
    [self importArticleWithLink:self.pastedLink andc_id:self.selectedClassifyC_id];
    
    
    
}


#pragma mark- 导入链接
- (void)importArticleWithLink:(NSString *)link andc_id:(NSString *)c_id{

    NetWork * net = [NetWork shareNetWorkNew];
    
    [net customerImportArticleURL:link andc_id:c_id];
    
    __weak ImportArticleController * weakSelf = self;
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    net.importArticleLinkBK = ^(NSString *code, NSString *message) {
        
        [hud hideAnimated:YES];
        
        NSLog(@"%@,%@",code,message);
        
        [weakSelf rootShowMBPhudWith:message andShowTime:2.0];
        
        [weakSelf performSelector:@selector(succeedImportArticle) withObject:nil afterDelay:2.5];
    };
    
    
    
}


- (void)succeedImportArticle{

    [self.navigationController popViewControllerAnimated:YES];

}


- (UIPasteboard *)pasteboard{

    if (!_pasteboard) {
        
        _pasteboard = [UIPasteboard generalPasteboard];
        
    }
    return _pasteboard;
}


- (IBAction)popBackButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)rightButtonAction:(id)sender {
}


@end
