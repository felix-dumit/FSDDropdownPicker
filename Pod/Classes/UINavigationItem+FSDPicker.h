//
//  UINavigationItem+FSDPicker.h
//  FSDDropdownPicker
//
//  Created by Felix Dumit on 3/7/15.
//  Copyright (c) 2015 Felix Dumit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSDDropdownPicker.h"

typedef NS_ENUM(NSUInteger, FSDDropdownPickerNavigationPosition) {
    FSDDropdownPickerNavigationPositionLeft,
    FSDDropdownPickerNavigationPositionRight,
};

@interface UINavigationItem (FSDPicker)

/**
 *  Adds a dropdown picker to the navigation item
 *
 *  @param options the array of options to be displayed
 *
 *  @return FSDDropdown picker instance
 */
- (FSDDropdownPicker *)addDropdownPickerWithOptions:(NSArray *)options;


/**
 Adds a dropdown picker to the navigation item

 @param options array of options to be displayed
 @param position position of the bar item in the navigation item. (left of right)
 @return the picker instance
 */
- (FSDDropdownPicker *)addDropdownPickerWithOptions:(NSArray *)options atPosition:(FSDDropdownPickerNavigationPosition)position;

@end
