//
//  BluetoothSearchViewController.m
//  DashboardNordhorn
//
//  Created by Hu, Hao on 01/06/16.
//  Copyright © 2016 SAP SE. All rights reserved.
//

#import "BluetoothSearchViewController.h"
#import "BluetoothCell.h"



@interface BluetoothSearchViewController ()<UITableViewDataSource, UITableViewDelegate, BTSmartSensorDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong, nonatomic) NSMutableArray* bluetoothDevices;



@end

@implementation BluetoothSearchViewController

- (IBAction)doneButtonDidClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bluetoothDevices = [NSMutableArray array];
    
    self.serialGatt.delegate = self;
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
   
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scanDevice:) userInfo:nil repeats:NO];
}


-(void) scanDevice:(NSTimer*) sender{
    [self.serialGatt findHMSoftPeripherals:15];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bluetoothDevices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* cellId = @"bluetoothCell";
    BluetoothCell* cell = (BluetoothCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
    CBPeripheral* p = self.bluetoothDevices[indexPath.row];
    cell.deviceName.text = p.name;
    cell.deviceId.text = p.identifier.UUIDString;
    return cell;
}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CBPeripheral* p = self.bluetoothDevices[indexPath.row];
    self.serialGatt.activePeripheral = p;
    [self.serialGatt stopScan];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidSelectDevice" object:self userInfo:nil];
}



- (void) peripheralFound:(CBPeripheral *)peripheral{
    
    [self.bluetoothDevices addObject:peripheral];
    [self.tableView reloadData];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}


@end
