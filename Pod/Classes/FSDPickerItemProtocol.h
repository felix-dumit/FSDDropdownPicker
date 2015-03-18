//
//  FSDPickerItemProtocol.h
//  FSDDropdownPickerExample
//
//  Created by Felix Dumit on 3/6/15.
//  Copyright (c) 2015 Felix Dumit. All rights reserved.
//

#ifndef FSDDropdownPickerExample_FSDPickerItemProtocol_h
#define FSDDropdownPickerExample_FSDPickerItemProtocol_h

@class UIImage;

/**
 *  Object added to the FSDDropdownPicker must conform to this protocol
 */
@protocol FSDPickerItemProtocol <NSObject>

- (NSString *)name;
- (UIImage *)image;

@end

#endif
