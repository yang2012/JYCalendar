//
//  JYCalendarHeaderView.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-19.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYCalendarMonthPickerView.h"
#import "JYCalendarMonthPickerViewCell.h"

#import "NSDate+JYCalendar.h"
#import "UIView+JYCalendar.h"

static NSString *kHeaderCellIdentifier = @"JYHeaderCell";

@interface JYCalendarMonthPickerView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic, strong) UIButton *leftArrowButton;
@property (nonatomic, strong) UIButton *rightArrowButton;
@property (nonatomic, strong) UICollectionView *monthCollectionView;
@property (nonatomic, strong) UILabel *yearLabel;

@end

@implementation JYCalendarMonthPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubviews];
    }
    return self;
}

- (void)_addSubviews
{
    self.yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, 0.0f, 0.0f)];
    self.yearLabel.textAlignment = NSTextAlignmentCenter;
    self.yearLabel.backgroundColor = [UIColor clearColor];
    self.yearLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:self.yearLabel];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.width / 6, 38.0f);
    flowLayout.minimumLineSpacing      = 0.0f;
    flowLayout.minimumInteritemSpacing = 0.0f;
    flowLayout.scrollDirection         = UICollectionViewScrollDirectionHorizontal;
    
    self.monthCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.monthCollectionView.showsHorizontalScrollIndicator = NO;
    self.monthCollectionView.alwaysBounceHorizontal         = NO;
    self.monthCollectionView.scrollEnabled                  = NO;
    self.monthCollectionView.bounces                        = NO;
    self.monthCollectionView.pagingEnabled                  = YES;
    self.monthCollectionView.delegate                       = self;
    self.monthCollectionView.dataSource                     = self;
    self.monthCollectionView.backgroundColor                = [UIColor whiteColor];
    [self addSubview:self.monthCollectionView];
    
    self.leftArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftArrowButton.frame = CGRectMake(0.0f, 5.0f, 11.0f, 19.0f);
    [self.leftArrowButton setImage:[UIImage imageNamed:@"comm_btn_popup_prev_normal"] forState:UIControlStateNormal];
    [self.rightArrowButton setImage:[UIImage imageNamed:@"comm_btn_popup_prev_press"] forState:UIControlStateHighlighted];
    [self.leftArrowButton addTarget:self action:@selector(_navigateToPreviousYear:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.leftArrowButton];
    
    self.rightArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightArrowButton.frame = CGRectMake(0.0f, 5.0f, 11.0f, 19.0f);
    [self.rightArrowButton setImage:[UIImage imageNamed:@"comm_btn_popup_next_normal"] forState:UIControlStateNormal];
    [self.rightArrowButton setImage:[UIImage imageNamed:@"comm_btn_popup_prev_press"] forState:UIControlStateHighlighted];
    [self.rightArrowButton addTarget:self action:@selector(_navigateToNextYear:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.rightArrowButton];
    
    [self.monthCollectionView registerClass:[JYCalendarMonthPickerViewCell class] forCellWithReuseIdentifier:kHeaderCellIdentifier];
    
    // Gesture
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_swipe:)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.monthCollectionView addGestureRecognizer:leftSwipeGesture];
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_swipe:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.monthCollectionView addGestureRecognizer:rightSwipeGesture];
}

- (void)layoutSubviews
{
    CGRect frame = self.bounds;
    
    CGFloat inset = 10.0f;
    
    self.leftArrowButton.x = inset;
    self.rightArrowButton.x = frame.size.width - inset - self.rightArrowButton.width;
    self.yearLabel.x = (frame.size.width - self.yearLabel.width) / 2;
    
    self.monthCollectionView.frame = CGRectMake(0.0, self.yearLabel.y + self.yearLabel.height, frame.size.width, 76.0f);
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    
    self.currentDate = date;
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    _currentDate = currentDate;
    
    self.yearLabel.text = [NSString stringWithFormat:@"%d", currentDate.year];
    [self.yearLabel sizeToFit];
    
    [self.monthCollectionView reloadData];
}

- (void)_swipe:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self _navigateToNextYear:sender];
    } else {
        [self _navigateToPreviousYear:sender];
    }
}

- (void)_navigateToPreviousYear:(id)sender
{
    self.currentDate = [self.currentDate dateByMovingToPreviousYear];
    
    [self.monthCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]
                                     atScrollPosition:UICollectionViewScrollPositionLeft
                                             animated:NO];
    [self.monthCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                     atScrollPosition:UICollectionViewScrollPositionRight
                                             animated:YES];
}

- (void)_navigateToNextYear:(id)sender
{
    self.currentDate = [self.currentDate dateByMovingToNextYear];
    
    [self.monthCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                     atScrollPosition:UICollectionViewScrollPositionLeft
                                             animated:NO];
    [self.monthCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]
                                     atScrollPosition:UICollectionViewScrollPositionLeft
                                             animated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    // One for placeholder using for animation
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
    
    if (indexPath.row + 1 == self.date.month
        && self.currentDate.year == self.date.year
        && indexPath.section == 0) {
        // seciont 2 is just placeholder
        pickerCell.selected = YES;
    } else {
        pickerCell.selected = NO;
    }
    return pickerCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
