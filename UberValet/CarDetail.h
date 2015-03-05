//
//  CarDetail.h
//  UberValetService
//
//  Created by Globussoft 1 on 11/25/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriverAssignment.h"

@interface CarDetail : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UITextField *carNumber;
@property(nonatomic,strong) UITextField *carColor ;
@property(nonatomic,strong) UITextField *carModel;
@property(nonatomic,strong) UITextField *yearOfpurchase;
@property(nonatomic,strong) UIButton *submitDetailBtn;
@property(nonatomic,strong) UIImageView *carImage;
@property(nonatomic,strong) UIImage *carImg;
@end
