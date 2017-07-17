//
//  buttonOrderView.m
//  buttonAnimiation
//
//  Created by gxtc on 16/9/21.
//  Copyright © 2016年 gxtc. All rights reserved.
//

#import "buttonOrderView.h"



#define img_Name @"comm_icon_delete.png"

#define Screen_W [UIScreen mainScreen].bounds.size.width
#define Screen_H [UIScreen mainScreen].bounds.size.height

#define button_w Screen_W / 7
#define button_h Screen_W / 13

@interface buttonOrderView ()<UIGestureRecognizerDelegate>


@property (nonatomic,strong)UIView * lineView;

@property (nonatomic,strong)UIButton * upLastBt;
@property (nonatomic,strong)UIButton * downLastBt;


@property (nonatomic,strong)NSMutableArray * PointNewArray;


@property (nonatomic,strong)UIPanGestureRecognizer * panGesture;
@property (nonatomic,strong)UIPanGestureRecognizer * currentSelectPan;


@property (nonatomic,assign)CGPoint oldCenter;

@property (nonatomic,assign)NSInteger a;
@property (nonatomic,assign)NSInteger b;
@property (nonatomic,assign)NSInteger c;
@property (nonatomic,assign)int temp_i;


@property (nonatomic,strong)NSMutableArray * centArray;

@property (nonatomic,assign)BOOL isOrder;

//存频道model
@property (nonatomic,strong)NSMutableArray * selectArr;
@property (nonatomic,strong)NSMutableArray * unSelectArr;

@property (nonatomic,assign)NSInteger fistBtTag;



//存手势
@property (nonatomic,strong)NSMutableArray * panGuestArray;

@end


@implementation buttonOrderView



#pragma mark- 获取选中频道
- (void)checkSelectArticleCharnels{


    CoreDataManger * CDManger = [CoreDataManger shareCoreDataManger];

    self.selectArr = [NSMutableArray arrayWithArray: [CDManger checkSelectArticleCharnel]];

    self.unSelectArr = [NSMutableArray arrayWithArray:[CDManger checkUnSelectArticleCharnel]];
    
}



//选中的频道
- (NSArray *)selTitle{

    NSMutableArray * arr = [[NSMutableArray alloc]init];
    
    for (ArticleClassifyModel * model in self.selectArr) {
        
        NSString * title = model.title;
        
        [arr addObject:title];
    }
    
    
    return arr;
}


//未选中的频道
- (NSArray *)unSelTitle{
    
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    
    for (ArticleClassifyModel * model in self.unSelectArr) {
        
        NSString * title = model.title;
        
        [arr addObject:title];
    }
    

    
    
    return arr;

}


//选中的频道下标
- (NSArray *)selTitleC_id{
    
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    
    for (ArticleClassifyModel * model in self.selectArr) {
        
        NSString * c_id = model.c_id;
        
        [arr addObject:c_id];
    }
    

    
    
    return arr;

}


//未选中的频道下标
- (NSArray *)unSelTitleC_id{
    
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    
    for (ArticleClassifyModel * model in self.unSelectArr) {
        
        NSString * c_id = model.c_id;
        
        [arr addObject:c_id];
    }
    

    
    return arr;
}


- (instancetype)initWithFrame:(CGRect)frame{
    
    
    NSInteger device = CurrentDeviceScreen;
    
    NSInteger fontSize = 16;
    
    if (device == 0) {
        
        fontSize = 12;
    }
    
    
    self.panGuestArray  = [NSMutableArray new];
    
    [self checkSelectArticleCharnels];
    
    NSArray * arr1 = [self selTitle];
    NSArray * arr2 = [self unSelTitle];
    
    NSArray * numb1 = [self selTitleC_id];
    NSArray * numb2 = [self unSelTitleC_id];

    self.backgroundColor = [UIColor redColor];
    
    NSArray * array1 ;
    NSArray * array2 ;

    array1 = [NSArray arrayWithArray:arr1];
    array2 = [NSArray arrayWithArray:arr2];
        
    
    _PointNewArray = [NSMutableArray new];
    
    _selectArray = [NSMutableArray new];
    
    _unSelectArray = [NSMutableArray new];
    
    _centArray = [NSMutableArray new];
    
    
    if (self = [super initWithFrame:frame]) {
        
        for (int i = 0; i < array1.count ; i++) {
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:array1[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:105/255.0 green:105/255.0 blue:105/255.0 alpha:1] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
            button.layer.borderColor = [UIColor blackColor].CGColor;
            button.layer.borderWidth = 0.5;
            button.layer.cornerRadius = 5;
            
            
            if(i == 0){
            
                [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                button.layer.borderColor = [UIColor orangeColor].CGColor;
                button.enabled = NO;
            }
            
            
            button.tag = 2200 + [numb1[i] integerValue];
            
            button.frame = CGRectMake(0, 0, button_w,button_h);
            CGPoint btcenter = CGPointMake( (Screen_W - button_w * 4)/5 + button_w/2  + ( button_w + (Screen_W - button_w * 4)/5)* (i % 4), 44 + ( button_h * 2) * (i /4));
            
            button.center = btcenter;
            
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [_selectArray addObject:button];
            
            
            //NSValue <- CGPoint
            NSValue * centValue =  [NSValue valueWithCGPoint:btcenter];
            
            [_centArray addObject:centValue];
            
            
            //NSValue -> CGPoint
//            NSValue * val = _centArray[0];
//            CGPoint poi = [val CGPointValue];
            
            
        }
        
        UIButton * lastBt = [_selectArray lastObject];
        
        NSLog(@"%@",lastBt.titleLabel.text);
        
        self.lineView = [[UIView alloc]init];
        self.lineView.frame = CGRectMake( 0,0,Screen_W, Screen_W/14);
        self.lineView.center = CGPointMake(Screen_W/2, CGRectGetMaxY(lastBt.frame) + Screen_W/14);
        
        self.lineView.backgroundColor = [UIColor colorWithRed:0.0 green:207.0/255.0 blue:1.0 alpha:1.0];
        [self addSubview:_lineView];
        
        
        self.lineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.lineButton.backgroundColor = [UIColor clearColor];
        [self.lineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.lineButton setTitle:@"完成" forState:UIControlStateNormal];
        self.lineButton.frame = CGRectMake(0, 0, button_w - 5, button_h - 5);
        self.lineButton.center = CGPointMake(_lineView.frame.size.width - button_w/2 - 20, _lineView.frame.size.height/2);
        self.lineButton.titleLabel.font = [UIFont systemFontOfSize:13];
        self.lineButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.lineButton.layer.borderWidth = 1;
        self.lineButton.layer.cornerRadius = 3.0;
        [self.lineView addSubview:_lineButton];
//        [self.lineButton addTarget:self action:@selector(lineButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_W/3, Screen_W/14)];
        lineLabel.center = CGPointMake(Screen_W/6 , Screen_W/28);
        lineLabel.text = @"点击添加频道";
        lineLabel.textColor =[ UIColor whiteColor];
        lineLabel.font = [UIFont systemFontOfSize:14];
        lineLabel.textAlignment = NSTextAlignmentCenter;
        [self.lineView addSubview:lineLabel];
        
        
        for (int i = 0; i < array2.count ; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:array2[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:105/255.0 green:105/255.0 blue:105/255.0 alpha:1] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
            button.layer.borderColor = [UIColor blackColor].CGColor;
            button.layer.borderWidth = 0.5;
            button.layer.cornerRadius = 5;

            button.frame = CGRectMake(0, 0, button_w,button_h);
            
            button.center = CGPointMake( (Screen_W - button_w * 4)/5 + button_w/2  + ( button_w + (Screen_W - button_w * 4)/5)* (i % 4), CGRectGetMaxY(_lineView.frame)  + button_h + ( button_h * 2) * (i /4));
            
            [self addSubview:button];
            
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
            button.tag = 1100 + [numb2[i] integerValue];
            
            [_unSelectArray addObject:button];
        }
    }
    
    
    self.addPanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addPanButton.frame = CGRectMake(0, 0, Screen_W, 30);
    self.addPanButton.center = CGPointMake(Screen_W /2,Screen_H - 64 - 49 - 30);
    self.addPanButton.backgroundColor = [UIColor clearColor];
//    [_addPanButton setTitle:@"添加手势" forState:UIControlStateNormal];
    [self.addPanButton addTarget:self action:@selector(addGest) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addPanButton];
    
    
    return self;
}

#pragma mark- 添加拖拽手势
- (void)addGest{
    NSLog(@"添加手势!");
    
    self.isOrder = YES;
    
    for (UIButton * bt in _selectArray) {
        
        if ([bt.titleLabel.text isEqualToString:@"推荐"] ) {
            continue;
        }
        
        UIImageView * xx_img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:img_Name]];
        xx_img.tag = bt.tag + 1000;
        xx_img.frame = CGRectMake(0, 0, 15, 15);
        xx_img.center = CGPointMake(0, 0);
        [bt addSubview:xx_img];
        
     UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMove:)];
        
        panGesture.delegate = self;
        [panGesture addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
        
        [bt addGestureRecognizer:panGesture];
        
        
        [self.panGuestArray addObject:panGesture];

    }
}




#pragma mark- 单独给一个按钮添加拖拽手势
- (void)singleButtonPanAdd:(UIButton *)bt{

    
    UIImageView * xx_img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:img_Name]];
    xx_img.tag = bt.tag + 2100;
    
    NSLog(@"%ld",xx_img.tag);
    
    xx_img.frame = CGRectMake(0, 0, 15, 15);
    xx_img.center = CGPointMake(0, 0);
    [bt addSubview:xx_img];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMove:)];
    panGesture.delegate = self;
    [panGesture addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    
    [bt addGestureRecognizer:panGesture];

    [self.panGuestArray addObject:panGesture];
    
    
//    [bt addGestureRecognizer:self.currentSelectPan];
}



- (void)dealloc{

    if (self.panGuestArray.count > 0) {
        
        for (UIPanGestureRecognizer * pan in self.panGuestArray) {
            
            [pan removeObserver:self forKeyPath:@"state"];
        }
        
    }
    
}




//监听手势拖动
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    UIButton * bt = (UIButton *)_panGesture.view;
    
    if (_panGesture.state == UIGestureRecognizerStateEnded) {
        
        NSLog(@"拖动结束!");
        

        NSLog(@"%@",bt.titleLabel.text);
        
        [bt removeGestureRecognizer:_panGesture];
        
        
        [UIView animateWithDuration:0.2 animations:^{
            
            bt.center = _oldCenter;
        }];
        
        [self performSelector:@selector(addPanAgain:) withObject:bt afterDelay:0.2];
    }
    
}




//重新添加手势
- (void)addPanAgain:(UIButton *)bt{
    
    [bt addGestureRecognizer:_panGesture];
    
}




#pragma mark- 手势拖动事件
- (void)panMove:(UIPanGestureRecognizer *)pan{

    UIButton * bt = (UIButton *)pan.view;
    
    //计算要交换的坐标
    [self selectButtonRank:bt];
    
    _panGesture = pan;
    
    // 获取相对于self.view的坐标位置
    CGPoint point = [pan locationInView:self];
    
    // 改变视图具体的位置
    pan.view.center = point;
}


#pragma mark-手势将要移动
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{

    UIButton * bt = (UIButton *)gestureRecognizer.view;

    if (bt.tag < 2000) {

        return NO;
    }
    
    
    NSLog(@"动了");
    _oldCenter = gestureRecognizer.view.center;
    
    return YES;

}


- (void)lineButtonAction{

    NSLog(@"完成!");

}

#pragma mark- 加减频道
- (void)buttonAction:(UIButton *)bt{
    
    NSLog(@"[[%@]]",bt.titleLabel.text);
    
    if ([bt.titleLabel.text isEqualToString:@"热门"]) {
        
        return;
    }
    
    //取消频道
    if (bt.tag > 2000) {
       
        
        //如果是排序状态
        if (self.isOrder) {

            UIImageView * xx_img = (UIImageView *)[bt viewWithTag:bt.tag + 1000];
            
            NSLog(@"%ld",xx_img.tag);

            [xx_img removeFromSuperview];
        }
        
        [_selectArray removeObject:bt];
        
        
        NSInteger index = bt.tag - 2200;
        bt.tag = 1100 + index;
        
        [_unSelectArray addObject:bt];
        
        
                NSInteger i = (NSInteger)_selectArray.count - 1;
            
                CGPoint newPoint = CGPointMake( (Screen_W - button_w * 4)/5 + button_w/2  + ( button_w + (Screen_W - button_w * 4)/5)* (i % 4), 44 + ( button_h * 2) * (i /4));
                
                UIButton * lastBt = [UIButton buttonWithType:UIButtonTypeCustom];
                lastBt.frame = CGRectMake(0, 0, button_w,button_h );
                lastBt.center = newPoint;
        
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.lineView.center = CGPointMake(Screen_W/2, CGRectGetMaxY(lastBt.frame) + Screen_W/14);
                    
                }];
        
        
        for (int i = 0; i < _unSelectArray.count; i ++) {
            
            CGPoint newPoint = CGPointMake( (Screen_W - button_w * 4)/5 + button_w/2  + ( button_w + (Screen_W - button_w * 4)/5)* (i % 4), CGRectGetMaxY(_lineView.frame)  + button_h + ( button_h * 2) * (i /4));
            
            
            UIButton * bt = _unSelectArray[i];
            
            
            [self moveAnimation:bt.center andNewPoint:newPoint withButton:bt];
        
        }
     
        [_centArray removeAllObjects];
        
        for (int i = 0 ; i<_selectArray.count;i++) {
            
        CGPoint newPoint = CGPointMake( (Screen_W - button_w * 4)/5 + button_w/2  + ( button_w + (Screen_W - button_w * 4)/5)* (i % 4), 44 + ( button_h * 2) * (i /4));
            
            
            UIButton * bt = _selectArray[i];
            
            
            [self moveAnimation:bt.center andNewPoint:newPoint withButton:bt];
            
            
            NSValue * value = [NSValue valueWithCGPoint:newPoint];
            [_centArray addObject:value];
            

        }
        
       
        if (bt.gestureRecognizers) {
        
//        [self removeCurrentBtPan];
        
        }
        
    //添加频道
    }else if (bt.tag < 2000) {
        
        
        //如果是排序状态
        if (self.isOrder) {
           [self singleButtonPanAdd:bt];
        }
        
        
        [_unSelectArray removeObject:bt];
        
        
        NSInteger index = bt.tag - 1100;
        
        bt.tag = 2200 + index;
        
        [_selectArray addObject:bt];
        
        [_centArray removeAllObjects];
        
        for (int i = 0 ; i<_selectArray.count;i++) {
            
            CGPoint newPoint = CGPointMake( (Screen_W - button_w * 4)/5 + button_w/2  + ( button_w + (Screen_W - button_w * 4)/5)* (i % 4), 44 + ( button_h * 2) * (i /4));
            
            UIButton * bt = _selectArray[i];
            
            [self moveAnimation:bt.center andNewPoint:newPoint withButton:bt];
            
            NSValue * value = [NSValue valueWithCGPoint:newPoint];
            
            [_centArray addObject:value];
        }

        
        [UIView animateWithDuration:0.25 animations:^{
            UIButton * btLast = [_selectArray lastObject];
            
            self.lineView.center = CGPointMake(Screen_W/2, CGRectGetMaxY(btLast.frame) + Screen_W/14);
            
        }];
        
        
        for (int i = 0; i < _unSelectArray.count; i ++) {
            
            CGPoint newPoint = CGPointMake( (Screen_W - button_w * 4)/5 + button_w/2  + ( button_w + (Screen_W - button_w * 4)/5)* (i % 4), CGRectGetMaxY(_lineView.frame)  + button_h + ( button_h * 2) * (i /4));
            
            
            UIButton * bt = _unSelectArray[i];
            
            
            [self moveAnimation:bt.center andNewPoint:newPoint withButton:bt];
            
        }
            }
    
    
    
    
}


#pragma mark- 移除手势
- (void)removeCurrentBtPan{

    UIButton * bt = [self.unSelectArray lastObject];

    [bt removeGestureRecognizer:self.currentSelectPan];
    
}


#pragma mark- 计算要交换的坐标
//计算要交换的坐标
- (void)selectButtonRank:(UIButton *)bt{
    
    NSInteger bt_X = bt.center.x;
    NSInteger bt_Y = bt.center.y;

    NSInteger temp = 10000;
    
    
    for (int i = 1; i  < _centArray.count ; i++) {
        
        if (bt == _selectArray[i]) {
            continue;
        }
        
        NSValue * value = _centArray[i];
        
        CGPoint vaPt = [value CGPointValue];
        
        NSInteger vaPt_X = vaPt.x;
        NSInteger vaPt_Y = vaPt.y;
        //勾股定理
        _a = labs(bt_X - vaPt_X);
        _b = labs(bt_Y - vaPt_Y);
        //开平方计算最小的距离
        _c = sqrtl(_a * _a + _b * _b);
        
        if (temp > _c) {
            temp = _c;
            //要交换位置的数组下标
            _temp_i = i;

        }
        
    }
    
    if (temp < button_h + button_h/3) {
        
    CGPoint newPoint = CGPointMake( (Screen_W - button_w * 4)/5 + button_w/2  + ( button_w + (Screen_W - button_w * 4)/5)* (_temp_i % 4), 44 + ( button_h * 2) * (_temp_i /4));
        
       _oldCenter = newPoint;
        
        NSLog(@"-=-=-=-=-=");
        
        [_selectArray removeObject:bt];
        [_selectArray insertObject:bt atIndex:_temp_i];
        
        
//       ============================
        
        //重新计算按钮坐标
        for (int i = 0 ; i<_selectArray.count;i++) {
            
            CGPoint newPoint = CGPointMake( (Screen_W - button_w * 4)/5 + button_w/2  + ( button_w + (Screen_W - button_w * 4)/5)* (i % 4), 44 + ( button_h * 2) * (i /4));
            
            
            UIButton * bt = _selectArray[i];
            
            if (_temp_i != i) {
//      //改变按钮位置
            [self moveAnimation:bt.center andNewPoint:newPoint withButton:bt];
                
            }
        }
//        ============================
        
    }
    

}


#pragma mark- 坐标移动动画
- (void)moveAnimation:(CGPoint)oldPoint andNewPoint:(CGPoint)newPoint withButton:(UIButton *)bt{

    [UIView animateWithDuration:0.25 animations:^{
        bt.center = newPoint;
    }];

}




- (void)removeButtonoOfAllPan{

}

@end











