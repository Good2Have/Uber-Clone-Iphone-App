//
//  mainAppDelegate.h
//  UberValetService
//
//  Created by Globussoft 1 on 10/21/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegateFirstVC.h"
#import "MBProgressHUD.h"

@interface mainAppDelegate : UIResponder <UIApplicationDelegate>{
    NSString * fbEmail ;
    NSString * fbName ;
    MBProgressHUD *HUD;
    NSTimer* myTimer ;
    NSNumber *check1 ;
    NSNumber *check2 ;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic)  UINavigationController *navMain;
@property (strong, nonatomic) AppDelegateFirstVC *viewController ;
-(void) showHUDLoadingView:(NSString *)strTitle;
-(void) hideHUDLoadingView;
+(mainAppDelegate *)sharedAppDelegate;
-(void)showToastMessage:(NSString *)message;
- (BOOL)openSessionWithAllowLoginUI:(NSString *)isLoginReq ;
-(void) shareOnFacebookWithParams:(NSDictionary *)params ;
-(BOOL) openSessionWithLoginUI:(NSInteger)value withParams: (NSDictionary *)dict ; 
@end
