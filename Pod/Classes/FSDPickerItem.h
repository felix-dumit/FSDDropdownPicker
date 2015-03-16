//
//  FSDPickerItem.h
//  FSDDropdownPickerExample
//
//  Created by Felix Dumit on 3/6/15.
//  Copyright (c) 2015 Felix Dumit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSDPickerItemProtocol.h"
#import <UIKit/UIKit.h>


@interface FSDPickerItem : NSObject <FSDPickerItemProtocol>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *image;


- (instancetype)initWithName:(NSString *)name andImage:(UIImage *)image;


@end
