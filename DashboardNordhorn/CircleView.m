//
//  CircleView.m
//  DashboardNordhorn
//
//  Created by Hu, Hao on 30/05/16.
//  Copyright © 2016 SAP SE. All rights reserved.
//

#import "CircleView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CircleView


- (void)drawRect:(CGRect)rect {
    CGFloat height = self.frame.size.width;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = height / 2;
}

@end
