//
//  DriverAssignment.h
//  Uber
//
//  Created by Elluminati - macbook on 03/07/14.
//  Copyright (c) 2014 Elluminati MacBook Pro 1. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UD_DRIVERASSIGNMENT     @"DriverAssignment"
#define UD_DATE_ETA             @"dateETA"
#define UD_ON_ETA               @"isOnETA"
#define UD_DATE_REACHED_AT_CLIENT             @"dateReachedAtClient"

@interface DriverAssignment : NSObject

@property(nonatomic,copy)NSString *alert;
@property(nonatomic,copy)NSString *random_id;
@property(nonatomic,copy)NSString *lattitude;
@property(nonatomic,copy)NSString *logitude;
@property(nonatomic,copy)NSString *end_lattitude;
@property(nonatomic,copy)NSString *end_logitude;
@property(nonatomic,copy)NSString *id_;
@property(nonatomic,copy)NSString *badge;
@property(nonatomic,copy)NSString *sound;
@property(nonatomic,copy)NSString *Client_contact;
@property(nonatomic, copy)NSString *client_id;
@property(nonatomic,copy)NSString *Operator_contact;
@property(nonatomic,copy)NSString *client_name;
@property(nonatomic,copy)NSString *clientImage_url;
@property(nonatomic,copy)NSURL *strUrl;
@property(nonatomic,copy)NSString *carWash ;
@property(nonatomic,copy)NSString *fuelTopUp;
@property(nonatomic,copy)NSString *address;

@property(nonatomic,assign)PushDriverID pushDriverID;

@property(nonatomic,copy)NSDate *dateETA;
@property(nonatomic,assign)BOOL isOnETA;
@property(nonatomic,assign)BOOL isZoom;

@property(nonatomic,copy)NSDate *dateReachedAtClient;

+(DriverAssignment *)sharedObject;
-(void)setData:(NSDictionary *)dictData;
-(void)setETA:(NSDate *)date;
-(void)setIsOnETA:(BOOL)onETA;
-(BOOL)isActiveJob;
-(BOOL)isETAset;
-(void)removeAllData;

-(void)setReachedAtClient:(NSDate *)date;
-(BOOL)isReachedAtClient;

@end

