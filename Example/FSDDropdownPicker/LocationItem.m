//
//  LocationItem.m
//  FSDDropdownPicker
//
//  Created by Felix Dumit on 3/7/15.
//  Copyright (c) 2015 Felix Dumit. All rights reserved.
//

#import "LocationItem.h"

@implementation LocationItem

-(UIImage *)image {
    return [self.flag imageWithStyle:FKFlagStyleRoundedRect];
}

@end

