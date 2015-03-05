//
//  mainViewController.m
//  UberValetService
//
//  Created by Globussoft 1 on 10/21/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import "LoginVC.h"
#import "HomeVC.h"
#import "RegisterVC.h"
#import "FirstVC.h"
#import "UserDefaultHelper.h"
#import "User.h"
#import "Constants.h"
#import "AFNHelper.h"
#import "About.h"
#import "LogutVC.h"
#import "PromotionDetail.h"
#import "Settings.h"

//#import "CustomMenuViewController.h"

@interface LoginVC ()
@property(nonatomic,strong)UITextField *emailField;
@property (nonatomic,strong)UITextField *passwordField;
@property(nonatomic,strong)UIButton *fbLoginButton;
@property(nonatomic,strong)UIButton *emailLoginButton;
@property(nonatomic,strong)UIButton *backButton;
@property(nonatomic,strong)UIButton  *forgetPswdButton;
@property(nonatomic,strong)UIScrollView *scrollView;
@end

@implementation LoginVC 

- (void)viewDidLoad
{
    [super viewDidLoad];
    
      NSLog(@"[UIScreen mainScreen].bounds.size.width is %f height is %f",[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.scrollView.delegate=self;
    self.scrollView.backgroundColor=[UIColor clearColor];
    
    [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, 700)];
    [self.view addSubview:self.scrollView];
    
    self.view.backgroundColor=[UIColor blackColor];
    
    
    self.emailField = [[UITextField alloc] init ];
    //                       WithFrame:CGRectMake(30,self.view.frame.size.height-280, 268, 40)];
    self.emailField.font = [UIFont systemFontOfSize:15];
    self.emailField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
    self.emailField.placeholder  = @" Enter Email Adrress";
    self.emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailField.keyboardType = UIKeyboardTypeDefault;
    self.emailField.returnKeyType = UIReturnKeyDone;
    self.emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.emailField.delegate = self;
    self.emailField.text=@"vsv@gmail.com";
    [self.scrollView addSubview:self.emailField];
    
    self.passwordField = [[UITextField alloc] init ];
    //                          WithFrame:CGRectMake(30, self.view.frame.size.height-230, 268, 40)];
    self.passwordField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
    self.passwordField.borderStyle = UITextBorderStyleNone;
    self.passwordField.font = [UIFont systemFontOfSize:15];
    self.passwordField.placeholder = @" Enter Password";
    self.passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordField.keyboardType = UIKeyboardTypeDefault;
    self.passwordField.returnKeyType = UIReturnKeyDone;
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passwordField.delegate = self;
    self.passwordField.text=@"123456";
    [self.scrollView addSubview:self.passwordField];
    
    
    self.emailLoginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.emailLoginButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"reglog.png"]];
    [self.emailLoginButton addTarget:self action:@selector(emailLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.emailLoginButton setTitle:@"Login with Email" forState:UIControlStateNormal];
    [self.scrollView addSubview:self.emailLoginButton];
    
    
    self.backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [self.scrollView addSubview:self.backButton];
    
    
    self.forgetPswdButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.forgetPswdButton addTarget:self action:@selector(forgetPswdButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.forgetPswdButton setTitle:@"Forgot Password?" forState:UIControlStateNormal];
    [self.scrollView addSubview:self.forgetPswdButton];

    if ([UIScreen mainScreen].nativeScale == 2.0f){
        if (self.view.frame.size.height>568.0f) {
            NSLog(@"in iPhone6");
            
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg_750@2x.png"]];
            
            self.passwordField.frame=CGRectMake(55, self.view.frame.size.height-300, 268, 40);
            self.emailField.frame=CGRectMake(55,self.view.frame.size.height-360, 268, 40);
            self.emailLoginButton.frame=CGRectMake(40, self.view.frame.size.height-190, 300, 40);
            self.fbLoginButton.frame=CGRectMake(40, self.view.frame.size.height-120, 300,40);
            self.backButton.frame=CGRectMake(10, 20, 50,50);
            self.forgetPswdButton.frame=CGRectMake(100, self.view.frame.size.height-265, 300, 40);
        }
        else if ( self.view.bounds.size.height==568.0f) {
            NSLog(@"in iPhone5");
            self.passwordField.frame=CGRectMake(30, self.view.frame.size.height-230, 268, 40);
            self.emailField.frame=CGRectMake(30,self.view.frame.size.height-280, 268, 40);
            self.emailLoginButton.frame=CGRectMake(10, self.view.frame.size.height-130, 300, 40);
            self.fbLoginButton.frame=CGRectMake(10, self.view.frame.size.height-80, 300,40);
            self.backButton.frame=CGRectMake(10, 20, 50,50);
            self.forgetPswdButton.frame=CGRectMake(10, self.view.frame.size.height-180, 300, 40);
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg_568.png"]];
            
        }
        else{
            NSLog(@"in iPhone4 ");
            self.passwordField.frame=CGRectMake(30, self.view.frame.size.height-230, 268, 40);
            self.emailField.frame=CGRectMake(30,self.view.frame.size.height-280, 268, 40);
            self.emailLoginButton.frame=CGRectMake(10, self.view.frame.size.height-130, 300, 40);
            self.fbLoginButton.frame=CGRectMake(10, self.view.frame.size.height-80, 300,40);
            self.backButton.frame=CGRectMake(10, 20, 50,50);
            self.forgetPswdButton.frame=CGRectMake(10, self.view.frame.size.height-180, 300, 40);
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg.png"]];
        }
        
    }
    else if ([UIScreen mainScreen].scale > 2.1f)
    {
        NSLog(@"in iPhone 6 plus");
        
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg@3x.png"]];
        self.passwordField.frame=CGRectMake(65, self.view.frame.size.height-340, 268, 40);
        self.emailField.frame=CGRectMake(65,self.view.frame.size.height-400, 268, 40);
        self.emailLoginButton.frame=CGRectMake(50, self.view.frame.size.height-230, 300, 40);
        self.fbLoginButton.frame=CGRectMake(40, self.view.frame.size.height-170, 300,40);
        self.backButton.frame=CGRectMake(10, 20, 50,50);
        self.forgetPswdButton.frame=CGRectMake(100, self.view.frame.size.height-295, 300, 40);
        
//    }else{
//        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg@3x.png"]];
//        self.passwordField.frame=CGRectMake(65, self.view.frame.size.height-340, 268, 40);
//        self.emailField.frame=CGRectMake(65,self.view.frame.size.height-400, 268, 40);
//        self.emailLoginButton.frame=CGRectMake(50, self.view.frame.size.height-230, 300, 40);
//        self.fbLoginButton.frame=CGRectMake(40, self.view.frame.size.height-170, 300,40);
//        self.backButton.frame=CGRectMake(10, 20, 50,50);
//        self.forgetPswdButton.frame=CGRectMake(100, self.view.frame.size.height-295, 300, 40);
//
   }
    
}

-(void)backButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark===== textfield delegate. 

- (void)textFieldDidBeginEditing:(UITextField *)textField{
   
    if (textField==self.passwordField) {
//         [self.passwordField becomeFirstResponder];
        self.scrollView.contentOffset=CGPointMake(0, 150);
    }
    
    if (textField==self.emailField) {
        [self.emailField becomeFirstResponder];
    }
}
// became first responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField==self.passwordField) {
        self.scrollView.contentOffset=CGPointMake(0, 0);
    }
    return YES;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.emailField !=nil&& self.passwordField!=nil) {
        
        [self.emailField resignFirstResponder];
        [self.passwordField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField==self.passwordField) {
        self.scrollView.contentOffset=CGPointMake(0, 0);
    }
   
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==self.passwordField) {
        self.scrollView.contentOffset=CGPointMake(0, 40);
    }
    return YES;
}


//Forgot Password Web service.

-(void)forgetPswdButton:(UIButton *)button{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSString *url=@"http://uber.globusapps.com/ws/forgot_driver.php";
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [self.webView loadRequest:nsrequest];
    [self.view addSubview:self.webView];
    
    self.backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton addTarget:self action:@selector(webViewBackButton:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
    self.backButton.backgroundColor=[UIColor clearColor];
    [self.backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.webView addSubview:self.backButton];
    self.backButton.frame=CGRectMake(20, 20, 50,50);

}

-(void)webViewBackButton:(UIButton *)button{
    [self.webView removeFromSuperview];
}

-(void)backButton:(UIButton *)button{


}

-(void)emailLoginClick:(UIButton *)button{
    
     //Login via Email web service call . 
    
    [self textFieldShouldReturn:self.emailField];
    if (self.emailField.text.length==0 || self.passwordField.text.length==0)
    {
        [[UtilityClass sharedObject]showAlertWithTitle:@"" andMessage:@"Enter email and password."];
        return;
    }
    else if (![[UtilityClass sharedObject]isValidEmailAddress:self.emailField.text])
    {
        [[UtilityClass sharedObject]showAlertWithTitle:@"" andMessage:@"Enter valid email id."];
        return;
    }
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:self.emailField.text forKey:PARAM_EMAIL];
    [dictParam setObject:self.passwordField.text forKey:PARAM_PASSWORD];
    [dictParam setObject:[[UserDefaultHelper sharedObject] deviceToken] forKey:PARAM_DEVICE_TOKEN];
    [dictParam setObject:DEVICE_TYPE forKey:PARAM_DEVICE_TYPE];
    [dictParam setObject:@"1" forKey:@"is_driver"];
    
    [dictParam setObject:USER_TYPE forKey:PARAM_IS_DRIVER];
    
  [[mainAppDelegate sharedAppDelegate]showHUDLoadingView:@""];
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
    [afn getDataFromPath:FILE_LOGIN withParamData:dictParam withBlock:^(id response, NSError *error)
     {
       [[mainAppDelegate sharedAppDelegate]hideHUDLoadingView];
         if (response)
         {
             NSMutableDictionary *dict=[response objectForKey:WS_UBER_ALPHA];
             if ([[dict objectForKey:WS_STATUS]isEqualToString:WS_STATUS_SUCCESS])
             {
                [[mainAppDelegate sharedAppDelegate]showToastMessage:[dict objectForKey:WS_MESSAGE]];
                 [[User currentUser]setUser:[dict objectForKey:WS_DETAILS]];
                 [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isLogin"];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 
                 
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
                 [[mainAppDelegate sharedAppDelegate]showToastMessage:[dict objectForKey:WS_MESSAGE]];
             }
         }
         else{
             
         }
     }];

   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
