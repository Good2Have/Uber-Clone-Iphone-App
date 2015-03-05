//
//  PaymentDetail.m
//  UberValetService
//
//  Created by Globussoft 1 on 11/25/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import "PaymentDetail.h"

@interface PaymentDetail ()

@end

@implementation PaymentDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.scrollView.delegate=self;
        //    if ( self.view.bounds.size.height>500) {
    self.scrollView.backgroundColor=[UIColor clearColor];
    [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, 700)];
    [self.view addSubview:self.scrollView];
    
    
    
    self.cardNumber = [[UITextField alloc] init ];
    self.cardNumber.font = [UIFont systemFontOfSize:15];
    self.cardNumber.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
    self.cardNumber.placeholder  = @" Enter Card Code Number";
    self.cardNumber.autocorrectionType = UITextAutocorrectionTypeNo;
    self.cardNumber.keyboardType = UIKeyboardTypeDefault;
    self.cardNumber.returnKeyType = UIReturnKeyDone;
    self.cardNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.cardNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.cardNumber.delegate = self;
        //    self.carNumber.text=@"Hdhcvjbk578@gmail.com";
    [self.scrollView addSubview:self.cardNumber];
    
    
    self.banKName = [[UITextField alloc] init ];
    self.banKName.font = [UIFont systemFontOfSize:15];
    self.banKName.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
    self.banKName.placeholder  = @" Enter Name";
    self.banKName.autocorrectionType = UITextAutocorrectionTypeNo;
    self.banKName.keyboardType = UIKeyboardTypeDefault;
    self.banKName.returnKeyType = UIReturnKeyDone;
    self.banKName.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.banKName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.banKName.delegate = self;
        //    self.carColor.text=@"Hdhcvjbk578@gmail.com";
    [self.scrollView addSubview:self.banKName];
    
    
    self.validity = [[UITextField alloc] init ];
    self.validity.font = [UIFont systemFontOfSize:15];
    self.validity.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
    self.validity.placeholder  = @" Enter your Validity";
    self.validity.autocorrectionType = UITextAutocorrectionTypeNo;
    self.validity.keyboardType = UIKeyboardTypeDefault;
    self.validity.returnKeyType = UIReturnKeyDone;
    self.validity.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.validity.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.validity.delegate = self;
        //    self.carModel.text=@"Hdhcvjbk578@gmail.com";
    [self.scrollView addSubview:self.validity];
    
    self.cardType = [[UITextField alloc] init ];
    self.cardType.font = [UIFont systemFontOfSize:15];
    self.cardType.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regtext.png"]];
    self.cardType.placeholder  = @" Enter card Type";
    self.cardType.autocorrectionType = UITextAutocorrectionTypeNo;
    self.cardType.keyboardType = UIKeyboardTypeDefault;
    self.cardType.returnKeyType = UIReturnKeyDone;
    self.cardType.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.cardType.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.cardType.delegate = self;
        //    self.yearOfpurchase.text=@"Hdhcvjbk578@gmail.com";
    [self.scrollView addSubview:self.cardType];
    
    
    self.submitDetailBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.submitDetailBtn.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regface.png"]];
    [self.submitDetailBtn addTarget:self action:@selector(submitDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.submitDetailBtn setTitle:@"Save Card Detail" forState:UIControlStateNormal];
    [self.scrollView addSubview:self.submitDetailBtn];
    
    if ([UIScreen mainScreen].nativeScale == 2.0f){
        if (self.view.frame.size.height>568.0f) {
            NSLog(@"in iPhone6");
            
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg_750@2x.png"]];
            
            self.cardType.frame=CGRectMake(55, self.view.frame.size.height-300, 268, 40);
            self.validity.frame=CGRectMake(55,self.view.frame.size.height-360, 268, 40);
            self.banKName.frame=CGRectMake(55, self.view.frame.size.height-420, 268, 40);
            self.cardNumber.frame=CGRectMake(55,self.view.frame.size.height-480, 268, 40);
            self.submitDetailBtn.frame=CGRectMake(55, self.view.frame.size.height-180, 268, 40);
            
        }
        else if ( self.view.bounds.size.height==568.0f) {
            NSLog(@"in iPhone5");
            
                //            self.imageView.frame = CGRectMake(105, self.view.frame.size.height-500,80, 80);
            
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg_568.png"]];
            
            self.cardType.frame=CGRectMake(25, self.view.frame.size.height-260, 268, 40);
            self.validity.frame=CGRectMake(25,self.view.frame.size.height-320, 268, 40);
            self.banKName.frame=CGRectMake(25, self.view.frame.size.height-380, 268, 40);
            self.cardNumber.frame=CGRectMake(25,self.view.frame.size.height-440, 268, 40);
            self.submitDetailBtn.frame=CGRectMake(25, self.view.frame.size.height-180, 268, 40);
            
        }
        else{
            NSLog(@"in iPhone4 ");
            
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg.png"]];
           self.cardType.frame=CGRectMake(25, self.view.frame.size.height-225, 268, 40);
            self.validity.frame=CGRectMake(25, self.view.frame.size.height-375, 268, 40);
            self.banKName.frame=CGRectMake(25, self.view.frame.size.height-325, 268, 40);
            self.cardNumber.frame=CGRectMake(25,self.view.frame.size.height-275, 268, 40);
            self.submitDetailBtn.frame=CGRectMake(25, self.view.frame.size.height-140, 268, 40);
        }
        
    }
    else if ([UIScreen mainScreen].scale > 2.1f)
    {
        NSLog(@"in iPhone 6 plus");
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg@3x.png"]];
        
        self.cardType.frame=CGRectMake(68,self.view.frame.size.height-550, 268, 40);
        self.validity.frame=CGRectMake(68, self.view.frame.size.height-480, 268, 40);
        self.banKName.frame=CGRectMake(68,self.view.frame.size.height-410, 268, 40);
        self.cardNumber.frame=CGRectMake(68, self.view.frame.size.height-340, 268, 40);
        self.submitDetailBtn.frame=CGRectMake(68, self.view.frame.size.height-250, 268, 40);
        
        
    }
    else
    {
        NSLog(@"in iPhone4 ");
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg.png"]];
        
        self.cardType.frame=CGRectMake(25, self.view.frame.size.height-175, 268, 40);
        self.validity.frame=CGRectMake(25, self.view.frame.size.height-325, 268, 40);
        self.banKName.frame=CGRectMake(25, self.view.frame.size.height-275, 268, 40);
        self.cardNumber.frame=CGRectMake(25,self.view.frame.size.height-225, 268, 40);
        self.submitDetailBtn.frame=CGRectMake(25, self.view.frame.size.height-110, 268, 40);
    }
 
    
    // Do any additional setup after loading the view.
}


-(void)submitDetailBtnClick:(UIButton *)button{


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
