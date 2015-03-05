//
//  CarDetail.m
//  UberValetService
//
//  Created by Globussoft 1 on 11/25/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import "CarDetail.h"
#import "User.h"

@interface CarDetail ()

@end

@implementation CarDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.scrollView.delegate=self;
        //    if ( self.view.bounds.size.height>500) {
    self.scrollView.backgroundColor=[UIColor clearColor];
    [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, 700)];
    [self.view addSubview:self.scrollView];

    
    
    self.carNumber = [[UITextField alloc] init ];
    self.carNumber.font = [UIFont systemFontOfSize:15];
    self.carNumber.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
    self.carNumber.placeholder  = @" Enter Car Plate Number";
    self.carNumber.autocorrectionType = UITextAutocorrectionTypeNo;
    self.carNumber.keyboardType = UIKeyboardTypeDefault;
    self.carNumber.returnKeyType = UIReturnKeyDone;
    self.carNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.carNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.carNumber.delegate = self;
    [self.scrollView addSubview:self.carNumber];

    
    self.carColor = [[UITextField alloc] init ];
    self.carColor.font = [UIFont systemFontOfSize:15];
    self.carColor.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
    self.carColor.placeholder  = @" Enter Car Color";
    self.carColor.autocorrectionType = UITextAutocorrectionTypeNo;
    self.carColor.keyboardType = UIKeyboardTypeDefault;
    self.carColor.returnKeyType = UIReturnKeyDone;
    self.carColor.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.carColor.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.carColor.delegate = self;
    [self.scrollView addSubview:self.carColor];

    
    self.carModel = [[UITextField alloc] init ];
    self.carModel.font = [UIFont systemFontOfSize:15];
    self.carModel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
    self.carModel.placeholder  = @" Enter Car Model";
    self.carModel.autocorrectionType = UITextAutocorrectionTypeNo;
    self.carModel.keyboardType = UIKeyboardTypeDefault;
    self.carModel.returnKeyType = UIReturnKeyDone;
    self.carModel.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.carModel.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.carModel.delegate = self;
    [self.scrollView addSubview:self.carModel];
    
    self.yearOfpurchase = [[UITextField alloc] init ];
    self.yearOfpurchase.font = [UIFont systemFontOfSize:15];
    self.yearOfpurchase.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
    self.yearOfpurchase.placeholder  = @" Enter year of Purchase";
    self.yearOfpurchase.autocorrectionType = UITextAutocorrectionTypeNo;
    self.yearOfpurchase.keyboardType = UIKeyboardTypeDefault;
    self.yearOfpurchase.returnKeyType = UIReturnKeyDone;
    self.yearOfpurchase.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.yearOfpurchase.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.yearOfpurchase.delegate = self;
    [self.scrollView addSubview:self.yearOfpurchase];

    self.carImage = [[UIImageView alloc] init];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 200, 100, 100)];
    [self.datePicker setDatePickerMode: UIDatePickerModeDate];
    [self.datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor grayColor];
    self.yearOfpurchase.inputView=self.datePicker;

    
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageGestureRecognizer:)];
    [self.carImage setUserInteractionEnabled:YES];
    [self.carImage addGestureRecognizer:gesture];
    self.carImage.image=[UIImage imageNamed:@"plus_icon.png"];
//    [self.scrollView addSubview:self.carImage];
    
    self.submitDetailBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.submitDetailBtn.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regface.png"]];
    [self.submitDetailBtn addTarget:self action:@selector(submitDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.submitDetailBtn setTitle:@"Save Car Detail" forState:UIControlStateNormal];
    [self.scrollView addSubview:self.submitDetailBtn];
    
    if ([UIScreen mainScreen].nativeScale == 2.0f){
        if (self.view.frame.size.height>568.0f) {
            NSLog(@"in iPhone6");
            
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg_750@2x.png"]];
            self.carImage.frame=CGRectMake(142, self.view.frame.size.height-550,110, 110);
            self.yearOfpurchase.frame=CGRectMake(55, self.view.frame.size.height-250, 268, 40);
            self.carModel.frame=CGRectMake(55,self.view.frame.size.height-310, 268, 40);
            self.carColor.frame=CGRectMake(55, self.view.frame.size.height-370, 268, 40);
            self.carNumber.frame=CGRectMake(55,self.view.frame.size.height-430, 268, 40);
            self.submitDetailBtn.frame=CGRectMake(25, self.view.frame.size.height-130, 268, 40);

        }
        else if ( self.view.bounds.size.height==568.0f) {
            NSLog(@"in iPhone5");
           
//            self.imageView.frame = CGRectMake(105, self.view.frame.size.height-500,80, 80);
            
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg_568.png"]];
            self.carImage.frame=CGRectMake(self.view.frame.size.width-200, 30, 90, 90);
            self.yearOfpurchase.frame=CGRectMake(25, self.view.frame.size.height-210, 268, 40);
            self.carModel.frame=CGRectMake(25,self.view.frame.size.height-270, 268, 40);
            self.carColor.frame=CGRectMake(25, self.view.frame.size.height-330, 268, 40);
            self.carNumber.frame=CGRectMake(25,self.view.frame.size.height-390, 268, 40);
             self.submitDetailBtn.frame=CGRectMake(25, self.view.frame.size.height-130, 268, 40);
            
        }
        else{
            NSLog(@"in iPhone4 ");

         self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg.png"]];
            self.carImage.frame=CGRectMake(self.view.frame.size.width-200, 20,80, 80);
            self.yearOfpurchase.frame=CGRectMake(25, self.view.frame.size.height-175, 268, 40);
            self.carModel.frame=CGRectMake(25, self.view.frame.size.height-325, 268, 40);
            self.carColor.frame=CGRectMake(25, self.view.frame.size.height-275, 268, 40);
            self.carNumber.frame=CGRectMake(25,self.view.frame.size.height-225, 268, 40);
            self.submitDetailBtn.frame=CGRectMake(25, self.view.frame.size.height-110, 268, 40);
        }
        
    }
    else if ([UIScreen mainScreen].scale > 2.1f)
    {
        NSLog(@"in iPhone 6 plus");
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg@3x.png"]];
        self.carImage.frame=CGRectMake(self.view.frame.size.width-290, 50, 140, 140);
        self.yearOfpurchase.frame=CGRectMake(68,self.view.frame.size.height-450, 268, 40);
        self.carModel.frame=CGRectMake(68, self.view.frame.size.height-395, 268, 40);
        self.carColor.frame=CGRectMake(68,self.view.frame.size.height-340, 268, 40);
        self.carNumber.frame=CGRectMake(68, self.view.frame.size.height-285, 268, 40);
        self.submitDetailBtn.frame=CGRectMake(68, self.view.frame.size.height-190, 268, 40);
        
        
    }
    else
    {
        NSLog(@"in iPhone4 ");
       self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg.png"]];
        self.carImage.frame=CGRectMake(self.view.frame.size.width-200, 20,80, 80);
        self.yearOfpurchase.frame=CGRectMake(25, self.view.frame.size.height-175, 268, 40);
        self.carModel.frame=CGRectMake(25, self.view.frame.size.height-325, 268, 40);
        self.carColor.frame=CGRectMake(25, self.view.frame.size.height-275, 268, 40);
        self.carNumber.frame=CGRectMake(25,self.view.frame.size.height-225, 268, 40);
        self.submitDetailBtn.frame=CGRectMake(25, self.view.frame.size.height-110, 268, 40);
    }

    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    
    [dictParam setObject:[User currentUser].client_id forKey:PARAM_CLIENT_ID];
    
    
    [[mainAppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
    [afn getDataFromPath:FILE_CLIENT_CAR_Detail withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         [[mainAppDelegate sharedAppDelegate]hideHUDLoadingView];
         if (response)
         {
                if ([[response objectForKey:WS_STATUS]isEqualToString:WS_STATUS_SUCCESS])
             {
                 NSDictionary *dict=[response objectForKey:@"details"];
//                 self.carNumber.text=[dict valueForKey:@""];
                 self.carModel.text=[dict valueForKey:@"car_model"];
                 self.carNumber.text=[dict valueForKey:@"car_number_plate"];
                 self.carColor.text=[dict valueForKey:@"car_color"];
                 self.yearOfpurchase.text=[dict valueForKey:@"year_of_registration"];
             }
             else{
                 [[mainAppDelegate sharedAppDelegate]showToastMessage:[response objectForKey:WS_MESSAGE]];
             }
         }
         else{
             
         }
     }];
 
    // Do any additional setup after loading the view.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==self.yearOfpurchase) {
        
//        self.yearOfpurchase.inputView.hidden=YES;
    }
    self.scrollView.contentOffset=CGPointMake(0, 200);
}

-(void)onDatePickerValueChanged:(UIDatePicker *)datePicker
{
   NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:datePicker.date];
    self.yearOfpurchase.text=dateString;
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    self.datePicker.hidden=YES;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
  self.scrollView.contentOffset=CGPointMake(0, 0);
    self.datePicker.hidden=YES;
}

-(void)submitDetailBtnClick:(UIButton *)button{
//    self.yearOfpurchase.inputView.hidden=YES;
//    self.scrollView.contentOffset=CGPointMake(0, 0);
    self.datePicker.hidden=YES;
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:[User currentUser].client_id forKey:@"client_id"];
    [dictParam setObject:self.carModel.text forKey:@"car_model"];
    [dictParam setObject:self.carColor.text forKey:@"car_color"];
    [dictParam setObject:self.carNumber.text forKey:@"car_number_plate"];
    [dictParam setObject:self.yearOfpurchase.text forKey:@"year_of_registration"];
    
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
    [afn getDataFromPath:FILE_CAR_Detail withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         [[mainAppDelegate sharedAppDelegate]hideHUDLoadingView];
         if (response)
         {
//             NSMutableDictionary *dict=[response objectForKey:@""];
             if ([[response objectForKey:WS_STATUS]isEqualToString:WS_STATUS_SUCCESS])
             {
                  [[mainAppDelegate sharedAppDelegate]showToastMessage:[response objectForKey:WS_MESSAGE]];
            
            }
             else{
                 [[mainAppDelegate sharedAppDelegate]showToastMessage:[response objectForKey:WS_MESSAGE]];
             }
             
             NSLog(@"%@",response);
         }
         else{
             
         }
     }];

}

#pragma mark -
#pragma mark UIImagePickerDelegate

-(void)imageGestureRecognizer:(UIImageView *)img{

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    [self  presentViewController:imagePicker animated:YES completion:nil];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.carImage.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
