//
//  JYCalendarMonthPickerLayout.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-21.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYCalendarMonthPickerLayout.h"

static NSString * const BHPhotoAlbumLayoutPhotoCellKind = @"PhotoCell";

@interface JYCalendarMonthPickerLayout ()

@property (nonatomic, strong) NSDictionary *layoutAttributesDict;

@end

@implementation JYCalendarMonthPickerLayout

#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.itemSize                = CGSizeMake(50.0f, 38.0f);
    self.margin                  = 10.0f;
    self.numberOfColumns         = 6;
    self.minimumLineSpacing      = 0.0f;
    self.minimumInteritemSpacing = 0.0f;
}

#pragma mark - Properties

- (void)setNumberOfColumns:(NSInteger)numberOfColumns
{
    if (_numberOfColumns == numberOfColumns) return;
    
    _numberOfColumns = numberOfColumns;
    
    [self invalidateLayout];
}

#pragma mark - Layout

- (void)prepareLayout
{
    NSInteger sectionsNum = [self.collectionView numberOfSections];
    NSMutableDictionary *allAttributesDict = [NSMutableDictionary dictionaryWithCapacity:24];
    NSInteger itemsNum = 0;
    for (NSInteger section = 0; section < sectionsNum; section++) {
        itemsNum = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < itemsNum; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = [self _frameForMonthAtIndexPath:indexPath];
            
            [allAttributesDict setObject:attributes forKey:indexPath];
        }
    }
    self.layoutAttributesDict = allAttributesDict;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.layoutAttributesDict.allValues;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.layoutAttributesDict objectForKey:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    return NO;
}

#pragma mark - Private

- (CGRect)_frameForMonthAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row / self.numberOfColumns;
    NSInteger column = indexPath.row % self.numberOfColumns;
    
    CGFloat originX = floorf(self.margin + self.itemSize.width * column) + indexPath.section * self.collectionView.bounds.size.width;
    CGFloat originY = floor(self.itemSize.height * row);
    
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
}

- (CGSize)collectionViewContentSize
{
    CGFloat width  = self.collectionView.bounds.size.width * [self.collectionView numberOfSections];
    CGFloat height = self.collectionView.bounds.size.height;
    return CGSizeMake(width, height);
}

@end
