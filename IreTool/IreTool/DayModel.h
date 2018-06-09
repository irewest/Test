//
//  DayModel.h
//  IreTool
//
//  Created by IreWesT on 2016/10/8.
//  Copyright © 2016年 IreWesT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DayModel : NSObject

@property (nonatomic, retain) NSDate    *date;
@property (nonatomic, copy) NSString    *dateString;
@property (nonatomic, assign) NSInteger count;

- (id)initWithDate:(NSString *)dateString withCount:(NSInteger)count;

@end
