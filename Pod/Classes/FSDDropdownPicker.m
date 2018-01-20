//
//  DropDownTableView.m
//  Umwho
//
//  Created by Felix Dumit on 12/24/14.
//  Copyright (c) 2014 Umwho. All rights reserved.
//


#import "FSDDropdownPicker.h"

@interface FSDDropDownTableView: UITableView
@property (strong, nonatomic) NSLayoutConstraint* heightConstraint;
@end

@interface FSDDropdownPicker () <UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) CGFloat headerHeight;
@property (strong, nonatomic) NSArray *options;
@property (strong, nonatomic) FSDDropDownTableView *tableView;
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
    actionButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    actionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    NSLayoutConstraint* constraint = nil;
    constraint = [actionButton.widthAnchor constraintEqualToConstant:36];
    constraint.priority = 999;
    [constraint setActive:YES];
    constraint = [actionButton.heightAnchor constraintEqualToConstant:36];
    constraint.priority = 999;
    [constraint setActive:YES];
    
    if (self = [super initWithCustomView:actionButton]) {
        [actionButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        self.actionButton = actionButton;
        
        self.options = options;
        _isDropped = NO;
        _dropdownBackgroundColor = [UIColor colorWithWhite:1.000 alpha:0.850];
        self.selectedOption = firstItem;
        self.displaysImageInList = NO;
        self.shouldHideOnOutsideTap = YES;
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
    UINavigationBar *s = (UINavigationBar*)self.customView.superview;
    while (s && ![s isKindOfClass:[UINavigationBar class]]) {
        s = (UINavigationBar*)s.superview;
    }
    return s;
}

-(CGFloat)screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

- (FSDDropDownTableView *)tableView {
    if (!_tableView) {
        _tableView = [[FSDDropDownTableView alloc] init];
        _tableView.accessibilityIdentifier = @"fsd_tableView";
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = self.rowHeight;
        _tableView.backgroundColor = self.dropdownBackgroundColor;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.sectionHeaderHeight = self.headerHeight;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"fsd_table_cell"];
    }
    
    UINavigationBar* navbar = [self navigationBar];
    
    if (!_tableView.superview && navbar.superview) {
        UIView* superview = navbar.superview;
        [superview insertSubview:_tableView belowSubview:navbar];
        
        [_tableView.leadingAnchor constraintEqualToAnchor:superview.leadingAnchor].active = YES;
        [_tableView.trailingAnchor constraintEqualToAnchor:superview.trailingAnchor].active = YES;
        [_tableView.topAnchor constraintEqualToAnchor:navbar.bottomAnchor constant:-self.headerHeight].active = YES;
        [self calculateTableViewHeight];
        [self hideDropdownAnimated:NO];
    }
    
    return _tableView;
}

-(void) calculateTableViewHeight {
    _tableView.heightConstraint.constant = self.options.count * self.rowHeight + self.headerHeight;
    [_tableView setNeedsLayout];
}

- (void)buttonTapped:(id)sender {
    [self toggleDropdown];
}

- (void)setRowHeight:(CGFloat)rowHeight {
    _rowHeight = rowHeight;
    _tableView.rowHeight = rowHeight;
    [self calculateTableViewHeight];
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
    
    self.tableView.hidden = NO;
    
    if (animated) {
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:10
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations: ^{
                             self.tableView.transform = CGAffineTransformIdentity;
                         }
                         completion: ^(BOOL finished) {
                             NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.options indexOfObject:self.selectedOption] inSection:0];
                             [self.tableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionNone];
                         }];
    } else {
        self.tableView.transform = CGAffineTransformIdentity;
    }
    
    if(self.shouldHideOnOutsideTap) {
        [self addTapoutView];
    }
    
    _isDropped = YES;
}

- (void)hideDropdownAnimated:(BOOL)animated {
    if([self.delegate respondsToSelector:@selector(dropdownPicker:didDropDown:)]){
        [self.delegate dropdownPicker:self didDropDown:NO];
    }
    
    CGFloat navHeight = [self navigationBar].bounds.size.height;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -(_tableView.heightConstraint.constant + self.headerHeight + navHeight));
    
    if (animated) {
        [UIView animateWithDuration:0.7
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:10
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations: ^{
                             self.tableView.transform = transform;
                         }
         
                         completion: ^(BOOL finished) {
                             if(!_isDropped) {
                                 self.tableView.hidden = YES;
                             }
                         }];
    } else {
        //        self.tableView.frame = frame;
        self.tableView.transform = transform;
        self.tableView.hidden = YES;
    }
    
    [self removeTapOutView];
    
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
    
    UITableViewCell* cell =  [tableView dequeueReusableCellWithIdentifier:@"fsd_table_cell" forIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont systemFontOfSize:self.rowHeight / 2.3];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
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
    self.selectedOption = self.options[indexPath.row];
}

- (void)setSelectedOption:(id <FSDPickerItemProtocol> )selectedOption {
    _selectedOption = selectedOption;
    [self.actionButton setImage:selectedOption.image forState:UIControlStateNormal];
    
    if (self.delegate && [self.delegate dropdownPicker:self didSelectOption:selectedOption]) {
        [self hideDropdownAnimated:YES];
    }
}

#pragma mark - Tapoutview
-(void) addTapoutView {
    if(self.tapOutView && self.tapOutView.superview) {
        return;
    }
    self.tapOutView = [UIView new];
    self.tapOutView.accessibilityIdentifier = @"fsd_tapoutView";
    self.tapOutView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tapOutView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOutTapped:)];
    [self.tapOutView addGestureRecognizer:tap];
    [self.tableView.superview insertSubview:self.tapOutView belowSubview:self.tableView];
    [self.tapOutView.leadingAnchor constraintEqualToAnchor:self.tableView.leadingAnchor].active = YES;
    [self.tapOutView.trailingAnchor constraintEqualToAnchor:self.tableView.trailingAnchor].active = YES;
    [self.tapOutView.topAnchor constraintEqualToAnchor:self.tableView.bottomAnchor].active = YES;
    [self.tapOutView.bottomAnchor constraintEqualToAnchor:self.tableView.window.bottomAnchor].active = YES;
}

-(void) removeTapOutView {
    [self.tapOutView removeFromSuperview];
    self.tapOutView = nil;
}


- (void)tapOutTapped:(id)sender {
    [self hideDropdownAnimated:YES];
}

@end

@implementation FSDDropDownTableView

-(instancetype) init {
    if(self = [super init]) {
        self.allowsSelection = YES;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0f, 4.0f);
        self.layer.cornerRadius = 2.0f;
        self.layer.shadowOpacity = 0.3f;
        self.heightConstraint = [self.heightAnchor constraintEqualToConstant:0];
        self.heightConstraint.priority = 999;
        self.heightConstraint.active = YES;
        self.clipsToBounds = NO;
    }
    return self;
}

-(void)setTransform:(CGAffineTransform)transform {
    [super setTransform:transform];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.scrollEnabled = self.contentSize.height > self.bounds.size.height + self.sectionHeaderHeight;
    //    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    //    self.layer.shadowPath = shadowPath.CGPath;
}

@end
