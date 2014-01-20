//
//  JYCalendarViewController.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-18.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYCalendarViewController.h"
#import "JYCalendarUtil.h"
#import "JYCalendarMonthCell.h"
#import "JYCalendarMonthPickerView.h"
#import "JYCalendarTitleView.h"
#import "JYDateEntity.h"
#import "NSDate+JYCalendar.h"

#import "UIView+JYCalendar.h"

static NSString *kMonthCellIdentifier = @"JYCalendarWeekCell";

@interface JYCalendarViewController () <JYCalendarTitleViewDelegate, JYCalendarMonthPickerDelegate, JYCalendarMonthCellDelegate>

@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) JYCalendarTitleView *titleView;
@property (nonatomic, strong) JYCalendarMonthPickerView *monthPickerView;

@property (nonatomic, assign) BOOL animatingPickerView;
@property (nonatomic, assign) BOOL pickerViewShowed;

@property (nonatomic, assign) BOOL animatingDetailView;
@property (nonatomic, strong) JYDateEntity *showedDateEntity;

@end

@implementation JYCalendarViewController

- (id)init
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self = [super initWithCollectionViewLayout:flowLayout];
    if (self) {
        [self _initSubViews];
        
        self.currentDate         = [NSDate date];
        self.animatingPickerView = NO;
        
        flowLayout.scrollDirection         = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing      = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.pagingEnabled                  = YES;
        self.edgesForExtendedLayout                        = UIRectEdgeNone;
    }
    return self;
}

- (void)_initSubViews
{
    self.titleView          = [[JYCalendarTitleView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    self.titleView.delegate = self;
    
    self.monthPickerView        = [[JYCalendarMonthPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 105.0f)];
    self.monthPickerView.hidden = YES;
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    _currentDate = currentDate;
    
    [self.titleView setTime:currentDate];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[JYCalendarMonthCell class]
            forCellWithReuseIdentifier:kMonthCellIdentifier
     ];
    
    [self.navigationItem setTitleView:self.titleView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:0 inSection:1];
    [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - UICollectionView delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue a prototype cell and set the label to indicate the page
    JYCalendarMonthCell *cell = [collectionView
                                 dequeueReusableCellWithReuseIdentifier:kMonthCellIdentifier
                                 forIndexPath:indexPath
                                 ];
    cell.delegate = self;
    
    NSArray *dateEntities = nil;
    switch (indexPath.section) {
        case 0:
            dateEntities = [self _dateEntitesForMonth:[self.currentDate dateByMovingToPreviousMonth]];
            break;
        case 1:
            dateEntities = [self _dateEntitesForMonth:self.currentDate];
            break;
        case 2:
            dateEntities = [self _dateEntitesForMonth:[self.currentDate dateByMovingToNextMonth]];
            break;
        default:
            dateEntities = [NSArray array];
            break;
    }
    
    [cell setUpMonthWithDateEntities:dateEntities];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.bounds.size;
}

#pragma mark - Scroll delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // Calculate where the collection view should be at the right-hand end item
    float contentOffsetWhenFullyScrolledRight = self.collectionView.frame.size.width * 2;
    
    if (scrollView.contentOffset.x == contentOffsetWhenFullyScrolledRight) {
        
        self.currentDate = [self.currentDate dateByMovingToNextMonth];
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:0 inSection:1];
        [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        
    } else if (scrollView.contentOffset.x == 0)  {
        
        self.currentDate = [self.currentDate dateByMovingToPreviousMonth];
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:0 inSection:1];
        [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        
    }
}

#pragma mark - JYCalendarMonthPickerViewDelegate

- (void)monthPicker:(JYCalendarMonthPickerView *)pickerView didSelectDate:(NSDate *)date
{
    
}

#pragma mark - JYCalendarMonthCellDelegate

- (void)monthCell:(JYCalendarMonthCell *)monthCell didSelectDate:(JYDateEntity *)dateEntity
{
    if (self.animatingPickerView || self.animatingDetailView) {
        return;
    }
    
    if (self.pickerViewShowed) {
        [self _hideMonthPickerViewWithCompletion:^{
            [self _toggleDetailViewAtMonthCell:monthCell forDate:dateEntity];
        }];
    } else {
        [self _toggleDetailViewAtMonthCell:monthCell forDate:dateEntity];
    }
}

- (void)monthCell:(JYCalendarMonthCell *)monthCell didSelectEvent:(JYEventEntity *)event
{
    
}

- (NSArray *)monthCell:(JYCalendarMonthCell *)monthCell eventsForDate:(JYDateEntity *)dateEntity
{
    return [NSArray array];
}

#pragma mark - JYCalendarTitleViewDelegate

- (void)didTapTitleView:(JYCalendarTitleView *)titleView
{
    if (self.animatingPickerView || self.animatingDetailView) {
        return;
    }
    if (self.pickerViewShowed) {
        [self _hideMonthPickerViewWithCompletion:nil];
    } else {
        if (self.showedDateEntity) {
            // If detail view had showd, hide it firstly
            JYCalendarMonthCell *monthCell = (JYCalendarMonthCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
            
            self.animatingDetailView = YES;
            [monthCell hideDetailViewWithCompletion:^(BOOL showed) {
                self.animatingDetailView = NO;
                self.showedDateEntity = nil;
                
                // Show picker view
                [self _showMonthPickerView];
            }];
        } else {
            [self _showMonthPickerView];
        }
    }
}

#pragma mark - Private methods

- (void)_toggleDetailViewAtMonthCell:(JYCalendarMonthCell *)monthCell
                             forDate:(JYDateEntity *)dateEntity
{
    self.animatingDetailView = YES;
    [monthCell toggleDetailViewForDate:dateEntity completion:^(BOOL showed) {
        self.animatingDetailView = NO;
        if (showed) {
            self.showedDateEntity = dateEntity;
        } else {
            self.showedDateEntity = nil;
        }
    }];
}

- (void)_showMonthPickerView
{
    self.animatingPickerView = YES;
    
    self.monthPickerView.date = self.currentDate;
    self.monthPickerView.hidden = NO;
    [self.view addSubview:self.monthPickerView];
    [self.view sendSubviewToBack:self.monthPickerView];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.collectionView.y = self.monthPickerView.height;
    } completion:^(BOOL finished) {
        self.animatingPickerView = NO;
        self.pickerViewShowed    = YES;
    }];
}

- (void)_hideMonthPickerViewWithCompletion:(void (^)())finishedBlock
{
    self.animatingPickerView = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.collectionView.y = 0;
    } completion:^(BOOL finished) {
        self.monthPickerView.hidden = YES;
        [self.monthPickerView removeFromSuperview];
        self.animatingPickerView    = NO;
        self.pickerViewShowed       = NO;
        
        if (finishedBlock) {
            finishedBlock();
        }
    }];
}

- (NSArray *)_dateEntitesForMonth:(NSDate *)date
{
    NSMutableArray *dateEntities = [NSMutableArray arrayWithCapacity:35];
    
    NSArray *daysInLastWeekOfPreviousMonth = [JYCalendarUtil daysInLastWeekOfPreviousMonth:date];
    for (NSDate *day in daysInLastWeekOfPreviousMonth) {
        JYDateEntity *dateEntity = [[JYDateEntity alloc] init];
        dateEntity.visible = NO;
        dateEntity.date = day;
        
        [dateEntities addObject:dateEntity];
    }
    
    NSArray *daysInMonth = [JYCalendarUtil daysInMonth:date];
    for (NSDate *day in daysInMonth) {
        JYDateEntity *dateEntity = [[JYDateEntity alloc] init];
        dateEntity.visible = YES;
        dateEntity.date = day;
        
        [dateEntities addObject:dateEntity];
    }
    
    NSArray *daysInFirstWeekOfNextMonth = [JYCalendarUtil daysInFirstWeekOfNextMonth:date];
    for (NSDate *day in daysInFirstWeekOfNextMonth) {
        JYDateEntity *dateEntity = [[JYDateEntity alloc] init];
        dateEntity.visible = NO;
        dateEntity.date = day;
        
        [dateEntities addObject:dateEntity];
    }
    
    return dateEntities;
}

@end
