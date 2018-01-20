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
    return [self addDropdownPickerWithOptions:options atPosition:FSDDropdownPickerNavigationPositionRight];
}

-(FSDDropdownPicker *)addDropdownPickerWithOptions:(NSArray *)options atPosition:(FSDDropdownPickerNavigationPosition)position {
    FSDDropdownPicker *picker = [[FSDDropdownPicker alloc] initWithOptions:options];
    switch (position) {
        case FSDDropdownPickerNavigationPositionLeft:
            self.leftBarButtonItem = picker;
            break;
        case FSDDropdownPickerNavigationPositionRight:
            self.rightBarButtonItem = picker;
    }
    return picker;
}

@end
