//
//  FirstVC.m
//  UberValetService
//
//  Created by Globussoft 1 on 10/27/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import "FirstVC.h"
#import "PlaceMark.h"
#import "Place.h"
#import "RoundedImageView.h"
#import "UserDefaultHelper.h"
#import "RegexKitLite.h"
#import "Constants.h"
#import "LocationHelper.h"
#import "DriverAssignment.h"
#import "AFNHelper.h"
#import "JobDoneVC.h"
#import "BaseVC.h"
#import "mainAppDelegate.h"
#import <MessageUI/MessageUI.h>
#import "UIImageView+WebCache.h"
#import "PromotionDetail.h"
#import "About.h"
#import "LogutVC.h"
#import "Settings.h"


@interface FirstVC ()
{
MKRoute *routeDetails;
 NSArray *  routes;
    BOOL check;
    UIButton *okay ;
     MFMessageComposeViewController *messageController;
    
    UIButton *washCarChekBox;
    UIButton *fueltopChekBox;
}
@end

@implementation FirstVC

@synthesize datePic,arrivedButton,requestDropOffButton,droppedButton,confirmPickupBtn,datePicker,EtaLabel,setEtaBtn,checkBoxEmpty,tickedCheckBox,checkBoxEmpty1,tickedCheckBox1;

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy) {
            // Copy NSObject subclasses
        [copy setMapUser:self.mapUser ];
        [copy setCrntPlaceLbl:self.crntPlaceLbl];
    }
    return copy;
}


@synthesize mapUser,roundImageView,driverName,accept,cancel,acceptView,name,add1,add2,distanceLabel,call,text,dropOff;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestNow) name:@"requestNotification" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestDropOffAction) name:@"ReachedClient" object:nil];
    
    
    NSNumber *screenWidth = @([UIScreen mainScreen].bounds.size.width);
    NSLog(@"screen Width is %@",screenWidth);
    NSLog(@"self view bounds height %f and width %f",self.view.frame.size.height,self.view.frame.size.width);
    
    self.mapUser=[[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50)];
    self.mapUser.delegate=self;
        //    self.mapUser.annotations
    [self.view addSubview:self.mapUser];

    self.crntPlaceLbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 30)];
    [self.crntPlaceLbl setBackgroundColor:[UIColor whiteColor]];
    self.crntPlaceLbl.text=[[UserDefaultHelper sharedObject]adrsLable];
    
    NSLog(@"Userdefault adrs %@",[[UserDefaultHelper sharedObject]adrsLable]);
    [self.mapUser addSubview:self.crntPlaceLbl];
    self.requestNowButton=[[UIButton alloc] init];
       [self.requestNowButton setFrame:CGRectMake(0, self.mapUser.frame.size.height-50, 320, 50)];
    self.requestNowButton.backgroundColor=[UIColor blackColor];
//    self.requestNowButton.titleLabel.textColor=[UIColor whiteColor];
    self.requestNowButton.titleLabel.frame=CGRectMake(190, self.view.frame.size.height-50, 320, 50);
    [self.requestNowButton setTitle:@"Request Now" forState:UIControlStateNormal];
    [self.requestNowButton addTarget:self action:@selector(requestNowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self requestNow];
//    [self.view addSubview:self.requestNowButton];
    
    mapTimer = [NSTimer scheduledTimerWithTimeInterval: 10.0 target: self
                                             selector: @selector(updateOnMapView) userInfo: nil repeats: YES];
    
//    [self updateOnMapView];
    
    // Do any additional setup after loading the view.
}

-(void)updateOnMapView{
    NSLog(@"mapview updated");
   
    NSString *str=    [[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"];
    if ([str isEqualToString:@"NO"]) {
        [mapTimer invalidate];
        return ;
    }
    
    Place* home = [[Place alloc] init];
    home.name = @"It's me";
    home.description = @"";
    home.latitude = [[[UserDefaultHelper sharedObject] currentLatitude] doubleValue];
    home.longitude = [[[UserDefaultHelper sharedObject] currentLongitude] doubleValue];
    NSLog(@"My location latitude is %f longitude is %f", home.latitude,home.longitude);
    //    home.latitude=22.578696;
    //    home.longitude=82.790555;
    home.isFrom=YES;
    
    Place* des = [[Place alloc] init];
    des.name = @"It's Driver";
    des.description = @"";
    //    des.latitude = 20.9087889;
    //    des.longitude = 81.889090;
    des.latitude = [[DriverAssignment sharedObject].lattitude doubleValue];
    des.longitude = [[DriverAssignment sharedObject].logitude doubleValue];
    des.isFrom=YES;
    NSLog(@"destination latitude is %f longitude is %f", des.latitude,des.longitude);
    //    [self showRouteFrom:home];
    
    [self showRouteFrom:home To:des];
    [self.mapUser setZoomEnabled:YES];
}


-(void)viewDidAppear:(BOOL)animated{
    
    self.acceptView.hidden = NO;
    self.cardDetail.hidden = NO;
    self.dropOff.hidden = YES ;
    
}

-(void)onClickOk:(id)sender
{
    
    //web service
    
//    [[AppDelegate sharedAppDelegate]showHUDLoadingView:@""];
    
    NSDate *datePickUp=self.datePicker.date;
    double time=[datePickUp timeIntervalSinceNow];
    
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:[NSString stringWithFormat:@"%.0f",time*1000] forKey:PARAM_TIME_OF_PICKUP];
    [dictParam setObject:[DriverAssignment sharedObject].random_id forKey:PARAM_RANDOM_ID];
    
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
    [afn getDataFromPath:FILE_SET_PICK_TIME withParamData:dictParam withBlock:^(id response, NSError *error)
     {
//         [[AppDelegate sharedAppDelegate]hideHUDLoadingView];
         if (response)
         {
             NSDictionary *dictUber=[response objectForKey:WS_UBER_ALPHA];
             if ([[dictUber objectForKey:WS_STATUS]isEqualToString:WS_STATUS_SUCCESS])
             {
                 [[DriverAssignment sharedObject]setETA:datePickUp];
                 BaseVC *bvc = [[BaseVC alloc]init];
                 [bvc gotoView:[JobDoneVC sharedObject]];
             }
             else{
                 [[mainAppDelegate sharedAppDelegate]showToastMessage:[dictUber objectForKey:WS_MESSAGE]];
             }
         }
     }];
}

-(void)onDatePickerValueChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *currentTime = [dateFormatter stringFromDate:self.datePicker.date];
    NSLog(@"%@", currentTime);
    
    if (! EtaLabel) {
         EtaLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-30, self.view.bounds.size.height-80, 80, 50)];
         [self.view addSubview:EtaLabel];
    }
//    EtaLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 290, 300, 50)];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *currentTime1 = [dateFormatter stringFromDate:self.datePicker.date];
    EtaLabel.text = currentTime1;
   
}

-(void)requestNow{
    self.cardDetail=[[UIView alloc]init];
    self.cardDetail.backgroundColor=[UIColor blackColor];
  
    NSURL *imgUrl=[DriverAssignment sharedObject].strUrl;
    NSLog(@"imgUrl is %@",imgUrl);
    

    self.roundImageView = [[RoundedImageView alloc] initWithFrame:CGRectMake(80,20, 59, 60)];
    
    [self.roundImageView setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    driverName = [[UILabel alloc]init];
    driverName.text = [DriverAssignment sharedObject].client_name;
    driverName.textColor = [UIColor redColor] ;
    UILabel *washMyCarLbl=[[UILabel alloc] initWithFrame:CGRectMake(20, 100, 200, 40)];
    washMyCarLbl.backgroundColor=[UIColor clearColor];
    washMyCarLbl.textColor=[UIColor whiteColor];
    washMyCarLbl.text=@"Car Wash";
    [self.cardDetail addSubview:washMyCarLbl];
    
    
    UILabel *fueltopUpLbl=[[UILabel alloc] initWithFrame:CGRectMake(20, 150, 200, 40)];
    fueltopUpLbl.backgroundColor=[UIColor clearColor];
    fueltopUpLbl.textColor=[UIColor whiteColor];
    fueltopUpLbl.text=@"Fuel Top Up ";
    [self.cardDetail addSubview:fueltopUpLbl];
    
    
    tickedCheckBox=[UIButton buttonWithType:UIButtonTypeCustom];
    tickedCheckBox.frame = CGRectMake(150, 100, 50, 40);
    //        tickedCheckBox.backgroundColor = [UIColor redColor];
    [tickedCheckBox setImage:[UIImage imageNamed:@"checkbox_mark.png"] forState:UIControlStateNormal];
    //    [self.cardDetail addSubview:tickedCheckBox];
    
    checkBoxEmpty=[UIButton buttonWithType:UIButtonTypeCustom];
    checkBoxEmpty.frame = CGRectMake(150, 100, 50, 40);
    //    checkBoxEmpty.backgroundColor = [UIColor redColor];
    [checkBoxEmpty setImage:[UIImage imageNamed:@"checkbox_empty.png"] forState:UIControlStateNormal];
    //   [self.cardDetail addSubview:checkBoxEmpty];
    
    tickedCheckBox1=[UIButton buttonWithType:UIButtonTypeCustom];
    tickedCheckBox1.frame = CGRectMake(150, 150, 50, 40);
    //       tickedCheckBox.backgroundColor = [UIColor redColor];
    [tickedCheckBox1 setImage:[UIImage imageNamed:@"checkbox_mark.png"] forState:UIControlStateNormal];
    //    [self.cardDetail addSubview:tickedCheckBox1];
    
    
    checkBoxEmpty1=[UIButton buttonWithType:UIButtonTypeCustom];
    checkBoxEmpty1.frame = CGRectMake(150, 150, 50, 40);
    //      checkBoxEmpty.backgroundColor = [UIColor redColor];
    [checkBoxEmpty1 setImage:[UIImage imageNamed:@"checkbox_empty.png"] forState:UIControlStateNormal];
    //    [self.cardDetail addSubview:checkBoxEmpty1];
    
    
    
    
    if([[DriverAssignment sharedObject].carWash isEqualToString:@"yes"])  {
        [self.cardDetail addSubview:tickedCheckBox];
        
    }else{
        [self.cardDetail addSubview:checkBoxEmpty];
    }
    
    if([[DriverAssignment sharedObject].fuelTopUp isEqualToString:@"yes"]) {
        [self.cardDetail addSubview:tickedCheckBox1];
    }else{
        [self.cardDetail addSubview:checkBoxEmpty1];
    }
    

    self.accept=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.accept addTarget:self action:@selector(acceptAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.accept.frame=CGRectMake(0,120,100,40);
    [self.accept setImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
//    [self.cardDetail addSubview:self.accept];
    
    self.cancel=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.cancel.frame=CGRectMake(100, 120, 100, 40);
    self.cancel.backgroundColor=[UIColor redColor];
    [self.cancel setImage:[UIImage imageNamed:@"decline.png"] forState:UIControlStateNormal];
//    [self.cardDetail addSubview:self.cancel];
    
    if ([UIScreen mainScreen].nativeScale == 2.0f){
        if (self.view.frame.size.height>568.0f) {
            NSLog(@"in iPhone6");
            self.cardDetail.frame = CGRectMake(80, 100, 200, 150);
            self.roundImageView.frame = CGRectMake(70,20, 59, 60);
            driverName.frame = CGRectMake(70, 90, 80, 20);
            self.accept.frame=CGRectMake(0,120,100,40);
            self.cancel.frame=CGRectMake(100, 120, 100, 40);
        
        }
        else if ( self.view.bounds.size.height==568.0f) {
            NSLog(@"in iPhone5");
            self.cardDetail.frame = CGRectMake(50, 100
                                               , 200, 150);
            self.roundImageView.frame = CGRectMake(70,20, 59, 60);
            driverName.frame = CGRectMake(70, 90, 80, 20);
            self.accept.frame=CGRectMake(0,120,100,40);
            self.cancel.frame=CGRectMake(100, 120, 100, 40);
            
        }
        else{
            NSLog(@"in iPhone4 ");
            self.cardDetail.frame = CGRectMake(50, 100
                                               , 200, 250);
            self.roundImageView.frame = CGRectMake(70,20, 59, 60);
            driverName.frame = CGRectMake(70, 90, 80, 20);
            self.accept.frame=CGRectMake(0,210,100,40);
            self.cancel.frame=CGRectMake(100,210, 100, 40);
        }
        
   }
    else if ([UIScreen mainScreen].scale > 2.1f)
    {
        NSLog(@"in iPhone 6 plus");
        self.cardDetail.frame = CGRectMake(50, 100
                                           , 200, 150);
        self.roundImageView.frame = CGRectMake(70,20, 59, 60);
        driverName.frame = CGRectMake(70, 90, 80, 20);
        self.accept.frame=CGRectMake(0,120,100,40);
        self.cancel.frame=CGRectMake(100, 120, 100, 40);
        
    }
//        else{
//        NSLog(@"in ipad");
//
//        self.cardDetail.frame = CGRectMake(50, 100
//                                           , 200, 150);
//        self.roundImageView.frame = CGRectMake(70,20, 59, 60);
//        driverName.frame = CGRectMake(70, 90, 80, 20);
//        self.accept.frame=CGRectMake(0,120,100,40);
//        self.cancel.frame=CGRectMake(100, 120, 100, 40);
//    }
//}
    [self.view addSubview:self.cardDetail];
    [self.cardDetail addSubview:self.roundImageView];
    [self.cardDetail addSubview:driverName];
    [self.cardDetail addSubview:self.accept];
    [self.cardDetail addSubview:self.cancel];

}

#pragma mark ------ arrived web service . 

-(void)onClickReachedAtClient{
    
    NSDate *dateReached=[NSDate date];
    double time=[dateReached timeIntervalSinceDate:[DriverAssignment sharedObject].dateETA];
    
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:[NSString stringWithFormat:@"%.0f",time*1000] forKey:PARAM_TIME];
    [dictParam setObject:[DriverAssignment sharedObject].random_id forKey:PARAM_RANDOM_ID];
    //[dictParam setObject:@"1234" forKey:PARAM_RANDOM_ID];
    
    [[mainAppDelegate sharedAppDelegate]showHUDLoadingView:@""];
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
    [afn getDataFromPath:FILE_DRIVER_REACHED_CLIENT withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         [[mainAppDelegate sharedAppDelegate]hideHUDLoadingView];
         if (response)
         {
             NSDictionary *dictUber=[response objectForKey:WS_UBER_ALPHA];
             if ([[dictUber objectForKey:WS_STATUS]isEqualToString:WS_STATUS_SUCCESS])
             {
                 [[DriverAssignment sharedObject]setDateReachedAtClient:dateReached];
                     self.confirmPickUpBtn.hidden=YES;
             }
             else{
                 [[mainAppDelegate sharedAppDelegate]showToastMessage:[dictUber objectForKey:WS_MESSAGE]];
             }
         }
     }];
}

-(void)requestNowButtonClick:(UIButton *)button{
    
    self.cardDetail=[[UIView alloc]initWithFrame:CGRectMake(50, 100
                                                            , 200, 150)];
    self.cardDetail.backgroundColor=[UIColor blackColor];
//    self.cardDetail.hidden=YES;
    [self.view addSubview:self.cardDetail];
    
    self.addExtraServiceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.addExtraServiceBtn addTarget:self action:@selector(confrmPickUpBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.addExtraServiceBtn.frame=CGRectMake(self.view.bounds.size.width-310,50, 200, 40);
    self.addExtraServiceBtn.backgroundColor=[UIColor clearColor];
   [self.addExtraServiceBtn setTitle:@"Add Extra Services" forState:UIControlStateNormal];
//    [self.cardDetail addSubview:self.addExtraServiceBtn];

    
    self.confirmPickUpBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmPickUpBtn addTarget:self action:@selector(confrmPickUpBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmPickUpBtn.frame=CGRectMake(self.view.bounds.size.width-280, 100, self.view.bounds.size.width-80, 40);
    self.confirmPickUpBtn.backgroundColor=[UIColor redColor];
    [self.confirmPickUpBtn setTitle:@"Confirm Pickup" forState:UIControlStateNormal];
//    [self.cardDetail addSubview:self.confirmPickUpBtn];
    
     self.roundImageView = [[RoundedImageView alloc] initWithFrame:CGRectMake(80,20, 59, 60)];
    NSURL *imgUrl=[DriverAssignment sharedObject].strUrl;
    [self.roundImageView setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"profile.png"]];
//    self.roundImageView.image = [UIImage imageNamed:@"concierg.png"];
    [self.cardDetail addSubview:self.roundImageView];
    
    driverName = [[UILabel alloc]initWithFrame:CGRectMake(70, 90, 80, 20) ];
    driverName.text = @"John Doe";
    driverName.textColor = [UIColor redColor] ;
    [self.cardDetail addSubview:driverName];
    
    self.accept=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.accept addTarget:self action:@selector(acceptAction:) forControlEvents:UIControlEventTouchUpInside];
    self.accept.frame=CGRectMake(0,120,100,40);
    self.accept.backgroundColor=[UIColor greenColor];
//    [self.accept setImage:@"" forState:UIControlStateNormal];
   [self.cardDetail addSubview:self.accept];
    
    self.cancel=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    self.cancel.frame=CGRectMake(100, 120, 100, 40);
    self.cancel.backgroundColor=[UIColor redColor];
//    [self.accept setImage:@"" forState:UIControlStateNormal];
    [self.cardDetail addSubview:self.cancel];
}

-(void)acceptAction:(UIButton *)button{
    
     self.cardDetail.hidden = YES;
//    self.mapUser.hidden = YES;
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    [self.datePicker setDatePickerMode: UIDatePickerModeTime];
    [self.datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
   self.datePicker.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:self.datePicker];
    
    self.setEtaBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.setEtaBtn addTarget:self action:@selector(setETAAction:) forControlEvents:UIControlEventTouchUpInside];
    self.setEtaBtn.frame=CGRectMake(0, self.view.bounds.size.height-40, self.view.bounds.size.width, 40);
    self.setEtaBtn.backgroundColor=[UIColor colorWithRed:192/255.0f green:57/255.0f blue:61/255.0f alpha:1];

    [self.setEtaBtn setTitle:@"SET ETA"forState:UIControlStateNormal];
    [self.view addSubview:self.setEtaBtn];
   
}

-(void)setETAAction:(id)sender{
    
    
    NSString *address= [DriverAssignment sharedObject].address;
    NSArray *items = [address componentsSeparatedByString:@","];
   
    NSString *addr1 = items[0];
    NSString *addr2 = items[1];
    
    NSLog(@"in setEta action action");
    
    self.setEtaBtn.hidden = YES;
    self.datePicker.hidden = YES ;
    self.EtaLabel.hidden = YES;
    self.cardDetail.hidden = YES;
    self.cardDetail = nil;
     NSURL *imgUrl=[DriverAssignment sharedObject].strUrl;
    self.acceptView = [[UIView alloc]init];
    //self.acceptView.frame = CGRectMake(0, 0, self.view.frame.size.width, 150);
    self.acceptView.backgroundColor=[UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1];
    //    [self.view addSubview:self.acceptView];
    
    self.roundImageView = [[RoundedImageView alloc] initWithFrame:CGRectMake(20,30, 59, 60)];
    //  self.roundImageView.frame = CGRectMake(20,30, 59, 60);
     [self.roundImageView setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"profile.png"]];
//    self.roundImageView.image = [UIImage imageNamed:@"concierg.png"];
    //    [self.acceptView addSubview:self.roundImageView];
    
    name = [[UILabel alloc]init];
    // name.frame = CGRectMake(110, 20, 150, 20);
    name.text = [DriverAssignment sharedObject].client_name;
    name.textColor = [UIColor whiteColor] ;
    //    [self.acceptView addSubview:name];
    
    add1 = [[UILabel alloc]initWithFrame:CGRectMake(110, 50, 200, 20) ];
    // add1.frame = CGRectMake(110, 50, 200, 20);
    add1.text = addr1;
    add1.textColor = [UIColor whiteColor] ;
    //    [self.acceptView addSubview:add1];
    
    add2 = [[UILabel alloc]init];
    // add2.frame = CGRectMake(110, 80, 200, 20);
    add2.text = addr2;
    add2.textColor = [UIColor whiteColor] ;
    //    [self.acceptView addSubview:add2];
    

    CLLocation *locA = [[CLLocation alloc] initWithLatitude:[[[UserDefaultHelper sharedObject] currentLatitude] doubleValue] longitude:[[[UserDefaultHelper sharedObject] currentLongitude] doubleValue]];
    
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:[[DriverAssignment sharedObject].lattitude doubleValue] longitude:[[DriverAssignment sharedObject].logitude doubleValue]];
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
                        
    

    NSLog(@"distance is %f ",distance );
    distance = distance/1000;//convert meters to kilometers.
    //   distance = distance/1609;//convert meters to miles .
    

    self.distanceLabel =[[UILabel alloc]init];
    // self.distanceLabel.frame = CGRectMake(0, 120, self.view.frame.size.width, 30);
    self.distanceLabel.text = [NSString stringWithFormat:@"Distance is %f km",distance];
    self.distanceLabel.backgroundColor = [UIColor blackColor];
    self.distanceLabel.textColor = [UIColor whiteColor] ;
    //    [self.acceptView addSubview:self.distanceLabel];
    
    self.call=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.call addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
    //   self.call.frame=CGRectMake(110, 100, 70, 20);
    self.call.backgroundColor=[UIColor colorWithRed:192/255.0f green:57/255.0f blue:61/255.0f alpha:1];
    [self.call setTitle:@"call" forState:UIControlStateNormal];
    //    [self.acceptView addSubview:self.call];
    
    self.text=[UIButton buttonWithType:UIButtonTypeCustom];
    [ self.text addTarget:self action:@selector(textAction:) forControlEvents:UIControlEventTouchUpInside];
    // self.text.frame=CGRectMake(190, 100, 70, 20);
    self.text.backgroundColor=[UIColor colorWithRed:192/255.0f green:57/255.0f blue:61/255.0f alpha:1];
    [ self.text setTitle:@"text" forState:UIControlStateNormal];
    //    [self.acceptView addSubview: self.text];
    
    
    self.arrivedButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.arrivedButton addTarget:self action:@selector(arrivedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // self.arrivedButton.frame=CGRectMake(0, self.view.bounds.size.height-40,self.view.bounds.size.width , 40);
    self.arrivedButton.backgroundColor=[UIColor blackColor];
    [self.arrivedButton setTitle:@"Arrived" forState:UIControlStateNormal];
    //    [self.view addSubview:self.arrivedButton];
    

    
    self.acceptView.frame = CGRectMake(0, 0, self.view.frame.size.width, 150);
    self.roundImageView.frame = CGRectMake(20,30, 59, 60);
    name.frame = CGRectMake(110, 20, 150, 20);
    add1.frame = CGRectMake(110, 50, 200, 20);
    add2.frame = CGRectMake(110, 80, 200, 20);
    self.distanceLabel.frame = CGRectMake(0, 120, self.view.frame.size.width, 30);
    self.call.frame=CGRectMake(110, 100, 70, 20);
    self.text.frame=CGRectMake(190, 100, 70, 20);
    self.arrivedButton.frame=CGRectMake(0, self.view.bounds.size.height-40,self.view.bounds.size.width , 40);
    //
    
    if ([UIScreen mainScreen].nativeScale == 2.0f){
        if (self.view.frame.size.height>568.0f) {
            NSLog(@"in iPhone6");
            self.acceptView.frame = CGRectMake(0, 0, self.view.frame.size.width, 150);
            self.roundImageView.frame = CGRectMake(20,30, 59, 60);
            name.frame = CGRectMake(110, 20, 150, 20);
            add1.frame = CGRectMake(110, 50, 200, 20);
            add2.frame = CGRectMake(110, 80, 200, 20);
            self.distanceLabel.frame = CGRectMake(0, 120, self.view.frame.size.width, 30);
            self.call.frame=CGRectMake(110, 100, 70, 20);
            self.text.frame=CGRectMake(190, 100, 70, 20);
            self.arrivedButton.frame=CGRectMake(0, self.view.bounds.size.height-40,self.view.bounds.size.width , 40);
        }
        else if ( self.view.bounds.size.height==568.0f) {
            NSLog(@"in iPhone5");
            self.acceptView.frame = CGRectMake(0, 0, self.view.frame.size.width, 150);
            self.roundImageView.frame = CGRectMake(20,30, 59, 60);
            name.frame = CGRectMake(110, 20, 150, 20);
            add1.frame = CGRectMake(110, 50, 200, 20);
            add2.frame = CGRectMake(110, 80, 200, 20);
            self.distanceLabel.frame = CGRectMake(0, 120, self.view.frame.size.width, 30);
            self.call.frame=CGRectMake(110, 100, 70, 20);
            self.text.frame=CGRectMake(190, 100, 70, 20);
            self.arrivedButton.frame=CGRectMake(0, self.view.bounds.size.height-40,self.view.bounds.size.width , 40);
        }
        else{
            NSLog(@"in iPhone4 ");
            self.acceptView.frame = CGRectMake(0, 0, self.view.frame.size.width, 150);
            self.roundImageView.frame = CGRectMake(20,30, 59, 60);
            name.frame = CGRectMake(110, 20, 150, 20);
            add1.frame = CGRectMake(110, 50, 200, 20);
            add2.frame = CGRectMake(110, 80, 200, 20);
            self.distanceLabel.frame = CGRectMake(0, 120, self.view.frame.size.width, 30);
            self.call.frame=CGRectMake(110, 100, 70, 20);
            self.text.frame=CGRectMake(190, 100, 70, 20);
            self.arrivedButton.frame=CGRectMake(0, self.view.bounds.size.height-40,self.view.bounds.size.width , 40);
        }
        
    }
    else if ([UIScreen mainScreen].scale > 2.1f)
    {
        NSLog(@"in iPhone 6 plus");
        self.acceptView.frame = CGRectMake(0, 0, self.view.frame.size.width, 150);
        self.roundImageView.frame = CGRectMake(20,30, 59, 60);
        name.frame = CGRectMake(110, 20, 150, 20);
        add1.frame = CGRectMake(110, 50, 200, 20);
        add2.frame = CGRectMake(110, 80, 200, 20);
        self.distanceLabel.frame = CGRectMake(0, 120, self.view.frame.size.width, 30);
        self.call.frame=CGRectMake(110, 100, 70, 20);
        self.text.frame=CGRectMake(190, 100, 70, 20);
        self.arrivedButton.frame=CGRectMake(0, self.view.bounds.size.height-40,self.view.bounds.size.width , 40);
    }
    
    [self.view addSubview:self.acceptView];
    [self.acceptView addSubview:self.roundImageView];
    [self.acceptView addSubview:name];
    [self.acceptView addSubview:add1];
    [self.acceptView addSubview:add2];
    [self.acceptView addSubview:self.distanceLabel];
    [self.acceptView addSubview:self.call];
    [self.acceptView addSubview: self.text];
    [self.view addSubview:self.arrivedButton];
    
    
    
    
    
    //added webservice
    
    NSDate *datePickUp=self.datePicker.date;
    double time=[datePickUp timeIntervalSinceNow];
    NSLog(@"time is %f",time);
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:[NSString stringWithFormat:@"%.0f",time*1000] forKey:PARAM_TIME_OF_PICKUP];
   [dictParam setObject:[DriverAssignment sharedObject].random_id forKey:PARAM_RANDOM_ID];

    
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
    [afn getDataFromPath:FILE_SET_PICK_TIME withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         //         [[AppDelegate sharedAppDelegate]hideHUDLoadingView];
         if (response)
         {
             NSDictionary *dictUber=[response objectForKey:WS_UBER_ALPHA];
             if ([[dictUber objectForKey:WS_STATUS]isEqualToString:WS_STATUS_SUCCESS])
             {
                 [[DriverAssignment sharedObject]setETA:datePickUp];
                 BaseVC *bvc = [[BaseVC alloc]init];
//                 [bvc gotoView:[JobDoneVC sharedObject]];
             }
             else{
//                 [[mainAppDelegate sharedAppDelegate]showToastMessage:[dictUber objectForKey:WS_MESSAGE]];
             }
         }
     }];

    
}
-(void)arrivedButtonAction:(id)sender{
    
   
    
    self.confirmPickUpBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmPickUpBtn addTarget:self action:@selector(confirmPickPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.confirmPickUpBtn.frame=CGRectMake(0, self.view.bounds.size.height-40,self.view.bounds.size.width , 40);
    self.confirmPickUpBtn.backgroundColor=[UIColor blackColor];
    [self.confirmPickUpBtn setTitle:@"Confirm Pickup " forState:UIControlStateNormal];
    [self.view addSubview:self.confirmPickUpBtn];
    
}
-(void)confirmPickPressed:(id)sender{
    
     [self onClickReachedAtClient];
    
    self.acceptView.hidden = YES;
    self.arrivedButton.hidden = YES;
}


-(void)requestDropOffAction{
    
    NSLog(@"in request drop off action");
    
    self.dropOff = [[UIView alloc]initWithFrame:CGRectMake(20, 80, self.view.frame.size.width-50, 170)];
    self.dropOff.backgroundColor=[UIColor blackColor];
    [self.view addSubview:self.dropOff];
    
    UILabel *dropOffLabel =[[UILabel alloc]initWithFrame:CGRectMake(100, 0, 80, 30) ];
    dropOffLabel.text = @"Drop off";
    dropOffLabel.textColor = [UIColor colorWithRed:192/255.0f green:57/255.0f blue:61/255.0f alpha:1] ;
    [self.dropOff addSubview:dropOffLabel];
    
    self.roundImageView = [[RoundedImageView alloc] initWithFrame:CGRectMake(100,30, 59, 60)];
//    self.roundImageView.image = [UIImage imageNamed:@"concierg.png"];
    NSURL *imgUrl=[DriverAssignment sharedObject].strUrl;
    [self.roundImageView setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"profile.png"]];
    [self.dropOff addSubview:self.roundImageView];
    
    okay =[UIButton buttonWithType:UIButtonTypeCustom];
    [okay addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];
    
    okay.frame=CGRectMake(20,250, self.view.frame.size.width-50,30);
    okay.backgroundColor= [UIColor colorWithRed:192/255.0f green:57/255.0f blue:61/255.0f alpha:1];
    [okay setTitle:@"OK" forState:UIControlStateNormal];
    //    [self.dropOff bringSubviewToFront:okay];
    [self.view addSubview:okay];
    
    name = [[UILabel alloc]initWithFrame:CGRectMake(110, 100, 150, 20) ];
//    name.text = @"Khomesh";
    name.text = [DriverAssignment sharedObject].client_name;
    name.textColor = [UIColor whiteColor] ;
    [self.dropOff addSubview:name];
    
    
    
    NSString *address= [DriverAssignment sharedObject].address;
    NSArray *items = [address componentsSeparatedByString:@","];
    
    
    NSString *addr1 = items[0];
    NSString *addr2 = items[1];
    
    add1 = [[UILabel alloc]initWithFrame:CGRectMake(40, 118, 200, 20) ];
    [add1 setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    add1.text = addr1;
    add1.textColor = [UIColor whiteColor] ;
    [self.dropOff addSubview:add1];
    
    add2 = [[UILabel alloc]initWithFrame:CGRectMake(90, 140, 200, 20) ];
    [add2 setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    add2.text = addr2;
    add2.textColor = [UIColor whiteColor] ;
    [self.dropOff addSubview:add2];

}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay{

    MKPolylineView *overlayView = [[MKPolylineView alloc] initWithOverlay:overlay];
    overlayView.lineWidth =5;
    overlayView.strokeColor = [UIColor redColor];
    overlayView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.1f];
    return overlayView;


}

-(void)cancelAction:(UIButton *)button{
    
   self.acceptView.hidden = YES ;
    self.cardDetail.hidden = YES ;
    /*
    self.dropOff = [[UIView alloc]initWithFrame:CGRectMake(20, 80, self.view.frame.size.width-50, 150)];
    self.dropOff.backgroundColor=[UIColor blackColor];
    [self.view addSubview:self.dropOff];

   UILabel *dropOffLabel =[[UILabel alloc]initWithFrame:CGRectMake(100, 0, 80, 30) ];
    dropOffLabel.text = @"Drop off";
   dropOffLabel.textColor = [UIColor whiteColor] ;
    [self.dropOff addSubview:dropOffLabel];
    
    self.roundImageView = [[RoundedImageView alloc] initWithFrame:CGRectMake(100,30, 59, 60)];
    self.roundImageView.image = [UIImage imageNamed:@"concierg.png"];
    [self.dropOff addSubview:self.roundImageView];
    
   okay =[UIButton buttonWithType:UIButtonTypeCustom];
   [okay addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];

    okay.frame=CGRectMake(20,230, self.view.frame.size.width-50,30);
    okay.backgroundColor=[UIColor redColor];
    [okay setTitle:@"OK" forState:UIControlStateNormal];
//    [self.dropOff bringSubviewToFront:okay];
    [self.view addSubview:okay];
    
    name = [[UILabel alloc]initWithFrame:CGRectMake(90, 100, 150, 20) ];
    name.text = @"Khomesh";
    name.textColor = [UIColor whiteColor] ;
    [self.dropOff addSubview:name];
    
    add1 = [[UILabel alloc]initWithFrame:CGRectMake(80, 118, 200, 20) ];
    [add1 setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    add1.text = @"Shastri chowk";
    add1.textColor = [UIColor whiteColor] ;
    [self.dropOff addSubview:add1];
    
    add2 = [[UILabel alloc]initWithFrame:CGRectMake(80, 130, 200, 20) ];
      [add2 setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    add2.text = @"camp-1 bhilai";
    add2.textColor = [UIColor whiteColor] ;
    [self.dropOff addSubview:add2];

*/
    
}

-(void)okAction:(id)sender{
    NSLog(@"in ok action");
    
    self.dropOff.hidden = YES;
    okay.hidden = YES ;
    self.droppedButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.droppedButton addTarget:self action:@selector(droppedBtnActn:) forControlEvents:UIControlEventTouchUpInside];
    self.droppedButton.frame=CGRectMake(0, self.view.bounds.size.height-40,self.view.bounds.size.width , 40);
    self.droppedButton.backgroundColor=[UIColor blackColor];
    [self.droppedButton setTitle:@"Dropped" forState:UIControlStateNormal];
    [self.view addSubview:self.droppedButton];
    
}

-(void)droppedBtnActn:(id)sender{
    
    NSLog(@"hereeeeee");
    
    //web service.
    
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:[[UserDefaultHelper sharedObject] currentLatitude] forKey:PARAM_LATTITUDE];
    [dictParam setObject:[[UserDefaultHelper sharedObject] currentLongitude] forKey:PARAM_LOGITUDE];
    [dictParam setObject:[DriverAssignment sharedObject].random_id forKey:PARAM_RANDOM_ID];
    
    [[mainAppDelegate sharedAppDelegate]showHUDLoadingView:@""];
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
    [afn getDataFromPath:FILE_JOB_DONE withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         [[mainAppDelegate sharedAppDelegate]hideHUDLoadingView];
         if (response)
         {
             NSLog(@"response in job done is %@",response);
             NSDictionary *dictUber=[response objectForKey:WS_UBER_ALPHA];
             if ([[dictUber objectForKey:WS_STATUS]isEqualToString:WS_STATUS_SUCCESS])
             {
                 [[DriverAssignment sharedObject]removeAllData];
                 [DriverAssignment sharedObject].random_id = nil ;
                 [[HomeVC sharedObject]removeAllAnnotations];

                 NSLog(@"random id in dropped action/firstvc is %@", [DriverAssignment sharedObject].random_id);
                 
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"check1"];
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"check2"];

                 [[NSUserDefaults standardUserDefaults]synchronize];
                 
                 NSString * str = [[NSUserDefaults standardUserDefaults]objectForKey:@"check1"];
                 NSLog(@"str = %@",str);
                 
//                 AppDelegateFirstVC *loginVC=[[AppDelegateFirstVC alloc] init];
//                 loginVC.title=@"Login";
                 
                 FirstVC *firstVC=[[FirstVC alloc] init];
                 firstVC.title=@"Home";
                            
                 
                 PromotionDetail *promotion = [[PromotionDetail alloc]init];
                 promotion.title = @"Promotion";
                 
                 About *about= [[About alloc]init] ;
                 about.title=@"About";
                 
                 LogutVC *logout = [[LogutVC alloc]init];
                 logout.title = @"Log out";
                 
                 Settings *set = [[Settings alloc]init];
                 set.title = @"Status";
                 
                 HomeVC *homeVC=[[HomeVC alloc] init];
                 homeVC.viewControllers = @[firstVC,set,promotion,about,logout];
                 
                 [self presentViewController:homeVC animated:YES completion:nil];
                 
                 
             }
             else{
                 [[mainAppDelegate sharedAppDelegate]showToastMessage:[dictUber objectForKey:WS_MESSAGE]];
             }
         }
     }];

}
-(void)callAction:(UIButton *)button{
    NSLog(@"in call action");
    NSString *phoneNumber = [@"tel://" stringByAppendingString:[DriverAssignment sharedObject].Client_contact];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

-(void)textAction:(UIButton *)button{
   
    NSLog(@"in text action");
    NSString *selectedFile = @"Hello client";
    [self showSMS:selectedFile];
}


- (void)showSMS:(NSString*)file {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[[DriverAssignment sharedObject].Client_contact];
    NSString *message = [NSString stringWithFormat:@"Just sent the %@ file to your email. Please check!", file];
    
    messageController = [[MFMessageComposeViewController alloc] init];
    
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self addChildViewController:messageController];
    [self.view addSubview:messageController.view];
    //    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [controller.view removeFromSuperview];// removeFromParentViewController];
    //  [self dismissViewControllerAnimated:YES completion:nil];
}




-(void)confrmPickUpBtnClick:(UIButton *)button{
    
    
    self.cardDetail.hidden=YES;
    self.ShowDrivrView=[[UIView alloc] initWithFrame:CGRectMake(20,50, 280, self.view.frame.size.height-100)];
    self.ShowDrivrView.backgroundColor=[UIColor blackColor];
    [self.mapUser addSubview:self.ShowDrivrView];
    
    self.DrivrImgview=[[RoundedImageView alloc] initWithFrame:CGRectMake(105, 5, 70, 70)];
        self.DrivrImgview.image=[UIImage imageNamed:@"reglog.png"];
    [self.ShowDrivrView addSubview:self.DrivrImgview];
    
    UILabel *driverNmeLbl=[[UILabel alloc]initWithFrame:CGRectMake(105, 78, 150, 30)];
    driverNmeLbl.text=@"khomesh";
    driverNmeLbl.backgroundColor=[UIColor clearColor];
    driverNmeLbl.textColor=[UIColor whiteColor];
    [self.ShowDrivrView addSubview:driverNmeLbl];
    
    
//    int ratingCount;
//    for (int i=0; i<ratingCount; i++) {
//        UIImageView *starimg=[[UIImageView alloc] initWithFrame:CGRectMake(50+20*i, 150, 20, 20)];
//        starimg.image=[UIImage imageNamed:@"starimage.png"];
//        [self.ShowDrivrView addSubview:starimg];
//    }
    
    UILabel *declarLabel=[[UILabel alloc] initWithFrame:CGRectMake(40, 150, 200, 60)];
        declarLabel.backgroundColor=[UIColor clearColor];
    declarLabel.text=@"Your conceirege should \n    meet you in min";
    declarLabel.lineBreakMode=NSLineBreakByCharWrapping;
    declarLabel.numberOfLines=0;
    declarLabel.textColor=[UIColor whiteColor];
    [self.ShowDrivrView addSubview:declarLabel];
    
   [declarLabel sizeToFit];
    
    UILabel *timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(110, 190, 200, 40)];
    timeLabel.backgroundColor=[UIColor clearColor];
     timeLabel.textColor=[UIColor whiteColor];
    timeLabel.text=@"05:20 min ";
    [self.ShowDrivrView addSubview:timeLabel];
  
    UIButton *rightClkOkBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightClkOkBtn.frame=CGRectMake(30, 270, self.view.frame.size.width-100, 40);
    rightClkOkBtn.backgroundColor=[UIColor redColor];
    [rightClkOkBtn setTitle:@"Ok" forState:UIControlStateNormal];
//    [rightClkOkBtn setImage:[UIImage imageNamed:@"rightClick.png"] forState:UIControlStateNormal];
  [rightClkOkBtn addTarget:self action:@selector(rightClkOkBtnEvent:) forControlEvents:UIControlEventTouchUpInside ];
    [self.ShowDrivrView addSubview:rightClkOkBtn];
}

-(void)rightClkOkBtnEvent:(UIButton *)button{
    self.ShowDrivrView.hidden=YES;
    self.showDrivrRichTimeLbl=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50,self.view.frame.size.width,50)];
    self.showDrivrRichTimeLbl.backgroundColor=[UIColor blackColor];
        [self.view addSubview:self.showDrivrRichTimeLbl];
    
    
    UIImageView *drvrImgview=[[RoundedImageView alloc] initWithFrame:CGRectMake(25, -15, 60, 60)];
   drvrImgview.image=[UIImage imageNamed:@"reglog.png"];
    [self.showDrivrRichTimeLbl addSubview:drvrImgview];
//    self.DrivrImgview.frame=;
    
    
    UILabel *timrlbl=[[UILabel alloc] initWithFrame:CGRectMake(95,5 , 155, 50)];
    timrlbl.text=@"2min";
    timrlbl.backgroundColor=[UIColor clearColor];
    timrlbl.textColor=[UIColor whiteColor];
    [self.showDrivrRichTimeLbl addSubview:timrlbl];
    
    
    UIButton *cancelDriver=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelDriver addTarget:self action:@selector(cancelDriver:) forControlEvents:UIControlEventTouchUpInside];
    cancelDriver.backgroundColor=[UIColor redColor];
    [cancelDriver setTitle:@"Cancel" forState:UIControlStateNormal];
//    [cancelDriver setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    cancelDriver.frame=CGRectMake(270, 0 ,120 , 150);
    [self.showDrivrRichTimeLbl addSubview:cancelDriver];


}



-(void)cancelDriver:(UIButton *)button{
    UIButton *dropOffReqBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [dropOffReqBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    dropOffReqBtn.frame=CGRectMake(0, self.view.frame.size.height-100, self.view.frame.size.width, 100);
    [dropOffReqBtn addTarget:self action:@selector(dropOffReqBtnClk:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dropOffReqBtn];

}

-(void)dropOffReqBtnClk:(UIButton *)button{

    self.feedBackVC=[[UIView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100)];
    [self.view addSubview:self.feedBackVC];
    self.DrivrImgview.frame=CGRectMake(135, self.view.frame.size.height-150, 50, 50);
    
    
    int ratingCount;
    for (int i=0; i<ratingCount; i++) {
        UIButton *ratingImg=[[UIButton alloc] initWithFrame:CGRectMake(50+20*i, self.view.frame.size.height-150, 20, 20)];
        [ratingImg setImage:[UIImage imageNamed:@"starimage.png"] forState:UIControlStateNormal];
        [ratingImg addTarget:self action:@selector(ratingButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.ShowDrivrView addSubview:ratingImg];
    }

}


-(void)ratingButton:(UIButton *)button{


}

-(void) showRouteFrom: (Place *) pickUpFrom To:(Place *)pickUpTo
{
    [self.mapUser removeAnnotations:[self.mapUser annotations]];
    
    
	PlaceMark* markPickUp = [[PlaceMark alloc] initWithPlace:pickUpFrom];
	[self.mapUser addAnnotation:markPickUp];
    PlaceMark* PickUp = [[PlaceMark alloc] initWithPlace:pickUpTo];
	[self.mapUser addAnnotation:PickUp];
//    PlaceMark* from = [[PlaceMark alloc] initWithPlace:pickUpFrom];
//	PlaceMark* to = [[PlaceMark alloc] initWithPlace:pickUpTo];
//    
    routes = [self calculateRoutesFrom:markPickUp.coordinate to:PickUp.coordinate];
    int ro=(int)routes.count;
	[self updateRouteView];
//    NSMutableArray *polyLinesArray =[[NSMutableArray alloc]initWithCapacity:0];
    CLLocationCoordinate2D coordinates[ro];
    for (int i = 0; i < routes.count; i++)
    {
        CLLocation *location=routes[i];
//        NSString* encodedPoints = [routes objectAtIndex:i] ;
//        MKPolyline *route = [self polylineWithEncodedString:encodedPoints];
//
           coordinates[i] = [location coordinate];
    
    
    }
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coordinates count:ro];
    [self.mapUser addOverlay:polyline];
    
//    [self.mapUser addOverlays:polyLinesArray];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    
}


-(void) updateRouteView
{
/*	CGContextRef context = 	CGBitmapContextCreate(nil,
												  routeView.frame.size.width,
												  routeView.frame.size.height,
												  8,
												  4 * routeView.frame.size.width,
												  CGColorSpaceCreateDeviceRGB(),
												  (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
	
	CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
	CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
	CGContextSetLineWidth(context, 3.0);
	
	for(int i = 0; i < routes.count; i++) {
		CLLocation* location = [routes objectAtIndex:i];
		CGPoint point = [self.mapUser convertCoordinate:location.coordinate toPointToView:routeView];
		
		if(i == 0) {
			CGContextMoveToPoint(context, point.x, routeView.frame.size.height - point.y);
		} else {
			CGContextAddLineToPoint(context, point.x, routeView.frame.size.height - point.y);
		}
	}
	
	CGContextStrokePath(context);
	
	CGImageRef image = CGBitmapContextCreateImage(context);
	UIImage* img = [UIImage imageWithCGImage:image];
	
	routeView.image = img;
	CGContextRelease(context);*/
    
}

-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded {
	[encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
								options:NSLiteralSearch
								  range:NSMakeRange(0, [encoded length])];
	NSInteger len = [encoded length];
	NSInteger index = 0;
	NSMutableArray *array = [[NSMutableArray alloc] init];
	NSInteger lat=0;
	NSInteger lng=0;
	while (index < len) {
		NSInteger b;
		NSInteger shift = 0;
		NSInteger result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lat += dlat;
		shift = 0;
		result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lng += dlng;
		NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
		NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
		printf("[%f,", [latitude doubleValue]);
		printf("%f]", [longitude doubleValue]);
		CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
		[array addObject:loc];
	}
	
	return array;
}

-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t {
	NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
	NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
	
	NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
	NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
	NSLog(@"api url: %@", apiUrl);
	NSError *error;
    NSString *apiResponse = [NSString stringWithContentsOfURL:apiUrl encoding:NSASCIIStringEncoding error:&error];
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"points:\\\"([^\\\"]*)\\\"" options:0 error:NULL];
    NSTextCheckingResult *match = [regex firstMatchInString:apiResponse options:0 range:NSMakeRange(0, [apiResponse length])];
    NSString *encodedPoints = [apiResponse substringWithRange:[match rangeAtIndex:1]];
	return [self decodePolyLine:[encodedPoints mutableCopy]];
}


-(void) showRouteFrom: (Place*) pickUp
{
    [self.mapUser removeAnnotations:[self.mapUser annotations]];
	PlaceMark* markPickUp = [[PlaceMark alloc] initWithPlace:pickUp];
	[self.mapUser addAnnotation:markPickUp];
//	[self centerMap:pickUp];
    
      MKPlacemark *source = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(37.776142, -122.424774)  addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
//    [self.mapUser centerCoordinate:source.c];

    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:source];
    [distMapItem setName:@""];
    
     MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(37.73787, -122.373962) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    
    MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
    [srcMapItem setName:@""];
    
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    [request setSource:srcMapItem];
    [request setDestination:distMapItem];
    [request setTransportType:MKDirectionsTransportTypeAutomobile];
    
    MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
    
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        NSLog(@"response = %@",response);
        NSArray *arrRoutes = [response routes];
        [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            MKRoute *rout = obj;
//       NSString *    routeDetails = response.routes.lastObject;
            MKPolyline *line = [rout polyline];
//            MKPolylineRenderer  * routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:line];
//            routeLineRenderer.strokeColor = [UIColor redColor];
//            routeLineRenderer.lineWidth = 15;

            [self.mapUser addOverlay:line];
            NSLog(@"Rout Name : %@",rout.name);
            NSLog(@"Total Distance (in Meters) :%f",rout.distance);
            
            NSArray *steps = [rout steps];
            
            NSLog(@"Total Steps : %lu",(unsigned long)[steps count]);
//            [self.mapUser addOverlay:routeDetails.polyline];

            [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSLog(@"Rout Instruction : %@",[obj instructions]);
                NSLog(@"Rout Distance : %f",[obj distance]);
            }];
        }];
    
    }];

}

- (MKPolyline *)polylineWithEncodedString:(NSString *)encodedString {
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    
    NSUInteger count = length / 4;
    CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
    NSUInteger coordIdx = 0;
    
    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        coords[coordIdx++] = coord;
        
        if (coordIdx == count) {
            NSUInteger newCount = count + 10;
            coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
            count = newCount;
        }
    }
    
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:coordIdx];
    free(coords);
    
    return polyline;
}


#pragma mark - add annotation on source and destination

-(void)addAnnotationSrcAndDestination :(CLLocationCoordinate2D )srcCord :(CLLocationCoordinate2D)destCord
{
    MKPointAnnotation *sourceAnnotation = [[MKPointAnnotation alloc]init];
    MKPointAnnotation *destAnnotation = [[MKPointAnnotation alloc]init];
    sourceAnnotation.coordinate=srcCord;
    destAnnotation.coordinate=destCord;
    sourceAnnotation.title=@"source";
    
    destAnnotation.title=@"dest";
    
    [self.mapUser addAnnotation:sourceAnnotation];
    [self.mapUser addAnnotation:destAnnotation];
    
    MKCoordinateRegion region;
    
    MKCoordinateSpan span;
    span.latitudeDelta=2;
    span.latitudeDelta=2;
    region.center=srcCord;
    region.span=span;
    CLGeocoder *geocoder= [[CLGeocoder alloc]init];
    for (NSString *strVia in routes) {
        [geocoder geocodeAddressString:strVia completionHandler:^(NSArray *placemarks, NSError *error) {
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                CLLocation *location = placemark.location;
                    //                CLLocationCoordinate2D coordinate = location.coordinate;
                MKPointAnnotation *viaAnnotation = [[MKPointAnnotation alloc]init];
                viaAnnotation.coordinate=location.coordinate;
                [self.mapUser addAnnotation:viaAnnotation];
                    //                NSLog(@"%@",placemarks);
            }
            
        }];
    }
    
    self.mapUser.region=region;
}


-(void) centerMap: (Place*) pickUp
{
	MKCoordinateRegion region;
	region.center.latitude     = pickUp.latitude;
	region.center.longitude    = pickUp.longitude;
	region.span.latitudeDelta  = 0.1;
	region.span.longitudeDelta = 0.1;
	
	[self.mapUser setRegion:region animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    PlaceMark *place=(PlaceMark *)annotation;
    MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PlaceMark"];
    if (place.place.isFrom)
    {
//        newAnnotation.pinColor = MKPinAnnotationColorRed;
        newAnnotation.image=[UIImage imageNamed:@"User + Z 6.png"];
    }
    else{
        newAnnotation.pinColor = MKPinAnnotationColorGreen;
    }
    /*
     if (![place.place.name isEqualToString:@"It's me"])
     {
     UIButton *btnSet=[UIButton buttonWithType:UIButtonTypeContactAdd];
     [btnSet addTarget:self action:@selector(onClicksetETA:) forControlEvents:UIControlEventTouchUpInside];
     newAnnotation.rightCalloutAccessoryView =btnSet;
     }
     */
//    newAnnotation.animatesDrop = YES;
    
    newAnnotation.canShowCallout = YES;
    return newAnnotation;
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
