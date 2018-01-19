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

@interface FSDDropdownPicker<__covariant ItemType: id<FSDPickerItemProtocol>> : UIBarButtonItem

/**
 *  The delegate
 */
@property (weak, nonatomic) id <FSDDropdownPickerDelegate> delegate;

/**
 *  If the picker is currently dropped down or not
 */
@property (assign, nonatomic, readonly) BOOL isDropped;

/**
 *  The current selected option from the dropdown picker
 */
@property (strong, nonatomic) ItemType selectedOption;

/**
 *  The height of each option in the dropdown picker
 */
@property (assign, nonatomic) CGFloat rowHeight;

/**
 *  Whether to show images when the picker drops down or not
 */
@property (assign, nonatomic) BOOL displaysImageInList;

/**
 *  Color of the dropdown view
 */
@property (strong, nonatomic) UIColor* dropdownBackgroundColor;

/**
 *  The tableView that will display the options when dropped down
 */
@property (strong, nonatomic, readonly) UITableView *tableView;


/**
 *  The array of options id<FSDPickerItemProtocol> to be selected
 */
@property (strong, nonatomic, readonly) NSArray <ItemType>*options;

/**
 *  Initialize a FSDDropdownpicker instance given a list of items to display
 *
 *  @param options array containing id<FSDPickerItemProtocol> items to be displayed
 *
 *  @return FSDDropdownPicker instance
 */
- (instancetype)initWithOptions:(NSArray<ItemType> *)options;

/**
 *  Shows the dropdown list
 *
 *  @param animated If the dropdown should show animated
 */
- (void)showDropdownAnimated:(BOOL)animated;

/**
 *  Hides the dropdown list
 *
 *  @param animated If the dropdown should hide animated
 */
- (void)hideDropdownAnimated:(BOOL)animated;


/**
 *  Togges the dropdown show/hide
 */
- (void)toggleDropdown;

@end


@protocol FSDDropdownPickerDelegate <NSObject>

/**
 *  Called when the user selects an option from the dropdown
 *
 *  @param dropdownPicker the picker that received the event
 *  @param option         the selected option
 *
 *  @return whether the dropdown should dismiss or not
 */
- (BOOL)dropdownPicker:(FSDDropdownPicker *)dropdownPicker didSelectOption:(id <FSDPickerItemProtocol> )option;


/**
 *  Called when the dropdown picker shows or dismisses
 *
 *  @param dropdownPicker the dropdown picker
 *  @param drop           YES if picker was shown, NO if it was hidden
 */
@optional
- (void)dropdownPicker:(FSDDropdownPicker *)dropdownPicker didDropDown:(BOOL)drop;


/**
 *  Called to display an option in the list
 *
 *  @param dropdownPicker the dropdown picker
 *  @param option         the option to be displayed in the dropdown list
 *
 *  @return a tableView cell to be displayed in the list
 */
@optional
- (UITableViewCell*)dropdownPicker:(FSDDropdownPicker *)dropdownPicker cellForOption:(id<FSDPickerItemProtocol>)option;


@end
