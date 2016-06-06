//
//  DropDownTableView.m
//  Umwho
//
//  Created by Felix Dumit on 12/24/14.
//  Copyright (c) 2014 Umwho. All rights reserved.
//


#import "FSDDropdownPicker.h"

@interface FSDDropdownPicker () <UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) CGRect originalFrame;
@property (assign, nonatomic) CGRect tableFrame;
@property (strong, nonatomic) NSArray *options;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIVisualEffectView *bluredEffectView;
@property (strong, nonatomic) UIView *tapOutView;
@property (strong, nonatomic) UIButton *actionButton;

@end

@implementation FSDDropdownPicker


- (instancetype)initWithOptions:(NSArray *)options {
    id <FSDPickerItemProtocol> firstItem = [options firstObject];
    UIImage *buttonImage = [firstItem image];
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [actionButton setImage:buttonImage forState:UIControlStateNormal];
    actionButton.frame = CGRectMake(0.0, 0.0, 44, 44); //buttonImage.size.width, buttonImage.size.height);
    
    if (self = [super initWithCustomView:actionButton]) {
        [actionButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        self.actionButton = actionButton;
        
        self.options = options;
        _isDropped = NO;
        _labelTextAlignment = NSTextAlignmentNatural;
        _dropdownBackgroundColor = [UIColor colorWithWhite:1.000 alpha:0.850];
        self.selectedOption = firstItem;
        
        self.displaysImageInList = NO;
        
        self.tapOutView = nil;
        
        self.rowHeight = 44.0f;
        
        self.listSeparator = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}

- (UINavigationBar *)navigationBar {
    return (UINavigationBar *)[self.customView superview];
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect navFrame = [self navigationBar].frame;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        BOOL greaterThanScreenSize = self.options.count * self.rowHeight > screenHeight - CGRectGetMaxY(navFrame);
        
        self.tableFrame = CGRectMake(CGRectGetMinX(navFrame), CGRectGetMaxY(navFrame), CGRectGetWidth(navFrame), MIN(screenHeight - CGRectGetMaxY(navFrame), self.options.count * self.rowHeight));
        
        _tableView = [[UITableView alloc] initWithFrame:self.tableFrame];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelection = YES;
        _tableView.scrollEnabled = greaterThanScreenSize;
        _tableView.separatorStyle = self.listSeparator;
        _tableView.rowHeight = self.rowHeight;
        _tableView.backgroundColor = self.dropdownBackgroundColor;
        
        [self hideDropdownAnimated:NO];
        
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.tableView.bounds];
        self.tableView.layer.masksToBounds = NO;
        self.tableView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.tableView.layer.shadowOffset = CGSizeMake(0.0f, 4.0f);
        self.tableView.layer.cornerRadius = 2.0f;
        self.tableView.layer.shadowOpacity = 0.3f;
        self.tableView.layer.shadowPath = shadowPath.CGPath;
    }
    
    if (!_tableView.superview) {
        [[self navigationBar].superview insertSubview:_tableView belowSubview:[self navigationBar]];
    }
    
    return _tableView;
}

- (void)buttonTapped:(id)sender {
    [self toggleDropdown];
}

- (void)setRowHeight:(CGFloat)rowHeight {
    _rowHeight = rowHeight;
    _tableView.rowHeight = rowHeight;
    CGRect tableFrame = self.tableFrame;
    tableFrame.size.height = self.options.count * rowHeight;
    self.tableFrame = tableFrame;
    [_tableView reloadData];
}

- (void)setDisplaysImageInList:(BOOL)displaysImageInList {
    _displaysImageInList = displaysImageInList;
}

- (void)setListSeparator:(UITableViewCellSeparatorStyle)listSeparator {
    _listSeparator = listSeparator;
    _tableView.separatorStyle = listSeparator;
}

- (void)toggleDropdown {
    _isDropped = !_isDropped;
    
    if (_isDropped) {
        [self showDropdownAnimated:YES];
    } else {
        [self hideDropdownAnimated:YES];
    }
}

- (void)showDropdownAnimated:(BOOL)animated {
    if([self.delegate respondsToSelector:@selector(dropdownPicker:didDropDown:)]){
        [self.delegate dropdownPicker:self didDropDown:YES];
    }
    
    self.tableView.hidden = NO;
    
    if (animated) {
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:10
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations: ^{
                             self.tableView.frame = self.tableFrame;
                         }
         
                         completion: ^(BOOL finished) {
                         }];
    } else {
        self.tableView.frame = self.tableFrame;
        //        self.frame = self.originalFrame;
    }
    
    [self.tableView.superview insertSubview:self.tapOutView belowSubview:self.tableView];
    
    _isDropped = YES;
}

- (void)hideDropdownAnimated:(BOOL)animated {
    if([self.delegate respondsToSelector:@selector(dropdownPicker:didDropDown:)]){
        [self.delegate dropdownPicker:self didDropDown:NO];
    }
    
    
    CGRect frame = self.tableFrame;
    frame.origin.y -= CGRectGetHeight(self.tableView.bounds) + 5;
    
    if (animated) {
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:10
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations: ^{
                             self.tableView.frame = frame;
                         }
         
                         completion: ^(BOOL finished) {
                             self.tableView.hidden = YES;
                         }];
    } else {
        self.tableView.frame = frame;
        self.tableView.hidden = YES;
    }
    
    [self.tapOutView removeFromSuperview];
    self.tapOutView = nil;
    
    _isDropped = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"dropCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:self.rowHeight / 2.3];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    id <FSDPickerItemProtocol> item = [self.options objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [item name];
    
    if (self.displaysImageInList) {
        cell.imageView.image = [item image];
    }
    
    if(self.labelTextAlignment != NSTextAlignmentNatural) {
        cell.textLabel.textAlignment = self.labelTextAlignment;
    } else if(self.displaysImageInList) {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    } else {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedOption = [self.options objectAtIndex:indexPath.row];
}

- (void)setSelectedOption:(id <FSDPickerItemProtocol> )selectedOption {
    _selectedOption = selectedOption;
    [self.actionButton setImage:[_selectedOption image] forState:UIControlStateNormal];
    
    if (self.delegate && [self.delegate dropdownPicker:self didSelectOption:_selectedOption]) {
        [self hideDropdownAnimated:YES];
    }
}

#pragma mark - Tapoutview
- (UIView *)tapOutView {
    if (!_tapOutView && self.tableView.window) {
        _tapOutView = [[UIView alloc] initWithFrame:self.tableView.window.rootViewController.view.frame];
        _tapOutView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOutTapped:)];
        [_tapOutView addGestureRecognizer:tap];
    }
    
    return _tapOutView;
}

- (void)tapOutTapped:(id)sender {
    [self hideDropdownAnimated:YES];
}

@end
