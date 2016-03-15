//
//  ProfessionalController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/6/9.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "ProfessionalController.h"



@interface ProfessionalController ()<UITableViewDelegate,UITableViewDataSource>


/**职业列表*/
@property (strong, nonatomic) NSArray *careers;
/**职业列表*/
@property (assign, nonatomic) int  isSelect;


@property(nonatomic,strong)NSIndexPath * currentIndex;

/**爱好选择数组*/
@property(nonatomic,strong) NSMutableArray * selectArray;


@property(nonatomic,strong) NSString * loveString;


@end

@implementation ProfessionalController

static NSString *professionalIdentify = @"pfCellId";


- (void)setDefauleDateID:(int)DefauleDateID{
    _DefauleDateID = DefauleDateID-1;
}



- (NSMutableArray *)selectArray{
    if (_selectArray == nil) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}



- (void)setSetgoods:(NSArray *)Setgoods{
    _Setgoods = Setgoods;
    
    LWLog(@"%lu",(unsigned long)Setgoods.count);
    if (Setgoods.count) {
        
        _careers = Setgoods;
        [self.tableView reloadData];
    }
    
   
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * titleName = nil;
    if (self.type == 0) {
        titleName = @"职业列表";
    }else if(self.type == 1){
        titleName = @"收入";
    }else{
       titleName = @"爱好";
    }
    
    self.title = titleName;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:professionalIdentify];
    self.tableView.tableFooterView = [[UIView alloc] init];

    
    
    LWLog(@"%d",self.DefauleDateID);
//    //处理爱好问题
//    if (self.type == 2) {
//        if([self.DefauleDateID isEqualToString:@"未知"]){
//            [self.selectArray removeAllObjects];
//        }else{
//            NSArray * current = [self.DefauleDate componentsSeparatedByString:@","];
//            [self.selectArray addObjectsFromArray:current];
//        }
//    }
//    
}


#pragma mark DateSouces tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return self.careers.count;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:professionalIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:professionalIdentify];
    }
    if (self.type == 1 || self.type == 0) {
        if(self.DefauleDateID){
            if (self.DefauleDateID == indexPath.row) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;

            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
    TwoOption * ca = self.careers[indexPath.row];
    NSMutableDictionary * dict = [ca mj_keyValues];
    cell.textLabel.text = dict[@"name"];
    return cell;
}

#pragma mark tableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LWLog(@"%ld",(long)indexPath.row);
    if (self.type == 2) {
        
        
    }
//    TwoOption * op = self.careers[indexPath.row];
    if (self.type == 0 || self.type == 1) {
        if (indexPath.row != self.DefauleDateID) {
            NSIndexPath * ind = [NSIndexPath indexPathForRow:self.DefauleDateID inSection:0];
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:ind];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        self.currentIndex = indexPath;
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
}



- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 0 || self.type == 1) {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
}
    

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.type == 0) {
        TwoOption * ca = self.careers[self.currentIndex.row];
        if ([self.delegate respondsToSelector:@selector(ProfessionalControllerBringBackCareerWithValue:withName:currentSelectType:)]) {
            [self.delegate ProfessionalControllerBringBackCareerWithValue:[[ca mj_keyValues] objectForKey:@"value"] withName:[[ca mj_keyValues] objectForKey:@"name"] currentSelectType:self.type];
        }
    }else if (self.type == 1){
        TwoOption * ca = self.careers[self.currentIndex.row];
        if ([self.delegate respondsToSelector:@selector(ProfessionalControllerBringBackIncomeWithId:WithName:currentSelectType:)]) {
            
            [self.delegate ProfessionalControllerBringBackIncomeWithId:[[ca mj_keyValues] objectForKey:@"value"] WithName:[[ca mj_keyValues] objectForKey:@"name"] currentSelectType:self.type];
        }
    }
    
}

@end
