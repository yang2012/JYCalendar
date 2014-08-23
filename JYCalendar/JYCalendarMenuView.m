//
//  JYCalendarMenuView.m
//  JYCalendar
//
//  Created by Justin Yang on 14-1-26.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

#import "RACEXTScope.h"

#import "JYCalendarMenuView.h"
#import "JYWeatherManager.h"

#import "NSDate+JYCalendar.h"
#import "UIView+JYCalendar.h"

static const NSInteger kTagForMonthView     = 1;
static const NSInteger kTagForDayView       = 2;
static const NSInteger kTagForCalendarsView = 3;
static const NSInteger kTagForAgendaView    = 4;

static CGFloat kHeightofMenuView = 145.0f;

@interface JYCalendarMenuView ()

@property (nonatomic, assign) BOOL showed;
@property (nonatomic, assign) BOOL animating;
@property (nonatomic, assign) BOOL loading;

@property (nonatomic, strong) UIView *originView;
@property (nonatomic, strong) UIView *menuView;

@property (nonatomic, strong) UIButton *monthButton;
@property (nonatomic, strong) UIButton *dayButton;
@property (nonatomic, strong) UIButton *agendaButton;
@property (nonatomic, strong) UIButton *calendarsButton;

@property (nonatomic, strong) UIImageView *conditionImageView;
@property (nonatomic, strong) UIImageView *seperatorLineImageView;
@property (nonatomic, strong) UILabel *temperatureLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *conditionsLabel;

@property (nonatomic, strong) UIImageView *loadingImageView;

@end

@implementation JYCalendarMenuView

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
    
    self.showed    = NO;
    self.animating = NO;
    self.loading   = NO;
    
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.width, kHeightofMenuView)];

    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bg_loading"]];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImageView.frame = CGRectMake(0.0f, 0.0f, self.menuView.width, self.menuView.height);
    [self.menuView addSubview:backgroundImageView];
    
    CGSize menuSize = CGSizeMake(self.width / 4, 60);
    self.monthButton = [self _buttonWithRect:CGRectMake(0.0f, self.menuView.height - menuSize.height, menuSize.width, menuSize.height)
                                         tag:kTagForMonthView
                                       image:@"menu_ico_month_normal"
                            highlightedImage:@"menu_ico_month_press"
                                       title:@"Month"];
    [self.menuView addSubview:self.monthButton];
    
    self.dayButton = [self _buttonWithRect:CGRectMake(menuSize.width, self.menuView.height - menuSize.height, menuSize.width, menuSize.height)
                                       tag:kTagForDayView
                                     image:@"menu_ico_day_normal"
                          highlightedImage:@"menu_ico_day_press"
                                     title:@"Day"];
    [self.menuView addSubview:self.dayButton];
    
    self.agendaButton    = [self _buttonWithRect:CGRectMake(menuSize.width * 2, self.menuView.height - menuSize.height, menuSize.width, menuSize.height)
                                             tag:kTagForAgendaView
                                           image:@"menu_ico_list_normal"
                                highlightedImage:@"menu_ico_list_press"
                                           title:@"Agenda"];
    [self.menuView addSubview:self.agendaButton];
    
    
    self.calendarsButton = [self _buttonWithRect:CGRectMake(menuSize.width * 3, self.menuView.height - menuSize.height, menuSize.width, menuSize.height)
                                             tag:kTagForCalendarsView
                                           image:@"menu_ico_calendar_normal"
                                highlightedImage:@"menu_ico_calendar_press"
                                           title:@"Calendars"];
    [self.menuView addSubview:self.calendarsButton];
    
    self.conditionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    self.conditionImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.conditionImageView setImage:[UIImage imageNamed:@"clock"]];
    [self.menuView addSubview:self.conditionImageView];
    
    self.seperatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 1.0f, 32.0f)];
    [self.seperatorLineImageView setImage:[UIImage imageNamed:@"menu_div_line"]];
    [self.menuView addSubview:self.seperatorLineImageView];
    
    self.temperatureLabel = [[UILabel alloc] init];
    self.temperatureLabel.backgroundColor = [UIColor clearColor];
    self.temperatureLabel.textColor = [UIColor whiteColor];
    self.temperatureLabel.textAlignment = NSTextAlignmentCenter;
    self.temperatureLabel.font = [UIFont boldSystemFontOfSize:30];
    [self.menuView addSubview:self.temperatureLabel];
    
    self.cityLabel = [[UILabel alloc] init];
    self.cityLabel.backgroundColor = [UIColor clearColor];
    self.cityLabel.textColor = [UIColor whiteColor];
    self.cityLabel.font = [UIFont systemFontOfSize:11];
    [self.menuView addSubview:self.cityLabel];
    
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.backgroundColor = [UIColor clearColor];
    self.dateLabel.textColor = [UIColor whiteColor];
    self.dateLabel.font = [UIFont systemFontOfSize:11];
    [self.menuView addSubview:self.dateLabel];
    
    self.conditionsLabel = [[UILabel alloc] init];
    self.conditionsLabel.backgroundColor = [UIColor clearColor];
    self.conditionsLabel.font = [UIFont systemFontOfSize:11];
    self.conditionsLabel.textColor = [UIColor whiteColor];
    [self.menuView addSubview:self.conditionsLabel];
    
    UIImageView *loadingBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 44.0f) / 2, 25.0f, 44.0f, 44.0f)];
    [loadingBackgroundImageView setImage:[UIImage imageNamed:@"clock"]];
    loadingBackgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    loadingBackgroundImageView.hidden = YES;
    [self.menuView addSubview:loadingBackgroundImageView];
    
    self.loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 44.0f) / 2, 25.0f, 44.0f, 44.0f)];
    [self.loadingImageView setImage:[UIImage imageNamed:@"clock_hand"]];
    self.loadingImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.loadingImageView.hidden = YES;
    [self.menuView addSubview:self.loadingImageView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tap:)];
    [self addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *updateGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_updateWeather)];
    self.conditionImageView.userInteractionEnabled = YES;
    [self.conditionImageView addGestureRecognizer:updateGesture];
    
    @weakify(self);
    [[[RACObserve([JYWeatherManager sharedManager], currentCondition)
      deliverOn:RACScheduler.mainThreadScheduler]
     filter:^BOOL(JYCondition *newCondition) {
         return newCondition != nil;
     }]
     subscribeNext:^(JYCondition *newCondition) {
         @strongify(self);
         self.loading                  = NO;
         
         self.conditionImageView.image = [UIImage imageNamed:[newCondition imageName]];
         
         self.temperatureLabel.text    = [NSString stringWithFormat:@"%.0f°",newCondition.temperature.floatValue];
         [self.temperatureLabel sizeToFit];
         
         self.cityLabel.text           = [newCondition.locationName capitalizedString];
         [self.cityLabel sizeToFit];
         
         NSDate *date                  = newCondition.date;
         self.dateLabel.text           = [NSString stringWithFormat:@"%@, %@ %ld.", date.weekdayName, date.monthName, (long)date.day];
         [self.dateLabel sizeToFit];
         
         self.conditionsLabel.text     = newCondition.conditionDescription;
         [self.conditionsLabel sizeToFit];
         
         [self setNeedsLayout];
     }];
    
    [[RACObserve(self, loading) deliverOn:RACScheduler.mainThreadScheduler] subscribeNext:^(NSNumber *loading) {
        @strongify(self);
        self.loadingImageView.hidden       = !loading.boolValue;
        loadingBackgroundImageView.hidden  = !loading.boolValue;
        
        self.conditionImageView.hidden     = loading.boolValue;
        self.seperatorLineImageView.hidden = loading.boolValue;
        self.temperatureLabel.hidden       = loading.boolValue;
        self.cityLabel.hidden              = loading.boolValue;
        self.dateLabel.hidden              = loading.boolValue;
        self.conditionsLabel.hidden        = loading.boolValue;
        
        if (loading.boolValue) {
            [self _startLoadingAnimation];
        } else {
            [self _stopLoadingAnimation];
        }
    }];
}

- (void)layoutSubviews
{
    CGFloat topMargin = 25.0f;
    CGFloat leftMargin = 20.0f;
    self.conditionImageView.frame = (CGRect){leftMargin, topMargin, self.conditionImageView.bounds.size};
    self.seperatorLineImageView.frame = (CGRect){self.conditionImageView.x + self.conditionImageView.width + leftMargin, topMargin, self.seperatorLineImageView.bounds.size};
    self.temperatureLabel.frame = (CGRect){self.seperatorLineImageView.x + self.seperatorLineImageView.width + leftMargin, topMargin, self.temperatureLabel.bounds.size};
    self.cityLabel.frame = (CGRect){self.temperatureLabel.x + self.temperatureLabel.width + leftMargin, topMargin + 5.0f, self.cityLabel.bounds.size};
    self.dateLabel.frame = (CGRect){self.temperatureLabel.x + self.temperatureLabel.width + leftMargin, self.cityLabel.y + self.cityLabel.height, self.dateLabel.bounds.size};
    self.conditionsLabel.frame = (CGRect){self.dateLabel.x + self.dateLabel.width, self.cityLabel.y + self.cityLabel.height, self.conditionsLabel.frame.size};
}

- (UIButton *)_buttonWithRect:(CGRect)rect
                        tag:(NSInteger)tag
                      image:(NSString *)imageName
           highlightedImage:(NSString *)highlightedImageName
                      title:(NSString *)title
{
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    button.backgroundColor = [UIColor clearColor];
    button.layer.borderWidth = 0.5f;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.tag = tag;
    [button addTarget:self action:@selector(_clickMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName] highlightedImage:[UIImage imageNamed:highlightedImageName]];
    imageView.frame = CGRectMake((button.width - 21.0f)/2, (button.height - 21.0f) / 2 - 5.0f, 21.0f, 21.0f);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:10.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    [label sizeToFit];
    label.x = (button.width - label.width) / 2;
    label.y = imageView.y + imageView.height;
    [button addSubview:label];
    
    [[RACObserve(button, selected) deliverOn:RACScheduler.mainThreadScheduler] subscribeNext:^(NSNumber *selected) {
        imageView.highlighted = selected.boolValue;
        if (selected.boolValue) {
            button.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5];
            label.textColor = [UIColor blackColor];
        } else {
            button.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor whiteColor];
        }
    }];
    
    return button;
}

- (void)presentMenuInView:(UIView *)view animated:(BOOL)animated
{
    if (self.animating) {
        return;
    }
    
    self.originView = view;
    
    [self _addSubviewsToOriginView];
    
    [self _updateWeather];
    
    self.animating = YES;
    [UIView animateWithDuration:animated ? 0.3f : 0.0f animations:^{
        self.originView.y = kHeightofMenuView;
        self.y            = kHeightofMenuView;
        self.alpha        = 0.3f;
    } completion:^(BOOL finished) {
        self.animating = NO;
        self.showed    = YES;
    }];
}

- (void)dismissMenuAnimated:(BOOL)animated
{
    [self _hideMenuAnimated:animated completion:nil];
}

- (void)dismissMenuAnimated:(BOOL)animated completion:(void (^)())finishedBlock
{
    [self _hideMenuAnimated:animated completion:finishedBlock];
}

#pragma mark - Private Methods

- (void)_updateWeather
{
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    [[JYWeatherManager sharedManager] findCurrentLocation];
}

- (void)_startLoadingAnimation
{
    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.fromValue = 0;
    spinAnimation.byValue = [NSNumber numberWithFloat:2*M_PI];
    spinAnimation.duration = 3.0f;
    spinAnimation.repeatCount = HUGE_VALF;
    [self.loadingImageView.layer addAnimation:spinAnimation forKey:@"spinAnimation"];
}

- (void)_stopLoadingAnimation
{
    [self.loadingImageView.layer removeAllAnimations];
}

- (void)_hideMenuAnimated:(BOOL)animated completion:(void (^)())finishedBlock
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

- (void)_tap:(id)sender
{
    [self _hideMenuAnimated:YES completion:nil];
}

- (void)_clickMenu:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(menuView:didClickMenuAtIndex:)]) {
        [self.delegate menuView:self didClickMenuAtIndex:sender.tag];
    }
    switch (sender.tag) {
        case kTagForMonthView:
            self.monthButton.selected = YES;
            self.dayButton.selected = NO;
            self.agendaButton.selected = NO;
            self.calendarsButton.selected = NO;
            break;
        case kTagForDayView:
            self.monthButton.selected = NO;
            self.dayButton.selected = YES;
            self.agendaButton.selected = NO;
            self.calendarsButton.selected = NO;
            break;
        case kTagForAgendaView:
            self.monthButton.selected = NO;
            self.dayButton.selected = NO;
            self.agendaButton.selected = YES;
            self.calendarsButton.selected = NO;
            break;
        case kTagForCalendarsView:
            self.monthButton.selected = NO;
            self.dayButton.selected = NO;
            self.agendaButton.selected = NO;
            self.calendarsButton.selected = YES;
        default:
            break;
    }
}

- (void)_addSubviewsToOriginView
{
    self.menuView.width = self.originView.width;
    [self.originView.superview addSubview:self.menuView];
    [self.originView.superview sendSubviewToBack:self.menuView];
    
    self.frame = self.originView.frame;
    [self.originView.superview addSubview:self];
}

- (void)_removeSubviewsFromOriginView
{
    [self removeFromSuperview];
    [self.menuView removeFromSuperview];
}

@end
