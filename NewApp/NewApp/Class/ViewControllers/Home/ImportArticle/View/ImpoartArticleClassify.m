//
//  ImpoartArticleClassify.m
//  NewApp
//
//  Created by gxtc on 2017/7/21.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "ImpoartArticleClassify.h"

#define bt_w (self.frame.size.width - 40.0)/5.0
#define bt_h ScreenWith/10.0

@interface ImpoartArticleClassify()

@property(nonatomic,strong)UIView * selected;

@end

@implementation ImpoartArticleClassify

- (instancetype)initWithFrame:(CGRect)frame{


    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
    }

    return self;
}


- (void)drawRect:(CGRect)rect{


    [self addUI];

}


- (void)addUI{


    for (NSInteger i = 0; i <self.titleArr.count;i++) {
        
        UIButton * bt = [self addViewRootButtonNewFram:CGRectMake((bt_w + 10) * (i%5), (bt_h + 10)*(i/5), bt_w, bt_h) andImageName:nil andTitle:self.titleArr[i] andBackGround:[UIColor whiteColor] andTitleColor:[UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:1.0 alpha:1.0] andFont:16.0 andCornerRadius:1.0];
        bt.tag = 10000+i;
        [bt addTarget:self action:@selector(selectBtAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt];
    }


}


- (UIView *)selected{
    if (!_selected) {
        
        _selected = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bt_w, bt_h)];
        _selected.backgroundColor = [UIColor clearColor];
        _selected.layer.borderWidth = 1.0;
        _selected.layer.borderColor = [UIColor colorWithRed:30.0/255.0 green:140.0/255.0 blue:1.0 alpha:1.0].CGColor;
        _selected.layer.cornerRadius = 3.0;
    }
    
    return _selected;
}

- (void)selectBtAction:(UIButton *)bt{

    NSLog(@"%ld",bt.tag);
    
    [bt addSubview:self.selected];
    
    self.selectBK(bt.tag - 10000);
    
}

@end
