//
//  TopTenOtherTableViewCell.h
//  loveshare
//
//  Created by lhb on 16/6/7.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OtherTenModel.h"

@interface TopTenOtherTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *number;
@property(nonatomic,strong) OtherTenModel * date;

@end
