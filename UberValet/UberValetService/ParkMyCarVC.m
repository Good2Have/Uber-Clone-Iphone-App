//
//  ParkMyCarVC.m
//  UberValetService
//
//  Created by Globussoft 1 on 10/30/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import "ParkMyCarVC.h"
#import "HomeVC.h"

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
    [parkMyCarButton setTitle:@" Park My Car "  forState:UIControlStateNormal];
    parkMyCarButton.frame=CGRectMake(20, self.view.frame.size.height/2, 100, 40);
    [self.view addSubview:parkMyCarButton];
    
    
    UIView *footerView=[[UIView alloc] init];
    footerView.frame=CGRectMake(0, self.view.frame.size.height-100, self.view.frame.size.width, 100);
    footerView.backgroundColor=[UIColor redColor];
    [self.view addSubview:footerView];
    
    UIButton *errandSerVice=[UIButton buttonWithType:UIButtonTypeCustom];
    [errandSerVice addTarget:self action:@selector(errandServiceClick:) forControlEvents:UIControlEventTouchUpInside];[errandSerVice setTitle:@"ERRAND SERVICES" forState:UIControlStateNormal];
    errandSerVice.frame=CGRectMake(10, 10, 150, 40);
    errandSerVice.backgroundColor=[UIColor clearColor];
    [footerView addSubview:errandSerVice];
    
    UIButton *comingSrvicClck=[UIButton buttonWithType:UIButtonTypeCustom];
    [comingSrvicClck addTarget:self action:@selector(comingServiceClick:) forControlEvents:UIControlEventTouchUpInside];[errandSerVice setTitle:@"ERRAND SERVICES" forState:UIControlStateNormal];
    comingSrvicClck.backgroundColor=[UIColor clearColor];
     comingSrvicClck.frame=CGRectMake(10, 10, 170, 40);
    [footerView addSubview:comingSrvicClck];

    
    // Do any additional setup after loading the view.
}

-(void)parkMyCarClick:(UIButton *)button{



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
