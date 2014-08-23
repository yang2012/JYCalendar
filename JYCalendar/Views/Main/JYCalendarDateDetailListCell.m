//
//  JYCalendarDateDetailCell.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-22.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "JYCalendarDateDetailListCell.h"
#import "JYEvent.h"
#import "NSDate+JYCalendar.h"
#import "UIView+JYCalendar.h"

static NSString *kDateDetailCellIdentifier = @"JYDateDetailCell";

static NSInteger kTagForImageView = 1;
static NSInteger kTagForStartTimeLabel = 2;
static NSInteger kTagForEventContentLabel = 3;

@interface JYCalendarDateDetailListCell () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *eventTableView;

@end

@implementation JYCalendarDateDetailListCell

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
    self.eventTableView            = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.width, self.height)];
    self.eventTableView.alwaysBounceVertical = NO;
    self.eventTableView.bounces = NO;
    self.eventTableView.delegate   = self;
    self.eventTableView.dataSource = self;
    [self.contentView addSubview:self.eventTableView];
    
    // Set up seperator
    [self.eventTableView setTableFooterView:[UIView new]];
    [self.eventTableView setSeparatorInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setEventEntities:(NSArray *)eventEntities
{
    _eventEntities = eventEntities;
    
    [self.eventTableView reloadData];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.eventEntities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.eventTableView dequeueReusableCellWithIdentifier:kDateDetailCellIdentifier];
    if (cell == NULL) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDateDetailCellIdentifier];
        
        UIImageView *indicatorImageView = [[UIImageView alloc] init];
        indicatorImageView.frame = CGRectMake(0.1f, 0.1f, 21.0f, 21.0f);
        indicatorImageView.tag = kTagForImageView;
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 5.0f, 21.2f, 21.2f)];
        containerView.backgroundColor = [UIColor blueColor];
        containerView.layer.cornerRadius = 10.6f;
        [containerView addSubview:indicatorImageView];
        [cell.contentView addSubview:containerView];
        
        UILabel *eventStartTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(35.0f, 8.0f, 0.0f, 0.0f)];
        eventStartTimeLabel.tag = kTagForStartTimeLabel;
        eventStartTimeLabel.font = [UIFont systemFontOfSize:12.0f];
        eventStartTimeLabel.textColor = [UIColor blueColor];
        [cell.contentView addSubview:eventStartTimeLabel];
        
        UILabel *eventContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0f, 8.0f, 0.0f, 0.0f)];
        eventContentLabel.tag = kTagForEventContentLabel;
        eventContentLabel.font = [UIFont systemFontOfSize:11.0f];
        [cell.contentView addSubview:eventContentLabel];
    }
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    JYEvent *eventEntity = self.eventEntities[indexPath.row];
    
    UIImageView *indicatorImageView = (UIImageView *)[cell viewWithTag:kTagForImageView];
    if (eventEntity.startDate.isAM) {
        indicatorImageView.image = [UIImage imageNamed:@"comm_ico_timeline_am@2x"];
    } else {
        indicatorImageView.image = [UIImage imageNamed:@"comm_ico_timeline_pm@2x"];
    }
    
    UILabel *eventStartTimeLabel = (UILabel *)[cell viewWithTag:kTagForStartTimeLabel];
    eventStartTimeLabel.text = [eventEntity.startDate description:@"HH:mm"];
    [eventStartTimeLabel sizeToFit];
    
    UILabel *eventContentLabel = (UILabel *)[cell viewWithTag:kTagForEventContentLabel];
    eventContentLabel.text = eventEntity.content;
    [eventContentLabel sizeToFit];
}

@end
