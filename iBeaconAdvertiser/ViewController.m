//
//  ViewController.m
//  iBeaconAdvertiser
//
//  Created by Luis Abreu on 30/08/2013.
//  Copyright (c) 2013 lmjabreu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, strong) NSDictionary *peripheralData;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initPeripheralManager];
    [self setupPeripheralData];
}

- (void)setupPeripheralData
{
    // I belong to this major group (Apple)
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:@"96BF94BC-4C17-42D8-90B4-7ACBE7A8DEA0"];
    // I belong to this region (eg: Apple Store)
    NSString *regionIdentifier = @"AppleStore";
    // I am this type of beacon (eg: display)
    CLBeaconMajorValue major = 1;
    // With this subtype (eg: iphone)
    CLBeaconMinorValue minor = 1;
    
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                                     major:major
                                                                     minor:minor
                                                                identifier:regionIdentifier];
   
    self.peripheralData = [region peripheralDataWithMeasuredPower:nil];
}

- (void)initPeripheralManager
{
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"peripheral.isAdvertising: %hhd", peripheral.isAdvertising);
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failed to Advertise"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"Got it"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }

    NSLog(@"Advertising STARTED");
    [self.advertiseToggleButton setTitle:@"Stop Advertising" forState:UIControlStateNormal];
}

- (IBAction)advertiseToggleAction:(UIButton *)sender {
    if (self.peripheralManager.isAdvertising) {
        NSLog(@"Advertising STOPPED");
        [self.advertiseToggleButton setTitle:@"Start Advertising" forState:UIControlStateNormal];
        [self.peripheralManager stopAdvertising];
    } else {
        NSLog(@"Advertising WILL START");
        [self.peripheralManager startAdvertising:self.peripheralData];
    }
}
@end
