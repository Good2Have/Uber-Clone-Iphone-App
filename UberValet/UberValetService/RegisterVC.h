//
//  RegisterVC.h
//  UberValetService
//
//  Created by Globussoft 1 on 10/21/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterVC : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,weak) UITextField *txtUserName;
@property(nonatomic,weak) UITextField *txtSex;
@property(nonatomic,weak) UITextField *txtEmailID;
@property(nonatomic,weak) UITextField *txtPsw;
@property(nonatomic,weak) UITextField *txtDOB;
@property(nonatomic,weak) UITextField *txtMoNo;
@property(nonatomic,weak) UITextField *txtRefNo;
@property(nonatomic,weak) UITextField *txtCountryCode;
-(void)backButtonAction ;

@end
