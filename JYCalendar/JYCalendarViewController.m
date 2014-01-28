//
//  JYCalendarViewController.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-18.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//
#import <ReactiveCocoa.h>
#import "RACEXTScope.h"

#import "JYCalendarViewController.h"
#import "JYCalendarUtil.h"

#import "JYCalendarMonthPickerView.h"
#import "JYCalendarMenuView.h"
#import "JYCalendarTitleView.h"
#import "JYCalendarMonthCell.h"

#import "JYDate.h"
#import "JYEvent.h"

#import "NSDate+JYCalendar.h"
#import "UIView+JYCalendar.h"

static NSString *kMonthCellIdentifier = @"JYCalendarWeekCell";

@interface JYCalendarViewController () <JYCalendarTitleViewDelegate, JYCalendarMonthPickerDelegate, JYCalendarMonthCellDelegate, JYCalendarMenuViewDelegate>

@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic, strong) JYCalendarMenuView *menuView;
@property (nonatomic, strong) JYCalendarTitleView *titleView;
@property (nonatomic, strong) JYCalendarMonthPickerView *monthPickerView;

@property (nonatomic, assign) BOOL animatingDetailView;
@property (nonatomic, assign) BOOL hasShowedDetail;

@end

@implementation JYCalendarViewController

- (id)init
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self = [super initWithCollectionViewLayout:flowLayout];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)_initialize
{
    self.titleView                = [[JYCalendarTitleView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    self.titleView.delegate       = self;
    
    self.menuView                 = [[JYCalendarMenuView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.width, self.view.height)];
    
    self.monthPickerView          = [[JYCalendarMonthPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.width, self.view.height)];
    self.monthPickerView.delegate = self;
    
    self.currentDate              = [NSDate date];
    self.animatingDetailView      = NO;
    self.hasShowedDetail          = NO;
    
    ((UICollectionViewFlowLayout *)self.collectionViewLayout).scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled                  = YES;
    self.edgesForExtendedLayout                        = UIRectEdgeNone;
    
    @weakify(self);
    [[RACObserve(self.menuView, showed) deliverOn:RACScheduler.mainThreadScheduler] subscribeNext:^(NSNumber *showed) {
        @strongify(self);
        if (showed.boolValue) {
            [self _setupNavigationBarInMenuMode];
        } else {
            [self _setupNavigationBarInNormalMode];
        }
    }];
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    _currentDate = currentDate;
    
    [self.titleView setTime:currentDate];
    [self.collectionView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[JYCalendarMonthCell class]
            forCellWithReuseIdentifier:kMonthCellIdentifier
     ];
    
    [self.navigationItem setTitleView:self.titleView];
    
    [self _setupNavigationBarInNormalMode];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:0 inSection:1];
    [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    JYCalendarMonthCell *monthCell = (JYCalendarMonthCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    
    self.animatingDetailView = YES;
    [monthCell hideDetailViewAnimated:NO completion:^(BOOL showed) {
        self.animatingDetailView = NO;
        self.hasShowedDetail     = NO;
    }];
}

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
    self.currentDate = date;
    
    [pickerView dismissPickerAnimated:YES];
}

#pragma mark - JYCalendarMonthCellDelegate

- (void)monthCell:(JYCalendarMonthCell *)monthCell didSelectDate:(JYDate *)dateEntity
{
    if (self.animatingDetailView) {
        return;
    }
    
    self.animatingDetailView = YES;
    [monthCell toggleDetailViewForDate:dateEntity completion:^(BOOL showed) {
        self.animatingDetailView = NO;
        if (showed) {
            self.hasShowedDetail = YES;
        } else {
            self.hasShowedDetail = NO;
        }
    }];
}

- (void)monthCell:(JYCalendarMonthCell *)monthCell didSelectEvent:(JYEvent *)event
{
    
}

- (NSArray *)monthCell:(JYCalendarMonthCell *)monthCell eventsForDate:(NSDate *)date
{
    NSMutableArray *events = [NSMutableArray array];
    if (date.day % 2 == 0) {
        JYEvent *event = [[JYEvent alloc] init];
        event.content = @"Taking exercise";
        event.startDate = [NSDate date];
        [events addObject:event];
        
        event = [[JYEvent alloc] init];
        event.content = @"Make some food";
        event.startDate = [NSDate date];
        [events addObject:event];
    }
    return events;
}

#pragma mark - JYCalendarTitleViewDelegate

- (void)didTapTitleView:(JYCalendarTitleView *)titleView
{
    if (self.animatingDetailView || self.monthPickerView.animating || self.menuView.animating) {
        return;
    }
    
    if (self.monthPickerView.showed) {
        [self.monthPickerView dismissPickerAnimated:YES];
    } else {
        if (self.hasShowedDetail) {
            // If detail view had showd, hide it firstly
            JYCalendarMonthCell *monthCell = (JYCalendarMonthCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
            
            self.animatingDetailView = YES;
            [monthCell hideDetailViewAnimated:YES completion:^(BOOL showed) {
                self.animatingDetailView = NO;
                self.hasShowedDetail = NO;
                [self.monthPickerView presentPickerBeginningAtDate:self.currentDate
                                                            inView:self.collectionView
                                                          animated:YES];
            }];
        } else if (self.menuView.showed) {
            [self.menuView dismissMenuAnimated:YES completion:^{
                [self.monthPickerView presentPickerBeginningAtDate:self.currentDate
                                                            inView:self.collectionView
                                                          animated:YES];
            }];
        } else {
            [self.monthPickerView presentPickerBeginningAtDate:self.currentDate
                                                        inView:self.collectionView
                                                      animated:YES];
        }
    }
}

#pragma mark - JYCalendarMenuViewDelegate

- (void)menuView:(JYCalendarMenuView *)menuView didClickMenuAtIndex:(NSInteger)index
{
    // Child controller should implement this method
}

#pragma mark - Private methods

- (NSArray *)_dateEntitesForMonth:(NSDate *)date
{
    NSMutableArray *dateEntities = [NSMutableArray arrayWithCapacity:35];
    
    NSArray *daysInLastWeekOfPreviousMonth = [JYCalendarUtil daysInLastWeekOfPreviousMonth:date];
    for (NSDate *day in daysInLastWeekOfPreviousMonth) {
        JYDate *dateEntity = [[JYDate alloc] init];
        dateEntity.visible = NO;
        dateEntity.date = day;
        
        [dateEntities addObject:dateEntity];
    }
    
    NSArray *daysInMonth = [JYCalendarUtil daysInMonth:date];
    for (NSDate *day in daysInMonth) {
        JYDate *dateEntity = [[JYDate alloc] init];
        dateEntity.visible = YES;
        dateEntity.date = day;
        
        [dateEntities addObject:dateEntity];
    }
    
    NSArray *daysInFirstWeekOfNextMonth = [JYCalendarUtil daysInFirstWeekOfNextMonth:date];
    for (NSDate *day in daysInFirstWeekOfNextMonth) {
        JYDate *dateEntity = [[JYDate alloc] init];
        dateEntity.visible = NO;
        dateEntity.date = day;
        
        [dateEntities addObject:dateEntity];
    }
    
    return dateEntities;
}

- (void)_setupNavigationBarInNormalMode
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];

    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 31.0f)];
    [menuButton setImage:[UIImage imageNamed:@"gnb_btn_menu_normal"] forState:UIControlStateNormal];
    [menuButton setImage:[UIImage imageNamed:@"gnb_btn_menu_press"] forState:UIControlStateHighlighted];
    [menuButton addTarget:self action:@selector(_showMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItems = @[menuBarButtonItem];
    
    UIButton *todayButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 31.0f)];
    [todayButton setImage:[UIImage imageNamed:@"gnb_btn_today_normal"] forState:UIControlStateNormal];
    [todayButton setImage:[UIImage imageNamed:@"gnb_btn_today_press"] forState:UIControlStateHighlighted];
    [todayButton addTarget:self action:@selector(_gotoToday:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *todayBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:todayButton];
    self.navigationItem.rightBarButtonItems = @[todayBarButtonItem];
}

- (void)_setupNavigationBarInMenuMode
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.235f green:0.757f blue:0.945f alpha:0.4]];

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 31.0f)];
    [backButton setImage:[UIImage imageNamed:@"menu_btn_close_normal"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"menu_btn_close_press"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(_hideMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItems = @[backBarButtonItem];
    
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 31.0f)];
    [settingButton setImage:[UIImage imageNamed:@"menu_btn_setting_normal"] forState:UIControlStateNormal];
    [settingButton setImage:[UIImage imageNamed:@"menu_btn_setting_press"] forState:UIControlStateHighlighted];
    UIBarButtonItem *settingBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    self.navigationItem.rightBarButtonItems = @[settingBarButtonItem];
}

#pragma mark - UIBarButtonItem Action

- (void)_gotoToday:(id)sender
{
    self.currentDate = [NSDate date];
}

- (void)_showMenu:(id)sender
{
    if (self.hasShowedDetail) {
        // If detail view had showd, hide it firstly
        JYCalendarMonthCell *monthCell = (JYCalendarMonthCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
        
        self.animatingDetailView = YES;
        [monthCell hideDetailViewAnimated:YES completion:^(BOOL showed) {
            self.animatingDetailView = NO;
            self.hasShowedDetail = NO;
            
            [self.menuView presentMenuInView:self.collectionView animated:YES];
        }];
    } else if(self.monthPickerView.showed) {
        [self.monthPickerView dismissPickerAnimated:YES completion:^{
            [self.menuView presentMenuInView:self.collectionView animated:YES];
        }];
    } else {
        [self.menuView presentMenuInView:self.collectionView animated:YES];
    }
}

- (void)_hideMenu:(id)sender
{
    [self.menuView dismissMenuAnimated:YES];
}
@end
