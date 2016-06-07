//
//  HomeViewController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "HomeListViewController.h"
#import "detailViewController.h"
#import <MJRefresh.h>
#import "RAYNewFunctionGuideVC.h"
#import "SearchViewController.h"
#import "HomeTitleButton.h"
#import "MJChiBaoZiHeader.h"
#import "StoreSelectedViewController.h"
#import "UIButton+WebCache.h"
#import "XYPopView.h"
#import "TopTenListTableViewController.h"

#define pageSize 10

#define COLOR_BACK_SELECTED [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1]


@interface HomeListViewController ()<XYPopViewDelegate,HomeTitleOptionDelegate,UIScrollViewDelegate,storeSelectedDelegate>


@property(nonatomic,strong) UIScrollView * scrollView;


/**头部栏*/
@property(nonatomic,strong) HomeTitleButton * optionCurrentBtn;

/**luohaibo头部选项栏*/
@property(nonatomic,strong) HomeTitleOption * titleView;


@property (weak, nonatomic) IBOutlet HomeTitleOption *titleHeadOption;


/**第四个图片*/
@property (weak, nonatomic) IBOutlet UIImageView *fourthImage;

/**第二个图片*/
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;

/**thirdImage*/
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;


@property (weak, nonatomic) IBOutlet UIView *firstView;

@property (weak, nonatomic) IBOutlet UILabel *firstLable;

@property (weak, nonatomic) IBOutlet UIView *secondView;

@property (weak, nonatomic) IBOutlet UILabel *secondLable;

@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIView *otherView;

@property (weak, nonatomic) IBOutlet UILabel *thirdLable;

@property (weak, nonatomic) IBOutlet UIView *fourthView;

@property (weak, nonatomic) IBOutlet UILabel *fourLable;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;


@property (nonatomic, strong) XYPopView *popView;


@property (nonatomic, strong) NSArray *otherArray;

@property(nonatomic,strong)UIView * redView;

@property (weak, nonatomic) IBOutlet UIView *topHeadView;

@property(nonatomic,strong)UIView * currentSelect;





@property (weak, nonatomic) IBOutlet UIImageView *imageVLine;



@property(nonatomic,assign) int thirdLableNum;


@property(assign ,nonatomic) NSInteger currentTag;

@property(assign ,nonatomic) NSInteger pageIndex;


@property (weak, nonatomic) IBOutlet UITableView *taskTableview;



@property(nonatomic,strong) MJRefreshGifHeader * head;
@property(nonatomic,strong) MJRefreshAutoFooter * footer;

@property(nonatomic,strong) UISegmentedControl * segmentedControl;

@property(nonatomic,strong) UIButton * searchButton;

@property(nonatomic,assign) NSInteger homeStoreID;//ID为0为全部商户



@property(nonatomic,assign) NSInteger homeTaskStaus;


@end


@implementation HomeListViewController

static NSString * homeCellidentify = @"homeCellId";

- (UIButton *)searchButton {
    if (_searchButton == nil) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_searchButton setBackgroundImage:[UIImage imageNamed:@"homeSearch"] forState:UIControlStateNormal];
        [_searchButton bk_whenTapped:^{
            if (_popView) {
                [_popView showPopView];
            }
            SearchViewController *search = [[SearchViewController alloc] init];
            [self.navigationController pushViewController:search animated:YES];
        }];
    }
    return _searchButton;
}

- (XYPopView *)popView {
    if (_popView == nil) {
        _popView = [[XYPopView alloc] initWXYPopViewWithImage:nil andTitle:nil andSuperView:self.otherView];
        _popView.delegate = self;
    }
    return _popView;
}
- (NSArray *)otherArray {
    if (_otherArray == nil) {
        _otherArray = @[@"1",@"2",@"3"];
    }
    return _otherArray;
}


- (void)leftButton{
//    if (_popView) {
//        [_popView showPopView];
//    }
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
    }];
}


- (void)setUpInit{
    self.navigationItem.title = @"资讯";
    
    UserModel * userInfo = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchButton];
    self.titleHeadOption.delegate  = self;
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    btn.layer.cornerRadius = 16;
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = 1;
    [btn sd_setImageWithURL:[NSURL URLWithString:userInfo.userHead] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"geren"]];
    [btn addTarget:self action:@selector(leftButton) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectController:) name:@"backToHomeView" object:nil];
    [self.taskTableview registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:homeCellidentify];
    self.taskTableview.rowHeight = 150;
    self.taskTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.taskTableview.backgroundColor = [UIColor colorWithRed:0.884 green:0.890 blue:0.832 alpha:1.000]
    ;
}


- (void)setupChildViewControllers
{
    MoreTaskController  *voice = [[MoreTaskController alloc] init];
    [self addChildViewController:voice];
    
    SheYuTaskViewContrller *all = [[SheYuTaskViewContrller alloc] init];
    [self addChildViewController:all];
    

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupChildViewControllers];
 
    
    [self setUpInit];
    
    [self setupScrollView];
    
    
    [self setupTitlesView];
    
    
    
    [self addChildVcView];
    
    
}


#pragma mark - 添加子控制器的view
- (void)addChildVcView
{
    // 子控制器的索引
    NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.xmg_width;
    
    // 取出子控制器
    UIViewController *childVc = self.childViewControllers[index];
    if ([childVc isViewLoaded]) return;
    
    childVc.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:childVc.view];
}

- (void)TopOptionButtonClick:(HomeTitleButton *)Btn{
    
    if (Btn.tag == self.optionCurrentBtn.tag)
        return;
    Btn.selected = YES;
    Btn.backgroundColor = LWColor(206, 206, 206);
    self.optionCurrentBtn.selected = NO;
    self.optionCurrentBtn.backgroundColor = LWColor(254, 254, 254);
    self.optionCurrentBtn = Btn;
}

- (void)setupTitlesView
{
    
    CGFloat Height = 44;
    
//    UIView * bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, Height)];
//    bigView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
//    
//    HomeTitleButton * btn1 = [[HomeTitleButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth *0.5, Height)];
//    btn1.selected = YES;
//    self.optionCurrentBtn = btn1;
//    self.optionCurrentBtn.backgroundColor = LWColor(206, 206, 206);
//    btn1.tag = 100;
//    [btn1 setTitle:@"进行中" forState:UIControlStateNormal];
//    [btn1 addTarget:self action:@selector(TopOptionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
////    [btn1 setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7]];
////    btn1.backgroundColor = [UIColor colorWithHue:0.6 saturation:0.6 brightness:0.6 alpha:0.5];
//    [bigView addSubview:btn1];
//    
//    HomeTitleButton * btn2= [[HomeTitleButton alloc] initWithFrame:CGRectMake(ScreenWidth *0.5, 0, ScreenWidth *0.5, Height)];
//    [btn2 addTarget:self action:@selector(TopOptionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [btn2 setTitle:@"已抢光" forState:UIControlStateNormal];
//    [bigView addSubview:btn2];
//    btn1.tag = 200;
//    [self.view addSubview:bigView];
    
    
    HomeTitleOption * titleView = [[HomeTitleOption alloc] initWithFrame:CGRectMake(0,0, ScreenWidth-60, Height)];
    UILabel * shaixuan = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-60, 0, 60, Height)];
    shaixuan.textAlignment = NSTextAlignmentCenter;
    shaixuan.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shaixuan)];
    [shaixuan setText:@"筛选"];
    [shaixuan addGestureRecognizer:tap];
    [self.view addSubview:shaixuan];
    
    titleView.delegate = self;
    _titleView = titleView;
    [self.view addSubview:titleView];
}

/**
 *  筛选点击
 */
- (void)shaixuan{
   
    LWLog(@"xx");
}

- (void)setupScrollView
{
    // 不允许自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.frame = self.view.bounds;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    // 添加所有子控制器的view到scrollView中
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count * scrollView.xmg_width, 0);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}




/**
 *  控制器选择
 *
 *  @param note <#note description#>
 */
- (void)selectController:(NSNotification *) note{
    
    if([note.userInfo[@"option"] integerValue] == 0){//首页
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    }else if([note.userInfo[@"option"] integerValue] == 1){//历史浏览量
       
        HostTableViewController * vc = [[HostTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:vc animated:NO];
        
        
    }else if([note.userInfo[@"option"] integerValue] == 2){//新手任务
        JiFenToMallController * vc = (JiFenToMallController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"JiFenToMallController"];
        [self.navigationController pushViewController:vc animated:NO];
        
    }else if([note.userInfo[@"option"] integerValue] == 3){//进入商城
        
#warning 缺商城账号选中
       HomeViewController * vc =  (HomeViewController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"HomeViewController"];
      [self.navigationController pushViewController:vc animated:NO];
    }else if([note.userInfo[@"option"] integerValue] == 4){//最新预告
        
        TodayForesController * vc =  (TodayForesController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"TodayForesController"];
        [self.navigationController pushViewController:vc animated:NO];
        
    }else if([note.userInfo[@"option"] integerValue] == 5){//师徒联盟
        MasterAndTudiViewController * vc = (MasterAndTudiViewController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"MasterAndTudiViewController"];
        [self.navigationController pushViewController:vc animated:NO];
    }else if([note.userInfo[@"option"] integerValue] == 6){//排行榜
        TopTenListTableViewController * topten = [[TopTenListTableViewController alloc] init];
        [self.navigationController pushViewController:topten animated:NO];
        
    }else if([note.userInfo[@"option"] integerValue] == 7){//更多设置
        MoreSetTableViewController * vc = (MoreSetTableViewController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"MoreSetTableViewController"];
        [self.navigationController pushViewController:vc animated:NO];
        
    }else if([note.userInfo[@"option"] integerValue] == 8){
        VipAccountViewController * vip = [[VipAccountViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:vip animated:NO];
        
    }else{
        PersonMessageTableViewController * pers = (PersonMessageTableViewController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"PersonMessageTableViewController"];
        [self.navigationController pushViewController:pers animated:NO];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view endEditing:YES];

    self.navigationController.navigationBarHidden = NO;
    [_head beginRefreshing];

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //判断是否为第一次进入
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *isFirstHome = [defaults stringForKey:@"isFirstHome"];
    if (![isFirstHome isEqualToString:@"1"]){
        [defaults setObject:@"1" forKey:@"isFirstHome"];
        [defaults synchronize];
        [self makeGuideView];
    }
    //判断是否为第一次进入
    NSString *isFirstShareSuccess = [defaults stringForKey:@"isFirstShareSuccess"];
    //正常加个
    if ([isFirstHome isEqualToString:@"1"] && [isFirstShareSuccess isEqualToString:@"YES"]){
        [defaults setObject:@"NO" forKey:@"isFirstShareSuccess"];
        [defaults setObject:@"YES" forKey:@"isShareSuccessAndGoHome"];
        [defaults synchronize];
        [self makeGuideShareView];
    }

    

}
- (void)makeGuideShareView{
    RAYNewFunctionGuideVC *vc = [[RAYNewFunctionGuideVC alloc]init];
    vc.titles = @[@"转发成功后在这里查看奖励"];
    vc.frames = @[@"{{5,10},{50,50}}"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}
- (void)makeGuideView{
    RAYNewFunctionGuideVC *vc = [[RAYNewFunctionGuideVC alloc]init];
    vc.titles = @[@"新手任务: 首次转发即可获得积分奖励"];
    vc.frames = @[@"{{0,  140},{130,140}}"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark XYPopViewDelegate


- (void)chooseItem:(NSString *)title andTag:(NSInteger)tag {
    NSLog(@"title ------ %@ title ------ %ld",title,(long)tag);
}

- (void)sendUserID:(NSInteger)userID {
    _homeStoreID = userID;
}


#pragma mark titleHeadOption

- (void)selectCurrentOption:(NSInteger) index{
    
    // 让UIScrollView滚动到对应位置
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = index * self.scrollView.xmg_width;
    [self.scrollView setContentOffset:offset animated:YES];
}


#pragma mark - <UIScrollViewDelegate>
/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 使用setContentOffset:animated:或者scrollRectVisible:animated:方法让scrollView产生滚动动画
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self addChildVcView];
}

/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 人为拖拽scrollView产生的滚动动画
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 选中\点击对应的按钮
    NSUInteger index = scrollView.contentOffset.x / scrollView.xmg_width;
    
    HomeTitleButton *titleButton = self.titleView.subviews[index];
    [self.titleView titleClick:titleButton];
    
    // 添加子控制器的view
    [self addChildVcView];
    
    // 当index == 0时, viewWithTag:方法返回的就是self.titlesView
    //    XMGTitleButton *titleButton = (XMGTitleButton *)[self.titlesView viewWithTag:index];
}

@end
