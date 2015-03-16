//
//  UINavigationItem+FSDPicker.h
//  FSDDropdownPicker
//
//  Created by Felix Dumit on 3/7/15.
//  Copyright (c) 2015 Felix Dumit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSDDropdownPicker.h"

@interface UINavigationItem (FSDPicker)

- (FSDDropdownPicker *)addDropdownPickerWithOptions:(NSArray *)options;

@end
