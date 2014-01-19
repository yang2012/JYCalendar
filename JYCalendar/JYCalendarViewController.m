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
#import "JYDateEntity.h"
#import "NSDate+JYCalendar.h"

static NSString *kMonthCellIdentifier = @"JYCalendarWeekCell";

@interface JYCalendarViewController ()

@property (nonatomic, strong) NSDate *currentDate;

@end

@implementation JYCalendarViewController

- (id)init
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self = [super initWithCollectionViewLayout:flowLayout];
    if (self) {
        flowLayout.scrollDirection                         = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing                      = 0;
        flowLayout.minimumInteritemSpacing                 = 0;
        
        self.title = @"Calendar";
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.pagingEnabled                  = YES;
        self.edgesForExtendedLayout                        = UIRectEdgeNone;
        self.currentDate                                   = [NSDate date];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[JYCalendarMonthCell class]
            forCellWithReuseIdentifier:kMonthCellIdentifier
     ];
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
    
    [cell setUpDatesForMonth:dateEntities];
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


#pragma mark - JYCalendarDateViewDelegate

#pragma mark - Private methods

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
