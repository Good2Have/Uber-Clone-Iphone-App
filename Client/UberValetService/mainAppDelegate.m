//
//  mainAppDelegate.m
//  UberValetService
//
//  Created by Globussoft 1 on 10/21/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import "mainAppDelegate.h"
#import "PayPalMobile.h"
#import "MBProgressHUD.h"
#import "HomeVC.h"
#import "AppDelegateFirstVC.h"
#import "FirstVC.h"
#import "PaymentDetail.h"
#import "LoginVC.h"
#import "PromotionDetail.h"
#import "ParkMyCarVC.h"
#import "CarDetail.h"
#import "About.h"
#import "ShareVC.h"
#import "SupportVC.h"
#import "LogutVC.h"
#import "Country.h"
#import "PickUpRequest.h"
#import "ClientAssignment.h"
#import "LocationHelper.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@implementation mainAppDelegate{
    NSString *fbEmail;
    NSString *  fbName;
    ParkMyCarVC *parkMyCar;
    UITextField *contactField;
    UITextField *emailLbl;
    UIView * all;
    UIImageView *img;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[LocationHelper sharedObject]startLocationUpdatingWithBlock:^(CLLocation *newLocation, CLLocation *oldLocation, NSError *error)
     {
//         [self updateLocation];
     }];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"",
                                                           PayPalEnvironmentSandbox : @"ASR0bxDIAqjAPLLlPs_echPOSIloTtvLdcQFNelhseLzNKcyqojUdMPOxxOZ"}];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
   NSString *str=    [[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"];
    if ([str isEqualToString:@"NO"]||str==nil) {
        self.viewController=[[AppDelegateFirstVC alloc] init];
        self.window.rootViewController = self.viewController;
        
    }
    else{
        
        FirstVC *firstVC=[[FirstVC alloc] init];
        firstVC.title=@"Home";
        PaymentDetail *pay=[[PaymentDetail alloc] init];
        pay.title=@"Payment";
        PromotionDetail *promot=[[PromotionDetail alloc] init];
        promot.title=@"Promotion";
        CarDetail *carInfo=[[CarDetail alloc] init];
        carInfo.title=@"CarDetail";
        About *ab=[[About alloc] init];
        ab.title=@"About";
        ShareVC *sh=[[ShareVC alloc] init];
        sh.title=@"Share";
        SupportVC *support=[[SupportVC alloc] init];
        support.title=@"Support";
        LogutVC *logout=[[LogutVC alloc] init];
        logout.title=@"Logout";
        
        HomeVC *homeVC=[[HomeVC alloc] init];
        homeVC.viewControllers = @[firstVC,pay,promot,carInfo,sh,support,ab,logout];
         self.window.rootViewController = homeVC;
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(NSMutableArray *)getCountry
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"countrycodes" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error: NULL];
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSArray *arr=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
    NSMutableArray *arrCountry=[[NSMutableArray alloc]init];
    for (NSDictionary *dict in arr) {
        Country *con=[[Country alloc]init];
        [con setData:dict];
        [arrCountry addObject:con];
    }
    return arrCountry;
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"notification %@",userInfo);
    
    [[NSUserDefaults standardUserDefaults]setObject:userInfo forKey:@"push"];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                       options:(NSJSONWritingOptions)    (YES ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    
    NSDictionary *dict=[userInfo valueForKey:@"aps"];
    NSString *ts=[dict valueForKey:@"id"];

    
    NSString *strMsg=@"";
    if (! jsonData)
    {
        strMsg=error.localizedDescription;
    }
    else {
        strMsg=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

//    NSString *str=[userInfo valueForKey:@"id"];
//    if ([ts isEqualToString:@"1"]) {
//          [[ClientAssignment sharedObject]setData:dict];
//           [[NSNotificationCenter defaultCenter]postNotificationName:@"pushNotification" object:nil];
////        [ClientAssignment sharedObject].time_of_pickup=[dict valueForKey:@"time_of_pickup"];
//        
//      
//    
//    }
//    else if ([ts isEqualToString:@"2"]) {
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"dropOffNotification" object:nil];
//    }
//    else if ([ts isEqualToString:@"3"]) {
//        
//  [[NSNotificationCenter defaultCenter]postNotificationName:@"droppedNotification" object:nil];
//        
//    }
   
     [[NSNotificationCenter defaultCenter]postNotificationName:@"clientPush" object:nil];
    

}

#pragma mark -
#pragma mark - Loading View

-(void) showHUDLoadingView:(NSString *)strTitle
{
    HUD = [[MBProgressHUD alloc] initWithView:self.window];
    [self.window addSubview:HUD];
        //HUD.delegate = self;
        //HUD.labelText = [strTitle isEqualToString:@""] ? @"Loading...":strTitle;
    HUD.detailsLabelText=[strTitle isEqualToString:@""] ? @"Loading...":strTitle;
    [HUD show:YES];
}

-(void) hideHUDLoadingView
{
    [HUD removeFromSuperview];
}

-(void)showToastMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window
                                              animated:YES];
    
        // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0];
}

-(void)emailLoginClick:(NSString *)email{
    /*
     RegisterVC *registerVC=[[RegisterVC alloc] init];
     [self presentViewController:registerVC animated:YES completion:nil];*/
    
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:fbEmail forKey:PARAM_EMAIL];
    [dictParam setObject:@"fbpswd" forKey:PARAM_PASSWORD];
    [dictParam setObject:[[UserDefaultHelper sharedObject] deviceToken] forKey:PARAM_DEVICE_TOKEN];
    [dictParam setObject:DEVICE_TYPE forKey:PARAM_DEVICE_TYPE];
    
    [dictParam setObject:USER_TYPE forKey:PARAM_IS_DRIVER];
    
    
    [[mainAppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
    [afn getDataFromPath:FILE_LOGIN withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         [[mainAppDelegate sharedAppDelegate]hideHUDLoadingView];
         if (response)
         {
             NSMutableDictionary *dict=[response objectForKey:WS_UBER_ALPHA];
             if ([[dict objectForKey:WS_STATUS]isEqualToString:WS_STATUS_SUCCESS])
             {
                 [[NSUserDefaults standardUserDefaults]setObject:@"Yes" forKey:@"isLogin"];
                 [[NSUserDefaults standardUserDefaults ]synchronize];
                 
                 [[mainAppDelegate sharedAppDelegate]showToastMessage:[dict objectForKey:WS_MESSAGE]];
                 [[User currentUser]setUser:[dict objectForKey:WS_DETAILS]];
                 if (!parkMyCar) {
                     parkMyCar=[[ParkMyCarVC alloc] init];
                     
                 }
                 
                 self.window.rootViewController=parkMyCar;
                     //                 [self.window.rootViewController presentViewController:parkMyCar animated:YES completion:nil];
             }
             else{
                 [[mainAppDelegate sharedAppDelegate]showToastMessage:[dict objectForKey:WS_MESSAGE]];
             }
         }
         else{
             
         }
     }];
    
    
}


-(void)fbRegistrClick:(NSString *)email name:(NSString *)name phoneNo:(NSString *)phoneNo{
    
    
    UIImage *im=img.image;
    
    NSString *strPath=FILE_CLIENT_REGISTER;
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:name forKey:PARAM_NAME];
    [dictParam setObject:email forKey:PARAM_EMAIL];
    [dictParam setObject:@"fbpswd" forKey:PARAM_PASSWORD];
    [dictParam setObject:phoneNo forKey:PARAM_CONTACT];
    [dictParam setObject:@"US" forKey:PARAM_COUNTRY_CODE];
    [dictParam setObject:DEVICE_TYPE forKey:PARAM_DEVICE_TYPE];
    [dictParam setObject:[[UserDefaultHelper sharedObject] deviceToken] forKey:PARAM_DEVICE_TOKEN];
    [dictParam setObject:[[UserDefaultHelper sharedObject] currentLatitude] forKey:PARAM_LATTITUDE];
    [dictParam setObject:[[UserDefaultHelper sharedObject] currentLongitude] forKey:PARAM_LOGITUDE];
    [dictParam setObject:@"111991" forKey:PARAM_DATE_OF_BIRTH];
    [dictParam setObject:@"56" forKey:PARAM_REFERENCE_NO];
        //    [dictParam setObject:data forKey:@"PhotoFile"];
    
    [[mainAppDelegate sharedAppDelegate]showHUDLoadingView:@""];
    
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
    
        //    NSString *feedStr = [[NSString alloc] initWithData:feedData encoding:NSUTF8StringEncoding];
        //    for(int i=0; i<[feedStr length]; ++i)
        //    {
        //        unichar c = [feedStr characterAtIndex:i];
        //        NSLog(@"decimal char %d", c);
        //    }
    NSLog(@"str path %@",strPath);
    [afn getDataFromPath:strPath withParamDataImage:dictParam andImage:im withBlock:^(id response, NSError *error) {
        
        [[mainAppDelegate sharedAppDelegate]hideHUDLoadingView];
        if (response)
        {
            NSMutableDictionary *dict=[response objectForKey:WS_UBER_ALPHA];
            if ([[dict objectForKey:WS_STATUS]isEqualToString:WS_STATUS_SUCCESS])
            {
                [[NSUserDefaults standardUserDefaults]setObject:@"Yes" forKey:@"isLogin"];
                [[NSUserDefaults standardUserDefaults ]synchronize];
                
                [[User currentUser]setUser:[dict objectForKey:WS_DETAILS]];
                all=nil;
                if (!parkMyCar) {
                    parkMyCar=[[ParkMyCarVC alloc] init];
                }
                [contactField resignFirstResponder];
                self.window.rootViewController=parkMyCar;
                
            }
            else{
                [[mainAppDelegate sharedAppDelegate]showToastMessage:[dict objectForKey:WS_MESSAGE]];
            }
        }
        else{
            [[mainAppDelegate sharedAppDelegate]showToastMessage:@"Server error, please try again"];
        }
    }];
    
    
}



+(mainAppDelegate *)sharedAppDelegate
{
    return (mainAppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
        // attempt to extract a token from the url
        //return [FBSession.activeSession handleOpenURL:url];
    
    NSLog(@"url is %@",url);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"callwebservice" object:nil];
    
        //   [PFFacebookUtils handleOpenURL:url];
    
    [FBAppCall handleOpenURL:url sourceApplication:sourceApplication fallbackHandler:^(FBAppCall *call) {
        NSString *accessToken = call.accessTokenData.accessToken;
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"Facebook Access Token"];
        NSLog(@"Access Token = %@",call.accessTokenData.accessToken);
        NSLog(@"App Link Data = %@",call.appLinkData);
        NSLog(@"call == %@",call);
        
        if (call.appLinkData && call.appLinkData.targetURL) {
            
        }
        
    }];
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"Url== %@", url);
    return [FBSession.activeSession handleOpenURL:url];
}

#pragma mark -
- (BOOL)openSessionWithAllowLoginUI:(NSString *)isLoginReq{
    

    NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile",@"email",@"status_update",@"user_photos",@"user_birthday",@"user_about_me",@"user_friends",@"photo_upload",@"read_friendlists",@"publish_actions", nil];
    
    FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
        // Set the active session
    [FBSession setActiveSession:session];
    
        //imports an existing access token and opens a session with it.....
    
    [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView
            completionHandler:^(FBSession *session,
                                FBSessionState status,
                                NSError *error) {
                
                if (error==nil) {
                    
                    FBAccessTokenData *tokenData= session.accessTokenData;
                    
                    NSString *accessToken = tokenData.accessToken;
                    NSLog(@"AccessToken==%@",accessToken);
                    
                        //                    [self fetchFacebookGameFriends:accessToken];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
                    
                    /*    Simple method to make a graph API request for user friends (/me/friends), creates an <FBRequest>
                     then uses an <FBRequestConnection> object to start the connection with Facebook. The
                     request uses the active session represented by `[FBSession activeSession]`.*/
                    
                    [FBRequestConnection
                     startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                                       id<FBGraphUser> user,
                                                       NSError *error){
                         NSLog(@"User = %@", user);
                         
                         
                         fbEmail = [NSString stringWithFormat:@"%@",[user objectForKey:@"email"]];
                         fbName = [NSString stringWithFormat:@"%@",[user objectForKey:@"name"]];
                          NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [user objectID]];
                         NSURL *url=[NSURL URLWithString:userImageURL];
                         
                         if ([isLoginReq isEqualToString:@"Login"]) {
                             [self emailLoginClick:fbEmail];
                             
                         }else{
                             
                         all=[[UIView alloc] init ];
                         all.backgroundColor=[UIColor blackColor];
                         [self.window addSubview:all];
                         
                         
                         UILabel * header=[[UILabel alloc] init ];
                         header.textAlignment=NSTextAlignmentCenter;
                         header.backgroundColor= [UIColor whiteColor];
                         header.text=@"Enter You Details";
                         [all addSubview:header];
                         
                         
                         img=[[UIImageView alloc]init];
                         [img setImageWithURL:url placeholderImage:[UIImage imageNamed:@"profile.png"]];
                         [img.layer setBorderColor: [[UIColor whiteColor] CGColor]];
                         [img.layer setBorderWidth: 2.0];
                         [img.layer setCornerRadius: 5.0];
                         [all addSubview:img];
                         
                         UILabel *nameLbl=[[UILabel alloc]init];
                         nameLbl.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
                             nameLbl.text=fbName;
                         nameLbl.textColor=[UIColor whiteColor];
                         [nameLbl.layer setBorderColor: [[UIColor whiteColor] CGColor]];
                         nameLbl.textAlignment = NSTextAlignmentCenter;
                         [nameLbl.layer setBorderWidth: 2.0];
                        [nameLbl.layer setCornerRadius: 5.0];

                             
                             UILabel *contactLbl=[[UILabel alloc]init];
                            contactLbl.backgroundColor=[UIColor clearColor];
                             contactLbl.textColor=[UIColor whiteColor];
                             contactLbl.text=@"Contact Number";
                             [all addSubview:contactLbl];
                         [all addSubview:nameLbl];
                         
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor=[UIColor whiteColor];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:@"Done" forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont fontWithName:nil size:30]];
            
            [button addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [all addSubview:button];
                             
                             
                             emailLbl = [[UITextField alloc] init ];
                             emailLbl.font = [UIFont systemFontOfSize:15];
                             emailLbl.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
                             emailLbl.placeholder  = @" Enter Email Adrress";
                             emailLbl.autocorrectionType = UITextAutocorrectionTypeNo;
                             emailLbl.keyboardType =UIKeyboardTypeEmailAddress;
                             emailLbl.returnKeyType = UIReturnKeyDone;
                             emailLbl.clearButtonMode = UITextFieldViewModeWhileEditing;
                             emailLbl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                            emailLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                             [all addSubview:emailLbl];
                             
                            if ([user objectForKey:@"email"]) {
                                  NSLog(@"fbmail is null1");
                             emailLbl.text=fbEmail;
                                
                             }
//                             fbEmail = emailLbl.text;
//                              emailLbl.text=fbEmail;

                             NSLog(@"emaillbl.text is %@",emailLbl.text);
                           
                             emailLbl.textColor=[UIColor whiteColor];
                             [emailLbl.layer setBorderColor: [[UIColor whiteColor] CGColor]];
                             
                             [emailLbl.layer setBorderWidth: 2.0];
                             
                             [emailLbl.layer setCornerRadius: 5.0];
                             
                         
                      contactField = [[UITextField alloc] init ];
                      
                         contactField.font = [UIFont systemFontOfSize:15];
                        contactField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
                        contactField.placeholder  = @" Enter Contact Number";
                        contactField.autocorrectionType = UITextAutocorrectionTypeNo;
                         contactField.keyboardType =UIKeyboardTypeNumberPad;
                         contactField.returnKeyType = UIReturnKeyDone;
                         contactField.clearButtonMode = UITextFieldViewModeWhileEditing;
                         contactField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                              contactField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                         [all addSubview:contactField];
                             contactField.textColor=[UIColor whiteColor];
                             [contactField.layer setBorderColor: [[UIColor whiteColor] CGColor]];
                             [contactField.layer setBorderWidth: 2.0];
                            [contactField.layer setCornerRadius: 5.0];
                             
                             emailLbl.text=fbEmail;
                             if(emailLbl.text==nil){
                                 [emailLbl becomeFirstResponder];
                             }else {
       
                                 [contactField becomeFirstResponder];}
                         
                             NSLog(@"email is %@",fbEmail);
                         
                             if ([UIScreen mainScreen].nativeScale == 2.0f){
                                 if (self.window.frame.size.height>568.0f) {
                                     NSLog(@"in iPhone6");
                                     all.frame=CGRectMake(0, 0, self.window.frame.size.width , self.window.frame.size.height);
                                     header.frame=CGRectMake(0, 0, self.window.frame.size.width-138 ,60);
                                     img.frame=CGRectMake(10, 75, 100, 150);
                                     nameLbl.frame=CGRectMake(125, 90, self.window.frame.size.width-125, 40);
                                     emailLbl.frame=CGRectMake(125, 173.0, self.window.frame.size.width-125,40);
                                     button.frame=CGRectMake(239, 1, 150, 60);
                                      contactLbl.frame=CGRectMake(55, self.window.frame.size.height-390, self.window.frame.size.width-145, 40);
                                     contactField.frame=CGRectMake(30,self.window.frame.size.height-360, 268, 40);

                                     
                               }
                                 else if ( self.window.bounds.size.height==568.0f) {
                                     NSLog(@"in iPhone5");
                                     all.frame=CGRectMake(0, 0, self.window.frame.size.width , self.window.frame.size.height);
                                     header.frame=CGRectMake(0, 0, self.window.frame.size.width-125 ,60);
                                     img.frame=CGRectMake(10, 75, 100, 100);
                                     nameLbl.frame=CGRectMake(125, 75, self.window.frame.size.width-145, 40);
                                     emailLbl.frame=CGRectMake(125, 130, self.window.frame.size.width-145,40);
                                     button.frame=CGRectMake(200, 1, 150, 60);
                                       contactLbl.frame=CGRectMake(55, self.window.frame.size.height-350, self.window.frame.size.width-145, 40);
                                     contactField.frame=CGRectMake(30,self.window.frame.size.height-320, 268, 40);

                               }
                                 else{
                                     NSLog(@"in iPhone4 ");
                                         all.frame=CGRectMake(0, 0, self.window.frame.size.width , self.window.frame.size.height);
                                      header.frame=CGRectMake(0, 0, self.window.frame.size.width-118 ,60);
                                     img.frame=CGRectMake(10, 75, 100, 100);
                                     nameLbl.frame=CGRectMake(125, 75, self.window.frame.size.width-120, 40);
                                     emailLbl.frame=CGRectMake(125, 130, self.window.frame.size.width-120,40);
                                      button.frame=CGRectMake(205, 1, 150, 60);
                                      contactLbl.frame=CGRectMake(55, self.window.frame.size.height-310, self.window.frame.size.width-145, 40);
                                     contactField.frame=CGRectMake(30,self.window.frame.size.height-280, 268, 40);

                            
                               }
                                 
                             }
                             else if ([UIScreen mainScreen].scale > 2.1f)
                             {
                                 NSLog(@"in iPhone 6 plus");
                                 all.frame=CGRectMake(0, 0, self.window.frame.size.width , self.window.frame.size.height);
                                 header.frame=CGRectMake(0, 0, self.window.frame.size.width-140 ,60);
                                 img.frame=CGRectMake(10, 75, 100, 100);
                                 nameLbl.frame=CGRectMake(125, 75, self.window.frame.size.width-145, 40);
                                 emailLbl.frame=CGRectMake(125, 130, self.window.frame.size.width-145,40);
                                 button.frame=CGRectMake(276, 1, 170, 60);
                                  contactLbl.frame=CGRectMake(55, self.window.frame.size.height-430, self.window.frame.size.width-145, 40);
                                 contactField.frame=CGRectMake(30,self.window.frame.size.height-400, 268, 40);

                                 
                             }
                             else 
                             {
                                 NSLog(@"in iPad ");
                                 all.frame=CGRectMake(0, 0, self.window.frame.size.width , self.window.frame.size.height);
                                 header.frame=CGRectMake(0, 0, self.window.frame.size.width-100 ,60);
                                 img.frame=CGRectMake(10, 75, 100, 100);
                                 nameLbl.frame=CGRectMake(125, 75, self.window.frame.size.width-125, 40);
                                 emailLbl.frame=CGRectMake(125, 130, self.window.frame.size.width-125,40);
                                 button.frame=CGRectMake(200, 1, 180, 60);
                                 contactField.frame=CGRectMake(30,self.window.frame.size.height-280, 268, 40);
                          [button.titleLabel setFont:[UIFont fontWithName:nil size:15]];
                            
                             }
                         }
                         
                     }];
                    
                }
                     
                else{
                    
                    NSLog(@"Session not open==%@",error);
                }
                
                    // Respond to session state changes,
                    // ex: updating the view
            }];
    return YES;
}

-(BOOL) openSessionWithLoginUI:(NSInteger)value withParams: (NSDictionary *)dict{
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile",@"user_friends",@"publish_actions", nil];
    
    FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
        // Set the active session
    [FBSession setActiveSession:session];
        //    ms_friendCache = NULL;
    
    [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView
            completionHandler:^(FBSession *session,
                                FBSessionState status,
                                NSError *error) {
                
                if (error==nil) {
                        //[NSThread detachNewThreadSelector:@selector(fetchFacebookGameFriends) toTarget:self withObject:nil];
                    FBAccessTokenData *tokenData= session.accessTokenData;
                    
                    NSString *accessToken = tokenData.accessToken;
                    NSLog(@"AccessToken==%@",accessToken);
                    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
                    
                    
                    [self shareOnFacebookWithParams:dict];
                    
                    
                    [FBRequestConnection
                     startForMeWithCompletionHandler:^(FBRequestConnection *connection,id<FBGraphUser> user,NSError *error){
                         NSLog(@"User = %@",user);
                             //                         NSString *userName = [NSString stringWithFormat:@"%@",[user objectForKey:@"first_name"]];
                             //                         NSString *userID = [NSString stringWithFormat:@"%@",[user objectForKey:@"id"]];
                         
                     }];
                    
                        // [self retriveAllfriends];
                }
                else{
                    
                    NSLog(@"Session not open==%@",error);
                }
                
                    // Respond to session state changes,
                    // ex: updating the view
            }];
    
    return YES;
}


#pragma mark -Share on Facebook
-(void) shareOnFacebookWithParams:(NSDictionary *)params{
    
    [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params handler:^(FBWebDialogResult result, NSURL *resultUrl, NSError *error){
        
        if (error) {
            NSLog(@"Error to post on facebook = %@", [error localizedDescription]);
        }
        else{
            if (result == FBWebDialogResultDialogNotCompleted) {
                NSLog(@"Error to post on facebook = %@", [error localizedDescription]);
                NSLog(@"User cancel Request");
            }//End Result Check
            else{
                NSString *sss= [NSString stringWithFormat:@"%@",resultUrl];
                if ([sss rangeOfString:@"post_id"].location == NSNotFound) {
                    NSLog(@"User Cancel Share");
                }
                else{
                    NSLog(@"posted on wall");
                }
            }//End Else Block Result Check
        }
    }];
}


-(void)doneButtonAction:(UIButton *)button{
    
    if (contactField.text.length == 0 ||emailLbl.text.length== 0) {
        UIAlertView *aletr=[[UIAlertView alloc] initWithTitle:@"Required Field must not be Blank" message:@"Enter all details" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [aletr show];
    }else {
        [self fbRegistrClick:emailLbl.text name:fbName phoneNo:contactField.text];
    }
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *device = [deviceToken description];
    device = [device stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        NSLog(@"My device is: %@", device);
        //RegisteringforRemoteNotifications
    [USERDEFAULT setObject:device forKey:UD_DEVICETOKEN];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code != 3010) { // 3010 is for the iPhone Simulator
        NSLog(@"Application failed to register for push notifications: %@", error);
    }
}


#pragma mark - Application Delegates

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
      NSDictionary *dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"push"];
    if (dict==nil) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"clientPush" object:nil];
    }else{
      [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"push"];
    
    }
   
//    [self getPush];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)getPush
{
    if ([User currentUser].client_id!=nil) {
        
        NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
        
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
                 if ([[dict objectForKey:@"id"] intValue]==5) {
                     
                     PickUpRequest *pick=[[PickUpRequest alloc]init];
                     [pick setData:dict];
                     [[ClientAssignment sharedObject]setData:dict];
                     [ClientAssignment sharedObject].random_id=pick.random_id;
                     
                     [[NSNotificationCenter defaultCenter]postNotificationName:@"pushNotificationDidActive" object:nil];
                 }
                 else if ([[dict objectForKey:@"id"] intValue]==4)
                 {
                     [[ClientAssignment sharedObject]removeAllData];
                 }
                     //             else{
                     //                 [self handalClientPush:response];
                     //             }
                     //             [self goToHome];
             }
         }];}
}




@end
