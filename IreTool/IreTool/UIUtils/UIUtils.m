//
//  UIUtils.m
//  WXTime
//
//  Created by wei.chen on 12-7-22.
//  Copyright (c) 2012年 www.iphonetrain.com 无限互联ios开发培训中心 All rights reserved.
//

#import "UIUtils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation UIUtils

+ (NSString *)getDocumentsPath:(NSString *)fileName {
    
    //两种获取document路径的方式
//    NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documents = [paths objectAtIndex:0];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    
    return path;
}

+ (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:formate];
  
  NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
  [formatter setTimeZone:timeZone];
  
  NSString *str = [formatter stringFromDate:date];
  return str;
}

+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];

    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [formatter setTimeZone:timeZone];

    NSDate *date = [formatter dateFromString:datestring];

    if (!date) {
        date = [NSDate date];
    }
    
    return date;
}

//Sat Jan 12 11:50:16 +0800 2013
+ (NSString *)fomateString:(NSString *)datestring {
    NSString *formate = @"E MMM d HH:mm:ss Z yyyy";
    NSDate *createDate = [UIUtils dateFromFomate:datestring formate:formate];
    NSString *text = [UIUtils stringFromFomate:createDate formate:@"MM-dd HH:mm"];
    return text;
}

//获取时间戳
+ (NSInteger)stampFromDateString:(NSString *)dateString
{
    NSDate *date = [UIUtils dateFromFomate:dateString formate:@"yyyy-MM-dd"];
    return date.timeIntervalSince1970;
}

+ (NSString *)dateStringFromStamp:(NSInteger)stamp
{
    return [UIUtils stringFromFomate:[NSDate dateWithTimeIntervalSince1970:stamp]
                             formate:@"MM月dd日"];
}

+ (NSInteger)todayStamp
{
    return [UIUtils stampFromDateString:[UIUtils stringFromFomate:[NSDate date] formate:@"yyyy-MM-dd"]];
}

+ (UIColor *)getColor:(NSString *)hexColor {
  unsigned int red,green,blue;
  NSRange range;
  range.length = 2;
  range.location = 0;
  [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
  range.location = 2;
  [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
  range.location = 4;
  [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
  return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}

+ (int)getRandomNumber:(int)from to:(int)to{
  int a= arc4random() % (to - from + 1);
  return (int)(from + a);
  
}

//添加底边框
+ (void)addBottomBorder:(UIView *)view color:(CGColorRef)color borderWidth:(float)borderWidth {
  CALayer *bottomBorder = [CALayer layer];
  float height=view.frame.size.height-borderWidth;
  float width=view.frame.size.width;
  bottomBorder.frame = CGRectMake(0.0f, height, width, borderWidth);
  bottomBorder.backgroundColor = color;
  [view.layer addSublayer:bottomBorder];
}


+ (void)removeShadowFromWebview:(UIWebView *)webview {
  for( UIView *view in [webview subviews] ) {
    if( [view isKindOfClass:[UIScrollView class]] ) {
      for( UIView *innerView in [view subviews] ) {
        if( [innerView isKindOfClass:[UIImageView class]] ) {
          innerView.hidden = YES;
        }
      }
    }
  }
}

+ (NSDictionary *)loadCacheData:(NSString *)pathName {
  NSString *path = [[NSHomeDirectory() stringByAppendingString:@"/Documents/"] stringByAppendingString:[NSString stringWithFormat:@"%@.plist",pathName]];
  NSString *plist = [[NSBundle mainBundle] pathForResource:pathName ofType:@"plist"];
  NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:path] ? [[NSDictionary alloc] initWithContentsOfFile:path] : [[NSDictionary alloc] initWithContentsOfFile:plist];
  return data;
}

+ (NSString *)intervalSinceNow:(NSString *) theDate {
  NSDateFormatter *date=[[NSDateFormatter alloc] init];
  [date setDateFormat:@"MM/dd/yyyy HH:mm"];
  NSDate *d=[date dateFromString:theDate];
  
  NSTimeInterval late=[d timeIntervalSince1970]*1;
  
  
  NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
  NSTimeInterval now=[dat timeIntervalSince1970]*1;
  NSString *timeString=@"";
  
  NSTimeInterval cha=now-late;
  if (cha/3600<1) {
    timeString = [NSString stringWithFormat:@"%f", cha/60];
    timeString = [timeString substringToIndex:timeString.length-7];
    if ([timeString isEqualToString:@"0"]) {
      timeString = @"刚刚更新";
    }else
    {
      timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }
  }
  if (cha/3600>1&&cha/86400<1) {
    timeString = [NSString stringWithFormat:@"%f", cha/3600];
    timeString = [timeString substringToIndex:timeString.length-7];
    timeString=[NSString stringWithFormat:@"%@小时前", timeString];
  }
  if (cha/86400>1)
  {
    timeString = [NSString stringWithFormat:@"%f", cha/86400];
    timeString = [timeString substringToIndex:timeString.length-7];
    timeString=[NSString stringWithFormat:@"%@天前", timeString];
    
  }
  return timeString;
}


//获取当前时间戳
+ (NSInteger)getNowStamp
{
    NSDate *fromdate = [NSDate date];
    NSInteger time = [fromdate timeIntervalSince1970];
    return time;
}

//获取日期
+ (NSString *)getStringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString;
    if (date == nil) {
        destDateString = [dateFormatter stringFromDate:[NSDate date]];
    }else {
        destDateString = [dateFormatter stringFromDate:date];
    }
    
    return destDateString;
}

//获取屏幕尺寸大小
+ (CGFloat)applicationSreenInch{
    CGFloat height = [UIScreen mainScreen].bounds.size.height;

    if (height == 736) {
        return 5.5;
    }else if (height == 667) {
        return 4.7;
    }else if (height == 568) {
        return 4;
    }else {
        return 3.5;
    }
}

//获取整型版本号字符串
+ (NSString *)appVersion {

    return [NSString stringWithFormat:@"%ld", (long)[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] integerValue]];
}

//获取当前活动Controller
+ (UIViewController *)getCurrentViewController {
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    if ([result isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbar = (UITabBarController *)result;
        UINavigationController *nav = tabbar.viewControllers[tabbar.selectedIndex];
        if ([nav isKindOfClass:[UINavigationController class]]) {
            UIViewController *controller = nav.viewControllers[nav.viewControllers.count - 1];
            return controller;
        }
    }
    
    return result;
}

//去除字符串左右两边的空格
+ (NSString *)trim:(NSString *)string {
    
    NSString *cleanString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return cleanString;
}

//是否包含特殊字符
+ (BOOL)isIncludeSpecialCharact:(NSString *)string {
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [string rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"<>,'\""]];
    if (urgentRange.location == NSNotFound) {
        return NO;
    }
    return YES;
}

//是否是手机号
+ (BOOL)isMobile:(NSString *)string {
    
    NSString *phoneRegex = @"^1[0-9]{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:string];
}

//是否为6位验证码
+ (BOOL)isCode:(NSString *)string {
    
    NSString *regex = @"^[0-9]{4,6}$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:string];
}

+ (BOOL)validateIDCardNumber:(NSString *)value {
    
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSInteger length = 0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        
        if (length != 15 && length != 18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return NO;
    }
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year = 0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue + 1900;
            
            if (year %4 == 0 || (year %100 == 0 && year % 4 == 0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch > 0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year % 4 == 0 || (year % 100 == 0 && year % 4 == 0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch > 0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S % 11;
                NSString *M = @"F";
                NSString *M2 = @"F";
                NSString *JYM = @"10X98765432";
                NSString *JYM2 = @"10x98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                M2 = [JYM2 substringWithRange:NSMakeRange(Y,1)];// 判断校验位2
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]] ||
                    [M2 isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }
}

@end
