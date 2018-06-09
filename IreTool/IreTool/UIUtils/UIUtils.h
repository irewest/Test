//
//  UIUtils.h
//  WXTime
//
//  Created by wei.chen on 12-7-22.
//  Copyright (c) 2012年 www.iphonetrain.com 无限互联ios开发培训中心 All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIUtils : NSObject

//获取documents下的文件路径
+ (NSString *)getDocumentsPath:(NSString *)fileName;
// date 格式化为 string
+ (NSString*) stringFromFomate:(NSDate*)date formate:(NSString*)formate;
// string 格式化为 date
+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate;

+ (NSString *)fomateString:(NSString *)datestring;

//获取时间戳
+ (NSInteger)stampFromDateString:(NSString *)dateString;

//根据时间戳获取月-日
+ (NSString *)dateStringFromStamp:(NSInteger)stamp;

//16进制转化rgb颜色
+ (UIColor *)getColor:(NSString *)hexColor;

//获取随机数包括from 包括to
+ (int)getRandomNumber:(int)from to:(int)to;

//添加底边框
+ (void)addBottomBorder:(UIView *)view color:(CGColorRef)color borderWidth:(float)borderWidth;

//去除webview阴影
+ (void)removeShadowFromWebview:(UIWebView *)webview;

//加载缓存数据优先从沙盒然后app目录
+ (NSDictionary *)loadCacheData:(NSString *)pathName;

//计算至今的时间差
+ (NSString *)intervalSinceNow: (NSString *) theDate;

//获取今日时间戳
+ (NSInteger)todayStamp;

//获取当前时间戳
+ (NSInteger)getNowStamp;

//获取日期
+ (NSString *)getStringFromDate:(NSDate *)date;

//获取屏幕尺寸大小
+ (CGFloat)applicationSreenInch;

//获取整型版本号字符串
+ (NSString *)appVersion;

/** 获取当前活动VC */
+ (UIViewController *)getCurrentViewController;

//去除字符串左右两边的空格
+ (NSString *)trim:(NSString *)string;

//是否包含特殊字符
+ (BOOL)isIncludeSpecialCharact:(NSString *)string;

//是否是手机号
+ (BOOL)isMobile:(NSString *)string;

//是否为6位验证码
+ (BOOL)isCode:(NSString *)string;

//判断身份证号是否有效
+ (BOOL)validateIDCardNumber:(NSString *)value;

@end
