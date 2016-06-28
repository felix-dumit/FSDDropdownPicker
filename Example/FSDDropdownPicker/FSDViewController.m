//
//  FSDViewController.m
//  FSDDropdownPicker
//
//  Created by Felix Dumit on 03/07/2015.
//  Copyright (c) 2014 Felix Dumit. All rights reserved.
//

#import "FSDViewController.h"
#import "LocationItem.h"
#import <MapKit/MapKit.h>
@import FlagKit;
@import FSDDropdownPicker;

@interface FSDViewController () <FSDDropdownPickerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation FSDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LocationItem *item1 = [[LocationItem alloc] init];
    item1.name = @"Brasil";
    item1.image = [[UIImage alloc] initWithFlagImageWithCountryCode:@"BR"];
    item1.coordinate = CLLocationCoordinate2DMake(-15.7833, -47.8667);
    
    LocationItem *item2 = [[LocationItem alloc] init];
    item2.name = @"USA";
    item2.image = [[UIImage alloc] initWithFlagImageWithCountryCode:@"US"];
    item2.coordinate = CLLocationCoordinate2DMake(38.8833, -77.0167);
    
    LocationItem *item3 = [[LocationItem alloc] init];
    item3.name = @"Japan";
    item3.image = [[UIImage alloc] initWithFlagImageWithCountryCode:@"JP"];
    item3.coordinate = CLLocationCoordinate2DMake(35.6833, 139.7667);
    
    FSDDropdownPicker *picker =  [self.navigationItem addDropdownPickerWithOptions:@[item1, item2, item3]];
    picker.delegate = self;
    picker.displaysImageInList = YES;
    
    [self.mapView setCenterCoordinate:item1.coordinate];
    
    [picker.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableCell"];
}

#pragma mark - FSDDropdownPickerDelegate
- (void)dropdownPicker:(FSDDropdownPicker *)dropdownPicker didDropDown:(BOOL)drop {
    //do something when the picker dropped down or up
}

- (BOOL)dropdownPicker:(FSDDropdownPicker *)dropdownPicker didSelectOption:(id <FSDPickerItemProtocol> )option {
    NSLog(@"option selected: %@", [option name]);
    self.title = [option name];
    
    LocationItem *item = (LocationItem *)option;
    
    [self.mapView setCenterCoordinate:item.coordinate];
    
    //if the picker should dismiss
    return YES;
}

-(UITableViewCell *)dropdownPicker:(FSDDropdownPicker *)dropdownPicker cellForOption:(id<FSDPickerItemProtocol>)option {
    UITableViewCell* cell = [dropdownPicker.tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    cell.textLabel.text = option.name;
    cell.imageView.image = option.image;
    return cell;
}

@end
