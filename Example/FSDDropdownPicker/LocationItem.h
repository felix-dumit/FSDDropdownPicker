//
//  LocationItem.h
//  FSDDropdownPicker
//
//  Created by Felix Dumit on 3/7/15.
//  Copyright (c) 2015 Felix Dumit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <FSDDropdownPicker/FSDPickerItemProtocol.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationItem : NSObject <FSDPickerItemProtocol>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

@end
