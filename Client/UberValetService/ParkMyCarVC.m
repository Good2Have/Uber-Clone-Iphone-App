//
//  ParkMyCarVC.m
//  UberValetService
//
//  Created by Globussoft 1 on 10/30/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import "ParkMyCarVC.h"
#import "HomeVC.h"
#import "LoginVC.h"
#import "FirstVC.h"
#import "AppDelegateFirstVC.h"
#import "CarDetail.h"
#import "About.h"
#import "PromotionDetail.h"
#import "LogutVC.h"
#import "PaymentDetail.h"
#import "ShareVC.h"
#import "SupportVC.h"

@interface ParkMyCarVC ()

@end

@implementation ParkMyCarVC

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
    
    
    UIButton *parkMyCarButton=[UIButton buttonWithType:     UIButtonTypeCustom];
    [parkMyCarButton addTarget:self action:@selector(parkMyCarClick:) forControlEvents:UIControlEventTouchUpInside];
     parkMyCarButton.titleLabel.textAlignment=NSTextAlignmentLeft;
    [parkMyCarButton setTitle:@" Park My Car "  forState:UIControlStateNormal];
    [self.view addSubview:parkMyCarButton];
    
    
    UIView *footerView=[[UIView alloc] init];
    footerView.frame=CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 100);
    footerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"trans_bg.png"]];
    [self.view addSubview:footerView];
    
    UIButton *errandSerVice=[UIButton buttonWithType:UIButtonTypeCustom];
    [errandSerVice addTarget:self action:@selector(errandServiceClick:) forControlEvents:UIControlEventTouchUpInside];[errandSerVice setTitle:@"ERRAND SERVICES" forState:UIControlStateNormal];
       errandSerVice.titleLabel.font=[UIFont fontWithName:nil size:15.0];
    errandSerVice.backgroundColor=[UIColor clearColor];
    [footerView addSubview:errandSerVice];
    
    UIButton *comingSrvicClck=[UIButton buttonWithType:UIButtonTypeCustom];
       [comingSrvicClck addTarget:self action:@selector(comingServiceClick:) forControlEvents:UIControlEventTouchUpInside];
    [comingSrvicClck setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [comingSrvicClck setTitle:@"Comming Soon" forState:UIControlStateNormal];
    comingSrvicClck.backgroundColor=[UIColor clearColor];
    comingSrvicClck.titleLabel.font=[UIFont fontWithName:nil size:15.0];
    
    [footerView addSubview:comingSrvicClck];

    if ([UIScreen mainScreen].nativeScale == 2.0f){
        if (self.view.frame.size.height>568.0f) {
            NSLog(@"in iPhone6");
             errandSerVice.frame=CGRectMake(10, 10, 170, 40);
             comingSrvicClck.frame=CGRectMake(160, 10, 170, 40);
             parkMyCarButton.frame=CGRectMake(0, self.view.frame.size.height/2+90, 250, 40);
             parkMyCarButton.titleLabel.font=[UIFont fontWithName:nil size:35];
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg750@2x.png"]];

        }
        else if ( self.view.bounds.size.height==568.0f) {
            NSLog(@"in iPhone5");
            errandSerVice.frame=CGRectMake(10, 10, 170, 40);
             comingSrvicClck.frame=CGRectMake(160, 10, 170, 40);
             parkMyCarButton.frame=CGRectMake(20, self.view.frame.size.height/2+80, 200, 40);
            parkMyCarButton.titleLabel.font=[UIFont fontWithName:nil size:30];
             self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_568.png"]];
            
        }
        else{
            NSLog(@"in iPhone4 ");
            errandSerVice.frame=CGRectMake(10, 10, 170, 40);
             comingSrvicClck.frame=CGRectMake(160, 10, 170, 40);
            
             parkMyCarButton.frame=CGRectMake(0, self.view.frame.size.height/2+100, 200, 40);
            parkMyCarButton.titleLabel.font=[UIFont fontWithName:nil size:30];
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];        }
        
        }
    
    else if ([UIScreen mainScreen].scale > 2.1f)
    {
        NSLog(@"in iPhone 6 plus");
         errandSerVice.frame=CGRectMake(10, 10, 170, 40);
         comingSrvicClck.frame=CGRectMake(250, 10, 170, 40);
         parkMyCarButton.frame=CGRectMake(20, self.view.frame.size.height/2+80, 300, 40);
        parkMyCarButton.titleLabel.font=[UIFont fontWithName:nil size:35];
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg1242@3x.png"]];
       
    }
    else
    {
        NSLog(@"in iPAD");
       errandSerVice.frame=CGRectMake(10, 10, 170, 40);
         comingSrvicClck.frame=CGRectMake(160, 10, 170, 40);
         parkMyCarButton.frame=CGRectMake(20, self.view.frame.size.height/2+80, 200, 40);
       self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    }
    
    
    // Do any additional setup after loading the view.
}

-(void)parkMyCarClick:(UIButton *)button{

//            AppDelegateFirstVC *loginVC=[[AppDelegateFirstVC alloc] init];
//        loginVC.title=@"Login";
    
    
        FirstVC *firstVC=[[FirstVC alloc] init];
        firstVC.title=@"Home";

    PaymentDetail *pay=[[PaymentDetail alloc] init];
    pay.title=@"Payment";
    PromotionDetail *promot=[[PromotionDetail alloc] init];
    promot.title=@"Promotion";
    CarDetail *carInfo=[[CarDetail alloc] init];
    carInfo.title=@"CarDetail";
    About *ab=[[About alloc] init];
    ab.title=@"About";
    ShareVC *sh=[[ShareVC alloc] init];
    sh.title=@"Share";
    SupportVC *support=[[SupportVC alloc] init];
    support.title=@"Support";
    LogutVC *logout=[[LogutVC alloc] init];
    logout.title=@"Logout";
    if (!homeVC) {
          homeVC=[[HomeVC alloc] init];
        homeVC.viewControllers = @[firstVC,pay,promot,carInfo,sh,support,ab,logout];

    }
    
    
    [self presentViewController:homeVC animated:YES completion:nil];

}
-(void)errandServiceClick:(UIButton *)button{
}


-(void)comingServiceClick:(UIButton *)button{


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
