//
//  DayModel.m
//  IreTool
//
//  Created by IreWesT on 2016/10/8.
//  Copyright © 2016年 IreWesT. All rights reserved.
//

#import "DayModel.h"
#import "UIUtils.h"

@implementation DayModel

- (id)initWithDate:(NSString *)dateString withCount:(NSInteger)count {
    
    if (self = [super init]) {
        _dateString = dateString;
        _date = [UIUtils dateFromFomate:dateString formate:@"yyyy-MM-dd"];
        _count = count;
    }
    return self;
}

@end
