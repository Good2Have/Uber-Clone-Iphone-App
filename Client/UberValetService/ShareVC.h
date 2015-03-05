//
//  ShareVC.h
//  UberValetService
//
//  Created by Globussoft 1 on 11/26/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ShareVC : UIViewController<MFMessageComposeViewControllerDelegate>
{
    MFMessageComposeViewController *messageController;

}
@end
