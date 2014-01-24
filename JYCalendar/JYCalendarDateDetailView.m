//
//  JYCalendarDateDetailView.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-19.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYCalendarDateDetailView.h"
#import "JYCalendarDateDetailCell.h"
#import "UIView+JYCalendar.h"

static NSString *kDetailCellIndentifier    = @"JYDetailCell";
static NSString *kSupplementaryIndentifier = @"JYSupplementaryCell";

@interface JYCalendarDateDetailView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIButton *writeButton;
@property (nonatomic, strong) UIView *placeholderView;
@property (nonatomic, strong) UICollectionView *eventCollectionView;

@property (nonatomic, strong) NSArray *eventEntities;

@end

@implementation JYCalendarDateDetailView

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
    
    UIImageView *placeholderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_ico_schedule_none@2x"]];
    placeholderImageView.frame        = CGRectMake(0.0f, inset, 36.0f, 38.0f);
    
    UILabel *placeholderLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, placeholderImageView.y + placeholderImageView.height + inset, 0.0f, 0.0f)];
    placeholderLabel.font             = [UIFont systemFontOfSize:12.0f];
    placeholderLabel.text             = NSLocalizedString(@"Any new events?", nil);
    [placeholderLabel sizeToFit];
    
    self.placeholderView                 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.width, self.height)];
    self.placeholderView.backgroundColor = [UIColor clearColor];
    self.placeholderView.width           = placeholderLabel.width > placeholderImageView.width ? placeholderLabel.width + 2 * inset : placeholderImageView.width + 2 * inset;
    self.placeholderView.height          = placeholderImageView.height + placeholderLabel.height +  inset;
    self.placeholderView.x               = (self.width - self.placeholderView.width) / 2;
    self.placeholderView.y               = (self.height - self.placeholderView.height) / 2;
    
    placeholderImageView.x = (self.placeholderView.width - placeholderImageView.width) / 2;
    [self.placeholderView addSubview:placeholderImageView];
    
    placeholderLabel.x = (self.placeholderView.width - placeholderLabel.width) / 2;
    [self.placeholderView addSubview:placeholderLabel];
    
    self.writeButton       = [[UIButton alloc] init];
    [self.writeButton setImage:[UIImage imageNamed:@"detail_btn_write_normal@2x"] forState:UIControlStateNormal];
    [self.writeButton setImage:[UIImage imageNamed:@"detail_btn_write_press@2x"] forState:UIControlStateHighlighted];
    self.writeButton.frame = CGRectMake(self.width - 44.0f - inset, self.height - 44.0f - inset, 44.0f, 44.0f);
    [self addSubview:self.writeButton];
    
    self.eventCollectionView                 = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.width, self.height) collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    self.eventCollectionView.dataSource      = self;
    self.eventCollectionView.delegate        = self;
    self.eventCollectionView.backgroundColor = [UIColor whiteColor];
    [self.eventCollectionView registerClass:[JYCalendarDateDetailCell class] forCellWithReuseIdentifier:kDetailCellIndentifier];
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)showEvents:(NSArray *)events animated:(BOOL)animated
{
    self.eventEntities = events;
    
    if (events.count == 0) {
        [self _showPlaceHolderAnimated:animated];
    } else {
        [self _showEventTableAnimated:animated];
    }
}


- (void)_showPlaceHolderAnimated:(BOOL)animated
{
    [self .eventCollectionView removeFromSuperview];
    [self addSubview:self.placeholderView];
}

- (void)_showEventTableAnimated:(BOOL)animated
{
    [self.placeholderView removeFromSuperview];
    [self addSubview:self.eventCollectionView];
    
    [self.eventCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.width, 27.0f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.eventEntities.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JYCalendarDateDetailCell *detailCell = (JYCalendarDateDetailCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kDetailCellIndentifier forIndexPath:indexPath];
    detailCell.eventEntity = self.eventEntities[indexPath.row];
    return detailCell;
}

@end
