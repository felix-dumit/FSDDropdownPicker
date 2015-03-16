//
//  FSDPickerItem.m
//  FSDDropdownPickerExample
//
//  Created by Felix Dumit on 3/6/15.
//  Copyright (c) 2015 Felix Dumit. All rights reserved.
//

#import "FSDPickerItem.h"

@implementation FSDPickerItem

- (instancetype)initWithName:(NSString *)name andImage:(UIImage *)image {
    if (self = [super init]) {
        self.name = name;
        self.image = image;
    }
    return self;
}

@end
