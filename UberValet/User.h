//
//  User.h
//  Uber
//
//  Created by Elluminati - macbook on 26/06/14.
//  Copyright (c) 2014 Elluminati MacBook Pro 1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject{

}
@property(nonatomic,copy)NSString *driver_id;
@property(nonatomic,copy)NSString *client_id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *email;
@property(nonatomic,copy)NSString *contact;
@property(nonatomic,copy)NSString *date_of_birth;
@property(nonatomic,copy)NSString *gender;
@property(nonatomic,copy)NSString *reference_no;
@property(nonatomic,copy)NSString *lattitude;
@property(nonatomic,copy)NSString *logitude;
@property(nonatomic,copy)NSString *rating;
@property(nonatomic,copy)NSString *rating_count;
@property(nonatomic,copy)NSString *confirm_status;
@property(nonatomic,copy)NSString *reg_time;
@property(nonatomic,copy)NSString *is_busy;
@property(nonatomic,copy)NSString *driver_busy_stat;
@property(nonatomic,copy )NSURL *strUrl;

-(id)init;
+(User *)currentUser;

-(void)setUser:(NSMutableDictionary *)dict;
-(BOOL)isLogin;
-(void)logout;
-(void)changeDriverStat:(NSMutableDictionary *)dictStat;

@end
