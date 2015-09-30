//
//  RepoDetailViewController.m
//  GithubOrg
//
//  Created by Wane Wang on 2015/9/30.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import "RepoDetailViewController.h"
#import "GithubAPIManager.h"
#import <JTCalendar.h>

@interface RepoDetailViewController () <JTCalendarDelegate>
@property (weak, nonatomic) IBOutlet UILabel *starLabel;
@property (weak, nonatomic) IBOutlet UILabel *forkLabel;

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (nonatomic, strong) JTCalendarManager *calendarManager;
@end

@implementation RepoDetailViewController {
    NSDateFormatter *_dateFormatter;
    NSDateFormatter *_dayFormatter;
    NSArray *_dayArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [_repoDictionary valueForKey:@"name"];
    _starLabel.text = [[_repoDictionary valueForKey:@"stargazers_count"] stringValue];
    _forkLabel.text = [[_repoDictionary valueForKey:@"forks_count"] stringValue];
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    _dayFormatter = [[NSDateFormatter alloc] init];
    [_dayFormatter setDateFormat:@"yyyy-MM-dd"];
    [self setupCalendar];
    [self loadEvents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Function

- (BOOL)checkDateStringExist:(NSString *)checkDate fromArray:(NSArray *)dayArray{
    BOOL hasString = NO;
    for (NSString *string in dayArray) {
        if ([checkDate isEqualToString:string]) {
            hasString = YES;
            break;
        }
    }
    return hasString;
}

#pragma mark - Network

- (void)loadEvents {
    [[GithubAPIManager sharedInstance] loadRepoEventList:[_repoDictionary valueForKey:@"events_url"] completion:^(NSError *error, NSArray *dataArray) {
        NSMutableArray *tempDayArray = [[NSMutableArray alloc] init];
        for (NSDictionary *eventDict in dataArray) {
            NSDate *createAt = [_dateFormatter dateFromString:[eventDict valueForKey:@"created_at"]];
            NSString *createTimeString = [_dayFormatter stringFromDate:createAt];
            if (![self checkDateStringExist:createTimeString fromArray:tempDayArray]) {
                [tempDayArray addObject:createTimeString];
            }
        }
        _dayArray = [[NSArray alloc] initWithArray:tempDayArray];
        [_calendarManager reload];
    }];
}

#pragma mark - Initial

- (void)setupCalendar {
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;

    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
}

#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView {
    if ([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]) {
        // Today
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor lightGrayColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    } else if (![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]) {
        // Other month
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    } else {
        // Another day of the current month
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    NSString *dayString = [_dayFormatter stringFromDate:dayView.date];
    if ([self checkDateStringExist:dayString fromArray:_dayArray]) {
        dayView.dotView.hidden = NO;
    } else {
        dayView.dotView.hidden = YES;
    }
    
}

/*
 * #pragma mark - Navigation
 *
 * // In a storyboard-based application, you will often want to do a little preparation before navigation
 * - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 *  // Get the new view controller using [segue destinationViewController].
 *  // Pass the selected object to the new view controller.
 * }
 */

@end
