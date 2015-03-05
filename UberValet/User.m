//
//  User.m
//  Uber
//
//  Created by Elluminati - macbook on 26/06/14.
//  Copyright (c) 2014 Elluminati MacBook Pro 1. All rights reserved.
//

#import "User.h"
#import "UserDefaultHelper.h"

@implementation User

@synthesize driver_id,client_id,name,email,contact,date_of_birth,gender,reference_no,lattitude,logitude,rating,rating_count,confirm_status,reg_time,is_busy,driver_busy_stat,strUrl;

#pragma mark -
#pragma mark - Init

-(id)init{
    self=[super init];
    if (self) {
        NSMutableDictionary *dict=[[UserDefaultHelper sharedObject]userInfo];
        if (dict!=nil) {
            [self setUser:dict];
        }
    }
    return self;
}

+(User *)currentUser{
    static User *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[User alloc] init];
    });
    return user;
}

#pragma mark -
#pragma mark - Methods

-(void)setUser:(NSMutableDictionary *)dict{
    
    name=[dict objectForKey:@"name"];
    email=[dict objectForKey:@"email"];
    contact=[dict objectForKey:@"contact"];
    date_of_birth=[dict objectForKey:@"date_of_birth"];
    gender=[dict objectForKey:@"gender"];
    reg_time=[dict objectForKey:@"reg_time"];
     driver_id=[dict objectForKey:@"driver_id"];
     strUrl=[NSURL URLWithString:[NSString stringWithFormat:@"http://uber.globusapps.com/uploads/%@",[dict objectForKey:@"profile_image"]]];
    
    [[NSUserDefaults standardUserDefaults]setObject:driver_id forKey:@"driver_id"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
#ifdef UBER_DRIVER
    driver_id=[dict objectForKey:@"driver_id"];
    reference_no=[dict objectForKey:@"reference_no"];
    lattitude=[dict objectForKey:@"lattitude"];
    logitude=[dict objectForKey:@"logitude"];
    rating=[dict objectForKey:@"rating"];
    rating_count=[dict objectForKey:@"rating_count"];
    confirm_status=[dict objectForKey:@"confirm_status"];
    is_busy=[dict objectForKey:@"is_busy"];
    driver_busy_stat=[dict objectForKey:@"driver_busy_stat"];
#elif UBER_CLIENT
    client_id=[dict objectForKey:@"client_id"];
#endif
//   [[UserDefaultHelper sharedObject]setDriverId:driver_id];
    [[UserDefaultHelper sharedObject]setUserInfo:dict];
}

-(BOOL)isLogin{
    BOOL isLogin=NO;
#ifdef UBER_DRIVER
    if (driver_id!=nil) {
        isLogin=YES;
    }
#elif UBER_CLIENT
    if (client_id!=nil) {
        isLogin=YES;
    }
#endif
    return isLogin;
}

-(void)logout{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:UD_USER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
    client_id=nil;
    driver_id=nil;
}

-(void)changeDriverStat:(NSMutableDictionary *)dictStat{
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:[[UserDefaultHelper sharedObject]userInfo]];
    [dict setObject:[dictStat objectForKey:@"is_busy"] forKey:@"is_busy"];
    [dict setObject:[dictStat objectForKey:@"driver_busy_stat"] forKey:@"driver_busy_stat"];
    [self setUser:dict];
}

@end
