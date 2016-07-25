//
//  MoreAdViewController.m
//  loveshare
//
//  Created by lhb on 16/7/7.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "MoreAdViewController.h"
#import "AdListModel.h"
#import "UIImageView+WebCache.h"
//#import "AdListModel.h"
#import "CircleBannerView.h"


@interface MoreAdViewController ()<CircleBannerViewDelegate>

@property(nonatomic,strong) UIScrollView * scrollView;


@property(nonatomic,strong) NSTimer * timer;


@property(nonatomic,assign) int lastTime;


@property(nonatomic,strong) UILabel * timeLable;

@property(nonatomic,strong) NSMutableArray * timerS;


@property(nonatomic,strong) NSMutableArray * imagesArray;


@property(nonatomic,strong) InitModel * initmodel;
@end

@implementation MoreAdViewController



- (NSMutableArray *)imagesArray{
    if (_imagesArray == nil) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}




- (NSMutableArray *)timerS{
    if (_timerS == nil) {
        _timerS = [NSMutableArray array];
    }
    return _timerS;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    InitModel * model = (InitModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:InitModelCaches];
    self.initmodel = model;
    NSArray * aa = model.AdList;
    
    for (int i = 0; i<aa.count; i++) {
        AdListModel * model = aa[i];
        [self.imagesArray addObject:model.itemImgUrl];
    }
    CircleBannerView * banaerView = [[CircleBannerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight) urlArray:self.imagesArray];
    banaerView.scrollDirection = CircleBannerViewScrollDirectionHorizontal;
    banaerView.delegate = self;
     AdListModel * urlxx = [model.AdList objectAtIndex:0];
    banaerView.interval = urlxx.itemShowTime;
    
    [self.view addSubview:banaerView];
    

   
    _lastTime = model.adTime;
//
    UILabel * timeLable = [[UILabel alloc] init];
    _timeLable = timeLable;
    timeLable.textAlignment = NSTextAlignmentCenter;
    [timeLable setFont:[UIFont systemFontOfSize:14]];
    timeLable.backgroundColor = [UIColor blackColor];
    [timeLable setTextColor:[UIColor whiteColor]];
    timeLable.frame = CGRectMake(ScreenWidth - 100, 30, 80, 40);
    [self.view addSubview:timeLable];
    timeLable.text = [NSString stringWithFormat:@"%ds 跳过",_lastTime];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumperAs)];
    timeLable.userInteractionEnabled = YES;
    [timeLable addGestureRecognizer:tap];
    
    NSDictionary * dict = @{@"totoleTime":@(model.adTime)};
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeLown:) userInfo:dict repeats:YES];
    
    
}

- (void)jumperAs{
    
    [self.timer invalidate];
    self.timer = nil;
    
    MMRootViewController * root = [[MMRootViewController alloc] init];
    UIWindow * windwon = [UIApplication sharedApplication].keyWindow;
    windwon.rootViewController = root;
    [windwon makeKeyAndVisible];
}

- (void)imageView:(UIImageView *)imageView loadImageForUrl:(NSString *)url bringBack:(CircleBannerView *)circleBannerView{
    
    NSUInteger aa = [self.imagesArray indexOfObject:url];
    AdListModel * urlxx = [self.initmodel.AdList objectAtIndex:aa];
    LWLog(@"----------%d",urlxx.itemShowTime);
    if(urlxx.itemShowTime > 0){
        [circleBannerView setInterval:urlxx.itemShowTime];
    }else{
        return;
    }
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageHighPriority];
    
}

- (void)timeLown:(NSTimer *)timer{
    
    _lastTime--;
    if (_lastTime == 0) {
        [timer invalidate];
        self.timer = nil;
        MMRootViewController * root = [[MMRootViewController alloc] init];
        UIWindow * windwon = [UIApplication sharedApplication].keyWindow;
        windwon.rootViewController = root;
        [windwon makeKeyAndVisible];
    }else{
        _timeLable.text = [NSString stringWithFormat:@"%ds 跳过",_lastTime];
    }

}


- (void)bannerView:(CircleBannerView *)bannerView didSelectAtIndex:(NSUInteger)index{
    
    [self.timer invalidate];
    self.timer = nil;

//    MMRootViewController * root = [[MMRootViewController alloc] init];
//    UIWindow * windwon = [UIApplication sharedApplication].keyWindow;
//    windwon.rootViewController = root;
//    [windwon makeKeyAndVisible];
//    
    
    InitModel * model = (InitModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:InitModelCaches];
    NSDictionary * url = [[model.AdList objectAtIndex:index] mj_keyValues];
    NSString * urldd = [url objectForKey:@"itemImgDescLink"];
    if (urldd.length) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urldd]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"adNotificate" object:nil userInfo:url];
    MMRootViewController * root = [[MMRootViewController alloc] init];
    UIWindow * windwon = [UIApplication sharedApplication].keyWindow;
    windwon.rootViewController = root;
    [windwon makeKeyAndVisible];
    
}


//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//
//
//
///**
// *  scrollView image
// */
//- (void)setupScrollView
//{
//    UIScrollView * scrollView = [[UIScrollView alloc] init];
//    scrollView.backgroundColor = [UIColor whiteColor];
//    self.scrollView = scrollView;
//    scrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//    scrollView.delegate = self;
//    scrollView.userInteractionEnabled = YES;
//    [self.view addSubview:scrollView];
//}
//
//
//- (void)addimage:(NSArray *)adlists{
//    _adlists = adlists;
//    
//    LWLog(@"%lu",(unsigned long)adlists.count);
//    //2、添加图片
//    CGFloat scrollW = ScreenWidth;
//    CGFloat scrollH = ScreenHeight;
//    
//    //获取启动图片
//    CGSize viewSize = CGSizeMake(scrollW, scrollH);
//    
//    LWLog(@"%@",NSStringFromCGSize(viewSize));
//    //横屏请设置成 @"Landscape"
//    NSString *viewOrientation = @"Portrait";
//    NSString *launchImageName = nil;
//    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
//    for (NSDictionary* dict in imagesDict)
//    {
//        
//        LWLog(@"%@",dict);
//        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
//        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
//        {
//            launchImageName = dict[@"UILaunchImageName"];
//            break;
//        }
//
//    }
//    LWLog(@"%@",launchImageName);
//    
//    for (int index = 0; index < adlists.count; index++) {
//        __block UIImageView * imageView = [[UIImageView alloc] init];
//        imageView.image = [UIImage imageNamed:launchImageName];
//        CGFloat imageX = index * scrollW;
//        CGFloat imageY = 0;
//        CGFloat imageW = scrollW;
//        CGFloat imageH = scrollH;
//        imageView.frame =CGRectMake(imageX, imageY, imageW, imageH);
//        imageView.tag = index;
//        
//        
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        AdListModel * model =  [adlists objectAtIndex:index];
//        LWLog(@"%@",[model mj_keyValues]);
//        
//        
//        NSDictionary * dict = @{@"timerArray":@(index)};
//        NSTimer * timer = [NSTimer timerWithTimeInterval:model.itemShowTime target:self selector:@selector(jumperAs:) userInfo:dict repeats:NO];
//        [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
//        [self.timerS addObject:timer];
//        if (index == 0) {
//            [timer fireDate];
//        }
//        SDWebImageManager * manager = [SDWebImageManager sharedManager];
//        [manager downloadImageWithURL:[NSURL URLWithString:model.itemImgUrl] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//            LWLog(@"%@",NSStringFromCGSize(image.size));
//            imageView.image = image;
//        }];
//        [self.scrollView addSubview:imageView];
//        
//    }
//    //设置滚动内容范围尺寸
//    self.scrollView.contentSize = CGSizeMake(scrollW*adlists.count, 0);
//    
//    //隐藏滚动条
//    self.scrollView.showsHorizontalScrollIndicator = NO;
//    self.scrollView.pagingEnabled = YES;
//    self.scrollView.bounces =NO;
//
//}
//
//
//- (void)jumperAs:(NSTimer *)timer{
//    
//    
//    LWLog(@"%@",timer.userInfo);
//    int index = (int)[timer.userInfo objectForKey:@"timerArray"];
//    [timer invalidate];
//    CGPoint point = CGPointMake((index+1)*ScreenWidth, 0);
//    [self.scrollView setContentOffset:point animated:YES];
//    
//    
//}
//
//
///**
// *  只要滚地就掉用这个方法
// */
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
////    CGFloat x =  scrollView.contentOffset.x;
////    double padgeDouble = x / scrollView.frame.size.width;
////    int padgeInt = (int)(padgeDouble + 0.5);
////    self.padgeControl.currentPage = padgeInt;
//    
//}
//
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    CGFloat x =  scrollView.contentOffset.x;
//    double padgeDouble = x / scrollView.frame.size.width;
//    int padgeInt = (int)(padgeDouble + 0.5);
//    
//    if (padgeInt < self.timerS.count) {
//        NSTimer * time = [self.timerS objectAtIndex:padgeInt+1];
//        [time fireDate];
//    }
//   
//}
//
//
///**
// *  <#Description#>
// */
//- (void)adClicl:(UITapGestureRecognizer *)tap{
//    
//    LWLog(@"%@",tap);
//    
//}
@end
