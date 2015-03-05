//
//  About.h
//  UberValetService
//
//  Created by Globussoft 1 on 11/25/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mainAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>
#import <MessageUI/MessageUI.h>

@interface About : UIViewController<MFMessageComposeViewControllerDelegate>{
    
    mainAppDelegate *appDelegate ;
      MFMessageComposeViewController *messageController;
     UIButton *twitterButton1;
}
@property(nonatomic,strong) id delegate ;


@end
