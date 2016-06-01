//
//  ViewController.m
//  DashboardNordhorn
//
//  Created by  on 30/05/16.
//  Copyright © 2016 SAP SE. All rights reserved.
//

#import "ViewController.h"
#import "KNCirclePercentView.h"
#import "BluetoothSearchViewController.h"
#import "SerialGATT.h"
#import "CircleView.h"

@interface ViewController ()<BTSmartSensorDelegate>
@property (weak, nonatomic) IBOutlet KNCirclePercentView *humidityView;
@property (weak, nonatomic) IBOutlet KNCirclePercentView *moisture;
@property (weak, nonatomic) IBOutlet KNCirclePercentView *metalContent;


@property (weak, nonatomic) IBOutlet CircleView *bluetoothStateView;
@property (strong, nonatomic) SerialGATT* serialGatt;


@property(strong, nonatomic) CBPeripheral* remoteRobot;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"UserDidSelectDevice"
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * note) {
                                                      
                                                      _serialGatt.delegate = self;
                                                       self.remoteRobot = _serialGatt.activePeripheral;
                                                      [_serialGatt connect:self.remoteRobot];
                                                      
    }];
    
    self.bluetoothStateView.backgroundColor = [UIColor redColor];
    
        // Do any additional setup after loading the view, typically from a nib.
    
  
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
      [self drawChart];
}


-(void) drawChart{
    self.humidityView.backgroundColor = [UIColor clearColor];
    self.moisture.backgroundColor = [UIColor clearColor];
    self.metalContent.backgroundColor = [UIColor clearColor];
    
    
    [self.humidityView drawCircleWithPercent:67
                                    duration:2
                                   lineWidth:15
                                   clockwise:YES
                                     lineCap:kCALineCapRound
                                   fillColor:[UIColor clearColor]
                                 strokeColor:[UIColor colorWithRed:0.13f green:0.6f blue:0.83f alpha:1]
                              animatedColors:nil];
    
    self.humidityView.percentLabel.font = [UIFont systemFontOfSize:20];
    self.humidityView.percentLabel.textColor = [UIColor whiteColor];
    
    
    
    
    [self.moisture drawCircleWithPercent:65
                                duration:2
                               lineWidth:20
                               clockwise:YES
                                 lineCap:kCALineCapRound
                               fillColor:[UIColor clearColor]
                             strokeColor:[UIColor colorWithRed:0.13f green:0.6f blue:0.83f alpha:1]
                          animatedColors:nil];
    
    
    
    self.moisture.percentLabel.font = [UIFont systemFontOfSize:20];
    self.moisture.percentLabel.textColor = [UIColor whiteColor];
    
    
    
    
    [self.metalContent drawCircleWithPercent:13
                                    duration:2
                                   lineWidth:15
                                   clockwise:YES
                                     lineCap:kCALineCapRound
                                   fillColor:[UIColor clearColor]
                                 strokeColor:[UIColor orangeColor]
                              animatedColors:nil];
    
    
    
    
    
    self.metalContent.percentLabel.font = [UIFont systemFontOfSize:20];
    self.metalContent.percentLabel.textColor = [UIColor whiteColor];
    
    
    [self.metalContent startAnimation];
    [self.humidityView startAnimation];
    [self.moisture startAnimation];
}



-(void) updateHumidiy:(CGFloat) percentagte{
    [self.humidityView drawCircleWithPercent:percentagte
                                    duration:0.1
                                   lineWidth:15
                                   clockwise:YES
                                     lineCap:kCALineCapRound
                                   fillColor:[UIColor clearColor]
                                 strokeColor:[UIColor colorWithRed:0.13f green:0.6f blue:0.83f alpha:1]
                              animatedColors:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    BluetoothSearchViewController* btVc = (BluetoothSearchViewController*)  segue.destinationViewController;
    self.serialGatt = [[SerialGATT alloc] init];
    [self.serialGatt setup];
    btVc.serialGatt = self.serialGatt;
}


#pragma - Bluetooth

- (void) serialGATTCharValueUpdated: (NSString *)UUID value: (NSData *)data{
    NSString* stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Data is %@", stringData);
    [self updateHumidiy:stringData.floatValue];
}
- (void) setConnect{
    self.bluetoothStateView.backgroundColor = [UIColor greenColor];
}
- (void) setDisconnect{
    self.bluetoothStateView.backgroundColor = [UIColor redColor];
}


@end
