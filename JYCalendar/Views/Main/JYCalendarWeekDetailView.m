//
//  JYCalendarDateDetailView.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-19.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYCalendarWeekDetailView.h"
#import "JYCalendarDateDetailListCell.h"
#import "JYCalendarDateDetailEmptyCell.h"
#import "UIView+JYCalendar.h"

static NSString *kDetailListCellIdentifier  = @"JYDetailListCell";
static NSString *kDetailEmptyCellIdentifier = @"JYDetailEmptyCell";

@interface JYCalendarWeekDetailView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) NSInteger currentWeekDay;

@property (nonatomic, strong) UIButton *writeButton;
@property (nonatomic, strong) UICollectionView *eventCollectionView;

@end

@implementation JYCalendarWeekDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initializa];
    }
    return self;
}

- (void)_initializa
{
    CGFloat inset = 2.0f;
    
    self.writeButton       = [[UIButton alloc] init];
    [self.writeButton setImage:[UIImage imageNamed:@"detail_btn_write_normal@2x"] forState:UIControlStateNormal];
    [self.writeButton setImage:[UIImage imageNamed:@"detail_btn_write_press@2x"] forState:UIControlStateHighlighted];
    self.writeButton.frame = CGRectMake(self.width - 44.0f - inset, self.height - 44.0f - inset, 44.0f, 44.0f);
    [self addSubview:self.writeButton];
    
    UICollectionViewFlowLayout *flowLayout                  = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection                              = UICollectionViewScrollDirectionHorizontal;
    self.eventCollectionView                                = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.width, self.height) collectionViewLayout:flowLayout];
    self.eventCollectionView.dataSource                     = self;
    self.eventCollectionView.delegate                       = self;
    self.eventCollectionView.showsHorizontalScrollIndicator = NO;
    self.eventCollectionView.pagingEnabled                  = YES;
    self.eventCollectionView.backgroundColor                = [UIColor whiteColor];
    [self.eventCollectionView registerClass:[JYCalendarDateDetailListCell class] forCellWithReuseIdentifier:kDetailListCellIdentifier];
    [self.eventCollectionView registerClass:[JYCalendarDateDetailEmptyCell class] forCellWithReuseIdentifier:kDetailEmptyCellIdentifier];
    [self addSubview:self.eventCollectionView];
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setEventsForWeek:(NSArray *)eventsForWeek
{
    _eventsForWeek = eventsForWeek;
    
    [self.eventCollectionView reloadData];
}

- (void)showWeekday:(NSInteger)weekday animated:(BOOL)animated
{
    self.currentWeekDay = weekday;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:weekday - 1];
    [self.eventCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.bounds.size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.eventsForWeek.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;

    NSArray *eventsForDay = self.eventsForWeek[indexPath.section];
    if (eventsForDay.count == 0) {
        JYCalendarDateDetailEmptyCell *emptyCell = (JYCalendarDateDetailEmptyCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kDetailEmptyCellIdentifier forIndexPath:indexPath];
        cell = emptyCell;
    } else {
        JYCalendarDateDetailListCell *listCell = (JYCalendarDateDetailListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kDetailListCellIdentifier forIndexPath:indexPath];
        listCell.eventEntities = eventsForDay;
        cell = listCell;
    }
    
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger weekday = scrollView.contentOffset.x / self.width + 1;
    if (weekday != self.currentWeekDay) {
        if (weekday > self.currentWeekDay) {
            if ([self.delegate respondsToSelector:@selector(weekDetailViewDidNavigateToNextDay:)]) {
                [self.delegate weekDetailViewDidNavigateToNextDay:self];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(weekDetailViewDidNavigateToPreviousDay:)]) {
                [self.delegate weekDetailViewDidNavigateToPreviousDay:self];
            }
        }
        self.currentWeekDay = weekday;
    }
}

@end
