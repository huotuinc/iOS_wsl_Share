//
//  InitModel.h
//  loveshare
//
//  Created by lhb on 16/3/4.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InitModel : NSObject
/*
 /// <summary>
 /// 微信版本号兼容配置
 /// </summary>
 public string wxVersionCode { get; set; }
 
 /// <summary>
 /// 登录是否成功
 /// </summary>
 public int loginStatus { get; set; }
 
 public AppUserDataModel userData { get; set; }
 
 /// <summary>
 /// 是否进行用户信息完善1是0否
 /// </summary>
 public int isCompleteUserInfo { get; set; }
 ///// <summary>
 ///// 用户昨日得到的总积分
 ///// </summary>
 //public int userYesTotalScore { get; set; }
 /// <summary>
 /// 短信后缀签名
 /// </summary>
 public string smsTag { get; set; }
 /// <summary>
 /// app版本更新类型：0，无更新1.增量更新2.整包更新3.强制增量更新4.强制整包更新
 /// </summary>
 public int updateType { get; set; }
 /// <summary>
 /// 更新包地址
 /// </summary>
 public string updateUrl { get; set; }
 /// <summary>
 /// 积分提现下限
 /// </summary>
 public int changeBoundary { get; set; }
 /// <summary>
 /// 更新内容
 /// </summary>
 public string updateTips { get; set; }
 /// <summary>
 /// 更新包的MD5
 /// </summary>
 public string updateMD5 { get; set; }
 
 /// <summary>
 /// 初始化载入图片数据
 /// </summary>
 public AppLoadingImgModel loadingImg { get; set; }
 /// <summary>
 /// 任务转发积分
 /// </summary>
 public decimal taskTurnScore { get; set; }
 /// <summary>
 /// 任务浏览积分
 /// </summary>
 public decimal taskBrowseScore { get; set; }
 /// <summary>
 /// 任务外链点击积分
 /// </summary>
 public decimal taskLinkScore { get; set; }
 /// <summary>
 /// 说明链接
 /// </summary>
 public string ruleUrl { get; set; }
 /// <summary>
 /// 关于我们
 /// </summary>
 public string aboutUsUrl { get; set; }
 /// <summary>
 /// 服务条款
 /// </summary>
 public string serviceUrl { get; set; }
 /// <summary>
 /// 渠道列表
 /// </summary>
 public string channelList { get; set; }
 /// <summary>
 /// 各任务转发时间间隔（单位s）
 /// </summary>
 public int taskTimeLag { get; set; }
 /// <summary>
 /// sina的app秘钥
 /// </summary>
 public string appSecret { get; set; }
 /// <summary>
 /// 灾难短信 0，正常;-1短信灾难
 /// </summary>
 public int smsEnable { get; set; }
 /// <summary>
 /// 微信的转发key
 /// </summary>
 public string weixinKey { get; set; }
 /// <summary>
 /// 人工服务
 /// </summary>
 public string manualServiceUrl { get; set; }
 /// <summary>
 /// 接入指南
 /// </summary>
 public string putInUrl { get; set; }
 /// <summary>
 /// 灾难标志 0正常  1不正常
 /// </summary>
 public int disasterFlag { get; set; }
 /// <summary>
 /// 灾难指导页面地址
 /// </summary>
 public string disasterUrl { get; set; }
 /// <summary>
 /// 拜师奖励信息提示语
 /// </summary>
 public string grenadeRewardInfo { get; set; }
 
 public List<AppGroupsModel> groups { get; set; }
 /// <summary>
 /// 返回连续签到奖励经验值，用|隔开
 /// </summary>
 public string checkExps { get; set; }
 /// <summary>
 /// 道具说明地址
 /// </summary>
 public string toolUrl { get; set; }
 
 private int cashType = 1;
 /// <summary>
 /// 提现类型  1 转入钱包  0积分提现
 /// </summary>
 public int CashType
 {
 get { return cashType; }
 set { cashType = value; }
 }
 /// <summary>
 /// 商城地址
 /// </summary>
 public string website { get; set; }
 
 */
/**提现类型  1 转入钱包  0积分提现*/
@property(nonatomic,strong)NSNumber *CashType;
/**关于我们*/
@property(nonatomic,copy)NSString *aboutUsUrl;
/***/
@property(nonatomic,copy)NSString *appSecret;

@property(nonatomic,strong)NSNumber * changeBoundary;
@property(nonatomic,copy)NSString *channelList;
@property(nonatomic,copy)NSString *checkExps;
@property(nonatomic,strong)NSNumber *customerId;
@property(nonatomic,strong)NSNumber * disasterFlag;
@property(nonatomic,copy)NSString *disasterUrl;
@property(nonatomic,copy)NSString *grenadeRewardInfo;
@property(nonatomic,strong)NSNumber * isCompleteUserInfo;
@property(nonatomic,copy)NSString *loadingImg;
@property(nonatomic,strong)NSNumber *loginStatus;
@property(nonatomic,copy)NSString *manualServiceUrl;
@property(nonatomic,copy)NSString *putInUrl;
@property(nonatomic,copy)NSString *ruleUrl;
@property(nonatomic,copy)NSString *serviceUrl;
@property(nonatomic,strong)NSNumber *smsEnable;
@property(nonatomic,copy)NSString * smsTag;
@property(nonatomic,copy)NSString * taskBrowseScore;
@property(nonatomic,strong)NSNumber *taskLinkScore;
@property(nonatomic,strong)NSNumber *taskTimeLag;
@property(nonatomic,strong)NSNumber *taskTurnScore;
@property(nonatomic,copy)NSString * toolUrl;
@property(nonatomic,copy)NSString * updateMD5;
@property(nonatomic,copy)NSString * updateMD5updateTips;
@property(nonatomic,copy)NSString *updateType;
@property(nonatomic,copy)NSString *updateUrl;
@property(nonatomic,copy)NSString *userData;
@property(nonatomic,copy)NSString * website;
@property(nonatomic,copy)NSString * weixinKey;
@property(nonatomic,copy)NSString * wxVersionCode;


@end
