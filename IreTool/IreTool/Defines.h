//
//  Defines.h
//  IreTool
//
//  Created by IreWesT on 2016/10/8.
//  Copyright © 2016年 IreWesT. All rights reserved.
//

#ifndef Defines_h
#define Defines_h

//Screen size
#define APP_SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define APP_SCREEN_HEIGHT           [UIScreen mainScreen].bounds.size.height

#define NavHeight                   64
#define StatusBarHeight             20
#define CUSTOM_NAV_HEIGHT           44
#define CUSTOM_TABBAR_HEIGHT        49
#define DefaultViewBackgroundColor  RGBCOLOR(255, 255, 255)
#define DefaultBorderColor          RGBCOLOR(216, 216, 219)

#define RGBCOLOR(r,g,b)             [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define HomeDirectory               [NSHomeDirectory() stringByAppendingString:@"/Documents/"]

#endif /* Defines_h */

#ifdef DEBUG

#define NSLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)

#endif
