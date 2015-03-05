//
//  mainViewController.h
//  UberValetService
//
//  Created by Globussoft 1 on 10/21/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController<UITextFieldDelegate,UIScrollViewDelegate>
-(void)emailLoginClick:(UIButton *)button;
//@property (strong, nonatomic) AppDelegateFirstVC *viewController ;
@property(nonatomic,strong)UIWebView *webView;
@end
