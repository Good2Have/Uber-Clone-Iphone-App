//
//  mainViewController.m
//  UberValetService
//
//  Created by Globussoft 1 on 10/21/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import "LoginVC.h"
#import "ParkMyCarVC.h"
#import "RegisterVC.h"


//#import "CustomMenuViewController.h"

@interface LoginVC (){
ParkMyCarVC *parkMyCar;
}
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
//    if ( self.view.bounds.size.height>500) {
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
    self.emailField.text=@"abc@d.com";
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
    self.passwordField.text=@"1234";
    [self.scrollView addSubview:self.passwordField];
    
    
    self.emailLoginButton=[UIButton buttonWithType:UIButtonTypeCustom];
       self.emailLoginButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"reglog.png"]];
    [self.emailLoginButton addTarget:self action:@selector(emailLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.emailLoginButton setTitle:@"Login with Email" forState:UIControlStateNormal];
    [self.scrollView addSubview:self.emailLoginButton];
    
    
    self.fbLoginButton=[UIButton buttonWithType:UIButtonTypeCustom];
        self.fbLoginButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regface.png"]];
    [self.fbLoginButton addTarget:self action:@selector(fbLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.fbLoginButton setTitle:@"Login With Facebook" forState:UIControlStateNormal];
    [self.scrollView addSubview:self.fbLoginButton];

    self.backButton=[UIButton buttonWithType:UIButtonTypeCustom];
      [self.backButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [self.scrollView addSubview:self.backButton];
    
    self.forgetPswdButton=[UIButton buttonWithType:UIButtonTypeCustom];
       [self.forgetPswdButton addTarget:self action:@selector(forgetPswdButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.forgetPswdButton setTitle:@"Forgot Password" forState:UIControlStateNormal];
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
        self.emailLoginButton.frame=CGRectMake(40, self.view.frame.size.height-230, 300, 40);
        self.fbLoginButton.frame=CGRectMake(40, self.view.frame.size.height-170, 300,40);
        self.backButton.frame=CGRectMake(10, 20, 50,50);
        self.forgetPswdButton.frame=CGRectMake(100, self.view.frame.size.height-295, 300, 40);
    }
    else 
    {
        NSLog(@"in iPad ");
        self.passwordField.frame=CGRectMake(30, self.view.frame.size.height-230, 268, 40);
        self.emailField.frame=CGRectMake(30,self.view.frame.size.height-280, 268, 40);
        self.emailLoginButton.frame=CGRectMake(10, self.view.frame.size.height-130, 300, 40);
        self.fbLoginButton.frame=CGRectMake(10, self.view.frame.size.height-80, 300,40);
        self.backButton.frame=CGRectMake(10, 20, 50,50);
        self.forgetPswdButton.frame=CGRectMake(10, self.view.frame.size.height-180, 300, 40);
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg.png"]];
    }
    
	// Do any additional setup after loading the view, typically from a nib.
}


-(void)fbLoginButton:(UIButton *)button{
    
    
    if (!(FBSession.activeSession.isOpen)) {
        mainAppDelegate *appDelegate = (mainAppDelegate *)[UIApplication sharedApplication].delegate;
            //            appDelegate.delegate = nil;
        [appDelegate openSessionWithAllowLoginUI:@"Login"];
            //connectWithFB.visible = NO;
    }


}
-(void)forgetPswdButton:(UIButton *)button{
    
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSString *url=@"http://uber.globusapps.com/ws/forgot.php";
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
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return  YES;
}



-(void)emailLoginClick:(UIButton *)button{
    
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:self.emailField.text forKey:PARAM_EMAIL];
    [dictParam setObject:self.passwordField.text forKey:PARAM_PASSWORD];
    [dictParam setObject:[[UserDefaultHelper sharedObject] deviceToken] forKey:PARAM_DEVICE_TOKEN];
    [dictParam setObject:@"alpha" forKey:@"gender"];
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
                 [self presentViewController:parkMyCar animated:YES completion:nil];
             }
             else{
                 [[mainAppDelegate sharedAppDelegate]showToastMessage:[dict objectForKey:WS_MESSAGE]];
             }
         }
         else{
             
         }
     }];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==self.passwordField) {
        self.scrollView.contentOffset=CGPointMake(0, 150);
    }
}           // became first responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField==self.passwordField) {
        self.scrollView.contentOffset=CGPointMake(0, 0);
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
