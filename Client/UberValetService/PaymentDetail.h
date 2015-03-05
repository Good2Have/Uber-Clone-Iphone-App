//
//  PaymentDetail.h
//  UberValetService
//
//  Created by Globussoft 1 on 11/25/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentDetail : UIViewController<UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UITextField *cardNumber;
@property(nonatomic,strong) UITextField *banKName ;
@property(nonatomic,strong) UITextField *validity;
@property(nonatomic,strong) UITextField *cardType;
@property(nonatomic,strong) UIButton *submitDetailBtn;

@end
