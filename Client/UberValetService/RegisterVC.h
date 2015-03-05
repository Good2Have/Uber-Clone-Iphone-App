//
//  RegisterVC.h
//  UberValetService
//
//  Created by Globussoft 1 on 10/21/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"

@interface RegisterVC : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *arrCountry;
    Country *selectedCountry;
}

@property(nonatomic,strong) UIPickerView *pickCountryCode;
@end
