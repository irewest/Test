//
//  HomeViewController.m
//  IreTool
//
//  Created by IreWesT on 2016/10/8.
//  Copyright © 2016年 IreWesT. All rights reserved.
//

#import "HomeViewController.h"
#import "NSDate+convenience.h"
#import "UIViewExt.h"
#import "Defines.h"
#import "UIUtils.h"
#import <EventKit/EventKit.h>
#import "NSString+MD5.h"

const static NSInteger  TagButtonMinus  = 200;
const static NSInteger  TagButtonPlus   = 201;
const static NSInteger  TagBaseCell     = 1000;
const static NSInteger  TagCellCount    = 2000;
static UIColor *CellBorderColor;
static UIColor *CellSelectedBorderColor;

@interface HomeViewController ()<
    UIScrollViewDelegate
>

@property (nonatomic, retain) UILabel       *titleLabel;
@property (nonatomic, retain) UIScrollView  *scrollView;
@property (nonatomic, assign) CGFloat       cellLength;

@property (nonatomic, copy) NSString        *filePath;
@property (nonatomic, retain) NSArray       *cacheData;
@property (nonatomic, retain) NSMutableDictionary   *data;

@property (nonatomic, retain) NSMutableArray*views;
@property (nonatomic, retain) UIView        *currentMonthView;
@property (nonatomic, retain) UIView        *todayMonthView;
@property (nonatomic, assign) BOOL          isAnimating;

@property (nonatomic, retain) NSDate        *currentMonth;
@property (nonatomic, retain) NSMutableArray*currentMonthData;
@property (nonatomic, assign) NSInteger     selectedStamp;
@property (nonatomic, retain) NSMutableDictionary   *selectedDict;
@property (nonatomic, retain) UIView        *selectedCell;

//信息展示
@property (nonatomic, retain) UIView        *infoView;
@property (nonatomic, retain) UILabel       *infoTitle;
@property (nonatomic, retain) UILabel       *countLabel;
@property (nonatomic, retain) UIButton      *modifyButton;
@property (nonatomic, retain) UIButton      *cancelButton;
@property (nonatomic, assign) BOOL          isModified;
@property (nonatomic, assign) NSInteger     originCount;
@property (nonatomic, retain) UIImageView   *ticketButtonPlus;
@property (nonatomic, retain) UIImageView   *ticketButtonMinus;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self showViews];
    [self refreshInfoData];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
//    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
//    NSLog(@"status:%ld", status);
    
//    EKEventStore *eventStore = [[EKEventStore alloc] init];
//    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
//
//        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (error)
//                {
//                }else if (!granted)
//                {
//                    NSLog(@"refused!");
//                    //被⽤用户拒绝,不允许访问⽇日历
//                }else{
//                    //事件保存到⽇日历
//                    //创建事件
//                    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
//                    event.title = @"测试";
//                    event.location = @"玄武区珠江路600谷阳大厦";
//                    //NSString *urlStirng = [NSString stringWithFormat:@"babyweekend://?push_type=6", [NSString shortUrl:@"?push_type=6"]];
//                    NSString *urlString = @"babyweekend://?push_type=6";
//                    event.URL = [NSURL URLWithString:urlString];
//                    NSLog(@"%@", event.URL.absoluteString);
//                    //设定事件开始时间
//                    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:3600];
//                    event.startDate = startDate;
//                    //设定事件结束时间
//                    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 2];
//                    event.endDate = endDate;
//                    //添加提醒 可以添加多个，设定事件多久以前开始提醒
//                    //event.allDay = YES;
//                    //在事件前多少秒开始事件提醒-5.0f
//                    [event addAlarm:[EKAlarm alarmWithRelativeOffset:-3000]];
//                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
//                    NSError *err;
//                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
//                    
//                    NSString *savedEventId = event.eventIdentifier;  // Store this so you can access this event later
//                    NSLog(@"id:%@", savedEventId);
//                }
//            });
//        }];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initView {

    CellBorderColor = RGBCOLOR(229, 229, 229);
    CellSelectedBorderColor = RGBCOLOR(45, 172, 188);
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = DefaultViewBackgroundColor;
    self.view = view;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, CUSTOM_NAV_HEIGHT)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor       = [UIColor blackColor];
    _titleLabel.font            = [UIFont systemFontOfSize:17.0f];
    _titleLabel.textAlignment   = NSTextAlignmentCenter;
    self.navigationItem.titleView   = _titleLabel;
    
    _cellLength = APP_SCREEN_WIDTH / 7;
    
    NSArray *dayName = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    UIView *weekdayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 34)];
    weekdayView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:weekdayView];
    for (int i = 0; i < 7; i++) {
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * _cellLength, 0, _cellLength, weekdayView.height)];
        weekdayLabel.backgroundColor    = [UIColor whiteColor];
        if (i == 0 || i == 6) {
            weekdayLabel.textColor      = RGBCOLOR(255, 78, 0);
            
        }else {
            weekdayLabel.textColor      = RGBCOLOR(66, 66, 6);
        }
        weekdayLabel.font               = [UIFont systemFontOfSize:14.0f];
        weekdayLabel.textAlignment      = NSTextAlignmentCenter;
        weekdayLabel.text               = dayName[i];
        [weekdayView addSubview:weekdayLabel];
    }
    
    CGFloat height = _cellLength * 6;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, weekdayView.bottom, APP_SCREEN_WIDTH, height)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.pagingEnabled   = YES;
    _scrollView.delegate        = self;
    _scrollView.showsHorizontalScrollIndicator  = NO;
    _scrollView.contentSize     = CGSizeMake(_scrollView.width * 3, _scrollView.height);
    [self.view addSubview:_scrollView];
    
    [self initInfoView];
}

- (void)initInfoView {
    
    _isModified = NO;
    
    _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, _scrollView.bottom, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - NavHeight - _scrollView.bottom)];
    _infoView.backgroundColor   = [UIColor whiteColor];
    [self.view addSubview:_infoView];

    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _infoView.width, 45)];
    titleView.backgroundColor   = [UIColor whiteColor];
    [_infoView addSubview:titleView];
    
    CGFloat marginX = 15.0f;
    CALayer *borderLeft = [CALayer layer];
    borderLeft.backgroundColor  = RGBCOLOR(73, 189, 204).CGColor;
    borderLeft.frame            = CGRectMake(marginX, (titleView.height - 15) / 2, 2.0f, 15);
    [titleView.layer addSublayer:borderLeft];
    
    _infoTitle = [[UILabel alloc] initWithFrame:CGRectMake(marginX + 10, (titleView.height - 15) / 2, 120, 15)];
    _infoTitle.backgroundColor  = [UIColor whiteColor];
    _infoTitle.textColor        = RGBCOLOR(73, 189, 204);
    _infoTitle.font             = [UIFont systemFontOfSize:15.0f];
    [titleView addSubview:_infoTitle];
    
    CALayer *border = [CALayer layer];
    border.backgroundColor  = DefaultBorderColor.CGColor;
    border.frame            = CGRectMake(0, titleView.height - .5f, titleView.width, .5f);
    [titleView.layer addSublayer:border];
    
    UIView *countView = [[UIView alloc] initWithFrame:CGRectMake(0, titleView.bottom + 8, _infoView.width, 50)];
    countView.backgroundColor   = [UIColor whiteColor];
    [_infoView addSubview:countView];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(marginX, (countView.height - 20) / 2, 20, 20)];
    icon.backgroundColor    = [UIColor clearColor];
    icon.image              = [UIImage imageNamed:@"home_icon_flane"];
    [countView addSubview:icon];
    
    UILabel *countTitle = [[UILabel alloc] initWithFrame:CGRectMake(icon.right + 5, 0, 60, countView.height)];
    countTitle.backgroundColor  = [UIColor whiteColor];
    countTitle.textColor        = RGBCOLOR(66, 66, 66);
    countTitle.font             = [UIFont systemFontOfSize:15.0f];
    countTitle.text             = @"次数";
    [countView addSubview:countTitle];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(countTitle.right + 5, 0, 50, countView.height)];
    _countLabel.backgroundColor = [UIColor whiteColor];
    _countLabel.textColor       = countTitle.textColor;
    _countLabel.font            = countTitle.font;
    [countView addSubview:_countLabel];
    
    CALayer *countBorder = [CALayer layer];
    countBorder.backgroundColor  = DefaultBorderColor.CGColor;
    countBorder.frame            = CGRectMake(marginX, countView.height - .5f, countView.width - marginX, .5f);
    [countView.layer addSublayer:countBorder];
    
    _modifyButton = [[UIButton alloc] initWithFrame:CGRectMake(countView.width - 60, 0, 60 - marginX, countView.height - .5f)];
    _modifyButton.backgroundColor   = [UIColor whiteColor];
    _modifyButton.titleLabel.font   = [UIFont systemFontOfSize:14.0f];
    [_modifyButton setTitle:@"修改" forState:UIControlStateNormal];
    [_modifyButton setTitleColor:RGBCOLOR(170, 170, 170) forState:UIControlStateNormal];
    [_modifyButton addTarget:self action:@selector(countViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [countView addSubview:_modifyButton];
    
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(_modifyButton.left - 10 - _modifyButton.width, 0, _modifyButton.width, _modifyButton.height)];
    _cancelButton.backgroundColor   = [UIColor whiteColor];
    _cancelButton.titleLabel.font   = [UIFont systemFontOfSize:14.0f];
    _cancelButton.hidden            = YES;
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:RGBCOLOR(170, 170, 170) forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [countView addSubview:_cancelButton];
    
    _ticketButtonMinus = [[UIImageView alloc] initWithFrame:CGRectMake(_countLabel.right + 5, (countView.height - 33) / 2, 33, 33)];
    _ticketButtonMinus.image            = [UIImage imageNamed:@"submit_btn_minus"];
    _ticketButtonMinus.tag              = TagButtonMinus;
    _ticketButtonMinus.layer.cornerRadius   = 4.0f;
    _ticketButtonMinus.layer.masksToBounds  = YES;
    _ticketButtonMinus.layer.borderWidth    = .5f;
    _ticketButtonMinus.layer.borderColor    = RGBCOLOR(215, 215, 215).CGColor;
    _ticketButtonMinus.hidden               = YES;
    [countView addSubview:_ticketButtonMinus];
    UITapGestureRecognizer *minusTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeCountClick:)];
    [_ticketButtonMinus addGestureRecognizer:minusTap];
    
    _ticketButtonPlus = [[UIImageView alloc] initWithFrame:CGRectMake(_ticketButtonMinus.right + 20, _ticketButtonMinus.top, 33, 33)];
    _ticketButtonPlus.image            = [UIImage imageNamed:@"submit_btn_plus"];
    _ticketButtonPlus.tag              = TagButtonPlus;
    _ticketButtonPlus.layer.cornerRadius   = 4.0f;
    _ticketButtonPlus.layer.masksToBounds  = YES;
    _ticketButtonPlus.layer.borderWidth    = .5f;
    _ticketButtonPlus.layer.borderColor    = RGBCOLOR(215, 215, 215).CGColor;
    _ticketButtonPlus.hidden                = YES;
    [countView addSubview:_ticketButtonPlus];
    UITapGestureRecognizer *plusTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeCountClick:)];
    [_ticketButtonPlus addGestureRecognizer:plusTap];
}

- (void)showViews {

    [self loadDataWithMonth:_currentMonth];
}

- (void)loadDataWithMonth:(NSDate *)month {
    
    _currentMonthView = [self calendarViewWithMonth:month];
    
    if (_views) {
        for (UIView *view in _views) {
            [view removeFromSuperview];
        }
        [_views removeAllObjects];
    }else {
        _views = [NSMutableArray new];
    }
    
    [_views addObject:[self calendarViewWithMonth:[_currentMonth offsetMonth:-1]]];
    [_views addObject:_currentMonthView];
    [_views addObject:[self calendarViewWithMonth:[_currentMonth offsetMonth:+1]]];
    
    //_selectedMonthData = _data[[NSDate yearAndMonth:_currentMonth]];
//    if (_todayMonth.year == month.year && _todayMonth.month == month.month) {
//        _todayMonthData = _selectedMonthData;
//    }else {
//        _todayMonthData = _dataDic[[NSDate yearAndMonth:_todayMonth]];
//    }
    [self updateViewFrame];
}

- (UIView *)calendarViewWithMonth:(NSDate *)month {
    
    NSInteger firstWeekDay = [month firstWeekDayInMonth];
    NSInteger numRows = [self numberOfRowsWithMonth:month];
    NSInteger numBlocks = numRows * 7;
    NSInteger numDays = [month numDaysInMonth];
    
    NSMutableArray *monthData = [self getMonthData:month];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, _scrollView.height)];
    view.backgroundColor    = [UIColor whiteColor];
    [_scrollView addSubview:view];
    
    float originX = 0;
    float originY = 0;
    for (int i = 1; i <= numBlocks; i++) {
        UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, _cellLength, _cellLength)];
        cell.backgroundColor    = [UIColor whiteColor];
        cell.layer.borderWidth  = .5f;
        cell.layer.borderColor  = CellBorderColor.CGColor;
        [view addSubview:cell];
        
        //weekday
        if (i >= firstWeekDay && i < (numDays + firstWeekDay)) {
            NSInteger day = i - firstWeekDay + 1;
            NSMutableDictionary *dict = monthData[day - 1];
            
            if (_selectedStamp == [dict[@"stamp"] integerValue]) {
                cell.layer.borderWidth  = 1.0f;
                cell.layer.borderColor  = CellSelectedBorderColor.CGColor;
                _selectedCell = cell;
            }
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 3, _cellLength - 10, 15)];
            label.backgroundColor   = [UIColor clearColor];
            label.textColor         = RGBCOLOR(52, 52, 52);
            label.text              = [NSString stringWithFormat:@"%ld", (long)day];
            label.font              = [UIFont systemFontOfSize:15.0f];
            [cell addSubview:label];
            
            CGFloat fontSize = 20.0f;
            NSInteger count = [dict[@"count"] integerValue];
            UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _cellLength - fontSize - 3, _cellLength - 8, fontSize)];
            countLabel.backgroundColor  = [UIColor clearColor];
            countLabel.textColor        = RGBCOLOR(255, 115, 115);
            countLabel.font             = [UIFont systemFontOfSize:fontSize];
            countLabel.textAlignment    = NSTextAlignmentRight;
            countLabel.tag              = TagCellCount;
            countLabel.text             = [NSString stringWithFormat:@"%ld", count];
            countLabel.hidden           = YES;
            [cell addSubview:countLabel];
            if (count > 0) {
                countLabel.hidden       = NO;
            }
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellClick:)];
            [cell addGestureRecognizer:tap];
            cell.tag = TagBaseCell + day;
        }
        
        if (i % 7 == 0) {
            originX = 0;
            originY += _cellLength;
        }else {
            originX += _cellLength;
        }
    }
    
    return view;
}

- (void)updateViewFrame {
    
    for (int i = 0; i < 3; i++) {
        UIView *view = (UIView *)_views[i];
        view.left = i * view.width;
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.width, 0) animated:NO];
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){
                     }
                     completion:^(BOOL finished){
                         
                     }];

    [self changeTitle];
    _isAnimating = NO;
}

#pragma mark - Data

- (void)initData {
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [array objectAtIndex:0];
    _filePath = [documents stringByAppendingString:@"/cacheDataList.plist"];
    
    _data = [[NSMutableDictionary alloc] initWithContentsOfFile:_filePath] ? : [NSMutableDictionary new];
    
    _currentMonth = [NSDate currentMonth];
    _selectedStamp = [UIUtils todayStamp];
    _currentMonthData = [self getMonthData:_currentMonth];
    _selectedDict = _currentMonthData[[NSDate date].day - 1];
}

- (NSMutableArray *)getMonthData:(NSDate *)date {

    NSString *dateString = [NSDate yearAndMonth:date];
    NSMutableArray *data = [NSMutableArray new];
    
    if ([[_data allKeys] containsObject:dateString]) {
        for (NSDictionary *dict in [_data objectForKey:dateString]) {
            NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
            [data addObject:mutDict];
        }
    }else {
        for (int i = 1; i <= [date numDaysInMonth]; i++) {
            NSString *dateString = [NSString stringWithFormat:@"%ld-%02ld-%02d", date.year, date.month, i];
            NSInteger count = 0;
            NSInteger stamp = [UIUtils stampFromDateString:dateString];
            NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithDictionary:@{@"date":dateString,
                                    @"count":[NSString stringWithFormat:@"%ld", count],
                                    @"stamp":[NSString stringWithFormat:@"%ld", stamp]}];
            [data addObject:mutDict];
        }
    }
    
    return data;
}

- (void)refreshInfoData {

    _infoTitle.text     = _selectedDict[@"date"];
    _countLabel.text    = [NSString stringWithFormat:@"%ld", [_selectedDict[@"count"] integerValue]];
}

#pragma mark - Private Methods

- (void)changeTitle {

    NSInteger total = 0;
    for (NSDictionary *dict in _currentMonthData) {
        NSInteger count = [dict[@"count"] integerValue];
        total += count;
    }
    
    NSString *title = [NSString stringWithFormat:@"%ld年%ld月 (%ld)", _currentMonth.year, _currentMonth.month, total];
    _titleLabel.text = title;
}

- (NSInteger)numberOfRowsWithMonth:(NSDate *)month {
    
    float lastBlock = [month numDaysInMonth] + ([month firstWeekDayInMonth]-1);
    return ceilf(lastBlock / 7);
}

- (void)refreshTicketButton {
    
    NSInteger currentCount = [_countLabel.text integerValue];
    if (currentCount <= 0) {
        _ticketButtonMinus.backgroundColor  = RGBCOLOR(223, 223, 223);
        _ticketButtonMinus.userInteractionEnabled = NO;
    }else {
        _ticketButtonMinus.backgroundColor  = RGBCOLOR(73, 189, 204);
        _ticketButtonMinus.userInteractionEnabled = YES;
    }

    _ticketButtonPlus.backgroundColor  = RGBCOLOR(73, 189, 204);
    _ticketButtonPlus.userInteractionEnabled = YES;
}

- (void)changeButtonDone {

    NSInteger count = [_countLabel.text integerValue];
    _selectedDict[@"count"] = [NSString stringWithFormat:@"%ld", count];
    
    UILabel *cellCount = (UILabel *)[_selectedCell viewWithTag:TagCellCount];
    cellCount.text = _selectedDict[@"count"];
    if (count > 0) {
        cellCount.hidden    = NO;
    }else {
        cellCount.hidden    = YES;
    }
    
    [_data setObject:_currentMonthData forKey:[NSDate yearAndMonth:_currentMonth]];
    [_data writeToFile:_filePath atomically:YES];
    
    [self changeTitle];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int x = scrollView.contentOffset.x;
    if (x == scrollView.frame.size.width || _isAnimating) {
        return;
    }
    
    if (x >= scrollView.frame.size.width * 2) {//next month
        [self moveRightMonth];
        
    }else if (x < scrollView.frame.size.width){//last month
        [self moveLeftMonth];
    }
    
    //_selectedMonthData = _data[[NSDate yearAndMonth:_currentMonth]];
}

#pragma mark - Action

- (void)moveLeftMonth {
    
    _isAnimating = YES;
    
    _currentMonth = [_currentMonth offsetMonth:-1];
    _currentMonthData = [self getMonthData:_currentMonth];
    _currentMonthView = _views[0];
    UIView *view = _views[2];
    [view removeFromSuperview];
    [_views removeObject:view];
    [_views insertObject:[self calendarViewWithMonth:[_currentMonth offsetMonth:-1]]
                      atIndex:0];
    [self updateViewFrame];
}

- (void)moveRightMonth {
    
    _isAnimating = YES;
    
    _currentMonth = [_currentMonth offsetMonth:+1];
    _currentMonthData = [self getMonthData:_currentMonth];
    UIView *view = _views[0];
    [view removeFromSuperview];
    [_views removeObject:view];
    [_views addObject:[self calendarViewWithMonth:[_currentMonth offsetMonth:+1]]];
    
    [self updateViewFrame];
}

- (void)cellClick:(UITapGestureRecognizer *)tap {

    if (tap.view == _selectedCell) {
        return;
    }
    
    NSInteger index = tap.view.tag - TagBaseCell;
    _selectedDict = _currentMonthData[index - 1];
    
    NSInteger todayStamp = [UIUtils todayStamp];
    _selectedStamp = [_selectedDict[@"stamp"] integerValue];
    if (todayStamp < _selectedStamp) {
        _modifyButton.hidden    = YES;
    }else {
        _modifyButton.hidden    = NO;
    }
    
    [self refreshInfoData];
    
    if (_selectedStamp == tap.view.tag) {
        return;
    }
    
    tap.view.layer.borderColor = CellSelectedBorderColor.CGColor;
    tap.view.layer.borderWidth = 1.0f;
    UIView *lastView = _selectedCell;
    _selectedCell = tap.view;
    if (lastView) {
        lastView.layer.borderColor = CellBorderColor.CGColor;
        lastView.layer.borderWidth = .5f;
    }
}

- (void)countViewClick:(UIButton *)button {
    
    if (!_isModified) {//修改
        [_modifyButton setTitle:@"完成" forState:UIControlStateNormal];
    }else {//完成
        [_modifyButton setTitle:@"修改" forState:UIControlStateNormal];
    }
    
    if (button) {
        [self refreshTicketButton];
        
        if (!_isModified) {//修改
            _originCount = [_countLabel.text integerValue];
        }else {//完成
            [self changeButtonDone];
        }
    }
    
    _ticketButtonMinus.hidden   = _isModified;
    _ticketButtonPlus.hidden    = _isModified;
    _cancelButton.hidden        = _isModified;
    _isModified = !_isModified;
}

- (void)cancelButtonClick:(UIButton *)button {

    [self countViewClick:nil];
    _countLabel.text = [NSString stringWithFormat:@"%ld", _originCount];
}

- (void)changeCountClick:(UITapGestureRecognizer *)tap {
    
    NSInteger tag = tap.view.tag;
    NSInteger currentCount = [_countLabel.text integerValue];
    if (tag == TagButtonMinus) {//减
        
        if (currentCount <= 0) {
            return;
        }
        currentCount--;
    }else {
        currentCount++;
    }
    
    _countLabel.text = [NSString stringWithFormat:@"%ld", currentCount];
    [self refreshTicketButton];
}

@end
