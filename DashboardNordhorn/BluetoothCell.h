//
//  BluetoothCell.h
//  DashboardNordhorn
//
//  Created by Hu, Hao on 01/06/16.
//  Copyright © 2016 SAP SE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BluetoothCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *deviceName;
@property (weak, nonatomic) IBOutlet UILabel *deviceId;

@end
