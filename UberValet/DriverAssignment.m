//
//  DriverAssignment.m
//  Uber
//
//  Created by Elluminati - macbook on 03/07/14.
//  Copyright (c) 2014 Elluminati MacBook Pro 1. All rights reserved.
//

#import "DriverAssignment.h"

@implementation DriverAssignment

@synthesize alert;
@synthesize random_id;
@synthesize lattitude;
@synthesize logitude;
@synthesize id_;
@synthesize badge;
@synthesize sound;
@synthesize pushDriverID,Client_contact,Operator_contact,client_name,clientImage_url;
@synthesize end_lattitude,end_logitude;
@synthesize dateETA;
@synthesize isOnETA,isZoom,strUrl,carWash,fuelTopUp,address;

@synthesize dateReachedAtClient,client_id;

#pragma mark -
#pragma mark - Init

-(id)init
{
    self=[super init];
    if (self)
    {
        NSDictionary *dict=[[NSUserDefaults standardUserDefaults]objectForKey:UD_DRIVERASSIGNMENT];
        if (dict!=nil) {
            [self setData:dict];
        }
        NSDate *date=[[NSUserDefaults standardUserDefaults]objectForKey:UD_DATE_ETA];
        if (date!=nil) {
            [self setETA:date];
        }
        isOnETA=[[NSUserDefaults standardUserDefaults]boolForKey:UD_ON_ETA];
        
        NSDate *dateRech=[[NSUserDefaults standardUserDefaults]objectForKey:UD_DATE_REACHED_AT_CLIENT];
        if (dateRech!=nil) {
            [self setDateReachedAtClient:dateRech];
        }
    }
    return self;
}

+(DriverAssignment *)sharedObject{
    static DriverAssignment *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[DriverAssignment alloc] init];
    });
    return obj;
}

#pragma mark -
#pragma mark - Methods

-(void)setData:(NSDictionary *)dictData
{
    NSLog(@"dicdata is %@",dictData);
    
    if (dictData==nil) {
        return;
    }
    
    if ([dictData isEqual:@""]) {
        return;
    }
    
    client_id=[dictData objectForKey:@"client_id"];
    alert=[dictData objectForKey:@"alert"];
    random_id=[dictData objectForKey:@"random_id"];
    lattitude=[dictData objectForKey:@"lattitude"];
    logitude=[dictData objectForKey:@"logitude"];
    end_lattitude=[dictData objectForKey:@"end_lattitude"];
    end_logitude=[dictData objectForKey:@"end_logitude"];
    id_=[dictData objectForKey:@"id"];
    sound=[dictData objectForKey:@"sound"];
    badge=[dictData objectForKey:@"badge"];
    Client_contact=[dictData objectForKey:@"client_contact"];
    Operator_contact=[dictData objectForKey:@"operator_contact"];
    client_name=[dictData objectForKey:@"client_name"];
//    clientImage_url=[NSString stringWithFormat:@"uber.globusapps.com/uploads/%@",[dictData objectForKey:@"profile_image"]];
     strUrl=[NSURL URLWithString:[NSString stringWithFormat:@"http://uber.globusapps.com/uploads/%@",[dictData objectForKey:@"profile_image"]]];
    carWash = [dictData objectForKey:@"car_washing"];
    fuelTopUp = [dictData objectForKey:@"fuel_topup"];

    
    isZoom=NO;
    if ([id_ intValue]==1) {
//        pushDriverID=PushDriverIdAssignRequest;
    }else{
//        pushDriverID=PushDriverIdDeleteAssignment;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:dictData forKey:UD_DRIVERASSIGNMENT];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)setReachedAtClient:(NSDate *)date
{
    if (date==nil) {
        return;
    }
    dateReachedAtClient=date;
    [[NSUserDefaults standardUserDefaults]setObject:date forKey:UD_DATE_REACHED_AT_CLIENT];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
-(BOOL)isReachedAtClient
{
    NSDate *date=[[NSUserDefaults standardUserDefaults]objectForKey:UD_DATE_REACHED_AT_CLIENT];
    if (date!=nil) {
        return YES;
    }else{
        return NO;
    }
}


-(void)setETA:(NSDate *)date
{
    if (date==nil) {
        return;
    }
    dateETA=date;
    [[NSUserDefaults standardUserDefaults]setObject:date forKey:UD_DATE_ETA];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)setIsOnETA:(BOOL)onETA
{
    isOnETA=onETA;
    [[NSUserDefaults standardUserDefaults]setBool:onETA forKey:UD_ON_ETA];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(BOOL)isActiveJob
{
    NSDictionary *dict=[[NSUserDefaults standardUserDefaults]objectForKey:UD_DRIVERASSIGNMENT];
    if (dict!=nil) {
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)isETAset
{
    NSDate *date=[[NSUserDefaults standardUserDefaults]objectForKey:UD_DATE_ETA];
    if (date!=nil) {
        return YES;
    }else{
        return NO;
    }
}

-(void)removeAllData
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:UD_DRIVERASSIGNMENT];
    [[NSUserDefaults standardUserDefaults]synchronize];
    alert=nil;
    random_id=nil;
    id_=nil;
    badge=nil;
    sound=nil;
    lattitude=nil;
    logitude=nil;
    end_lattitude=nil;
    end_logitude=nil;
    client_name=nil;
    Operator_contact=nil;
    Client_contact=nil;
    isZoom=NO;
//    pushDriverID=PushDriverIdDeleteAssignment;
    
    NSLog(@"random_id is %@",random_id);
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:UD_DATE_ETA];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    isOnETA=NO;
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:UD_ON_ETA];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:UD_DATE_REACHED_AT_CLIENT];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"check1"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"check2"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
