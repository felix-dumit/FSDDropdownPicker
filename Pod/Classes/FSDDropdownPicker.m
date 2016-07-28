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
@property (assign, nonatomic) CGFloat headerHeight;
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
        _dropdownBackgroundColor = [UIColor colorWithWhite:1.000 alpha:0.850];
        self.selectedOption = firstItem;
        
        self.displaysImageInList = NO;
        
        self.tapOutView = nil;
        
        self.rowHeight = 44.0f;
        self.headerHeight = 20.0f;
    }
    
    return self;
}

-(void)dealloc {
    [_tableView removeFromSuperview];
    [_tapOutView removeFromSuperview];
}

- (UINavigationBar *)navigationBar {
    return (UINavigationBar *)[self.customView superview];
}

-(CGFloat)screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

-(CGRect)tableFrame {
    CGRect navFrame = [self navigationBar].frame;
    if(CGRectEqualToRect(navFrame, CGRectZero)) {
        navFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    }
    return CGRectMake(CGRectGetMinX(navFrame), CGRectGetMaxY(navFrame) - self.headerHeight, CGRectGetWidth(navFrame), MIN(self.screenHeight - CGRectGetMaxY(navFrame), self.options.count * self.rowHeight) + self.headerHeight);
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.tableFrame];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelection = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = self.rowHeight;
        _tableView.backgroundColor = self.dropdownBackgroundColor;
        _tableView.layer.masksToBounds = NO;
        _tableView.layer.shadowColor = [UIColor blackColor].CGColor;
        _tableView.layer.shadowOffset = CGSizeMake(0.0f, 4.0f);
        _tableView.layer.cornerRadius = 2.0f;
        _tableView.layer.shadowOpacity = 0.3f;
        
        [self hideDropdownAnimated:NO];
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
    [_tableView reloadData];
}

- (void)setDisplaysImageInList:(BOOL)displaysImageInList {
    _displaysImageInList = displaysImageInList;
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
    
    CGRect navFrame = [self navigationBar].frame;
    BOOL greaterThanScreenSize = self.options.count * self.rowHeight > self.screenHeight - CGRectGetMaxY(navFrame);
    _tableView.scrollEnabled = greaterThanScreenSize;
    
    self.tableView.hidden = NO;
    
    if (animated) {
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:10
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations: ^{
                             self.tableView.frame = self.tableFrame;
                             UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.tableView.bounds];
                             self.tableView.layer.shadowPath = shadowPath.CGPath;
                         }
         
                         completion: ^(BOOL finished) {
                             
                             NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.options indexOfObject:self.selectedOption] inSection:0];
                             [self.tableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionNone];
                         }];
    } else {
        self.tableView.frame = self.tableFrame;
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
                             if(!_isDropped) {
                                 self.tableView.hidden = YES;
                             }
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
    
    id <FSDPickerItemProtocol> item = [self.options objectAtIndex:indexPath.row];
    
    if([self.delegate respondsToSelector:@selector(dropdownPicker:cellForOption:)]) {
        return [self.delegate dropdownPicker:self cellForOption:item];
    }
    
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
    
    cell.textLabel.text = [item name];
    
    if (self.displaysImageInList) {
        cell.imageView.image = [item image];
    }
    
    if(self.displaysImageInList) {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    } else {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.headerHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, self.headerHeight)];
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