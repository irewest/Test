//
//  BaseNavigationController.m
//  babyweekend
//
//  Created by IreWesT on 15/6/24.
//  Copyright (c) 2015年 IreWesT. All rights reserved.
//

#import "BaseNavigationController.h"

@implementation BaseNavigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

- (BOOL)shouldAutorotate {
    
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return self.topViewController.supportedInterfaceOrientations;
}

@end
