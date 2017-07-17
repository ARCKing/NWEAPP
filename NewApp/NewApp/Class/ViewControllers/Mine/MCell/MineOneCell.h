//
//  MineOneCell.h
//  NewApp
//
//  Created by gxtc on 17/2/16.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineOneCell : UITableViewCell

@property (nonatomic,strong)UIImageView * iconImageView;
@property (nonatomic,strong)UILabel * goldLabel;

- (void)addIcon:(NSString *)icon andTitle:(NSString *)title;


- (void)showUserGoldAmount:(NSString *)goldNumber;


- (NSMutableAttributedString *)addAttributedGoldNumber:(NSString *)num;
@end
