//
//  UserRankCell.h
//  NewApp
//
//  Created by gxtc on 17/2/16.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserRankModel.h"
@interface UserRankCell : UITableViewCell
@property (nonatomic,strong)UILabel * numberRankLabel;

@property(nonatomic,strong)UserRankModel * model;


-(void)setDataWithModel:(UserRankModel * )model andType:(NSInteger)type andHidenReview:(BOOL)hiden;

@end
