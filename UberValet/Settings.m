//
//  Settings.m
//  UberValetService
//
//  Created by Sumit on 05/12/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import "Settings.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation Settings
    
@synthesize is_busy;

- (void)viewDidLoad {
    [super viewDidLoad];
    

    if ([UIScreen mainScreen].nativeScale == 2.0f){
        if ( self.view.bounds.size.height>568) {
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg_750@2x.png"]];
           
            
        }
        else if (self.view.bounds.size.height==568){
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg_568.png"]];
           
            
        } else{
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg.png"]];
            
            
          }
        }
          else if([UIScreen mainScreen ].nativeScale>2.1)
            {
                NSLog(@"in iPhone 6 plus");
                self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"splash screen_bg@3x.png"]];
         }
    
     status=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-40, 20, self.view.frame.size.width, 50)];
//    [status setBackgroundColor:[UIColor whiteColor]];
    status.text=@"STATUS";
    status.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    status.textColor = [UIColor blueColor];
  [self.view addSubview:status];
    
    
    statusButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [statusButton addTarget:self action:@selector(privacySettings:) forControlEvents:UIControlEventTouchUpInside];
    statusButton.frame = CGRectMake(80, 200, 200, 100) ;
    
    [statusButton setImage:[UIImage imageNamed:@"driver_availablity_yes.png"] forState:UIControlStateNormal];
    
    [statusButton setImage:[UIImage imageNamed:@"driver_availablity_no.png"] forState:UIControlStateSelected];
  [self.view addSubview:statusButton];
}

-(void)privacySettings:(id)sender{
    if ( statusButton.selected) {
        NSLog(@"button selected off ");
         is_busy = @"no";
        [self changeStat];
        statusButton.selected = !statusButton.selected;
       

    }else{
        NSLog(@"button selected on ");
        is_busy =@"yes";
        [self changeStat];
        statusButton.selected = !statusButton.selected;
        

    }
}


-(void)changeStat
{
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:[User currentUser].driver_id forKey:PARAM_DRIVER_ID];
    [dictParam setObject:is_busy forKey:@"is_busy"];
    
    [[mainAppDelegate sharedAppDelegate]showHUDLoadingView:@""];
    
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
    [afn getDataFromPath:FILE_SET_DRIVER_STAT withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         [[mainAppDelegate sharedAppDelegate]hideHUDLoadingView];
         if (response)
         {
             NSMutableDictionary *dict=[response objectForKey:WS_UBER_ALPHA];
             if ([[dict objectForKey:WS_STATUS]isEqualToString:WS_STATUS_SUCCESS])
             {
                 [[mainAppDelegate sharedAppDelegate]showToastMessage:[dict objectForKey:WS_MESSAGE]];
                 [[User currentUser]changeDriverStat:dict];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
