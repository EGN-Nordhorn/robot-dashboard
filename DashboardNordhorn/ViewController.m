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


#define GREEN_COLOR [UIColor colorWithRed:0.14 green:0.73 blue:0.41 alpha:1]
#define RED_COLOR   [UIColor colorWithRed:0.87 green:0.18 blue:0.28 alpha:1]
#define YELLOW_COLOR [UIColor colorWithRed:0.87 green:0.82 blue:0.16 alpha:1]


@interface ViewController ()<BTSmartSensorDelegate>

//Start UI outlets.
@property (weak, nonatomic) IBOutlet KNCirclePercentView *humidityView;


@property (weak, nonatomic) IBOutlet UILabel *lblMositure;

@property (weak, nonatomic) IBOutlet UILabel *airTemp;
@property (weak, nonatomic) IBOutlet UILabel *groundTemp;

@property (weak, nonatomic) IBOutlet CircleView *mositure;

@property (weak, nonatomic) IBOutlet CircleView *gasAlertView;
@property (weak, nonatomic) IBOutlet CircleView *bluetoothStateView;


//End UI outlets
@property (strong, nonatomic) SerialGATT* serialGatt;



@property(strong, nonatomic) CBPeripheral* remoteRobot;

@property (assign, nonatomic) BOOL isFirstTime;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirstTime = YES;

    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"UserDidSelectDevice"
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * note) {
                                                      
                                                      _serialGatt.delegate = self;
                                                       self.remoteRobot = _serialGatt.activePeripheral;
                                                      [_serialGatt connect:self.remoteRobot];
                                                      
    }];
    
    self.bluetoothStateView.backgroundColor = RED_COLOR;
    
        // Do any additional setup after loading the view, typically from a nib.
   
  
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.isFirstTime){
        self.isFirstTime = NO;
        [self performSegueWithIdentifier:@"bluetooth" sender:nil];
    }
    
    
    [self drawChart];
}


-(void) drawChart{
    self.humidityView.backgroundColor = [UIColor clearColor];
    
    
    
    
    [self.humidityView drawCircleWithPercent:67
                                    duration:2
                                   lineWidth:20
                                   clockwise:YES
                                     lineCap:kCALineCapRound
                                   fillColor:[UIColor clearColor]
                                 strokeColor:[UIColor colorWithRed:0.13f green:0.6f blue:0.83f alpha:1]
                              animatedColors:nil];
    
    self.humidityView.percentLabel.font = [UIFont systemFontOfSize:20];
    self.humidityView.percentLabel.textColor = [UIColor whiteColor];
    
    
    
    
    
    
    [self.humidityView startAnimation];
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



//void sendCSVData(float tempAir, float moisture, int gasAlert, float tempGround,float humidity, float direction)


-(void) updateStatusWithNewString: (NSString*) statusString {
    
    NSLog(@"Status string is %@", statusString);
    NSArray* comps = [statusString componentsSeparatedByString:@"/"];
    
    NSLog(@"Comps is %lu", (unsigned long)comps.count);
    if (comps.count == 5) {
        
        NSLog(@"corrent format!");
        float tempAir = [comps[0] floatValue];
        float humidy = [comps[1] floatValue];
        float tempGround = [comps[2] floatValue];
        float moisture = [comps[3] floatValue];
        int gasAlert = [comps[4] floatValue];
        
        [self updateHumidiy:humidy];
        [self updateMosiure:moisture];
        [self updateAirTemp:tempAir];
        [self updateGasAlert:gasAlert];
        [self updateGroundTemp:tempGround];
        
        NSLog(@"Status is  %f, %f, %d, %f, %f", tempAir, moisture, gasAlert, tempGround, humidy);
        
    }
}



-(void) updateStatus:(NSString*) csvString{
    NSArray* comps = [csvString componentsSeparatedByString:@","];
    if (comps.count != 6){
        NSLog(@"Invalid format.");
    } else {
        float tempAir = [comps[0] floatValue];
        float moisture = [comps[1] floatValue];
        int gasAlert = [comps[2] floatValue];
        float tempGround = [comps[3] floatValue];
        float humidy = [comps[4] floatValue];
        float direction = [comps[5] floatValue];
        
        [self updateHumidiy:humidy];
        [self updateMosiure:moisture];
        [self updateAirTemp:tempAir];
        [self updateGasAlert:gasAlert];
        [self updateGroundTemp:tempGround];
        NSLog(@"Status is : ");
        NSLog(@"%f, %f, %d, %f, %f, %f", tempAir, moisture, gasAlert, tempGround, humidy, direction);
        
    }
    
}

#pragma - Bluetooth

- (void) serialGATTCharValueUpdated: (NSString *)UUID value: (NSData *)data{
    
    NSString* displayString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self updateStatusWithNewString:displayString];
    
//    NSLog(@"Dispay %@", displayString);
//    
//    
//    
//    UInt8 bytes_to_find[] = { 0x0D, 0x0A };
//    NSData *dataToFind = [NSData dataWithBytes:bytes_to_find
//                                        length:sizeof(bytes_to_find)];
//    
//    NSRange rangeOfData = [data rangeOfData:dataToFind options:0 range:NSMakeRange(0, data.length)];
//    
//    if (rangeOfData.location != NSNotFound) {
//        NSLog(@"Find the end");
//        NSString* stringData = [[NSString alloc] initWithData:[self.receivedData copy] encoding:NSUTF8StringEncoding];
//        [self updateStatus:stringData];
//        NSLog(@"%@", stringData);
//    }
    
    
    
//    [self updateHumidiy:stringData.floatValue];
}
- (void) setConnect{
    self.bluetoothStateView.backgroundColor = GREEN_COLOR;
}
- (void) setDisconnect{
    self.bluetoothStateView.backgroundColor = RED_COLOR;
}

#pragma mark - Update status


-(void) updateHumidiy:(CGFloat) percentagte{
    [self.humidityView drawCircleWithPercent:percentagte
                                    duration:0.1
                                   lineWidth:20
                                   clockwise:YES
                                     lineCap:kCALineCapRound
                                   fillColor:[UIColor clearColor]
                                 strokeColor:[UIColor colorWithRed:0.13f green:0.6f blue:0.83f alpha:1]
                              animatedColors:nil];
}



-(void) updateAirTemp:(CGFloat) tempAir{
    int temp = tempAir;
    self.airTemp.text = [NSString stringWithFormat:@"%d", temp];
    
}

-(void) updateGroundTemp:(CGFloat) tempGround {
    int temp = tempGround;
    self.groundTemp.text = [NSString stringWithFormat:@"%d", temp];
    
}


-(void) updateMosiure:(CGFloat) moisture {
    
    int temp = moisture;
    
    self.lblMositure.text = [NSString stringWithFormat:@"%d", temp];
    if (moisture < 250){
        self.mositure.backgroundColor = GREEN_COLOR;
    } else if (moisture > 250 && moisture < 500){
        self.mositure.backgroundColor = YELLOW_COLOR;
    } else if (moisture > 500) {
        self.mositure.backgroundColor = RED_COLOR;
    }
}


/**
 *  Update the gas alert value.
 *
 *  @param gasAlert The value could be from 0 - 3v
 */
-(void) updateGasAlert:(int) gasAlert {
    
    if (gasAlert >2){
        self.gasAlertView.backgroundColor = GREEN_COLOR;
    } else {
       self.gasAlertView.backgroundColor = RED_COLOR;
    }
}






@end
