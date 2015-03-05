//
//  Settings.h
//  UberValetService
//
//  Created by Sumit on 05/12/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings : UIViewController{
    UIButton *statusButton;
    UILabel *status;
    
    UIButton *washCarChekBox;
    UIButton *fueltopChekBox;
    UIButton *allowFuturePaymentCheckBox; 
   
}
@property (nonatomic,strong)NSString *is_busy;

@property(nonatomic,strong)UIView *saveTransactionView;
@property(nonatomic,strong)UIView *extraService;
@property(nonatomic,strong)UIButton *payPalbutton ;
@property(nonatomic,strong)UIButton *allowFuturePayment ;
@property(nonatomic,strong) UIButton *saveBtn;
@property(nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,strong) UILabel *xtraSrvicLbl;
@property(nonatomic,strong)UILabel * TransactionLabel;
@property(nonatomic,strong)UILabel *  totalAmountLbl;
@property(nonatomic,strong)UILabel *  IDLabel;

@end
