//
//  FirstVC.h
//  UberValetService
//
//  Created by Globussoft 1 on 10/27/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PayPalMobile.h"
#import "PayPalPayment.h"
#import "PayPal.h"
#import <CoreLocation/CoreLocation.h>

@interface FirstVC : UIViewController<MKMapViewDelegate,MKAnnotation,MKOverlay,NSCopying,PayPalPaymentDelegate,PayPalFuturePaymentDelegate>{
       NSNumber *starRating;
    NSInteger totalCharges;
     UILabel *TotalLbl; 
    NSString *transactionID;
}
@property(nonatomic,strong)MKMapView *mapUser;
@property(nonatomic,strong)UILabel *crntPlaceLbl;

@property(nonatomic,strong)UIButton *confirmPickUpBtn;
@property(nonatomic,strong)UIButton *requestNowButton;
@property(nonatomic,strong)UIButton *addExtraServiceBtn;
@property(nonatomic,strong)UIButton *payPalbutton ;
@property(nonatomic,strong)UIButton *allowFuturePayment ;
@property(nonatomic,strong)UIImageView *DrivrImgview;

@property(nonatomic,strong)UIView *paymentView;
@property(nonatomic,strong)UIView *ShowDrivrView;
@property(nonatomic,strong)UIView* showDrivrRichTimeLbl;
@property(nonatomic,strong)UIView *feedBackVC;
@property(nonatomic,strong)UIView  *frstTimePopVC;
@property(nonatomic,strong)UIView *extraService;
@property(nonatomic,strong)UIView *cardDetail;
@property(nonatomic,strong)UIView *saveTransactionView;

@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;
-(void)payWithPayPal;
@end
