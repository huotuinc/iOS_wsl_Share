//
//  StoreSelectedTableViewCell.h
//  loveshare
//
//  Created by che on 16/5/12.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreModel.h"



@interface StoreSelectedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageVLogo;
@property (weak, nonatomic) IBOutlet UILabel *labelName;



- (void)loadData:(StoreModel *)model;


@end
