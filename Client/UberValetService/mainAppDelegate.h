//
//  mainAppDelegate.h
//  UberValetService
//
//  Created by Globussoft 1 on 10/21/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"MBProgressHUD.h"
#import "AppDelegateFirstVC.h"
#import <FacebookSDK/FacebookSDK.h>

@interface mainAppDelegate : UIResponder <UIApplicationDelegate>
{
   MBProgressHUD *HUD;
 
}
@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic)AppDelegateFirstVC *viewController;

+(mainAppDelegate *)sharedAppDelegate;
-(void) showHUDLoadingView:(NSString *)strTitle;
-(void) hideHUDLoadingView;
-(void)showToastMessage:(NSString *)message;
-(NSMutableArray *)getCountry;
- (BOOL)openSessionWithAllowLoginUI:(NSString *)isLoginReq;
-(BOOL) openSessionWithLoginUI:(NSInteger)value withParams: (NSDictionary *)dict;
@end
