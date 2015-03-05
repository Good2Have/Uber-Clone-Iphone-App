//
//  JobDoneVC.h
//  Uber
//
//  Created by Elluminati - macbook on 30/06/14.
//  Copyright (c) 2014 Elluminati MacBook Pro 1. All rights reserved.
//

#import "BaseVC.h"
#import "HomeVC.h"

@interface JobDoneVC : BaseVC
{
    NSTimer *timer;
}
@property(nonatomic,weak)IBOutlet UIView *viewHeaderDriver;

@property(nonatomic,weak)IBOutlet UILabel *lblTime;
@property(nonatomic,weak)IBOutlet UILabel *lblRefNo;

+(JobDoneVC *)sharedObject;
-(IBAction)onClickJobDone:(id)sender;

@end
