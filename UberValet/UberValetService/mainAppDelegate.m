
//  mainAppDelegate.m
//  UberValetService
//
//  Created by Globussoft 1 on 10/21/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import "mainAppDelegate.h"
#import "LocationHelper.h"
#import "AFNHelper.h"
#import "User.h"
#import "Constants.h"
#import "UserDefaultHelper.h"
#import "DriverAssignment.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FirstVC.h"
#import "HomeVC.h"
#import "LoginVC.h"
#import "About.h"

#import "LogutVC.h"
#import "PromotionDetail.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "Settings.h"
#import "Reachability.h"


@implementation mainAppDelegate{
    int seconds;
    BOOL isStartUpdateLocation;
    NSString *Driver;
    BOOL checkNotification;
    
    
}
@synthesize navMain,viewController ;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //check for network connectivity
    
    [self reacheability];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reacheability) name:kReachabilityChangedNotification object:nil];
    
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
    
    isStartUpdateLocation=YES;
    // Override point for customization after application launch.
    seconds=0;
    
    BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:CurrentNetworkStatus];
   
    
    NSString *driver_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"driver_id"];

    if (connect == YES) {
        if (driver_id){
            [[LocationHelper sharedObject]startLocationUpdatingWithBlock:^(CLLocation *newLocation, CLLocation *oldLocation, NSError *error)
             {
                 [self updateLocation]; // update the driver location.
             }];
        }
    }
    
    if (driver_id) {
        NSLog(@"get push called");
        myTimer = [NSTimer scheduledTimerWithTimeInterval: 10.0 target: self
                                                 selector: @selector(updateLocation) userInfo: nil repeats: YES];
    
    }
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSString *str=    [[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"];
    
    if ([str isEqualToString:@"NO" ] || str == nil) {
        self.viewController=[[AppDelegateFirstVC alloc] init];
        self.window.rootViewController = self.viewController;
    }
    else{
//        BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:CurrentNetworkStatus];
        NSString *driver_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"driver_id"];
        
        if (driver_id) {
        [self updateLocation];
        }
        
        
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
        self.window.rootViewController=homeVC ;
    }
    [self.window makeKeyAndVisible];
    
    seconds=0;
  
    return YES;
}
//


-(void)getPush
{
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    
    [dictParam setObject:[User currentUser].driver_id forKey:PARAM_DRIVER_ID];
    NSLog(@"[User currentUser].driver_id %@",[User currentUser].driver_id);
    NSLog(@"DriverAssignment sharedObject].random_id is %@",[DriverAssignment sharedObject].random_id);
    
    if ([DriverAssignment sharedObject].random_id!=nil) {
        
        [dictParam setObject:[DriverAssignment sharedObject].random_id forKey:PARAM_RANDOM_ID];
    }
    
    
    //   [[mainAppDelegate sharedAppDelegate]showHUDLoadingView:@""];
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
    [afn getDataFromPath:FILE_DRIVER_PUSH withParamData:dictParam withBlock:^(id response, NSError *error)
     {
            if (response)
         {
             NSLog(@"response is %@",response);
            [self handalDriverPush:response];
            [self addressFromLattiude];
        }
     }];
}

-(void)addressFromLattiude{
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * latitude = [f numberFromString:[DriverAssignment sharedObject].lattitude];
    NSNumber * longitude = [f numberFromString:[DriverAssignment sharedObject].logitude];
    
    printf("[%f,", [latitude doubleValue]);
    printf("%f]", [longitude doubleValue]);
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"placemark %@",placemark);
         //String to hold address
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         NSLog(@"addressDictionary %@", placemark.addressDictionary);
         
         NSLog(@"placemark %@",placemark.region);
         NSLog(@"placemark %@",placemark.country);  // Give Country Name
         NSLog(@"placemark %@",placemark.locality); // Extract the city name
         NSLog(@"location %@",placemark.name);
         NSLog(@"location %@",placemark.ocean);
         NSLog(@"location %@",placemark.postalCode);
         NSLog(@"location %@",placemark.subLocality);
         
         NSLog(@"location %@",placemark.location);
         //Print the location to console
         NSLog(@"I am currently at %@",locatedAt);
         Driver=[NSString stringWithFormat:@"%@  %@",placemark.subLocality,locatedAt ];
         
         [DriverAssignment sharedObject].address = Driver;
         
         
     }];
}

-(void)handalDriverPush:(NSDictionary *)dictPush
{
    
    if(dictPush !=nil){
        [[DriverAssignment sharedObject]setData:[dictPush objectForKey:@"aps"]];
        NSLog(@"[DriverAssignment sharedObject].id_ is %@",[DriverAssignment sharedObject].id_);
    }
 
    check1 =[[NSUserDefaults standardUserDefaults] objectForKey:@"check1"];
    check2 =[[NSUserDefaults standardUserDefaults] objectForKey:@"check2"];
    
    //checks the request from the client.
    if ([[DriverAssignment sharedObject].id_ isEqualToString:@"3"]) {
        
        if (check1 == nil) {
            NSLog(@"success");
            check1 = @YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"requestNotification" object:nil];
        }
        [[NSUserDefaults standardUserDefaults]setObject:check1 forKey:@"check1"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    //check the request drop off action.

    if ([[DriverAssignment sharedObject].id_ isEqualToString:@"2"]) {
        
        if (check2 == nil) {
            NSLog(@"success");
            check2 = @YES;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReachedClient" object:nil];
            
        }
        [[NSUserDefaults standardUserDefaults]setObject:check2 forKey:@"check2"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    
    if ([[DriverAssignment sharedObject].id_ isEqualToString:@"1"]) {
        
        
        
    }
}




-(void)updateLocation
{
    //    seconds= 3 ;
    
    BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:CurrentNetworkStatus];
    
    
    if (!connect) {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"There is no Internet Connection in your device" message:@"Check Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    
    NSString *str=    [[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"];
    
    if ([str isEqualToString:@"NO"]) {
        [myTimer invalidate];
        return ;
    }
    
    if (seconds>2 && isStartUpdateLocation) {
        NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
        [dictParam setObject:[User currentUser].driver_id forKey:PARAM_DRIVER_ID];
        [dictParam setObject:[[UserDefaultHelper sharedObject] currentLatitude] forKey:PARAM_LATTITUDE];
        [dictParam setObject:[[UserDefaultHelper sharedObject] currentLongitude] forKey:PARAM_LOGITUDE];
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:FILE_SET_DRIVER_LOCATION withParamData:dictParam withBlock:^(id response, NSError *error) {
            if (response) {
                NSLog(@"current location is updating");
            }
        }];
        seconds=0;
    }
    seconds++;
}

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
                         
                         if ([fbEmail isEqualToString:@""]) {
                             //generate popup to enter email if null
                         }
                         //                         [[NSUserDefaults standardUserDefaults]setObject:fbEmail forKey:@"fbEmail"];
                         //                         [[NSUserDefaults standardUserDefaults]setObject:fbName forKey:@"fbName"];
                         //                         [[NSUserDefaults standardUserDefaults]synchronize];
                         if ([isLoginReq isEqualToString:@"Login"]) {
                             [self emailLoginClick:fbEmail];
                             
                         }else{
                             
//                             [self fbRegistrClick:fbEmail name:fbName phoneNo:@"hello"];
                         }
                         
                         NSLog(@"email is %@",fbEmail);
                         
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
    
    
    UIImage *im=[UIImage imageNamed:@"closed.png"];
    NSData  *data=UIImageJPEGRepresentation(im, 1.0) ;
    
    NSString *strPath=FILE_DRIVER_REGISTER;
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
    [afn getDataFromPath:strPath withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         [[mainAppDelegate sharedAppDelegate]hideHUDLoadingView];
         if (response)
         {
             NSMutableDictionary *dict=[response objectForKey:WS_UBER_ALPHA];
             if ([[dict objectForKey:WS_STATUS]isEqualToString:WS_STATUS_SUCCESS])
             {
                 
                 [[NSUserDefaults standardUserDefaults]setObject:@"Yes" forKey:@"isLogin"];
                 [[NSUserDefaults standardUserDefaults ]synchronize];
                 
                 [[User currentUser]setUser:[dict objectForKey:WS_DETAILS]];
              //   if (!parkMyCar) {
                  //   parkMyCar=[[ParkMyCarVC alloc] init];
              //   }
                 
               //  [self.window.rootViewController presentViewController:parkMyCar animated:YES completion:nil];
                 
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

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //    NSLog(@"device token %@",deviceToken);
    
    NSString *device = [deviceToken description];
    device = [device stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    //    device = [device stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"My device is: %@", device);
    
    
    //RegisteringforRemoteNotifications
    [USERDEFAULT setObject:device forKey:UD_DEVICETOKEN] ;
    NSLog(@"%@ \n %@",
          deviceToken,
          [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding]
          );
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code != 3010) { // 3010 is for the iPhone Simulator
        NSLog(@"Application failed to register for push notifications: %@", error);
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"Url== %@", url);
    return [FBSession.activeSession handleOpenURL:url];
}

#pragma mark -
#pragma mark - sharedAppDelegate

+(mainAppDelegate *)sharedAppDelegate
{
    return (mainAppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark -
#pragma mark - Loading View
/*
 -(void) showHUDLoadingView:(NSString *)strTitle
 {
 //    HUD = [[MBProgressHUD alloc] initWithView:self.window];
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
 */



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    if ( application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground  )
    {
        NSLog(@"opened from a push notification when the app was on background");
        //opened from a push notification when the app was on background
    }
    
    NSLog(@"user info is %@",userInfo);
    NSDictionary *dict=[userInfo valueForKey:@"aps"];
    NSString *ts=[dict valueForKey:@"id"];
    //    [DriverAssignment sharedObject].random_id =[dict valueForKey:@"random_id"];
    BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:CurrentNetworkStatus];
    
    
    if (connect == YES) {
        
        [self getPush];
        
    }
    
    
    if ([ts isEqualToString:@"1"])  {
        //            [self getPush];
    }
    
    if ([ts isEqualToString:@"2"])   {
        
        //         [[NSNotificationCenter defaultCenter] postNotificationName:@"ReachedClient" object:nil];
        
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                       options:(NSJSONWritingOptions)    (YES ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    NSString *strMsg=@"";
    if (! jsonData)
    {
        strMsg=error.localizedDescription;
    }
    else {
        strMsg=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    //    [[UtilityClass sharedObject]showAlertWithTitle:@"RemoteNotification" andMessage:strMsg];
    
    //    [self handalDriverPush:userInfo];
    
}

#pragma mark ------ share on facebook.
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


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //    [self getPush];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     if ( application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground  )
     {
     NSLog(@"opened from a push notification when the app was on background");
     //opened from a push notification when the app was on background
     }else{ */
   
    [self reacheability];
    
    BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:CurrentNetworkStatus];
    
    
    if (connect == YES) {
        [self getPush];
    }

    //    checkNotification = FALSE;
    
    // }
    
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"in application did become active");
    [self reacheability];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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

#pragma Reacheability

-(void)reacheability
{
    // NSLog(@"Rechability");
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    BOOL networkStatus = NO;
    
    if(status == NotReachable)
    {
        // NSLog(@"stringgk////");
        networkStatus = NO;
    }
    else if (status == ReachableViaWiFi)
    {
        // NSLog(@"reachable");
        networkStatus = YES;
        
    }
    else if (status == ReachableViaWWAN)
    {
        //3G
        networkStatus = YES;
    }
    else
    {
        networkStatus = NO;
    }
    // Do any additional setup after loading the view.
    
    [[NSUserDefaults standardUserDefaults] setBool:networkStatus forKey:CurrentNetworkStatus];
}


@end
