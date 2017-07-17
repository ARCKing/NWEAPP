//
//  ServiceQQCell.h
//  NewApp
//
//  Created by gxtc on 2017/6/3.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "RootTableViewCell.h"

@interface ServiceQQCell : RootTableViewCell

@property(nonatomic,strong)UILabel * QQLabel;


- (void)setDataWithQQNumber:(NSString *)QQ;

@end
