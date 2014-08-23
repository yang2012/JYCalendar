//
//  JYCalendarHeaderView.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-19.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYCalendarMonthPickerView.h"
#import "JYCalendarMonthPickerViewCell.h"
#import "JYCalendarMonthPickerLayout.h"

#import "NSDate+JYCalendar.h"
#import "UIView+JYCalendar.h"

static CGFloat kHeightofPickerView = 105.0f;
static NSString *kHeaderCellIdentifier = @"JYHeaderCell";

@interface JYCalendarMonthPickerView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) BOOL showed;
@property (nonatomic, assign) BOOL animating;

@property (nonatomic, strong) UIView *originView;
@property (nonatomic, strong) UIView *pickerView;

@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) NSDate *selectedDate;

@property (nonatomic, strong) UIButton *leftArrowButton;
@property (nonatomic, strong) UIButton *rightArrowButton;
@property (nonatomic, strong) UICollectionView *monthCollectionView;
@property (nonatomic, strong) UILabel *yearLabel;

@property (nonatomic, assign) NSInteger currentSection;

@end

@implementation JYCalendarMonthPickerView

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)_initialize
{
    self.backgroundColor = [UIColor blackColor];
    self.alpha           = 0.0f;
    self.currentSection = 0;
    
    self.pickerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.pickerView.height = kHeightofPickerView;
    
    self.yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, 0.0f, 0.0f)];
    self.yearLabel.textAlignment = NSTextAlignmentCenter;
    self.yearLabel.backgroundColor = [UIColor clearColor];
    self.yearLabel.font = [UIFont systemFontOfSize:18];
    [self.pickerView addSubview:self.yearLabel];
    
    self.monthCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.width, 80.0f) collectionViewLayout:[[JYCalendarMonthPickerLayout alloc] init]];
    self.monthCollectionView.showsHorizontalScrollIndicator = NO;
    self.monthCollectionView.alwaysBounceHorizontal         = NO;
    self.monthCollectionView.scrollEnabled                  = NO;
    self.monthCollectionView.bounces                        = NO;
    self.monthCollectionView.pagingEnabled                  = YES;
    self.monthCollectionView.delegate                       = self;
    self.monthCollectionView.dataSource                     = self;
    self.monthCollectionView.backgroundColor                = [UIColor whiteColor];
    [self.pickerView addSubview:self.monthCollectionView];
    
    self.leftArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftArrowButton.frame = CGRectMake(0.0f, 5.0f, 11.0f, 19.0f);
    [self.leftArrowButton setImage:[UIImage imageNamed:@"comm_btn_popup_prev_normal"] forState:UIControlStateNormal];
    [self.rightArrowButton setImage:[UIImage imageNamed:@"comm_btn_popup_prev_press"] forState:UIControlStateHighlighted];
    [self.leftArrowButton addTarget:self action:@selector(_navigateToPreviousYear:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerView addSubview:self.leftArrowButton];
    
    self.rightArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightArrowButton.frame = CGRectMake(0.0f, 5.0f, 11.0f, 19.0f);
    [self.rightArrowButton setImage:[UIImage imageNamed:@"comm_btn_popup_next_normal"] forState:UIControlStateNormal];
    [self.rightArrowButton setImage:[UIImage imageNamed:@"comm_btn_popup_prev_press"] forState:UIControlStateHighlighted];
    [self.rightArrowButton addTarget:self action:@selector(_navigateToNextYear:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerView addSubview:self.rightArrowButton];
    
    [self.monthCollectionView registerClass:[JYCalendarMonthPickerViewCell class] forCellWithReuseIdentifier:kHeaderCellIdentifier];
    
    // Gesture
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_swipe:)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.monthCollectionView addGestureRecognizer:leftSwipeGesture];
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_swipe:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.monthCollectionView addGestureRecognizer:rightSwipeGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tap:)];
    [self addGestureRecognizer:tapGesture];
}

#pragma mark - Public Methods

- (void)presentPickerBeginningAtDate:(NSDate *)date
                              inView:(UIView *)view
                            animated:(BOOL)animated
{
    if (self.animating) {
        return;
    }
    
    [self _clearBeforeShowed];
    
    self.originView = view;
    self.beginDate  = date;
    
    [self _addSubviewsToOriginView];
    
    [self.monthCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:date.month - 1 inSection:0]
                                           animated:NO
                                     scrollPosition:UICollectionViewScrollPositionNone];
    
    self.animating = YES;
    [UIView animateWithDuration:animated ? 0.3f : 0.0f animations:^{
        self.originView.y = kHeightofPickerView;
        self.y            = kHeightofPickerView;
        self.alpha        = 0.2f;
    } completion:^(BOOL finished) {
        self.animating = NO;
        self.showed    = YES;
    }];
}

- (void)dismissPickerAnimated:(BOOL)animated
{
    [self _hideMonthPickerViewAnimated:animated completion:nil];
}

- (void)dismissPickerAnimated:(BOOL)animated completion:(void (^)())finishedBlock
{
    [self _hideMonthPickerViewAnimated:animated completion:finishedBlock];
}

#pragma mark - UIView

- (void)layoutSubviews
{
    CGFloat inset = 10.0f;
    
    self.leftArrowButton.x = inset;
    self.rightArrowButton.x = self.width - inset - self.rightArrowButton.width;
    self.yearLabel.x = (self.width - self.yearLabel.width) / 2;
    
    self.monthCollectionView.y = self.yearLabel.y + self.yearLabel.height;
}

#pragma mark - Properties

- (void)setBeginDate:(NSDate *)beginDate
{
    _beginDate = beginDate;
    
    self.currentDate = beginDate;
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    _currentDate = currentDate;
    
    self.yearLabel.text = [NSString stringWithFormat:@"%ld", (long)currentDate.year];
    [self.yearLabel sizeToFit];
}

#pragma mark - Private Methods

- (void)_clearBeforeShowed
{
    [self.monthCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                     atScrollPosition:UICollectionViewScrollPositionLeft
                                             animated:NO];
}

- (void)_hideMonthPickerViewAnimated:(BOOL)animated completion:(void (^)())finishedBlock
{
    self.animating = YES;
    [UIView animateWithDuration: animated ? 0.3f : 0.0f animations:^{
        self.originView.y = 0.0f;
        self.y            = 0.0f;
        self.alpha        = 0.0f;
    } completion:^(BOOL finished) {
        self.animating = NO;
        self.showed    = NO;
        [self _removeSubviewsFromOriginView];
        
        if (finishedBlock) {
            finishedBlock();
        }
    }];
}

- (void)_addSubviewsToOriginView
{
    self.pickerView.width = self.originView.width;
    [self.originView.superview addSubview:self.pickerView];
    [self.originView.superview sendSubviewToBack:self.pickerView];
    
    self.frame = self.originView.frame;
    [self.originView.superview addSubview:self];
}

- (void)_removeSubviewsFromOriginView
{
    [self removeFromSuperview];
    [self.pickerView removeFromSuperview];
}

#pragma mark - Gesture Listener

- (void)_swipe:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self _navigateToNextYear:sender];
    } else {
        [self _navigateToPreviousYear:sender];
    }
}

- (void)_tap:(UITapGestureRecognizer *)sender
{
    [self _hideMonthPickerViewAnimated:YES completion:nil];
}

#pragma mark - Navigation Animation

- (void)_navigateToPreviousYear:(id)sender
{
    [self _markBeginMonthBeforeNavigation:YES];
    
    [self.monthCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]
                                     atScrollPosition:UICollectionViewScrollPositionLeft
                                             animated:NO];
    [self.monthCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                     atScrollPosition:UICollectionViewScrollPositionRight
                                             animated:YES];
    self.currentSection = 0;
    self.currentDate    = [self.currentDate dateByMovingToPreviousYear];
}

- (void)_navigateToNextYear:(id)sender
{
    [self _markBeginMonthBeforeNavigation:NO];
    
    [self.monthCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                     atScrollPosition:UICollectionViewScrollPositionLeft
                                             animated:NO];
    [self.monthCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]
                                     atScrollPosition:UICollectionViewScrollPositionLeft
                                             animated:YES];
    
    self.currentSection = 1;
    self.currentDate    = [self.currentDate dateByMovingToNextYear];
}

- (void)_markBeginMonthBeforeNavigation:(BOOL)leftDirection
{
    NSArray *indexPaths = [self.monthCollectionView indexPathsForSelectedItems];
    if (indexPaths.count != 0) {
        for (NSIndexPath *indexPath in indexPaths) {
            [self.monthCollectionView deselectItemAtIndexPath:indexPath animated:NO];
        }
    }
    
    NSIndexPath *markedIndexPath = nil;
    
    if (leftDirection) {
        if (self.currentDate.year - 1 == self.beginDate.year) {
            markedIndexPath = [NSIndexPath indexPathForItem:self.beginDate.month - 1 inSection:0];
        }
    } else {
        if (self.currentDate.year + 1 == self.beginDate.year) {
            markedIndexPath = [NSIndexPath indexPathForItem:self.beginDate.month - 1 inSection:1];
        }
    }

    if (markedIndexPath) {
        [self.monthCollectionView selectItemAtIndexPath:markedIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    // Extra section is just using for animation
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JYCalendarMonthPickerViewCell *pickerCell = [collectionView dequeueReusableCellWithReuseIdentifier:kHeaderCellIdentifier forIndexPath:indexPath];
    pickerCell.month = [NSDate dateForDay:1 month:indexPath.row + 1 year:self.currentDate.year];
    
    return pickerCell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JYCalendarMonthPickerViewCell *selectedCell = (JYCalendarMonthPickerViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(monthPicker:didSelectDate:)]) {
        [self.delegate monthPicker:self didSelectDate:selectedCell.month];
    }
}

@end
