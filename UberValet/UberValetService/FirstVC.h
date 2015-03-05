//
//  FirstVC.h
//  UberValetService
//
//  Created by Globussoft 1 on 10/27/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>

@interface FirstVC : UIViewController<MKMapViewDelegate,MKAnnotation,MKOverlay,NSCopying,MFMessageComposeViewControllerDelegate,UITextFieldDelegate>{

UIImageView* routeView;
    UIColor* lineColor;
    NSTimer *mapTimer ;
}
@property(nonatomic,strong) UIDatePicker *datePic;
@property(nonatomic,strong)MKMapView *mapUser;
@property(nonatomic,strong)UILabel *crntPlaceLbl;
@property(nonatomic,strong)UIView *cardDetail;
@property(nonatomic,strong)UIButton *confirmPickUpBtn;
@property (nonatomic,strong)UIButton *requestNowButton;
@property(nonatomic,strong)UIButton *addExtraServiceBtn;
@property(nonatomic,strong)UIImageView *DrivrImgview;
@property (nonatomic,strong)UIView *ShowDrivrView;
@property(nonatomic,strong)UIView* showDrivrRichTimeLbl;
@property(nonatomic,strong)UIView *feedBackVC;
@property(nonatomic,strong)UIImageView *roundImageView ;
@property(nonatomic,strong) UILabel *driverName ;
@property(nonatomic,strong) UIButton *accept ;
@property(nonatomic,strong) UIButton *cancel ;
@property(nonatomic,strong) UIView *acceptView ;
@property(nonatomic,strong) UILabel *name ;
@property(nonatomic,strong) UILabel *add1 ;
@property(nonatomic,strong) UILabel *add2 ;
@property(nonatomic,strong) UILabel *distanceLabel ;
@property(nonatomic,strong) UIButton *call ;
@property(nonatomic,strong) UIButton *text ;
@property(nonatomic,strong) UIView *dropOff ;
@property(nonatomic,strong) UIButton *arrivedButton ;
@property(nonatomic,strong) UIButton *requestDropOffButton;
@property(nonatomic,strong) UIButton *droppedButton ;
@property(nonatomic,strong) UIButton *confirmPickupBtn;
@property(nonatomic,strong) UIDatePicker *datePicker ;
@property(nonatomic,strong) UITextField *datePickerTextField ;
@property(nonatomic,strong)  UILabel  * EtaLabel ;
@property(nonatomic,strong) UIButton * setEtaBtn ;
@property(nonatomic,strong) UIButton *checkBoxEmpty ;
@property(nonatomic,strong) UIButton *tickedCheckBox ;
@property(nonatomic,strong) UIButton *checkBoxEmpty1 ;
@property(nonatomic,strong) UIButton *tickedCheckBox1 ;

@property(nonatomic,strong)UIView *extraService;
@property(nonatomic,strong)UIButton *payPalbutton ;
@property(nonatomic,strong)UIButton *allowFuturePayment ;


//@property(nonatomic,strong)
@end
