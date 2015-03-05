//
//  UserDefaultHelper.h
//  Tinder
//
//  Created by Elluminati - macbook on 10/04/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USERDEFAULT [NSUserDefaults standardUserDefaults]

//UserDefault Keys
extern NSString *const UD_USER_INFO;//UserInfo

extern NSString *const UD_CURRENTLATITUDE;//currentLatitude
extern NSString *const UD_CURRENTLONGITUDE;//currentLongitude
extern NSString *const UD_DEVICETOKEN;//DeviceToken


@interface UserDefaultHelper : NSObject
{
    NSMutableDictionary *userInfo;
    NSString *adrsLable;
    NSString *currentLatitude;
    NSString *currentLongitude;
    NSString *deviceToken;
    NSString *driverId ; 
}
-(id)init;
+(UserDefaultHelper *)sharedObject;

//getter
-(NSString *)adrsLable;
-(NSMutableDictionary *)userInfo;
-(NSString *)currentLatitude;
-(NSString *)currentLongitude;
-(NSString *)deviceToken;

//setter
-(void) setadrsLable:(NSString *)adrsLbl;
-(void)setUserInfo:(NSMutableDictionary *)newUserInfo;
-(void)setCurrentLatitude:(NSString *)newLat;
-(void)setCurrentLongitude:(NSString *)newLong;
-(void)setDeviceToken:(NSString *)newDeviceToken;
-(void)setDriverId:(NSString *)newDriverId;
@end
