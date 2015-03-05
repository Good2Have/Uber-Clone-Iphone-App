//
//  FirstVC.m
//  UberValetService
//
//  Created by Globussoft 1 on 10/27/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import "FirstVC.h"
#import "PlaceMark.h"
#import  "DriverInfo.h"
#import "Place.h"
#import "PickUpRequest.h"
#import "UIImageView+WebCache.h"
#import "ClientAssignment.h"
#import "RoundedImageView.h"
#import "UserDefaultHelper.h"
#import "LocationHelper.h"
#import <QuartzCore/QuartzCore.h>

@interface FirstVC (){
    int timeCount;
    BOOL rateToggle;
    int rateCount;
     BOOL isFeatchingDriverLocation;
     DriverInfo *driverInfo;
     NSTimer *timerDriverLocation;
    UIButton *washCarChekBox;
    UIButton *fueltopChekBox;
    NSString *fuelTopup;
    NSString *carWasing;
    NSString *state;
    NSString *transactionId;
    NSString *driverViewShowed;
    NSDate *pickUpTime;
    NSDate *dropOffTime;
    NSDecimalNumber *decimalNumber;
    
}
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)UILabel *timrlbl;
@property(nonatomic,strong)UIButton *dropOffButton;
@end

@implementation FirstVC
@synthesize payPalbutton ;

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

@synthesize mapUser,timer;
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
   
    driverViewShowed=@"No";
    UIScreen *mainScreen = [UIScreen mainScreen];
    NSLog(@"Screen bounds: %@, Screen resolution: %@, scale: %f, nativeScale: %f",
          NSStringFromCGRect(mainScreen.bounds), mainScreen.coordinateSpace, mainScreen.scale, mainScreen.nativeScale);
    
    fuelTopup=@"no";
    carWasing=@"no";
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getClientPush) name:@"clientPush" object:nil];
    
    _payPalConfiguration = [[PayPalConfiguration alloc] init];
    _payPalConfiguration.merchantName = @"Ultramagnetic Omega Supreme";
    _payPalConfiguration.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.omega.supreme.example/privacy"];
    _payPalConfiguration.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.omega.supreme.example/user_agreement"];

    driverInfo=[[DriverInfo alloc]init];
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
    [self.requestNowButton setFrame:CGRectMake(0, self.mapUser.frame.size.height-50, self.mapUser.frame.size.width, 50)];
    self.requestNowButton.backgroundColor=[UIColor blackColor];
    self.requestNowButton.titleLabel.frame=CGRectMake(190, self.view.frame.size.height-50, self.view.frame.size.width, 50);
    [self.requestNowButton setTitle:@"Request Now" forState:UIControlStateNormal];
    [self.requestNowButton addTarget:self action:@selector(requestNowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.requestNowButton];
    
    Place* home = [[Place alloc] init];
    home.name = @"It's me";
    home.description = @"";
    home.latitude = [[[UserDefaultHelper sharedObject] currentLatitude] doubleValue];
    home.longitude = [[[UserDefaultHelper sharedObject] currentLongitude] doubleValue];
    home.isFrom=YES;
    [self showRouteFrom:home];

//    [self call_feedBackVC];          //pay pal setup
        // Do any additional setup after loading the view.
}
    //pay pal methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
        // Start out working with the test environment! When you are ready, switch to PayPalEnvironmentProduction.
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
    [self getClientPush];
    
}


#pragma mark -
#pragma mark PayPal InstaceMethod
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _payPalConfiguration = [[PayPalConfiguration alloc] init];
        
        
            // See PayPalConfiguration.h for details and default values.
            // Should you wish to change any of the values, you can do so here.
            // For example, if you wish to accept PayPal but not payment card payments, then add:
        _payPalConfiguration.acceptCreditCards = YES;
            // Or if you wish to have the user choose a Shipping Address from those already
            // associated with the user's PayPal account, then add:
        _payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
        _payPalConfiguration.merchantName = @"Ultramagnetic Omega Supreme";
        _payPalConfiguration.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.omega.supreme.example/privacy"];
        _payPalConfiguration.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.omega.supreme.example/user_agreement"];

        
    }
    return self;
}

- (instancetype)initWithConfiguration:(PayPalConfiguration *)configuration
                             delegate:(id<PayPalFuturePaymentDelegate>)delegate{
    _payPalConfiguration = [[PayPalConfiguration alloc] init];
    _payPalConfiguration.merchantName = @"Ultramagnetic Omega Supreme";
    _payPalConfiguration.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.omega.supreme.example/privacy"];
    _payPalConfiguration.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.omega.supreme.example/user_agreement"];


    return  self;
}


#pragma mark - PayPalPaymentDelegate methods

- (void)payWithPayPal {
//     [self makePaymentUI];
        // Create a PayPalPayment
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    if ([carWasing isEqualToString:@"yes"]&&[fuelTopup isEqualToString:@"yes"]) {
            //fuel topup Charges + Car Washing Charges + Uber Service Charges
        decimalNumber=[[NSDecimalNumber alloc]initWithInteger:totalCharges];

    }else if ([carWasing isEqualToString:@"yes"])
    {
            //Car Washing Charges + Uber Service Charges
        decimalNumber=[[NSDecimalNumber alloc] initWithInteger:totalCharges];

    }else if([fuelTopup isEqualToString:@"yes"]){
        //Fuel TopUp Charges + Uber Service Charges
        decimalNumber=[[NSDecimalNumber alloc] initWithInteger:totalCharges];

    }else{
            //If extra service not choosen only  Uber Service Charges
     decimalNumber=[[NSDecimalNumber alloc] initWithInteger:totalCharges];
    }
          // Amount, currency, and description
    payment.amount = decimalNumber;
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Total Charges";
    

    payment.intent = PayPalPaymentIntentSale;
   
        // If your app collects Shipping Address information from the customer,
        // or already stores that information on your server, you may provide it here.
//    NSString *address = [[UserDefaultHelper sharedObject]adrsLable];
//    
//   payment.shippingAddress = (PayPalShippingAddress *)address; // a previously-created PayPalShippingAddress object
    
        // Several other optional fields that you can set here are documented in PayPalPayment.h,
        // including paymentDetails, items, invoiceNumber, custom, softDescriptor, etc.
    
        // Check whether payment is processable.
    if (!payment.processable) {
            // If, for example, the amount was negative or the shortDescription was empty, then
            // this payment would not be processable. You would want to handle that here.
    }
    PayPalPaymentViewController *paymentViewController;
    
    paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                   configuration:self.payPalConfiguration
                                                                        delegate:self];
    [self addChildViewController:paymentViewController];
        // Present the PayPalPaymentViewController.
//    [self presentViewController:paymentViewController animated:YES completion:nil];
    [self.view addSubview:paymentViewController.view];
}


- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment {
        // Payment was processed successfully; send to server for verification and fulfillment.
    [self verifyCompletedPayment:completedPayment];
    NSLog(@"paypal confiramtain is %@",completedPayment.confirmation);
    
        // Dismiss the PayPalPaymentViewController.
//    [self dismissViewControllerAnimated:YES completion:nil];
    [paymentViewController.view removeFromSuperview];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
        // The payment was canceled; dismiss the PayPalPaymentViewController.
//    [self dismissViewControllerAnimated:YES completion:nil];
    [paymentViewController.view removeFromSuperview];
}

- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
        // Send the entire confirmation dictionary
    NSData *confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation
                                                           options:0
                                                             error:nil];
         id parse=[NSJSONSerialization JSONObjectWithData:confirmation options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"parse %@",parse);
    NSDictionary *dict =[parse valueForKey:@"response"];
  state=[dict valueForKey:@"state"];
    transactionID=[dict valueForKey:@"id"];
    NSString *transactionTime = [dict valueForKey:@"create_time"];
    NSLog(@"state %@",state);
  
    if ([state isEqualToString:@"approved"]) {
        
        [self saveTransaction];
        self.cardDetail.hidden=NO;
        self.paymentView.hidden=YES;
        
        NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
        [dictParam setObject:transactionID forKey:@"paypal_id"];
        [dictParam setObject:[User currentUser].client_id forKey:PARAM_CLIENT_ID];
        [dictParam setObject:decimalNumber forKey:@"amount"];
        
        [dictParam setObject:transactionTime forKey:@"transactionTime"];
//        if ([ClientAssignment sharedObject].random_id ) {
//            [dictParam setObject:[ClientAssignment sharedObject].random_id forKey:@"trip_id"];
//        }
        
        [[mainAppDelegate sharedAppDelegate] showHUDLoadingView:@""];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:FILE_PAYMENT_DETAIL withParamData:dictParam withBlock:^(id response, NSError *error)
         {
             [[mainAppDelegate sharedAppDelegate]hideHUDLoadingView];
             if (response)
             {
                 NSMutableDictionary *dict=[response objectForKey:WS_UBER_ALPHA];
                 if ([[dict objectForKey:WS_STATUS]isEqualToString:WS_STATUS_SUCCESS])
                 {
                     
                 }
                 else{
                     [[mainAppDelegate sharedAppDelegate]showToastMessage:[dict objectForKey:WS_MESSAGE]];
                 }
             }
             else{
                 
             }
         }];
    }else{
    
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Payment Fail" message:@"Please Try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }

    }
        // Send confirmation to your server; your server should verify the proof of payment
        // and give the user their goods or services. If the server is not reachable, save
        // the confirmation and try again later.

#pragma  mark -
#pragma mark - MakePayment UI

-(void)makePaymentUI {
    
    
    UILabel * uberCharges;
    UILabel *xtraSrvicLbl;
    UILabel *washMyCarLbl;
    UILabel *fueltopUpLbl;
   
    UILabel *fuelChargLbl;
    UILabel *washChargLbl;
    UIButton  * allowFuturePaymentCheckBox;
    UIButton *rightClkedBtn;
    
    self.cardDetail.hidden=YES;
    self.paymentView=[[UIView alloc] init];
    self.paymentView.frame=CGRectMake(20,50, 280, self.view.frame.size.height-100);
        //WithFrame:CGRectMake(20,50, 280, self.view.frame.size.height-100)];
    self.paymentView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:self.paymentView];

    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:[User currentUser].client_id forKey:@"CLIENT_ID"];
    
    
             NSString * charges=@"20$";
             uberCharges = [[UILabel alloc] init ];
                 //                             WithFrame:CGRectMake(20, 50, 300, 40)];
             uberCharges.backgroundColor=[UIColor clearColor];
    
             uberCharges.textColor=[UIColor whiteColor];
             uberCharges.text=[NSString stringWithFormat:@"Uber service charges   %@",charges];
             uberCharges.font=[UIFont fontWithName:nil size:20.0];
             [self.paymentView addSubview:uberCharges];
             
             
             xtraSrvicLbl=[[UILabel alloc] init];
                 //                           WithFrame:CGRectMake(65, 5, 200, 40)];
             xtraSrvicLbl.backgroundColor=[UIColor clearColor];
             xtraSrvicLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
             xtraSrvicLbl.textColor=[UIColor colorWithRed:194.0/255.0 green:58.0/255.0 blue:58.0/255.0 alpha:1.0];
             xtraSrvicLbl.font=[UIFont fontWithName:nil size:15.0];
             xtraSrvicLbl.text=@"Add Extra Services ";
             xtraSrvicLbl.font=[UIFont fontWithName:nil size:20.0];
             [self.paymentView addSubview:xtraSrvicLbl];
             
             
             washMyCarLbl=[[UILabel alloc] init];
                 //                           WithFrame:CGRectMake(20, 80, 200, 40)];
             washMyCarLbl.backgroundColor=[UIColor clearColor];
             washMyCarLbl.textColor=[UIColor whiteColor];
             washMyCarLbl.text=@"Wash My Car ";
             [self.paymentView addSubview:washMyCarLbl];
             
             
            fueltopUpLbl=[[UILabel alloc] init ];
                 //    WithFrame:CGRectMake(20, 150, 200, 40)];
             fueltopUpLbl.backgroundColor=[UIColor clearColor];
             fueltopUpLbl.textColor=[UIColor whiteColor];
             fueltopUpLbl.text=@"Fuel Top Up ";
             [self.paymentView addSubview:fueltopUpLbl];
             
                          TotalLbl=[[UILabel alloc] init ];
                 //    WithFrame:CGRectMake(20, 150, 200, 40)];
             TotalLbl.backgroundColor=[UIColor clearColor];
             TotalLbl.textColor=[UIColor whiteColor];
    if ([carWasing isEqualToString:@"yes"]&&[fuelTopup isEqualToString:@"yes" ]) {
          totalCharges=60;
        TotalLbl.text=[NSString stringWithFormat:@"Total  Charges             %ld$",(long)totalCharges];
    }else if ([carWasing isEqualToString:@"yes"]){
        totalCharges=40;
    TotalLbl.text=[NSString stringWithFormat:@"Total  Charges             %ld$",(long)totalCharges];
    }else if ([fuelTopup isEqualToString:@"yes"]){
         totalCharges=40;
    TotalLbl.text=[NSString stringWithFormat:@"Total  Charges             %ld$",(long)totalCharges];
    }else{
         totalCharges=20;
    TotalLbl.text=[NSString stringWithFormat:@"Total  Charges             %ld$",(long)totalCharges];
    }
    
             [self.paymentView addSubview:TotalLbl];
    
             
             washCarChekBox=[UIButton buttonWithType:UIButtonTypeCustom];
    if ([carWasing isEqualToString:@"yes"]) {
        [washCarChekBox setImage:[UIImage imageNamed:@"checkbox_mark.png"] forState:UIControlStateNormal];
    }else{
        [washCarChekBox setImage:[UIImage imageNamed:@"checkbox_empty.png"] forState:UIControlStateNormal];
    }
            washCarChekBox.selected=NO;
             [washCarChekBox addTarget:self action:@selector(carWashing:) forControlEvents:UIControlEventTouchUpInside ];
             [self.paymentView addSubview:washCarChekBox];
             
             fuelChargLbl=[[UILabel alloc] init ];
                 //    WithFrame:CGRectMake(20, 150, 200, 40)];
             fuelChargLbl.backgroundColor=[UIColor clearColor];
             fuelChargLbl.textColor=[UIColor whiteColor];
             fuelChargLbl.text=@"20$";
             [self.paymentView addSubview:fuelChargLbl];
             
             fueltopChekBox=[UIButton buttonWithType:UIButtonTypeCustom];
             
    if ([fuelTopup isEqualToString:@"yes"]) {
      
        [fueltopChekBox setImage:[UIImage imageNamed:@"checkbox_mark.png"] forState:UIControlStateNormal];
    }
    else{
        [fueltopChekBox setImage:[UIImage imageNamed:@"checkbox_empty.png"] forState:UIControlStateNormal];
        }

             fueltopChekBox.selected=NO;
             [fueltopChekBox addTarget:self action:@selector(fuelTopUp:) forControlEvents:UIControlEventTouchUpInside ];
             [self.paymentView addSubview:fueltopChekBox];
             
             washChargLbl=[[UILabel alloc] init ];
                 //    WithFrame:CGRectMake(20, 150, 200, 40)];
             washChargLbl.backgroundColor=[UIColor clearColor];
             washChargLbl.textColor=[UIColor whiteColor];
             washChargLbl.text=@"20$";
             [self.paymentView addSubview:washChargLbl];
             
             
            UILabel *futrePaymentLabl=[[UILabel alloc] init ];
            futrePaymentLabl.backgroundColor=[UIColor clearColor];
            futrePaymentLabl.textColor=[UIColor whiteColor];
             futrePaymentLabl.text=@"To make faster payment in future ";
       futrePaymentLabl.font=[UIFont fontWithName:nil size:10.0];
            [self.paymentView addSubview:futrePaymentLabl];
    
    UILabel *orLabel=[[UILabel alloc] init ];
    orLabel.backgroundColor=[UIColor clearColor];
    orLabel.textColor=[UIColor whiteColor];
    orLabel.text=@"or ";
    orLabel.font=[UIFont fontWithName:nil size:10.0];
    [self.paymentView addSubview:orLabel];

    
             self.payPalbutton = [[UIButton alloc]init];
             [self.payPalbutton setFrame:CGRectMake(70,220, 115, 40)];
             self.payPalbutton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paynow.png"]];
            self.payPalbutton.titleLabel.frame=CGRectMake(0, 0, 50, 40);
            [self.payPalbutton addTarget:self action:@selector(payWithPayPal) forControlEvents:UIControlEventTouchUpInside];
             [self.paymentView addSubview:self.payPalbutton];
             
             self.allowFuturePayment = [[UIButton alloc]init];
             [self.allowFuturePayment setFrame:CGRectMake(10, 270, 115, 40)];
             self.allowFuturePayment.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"quick_pay.png"]];
            [self.allowFuturePayment addTarget:self action:@selector(obtainConsent:) forControlEvents:UIControlEventTouchUpInside ];
                 [self.paymentView addSubview:self.allowFuturePayment];
            [orLabel setFont:[UIFont fontWithName:@"System" size:36]];
            [futrePaymentLabl setFont:[UIFont fontWithName:@"System" size:25]];
           if ([UIScreen mainScreen].nativeScale == 2.0f){
            if (self.view.frame.size.height>568.0f) {
                NSLog(@"in iPhone 6");
                self.paymentView.frame=CGRectMake(20,50, 340, self.view.frame.size.height-160);
                    //            xtraSrvicLbl.frame=CGRectMake(65, 5, 200, 40);
                uberCharges.frame=CGRectMake(40, 50, 300, 40);
                
                fueltopUpLbl.frame=CGRectMake(70, 160, 200, 40);
                fueltopChekBox.frame=CGRectMake(20, 160, 40, 40);
                fuelChargLbl.frame=CGRectMake(245, 160, 200, 40);
                
                rightClkedBtn.frame=CGRectMake(30, 240, self.view.frame.size.width-100, 40);
                washMyCarLbl.frame=CGRectMake(70, 100, 200, 40);
                washCarChekBox.frame=CGRectMake(20, 100, 40, 40);
                washChargLbl.frame=CGRectMake(245, 100, 200, 40);
                
                TotalLbl.frame=CGRectMake(70, 225, 210, 40);
                
                allowFuturePaymentCheckBox.frame=CGRectMake(230, 280, 40, 40);
                xtraSrvicLbl.frame=CGRectMake(65, 5, 200, 40);
                
                self.payPalbutton.frame=CGRectMake(100,280, 115,40);
                orLabel.frame=CGRectMake(140, 330, 250, 40);
                self.allowFuturePayment.frame=CGRectMake(100, 380, 115, 40);
                futrePaymentLabl.frame=CGRectMake(100,410, 250, 40);
                futrePaymentLabl.font=[UIFont fontWithName:nil size:9.0];
//                [orLabel setFont:[UIFont fontWithName:@"System" size:36]];
//                [futrePaymentLabl setFont:[UIFont fontWithName:@"System" size:36]];
                
            }
            else if ( self.view.bounds.size.height==518.0f) {
                NSLog(@"in iPhone 5");
                self.paymentView.frame=CGRectMake(20,50, 280, self.view.frame.size.height-70);
                uberCharges.frame=CGRectMake(20, 70, 300, 40);
                fuelChargLbl.frame=CGRectMake(225, 165, 200, 40);
                washChargLbl.frame=CGRectMake(225, 115, 200, 40);
                fueltopUpLbl.frame=CGRectMake(50, 165, 200, 40);
                washMyCarLbl.frame=CGRectMake(50, 115, 200, 40);
                futrePaymentLabl.frame=CGRectMake(70, 390, 250, 40);
                self.allowFuturePayment.frame=CGRectMake(80, 350, 115, 40);
                allowFuturePaymentCheckBox.frame=CGRectMake(230, 280, 40, 40);
                xtraSrvicLbl.frame=CGRectMake(65, 5, 200, 40);
                washCarChekBox.frame=CGRectMake(5, 115, 40, 40);
                fueltopChekBox.frame=CGRectMake(5, 165, 40, 40);
                TotalLbl.frame=CGRectMake(35, 205, 210, 40);
                orLabel.frame=CGRectMake(130, 315, 250, 40);
                self.payPalbutton.frame=CGRectMake(80,280, 115, 40);
                futrePaymentLabl.font=[UIFont fontWithName:nil size:9.0];

            }
            else{
                NSLog(@"in iPhone 4");
                self.paymentView.frame=CGRectMake(20,50, 280, self.view.frame.size.height-70);
                uberCharges.frame=CGRectMake(20, 50, 300, 40);
                fuelChargLbl.frame=CGRectMake(225, 135, 200, 40);
                washChargLbl.frame=CGRectMake(225, 95, 200, 40);
                    //            xtraSrvicLbl.frame=CGRectMake(65, 5, 200, 40);
                fueltopUpLbl.frame=CGRectMake(50, 135, 200, 40);
                washMyCarLbl.frame=CGRectMake(50, 95, 200, 40);
                futrePaymentLabl.frame=CGRectMake(65, 310, 250, 40);
                self.allowFuturePayment.frame=CGRectMake(70, 280, 115, 40);
                allowFuturePaymentCheckBox.frame=CGRectMake(230, 280, 40, 40);
                xtraSrvicLbl.frame=CGRectMake(65, 5, 200, 40);
                washCarChekBox.frame=CGRectMake(5, 95, 40, 40);
                fueltopChekBox.frame=CGRectMake(5, 135, 40, 40);
                TotalLbl.frame=CGRectMake(35, 175, 210, 40);
                orLabel.frame=CGRectMake(120, 250, 250, 40);     
                futrePaymentLabl.font=[UIFont fontWithName:nil size:8.0];

            }
            
        }
        else if ([UIScreen mainScreen].scale > 2.1f)
        {
            NSLog(@"in iPhone 6 plus");
            self.paymentView.frame=CGRectMake(20,50, 380, self.view.frame.size.height-150);
//            xtraSrvicLbl.frame=CGRectMake(65, 5, 200, 40);
               uberCharges.frame=CGRectMake(40, 50, 300, 40);
            
            fueltopUpLbl.frame=CGRectMake(70, 160, 200, 40);
           fueltopChekBox.frame=CGRectMake(20, 160, 40, 40);
             fuelChargLbl.frame=CGRectMake(245, 160, 200, 40);
            
            rightClkedBtn.frame=CGRectMake(30, 240, self.view.frame.size.width-100, 40);
             washMyCarLbl.frame=CGRectMake(70, 100, 200, 40);
            washCarChekBox.frame=CGRectMake(20, 100, 40, 40);
             washChargLbl.frame=CGRectMake(245, 100, 200, 40);
            
            TotalLbl.frame=CGRectMake(70, 225, 210, 40);
            futrePaymentLabl.font=[UIFont fontWithName:nil size:10.0];            allowFuturePaymentCheckBox.frame=CGRectMake(230, 280, 40, 40);
            xtraSrvicLbl.frame=CGRectMake(65, 5, 200, 40);
            
            self.payPalbutton.frame=CGRectMake(100,280, 148, 50);
              orLabel.frame=CGRectMake(140, 330, 250, 40);
            self.allowFuturePayment.frame=CGRectMake(100, 380, 148, 50);
             futrePaymentLabl.frame=CGRectMake(100,430, 250, 40);
        }
        else
        {
            NSLog(@"in iPad ");
            self.paymentView.frame=CGRectMake(20,50, 280, self.view.frame.size.height-70);
            uberCharges.frame=CGRectMake(20, 50, 300, 40);
            fuelChargLbl.frame=CGRectMake(225, 135, 200, 40);
            washChargLbl.frame=CGRectMake(225, 95, 200, 40);
            fueltopUpLbl.frame=CGRectMake(50, 135, 200, 40);
            washMyCarLbl.frame=CGRectMake(50, 95, 200, 40);
            futrePaymentLabl.frame=CGRectMake(65, 310, 250, 40);
            self.allowFuturePayment.frame=CGRectMake(70, 280, 115, 40);
           futrePaymentLabl.font=[UIFont fontWithName:nil size:8.0];
            allowFuturePaymentCheckBox.frame=CGRectMake(230, 280, 40, 40);
             xtraSrvicLbl.frame=CGRectMake(65, 5, 200, 40);
            washCarChekBox.frame=CGRectMake(5, 95, 40, 40);
            fueltopChekBox.frame=CGRectMake(5, 135, 40, 40);
            TotalLbl.frame=CGRectMake(35, 175, 210, 40);
            orLabel.frame=CGRectMake(120, 250, 250, 40);

        }
        
    }


#pragma mark - Future Payments methods .
#pragma mark =====================

- (void)obtainConsent:(UIButton *)sender {
    
  
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:[User currentUser].client_id forKey:@"CLIENT_ID"];
    
    
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
    [afn getDataFromPath:FILE_PAYPAL_CLIENT_REFRESH_TOKEN withParamData:dictParam withBlock:^(id response, NSError *error)
     {

         if (response)
         {
             NSDictionary *res= [response valueForKey:@"uber_alpha"];
             NSString *str1=[res valueForKey:@"refresh_token"];
             NSString *str2=[res valueForKey:@"client_correlation_id"];
             if (![str1 isEqualToString:@"Refresh token is NULL"]) {
                 
               decimalNumber=[[NSDecimalNumber alloc] initWithInteger:totalCharges];
                 NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
                 [dictParam setObject:[User currentUser].client_id forKey:@"CLIENT_ID"];
                 [dictParam setObject:str2 forKey:@"CORRELATION_ID"];
                 [dictParam setObject:str1 forKey:@"REFRESH_TOKEN"];
                 [dictParam setObject:decimalNumber forKey:@"TOTAL"];
                 
                 AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                 [afn getDataFromPath:FILE_PAYPAL_POST_PAYMENT withParamData:dictParam withBlock:^(id response, NSError *error)
                  {
                      [[mainAppDelegate sharedAppDelegate]hideHUDLoadingView];
                      if (response)
                      {
                          NSDictionary *res= [response valueForKey:@"uber_alpha"];
                          if (res) {
                              transactionID=[res valueForKey:@"id"];
                              state=[res valueForKey:@"state"];
                              if ([state isEqualToString:@"approved"]) {
                                 
                                  NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
                                  [dictParam setObject:transactionID forKey:@"paypal_id"];
                                  [dictParam setObject:[User currentUser].client_id forKey:PARAM_CLIENT_ID];
                                  [dictParam setObject:decimalNumber forKey:@"amount"];
                                  
                                
                                  
                                  [[mainAppDelegate sharedAppDelegate] showHUDLoadingView:@""];
                                  AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                                  [afn getDataFromPath:FILE_PAYMENT_DETAIL withParamData:dictParam withBlock:^(id response, NSError *error)
                                   {
                                       [[mainAppDelegate sharedAppDelegate]hideHUDLoadingView];
                                       if (response)
                                       {
                                           NSMutableDictionary *dict=[response objectForKey:WS_UBER_ALPHA];
                                           if ([[dict objectForKey:WS_STATUS]isEqualToString:WS_STATUS_SUCCESS])
                                           {
                                                [self saveTransaction];
                                               self.cardDetail.hidden=NO;

                                               self.paymentView.hidden=YES;
                                               self.paymentView=nil;
                                           }
                                           else{
                                               [[mainAppDelegate sharedAppDelegate]showToastMessage:[dict objectForKey:WS_MESSAGE]];
                                           }
                                       }
                                   }];
                              }}}
                  }];

             }else{
             
                 [self getPaypalRefreshToken];

                 
             }
         }else{
         
             [self getPaypalRefreshToken];
         
         }
      }];
     }

#pragma mark - PayPalFuturePaymentDelegate methods

-(void)getPaypalRefreshToken{

    PayPalFuturePaymentViewController *fpViewController;
    
    fpViewController = [[PayPalFuturePaymentViewController alloc] initWithConfiguration:_payPalConfiguration
                                                                               delegate:self];
        //     fpViewController = [[PayPalFuturePaymentViewController alloc]ini
    [self addChildViewController:fpViewController];
    
        // Present the PayPalFuturePaymentViewController
        //    [self presentViewController:fpViewController animated:YES completion:nil];
    [self.view addSubview:fpViewController.view];


}


- (void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController {
        // User cancelled login. Dismiss the PayPalLoginViewController, breathe deeply.
//    [self dismissViewControllerAnimated:YES completion:nil];
    [futurePaymentViewController.view removeFromSuperview];
}

- (void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController
                didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization {
        // The user has successfully logged into PayPal, and has consented to future payments.
    
        // Your code must now send the authorization response to your server.
    [self sendAuthorizationToServer:futurePaymentAuthorization];
    
        // Be sure to dismiss the PayPalLoginViewController.
//    [self dismissViewControllerAnimated:YES completion:nil];
    [futurePaymentViewController.view removeFromSuperview];
}

- (void)sendAuthorizationToServer:(NSDictionary *)authorization {
        // Send the entire authorization reponse
    NSData *consentJSONData = [NSJSONSerialization dataWithJSONObject:authorization
                                                              options:0
                                                                error:nil];
    NSString *correlationId = [PayPalMobile applicationCorrelationIDForEnvironment:PayPalEnvironmentSandbox];
    NSLog(@"content Json data  %@",consentJSONData);
    NSLog(@"content corelation id %@",correlationId);
    NSLog(@" authorization response  %@",authorization);
    
    NSDictionary *dict=[authorization valueForKey:@"response"];
    NSString *str=[dict valueForKey:@"code"];
    
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:str forKey:@"AUTHORIZATION_CODE"];
    [dictParam setObject:correlationId forKey:@"CORRELATION_ID"];
    [dictParam setObject:[User currentUser].client_id forKey:@"CLIENT_ID"];
    
    //        if ([ClientAssignment sharedObject].random_id ) {
        //            [dictParam setObject:[ClientAssignment sharedObject].random_id forKey:@"trip_id"];
        //        }
    
    [[mainAppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
    [afn getDataFromPath:FILE_PAYPAL_REFRESH_TOKEN withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         [[mainAppDelegate sharedAppDelegate]hideHUDLoadingView];
         if (response)
         {
             NSDictionary *res= [response valueForKey:@"uber_alpha"];
             NSString *str1=[res valueForKey:@"refresh_token"];
             decimalNumber=[[NSDecimalNumber alloc]initWithInteger:totalCharges];

             NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
            [dictParam setObject:[User currentUser].client_id forKey:@"CLIENT_ID"];
             [dictParam setObject:correlationId forKey:@"CORRELATION_ID"];
             [dictParam setObject:str1 forKey:@"REFRESH_TOKEN"];
             [dictParam setObject:decimalNumber forKey:@"TOTAL"];

             AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
             [afn getDataFromPath:FILE_PAYPAL_POST_PAYMENT withParamData:dictParam withBlock:^(id response, NSError *error)
              {
                  [[mainAppDelegate sharedAppDelegate]hideHUDLoadingView];
                  if (response)
                  {
                      NSDictionary *res= [response valueForKey:@"uber_alpha"];
                      if (res) {
                          transactionID=[res valueForKey:@"id"];
                         state=[res valueForKey:@"state"];
                          if ([state isEqualToString:@"approved"]) {
                              self.paymentView.hidden=YES;
                              self.cardDetail.hidden=NO;
                          [self saveTransaction];
                              NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
                              [dictParam setObject:transactionID forKey:@"paypal_id"];
                              [dictParam setObject:[User currentUser].client_id forKey:PARAM_CLIENT_ID];
                              [dictParam setObject:decimalNumber forKey:@"amount"];
                              
//                              [dictParam setObject:transactionTime forKey:@"transactionTime"];
                                  //        if ([ClientAssignment sharedObject].random_id ) {
                                  //            [dictParam setObject:[ClientAssignment sharedObject].random_id forKey:@"trip_id"];
                                  //        }
                              
                              [[mainAppDelegate sharedAppDelegate] showHUDLoadingView:@""];
                              AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                              [afn getDataFromPath:FILE_PAYMENT_DETAIL withParamData:dictParam withBlock:^(id response, NSError *error)
                               {
                                   [[mainAppDelegate sharedAppDelegate]hideHUDLoadingView];
                                   if (response)
                                   {
                                       NSMutableDictionary *dict=[response objectForKey:WS_UBER_ALPHA];
                                       if ([[dict objectForKey:WS_STATUS]isEqualToString:WS_STATUS_SUCCESS])
                                       {
                                           
                                       }
                                       else{
                                           [[mainAppDelegate sharedAppDelegate]showToastMessage:[dict objectForKey:WS_MESSAGE]];
                                       }
                                   }
                                   else{
                                       
                                   }
                               }];

                              
                          }
                      }
                  }
         
              }];
            }
else{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Payment Fail" message:@"Please Try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}
     }];
        // (Your network code here!)
        //

        // Send the authorization response to your server, where it can exchange the authorization code
        // for OAuth access and refresh tokens.
        //
        // Your server must then store these tokens, so that your server code can execute payments
        // for this user in the future.
}


-(void)saveTransaction{
        if (!self.saveTransactionView) {
            
            self.saveTransactionView=[[UIView alloc] init];
            self.saveTransactionView.backgroundColor=[UIColor blackColor];
            [self.mapUser addSubview:self.saveTransactionView];
            NSLog(@"view height %f",self.view.frame.size.height);
            UILabel * xtraSrvicLbl=[[UILabel alloc] initWithFrame:CGRectMake(65, 5, 200, 40)];
            xtraSrvicLbl.backgroundColor=[UIColor clearColor];
           xtraSrvicLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            xtraSrvicLbl.textColor=[UIColor colorWithRed:194.0/255.0 green:58.0/255.0 blue:58.0/255.0 alpha:1.0];
//           xtraSrvicLbl.font=[UIFont fontWithName:nil size:15.0];
           xtraSrvicLbl.text=@"Transaction Details";
         xtraSrvicLbl.font=[UIFont fontWithName:nil size:20.0];
            [self.saveTransactionView addSubview:xtraSrvicLbl];
            
            UILabel *TransactionLabel = [[UILabel alloc] init];
          TransactionLabel.backgroundColor=[UIColor clearColor];
            TransactionLabel.textColor=[UIColor whiteColor];
            TransactionLabel.text=@"Transaction Id";
            TransactionLabel.font=[UIFont fontWithName:nil size:20.0];
            [self.saveTransactionView addSubview: TransactionLabel];
            
//            NSString * totalAmount=@"60$";
         UILabel * totalAmountLbl = [[UILabel alloc] init];
          totalAmountLbl.backgroundColor=[UIColor clearColor];
           totalAmountLbl.textColor=[UIColor whiteColor];
        totalAmountLbl.text=[NSString stringWithFormat:@"Total charges is %d",totalCharges];
        totalAmountLbl.font=[UIFont fontWithName:nil size:20.0];
            [self.saveTransactionView addSubview:totalAmountLbl];
            
            
            UILabel *iDLabel = [[UILabel alloc] init];
            iDLabel.backgroundColor=[UIColor clearColor];
           iDLabel.textColor=[UIColor whiteColor];
            iDLabel.text=transactionID;
            iDLabel.font=[UIFont fontWithName:nil size:12.0];
            [self.saveTransactionView addSubview: iDLabel];
            
       UIButton * saveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            saveBtn.backgroundColor = [UIColor redColor];
            [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
            [saveBtn addTarget:self action:@selector(captureView) forControlEvents:UIControlEventTouchUpInside ];
            [self.saveTransactionView addSubview: saveBtn];
            
         UIButton *  cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            cancelBtn.backgroundColor = [UIColor redColor];
            [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
            [cancelBtn addTarget:self action:@selector(transactionCancel) forControlEvents:UIControlEventTouchUpInside ];
            [self.saveTransactionView addSubview:cancelBtn];
            
            NSLog(@"self.view.bounds.size.height = %f",self.view.bounds.size.height);
                if ([UIScreen mainScreen].nativeScale == 2.0f){
            if (self.view.frame.size.height>568.0f) {
                NSLog(@"in iPhone 6");
                self.saveTransactionView.frame =CGRectMake(20,50, 340, self.view.frame.size.height-400);
                self.extraService.frame = CGRectMake(65, 5, 200, 40);
               TransactionLabel.frame = CGRectMake(90, 60, 250, 40);
                totalAmountLbl.frame = CGRectMake(60, 120, 250, 40);
                iDLabel.frame = CGRectMake(40, 90, 250, 40);
                saveBtn.frame = CGRectMake(20, 170, 150, 40);
              cancelBtn.frame = CGRectMake(180, 170, 150, 40);
                
            }
            else if ( self.view.bounds.size.height==518.0f) {
                NSLog(@"in iPhone 5");
                self.saveTransactionView.frame =CGRectMake(20,50, 280, self.view.frame.size.height-250);
//                self.extraService.frame = CGRectMake(65, 5, 200, 40);
               TransactionLabel.frame = CGRectMake(90, 40, 250, 40);
                totalAmountLbl.frame = CGRectMake(40, 160, 250, 40);
                iDLabel.frame = CGRectMake(40, 70, 250, 40);
              saveBtn.frame = CGRectMake(20, 220, 120, 40);
            cancelBtn.frame = CGRectMake(150, 220, 120, 40);
                
                
            }
            else{
                NSLog(@"in iPhone 4");
                self.saveTransactionView.frame =CGRectMake(20,50, 280, self.view.frame.size.height-215);
                TransactionLabel.frame = CGRectMake(90, 40, 250, 40);
                totalAmountLbl.frame = CGRectMake(40, 90, 250, 40);
                iDLabel.frame = CGRectMake(20, 70, 250, 40);
                saveBtn.frame = CGRectMake(20, 160, 120, 40);
                cancelBtn.frame = CGRectMake(150, 160, 120, 40);
                
                
            }
            
        }
        else if ([UIScreen mainScreen].scale > 2.1f)
        {
            NSLog(@"in iPhone 6 plus");
            self.saveTransactionView.frame =CGRectMake(40,50, 320, self.view.frame.size.height-415);
//            self.extraService.frame = CGRectMake(65, 5, 200, 40);
            TransactionLabel.frame = CGRectMake(90, 40, 250, 40);
           totalAmountLbl.frame = CGRectMake(40, 160, 250, 40);
            iDLabel.frame = CGRectMake(40, 70, 250, 40);
            saveBtn.frame = CGRectMake(20, 220, 120, 40);
          cancelBtn.frame = CGRectMake(150, 220, 120, 40);
            
            
        }
                    else
                    {
                        NSLog(@"in iPad ");
                        self.saveTransactionView.frame =CGRectMake(20,50, 280, self.view.frame.size.height-215); 
                        TransactionLabel.frame = CGRectMake(80, 40, 250, 40);

                        totalAmountLbl.frame = CGRectMake(40, 100, 250, 40);
                        iDLabel.frame = CGRectMake(20, 70, 250, 40);
                        saveBtn.frame = CGRectMake(20, 160, 120, 40);
                        cancelBtn.frame = CGRectMake(150, 160, 120, 40);
                        
                        
                    }
        
               }
    }

-(void)transactionCancel{
    self.saveTransactionView.hidden = YES;
    self.cardDetail.hidden=NO;
}


- (UIImage *)captureView {
    
//
    CGRect rect = [self.saveTransactionView bounds];
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.saveTransactionView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.saveTransactionView.hidden = YES;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
        UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"Photo saved to album" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [view show];
        self.cardDetail.hidden=NO;
           self.saveTransactionView.hidden = YES;
        
    });
    
    return img;
}


#pragma mark -
#pragma mark PickUp Valet Request

-(void)requestNowButtonClick:(UIButton *)button{

    self.requestNowButton.hidden=YES;
    
    self.cardDetail=[[UIView alloc]initWithFrame:CGRectMake(10, -30
                                                            , self.view.frame.size.width-20, 140 )];
    self.cardDetail.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"payment_bg.png"]];
//    self.cardDetail.hidden=YES;
    [self.view addSubview:self.cardDetail];
    
    self.addExtraServiceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.addExtraServiceBtn addTarget:self action:@selector(extraSrviceButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.addExtraServiceBtn setFrame:CGRectMake(10, 0, 200, 40)];

//    self.addExtraServiceBtn.frame=CGRectMake(self.view.bounds.size.width-310,50, 200, 40);
    self.addExtraServiceBtn.backgroundColor=[UIColor clearColor];
   [self.addExtraServiceBtn setTitle:@"Add Extra Services" forState:UIControlStateNormal];
    [self.cardDetail addSubview:self.addExtraServiceBtn];
    
    self.payPalbutton = [[UIButton alloc]init];
//    self.payPalbutton.frame=CGRectMake(self.view.bounds.size.width-310,45, 100, 40);
    self.payPalbutton.frame=CGRectMake(20,45, 100, 40);
//    [self.payPalbutton setFrame:CGRectMake(10, 0, 100, 40)];
    self.payPalbutton.backgroundColor = [UIColor blackColor];
//    self.payPalbutton.titleLabel.frame=CGRectMake(0, 0, 100, 40);
    [self.payPalbutton setTitle:@"Pay now" forState:UIControlStateNormal];
    [self.payPalbutton addTarget:self action:@selector(makePaymentUI) forControlEvents:UIControlEventTouchUpInside];
    [self.cardDetail addSubview:self.payPalbutton];
    
//   UIButton *Futurebutton = [[UIButton alloc]init];
////    [Futurebutton setFrame:CGRectMake(130, 0, 160, 40)];
//    [Futurebutton setFrame:CGRectMake(130, 45, 160, 40)];
//    Futurebutton.backgroundColor = [UIColor blackColor];
//    Futurebutton.titleLabel.frame=CGRectMake(0, 0, 50, 40);
//    [Futurebutton setTitle:@"Future payment" forState:UIControlStateNormal];
//    [Futurebutton addTarget:self action:@selector(obtainConsent:) forControlEvents:UIControlEventTouchUpInside];
//    [self.cardDetail addSubview:Futurebutton];

    self.confirmPickUpBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmPickUpBtn addTarget:self action:@selector(confrmPickUpBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmPickUpBtn.frame=CGRectMake(40, 100, self.view.bounds.size.width-80, 40);
    self.confirmPickUpBtn.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"reglog.png"]];
    [self.confirmPickUpBtn setTitle:@"Confirm Pickup" forState:UIControlStateNormal];
    [self.cardDetail addSubview:self.confirmPickUpBtn];
    
    
    if ([UIScreen mainScreen].nativeScale == 2.0f){
        
        if (self.view.frame.size.height>568.0f) {
            
            NSLog(@"in iPhone 6");
        }
        
        else if ( self.view.bounds.size.height==518.0f) {
            
            NSLog(@"in iPhone 5");
        }
        
        else{

            NSLog(@"in iPhone 4");
            
        }
        
    }
    
    else if ([UIScreen mainScreen].scale > 2.1f)
        
    {
        
        NSLog(@"in iPhone 6 plus");
//         self.payPalbutton.titleLabel.frame=CGRectMake(-300, 0, 100, 40);
    }
    
    else
        
    {
        
        NSLog(@"in iPad ");
    }
    

    
    [UIView animateWithDuration:1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.cardDetail.frame  = CGRectMake(10, self.view.frame.size.height-150, self.view.frame.size.width-20, 150);
    } completion:^(BOOL finished) {
        self.cardDetail.frame =CGRectMake(10, self.view.frame.size.height-150
                                          , self.view.frame.size.width-20, 150);

    }];
    
    
    
    
    
}

-(void)confrmPickUpBtnClick:(UIButton *)button{
    
      NSString *str= [[NSUserDefaults standardUserDefaults] objectForKey:@"FirstTimeRun"];
    if (str==nil) {
        self.cardDetail.hidden=YES;
        self.frstTimePopVC=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.frstTimePopVC.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_.png"]];
        [self.view addSubview:self.frstTimePopVC];
        
        UIButton  *popUpVC=[[UIButton alloc] init ];
        popUpVC.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"congratulation.png"]];
        [popUpVC addTarget:self action:@selector(okButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.frstTimePopVC addSubview:popUpVC];

        if ([UIScreen mainScreen].nativeScale == 2.0f){
            if (self.view.frame.size.height>568.0f) {
                NSLog(@"in iPhone6");
                popUpVC.frame=CGRectMake(40, 70, self.view.frame.size.width-80, self.frstTimePopVC.frame.size.height-230);
            }
            else if ( self.view.bounds.size.height==518.0f) {
                NSLog(@"in iPhone5");
                popUpVC.frame=CGRectMake(20, 25, self.view.frame.size.width-40, self.frstTimePopVC.frame.size.height-130);
            }
            else{
                popUpVC.frame=CGRectMake(20, 25, self.view.frame.size.width-40, self.frstTimePopVC.frame.size.height-50);
            }
            
        }
        else if ([UIScreen mainScreen].scale > 2.1f)
        {
            NSLog(@"in iPhone 6 plus");
            popUpVC.frame=CGRectMake(30, 45, self.view.frame.size.width-60, self.frstTimePopVC.frame.size.height-220);
            
        }
        else
        {
            NSLog(@"in iPad ");
            popUpVC.frame=CGRectMake(25, 25, self.view.frame.size.width-45, self.frstTimePopVC.frame.size.height-50);

        }

        
    
    }else{
        [self confirmPickup];

    }
 }
-(void)confirmPickup{
    
    if (![state isEqualToString:@"approved"]) {
   UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Payment is not approved or payment not done " message:@"Please Try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        self.cardDetail.hidden=NO;
    
    }else{
    
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:[User currentUser].client_id forKey:PARAM_CLIENT_ID];
    
   [dictParam setObject:[[UserDefaultHelper sharedObject] currentLatitude] forKey:PARAM_LATTITUDE];
   [dictParam setObject:[[UserDefaultHelper sharedObject] currentLongitude] forKey:PARAM_LOGITUDE];
        [dictParam setObject:transactionID forKey:@"pay_id"];
        [dictParam setObject:@"Yes" forKey:@"payment_status"];
        [dictParam setObject:carWasing forKey:@"car_washing"];
        [dictParam setObject:fuelTopup forKey:@"fuel_topup"];
    
        //also dict param set fuel topUp and wash car information
    
    AFNHelper *Afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
    [Afn getDataFromPath:FILE_CLIENT_PICK_REQUEST withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         if (response)
         {
             NSMutableDictionary *dictMain=[response objectForKey:WS_UBER_ALPHA];
             if ([[dictMain objectForKey:WS_STATUS]isEqualToString:WS_STATUS_SUCCESS])
             {
//                     [self showDriverViewMethod];
                 PickUpRequest *pick=[[PickUpRequest alloc]init];
                [pick setData:[dictMain objectForKey:WS_DETAILS]];
                 self.cardDetail.hidden=YES;
                 self.cardDetail=nil;
                 [ClientAssignment sharedObject].random_id=pick.random_id;
                 [self getDriverInformation:self];
            
            }
       }
     }];
//    }

     }
}


-(void)okButton:(UIButton *)button{
    [[NSUserDefaults standardUserDefaults] setObject:@"Uber Valet" forKey:@"FirstTimeRun"];

    self.frstTimePopVC.hidden=YES;
    self.frstTimePopVC=nil;
    [self confirmPickup];
}

#pragma mark -
#pragma mark Client Push Service
-(void)getClientPush{
  NSString *str=    [[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"];
    if ([str isEqualToString:@"Yes"]) {
       
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
        if ([User currentUser].client_id!=nil) {
            
    [dictParam setObject:[User currentUser].client_id forKey:PARAM_USER_ID];
    if ([ClientAssignment sharedObject].random_id!=nil) {
        [dictParam setObject:[ClientAssignment sharedObject].random_id forKey:PARAM_RANDOM_ID];
    }
    
    [[mainAppDelegate sharedAppDelegate]showHUDLoadingView:@""];
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
    [afn getDataFromPath:FILE_CLIENT_PUSH withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         [[mainAppDelegate sharedAppDelegate]hideHUDLoadingView];
         if (response)
         {
             NSMutableDictionary *dict=[response objectForKey:@"aps"];
             if ([[dict objectForKey:@"id"] intValue]==1) {
                 
                 PickUpRequest *pick=[[PickUpRequest alloc]init];
                 [pick setData:dict];
                 [[ClientAssignment sharedObject]setData:dict];
                 [ClientAssignment sharedObject].random_id=pick.random_id;
                 
                 
                 [self showDriverViewMethod];
                    if (timer)
                     {
                         [timer invalidate];
                         timer=nil;
                     }
//                 [self showDriverReachtime];

        timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime:) userInfo:nil repeats:YES];

                 
        timerDriverLocation=[NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(getDriverLocation:) userInfo:nil repeats:YES];
                 
             }
             else if ([[dict objectForKey:@"id"] intValue]==4)
             {
                 [[ClientAssignment sharedObject]removeAllData];
             }else if ([[dict objectForKey:@"id"] intValue]==5)
             {
                           [self updateDropOffLabel];
             }
             else if ([[dict objectForKey:@"id"] intValue]==2)
             {
                 [self call_feedBackVC];
             
             }else{
                 [self handalClientPush:response];
       timerDriverLocation=[NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(getDriverLocation:) userInfo:nil repeats:YES];
             }
//             [self goToHome];
         }
     }];
    }
  }

}

-(void)changeTime:(id)sender
{
    
     self.timrlbl.text=[self getTimeDiffrent:[ClientAssignment sharedObject].dateETAClient];
    if ([self.timrlbl.text isEqualToString:@"0:0:0"]) {
        [self.timer invalidate];
        self.showDrivrRichTimeLbl.hidden=YES;
        self.timer=nil;
    }
}

-(NSString *)getTimeDiffrent:(NSDate *)date
{
    NSDate *dateA=[NSDate date];
    NSDate *dateB=date;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
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



-(void)handalClientPush:(NSDictionary *)dictPush
{
    [[ClientAssignment sharedObject]setData:[dictPush objectForKey:@"aps"]];
//    [self gotoView:[HomeVC sharedObject]];
    if ([[ClientAssignment sharedObject]isActiveJob])
    {
        if([ClientAssignment sharedObject].pushClientID==PushClientIdJobDone)
        {
            [self call_feedBackVC];
        }
    }

//    [[HomeVC sharedObject]pushRecived];
}

-(void)showDriverViewMethod{
    
    driverViewShowed=@"Yes";
    self.cardDetail.hidden=YES;
    self.ShowDrivrView=[[UIView alloc] init ];
//                        WithFrame:CGRectMake(20,50, 280, self.view.frame.size.height-100)];
    self.ShowDrivrView.backgroundColor=[UIColor blackColor];
    [self.mapUser addSubview:self.ShowDrivrView];
    
    self.DrivrImgview=[[UIImageView alloc] init ];
    NSURL *url=    [[NSUserDefaults standardUserDefaults]objectForKey:@"url"];
    [self.DrivrImgview setImageWithURL:url placeholderImage:[UIImage imageNamed:@"profile.png"] options:1] ;
    [self.DrivrImgview.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [self.DrivrImgview.layer setBorderWidth: 2.0];
        [self.DrivrImgview.layer setCornerRadius: 5.0];
    [self.ShowDrivrView addSubview:self.DrivrImgview];
    
    UILabel *driverNmeLbl=[[UILabel alloc]initWithFrame:CGRectMake(105, 78, 150, 30) ];
    driverNmeLbl.text=driverInfo.name;
    driverNmeLbl.backgroundColor=[UIColor clearColor];
    driverNmeLbl.textColor=[UIColor whiteColor];
    driverNmeLbl.font=[UIFont fontWithName:nil size:27];
    [self.ShowDrivrView addSubview:driverNmeLbl];
    
    UIImageView *starimg=[[UIImageView alloc] init ];
//                          WithFrame:CGRectMake(65, 115, 160, 20)];
    starimg.image=[UIImage imageNamed:[NSString stringWithFormat:@"rating_%@.png",driverInfo.rating]];

    [self.ShowDrivrView addSubview:starimg];
    
    
    UILabel *declarLabel=[[UILabel alloc] init ];
//WithFrame:CGRectMake(40, 150, 200, 60)];
    declarLabel.backgroundColor=[UIColor clearColor];
    declarLabel.text=@"Your conceirege should \n     meet you in min";
    declarLabel.lineBreakMode=NSLineBreakByCharWrapping;
    declarLabel.numberOfLines=0;
    declarLabel.font=[UIFont fontWithName:nil size:27];
    declarLabel.textColor=[UIColor whiteColor];
    [self.ShowDrivrView addSubview:declarLabel];
    [declarLabel sizeToFit];
    
    UILabel *timeLabel=[[UILabel alloc] init ];
//WithFrame:CGRectMake(110, 190, 200, 40)];
    timeLabel.backgroundColor=[UIColor clearColor];
    timeLabel.font=[UIFont fontWithName:nil size:27];
    timeLabel.textColor=[UIColor whiteColor];
    timeLabel.text=[self getTimeDiffrent:[ClientAssignment sharedObject].dateETAClient];
    [self.ShowDrivrView addSubview:timeLabel];
    
    UIButton *rightClkOkBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightClkOkBtn setImage:[UIImage imageNamed:@"rightChecked.png"] forState:UIControlStateNormal];
    [rightClkOkBtn addTarget:self action:@selector(rightClkOkBtnEvent:) forControlEvents:UIControlEventTouchUpInside ];
    [self.ShowDrivrView addSubview:rightClkOkBtn];
    NSLog(@"self.view.bounds.size.height %f",self.view.frame.size.height);
    
    if ([UIScreen mainScreen].nativeScale == 2.0f){
        if (self.view.frame.size.height>568.0f) {
            NSLog(@"in iPhone6");
            
            self.ShowDrivrView.frame=CGRectMake(20,50, 340, self.view.frame.size.height-100);
            self.DrivrImgview.frame=CGRectMake(105, 35, 100, 100);
            driverNmeLbl.frame=CGRectMake(105, 145, 150, 30);
            declarLabel.frame=CGRectMake(30, 190, 300, 200);
            timeLabel.frame=CGRectMake(110, 340, 200, 40);
            rightClkOkBtn.frame=CGRectMake(30, 410, self.view.frame.size.width-100, 40);
            starimg.frame=CGRectMake(55, 190, 200, 20);
//             starimg.image=[UIImage imageNamed:@"rating_2.png"];
        }
        else if ( self.view.bounds.size.height==518.0f) {
            NSLog(@"in iPhone5");
            
                //            self.imageView.frame = CGRectMake(105, self.view.frame.size.height-500,80, 80);
            declarLabel.font=[UIFont fontWithName:nil size:18];
            self.ShowDrivrView.frame=CGRectMake(20,50, 280, self.view.frame.size.height-100);
            self.DrivrImgview.frame=CGRectMake(105, 25, 70, 70);
            driverNmeLbl.frame=CGRectMake(85, 105, 150, 30);
            declarLabel.frame=CGRectMake(40, 120, 250, 200);
            timeLabel.frame=CGRectMake(80, 250, 200, 40);
            rightClkOkBtn.frame=CGRectMake(30, 310, self.view.frame.size.width-100, 40);
            starimg.frame=CGRectMake(65, 160, 160, 20);
//             starimg.image=[UIImage imageNamed:@"rating_2.png"];
        }
        else{
            NSLog(@"in iPhone4 ");
             declarLabel.font=[UIFont fontWithName:nil size:18];
            self.ShowDrivrView.frame=CGRectMake(20,50, 280, self.view.frame.size.height-100);
            self.DrivrImgview.frame=CGRectMake(105, 5, 70, 70);
            driverNmeLbl.frame=CGRectMake(85, 78, 150, 30);
            declarLabel.frame=CGRectMake(40, 90, 200, 200);
            timeLabel.frame=CGRectMake(80, 220, 200, 40);
            starimg.frame=CGRectMake(60, 115, 160, 20);
//             starimg.image=[UIImage imageNamed:@"rating_2.png"];
            rightClkOkBtn.frame=CGRectMake(30, 260, self.view.frame.size.width-100, 40);
        }
    }
    else if ([UIScreen mainScreen].scale > 2.1f)
    {
        NSLog(@"in iPhone 6 plus");
        self.ShowDrivrView.frame=CGRectMake(35,50,355, self.view.frame.size.height-100);
        self.DrivrImgview.frame=CGRectMake(135, 25, 100, 100);
        driverNmeLbl.frame=CGRectMake(105, 158, 150, 30);
        starimg.frame=CGRectMake(85, 200, 160, 20);
        declarLabel.frame=CGRectMake(40, 230, 290, 200);
        timeLabel.frame=CGRectMake(130, 400, 200, 40);
        rightClkOkBtn.frame=CGRectMake(30, 470, self.view.frame.size.width-100, 40);
//        starimg.image=[UIImage imageNamed:@"rating_2.png"];
        

    }
    else
    {
        
        declarLabel.font=[UIFont fontWithName:nil size:18];
        self.ShowDrivrView.frame=CGRectMake(20,50, 280, self.view.frame.size.height-100);
        self.DrivrImgview.frame=CGRectMake(105, 5, 70, 70);
        driverNmeLbl.frame=CGRectMake(85, 78, 150, 30);
        declarLabel.frame=CGRectMake(40, 90, 200, 200);
        timeLabel.frame=CGRectMake(80, 220, 200, 40);
        starimg.frame=CGRectMake(60, 115, 160, 20);
//        starimg.image=[UIImage imageNamed:@"rating_2.png"];
        rightClkOkBtn.frame=CGRectMake(30, 260, self.view.frame.size.width-100, 40);
    }


}




    //========================================

-(void)showPushDriverViewMethod{
    
    driverViewShowed=@"Yes";
    self.cardDetail.hidden=YES;
    self.ShowDrivrView=[[UIView alloc] init ];
        //                        WithFrame:CGRectMake(20,50, 280, self.view.frame.size.height-100)];
    self.ShowDrivrView.backgroundColor=[UIColor blackColor];
    [self.mapUser addSubview:self.ShowDrivrView];
    
    self.DrivrImgview=[[UIImageView alloc] init ];
    NSURL *url=    [[NSUserDefaults standardUserDefaults]objectForKey:@"url"];
    [self.DrivrImgview setImageWithURL:url placeholderImage:[UIImage imageNamed:@"profile.png"] options:1] ;
    [self.DrivrImgview.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.DrivrImgview.layer setBorderWidth: 2.0];
    [self.DrivrImgview.layer setCornerRadius: 5.0];
    [self.ShowDrivrView addSubview:self.DrivrImgview];
    
    UILabel *driverNmeLbl=[[UILabel alloc]initWithFrame:CGRectMake(105, 78, 150, 30) ];
        //                           WithFrame:CGRectMake(105, 78, 150, 30)];
    driverNmeLbl.text=driverInfo.name;
    driverNmeLbl.backgroundColor=[UIColor clearColor];
    driverNmeLbl.textColor=[UIColor whiteColor];
    driverNmeLbl.font=[UIFont fontWithName:nil size:27];
    [self.ShowDrivrView addSubview:driverNmeLbl];
    
    UIImageView *starimg=[[UIImageView alloc] init ];
        //                          WithFrame:CGRectMake(65, 115, 160, 20)];
    starimg.image=[UIImage imageNamed:[NSString stringWithFormat:@"rating_%@.png",driverInfo.rating]];
    
    [self.ShowDrivrView addSubview:starimg];
    
    
    UILabel *declarLabel=[[UILabel alloc] init ];
        //WithFrame:CGRectMake(40, 150, 200, 60)];
    declarLabel.backgroundColor=[UIColor clearColor];
    declarLabel.text=@"Your conceirege should \n     meet you in min";
    declarLabel.lineBreakMode=NSLineBreakByCharWrapping;
    declarLabel.numberOfLines=0;
    declarLabel.font=[UIFont fontWithName:nil size:27];
    declarLabel.textColor=[UIColor whiteColor];
    [self.ShowDrivrView addSubview:declarLabel];
    [declarLabel sizeToFit];
    
    UILabel *timeLabel=[[UILabel alloc] init ];
        //WithFrame:CGRectMake(110, 190, 200, 40)];
    timeLabel.backgroundColor=[UIColor clearColor];
    timeLabel.font=[UIFont fontWithName:nil size:27];
    timeLabel.textColor=[UIColor whiteColor];
    timeLabel.text=[self getTimeDiffrent:[ClientAssignment sharedObject].dateETAClient];
    [self.ShowDrivrView addSubview:timeLabel];
    
    UIButton *rightClkOkBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightClkOkBtn setImage:[UIImage imageNamed:@"rightChecked.png"] forState:UIControlStateNormal];
    [rightClkOkBtn addTarget:self action:@selector(rightClkonOkBtnEvent:) forControlEvents:UIControlEventTouchUpInside ];
    [self.ShowDrivrView addSubview:rightClkOkBtn];
    NSLog(@"self.view.bounds.size.height %f",self.view.frame.size.height);
    
    if ([UIScreen mainScreen].nativeScale == 2.0f){
        if (self.view.frame.size.height>568.0f) {
            NSLog(@"in iPhone6");
            
            self.ShowDrivrView.frame=CGRectMake(20,50, 340, self.view.frame.size.height-100);
            self.DrivrImgview.frame=CGRectMake(105, 35, 100, 100);
            driverNmeLbl.frame=CGRectMake(105, 145, 150, 30);
            declarLabel.frame=CGRectMake(30, 190, 300, 200);
            timeLabel.frame=CGRectMake(110, 340, 200, 40);
            rightClkOkBtn.frame=CGRectMake(30, 410, self.view.frame.size.width-100, 40);
            starimg.frame=CGRectMake(55, 190, 200, 20);
                //             starimg.image=[UIImage imageNamed:@"rating_2.png"];
        }
        else if ( self.view.bounds.size.height==518.0f) {
            NSLog(@"in iPhone5");
            
                //            self.imageView.frame = CGRectMake(105, self.view.frame.size.height-500,80, 80);
            declarLabel.font=[UIFont fontWithName:nil size:18];
            self.ShowDrivrView.frame=CGRectMake(20,50, 280, self.view.frame.size.height-100);
            self.DrivrImgview.frame=CGRectMake(105, 25, 70, 70);
            driverNmeLbl.frame=CGRectMake(85, 105, 150, 30);
            declarLabel.frame=CGRectMake(40, 120, 250, 200);
            timeLabel.frame=CGRectMake(80, 250, 200, 40);
            rightClkOkBtn.frame=CGRectMake(30, 310, self.view.frame.size.width-100, 40);
            starimg.frame=CGRectMake(65, 160, 160, 20);
                //             starimg.image=[UIImage imageNamed:@"rating_2.png"];
        }
        else{
            NSLog(@"in iPhone4 ");
            declarLabel.font=[UIFont fontWithName:nil size:18];
            self.ShowDrivrView.frame=CGRectMake(20,50, 280, self.view.frame.size.height-100);
            self.DrivrImgview.frame=CGRectMake(105, 5, 70, 70);
            driverNmeLbl.frame=CGRectMake(85, 78, 150, 30);
            declarLabel.frame=CGRectMake(40, 90, 200, 200);
            timeLabel.frame=CGRectMake(80, 220, 200, 40);
            starimg.frame=CGRectMake(60, 115, 160, 20);
                //             starimg.image=[UIImage imageNamed:@"rating_2.png"];
            rightClkOkBtn.frame=CGRectMake(30, 260, self.view.frame.size.width-100, 40);
        }
    }
    else if ([UIScreen mainScreen].scale > 2.1f)
    {
        NSLog(@"in iPhone 6 plus");
        self.ShowDrivrView.frame=CGRectMake(35,50,355, self.view.frame.size.height-100);
        self.DrivrImgview.frame=CGRectMake(135, 25, 100, 100);
        driverNmeLbl.frame=CGRectMake(105, 158, 150, 30);
        starimg.frame=CGRectMake(85, 200, 160, 20);
        declarLabel.frame=CGRectMake(40, 230, 290, 200);
        timeLabel.frame=CGRectMake(130, 400, 200, 40);
        rightClkOkBtn.frame=CGRectMake(30, 470, self.view.frame.size.width-100, 40);
            //        starimg.image=[UIImage imageNamed:@"rating_2.png"];
        
        
    }
    else
    {
        
        declarLabel.font=[UIFont fontWithName:nil size:18];
        self.ShowDrivrView.frame=CGRectMake(20,50, 280, self.view.frame.size.height-100);
        self.DrivrImgview.frame=CGRectMake(105, 5, 70, 70);
        driverNmeLbl.frame=CGRectMake(85, 78, 150, 30);
        declarLabel.frame=CGRectMake(40, 90, 200, 200);
        timeLabel.frame=CGRectMake(80, 220, 200, 40);
        starimg.frame=CGRectMake(60, 115, 160, 20);
            //        starimg.image=[UIImage imageNamed:@"rating_2.png"];
        rightClkOkBtn.frame=CGRectMake(30, 260, self.view.frame.size.width-100, 40);
    }
    
    
}


-(void)rightClkonOkBtnEvent:(UIButton *)button{

    if (timer)
    {
        [timer invalidate];
        timer=nil;
    }
    [self showDriverReachtime];
    
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime:) userInfo:nil repeats:YES];
    
    
    timerDriverLocation=[NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(getDriverLocation:) userInfo:nil repeats:YES];

}


#pragma mark-  
#pragma mark - Extra Service Click
-(void)extraSrviceButton:(UIButton *)button{
    self.cardDetail.hidden=YES;
    if (!self.extraService) {
        
        self.extraService=[[UIView alloc] init];
//                       WithFrame:CGRectMake(20,50, 280, self.view.frame.size.height-100)];
    self.extraService.backgroundColor=[UIColor blackColor];
    [self.mapUser addSubview:self.extraService];
    
        UILabel *xtraSrvicLbl=[[UILabel alloc] init];
//                           WithFrame:CGRectMake(65, 5, 200, 40)];
    xtraSrvicLbl.backgroundColor=[UIColor clearColor];
    xtraSrvicLbl.textColor=[UIColor colorWithRed:194.0/255.0 green:58.0/255.0 blue:58.0/255.0 alpha:1.0];
    xtraSrvicLbl.font=[UIFont fontWithName:nil size:15.0];
    xtraSrvicLbl.text=@"Add Extra Services ";
    xtraSrvicLbl.font=[UIFont fontWithName:nil size:20.0];
    [self.extraService addSubview:xtraSrvicLbl];
    
    
        UILabel *washMyCarLbl=[[UILabel alloc] init];
//                           WithFrame:CGRectMake(20, 80, 200, 40)];
    washMyCarLbl.backgroundColor=[UIColor clearColor];
    washMyCarLbl.textColor=[UIColor whiteColor];
    washMyCarLbl.text=@"Wash My Car ";
    [self.extraService addSubview:washMyCarLbl];
    
    
        UILabel *fueltopUpLbl=[[UILabel alloc] init ];
//    WithFrame:CGRectMake(20, 150, 200, 40)];
    fueltopUpLbl.backgroundColor=[UIColor clearColor];
    fueltopUpLbl.textColor=[UIColor whiteColor];
    fueltopUpLbl.text=@"Fuel Top Up ";
    [self.extraService addSubview:fueltopUpLbl];
    
    washCarChekBox=[UIButton buttonWithType:UIButtonTypeCustom];
        if ([carWasing isEqualToString:@"yes"]) {
            [washCarChekBox setImage:[UIImage imageNamed:@"checkbox_mark.png"] forState:UIControlStateNormal];
        }else{
          [washCarChekBox setImage:[UIImage imageNamed:@"checkbox_empty.png"] forState:UIControlStateNormal];
        }
      
    washCarChekBox.selected=NO;
    [washCarChekBox addTarget:self action:@selector(carWashing:) forControlEvents:UIControlEventTouchUpInside ];
    [self.extraService addSubview:washCarChekBox];
    
    
    fueltopChekBox=[UIButton buttonWithType:UIButtonTypeCustom];
        if ([fuelTopup isEqualToString:@"yes"]) {
             [fueltopChekBox setImage:[UIImage imageNamed:@"checkbox_mark.png"] forState:UIControlStateNormal];
            fueltopChekBox.selected=YES;
        }else{

    [fueltopChekBox setImage:[UIImage imageNamed:@"checkbox_empty.png"] forState:UIControlStateNormal];
    fueltopChekBox.selected=NO;
    }
    [fueltopChekBox addTarget:self action:@selector(fuelTopUp:) forControlEvents:UIControlEventTouchUpInside ];
    [self.extraService addSubview:fueltopChekBox];
    
    UIButton *rightClkedBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
      [rightClkedBtn setImage:[UIImage imageNamed:@"rightChecked.png"] forState:UIControlStateNormal];
    [rightClkedBtn addTarget:self action:@selector(rightClkXtraSrvicBtn:) forControlEvents:UIControlEventTouchUpInside ];
    [self.extraService addSubview:rightClkedBtn];

        if ([UIScreen mainScreen].nativeScale == 2.0f){
            if (self.view.frame.size.height>568.0f) {
                NSLog(@"in iPhone 6");
                xtraSrvicLbl.font=[UIFont fontWithName:nil size:30.0];
                self.extraService.frame=CGRectMake(20,50, 320, self.view.frame.size.height-100);
                xtraSrvicLbl.frame=CGRectMake(30, 15, 300, 40);
                fueltopUpLbl.frame=CGRectMake(45, 250, 200, 40);
                fueltopUpLbl.font=[UIFont fontWithName:nil size:25.0];
                washMyCarLbl.font=[UIFont fontWithName:nil size:25.0];
                washMyCarLbl.frame=CGRectMake(45, 140, 200, 40);
                rightClkedBtn.frame=CGRectMake(30, 380, self.view.frame.size.width-100, 40);
                washCarChekBox.frame=CGRectMake(240, 140, 40, 40);
                fueltopChekBox.frame=CGRectMake(240, 250, 40, 40);

                
            }
            else if ( self.view.bounds.size.height==518.0f) {
                NSLog(@"in iPhone 5");
                self.extraService.frame=CGRectMake(20,50, 280, self.view.frame.size.height-100);
                xtraSrvicLbl.frame=CGRectMake(65, 5, 200, 40);
                   [rightClkedBtn setImage:[UIImage imageNamed:@"rightChecked.png"] forState:UIControlStateNormal];
                fueltopUpLbl.frame=CGRectMake(20, 170, 200, 40);
                washMyCarLbl.frame=CGRectMake(20, 80, 200, 40);
                rightClkedBtn.frame=CGRectMake(30, 310, self.view.frame.size.width-100, 40);
                washCarChekBox.frame=CGRectMake(200, 80, 40, 40);
                fueltopChekBox.frame=CGRectMake(200, 170, 40, 40);


            }
            else{
                NSLog(@"in iPhone 4");
                self.extraService.frame=CGRectMake(20,50, 280, self.view.frame.size.height-100);
                xtraSrvicLbl.frame=CGRectMake(65, 5, 200, 40);
                fueltopUpLbl.frame=CGRectMake(20, 150, 200, 40);
                washMyCarLbl.frame=CGRectMake(20, 80, 200, 40);
                rightClkedBtn.frame=CGRectMake(30, 240, self.view.frame.size.width-100, 40);
                washCarChekBox.frame=CGRectMake(200, 80, 40, 40);
                fueltopChekBox.frame=CGRectMake(200, 150, 40, 40);

            }
            
        }
        else if ([UIScreen mainScreen].scale > 2.1f)
        {
            NSLog(@"in iPhone 6 plus");
            self.extraService.frame=CGRectMake(20,50, 280, self.view.frame.size.height-100);
            xtraSrvicLbl.frame=CGRectMake(65, 5, 200, 40);
            fueltopUpLbl.frame=CGRectMake(20, 150, 200, 40);
            washMyCarLbl.frame=CGRectMake(20, 80, 200, 40);
            rightClkedBtn.frame=CGRectMake(30, 240, self.view.frame.size.width-100, 40);
            washCarChekBox.frame=CGRectMake(200, 80, 40, 40);
            fueltopChekBox.frame=CGRectMake(200, 150, 40, 40);

            
        }
        else
        {
            NSLog(@"in iPhone4 ");
            self.extraService.frame=CGRectMake(20,50, 280, self.view.frame.size.height-100);
            xtraSrvicLbl.frame=CGRectMake(65, 5, 200, 40);
            fueltopUpLbl.frame=CGRectMake(20, 150, 200, 40);
            washMyCarLbl.frame=CGRectMake(20, 80, 200, 40);
            rightClkedBtn.frame=CGRectMake(30, 240, self.view.frame.size.width-100, 40);
            washCarChekBox.frame=CGRectMake(200, 80, 40, 40);
            fueltopChekBox.frame=CGRectMake(200, 150, 40, 40);

        }
        
        
        
        
    }else{
        self.extraService.hidden=NO;
    
    }
}


-(void)carWashing:(UIButton *)button{
    if ([carWasing isEqualToString:@"no"]) {
        totalCharges=totalCharges+20;
        [button setImage:[UIImage imageNamed:@"checkbox_mark.png"] forState:UIControlStateNormal];
        carWasing=@"yes";
                   //        button.selected=YES;
    }else{
           totalCharges=totalCharges-20;
        [button setImage:[UIImage imageNamed:@"checkbox_empty.png"] forState:UIControlStateNormal];
        carWasing=@"no";
    }
    if (TotalLbl) {
        TotalLbl.text=[NSString stringWithFormat:@"Total  Charges             %d$",totalCharges];
    }


}


-(void)fuelTopUp:(UIButton *)button{
    
    if ([fuelTopup isEqualToString:@"no"]) {
          fuelTopup=@"yes";
           totalCharges=totalCharges+20;
          [button setImage:[UIImage imageNamed:@"checkbox_mark.png"] forState:UIControlStateNormal];
    }
    else{
           totalCharges=totalCharges-20;
        [button setImage:[UIImage imageNamed:@"checkbox_empty.png"] forState:UIControlStateNormal];
        fuelTopup=@"no";
    }
    if (TotalLbl) {
        TotalLbl.text=[NSString stringWithFormat:@"Total  Charges             %d$",totalCharges];
    }
    
}

-(void)rightClkXtraSrvicBtn:(UIButton *)button{

    self.extraService.hidden=YES;
    self.cardDetail.hidden=NO;
}


-(void)rightClkOkBtnEvent:(UIButton *)button{
    self.ShowDrivrView.hidden=YES;
    self.ShowDrivrView=nil;
//  [self getClientPush];
    [self showDriverReachtime];
    
   }

-(void)showDriverReachtime{
    
    self.ShowDrivrView.hidden=YES;
    self.ShowDrivrView=nil;
    self.showDrivrRichTimeLbl=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50,self.view.frame.size.width,50)];
    self.showDrivrRichTimeLbl.backgroundColor=[UIColor blackColor];
    [self.view addSubview:self.showDrivrRichTimeLbl];
    
    
    UIImageView *drvrImgview=[[RoundedImageView alloc] initWithFrame:CGRectMake(25, -15, 60, 60)];
    drvrImgview.image=[UIImage imageNamed:@"reglog.png"];
    NSURL *url=    [[NSUserDefaults standardUserDefaults]objectForKey:@"url"];
    [drvrImgview setImageWithURL:url placeholderImage:[UIImage imageNamed:@"profile.png"] options:1] ;
    [drvrImgview.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [drvrImgview.layer setBorderWidth: 2.0];
   [drvrImgview.layer setCornerRadius: 15.0];
    [self.showDrivrRichTimeLbl addSubview:drvrImgview];
    
        //    self.DrivrImgview.frame=;
    
    UILabel *nameLbl=[[UILabel alloc] initWithFrame:CGRectMake(95,2 , 155, 50)];
    nameLbl.lineBreakMode=NSLineBreakByCharWrapping;
    nameLbl.numberOfLines=0;
    nameLbl.font=[UIFont fontWithName:nil size:14.0];
    nameLbl.text=[NSString stringWithFormat:@"%@\n reaches you in ",driverInfo.name ];
    nameLbl.backgroundColor=[UIColor clearColor];
    nameLbl.textColor=[UIColor whiteColor];
    [self.showDrivrRichTimeLbl addSubview:nameLbl];
    [nameLbl sizeToFit];
    
    
//    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    timeCount=5;
    
    self.timrlbl=[[UILabel alloc] initWithFrame:CGRectMake(217,3 , 105, 50)];
//    self.timrlbl.text=[NSString stringWithFormat:@" %d min ",timeCount];
    self.timrlbl.backgroundColor=[UIColor clearColor];
    self.timrlbl.textColor=[UIColor whiteColor];
    [self.showDrivrRichTimeLbl addSubview:self.timrlbl];
    
    
    UIButton *cancelDriver=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelDriver addTarget:self action:@selector(cancelDriver:) forControlEvents:UIControlEventTouchUpInside];
//    [cancelDriver setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelDriver setImage:[UIImage imageNamed:@"closed.png"] forState:UIControlStateNormal];
    cancelDriver.frame=CGRectMake(270, 0 ,100 ,50);
    [self.showDrivrRichTimeLbl addSubview:cancelDriver];


}

-(void)updateDropOffLabel{
//    timeCount--;
//    self.timrlbl.text=[NSString stringWithFormat:@" %d min ",timeCount];
    
//    if (timeCount==0) {
        self.showDrivrRichTimeLbl.hidden=YES;
        self.showDrivrRichTimeLbl=nil;
        [self.timer invalidate];
        self.timer=nil;
        
        
        self.dropOffButton=[[UIButton alloc] init];
        [self.dropOffButton setFrame:CGRectMake(0, self.mapUser.frame.size.height-50, 320, 50)];
        self.dropOffButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"reglog.png"]];  
        self.dropOffButton.titleLabel.frame=CGRectMake(190, self.view.frame.size.height-50, 320, 50);
        [self.dropOffButton setTitle:@"Drop Off" forState:UIControlStateNormal];
        [self.dropOffButton addTarget:self action:@selector(dropOffReqBtnClk:) forControlEvents:UIControlEventTouchUpInside];
        [self.mapUser addSubview:self.dropOffButton];
//    }

}

-(void)cancelDriver:(UIButton *)button{
    self.showDrivrRichTimeLbl.hidden=YES;

}
#pragma mark -
#pragma mark Drop Off Request


-(void)dropOffReqBtnClk:(UIButton *)button{
    
  pickUpTime=[NSDate date ];
    
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:[User currentUser].client_id forKey:PARAM_CLIENT_ID];
//    if ([ClientAssignment sharedObject].random_id!=nil) {
        [dictParam setObject:driverInfo.user_id forKey:@"driver_id"];
//    }
    [dictParam setObject:[[UserDefaultHelper sharedObject] currentLatitude] forKey:PARAM_LATTITUDE];
    [dictParam setObject:[[UserDefaultHelper sharedObject] currentLongitude] forKey:PARAM_LOGITUDE];
    
    
    [[mainAppDelegate sharedAppDelegate]showHUDLoadingView:@""];
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
    [afn getDataFromPath:FILE_CLIENT_DROP_OFF withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         [[mainAppDelegate sharedAppDelegate]hideHUDLoadingView];
         if (response)
         {
//             NSMutableDictionary *dict=[response objectForKey:@"aps"];
//             [self showDriverReachtime];
         }
     }];
    

//    [self dropOffRequestCall];
    
}


-(void) showRouteFrom: (Place*) pickUp
{
    [self.mapUser removeAnnotations:[self.mapUser annotations]];
	PlaceMark* markPickUp = [[PlaceMark alloc] initWithPlace:pickUp];
	[self.mapUser addAnnotation:markPickUp];
	[self centerMap:pickUp];
}

#pragma mark - 
#pragma mark Driver Location and Information

-(void)getDriverInformation:(id)sender
{
    if (!isFeatchingDriverLocation)
    {
        isFeatchingDriverLocation=YES;
        
        NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
        [dictParam setObject:[ClientAssignment sharedObject].random_id forKey:PARAM_RANDOM_ID];
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:FILE_GET_DRIVER_LOCATION withParamData:dictParam withBlock:^(id response, NSError *error)
         {
             isFeatchingDriverLocation=NO;
             if (response)
             {
                 NSMutableDictionary *dictMain=[response objectForKey:WS_UBER_ALPHA];
                 
                 if ([[dictMain objectForKey:WS_STATUS]isEqualToString:WS_STATUS_SUCCESS])
                 {
                     [driverInfo setData:dictMain];
                     [self removeAllAnnotations];
                     
                     Place* home = [[Place alloc] init];
                     home.name = @"It's me";
                     home.description = @"";
                     home.latitude = [[[UserDefaultHelper sharedObject] currentLatitude] doubleValue];
                     home.longitude = [[[UserDefaultHelper sharedObject] currentLongitude] doubleValue];
                     home.isFrom=YES;
                     
                     PlaceMark* markPickUp = [[PlaceMark alloc] initWithPlace:home];
                     [self.mapUser addAnnotation:markPickUp];
                     
                     Place *driver=[[Place alloc]init];
                     driver.name = driverInfo.name;
                     driver.description = driverInfo.contact;
                     driver.latitude = [driverInfo.lattitude doubleValue];
                     driver.longitude = [driverInfo.logitude doubleValue];
                     
                     driver.isFrom=NO;
                     
                     
                     PlaceMark* markDriver = [[PlaceMark alloc] initWithPlace:driver];
                     [self.mapUser addAnnotation:markDriver];

                     
                     NSArray * routes = [self calculateRoutesFrom:markPickUp.coordinate to:markDriver.coordinate];
                     int ro=(int)routes.count;
                     
                     
                     CLLocationCoordinate2D coordinates[ro];
                     for (int i = 0; i < routes.count; i++)
                     {
                         CLLocation *location=routes[i];
                         
                         coordinates[i] = [location coordinate];
                         
                         
                     }
                     MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coordinates count:ro];
                     [self.mapUser addOverlay:polyline];
                     
                         //    [self.mapUser addOverlays:polyLinesArray];
                     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                     
                   
                 }
             }
         }];
    }
}


-(void)getDriverLocation:(id)sender
{
    if (!isFeatchingDriverLocation)
    {
        isFeatchingDriverLocation=YES;
        if ([ClientAssignment sharedObject].random_id!=nil) {
           
        NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
        [dictParam setObject:[ClientAssignment sharedObject].random_id forKey:PARAM_RANDOM_ID];
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:FILE_GET_DRIVER_LOCATION withParamData:dictParam withBlock:^(id response, NSError *error)
         {
             isFeatchingDriverLocation=NO;
             if (response)
             {
                 NSMutableDictionary *dictMain=[response objectForKey:WS_UBER_ALPHA];
                 
                 if ([[dictMain objectForKey:WS_STATUS]isEqualToString:WS_STATUS_SUCCESS])
                 {
                     [driverInfo setData:dictMain];
                     [self removeAllAnnotations];
                     
                     Place* home = [[Place alloc] init];
                     home.name = @"It's me";
                     home.description = @"";
                     home.latitude = [[[UserDefaultHelper sharedObject] currentLatitude] doubleValue];
                     home.longitude = [[[UserDefaultHelper sharedObject] currentLongitude] doubleValue];
                    
                     
                     home.isFrom=YES;
                     
                     PlaceMark* markPickUp = [[PlaceMark alloc] initWithPlace:home];
                     [self.mapUser addAnnotation:markPickUp];
                     
                     Place *driver=[[Place alloc]init];
                     driver.name = driverInfo.name;
                     driver.description = driverInfo.contact;
                     driver.latitude = [driverInfo.lattitude doubleValue];
                     driver.longitude = [driverInfo.logitude doubleValue];
                     driver.isFrom=NO;
                     
                     
            PlaceMark* markDriver = [[PlaceMark alloc] initWithPlace:driver];
                     [self.mapUser addAnnotation:markDriver];
                  NSArray * routes = [self calculateRoutesFrom:markPickUp.coordinate to:markDriver.coordinate];
                     int ro=(int)routes.count;
                
                     
                     CLLocationCoordinate2D coordinates[ro];
                     for (int i = 0; i < routes.count; i++)
                     {
                         CLLocation *location=routes[i];
                         
                         coordinates[i] = [location coordinate];
                         
                         
                     }
                     MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coordinates count:ro];
                     [self.mapUser addOverlay:polyline];
                     
                         //    [self.mapUser addOverlays:polyLinesArray];
                     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                     

                     
                     
                     
                 }
             }
         }];}
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay{
    
    MKPolylineView *overlayView = [[MKPolylineView alloc] initWithOverlay:overlay];
    overlayView.lineWidth =5;
    overlayView.strokeColor = [UIColor redColor];
    overlayView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.1f];
    return overlayView;
    
    
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


#pragma mark -
#pragma mark FeedBack Service and UI

-(void)call_feedBackVC{
    dropOffTime=[NSDate date];
    self.dropOffButton.hidden=YES;
    
    
    
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *componentsPickup = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:pickUpTime];
    
     NSDateComponents *componentsDropOff = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:dropOffTime];

    NSLog(@"com dropoff %@",componentsDropOff);
     NSLog(@"com pickup %@",componentsPickup);
    
    self.dropOffButton.hidden=YES;
    
    
    self.view.backgroundColor=[UIColor blackColor];
    
    
    self.feedBackVC=[[UIView alloc]init];
//initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height )];
    self.feedBackVC.backgroundColor=[UIColor colorWithRed:46.0/255.0 green:47.0/255.0 blue:46.0/255.0 alpha:1.0];
    [self.mapUser addSubview:self.feedBackVC];
    
    UIButton *doneBtn=[[UIButton alloc]init];
//initWithFrame:CGRectMake(270, 10, 50, 50)];
    [doneBtn addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    doneBtn.backgroundColor=[UIColor clearColor];
    [self.feedBackVC addSubview:doneBtn];
    
    
    UILabel *titleLbl=[[UILabel  alloc]init];
//                       initWithFrame:CGRectMake(10, -40, 300, 150)];
    titleLbl.backgroundColor=[UIColor clearColor];
    titleLbl.textColor=[UIColor colorWithRed:192.0/255.0 green:59.0/255.0 blue:60.0/255.0 alpha:1.0];
    titleLbl.font=[UIFont fontWithName:nil size:20.0];
    titleLbl.text=@"Parking Feedback";
    [self.feedBackVC addSubview:titleLbl];
    
    
    UILabel *pickupDetailLbl=[[UILabel  alloc]init];
//initWithFrame:CGRectMake(30, 70, 300, 150)];
    pickupDetailLbl.backgroundColor=[UIColor clearColor];
    pickupDetailLbl.textColor=[UIColor whiteColor];
    pickupDetailLbl.text=[NSString stringWithFormat:@"  Pick up   \n %@p                  ",[NSString stringWithFormat:@"%ld:%ld:%ld ",(long)componentsPickup.hour,(long)componentsPickup.minute,(long)componentsPickup.second]];
    pickupDetailLbl.numberOfLines=0;
    pickupDetailLbl.lineBreakMode=NSLineBreakByCharWrapping;
    [self.feedBackVC addSubview:pickupDetailLbl];
    [pickupDetailLbl sizeToFit];
    
    UILabel *dropOffdetailLbl=[[UILabel  alloc]init];
//initWithFrame:CGRectMake(200, 70, 300, 150)];
    dropOffdetailLbl.backgroundColor=[UIColor clearColor];
    dropOffdetailLbl.textColor=[UIColor whiteColor];
     dropOffdetailLbl.text=[NSString stringWithFormat:@"  Drop Off   \n  %@p                  ",[NSString stringWithFormat:@"%ld:%ld:%ld",(long)componentsDropOff.hour,(long)componentsDropOff.minute,(long)componentsDropOff.second]];
    dropOffdetailLbl.numberOfLines=0;
    dropOffdetailLbl.lineBreakMode=NSLineBreakByCharWrapping;
    [self.feedBackVC addSubview:dropOffdetailLbl];
    [dropOffdetailLbl sizeToFit];

    
    UILabel *priceLbl=[[UILabel  alloc]init];
//initWithFrame:CGRectMake(100, 165, 300, 150)];
    priceLbl.backgroundColor=[UIColor clearColor];
    priceLbl.textColor=[UIColor whiteColor];
    priceLbl.numberOfLines=0;
    priceLbl.lineBreakMode=NSLineBreakByCharWrapping;
    priceLbl.text=[NSString stringWithFormat:@"      %@ \n     flat \n Rate You  ",decimalNumber ];
    [self.feedBackVC addSubview:priceLbl];
    [priceLbl sizeToFit];
    
    
    UIImageView *drvrImgview=[[UIImageView alloc]init];
//initWithFrame:CGRectMake(115, 245, 60, 60)];
    NSURL *url=    [[NSUserDefaults standardUserDefaults]objectForKey:@"url"];
    [drvrImgview setImageWithURL:url placeholderImage:[UIImage imageNamed:@"profile.png"] options:1] ;
    [drvrImgview.layer setBorderColor:(__bridge CGColorRef)([UIColor whiteColor])];
    [drvrImgview.layer setBorderWidth:2.0];
    [drvrImgview.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [drvrImgview.layer setBorderWidth: 2.0];
    [drvrImgview.layer setCornerRadius: 15.0];
    [self.feedBackVC addSubview:drvrImgview];
    
    starRating=0;
    
    if ([UIScreen mainScreen].nativeScale == 2.0f){
        if (self.view.frame.size.height>568.0f) {
            NSLog(@"in iPhone6");
            self.feedBackVC.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height );
            doneBtn.frame=CGRectMake(300, 10, 50, 50);
            titleLbl.frame=CGRectMake(10, -40, 300, 150);
            pickupDetailLbl.frame=CGRectMake(30, 70, 300, 150);
            dropOffdetailLbl.frame=CGRectMake(255, 70, 300, 150);
            priceLbl.frame=CGRectMake(160, 205, 300, 150);
            drvrImgview.frame=CGRectMake(155, 380, 80, 80);
            for (int i=0; i<5; i++) {
                UIButton *ratingImg=[[UIButton alloc]init];
                ratingImg.frame=CGRectMake(125+30*i, 480, 20, 20);
                    //    initWithFrame:CGRectMake(80+30*i, 320, 20, 20)];
                ratingImg.tag=i;
                [ratingImg setImage:[UIImage imageNamed:@"single_empty.png"] forState:UIControlStateNormal];
                [ratingImg setImage:[UIImage imageNamed:@"single_fill.png"] forState:UIControlStateSelected];
                [ratingImg setImage:[UIImage imageNamed:@"single_fill.png"] forState:UIControlStateHighlighted];
                [ratingImg addTarget:self action:@selector(ratingButton:) forControlEvents:UIControlEventTouchUpInside];
                [self.feedBackVC addSubview:ratingImg];
            }

            
        }
        else if ( self.view.bounds.size.height==518.0f) {
            NSLog(@"in iPhone5");
             self.feedBackVC.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height );
            doneBtn.frame=CGRectMake(270, 10, 50, 50);
            titleLbl.frame=CGRectMake(10, -40, 300, 150);
            pickupDetailLbl.frame=CGRectMake(30, 70, 300, 150);
            dropOffdetailLbl.frame=CGRectMake(200, 70, 300, 150);
            priceLbl.frame=CGRectMake(100, 165, 300, 150);
            drvrImgview.frame=CGRectMake(115, 245, 60, 60);
            for (int i=0; i<5; i++) {
                UIButton *ratingImg=[[UIButton alloc]init];
                ratingImg.frame=CGRectMake(80+30*i, 360, 20, 20);
                    //    initWithFrame:CGRectMake(80+30*i, 320, 20, 20)];
                ratingImg.tag=i;
                [ratingImg setImage:[UIImage imageNamed:@"single_empty.png"] forState:UIControlStateNormal];
                [ratingImg setImage:[UIImage imageNamed:@"single_fill.png"] forState:UIControlStateSelected];
                [ratingImg setImage:[UIImage imageNamed:@"single_fill.png"] forState:UIControlStateHighlighted];
                [ratingImg addTarget:self action:@selector(ratingButton:) forControlEvents:UIControlEventTouchUpInside];
                [self.feedBackVC addSubview:ratingImg];
            }

            
  
        }
        else{
            NSLog(@"in iPhone4 ");
            
             self.feedBackVC.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height );
            doneBtn.frame=CGRectMake(270, 10, 50, 50);
            titleLbl.frame=CGRectMake(10, -40, 300, 150);
            pickupDetailLbl.frame=CGRectMake(30, 50, 300, 150);
            dropOffdetailLbl.frame=CGRectMake(200, 50, 300, 150);
            priceLbl.frame=CGRectMake(100, 125, 300, 150);
            drvrImgview.frame=CGRectMake(115, 245, 60, 60);
            for (int i=0; i<5; i++) {
                UIButton *ratingImg=[[UIButton alloc]init];
                ratingImg.frame=CGRectMake(80+30*i, 320, 20, 20);
                    //    initWithFrame:CGRectMake(80+30*i, 320, 20, 20)];
                ratingImg.tag=i;
                [ratingImg setImage:[UIImage imageNamed:@"single_empty.png"] forState:UIControlStateNormal];
                [ratingImg setImage:[UIImage imageNamed:@"single_fill.png"] forState:UIControlStateSelected];
                [ratingImg setImage:[UIImage imageNamed:@"single_fill.png"] forState:UIControlStateHighlighted];
                [ratingImg addTarget:self action:@selector(ratingButton:) forControlEvents:UIControlEventTouchUpInside];
                [self.feedBackVC addSubview:ratingImg];
            }


          }
    }
    else if ([UIScreen mainScreen].scale > 2.1f)
    {
        NSLog(@"in iPhone 6 plus");
         self.feedBackVC.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height );
        doneBtn.frame=CGRectMake(330, 10, 50, 50);
        titleLbl.frame=CGRectMake(10, -40, 300, 150);
        pickupDetailLbl.frame=CGRectMake(30, 70, 300, 150);
        dropOffdetailLbl.frame=CGRectMake(290, 70, 300, 150);
        priceLbl.frame=CGRectMake(170, 195, 300, 150);
        drvrImgview.frame=CGRectMake(165, 345, 90, 90);
        for (int i=0; i<5; i++) {
            UIButton *ratingImg=[[UIButton alloc]init];
            ratingImg.frame=CGRectMake(140+30*i, 500, 20, 20);
                //    initWithFrame:CGRectMake(80+30*i, 320, 20, 20)];
            ratingImg.tag=i;
            [ratingImg setImage:[UIImage imageNamed:@"single_empty.png"] forState:UIControlStateNormal];
            [ratingImg setImage:[UIImage imageNamed:@"single_fill.png"] forState:UIControlStateSelected];
            [ratingImg setImage:[UIImage imageNamed:@"single_fill.png"] forState:UIControlStateHighlighted];
            [ratingImg addTarget:self action:@selector(ratingButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.feedBackVC addSubview:ratingImg];
        }

        
        
    }
    else
    {
        NSLog(@"in iPad");
     self.feedBackVC.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height );
        doneBtn.frame=CGRectMake(270, 10, 50, 50);
        titleLbl.frame=CGRectMake(10, -40, 300, 150);
        pickupDetailLbl.frame=CGRectMake(30, 50, 300, 150);
        dropOffdetailLbl.frame=CGRectMake(200, 50, 300, 150);
        priceLbl.frame=CGRectMake(100, 120, 300, 150);
        drvrImgview.frame=CGRectMake(115, 245, 60, 60);
        for (int i=0; i<5; i++) {
            UIButton *ratingImg=[[UIButton alloc]init];
            ratingImg.frame=CGRectMake(80+30*i, 320, 20, 20);
                //    initWithFrame:CGRectMake(80+30*i, 320, 20, 20)];
            ratingImg.tag=i;
            [ratingImg setImage:[UIImage imageNamed:@"single_empty.png"] forState:UIControlStateNormal];
            [ratingImg setImage:[UIImage imageNamed:@"single_fill.png"] forState:UIControlStateSelected];
            [ratingImg setImage:[UIImage imageNamed:@"single_fill.png"] forState:UIControlStateHighlighted];
            [ratingImg addTarget:self action:@selector(ratingButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.feedBackVC addSubview:ratingImg];
        }


    }
    

    
    
    
}


-(void)doneButton:(UIButton *)button{

    self.feedBackVC.hidden=YES;
    
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:[ClientAssignment sharedObject].random_id forKey:PARAM_RANDOM_ID];
    [dictParam setObject:[NSString stringWithFormat:@"%d",rateCount] forKey:PARAM_RATING];
    
    [[mainAppDelegate sharedAppDelegate]showHUDLoadingView:@""];
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
    [afn getDataFromPath:FILE_RATE_TRIP withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         [[mainAppDelegate sharedAppDelegate]hideHUDLoadingView];
         if (response)
         {
             NSDictionary *dictUber=[response objectForKey:WS_UBER_ALPHA];
             [[mainAppDelegate sharedAppDelegate]showToastMessage:[dictUber objectForKey:WS_MESSAGE]];
             if ([[dictUber objectForKey:WS_STATUS]isEqualToString:WS_STATUS_SUCCESS]) {
                [[ClientAssignment sharedObject]removeAllData];
                [timerDriverLocation invalidate];
                 timerDriverLocation=nil;

                 
             }
         }
     }];

   }

-(void)ratingButton:(UIButton *)button{
    if (button.selected==YES) {
        rateCount--;
        [button setImage:[UIImage imageNamed:@"single_empty.png"] forState:UIControlStateNormal];
        
    }else{
        if (rateCount>=button.tag) {
            [button setImage:[UIImage imageNamed:@"single_fill.png"] forState:UIControlStateNormal];
            
            rateCount++;
        }
        
           }
}


#pragma mark-
#pragma mark MapView Delegate

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

-(void)removeAllAnnotations
{
    [self.mapUser removeAnnotations:[self.mapUser annotations]];
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
