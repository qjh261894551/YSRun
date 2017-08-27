//
//  MCCalendarViewController.m
//  MCRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCCalendarViewController.h"
#import "MCCalendarRecordView.h"
#import "MCAppMacro.h"
#import "MCContentTable.h"
#import "MCHeartRateRecordViewController.h"
#import "MCRunDataRecordViewController.h"
#import "MCDatabaseManager.h"
#import "MCRunDatabaseModel.h"
#import "MCModelReformer.h"
#import "NSDate+MCDateLogic.h"
#import "MCDataRecordModel.h"
#import "MCDevice.h"

#import "MCSportRecordViewController.h"

@interface MCCalendarViewController () <MCContentTableDelegate, MCCalendarRecordViewDelegate>

@property (nonatomic, weak) IBOutlet MCCalendarRecordView *calendarView;
@property (nonatomic, weak) IBOutlet MCContentTable *contentTable;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *calendarHeightConstraint;

@end

@implementation MCCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSDate *currentDate = [self getCurrentDate];
    [self.calendarView resetCalendarWithDate:currentDate];
    
    // 初始化时设置一下，否则即使选中有跑步数据的日期也不会显示对应数据。 2015-12-23
    [self resetContentTableWithDate:currentDate];
    
    self.calendarView.delegate = self;
    self.contentTable.delegate = self;
    
    self.view.backgroundColor = LightgrayBackgroundColor;
    
    if ([MCDevice isPhone6Plus])
    {
        self.calendarHeightConstraint.constant = 380;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 进入时拿当前时间作为数据设置
//    [self.calendarView resetCalendarWithDate:[NSDate date]];
//    [self resetContentTableWithDate:[NSDate date]];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.calendarView resetCalendarFrame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDate *)getCurrentDate
{
    NSDate *date = [NSDate date];
    return date;
    
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate:date];
//    
//    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
//    return localeDate;
}

- (void)resetCalendar
{
    // 用户登录或者退出时，日历界面的跑步数据刷新。
    NSDate *currentDate = [self getCurrentDate];
    [self.calendarView resetCalendarWithDate:currentDate];
    [self resetContentTableWithDate:currentDate];
}

- (void)resetContentTableWithDate:(NSDate *)date
{
    // 根据日期date来显示对应日期的跑步数据
    
    // 数据库操作换成队列执行之后，这些操作可以放到子线程里执行。    2015.12.31
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
//        double startTime = CFAbsoluteTimeGetCurrent();
        
        MCDatabaseManager *databaseManager = [MCDatabaseManager new];
        NSArray *runDataArray = [databaseManager getRunDataArrayWithDate:date];  // MCRunDatabaseModel数组
        
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSInteger i = 0; i < [runDataArray count]; i ++)
        {
            MCRunDatabaseModel *runDataBaseModel = runDataArray[i];
            MCDataRecordModel *dataRecordModel = [MCModelReformer dataRecordModelFromRunDatabaseModel:runDataBaseModel];
            
            [dataArray addObject:dataRecordModel];
        }
        
//        double endTime = CFAbsoluteTimeGetCurrent();
//        double useTime = endTime - startTime;
//        NSLog(@"操作耗时：%f", useTime);
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self.contentTable resetTableWithRecordDataArray:dataArray];
        });
    });
    
//    MCDatabaseManager *databaseManager = [MCDatabaseManager new];
//    NSArray *runDataArray = [databaseManager getRunDataArrayWithDate:date];  // MCRunDatabaseModel数组
//    
//    NSMutableArray *dataArray = [NSMutableArray array];
//    for (NSInteger i = 0; i < [runDataArray count]; i ++)
//    {
//        MCRunDatabaseModel *runDataBaseModel = runDataArray[i];
//        MCDataRecordModel *dataRecordModel = [MCModelReformer dataRecordModelFromRunDatabaseModel:runDataBaseModel];
//        
//        [dataArray addObject:dataRecordModel];
//    }
//    [self.contentTable resetTableWithRecordDataArray:dataArray];
}

#pragma mark - MCContentTableDelegate

- (void)showHeartRateRecordWithDataModel:(MCDataRecordModel *)dataModel
{
    UIViewController *recordViewController = nil;
    if ([dataModel.heartRateArray count] > 0)
    {
        recordViewController = [[MCHeartRateRecordViewController alloc] initWithDataRecordModel:dataModel];
    }
    else
    {
        recordViewController = [[MCRunDataRecordViewController alloc] initWithDataRecordModel:dataModel];
    }
    
    recordViewController = [[MCSportRecordViewController alloc] initWithDataRecordModel:dataModel];
    
    [self presentViewController:recordViewController animated:YES completion:nil];
}

#pragma mark - MCCalendarRecordViewDelegate

- (void)calendarRecordDidSelectedDate:(NSDate *)date
{
    [self resetContentTableWithDate:date];
}

@end
