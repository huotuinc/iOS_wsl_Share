//
//  TudiTableViewCell.h
//  loveshare
//
//  Created by lhb on 16/3/11.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowModel.h"

@interface TudiTableViewCell : UITableViewCell


@property(nonatomic,strong) FollowModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@end
