//
//  LWNewFeatureController.m
//  LuoHBWeiBo
//
//  Created by 罗海波 on 15-3-3.
//  Copyright (c) 2015年 LHB. All rights reserved.
//

#import "LWNewFeatureController.h"




@interface LWNewFeatureController ()<UIScrollViewDelegate,WXApiDelegate>


@property(nonatomic,weak)UIPageControl * padgeControl;
@end

@implementation LWNewFeatureController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view.userInteractionEnabled = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    //1、创建scrollView
    [self setupScrollView];
    
    [self setupPageControll];

    
}



/**
 *添加  pageControll
 */
- (void)setupPageControll
{
    //添加
    UIPageControl *pageControll = [[UIPageControl alloc] init];
    pageControll.numberOfPages = LWNewFeatureImageCount;
    CGFloat padgeX = self.view.frame.size.width * 0.5;
    CGFloat padgeY = self.view.frame.size.height - 35;
    pageControll.center = CGPointMake(padgeX, padgeY);
    pageControll.userInteractionEnabled = NO;
    pageControll.bounds = CGRectMake(0, 0, 60, 40);
    [self.view addSubview:pageControll];
    //设置圆点颜色
    pageControll.currentPageIndicatorTintColor = [UIColor colorWithRed:0.992 green:0.384 blue:0.165 alpha:1.000];//LWColor(253, 98, 42);
    pageControll.pageIndicatorTintColor = [UIColor colorWithWhite:0.741 alpha:1.000];// LWColor(189, 189, 189);
    //page
    self.padgeControl= pageControll;
    
}
/**
 *  scrollView image
 */
- (void)setupScrollView
{
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    scrollView.delegate = self;
    scrollView.userInteractionEnabled = YES;
    [self.view addSubview:scrollView];
    
    
    //2、添加图片
    
    CGFloat scrollW = scrollView.frame.size.width;
    CGFloat scrollH = scrollView.frame.size.height;
    
    for (int index = 0; index < LWNewFeatureImageCount; index++) {
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"414x736-%d",index+1]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        
        //设置scorllview的frame
        CGFloat imageX = index * scrollW;
        CGFloat imageY = 0;
        CGFloat imageW = scrollW;
        CGFloat imageH = scrollH;
        imageView.frame =CGRectMake(imageX, imageY, imageW, imageH);
        [scrollView addSubview:imageView];
        //在最后一个图片上面添加按钮
        if (index==LWNewFeatureImageCount-1) {
            [self setupLastImageView:imageView];
        }
    }
    //设置滚动内容范围尺寸
    scrollView.contentSize = CGSizeMake(scrollW*LWNewFeatureImageCount, 0);
    
    //隐藏滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces =NO;
}

/**
 *  处理追后一个view的按钮
 */
-(void)setupLastImageView:(UIImageView *)imageView
{
    imageView.userInteractionEnabled = YES;
    //添加按钮
    UIButton * startButton = [[UIButton alloc] init];
//    [startButton setBackgroundImage:[UIImage imageNamed:@"button-BR"] forState:UIControlStateNormal];

    //设置尺寸s
    CGFloat centerX = imageView.frame.size.width*0.5;
    CGFloat centerY = imageView.frame.size.height*0.85;
    startButton.center = CGPointMake(centerX,centerY);
//    startButton.layer.borderWidth = 1;
    startButton.layer.cornerRadius = 5;
    startButton.layer.masksToBounds =YES;
    startButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:128/255.0 blue:45/255.0 alpha:1.000];
    startButton.layer.borderColor = [UIColor blackColor].CGColor;
    [startButton becomeFirstResponder];
    startButton.bounds = (CGRect){CGPointZero,{ScreenWidth*2/3,44}};
    [startButton addTarget:self action:@selector(startButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    //设置文字
    startButton.imageView.image = [UIImage imageNamed:@"weixing"];
    [startButton setTitle:@"立即体验" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [imageView addSubview:startButton];
    
}


/**
 *  开始粉猫之旅
 */
-(void)startButtonClick
{
    
//    UIWindow * wind =  [UIApplication sharedApplication].keyWindow;
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
//    XMGLoginRegisterViewController * vc = [[XMGLoginRegisterViewController alloc] init];
    
   
    AccountLoginViewController * vc = [story instantiateViewControllerWithIdentifier:@"AccountLoginViewController"];
     UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    wind.rootViewController = vc;
//    [wind makeKeyAndVisible];
    [self presentViewController:nav animated:YES completion:nil];
    
    
}


#pragma scorllView 代理方法

/**
 *  只要滚地就掉用这个方法
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x =  scrollView.contentOffset.x;
    double padgeDouble = x / scrollView.frame.size.width;
    int padgeInt = (int)(padgeDouble + 0.5);
    self.padgeControl.currentPage = padgeInt;
 
}

@end
