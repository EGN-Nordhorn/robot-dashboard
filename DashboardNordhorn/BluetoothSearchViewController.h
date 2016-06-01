//
//  BluetoothSearchViewController.h
//  DashboardNordhorn
//
//  Created by Hu, Hao on 01/06/16.
//  Copyright © 2016 SAP SE. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SerialGATT.h"

@interface BluetoothSearchViewController : UIViewController
@property(strong, nonatomic) SerialGATT* serialGatt;
@end
