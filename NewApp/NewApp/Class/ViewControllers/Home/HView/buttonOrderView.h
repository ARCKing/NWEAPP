//
//  buttonOrderView.h
//  buttonAnimiation
//
//  Created by gxtc on 16/9/21.
//  Copyright © 2016年 gxtc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface buttonOrderView : UIView
@property (nonatomic,strong)UIButton * lineButton;
@property (nonatomic,strong)UIButton * addPanButton;

//存按钮数组
@property (nonatomic,strong)NSMutableArray * selectArray;
@property (nonatomic,strong)NSMutableArray * unSelectArray;

- (void)addGest;
@end
