//
//  JobDoneVC.m
//  Uber
//
//  Created by Elluminati - macbook on 30/06/14.
//  Copyright (c) 2014 Elluminati MacBook Pro 1. All rights reserved.
//

#import "JobDoneVC.h"
#import "HomeVC.h"
#import "DriverAssignment.h"
#import "UserDefaultHelper.h"

@interface JobDoneVC ()

@end

@implementation JobDoneVC

#pragma mark -
#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(JobDoneVC *)sharedObject
{
    static JobDoneVC *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[JobDoneVC alloc] initWithNibName:@"JobDoneVC" bundle:nil];
    });
    return obj;
}

#pragma mark -
#pragma mark - ViewLife Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    self.lblRefNo.text=[NSString stringWithFormat:@"%@",[DriverAssignment sharedObject].random_id];
    /*
    if (timer)
    {
        [timer invalidate];
        timer=nil;
    }
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime:) userInfo:nil repeats:YES];
     */
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (timer)
    {
        [timer invalidate];
        timer=nil;
    }
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark - Methods

/*
-(void)changeTime:(id)sender
{
    self.lblTime.text=[self getTimeDiffrent:[DriverAssignment sharedObject].dateETA];
}

-(NSString *)getTimeDiffrent:(NSDate *)date
{
    NSDate *dateA=[NSDate date];
    NSDate *dateB=date;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                               fromDate:dateA
                                                 toDate:dateB
                                                options:0];
    
    
    NSInteger hour=components.hour;
    NSInteger minute=components.minute;
    NSInteger second=components.second;
    
    if (hour<0)
    {
        hour=0;
    }
    if (minute<0)
    {
        minute=0;
    }
    if (second<0)
    {
        second=0;
    }
    return [NSString stringWithFormat:@"%li:%li:%li",(long)hour, (long)minute, (long)second];
}
*/
#pragma mark -
#pragma mark - Actions

-(void)onClickJobDone:(id)sender
{
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:[[UserDefaultHelper sharedObject] currentLatitude] forKey:PARAM_LATTITUDE];
    [dictParam setObject:[[UserDefaultHelper sharedObject] currentLongitude] forKey:PARAM_LOGITUDE];
    [dictParam setObject:[DriverAssignment sharedObject].random_id forKey:PARAM_RANDOM_ID];
    
//    [[AppDelegate sharedAppDelegate]showHUDLoadingView:@""];
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
    [afn getDataFromPath:FILE_JOB_DONE withParamData:dictParam withBlock:^(id response, NSError *error)
    {
//        [[AppDelegate sharedAppDelegate]hideHUDLoadingView];
        if (response)
        {
            NSDictionary *dictUber=[response objectForKey:WS_UBER_ALPHA];
            if ([[dictUber objectForKey:WS_STATUS]isEqualToString:WS_STATUS_SUCCESS])
            {
                [[DriverAssignment sharedObject]removeAllData];
                [DriverAssignment sharedObject].random_id = nil ;
                [[HomeVC sharedObject]removeAllAnnotations];
                [super gotoView:[HomeVC sharedObject]];
            }
            else{
                [[mainAppDelegate sharedAppDelegate]showToastMessage:[dictUber objectForKey:WS_MESSAGE]];
            }
        }
    }];
}

#pragma mark -
#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
