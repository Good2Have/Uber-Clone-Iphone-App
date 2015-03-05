//
//  HomeVC.m
//  UberValetService
//
//  Created by Globussoft 1 on 10/27/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import "HomeVC.h"
#import "RoundedImageView.h"
#import "UIImageView+WebCache.h"
#import "User.h"

@interface HomeVC ()
{
    UIView *profileView;
  UITextField  *emailLbl;
    UITextField  * nameField;
    UITextField  * contactField;
    UITextField  * pswdField;
    NSString *editOrsave;

}
@end

@implementation HomeVC

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
    self.view.backgroundColor = [UIColor blackColor];

    self.mainsubView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSLog(@"Main sub view frame X=-=- %f \n Y == %f",[UIScreen mainScreen].bounds.origin.x,[UIScreen mainScreen].bounds.origin.y);
    self.mainsubView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainsubView];

    CGFloat hh;
    CGRect frame_b;
     CGRect frame_a;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        hh = 75;
        frame_b = CGRectMake(68, 30, 45, 25);
        frame_a = CGRectMake(145, 30, 45, 25);

            //         frame_b = CGRectMake(self.view.frame.size.width-65, 30, 45, 25);
    }
    else{
        hh = 55;
            //        frame_b = CGRectMake(self.view.frame.size.width-65, 20, 45, 25);
        frame_b = CGRectMake(25, 20, 45, 25);
        frame_a = CGRectMake(130, 20, 150, 25);

    }
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, hh);
    
    self.headerView = [[UIView alloc] initWithFrame:frame];
    self.headerView.backgroundColor = [UIColor darkTextColor];
       [self.mainsubView addSubview:self.headerView];

    frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-50);
    self.contentContainerView = [[UIView alloc] initWithFrame:frame];
    self.contentContainerView.backgroundColor = [UIColor grayColor];
    self.contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.mainsubView addSubview:self.contentContainerView];

    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuButton.frame = frame_b;
    self.menuButton.titleLabel.font = [UIFont systemFontOfSize:9.0f];
    self.menuButton.titleLabel.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
        //self.menuButton.titleLabel.layer.
    [self.menuButton addTarget:self action:@selector(menuButtonClciked:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuButton setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    
    [self.headerView addSubview:self.menuButton];
   self.selectedIndex = 0;
    
    
    self.menuLabel=[[UILabel alloc] init];
    self.menuLabel.frame=frame_a;
    self.menuLabel.backgroundColor=[UIColor clearColor];
    self.menuLabel.textColor=[UIColor whiteColor];
    self.menuLabel.font=[UIFont fontWithName:nil size:30.0];
    self.menuLabel.text=@"Home";
    [self.headerView addSubview:self.menuLabel];
////
//
    [self createMenuTableView];
    self.swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    self.swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.mainsubView addGestureRecognizer:self.swipeGesture];
     self.selectedViewController = [_viewControllers objectAtIndex:0];
   [self updateViewContainer];
    
    if ([UIScreen mainScreen].nativeScale == 2.0f){
        if (self.view.frame.size.height>568.0f) {
            NSLog(@"in iPhone6");
            
          self.menuLabel.frame=frame_a;
            
           
        }
        else if ( self.view.bounds.size.height==568.0f) {
            NSLog(@"in iPhone5");
           self.menuLabel.frame=frame_a;
            
        }
        else{
            NSLog(@"in iPhone4 ");
            self.menuLabel.frame=frame_a;
         
        }
        
    }
    else if ([UIScreen mainScreen].scale > 2.1f)
    {
        NSLog(@"in iPhone 6 plus");
        
        self.menuLabel.frame=frame_a;
        
    }
    else
    {
        NSLog(@"in iPhone4 ");
       
    }

    
    // Do any additional setup after loading the view.
}


-(void) handleSwipeGesture:(UISwipeGestureRecognizer *)swipeGesture{
    
    
    
    if (self.mainsubView.frame.origin.x>100 ) {
        
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height);
            
        }completion:^(BOOL finish){
            self.swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
            
        }];
    }
    else{
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(200, 0, self.view.frame.size.width, self.view.frame.size.height);
            
        }completion:^(BOOL finish){
            
            self.swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
            
        }];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) createMenuTableView{
    
    if (!self.menuTableView) {
        self.selectedIndex = 0;
        self.menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(/*self.view.frame.size.width-200*/0, 130, 200, self.view.frame.size.height) style:UITableViewStylePlain];
           
        
        self.menuTableView.backgroundColor =  [UIColor colorWithRed:(CGFloat)39/255 green:(CGFloat)39/255 blue:(CGFloat)41/255 alpha:1];
        
        self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.menuTableView.delegate = self;
        self.menuTableView.dataSource = self;
        
    }
    else{
        [self.menuTableView reloadData];
    }
    
    [self.view insertSubview:self.menuTableView belowSubview:self.mainsubView];
    
    
    if (!imageVUser) {
        imageVUser = [[RoundedImageView alloc] init];
        imageVUser.frame=CGRectMake(self.view.frame.size.width-260, 20, 60, 60);
        [imageVUser setImageWithURL:[User currentUser].strUrl placeholderImage:[UIImage imageNamed:@"profile.png"]];
        [imageVUser setUserInteractionEnabled:YES];
        [self.view insertSubview:imageVUser belowSubview:self.mainsubView];
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageGesture:)];
        [imageVUser addGestureRecognizer:tapGesture];
    }
    if (!lblUserName) {
        
        lblUserName = [[UILabel alloc] init ];
//                       WithFrame:CGRectMake(self.view.frame.size.width-260,85 , 100, 20)];
        lblUserName.font=[UIFont boldSystemFontOfSize:12];
        lblUserName.textColor=[UIColor whiteColor];
        lblUserName.text=[User currentUser].name;
            //        [self.headerView addSubview:lblUserName];
        [self.view insertSubview:lblUserName belowSubview:self.mainsubView];
    }
        // Rajeev
    
    if ([UIScreen mainScreen].nativeScale == 2.0f){
        if (self.view.frame.size.height>568.0f) {
            NSLog(@"in iPhone6");
            
            imageVUser.frame=CGRectMake(self.view.frame.size.width-300, 20, 60, 60);
            lblUserName.frame=CGRectMake(self.view.frame.size.width-300,85 , 100, 20);

            
        }
        else if ( self.view.bounds.size.height==568.0f) {
            NSLog(@"in iPhone5");
            imageVUser.frame=CGRectMake(self.view.frame.size.width-260, 20, 60, 60);
            lblUserName.frame=CGRectMake(self.view.frame.size.width-260,85 , 100, 20);

        }
        else{
            NSLog(@"in iPhone4 ");
            imageVUser.frame=CGRectMake(self.view.frame.size.width-260, 20, 60, 60);
            lblUserName.frame=CGRectMake(self.view.frame.size.width-260,85 , 100, 20);

            
        }
        
    }
    else if ([UIScreen mainScreen].scale > 2.1f)
    {
        NSLog(@"in iPhone 6 plus");
        
        imageVUser.frame=CGRectMake(self.view.frame.size.width-350, 20, 60, 60);
        lblUserName.frame=CGRectMake(self.view.frame.size.width-350,85 , 100, 20);
    }
    else
    {
        imageVUser.frame=CGRectMake(self.view.frame.size.width-260, 20, 60, 60);
        lblUserName.frame=CGRectMake(self.view.frame.size.width-260,85 , 100, 20);

        NSLog(@"in iPad ");
        
    }
    

   
    
}


-(void)imageGesture:(UITapGestureRecognizer *)tapGesture{
    if (!profileView) {
        profileView=[[UIView alloc] init ];
        profileView.backgroundColor=[UIColor blackColor];
        [self.contentContainerView addSubview:profileView];
        
        
        UIView *headerView=[[UIView alloc] init ];
        headerView.backgroundColor=[UIColor grayColor];
        [profileView addSubview:headerView];
        
        UILabel *titleLabel=[[UILabel alloc]init];
        titleLabel.text=@"Profile";
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [profileView addSubview:titleLabel];

        
        UILabel *nameLbl=[[UILabel alloc]init];
        nameLbl.text=@"Name";
        nameLbl.textColor=[UIColor whiteColor];
        nameLbl.textAlignment = NSTextAlignmentLeft;
        [profileView addSubview:nameLbl];
        
        UILabel *emaillabel=[[UILabel alloc]init];
        emaillabel.text=@"Email";
        emaillabel.textColor=[UIColor whiteColor];
        [emaillabel.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        emaillabel.textAlignment = NSTextAlignmentLeft;
          [profileView addSubview:emaillabel];
        
        UILabel *contactLbl=[[UILabel alloc]init];
       contactLbl.text=@"Contact";
        contactLbl.textColor=[UIColor whiteColor];
        [contactLbl.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        contactLbl.textAlignment = NSTextAlignmentLeft;
        [profileView addSubview:contactLbl];
        
        
        UILabel *pswdLbl=[[UILabel alloc]init];
                pswdLbl.text=@"Password";
        pswdLbl.textColor=[UIColor whiteColor];
        [pswdLbl.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        pswdLbl.textAlignment = NSTextAlignmentLeft;
        [profileView addSubview:pswdLbl];

        
        nameField = [[UITextField alloc] init ];
       
        nameField.font = [UIFont systemFontOfSize:15];
        nameField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
        nameField.enabled=NO;
        nameField.delegate=self;
        nameField.placeholder  = @" Enter your name";
        nameField.autocorrectionType = UITextAutocorrectionTypeNo;
        nameField.keyboardType =UIKeyboardTypeEmailAddress;
        nameField.returnKeyType = UIReturnKeyDone;
        nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        nameField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [profileView addSubview:nameField];
        
        nameField.textColor=[UIColor whiteColor];
        [nameField.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [nameField.layer setBorderWidth: 2.0];
        [nameField.layer setCornerRadius: 5.0];

        
        emailLbl = [[UITextField alloc] init ];
       
        emailLbl.font = [UIFont systemFontOfSize:15];
        emailLbl.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
           emailLbl.enabled=NO;
        emailLbl.delegate=self;
        emailLbl.placeholder  = @" Enter Email Adrress";
        emailLbl.autocorrectionType = UITextAutocorrectionTypeNo;
        emailLbl.keyboardType =UIKeyboardTypeEmailAddress;
        emailLbl.returnKeyType = UIReturnKeyDone;
        emailLbl.clearButtonMode = UITextFieldViewModeWhileEditing;
        emailLbl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        emailLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [profileView addSubview:emailLbl];
        emailLbl.textColor=[UIColor whiteColor];
        [emailLbl.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [emailLbl.layer setBorderWidth: 2.0];
        [emailLbl.layer setCornerRadius: 5.0];
        
        contactField = [[UITextField alloc] init ];
        contactField.font = [UIFont systemFontOfSize:15];
        contactField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
        contactField.enabled=NO;
        contactField.delegate=self;
        contactField.placeholder  = @" Enter your contact";
        contactField.autocorrectionType = UITextAutocorrectionTypeNo;
        contactField.keyboardType =UIKeyboardTypeEmailAddress;
        contactField.returnKeyType = UIReturnKeyDone;
        contactField.clearButtonMode = UITextFieldViewModeWhileEditing;
        contactField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        contactField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [profileView addSubview:contactField];
        
        contactField.textColor=[UIColor whiteColor];
        [contactField.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [contactField.layer setBorderWidth: 2.0];
        [contactField.layer setCornerRadius: 5.0];
        
        
        pswdField = [[UITextField alloc] init ];
        pswdField.font = [UIFont systemFontOfSize:15];
        pswdField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
        pswdField.enabled=NO;
        pswdField.delegate=self;
        pswdField.placeholder  = @" Enter Email Adrress";
        pswdField.autocorrectionType = UITextAutocorrectionTypeNo;
        pswdField.keyboardType =UIKeyboardTypeEmailAddress;
        pswdField.returnKeyType = UIReturnKeyDone;
        pswdField.clearButtonMode = UITextFieldViewModeWhileEditing;
        pswdField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        pswdField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [profileView addSubview:pswdField];
        pswdField.textColor=[UIColor whiteColor];
        [pswdField.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [pswdField.layer setBorderWidth: 2.0];
        [pswdField.layer setCornerRadius: 5.0];

        
        
        UIButton *editButton=[UIButton buttonWithType:UIButtonTypeCustom];
       
        editButton.backgroundColor=[UIColor clearColor];
        [editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [editButton setTitle:@"Edit" forState:UIControlStateNormal];
        [editButton.titleLabel setFont:[UIFont fontWithName:nil size:30]];
        
        [editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:editButton];

        editOrsave=@"edit";
        
        if ([UIScreen mainScreen].nativeScale == 2.0f){
            if (self.view.frame.size.height>568.0f) {
                NSLog(@"in iPhone6");
                profileView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                 headerView.frame=CGRectMake(0, 0, self.view.frame.size.width, 50);
                 titleLabel.frame=CGRectMake(10, 5, 200, 40);
                 nameLbl.frame=CGRectMake(20, 70, 200, 40);
                emaillabel.frame=CGRectMake(20, 180, 200, 40);
                contactLbl.frame=CGRectMake(20, 290, 200, 40);
                pswdLbl.frame=CGRectMake(20, 400, 200, 40);
                nameField.frame=CGRectMake(20, 100, 280, 40);
                emailLbl.frame=CGRectMake(20, 210, 280, 40);
                contactField.frame=CGRectMake(20, 320, 280, 40);
                pswdField.frame=CGRectMake(20, 430, 280, 40);
                editButton.frame=CGRectMake(270, 5, 100, 40);
                

            }
            else if ( self.view.bounds.size.height==568.0f) {
                NSLog(@"in iPhone5");
                profileView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                 headerView.frame=CGRectMake(0, 0, self.view.frame.size.width, 50);
                 titleLabel.frame=CGRectMake(10, 5, 200, 40); 
                 nameLbl.frame=CGRectMake(20, 70, 200, 40);
                emaillabel.frame=CGRectMake(20, 150, 200, 40);
                contactLbl.frame=CGRectMake(20, 220, 200, 40);
                pswdLbl.frame=CGRectMake(20, 290, 200, 40);
                nameField.frame=CGRectMake(20, 100, 280, 40);
                emailLbl.frame=CGRectMake(20, 180, 280, 40);
                contactField.frame=CGRectMake(20, 250, 280, 40);
                pswdField.frame=CGRectMake(20, 320, 280, 40);
                editButton.frame=CGRectMake(220, 5, 100, 40);
                

            }
            else{
                NSLog(@"in iPhone4 ");
                profileView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                 headerView.frame=CGRectMake(0, 0, self.view.frame.size.width, 50);
                 titleLabel.frame=CGRectMake(10, 5, 200, 40);
                 nameLbl.frame=CGRectMake(20, 70, 200, 40);
                emaillabel.frame=CGRectMake(20, 150, 200, 40);
                
                contactLbl.frame=CGRectMake(20, 220, 200, 40);
                
                pswdLbl.frame=CGRectMake(20, 290, 200, 40);
                
                nameField.frame=CGRectMake(20, 100, 280, 40);
                
                emailLbl.frame=CGRectMake(20, 180, 280, 40);
                
                contactField.frame=CGRectMake(20, 250, 280, 40);
                
                pswdField.frame=CGRectMake(20, 320, 280, 40);
                
                editButton.frame=CGRectMake(220, 5, 100, 40);
                

            }
            
        }
        else if ([UIScreen mainScreen].scale > 2.1f)
        {
            NSLog(@"in iPhone 6 plus");
            profileView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
             headerView.frame=CGRectMake(0, 0, self.view.frame.size.width, 50);
             titleLabel.frame=CGRectMake(10, 5, 200, 40);
             nameLbl.frame=CGRectMake(20, 70, 200, 40);
            emaillabel.frame=CGRectMake(20, 170, 200, 40);
            
            contactLbl.frame=CGRectMake(20, 270, 200, 40);
            
            pswdLbl.frame=CGRectMake(20, 370, 200, 40);
            
            nameField.frame=CGRectMake(20, 100, 280, 40);
            
            emailLbl.frame=CGRectMake(20, 200, 280, 40);
            
            contactField.frame=CGRectMake(20, 300, 280, 40);
            
            pswdField.frame=CGRectMake(20, 400, 280, 40);
            
            editButton.frame=CGRectMake(290, 5, 100, 40);
            

        }
        else
        {
            NSLog(@"in iPad ");
            profileView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
             headerView.frame=CGRectMake(0, 0, self.view.frame.size.width, 50);
             titleLabel.frame=CGRectMake(10, 5, 200, 40);
             nameLbl.frame=CGRectMake(20, 70, 200, 40);
            emaillabel.frame=CGRectMake(20, 150, 200, 40);
            
            contactLbl.frame=CGRectMake(20, 220, 200, 40);
            
            pswdLbl.frame=CGRectMake(20, 290, 200, 40);
            
            nameField.frame=CGRectMake(20, 100, 280, 40);
            
            emailLbl.frame=CGRectMake(20, 180, 280, 40);
            
            contactField.frame=CGRectMake(20, 250, 280, 40);
            
            pswdField.frame=CGRectMake(20, 320, 280, 40);
            
            editButton.frame=CGRectMake(220, 5, 100, 40);
            

        }

        
        
        NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
        [dictParam setObject:USER_TYPE forKey:PARAM_IS_DRIVER];
        [dictParam setObject:[User currentUser].client_id forKey:PARAM_USER_ID];
        [[mainAppDelegate sharedAppDelegate]showHUDLoadingView:@""];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:FILE_GET_PROFILE withParamData:dictParam withBlock:^(id response, NSError *error)
         {
             [[mainAppDelegate sharedAppDelegate]hideHUDLoadingView];
             if (response)
             {
                 NSMutableDictionary *dict=[response objectForKey:WS_UBER_ALPHA];
                 if ([[dict objectForKey:WS_STATUS]isEqualToString:WS_STATUS_SUCCESS])
                 {
//                     [[User currentUser]setUser:[dict objectForKey:WS_DETAILS]];
                     [self fillData];
                 }
                 else{
                     [[mainAppDelegate sharedAppDelegate]showToastMessage:[dict objectForKey:WS_MESSAGE]];
                 }
             }
         }];
        [UIView animateWithDuration:.5 animations:^{
            
            self.mainsubView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            
            
        }];
       }else{
           [self.contentContainerView addSubview:profileView];
           [UIView animateWithDuration:.5 animations:^{
               
               self.mainsubView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
               
               
           }];

         }
    }



-(void)textFieldDidBeginEditing:(UITextField *)textField{


}

-(void)textFieldDidEndEditing:(UITextField *)textField{


}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)fillData
{
   nameField.text=[User currentUser].name;
    emailLbl.text=[User currentUser].email;
    contactField.text=[User currentUser].contact;
    pswdField.text=@"xxxxxxxxx";
    /*
     if ([[User currentUser].gender isEqualToString:VALUE_GENDER_MALE] )
     {
     self.imgMaleFemale.image=[UIImage imageNamed:@"sex_selector_male"];
     }
     else{
     self.imgMaleFemale.image=[UIImage imageNamed:@"sex_selector_female"];
     }
     */
}

-(void)editButtonClick:(UIButton *)button{
    if ([editOrsave isEqualToString:@"edit"]) {
        editOrsave=@"save";
        nameField.enabled=YES;
        pswdField.enabled=YES;
        contactField.enabled=YES;
        emailLbl.enabled=YES;
        [button setTitle:@"Save" forState:UIControlStateNormal];

    }else{
    [button setTitle:@"Edit" forState:UIControlStateNormal];
        editOrsave=@"edit";
        nameField.enabled=NO;
        pswdField.enabled=NO;
        contactField.enabled=NO;
        emailLbl.enabled=NO;
        
        NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
        [dictParam setObject:nameField.text forKey:PARAM_NAME];
        [dictParam setObject:contactField.text forKey:PARAM_CONTACT];
        
        [dictParam setObject:USER_TYPE forKey:PARAM_IS_DRIVER];
        [dictParam setObject:[User currentUser].client_id forKey:PARAM_USER_ID];
        
        [dictParam setObject:@"+1" forKey:PARAM_COUNTRY_CODE];
       
        
        [[mainAppDelegate sharedAppDelegate]showHUDLoadingView:@""];
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:FILE_EDIT_PROFILE withParamData:dictParam withBlock:^(id response, NSError *error) {
            [[mainAppDelegate sharedAppDelegate]hideHUDLoadingView];
            if (response) {
                NSMutableDictionary *dict=[response objectForKey:WS_UBER_ALPHA];
                if ([[dict objectForKey:WS_STATUS]isEqualToString:WS_STATUS_SUCCESS]) {
                    [[mainAppDelegate sharedAppDelegate]showToastMessage:[dict objectForKey:WS_MESSAGE]];
                    [[User currentUser]setUser:[dict objectForKey:WS_DETAILS]];
                }else{
                    [[mainAppDelegate sharedAppDelegate]showToastMessage:[dict objectForKey:WS_MESSAGE]];
                }
            }else{
                [[mainAppDelegate sharedAppDelegate]showToastMessage:@"Server error, please try again"];
            }
        }];
    }


 
    }



#pragma mark -
#pragma mark TableView Delegate and DataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section==0) {
    
        return self.viewControllers.count;

}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIColor *firstColor =  [UIColor colorWithRed:(CGFloat)39/255 green:(CGFloat)39/255 blue:(CGFloat)41/255 alpha:1];
    UIColor *secColor = [UIColor colorWithRed:(CGFloat)48/255 green:(CGFloat)48/255 blue:(CGFloat)50/255 alpha:1];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = cell.contentView.frame;
    layer.colors = [NSArray arrayWithObjects:(id)firstColor.CGColor,(id)secColor.CGColor, nil];
    
    [cell.contentView.layer insertSublayer:layer atIndex:0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
}



-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell Identifier";
    profileView.hidden=YES;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        //Check Section

    cell.textLabel.text =  [(UIViewController *)[self.viewControllers objectAtIndex:indexPath.row]title];
    cell.textLabel.font=[UIFont fontWithName:nil size:30.0];
    NSString *cellValue = [(UIViewController *)[self.viewControllers objectAtIndex:indexPath.row]title];
        //adding now
    NSLog(@"cell value %@",cellValue);
    
    if ([cellValue isEqualToString:@"Home"] || [cellValue isEqualToString:@"홈"]) {
        cell.imageView.image=[UIImage imageNamed:@"home.png"];
    }
    else if ([cellValue isEqualToString:@"Topic"] || [cellValue isEqualToString:@"주제"]) {
        cell.imageView.image=[UIImage imageNamed:@"topic.png"];
    }
    else if ([cellValue isEqualToString:@"Friend"] || [cellValue isEqualToString:@"친구"]) {
        cell.imageView.image=[UIImage imageNamed:@"friends.png"];
    }
    else if ([cellValue isEqualToString:@"History"] || [cellValue isEqualToString:@"역사"]) {
        cell.imageView.image=[UIImage imageNamed:@"slideHistory.png"];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     profileView.hidden=YES;
    
    NSLog(@"indexpath row %ld and Count %lu",(long)indexPath.row,(unsigned long)self.viewControllers.count);
    if (indexPath.row+1<self.viewControllers.count) {
        NSString *str=    [[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"];
     if (![str isEqualToString:@"NO"]) {
            //Dismiss Menu TableView with Animation
        [UIView animateWithDuration:.5 animations:^{
            
            self.mainsubView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
               self.swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
            
        }completion:^(BOOL finished){
                //After completion
                //first check if new selected view controller is equals to previously selected view controller
                //self.isSignIn=YES;
            
            
            UIViewController *newViewController = [_viewControllers objectAtIndex:indexPath.row];
//            _selectedSection = indexPath.section;
            _selectedIndex = indexPath.row;
            self.swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;

            [self getSelectedViewControllers:newViewController];
        }];}
    }
    else{
        [[User currentUser]logout];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isLogin"];
        [[NSUserDefaults standardUserDefaults]synchronize];

        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }completion:^(BOOL finished){
            
            
                     [self removeFromParentViewController];

           AppDelegateFirstVC *loginVC=[[AppDelegateFirstVC alloc] init];
                 loginVC.title=@"Login";
           [self presentViewController:loginVC animated:YES completion:nil];
            
        }];
  
    }
    }//Index Path 1 End




-(void) getSelectedViewControllers:(UIViewController *)newViewController{
        // selected new view controller
    UIViewController *oldViewController = _selectedViewController;
    
    if (newViewController != nil) {
        [oldViewController.view removeFromSuperview];
        _selectedViewController = newViewController;
                [self updateViewContainer];
            //Check Delegate assign or not
    }
}

-(void) updateViewContainer{
    self.selectedViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        //NSLog(@"View Height  = %f",self.contentContainerView.frame.size.height);
    self.selectedViewController.view.frame = self.contentContainerView.bounds;
        //    NSLog(@"Selected view frame = %f",self.selectedViewController.view.frame.size.width);
        //NSLog(@"Selected View Height = %f",self.selectedViewController.view.frame.size.height);
    self.menuLabel.text = self.selectedViewController.title;
    NSLog(@"menu label -=- %@",self.menuLabel.text);
    [self.contentContainerView addSubview:self.selectedViewController.view];
}


-(void) menuButtonClciked:(id)sender{
    
    if (self.mainsubView.frame.origin.x>100 ) {
        
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height);
            
        }completion:^(BOOL finish){
            self.swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
            
        }];
    }
    else{
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(200, 0, self.view.frame.size.width, self.view.frame.size.height);
            
        }completion:^(BOOL finish){
            
            self.swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
            
        }];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([UIScreen mainScreen].nativeScale == 2.0f){
        if (self.view.frame.size.height>568.0f) {
            NSLog(@"in iPhone6");
            
            return 70;
            
            
        }
        else if ( self.view.bounds.size.height==568.0f) {
            NSLog(@"in iPhone5");
            return 55;
            

              }
        else{
            
        NSLog(@"in iPhone4 ");
            return 45;
        }
        
    }
    else if ([UIScreen mainScreen].scale > 2.1f)
    {
        NSLog(@"in iPhone 6 plus");
        return 75;
        
    }
    else
    {
        NSLog(@"in iPad ");
        return 45;
        
      
    }
    

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
