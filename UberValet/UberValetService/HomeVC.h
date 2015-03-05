//
//  HomeVC.h
//  UberValetService
//
//  Created by Globussoft 1 on 10/27/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapView.h"

@interface HomeVC : UIViewController<UITableViewDelegate,UITableViewDataSource>{
        UIImageView *imageVUser;
        UILabel *lblUserName;
}

@property(nonatomic,weak) MKMapView *mapUser;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AppDelegateFirstVC *viewController ;
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, copy) UIViewController *selectedViewController;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) UIView *contentContainerView;
@property (nonatomic, strong) UIView *mainsubView;

@property (nonatomic, strong) UILabel *menuLabel;
@property (nonatomic, strong) UITableView *menuTableView;

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGesture;
+(HomeVC *)sharedObject;
-(void)removeAllAnnotations ;

@end
