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
#import "EnViewController.h"


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

/**头像*/
@property (nonatomic,strong) UIButton * leftBtn;

@property(nonatomic,strong) MJRefreshGifHeader * head;
@property(nonatomic,strong) MJRefreshAutoFooter * footer;

//@property(nonatomic,strong) UISegmentedControl * segmentedControl;

@property(nonatomic,strong) UIButton * searchButton;

@property(nonatomic,assign) NSInteger homeStoreID;//ID为0为全部商户



@property(nonatomic,assign) NSInteger homeTaskStaus;

@property(nonatomic,assign)  NSNotificationCenter * centerNot;


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

//
//- (UISegmentedControl *)segmentedControl {
//    if (_segmentedControl == nil) {
//        _segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//        [_segmentedControl addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventValueChanged];
//        //修改字体的默认颜色与选中颜色
//        _segmentedControl.layer.borderWidth = 0.0;
//        _segmentedControl.tintColor = [UIColor whiteColor];
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:225.0/255 green:128/255.0 blue:0/255.0 alpha:1.000],UITextAttributeTextColor,  [UIFont systemFontOfSize:16.f],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
//        [_segmentedControl setTitleTextAttributes:dic forState:UIControlStateSelected];
////        [_segmentedControl setTitleTextAttributes:dic forState:UIControlStateSelected];
//        [_segmentedControl insertSegmentWithTitle:@"及时任务" atIndex:0 animated:YES];
//        [_segmentedControl insertSegmentWithTitle:@"企业专区" atIndex:1 animated:YES];
//        _segmentedControl.selectedSegmentIndex = 0;
//    }
//    return _segmentedControl;
//}

- (void)segmentedControlChange:(UISegmentedControl *)sgc {
    
    // 让UIScrollView滚动到对应位置
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = sgc.selectedSegmentIndex * self.scrollView.xmg_width;
    [self.scrollView setContentOffset:offset animated:YES];
    
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
    
    
    [self.navigationController.navigationBar  setBarTintColor:[UIColor colorWithRed:233/255.0 green:147/255.0 blue:25/255.0 alpha:1]];
    
    self.title = @"乐享资讯";
//    UserModel * userInfo = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchButton];
    self.titleHeadOption.delegate  = self;
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    btn.layer.cornerRadius = 16;
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = 1;
    self.leftBtn = btn;
//    [btn sd_setImageWithURL:[NSURL URLWithString:userInfo.userHead] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"geren"]];
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
    
    
    
    EnViewControllerInCollectionViewController *all = [EnViewControllerInCollectionViewController EnMyInit];
    [self addChildViewController:all];
    

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate * ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ad.currentVC = self;
    
    [self setupChildViewControllers];
 
    
    [self setUpInit];
    
    [self setupScrollView];
    
    
    [self setupTitlesView];
    
    
    
    [self addChildVcView];
    
    
    NSNotificationCenter * centerNot = [NSNotificationCenter defaultCenter];
    _centerNot = centerNot;
    [centerNot addObserver:self selector:@selector(GoADDetail) name:@"AdClick" object:nil];
    
    
   
}


/**
 *  进入广告详情
 */
- (void)GoADDetail{

   InitModel * model = (InitModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:InitModelCaches];
    if (model.adclick.length) {
        AdViewController * ad = [[AdViewController alloc] init];
        ad.adLink = model.adclick;
        [self.navigationController pushViewController:ad animated:YES];
        
    }
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
    HomeTitleOption * titleView = [[HomeTitleOption alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, Height)];
//    UILabel * shaixuan = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-60, 0, 60, Height)];
//    shaixuan.textAlignment = NSTextAlignmentCenter;
//    shaixuan.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
//    shaixuan.userInteractionEnabled = YES;
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shaixuan)];
//    [shaixuan setText:@"筛选"];
//    [shaixuan addGestureRecognizer:tap];
//    [self.view addSubview:shaixuan];
    
    titleView.delegate = self;
    _titleView = titleView;
    [self.view addSubview:titleView];
}

/**
 *  筛选点击
 */
- (void)shaixuan{
   
    StoreSelectedViewController *store = [[StoreSelectedViewController alloc] init];
    store.delegate = self;
    [self.navigationController pushViewController:store animated:YES];
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
        
    }else if([note.userInfo[@"option"] integerValue] == 1){//历史浏览
       
        HostTableViewController * vc = [[HostTableViewController alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
        
        
    }else if([note.userInfo[@"option"] integerValue] == 2){//排行榜
        
        TopTenListTableViewController * topten = [[TopTenListTableViewController alloc] init];
        [self.navigationController pushViewController:topten animated:NO];
        
        
        
        
    }else if([note.userInfo[@"option"] integerValue] == 3){//本周任务
        
        
        WeekTaskTableViewController * vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"WeekTaskTableViewController"];
        [self.navigationController pushViewController:vc animated:NO];
        NSLog(@"本周人物");
    }else if([note.userInfo[@"option"] integerValue] == 4){//师徒联盟
        MasterAndTudiViewController * vc = (MasterAndTudiViewController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"MasterAndTudiViewController"];
        [self.navigationController pushViewController:vc animated:NO];
    }else if([note.userInfo[@"option"] integerValue] == 5){//内购商城
        HomeViewController * vc =  (HomeViewController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"HomeViewController"];
        [self.navigationController pushViewController:vc animated:NO];
        
    }else if([note.userInfo[@"option"] integerValue] == 6){//更多设置
        
        MoreSetTableViewController * vc = (MoreSetTableViewController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"MoreSetTableViewController"];
        [self.navigationController pushViewController:vc animated:NO];
    
    }else if([note.userInfo[@"option"] integerValue] == 7){//监督管理
        VipAccountViewController * vip = [[VipAccountViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:vip animated:NO];
        
    }else if([note.userInfo[@"option"] integerValue] == 100){
        
        PersonMessageTableViewController * pers = (PersonMessageTableViewController *)[UserLoginTool LoginCreateControllerWithNameOfStory:nil andControllerIdentify:@"PersonMessageTableViewController"];
        [self.navigationController pushViewController:pers animated:NO];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view endEditing:YES];

    UserModel * userInfo = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    [self.leftBtn sd_setImageWithURL:[NSURL URLWithString:userInfo.userHead] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"geren"]];
    
    
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
    vc.titles = @[@"温馨提示:点击头像去菜单选项"];
    vc.frames = @[@"{{5,10},{50,50}}"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}
- (void)makeGuideView{
    RAYNewFunctionGuideVC *vc = [[RAYNewFunctionGuideVC alloc]init];
    vc.titles = @[@"温馨提示: 点击咨询查看咨询详情"];
    vc.frames = @[@"{{0,  140},{130,140}}"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark XYPopViewDelegate


- (void)chooseItem:(NSString *)title andTag:(NSInteger)tag {
    NSLog(@"title ------ %@ title ------ %ld",title,(long)tag);
}



/**
 *  店铺选择
 *
 *  @param userID <#userID description#>
 */
- (void)sendUserID:(NSInteger)userID {
    _homeStoreID = userID;
    
    // 子控制器的索引
    NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.xmg_width;
    LWLog(@"%ld---%lud",(long)self.homeStoreID,(unsigned long)index);
    
   
    [[NSUserDefaults standardUserDefaults] setObject:@(userID) forKey:@"storyID"];
    
    // 取出子控制器
    for (int i = 0; i<self.childViewControllers.count; i++) {
        HomeListTableController *childVc = self.childViewControllers[index] ;
        [childVc StoryRefreshDateWithStroryID:userID];
    }
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
