# FSDDropdownPicker

<!--[![CI Status](http://img.shields.io/travis/felix-dumit/FSDDropdownPicker.svg?style=flat)](https://travis-ci.org/felix-dumit/FSDDropdownPicker)-->
[![Version](https://img.shields.io/cocoapods/v/FSDDropdownPicker.svg?style=flat)](http://cocoadocs.org/docsets/FSDDropdownPicker)
[![License](https://img.shields.io/cocoapods/l/FSDDropdownPicker.svg?style=flat)](http://cocoadocs.org/docsets/FSDDropdownPicker)
[![Platform](https://img.shields.io/cocoapods/p/FSDDropdownPicker.svg?style=flat)](http://cocoadocs.org/docsets/FSDDropdownPicker)

## Example

![Example](http://gifyu.com/images/temp2.gif)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Create instance
You can create an intance directly by passing in an `NSArray<id<FSDPickerItemProtocol>>*` , if you just want an item with a name and image you can use the provided `FSDPickerItem` :

```objc
FSDPickerItem* item1 = [[FSDPickerItem alloc] initWithName:@"name" andImage:[UIImage imageNamed:@"1"]];
...    
FSDDropdownPicker *picker = [[FSDDropdownPicker alloc] initWithOptions:@[item1]];    
```
You will then have to add it to your view manually. You can alternatively use a convenience method to directly add the picker to the right or left of a navigation bar:

```objc 
FSDDropdownPicker *picker =  [self.navigationItem addDropdownPickerWithOptions:@[item1, item2, item3] atPosition:FSDDropdownPickerNavigationPositionRight];
```

The dropdown picker will dismiss if you tap the dropdown button again, or if you tap outside the view and you have `shouldHideOnOutsideTap` turned on.

### FSDDropdownPickerDelegate
> The delegate can respond to the following events:

```objc
picker.delegate = self;

- (void)dropdownPicker:(FSDDropdownPicker *)dropdownPicker didDropDown:(BOOL)drop {
    //do something when the picker dropped down or up
}
```

```objc
- (BOOL)dropdownPicker:(FSDDropdownPicker *)dropdownPicker 	didSelectOption:(id <FSDPickerItemProtocol> )option {
	// called when user selects an option
}
```

### Customization
> You can customize the following options: 

```objc
/**
 *  The height of each option in the dropdown picker
 */
@property (assign, nonatomic) CGFloat rowHeight;

/**
 *  Whether to show images when the picker drops down or not
 */
@property (assign, nonatomic) BOOL displaysImageInList;


/**
 *  The list separator style for the picker items
 */
@property (assign, nonatomic) UITableViewCellSeparatorStyle listSeparator;

/**
*  If the dropdown should hide when a tap outside (rest of window) happens. Default= YES
*/
@property (assign, nonatomic) BOOL shouldHideOnOutsideTap;

```
## Installation

 FSDDropdownPicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "FSDDropdownPicker"
 
  Or to view the example project:
    ```
    pod try "FSDDropdownPicker"
    ```

 
 Pull requests or any suggestions are **welcome**

## Author

Felix Dumit, felix.dumit@gmail.com

## License

FSDDropdownPicker is available under the MIT license. See the LICENSE file for more info.

