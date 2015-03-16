//
//  UINavigationItem+FSDPicker.m
//  FSDDropdownPicker
//
//  Created by Felix Dumit on 3/7/15.
//  Copyright (c) 2015 Felix Dumit. All rights reserved.
//

#import "UINavigationItem+FSDPicker.h"


@implementation UINavigationItem (FSDPicker)

- (FSDDropdownPicker *)addDropdownPickerWithOptions:(NSArray *)options {
    FSDDropdownPicker *picker = [[FSDDropdownPicker alloc] initWithOptions:options];
    self.rightBarButtonItem = picker;
    return picker;
}

@end
