//
//  RegisterVC.m
//  UberValetService
//
//  Created by Globussoft 1 on 10/21/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import "RegisterVC.h"
#import "AFHTTPRequestOperationManager.h"
#import "RoundedImageView.h"
#import "LoginVC.h"
#import "FirstVC.h"
#import "ParkMyCarVC.h"
#import "HomeVC.h"

@interface RegisterVC (){
   ParkMyCarVC *parkCarVC;
}
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UITextField *emailTxtField;
@property(nonatomic,strong)UILabel *msglabel;
@property(nonatomic,strong)UIButton *backButton;
@property (nonatomic,strong)UITextField *passwordTxtField;
@property(nonatomic,strong)UITextField *nameTxtField;
@property (nonatomic,strong)UITextField *phoneTxtField;
@property (nonatomic,strong)UITextField *countryCodeTxtField;

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
    
//    self.imageView = [[RoundedImageView alloc] init ];
////    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
////    self.imageView.clipsToBounds = YES;
//    [self.imageView setUserInteractionEnabled:YES];
//    self.imageView.image=[UIImage imageNamed:@"profile.png"];
//    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageGestureRecognizer:)];
//    [self.imageView addGestureRecognizer:gesture];
//    [self.scrollView addSubview:self.imageView];

    self.imageView = [[RoundedImageView alloc] init];
    self.imageView.frame=CGRectMake(self.view.frame.size.width-260, 20, 60, 60);
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageGestureRecognizer:)];
    [self.imageView setUserInteractionEnabled:YES];

    [self.imageView addGestureRecognizer:gesture];
    self.imageView.image=[UIImage imageNamed:@"plus_icon.png"];
    [self.scrollView addSubview:self.imageView];
    
    
    self.nameTxtField = [[UITextField alloc] init ];
//                         WithFrame:CGRectMake(30,self.view.frame.size.height-340, 268, 40)];
    self.nameTxtField.font = [UIFont systemFontOfSize:15];
    self.nameTxtField.text=@"sahu";
    self.nameTxtField.placeholder  = @" Enter Your Name";
    self.nameTxtField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.nameTxtField.keyboardType = UIKeyboardTypeDefault;
    self.nameTxtField.returnKeyType = UIReturnKeyDone;
    self.nameTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.nameTxtField.delegate = self;
    [self.scrollView addSubview:self.nameTxtField];
    
    self.phoneTxtField = [[UITextField alloc] init ];
    self.phoneTxtField.text =@"1234";
//                          WithFrame:CGRectMake(90, self.view.frame.size.height-290, 208, 40)];
//    self.phoneTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
       self.phoneTxtField.borderStyle = UITextBorderStyleNone;
    self.phoneTxtField.font = [UIFont systemFontOfSize:15];
    self.phoneTxtField.placeholder = @" Enter Phone No";
    self.phoneTxtField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.phoneTxtField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTxtField.returnKeyType = UIReturnKeyDone;
    self.phoneTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.phoneTxtField.delegate = self;
    [self.scrollView addSubview:self.phoneTxtField];

    
    self.countryCodeTxtField = [[UITextField alloc] init ];
    self.countryCodeTxtField.text=@"+91";
//                                WithFrame:CGRectMake(30, self.view.frame.size.height-290, 60, 40)];
//    self.countryCodeTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
    self.countryCodeTxtField.borderStyle = UITextBorderStyleNone;
    self.countryCodeTxtField.font = [UIFont systemFontOfSize:15];
    self.countryCodeTxtField.placeholder = @"Code";
    self.countryCodeTxtField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.countryCodeTxtField.keyboardType = UIKeyboardTypeDefault;
    self.countryCodeTxtField.returnKeyType = UIReturnKeyDone;
    self.countryCodeTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.countryCodeTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.countryCodeTxtField.delegate = self;
    [self.scrollView addSubview:self.countryCodeTxtField];

    
    
    self.emailTxtField = [[UITextField alloc] init ];
    self.emailTxtField.font = [UIFont systemFontOfSize:15];
    self.emailTxtField.placeholder  = @" Enter Email Adrress";
    self.emailTxtField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailTxtField.keyboardType = UIKeyboardTypeDefault;
    self.emailTxtField.returnKeyType = UIReturnKeyDone;
    self.emailTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.emailTxtField.delegate = self;
    [self.scrollView addSubview:self.emailTxtField];
    
    self.passwordTxtField = [[UITextField alloc] init ];
    self.passwordTxtField.text=@"1234";
//                             WithFrame:CGRectMake(30, self.view.frame.size.height-190, 268, 40)];
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
//         self.signUpButton.frame=CGRectMake(10, self.view.frame.size.height-110, 300, 40);
//    self.signUpButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"reglog.png"]];
    [self.signUpButton addTarget:self action:@selector(emailLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.signUpButton setTitle:@"Sign Up with Email" forState:UIControlStateNormal];
    [self.scrollView addSubview:self.signUpButton];
    
    
    self.fbsignUpButton=[UIButton buttonWithType:UIButtonTypeCustom];
//     self.fbsignUpButton.frame=CGRectMake(10, self.view.frame.size.height-55, 300,40);
//    self.fbsignUpButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regface.png"]];
    [self.fbsignUpButton addTarget:self action:@selector(fbLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.fbsignUpButton setTitle:@"Sign Up With Facebook" forState:UIControlStateNormal];
    [self.scrollView addSubview:self.fbsignUpButton];

    self.backButton=[UIButton buttonWithType:UIButtonTypeCustom];
//       self.backButton.frame=CGRectMake(10, 20, 50,50);
    [self.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [self.scrollView addSubview:self.backButton];

    self.msglabel=[[UILabel alloc] init ];
//                   WithFrame:CGRectMake(30, self.view.frame.size.height-160, 268, 40)];
    self.msglabel.textColor=[UIColor whiteColor];
    self.msglabel.text=@"By Clicking SignUp You are agree to the Condition";
    [self.scrollView addSubview:self.backButton];
    
    self.pickCountryCode=[[UIPickerView alloc] init];
//WithFrame:CGRectMake(20, self.view.frame.size.height-200, self.view.frame.size.width-40, 200) ];
    self.pickCountryCode.delegate=self;
    self.pickCountryCode.dataSource=self;
    [self.pickCountryCode.layer setBorderColor: (__bridge CGColorRef)([UIColor blueColor])] ;
    [self.pickCountryCode.layer setBorderWidth:5.0];
    self.pickCountryCode.backgroundColor=[UIColor whiteColor];
    self.pickCountryCode.hidden=YES;
    [self.view addSubview:self.pickCountryCode];
    
    arrCountry=[[mainAppDelegate sharedAppDelegate]getCountry];
    [self.pickCountryCode reloadAllComponents];

    
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
            
        self.phoneTxtField.frame = CGRectMake(120, self.view.frame.size.height-370, 208, 40);
            
        self.countryCodeTxtField.frame =CGRectMake(55, self.view.frame.size.height-370, 60, 40);
            
        self.emailTxtField.frame = CGRectMake(55,self.view.frame.size.height-310, 268, 40);
            
        self.passwordTxtField.frame = CGRectMake(55, self.view.frame.size.height-250, 268, 40);
            
        self.signUpButton.frame=CGRectMake(40, self.view.frame.size.height-160, 300, 40);
            
        self.fbsignUpButton.frame=CGRectMake(40, self.view.frame.size.height-85, 300,40);
            
        self.backButton.frame=CGRectMake(10, 20, 50,50);
            
        self.msglabel=[[UILabel alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height-160, 268, 40)];
            
            

        }
        else if (self.view.frame.size.height==568){
        
         NSLog(@"in iPhone5");
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg_568.png"]];
//            self.imageView.image=[UIImage imageNamed:@"regface@2x.png"];
            
            self.nameTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext@2x.png"]];
            
            self.phoneTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext@2x.png"]];
            
            self.countryCodeTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext@2x.png"]];
            
            self.emailTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext@2x.png"]];
            
            self.passwordTxtField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext@2x.png"]];
            
            self.signUpButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"reglog@2x.png"]];
            
            self.fbsignUpButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regface@2x.png"]];
            
            [self.backButton setImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
            
//            self.imageView = [[RoundedImageView alloc] initWithFrame:CGRectMake(122, self.view.frame.size.height-450,80, 80)];
            
            self.imageView.frame = CGRectMake(105, self.view.frame.size.height-500,80, 80);
            
            self.nameTxtField.frame = CGRectMake(25,self.view.frame.size.height-390, 268, 40);
            
            self.phoneTxtField.frame = CGRectMake(85, self.view.frame.size.height-330, 208, 40);
            
            self.countryCodeTxtField.frame =CGRectMake(25, self.view.frame.size.height-330, 60, 40);
            
            self.emailTxtField.frame = CGRectMake(25,self.view.frame.size.height-270, 268, 40);
            
            self.passwordTxtField.frame = CGRectMake(25, self.view.frame.size.height-210, 268, 40);
            
            self.backButton.frame=CGRectMake(10, 20, 50,50);
            
            self.signUpButton.frame=CGRectMake(10, self.view.frame.size.height-110, 300, 40);
            
            self.fbsignUpButton.frame=CGRectMake(10, self.view.frame.size.height-55, 300,40);
            
            self.backButton.frame=CGRectMake(10, 20, 50,50);
            
            self.msglabel=[[UILabel alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height-160, 268, 40)];


            
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
            
              self.imageView.frame = CGRectMake(105, self.view.frame.size.height-450,100, 100);
            self.nameTxtField.frame = CGRectMake(25,self.view.frame.size.height-320, 268, 40);
            
            self.phoneTxtField.frame = CGRectMake(85, self.view.frame.size.height-270, 208, 40);
            
            self.countryCodeTxtField.frame =CGRectMake(25, self.view.frame.size.height-270, 60, 40);
            
            self.emailTxtField.frame = CGRectMake(25,self.view.frame.size.height-220, 268, 40);
            
            self.passwordTxtField.frame = CGRectMake(25, self.view.frame.size.height-170, 268, 40);
            
//            self.backButton.frame=CGRectMake(10, 20, 50,50);
            self.signUpButton.frame=CGRectMake(10, self.view.frame.size.height-110, 300, 40);
            
            self.fbsignUpButton.frame=CGRectMake(10, self.view.frame.size.height-55, 300,40);
            
            self.backButton.frame=CGRectMake(10, 20, 50,50);
            
            self.msglabel=[[UILabel alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height-160, 268, 40)];


        }
        
    }
    else if ([UIScreen mainScreen].scale > 2.1f)
    {
        NSLog(@"in iPhone 6 plus");
        
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
        
        self.imageView.frame = CGRectMake(152, self.view.frame.size.height-550,100, 100);
        
        self.nameTxtField.frame = CGRectMake(68,self.view.frame.size.height-380, 268, 40);
        
        self.phoneTxtField.frame = CGRectMake(128, self.view.frame.size.height-325, 208, 40);
        
        self.countryCodeTxtField.frame =CGRectMake(68, self.view.frame.size.height-325, 60, 40);
        
        self.emailTxtField.frame = CGRectMake(68,self.view.frame.size.height-270, 268, 40);
        
        self.passwordTxtField.frame = CGRectMake(68, self.view.frame.size.height-215, 268, 40);
        
        self.signUpButton.frame=CGRectMake(55, self.view.frame.size.height-150, 300, 40);
        
        self.fbsignUpButton.frame=CGRectMake(55, self.view.frame.size.height-95, 300,40);
        
        self.backButton.frame=CGRectMake(10, 20, 50,50);
        
        self.msglabel=[[UILabel alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height-160, 268, 40)];

    }else{
    
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
        
        self.imageView.frame = CGRectMake(105, self.view.frame.size.height-450,100, 100);
        
        self.nameTxtField.frame = CGRectMake(25,self.view.frame.size.height-320, 268, 40);
        
        self.phoneTxtField.frame = CGRectMake(85, self.view.frame.size.height-270, 208, 40);
        
        self.countryCodeTxtField.frame =CGRectMake(25, self.view.frame.size.height-270, 60, 40);
        
        self.emailTxtField.frame = CGRectMake(25,self.view.frame.size.height-220, 268, 40);
        
        self.passwordTxtField.frame = CGRectMake(25, self.view.frame.size.height-170, 268, 40);
        
            //            self.backButton.frame=CGRectMake(10, 20, 50,50);
        self.signUpButton.frame=CGRectMake(10, self.view.frame.size.height-110, 300, 40);
        
        self.fbsignUpButton.frame=CGRectMake(10, self.view.frame.size.height-55, 300,40);
        
        self.backButton.frame=CGRectMake(10, 20, 50,50);
        
        self.msglabel=[[UILabel alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height-160, 268, 40)];
        

    }
//        //
    
    
    
    
    // Do any additional setup after loading the view.
}
-(void)backButtonAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark - UIImagePickerController
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

-(void)emailLoginButton:(UIButton *)button{

    if (self.nameTxtField.text.length==0 || self.emailTxtField.text.length==0 || self.passwordTxtField.text.length==0 || self.phoneTxtField.text.length==0 )
    {
        [[UtilityClass sharedObject]showAlertWithTitle:@"Error!" andMessage:@"Plase enter all detail."];
        return;
        
    }
    
    if (![[UtilityClass sharedObject]isValidEmailAddress:self.emailTxtField.text])
    {
        [[UtilityClass sharedObject]showAlertWithTitle:@"Error!" andMessage:@"Plase enter valid email id."];
        return;
    }
    
    
   [self registerUser];
    
}

-(void)registerUser
{

    UIImage *im=self.imageView.image;

    NSString *strPath=FILE_CLIENT_REGISTER;
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:self.nameTxtField.text forKey:PARAM_NAME];
    [dictParam setObject:self.emailTxtField.text forKey:PARAM_EMAIL];
    [dictParam setObject:@"alpha" forKey:@"gender"];
    [dictParam setObject:self.passwordTxtField.text forKey:PARAM_PASSWORD];
    [dictParam setObject:self.phoneTxtField.text forKey:PARAM_CONTACT];
    [dictParam setObject:self.countryCodeTxtField.text forKey:PARAM_COUNTRY_CODE];
    [dictParam setObject:DEVICE_TYPE forKey:PARAM_DEVICE_TYPE];
    [dictParam setObject:[[UserDefaultHelper sharedObject] deviceToken] forKey:PARAM_DEVICE_TOKEN];
    [dictParam setObject:[[UserDefaultHelper sharedObject] currentLatitude] forKey:PARAM_LATTITUDE];
    [dictParam setObject:[[UserDefaultHelper sharedObject] currentLongitude] forKey:PARAM_LOGITUDE];
    
    [[mainAppDelegate sharedAppDelegate]showHUDLoadingView:@""];
    
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];

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
                 
                 if (!parkCarVC) {
                     parkCarVC=[[ParkMyCarVC alloc] init];
                 }
                 
                 [self presentViewController:parkCarVC animated:YES completion:nil];
                 
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

#pragma mark -
#pragma mark - UIPickerView Delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [arrCountry count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Country *contry=[arrCountry objectAtIndex:row];
    NSString *strTitle=[NSString stringWithFormat:@"%@ - %@",contry.phoneCode,contry.name];
    return strTitle;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedCountry=[arrCountry objectAtIndex:row];
    self.countryCodeTxtField.text=selectedCountry.phoneCode;
    self.pickCountryCode.hidden=YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if( textField == self.phoneTxtField )
    {
        UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        numberToolbar.barStyle = UIBarStyleBlackTranslucent;
        numberToolbar.items = [NSArray arrayWithObjects:
                               [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonAction)],nil];
        textField.inputAccessoryView = numberToolbar;
    }

    return YES;
}

- (void)doneButtonAction
{
    if (self.phoneTxtField.text.length==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Phone Number should not be blank " delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    else
        [self.phoneTxtField resignFirstResponder];
}

-(void)fbLoginButton:(UIButton *)button{

    NSLog(@"connect with facebook button clicked.");
      [[mainAppDelegate sharedAppDelegate]showHUDLoadingView:@""];
    if (!(FBSession.activeSession.isOpen)) {
        mainAppDelegate *appDelegate = (mainAppDelegate *)[UIApplication sharedApplication].delegate;
            //            appDelegate.delegate = nil;
        [appDelegate openSessionWithAllowLoginUI:@"register"];
            //connectWithFB.visible = NO;
    }
  [[mainAppDelegate sharedAppDelegate]hideHUDLoadingView];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
        //Keyboard becomes visible
    //resize
    if (textField==self.countryCodeTxtField) {
        self.pickCountryCode.hidden=NO;
        
    }
    if (textField==self.phoneTxtField && self.countryCodeTxtField==0) {
        self.pickCountryCode.hidden=NO;

    }
    
    if (textField==self.emailTxtField||textField==self.passwordTxtField||textField==self.phoneTxtField||textField==self.countryCodeTxtField) {
        self.scrollView.contentOffset=CGPointMake(0, 150);
    }
        //    scrollView.contentOffset=CGPointMake(0,textField.frame.origin.y);
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField==self.emailTxtField||textField==self.passwordTxtField||textField==self.phoneTxtField||textField==self.countryCodeTxtField) {
        self.scrollView.contentOffset=CGPointMake(0, 0);
    }

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
