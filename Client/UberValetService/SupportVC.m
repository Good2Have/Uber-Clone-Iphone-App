//
//  SupportVC.m
//  UberValetService
//
//  Created by Globussoft 1 on 11/26/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import "SupportVC.h"

@interface SupportVC ()
{
    UILabel *myLabel;
}
@end

@implementation SupportVC
@synthesize myScrollView;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myScrollView = [[UIScrollView alloc]
                         initWithFrame:CGRectMake(0, 0,
                                                  self.view.frame.size.width,
                                                  self.view.frame.size.height-150)];
        //set the paging to yes
    self.myScrollView.pagingEnabled = YES;
    
        //lets create 10 views
    NSInteger numberOfViews = 10;
    for (int i = 0; i < numberOfViews; i++) {
        
            //set the origin of the sub view
        CGFloat myOrigin = i * self.myScrollView.frame.size.width;
        
            //create the sub view and allocate memory
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(myOrigin,10,200,200)];
            //set the background to white color
        myView.backgroundColor = [UIColor redColor];
        
            //create a label and add to the sub view
        
            //create a text field and add to the sub view
    
            //set the scroll view delegate to self so that we can listen for changes
        self.myScrollView.delegate = self;
            //add the subview to the scroll view
        [self.myScrollView addSubview:myView];
    }
    
    self.myScrollView.contentSize = CGSizeMake(self.view.frame.size.width * numberOfViews,
                                               self.view.frame.size.height);
    
        //we set the origin to the 3rd page
    CGPoint scrollPoint = CGPointMake(self.view.frame.size.width * 2, 0);
        //change the scroll view offset the the 3rd page so it will start from there
    [myScrollView setContentOffset:scrollPoint animated:YES];
    
   [self.view addSubview:self.myScrollView];
    
    
    CGRect myFrame = CGRectMake(10.0f, self.view.frame.size.height-100, 300.0f, 25.0f);
    myLabel = [[UILabel alloc] initWithFrame:myFrame];
    myLabel.backgroundColor=[UIColor greenColor];
    [myLabel setTextColor:[UIColor whiteColor]];
    myLabel.lineBreakMode=NSLineBreakByCharWrapping;
    myLabel.numberOfLines=0;
    myLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    myLabel.textAlignment =  NSTextAlignmentLeft;
    [self.view addSubview:myLabel];
    [myLabel sizeToFit];

        // Dispose of any resources that can be recreated.
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
   
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
        //find the page number you are on
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    NSLog(@"Scrolling - You are now on page %i",page);
    
    if (page==0) {
        myLabel.text = [NSString stringWithFormat:@"Click Request Now \n Button to Park Your Car "];
    }
    if (page==1) {
        myLabel.text=[NSString stringWithFormat:@"Your Valet will come \n and Park Your Car"];
    }
    if (page==2) {
        myLabel.text=[NSString stringWithFormat:@"Click dropOff to \n getBack your Car"];
    }
    if (page==3) {
        myLabel.text=[NSString stringWithFormat:@"Help us maintain a \n quality service by rating  \n your experience "];
    }

}

    //dragging ends, please switch off paging to listen for this event
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *) targetContentOffset
NS_AVAILABLE_IOS(5_0){
    
        //find the page number you are on
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    NSLog(@"Dragging - You are now on page %i",page);
    
    
    if (page==0) {
        myLabel.text = [NSString stringWithFormat:@"Click Request Now \n Button to Park Your Car "];
    }
    if (page==1) {
        myLabel.text=[NSString stringWithFormat:@"Your Valet will come \n and Park Your Car"];
    }
    if (page==2) {
        myLabel.text=[NSString stringWithFormat:@"Click dropOff to \n getBack your Car"];
    }
    if (page==3) {
        myLabel.text=[NSString stringWithFormat:@"Help us maintain a \n quality service by rating  \n your experience "];
    }

    
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
