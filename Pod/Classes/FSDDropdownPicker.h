//
//  DropDownTableView.h
//  Umwho
//
//  Created by Felix Dumit on 12/24/14.
//  Copyright (c) 2014 Umwho. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "FSDPickerItemProtocol.h"


@protocol FSDDropdownPickerDelegate;

@interface FSDDropdownPicker : UIBarButtonItem

@property (weak, nonatomic) id <FSDDropdownPickerDelegate> delegate;
@property (assign, nonatomic, readonly) BOOL isDropped;
@property (strong, nonatomic) id <FSDPickerItemProtocol> selectedOption;
@property (assign, nonatomic) CGFloat rowHeight;
@property (assign, nonatomic) BOOL displaysImageInList;
@property (assign, nonatomic) UITableViewCellSeparatorStyle listSeparator;

- (instancetype)initWithOptions:(NSArray *)options;

- (void)showDropdownAnimated:(BOOL)animated;
- (void)hideDropdownAnimated:(BOOL)animated;
- (void)toggleDropdown;

@end


@protocol FSDDropdownPickerDelegate <NSObject>

- (BOOL)dropdownPicker:(FSDDropdownPicker *)dropdownPicker didSelectOption:(id <FSDPickerItemProtocol> )option;
@optional
- (void)dropdownPicker:(FSDDropdownPicker *)dropdownPicker didDropDown:(BOOL)drop;

@end
