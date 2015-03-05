//
//  RegisterVC.m
//  UberValetService
//
//  Created by Globussoft 1 on 10/21/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import "RegisterVC.h"
#import "RoundedImageView.h"
#import "LoginVC.h"
#import "FirstVC.h"
#import "HomeVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UserDefaultHelper.h"
#import "About.h"
#import "LogutVC.h"
#import "PromotionDetail.h"
#import "Settings.h"


@interface RegisterVC ()
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UITextField *emailTxtField;
@property(nonatomic,strong)UILabel *msglabel;
@property(nonatomic,strong)UIButton *backButton;
@property (nonatomic,strong)UITextField *passwordTxtField;
@property(nonatomic,strong)UITextField *nameTxtField;
@property (nonatomic,strong)UITextField *phoneTxtField;
@property(nonatomic,strong) UITextField *countryCodeTxtField;

@property(nonatomic,strong)UIButton *fbsignUpButton;
@property(nonatomic,strong)UIButton *signUpButton;
@end

@implementation RegisterVC

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
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.scrollView.backgroundColor=[UIColor clearColor];
    [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, 700)];
    [self.view addSubview:self.scrollView];
    
    self.imageView = [[RoundedImageView alloc] init ];
    self.imageView.frame=CGRectMake(self.view.frame.size.width-200, 40, 60, 60);
    self.imageView.image=[UIImage imageNamed:@"plus_icon.png"];
    [self.imageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageGestureRecognizer:)];
    [self.imageView addGestureRecognizer:gesture];
    [self.scrollView addSubview:self.imageView];

    self.nameTxtField = [[UITextField alloc] init];
    self.nameTxtField.font = [UIFont systemFontOfSize:15];
//    self.nameTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
    self.nameTxtField.placeholder  = @" Enter Your Name";
    self.nameTxtField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.nameTxtField.keyboardType = UIKeyboardTypeDefault;
    self.nameTxtField.returnKeyType = UIReturnKeyDone;
    self.nameTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.nameTxtField.delegate = self;
    [self.scrollView addSubview:self.nameTxtField];
    
    self.phoneTxtField = [[UITextField alloc] init];
//    self.phoneTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
    self.phoneTxtField.borderStyle = UITextBorderStyleNone;
    self.phoneTxtField.font = [UIFont systemFontOfSize:15];
    self.phoneTxtField.placeholder = @" Enter Phone No";
    self.phoneTxtField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.phoneTxtField.keyboardType = UIKeyboardTypeDefault;
    self.phoneTxtField.returnKeyType = UIReturnKeyDone;
    self.phoneTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.phoneTxtField.delegate = self;
    [self.scrollView addSubview:self.phoneTxtField];

    
    
    self.emailTxtField = [[UITextField alloc] init];
    self.emailTxtField.font = [UIFont systemFontOfSize:15];
//    self.emailTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
    self.emailTxtField.placeholder  = @" Enter Email Address";
    self.emailTxtField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailTxtField.keyboardType = UIKeyboardTypeDefault;
    self.emailTxtField.returnKeyType = UIReturnKeyDone;
    self.emailTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.emailTxtField.delegate = self;
    [self.scrollView addSubview:self.emailTxtField];
    
    self.passwordTxtField = [[UITextField alloc] init];
//    self.passwordTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
    self.passwordTxtField.borderStyle = UITextBorderStyleNone;
    self.passwordTxtField.font = [UIFont systemFontOfSize:15];
    self.passwordTxtField.placeholder = @" Enter Password";
    self.passwordTxtField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTxtField.keyboardType = UIKeyboardTypeDefault;
    self.passwordTxtField.returnKeyType = UIReturnKeyDone;
    self.passwordTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passwordTxtField.delegate = self;
    [self.scrollView addSubview:self.passwordTxtField];
    
    
    self.signUpButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    self.signUpButton.frame=CGRectMake(10, self.view.frame.size.height-110, 300, 40);
//    self.signUpButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"reglog.png"]];
    [self.signUpButton addTarget:self action:@selector(emailLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.signUpButton setTitle:@"Sign Up with Email" forState:UIControlStateNormal];
    [self.scrollView addSubview:self.signUpButton];
    
    
    self.fbsignUpButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    self.fbsignUpButton.frame=CGRectMake(10, self.view.frame.size.height-55, 300,40);
//    self.fbsignUpButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regface.png"]];
    [self.fbsignUpButton addTarget:self action:@selector(fbLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.fbsignUpButton setTitle:@"Sign Up With Facebook" forState:UIControlStateNormal];
//    [self.scrollView addSubview:self.fbsignUpButton];

    self.backButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    self.backButton.frame=CGRectMake(10, 20, 50,50);
    [self.backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [self.scrollView addSubview:self.backButton];

    self.msglabel=[[UILabel alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height-160, 268, 40)];
    self.msglabel.textColor=[UIColor whiteColor];
    self.msglabel.text=@"By Clicking SignUp You are agree to the Condition";
    [self.scrollView addSubview:self.backButton];
    
   //added now
    
    if ([UIScreen mainScreen].nativeScale == 2.0f){
    
        if (self.view.frame.size.height>568) {
            NSLog(@"in iPhone6");
            
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg_750@2x.png"]];
            self.nameTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext@2x.png"]];
            
            self.phoneTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext@2x.png"]];
            
            self.countryCodeTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext@2x.png"]];
            
            self.emailTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext@2x.png"]];
            
            self.passwordTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext@2x.png"]];
            
            self.signUpButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"reglog@2x.png"]];
            
            self.fbsignUpButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regface@2x.png"]];
            
            [self.backButton setImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
            
            //frame setting .
            
            self.imageView.frame = CGRectMake(142, self.view.frame.size.height-550,80, 80);
            
            self.nameTxtField.frame = CGRectMake(55,self.view.frame.size.height-430, 268, 40);
            
            self.phoneTxtField.frame = CGRectMake(55, self.view.frame.size.height-370, 268, 40);
            
            self.countryCodeTxtField.frame =CGRectMake(55, self.view.frame.size.height-370, 60, 40);
            
            self.emailTxtField.frame = CGRectMake(55,self.view.frame.size.height-310, 268, 40);
            
            self.passwordTxtField.frame = CGRectMake(55, self.view.frame.size.height-250, 268, 40);
            
            self.signUpButton.frame=CGRectMake(40, self.view.frame.size.height-160, 300, 40);
            
            self.fbsignUpButton.frame=CGRectMake(40, self.view.frame.size.height-85, 300,40);
            
            self.backButton.frame=CGRectMake(10, 20, 50,50);
            
            self.msglabel=[[UILabel alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height-160, 268, 40)];
            
             self.imageView.frame=CGRectMake(self.view.frame.size.width-230,60,100,100);
            
        }
        else if (self.view.frame.size.height==568){
            
            NSLog(@"in iPhone5");
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg_568.png"]];

            
            self.nameTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext@2x.png"]];
            
            self.phoneTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext@2x.png"]];
            
            self.countryCodeTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext@2x.png"]];
            
            self.emailTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext@2x.png"]];
            
            self.passwordTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext@2x.png"]];
            
            self.signUpButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"reglog@2x.png"]];
            
            self.fbsignUpButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regface@2x.png"]];
            
            [self.backButton setImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
            
            self.imageView.frame= CGRectMake(122, self.view.frame.size.height-450,80, 80);
            
           self.imageView.frame = CGRectMake(105, self.view.frame.size.height-500,80, 80);
            
            self.nameTxtField.frame = CGRectMake(25,self.view.frame.size.height-390, 268, 40);
            
            self.phoneTxtField.frame = CGRectMake(25, self.view.frame.size.height-330, 268, 40);
            
            self.countryCodeTxtField.frame =CGRectMake(25, self.view.frame.size.height-330, 60, 40);
            
            self.emailTxtField.frame = CGRectMake(25,self.view.frame.size.height-270, 268, 40);
            
            self.passwordTxtField.frame = CGRectMake(25, self.view.frame.size.height-210, 268, 40);
            
            self.backButton.frame=CGRectMake(10, 20, 50,50);
            
            self.signUpButton.frame=CGRectMake(10, self.view.frame.size.height-110, 300, 40);
            
            self.fbsignUpButton.frame=CGRectMake(10, self.view.frame.size.height-55, 300,40);
            
            self.backButton.frame=CGRectMake(10, 20, 50,50);
            
            self.msglabel=[[UILabel alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height-160, 268, 40)];
            
             self.imageView.frame=CGRectMake(self.view.frame.size.width-200,50,80,80);
            
        }
        else{
            
            NSLog(@"in iPhone4");
            
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg.png"]];
            
            //            self.imageView.image=[UIImage imageNamed:@"regface.png"];
            
            self.nameTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
            
            self.phoneTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
            
            self.countryCodeTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
            
            self.emailTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
            
            self.passwordTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
            
            self.signUpButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"reglog.png"]];
            
            self.fbsignUpButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regface.png"]];
            
            [self.backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
            

            self.nameTxtField.frame = CGRectMake(25,self.view.frame.size.height-320, 268, 40);
            
            self.phoneTxtField.frame = CGRectMake(25, self.view.frame.size.height-270, 268, 40);
            
            self.countryCodeTxtField.frame =CGRectMake(25, self.view.frame.size.height-270, 60, 40);
            
            self.emailTxtField.frame = CGRectMake(25,self.view.frame.size.height-220, 268, 40);
            
            self.passwordTxtField.frame = CGRectMake(25, self.view.frame.size.height-170, 268, 40);
            
            //            self.backButton.frame=CGRectMake(10, 20, 50,50);
            self.signUpButton.frame=CGRectMake(10, self.view.frame.size.height-110, 300, 40);
            
            self.fbsignUpButton.frame=CGRectMake(10, self.view.frame.size.height-55, 300,40);
            
            self.backButton.frame=CGRectMake(10, 20, 50,50);
            
            self.msglabel=[[UILabel alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height-160, 268, 40)];
            
//             self.imageView.frame=CGRectMake(self.view.frame.size.width-220, 40, 60, 60);
        }
    
    //   }
        
    }
    else if ([UIScreen mainScreen].scale > 2.1f)
    {
        NSLog(@"in iPhone 6 plus");
        self.imageView.frame=CGRectMake(self.view.frame.size.width-250,60,100,100);
        
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg@3x.png"]];
        
        self.nameTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext1@3x.png"]];
        
        self.phoneTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext1@3x.png"]];
        
        self.countryCodeTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext1@3x.png"]];
        
        self.emailTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext1@3x.png"]];
        
        self.passwordTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext1@3x.png"]];
        
        self.signUpButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"reglog@3x.png"]];
        
        self.fbsignUpButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regface1@3x.png"]];
        
        [self.backButton setImage:[UIImage imageNamed:@"back1@3x.png"] forState:UIControlStateNormal];
        
        //frame setting .

        
        self.nameTxtField.frame = CGRectMake(68,self.view.frame.size.height-480, 268, 40);
        
        self.phoneTxtField.frame = CGRectMake(68, self.view.frame.size.height-425, 268, 40);
        
//        self.countryCodeTxtField.frame =CGRectMake(68, self.view.frame.size.height-325, 60, 40);
        
        self.emailTxtField.frame = CGRectMake(68,self.view.frame.size.height-370, 268, 40);
        
        self.passwordTxtField.frame = CGRectMake(68, self.view.frame.size.height-315, 268, 40);
        
        self.signUpButton.frame=CGRectMake(55, self.view.frame.size.height-250, 300, 40);
        
//        self.fbsignUpButton.frame=CGRectMake(55, self.view.frame.size.height-95, 300,40);
        
        self.backButton.frame=CGRectMake(10, 20, 50,50);
        
        self.msglabel=[[UILabel alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height-160, 268, 40)];
        
    }else{
        self.imageView.frame=CGRectMake(self.view.frame.size.width-250,60,100,100);
        
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg@3x.png"]];
        
        self.nameTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext1@3x.png"]];
        
        self.phoneTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext1@3x.png"]];
        
        self.countryCodeTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext1@3x.png"]];
        
        self.emailTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext1@3x.png"]];
        
        self.passwordTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext1@3x.png"]];
        
        self.signUpButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"reglog@3x.png"]];
        
        self.fbsignUpButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regface1@3x.png"]];
        
        [self.backButton setImage:[UIImage imageNamed:@"back1@3x.png"] forState:UIControlStateNormal];
        
        //frame setting .
        
        
        self.nameTxtField.frame = CGRectMake(68,self.view.frame.size.height-480, 268, 40);
        
        self.phoneTxtField.frame = CGRectMake(68, self.view.frame.size.height-425, 268, 40);
        
        //        self.countryCodeTxtField.frame =CGRectMake(68, self.view.frame.size.height-325, 60, 40);
        
        self.emailTxtField.frame = CGRectMake(68,self.view.frame.size.height-370, 268, 40);
        
        self.passwordTxtField.frame = CGRectMake(68, self.view.frame.size.height-315, 268, 40);
        
        self.signUpButton.frame=CGRectMake(55, self.view.frame.size.height-250, 300, 40);
        
        //        self.fbsignUpButton.frame=CGRectMake(55, self.view.frame.size.height-95, 300,40);
        
        self.backButton.frame=CGRectMake(10, 20, 50,50);
        
        self.msglabel=[[UILabel alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height-160, 268, 40)];
    }
}

-(void)backButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)imageGestureRecognizer:(UIGestureRecognizer *)gesture{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    [self  presentViewController:imagePicker animated:YES completion:nil];

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)registerUser
{
//    
   UIImage * img = self.imageView.image;
  
    NSString *strPath=FILE_DRIVER_REGISTER;
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:self.nameTxtField.text forKey:PARAM_NAME];
    [dictParam setObject:self.emailTxtField.text forKey:PARAM_EMAIL];
    [dictParam setObject:self.passwordTxtField.text forKey:PARAM_PASSWORD];
    [dictParam setObject:self.phoneTxtField.text forKey:PARAM_CONTACT];
//    [dictParam setObject:self.countryCodeTxtField.text forKey:PARAM_COUNTRY_CODE];
    [dictParam setObject:DEVICE_TYPE forKey:PARAM_DEVICE_TYPE];
    [dictParam setObject:[[UserDefaultHelper sharedObject] deviceToken] forKey:PARAM_DEVICE_TOKEN];
       [dictParam setObject:[[UserDefaultHelper sharedObject] currentLatitude] forKey:PARAM_LATTITUDE];
       [dictParam setObject:[[UserDefaultHelper sharedObject] currentLongitude] forKey:PARAM_LOGITUDE];
   
    
    [[mainAppDelegate sharedAppDelegate]showHUDLoadingView:@""];
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
    
     [afn getDataFromPath:strPath withParamDataImage:dictParam andImage:img withBlock:^(id response, NSError *error) {
         
         [[mainAppDelegate sharedAppDelegate]hideHUDLoadingView];
         if (response)
         {
             NSMutableDictionary *dict=[response objectForKey:WS_UBER_ALPHA];
             if ([[dict objectForKey:WS_STATUS]isEqualToString:WS_STATUS_SUCCESS])
             {
                 [[User currentUser]setUser:[dict objectForKey:WS_DETAILS]];
                 [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isLogin"];
                 [[NSUserDefaults standardUserDefaults]synchronize];

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
                [[mainAppDelegate sharedAppDelegate]showToastMessage:[dict objectForKey:WS_MESSAGE]];
             }
         }
         else{
          [[mainAppDelegate sharedAppDelegate]showToastMessage:@"Server error, please try again"];
         }
     }];
}


-(void)emailLoginButton:(UIButton *)button{
    
    [self registerUser];
    
//    LoginVC *loginVC=[[LoginVC alloc] init];
//    loginVC.title=@"Login";
//    
//    
//    FirstVC *firstVC=[[FirstVC alloc] init];
//    firstVC.title=@"FirstVC";
//    
//    
//    HomeVC *homeVC=[[HomeVC alloc] init];
//    homeVC.viewControllers = @[firstVC,loginVC];
//
//    [self presentViewController:homeVC animated:YES completion:nil];

}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    int y=0;
    if (textField==self.emailTxtField)
    {
        y=100;
    }
    else if (textField==self.passwordTxtField){
        y=150;
    }
    [self.scrollView setContentOffset:CGPointMake(0, y) animated:YES];
}
/*
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //    [self.lblRefNo resignFirstResponder];
    if (textField==self.txtUserName)
    {
        [self.txtSex becomeFirstResponder];
    }
    else if (textField==self.txtSex){
        [self.txtEmailID becomeFirstResponder];
    }
    else if (textField==self.txtEmailID)
    {
        [self.txtPsw becomeFirstResponder];
    }
    else if (textField==self.txtPsw)
    {
        [self.txtDOB becomeFirstResponder];
    }
    else if (textField==self.txtDOB)
    {
        [self.txtCountryCode becomeFirstResponder];
    }
    else if (textField==self.txtDOB)
    {
        [self.txtMoNo becomeFirstResponder];
    }
    else if (textField==self.txtMoNo)
    {
        [self.txtMoNo resignFirstResponder];
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    //    [self.txtRefNo resignFirstResponder];
    //    [self.lblRefNo resignFirstResponder];
    //    [self.txtRefNo becomeFirstResponder];
    return YES;
}
*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.emailTxtField !=nil&& self.passwordTxtField!=nil) {
        
        [self.emailTxtField resignFirstResponder];
        [self.passwordTxtField resignFirstResponder];
    }
    
    return YES;

}

-(void)fbLoginButton:(UIButton *)button{
    if (!(FBSession.activeSession.isOpen)) {
        mainAppDelegate *appDelegate = (mainAppDelegate *)[UIApplication sharedApplication].delegate;
        //            appDelegate.delegate = nil;
        [appDelegate openSessionWithAllowLoginUI:@"register"];
        //connectWithFB.visible = NO;
    }

}

-(void)emailLoginClick:(NSString *)email{
    /*
     RegisterVC *registerVC=[[RegisterVC alloc] init];
     [self presentViewController:registerVC animated:YES completion:nil];*/
    
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:email forKey:PARAM_EMAIL];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
