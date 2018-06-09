//
//  NSString+MD5.h
//  IrewestTool
//
//  Created by IreWesT on 2016/12/26.
//  Copyright © 2016年 IreWesT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (MD5)

- (NSString *)md5HexDigest;

+ (NSString *)shortUrl:(NSString *)url;

@end
