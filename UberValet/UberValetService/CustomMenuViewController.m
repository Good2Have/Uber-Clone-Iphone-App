
//
//  CustomMenuViewController.m
//  MOVYT
//
//  Created by Sumit Ghosh on 27/05/14.
//  Copyright (c) 2014 Sumit Ghosh. All rights reserved.
//

#import "CustomMenuViewController.h"
#import <objc/runtime.h>
#import "ViewController.h"
#import <Parse/Parse.h>
#import "SingletonClass.h"
#import "PurchaseView.h"
#import "UIViewController+MJPopupViewController.h"

@interface CustomMenuViewController ()

@end

@implementation CustomMenuViewController
@synthesize viewControllers = _viewControllers;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    [self.menuTableView reloadData];
}
//Received Notification Method
-(void) reloadMenuTable:(NSNotification *)notify{
    
    id name = [notify object];
    if ([name isKindOfClass:[NSString class]]) {
        
        if ([name isEqualToString:@"LoggedInWithBroadCast"]){
            self.isSignIn = YES;
            
        }
        else if ([name isEqualToString:@"LoggedIn"]){
            self.isSignIn = YES;
            
        }
        [self.menuTableView reloadData];
    }
}

#pragma mark -
-(void) setViewControllers:(NSArray *)viewControllers{
    
    _viewControllers = [viewControllers copy];
    
    for (UIViewController *viewController in _viewControllers ) {
        [self addChildViewController:viewController];
        
        viewController.view.frame = CGRectMake(0, 90,[UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height-90);
        [viewController didMoveToParentViewController:self];
    }
}
-(void) setSecondSectionViewControllers:(NSArray *)secondSectionViewControllers{
    
    _secondSectionViewControllers = [secondSectionViewControllers copy];
    
    for (UIViewController *viewController in _secondSectionViewControllers ) {
        [self addChildViewController:viewController];
        
        viewController.view.frame = CGRectMake(0, 90,[UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height-90);
        [viewController didMoveToParentViewController:self];
    }
}
-(void) setSelectedViewController:(UIViewController *)selectedViewController{
    _selectedViewController = selectedViewController;
}

-(void) setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
}

-(NSArray *) getAllViewControllers{
    return self.viewControllers;
}
-(void) setSelectedSection:(NSInteger)selectedSection{
    _selectedSection = selectedSection;
}
#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    self.screen_height = [UIScreen mainScreen].bounds.size.height;
    self.isSignIn = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMenuTable:) name:@"UpdateMenuTable" object:nil];
    
    //Add View SubView;
    self.mainsubView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSLog(@"Main sub view frame X=-=- %f \n Y == %f",[UIScreen mainScreen].bounds.origin.x,[UIScreen mainScreen].bounds.origin.y);
    self.mainsubView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainsubView];
    
    //Add Header View
    CGFloat hh;
    CGRect frame_b;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        hh = 75;
        frame_b = CGRectMake(680, 30, 45, 25);
        //         frame_b = CGRectMake(self.view.frame.size.width-65, 30, 45, 25);
    }
    else{
        hh = 55;
        //        frame_b = CGRectMake(self.view.frame.size.width-65, 20, 45, 25);
        frame_b = CGRectMake(255, 20, 45, 25);
    }
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, hh);
    
    self.headerView = [[UIView alloc] initWithFrame:frame];
    self.headerView.backgroundColor = [UIColor darkTextColor];
    
    [self.mainsubView addSubview:self.headerView];
    
    NSLog(@"Width menu== %f",self.view.frame.size.width);
    frame = CGRectMake(0, 90, self.view.frame.size.width, self.screen_height-90);
    
    //=======================================
    // Add Booster View
    
    self.boosterView = [[UIView alloc] initWithFrame:CGRectMake(0, hh, self.view.frame.size.width, 35)];
    self.boosterView.backgroundColor = [UIColor grayColor];
    self.boosterView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.mainsubView addSubview:self.boosterView];
    
    [self boosterViewUI];
    
    //=======================================
    // Add Container View
    
    self.contentContainerView = [[UIView alloc] initWithFrame:frame];
    self.contentContainerView.backgroundColor = [UIColor grayColor];
    self.contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.mainsubView addSubview:self.contentContainerView];
    
    //============================
    //Add Menu Button
    
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuButton.frame = frame_b;
    self.menuButton.titleLabel.font = [UIFont systemFontOfSize:9.0f];
    self.menuButton.titleLabel.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    //self.menuButton.titleLabel.layer.
    [self.menuButton addTarget:self action:@selector(menuButtonClciked:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuButton setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    
    [self.headerView addSubview:self.menuButton];
    
    //===================================
    
    //Add Menu Lable
    self.menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 15, 100, 30)];
    self.menuLabel.backgroundColor = [UIColor clearColor];
    self.menuLabel.font = [UIFont boldSystemFontOfSize:15];
    self.menuLabel.textColor = [UIColor whiteColor];
    self.menuLabel.textAlignment = NSTextAlignmentCenter;
    
    self.menuLabel.text = _selectedViewController.title;
    [self.headerView addSubview:self.menuLabel];
    
    //====================================
    
    self.selectedIndex = 0;
    self.selectedViewController = [_viewControllers objectAtIndex:0];
    [self updateViewContainer];
    [self createMenuTableView];
    
    self.swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    self.swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.mainsubView addGestureRecognizer:self.swipeGesture];
}
-(void)boosterViewUI {
    
    UIButton *btnDiamond = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDiamond.frame=CGRectMake(3, 5, 70, 25);
    [btnDiamond setTitle:@"4" forState:UIControlStateNormal];
    btnDiamond.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [btnDiamond setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnDiamond.userInteractionEnabled=NO;
    [btnDiamond setBackgroundImage:[UIImage imageNamed:@"dia_btn.png"] forState:UIControlStateNormal];
    [self.boosterView addSubview:btnDiamond];
    
    UIButton *btnDiamondPlus = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnDiamondPlus.frame=CGRectMake(btnDiamond.frame.origin.x+btnDiamond.frame.size.width+3, 10, 15, 15);
    [btnDiamondPlus addTarget:self action:@selector(btnDiamondPlusAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnDiamondPlus setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    [self.boosterView addSubview:btnDiamondPlus];
    
    UIButton *btnBooster = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnBooster.frame=CGRectMake(btnDiamondPlus.frame.origin.x+btnDiamondPlus.frame.size.width+3, 5, 70, 25);
    [btnBooster setTitle:@"00" forState:UIControlStateNormal];
    [btnBooster setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnBooster.userInteractionEnabled=NO;
    [btnBooster setBackgroundImage:[UIImage imageNamed:@"booster_btn.png"] forState:UIControlStateNormal];
    [self.boosterView addSubview:btnBooster];
    
    UIButton *btnBoosterPlus = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnBoosterPlus.frame=CGRectMake(btnBooster.frame.origin.x+btnBooster.frame.size.width+3, 10, 15, 15);
    [btnBoosterPlus setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    [btnBoosterPlus addTarget:self action:@selector(btnBoosterPlusAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.boosterView addSubview:btnBoosterPlus];
    
    UIButton *btnLife = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnLife.frame=CGRectMake(btnBoosterPlus.frame.origin.x+btnBoosterPlus.frame.size.width+3, 5, 80, 25);
    btnLife.userInteractionEnabled=NO;
    [btnLife setBackgroundImage:[UIImage imageNamed:@"life_btn.png"] forState:UIControlStateNormal];
    [self.boosterView addSubview:btnLife];
    
    UILabel *lblLifeTime=[[UILabel alloc]initWithFrame:CGRectMake(btnLife.frame.origin.x+btnLife.frame.size.width+3, 7, 30, 20)];
    lblLifeTime.font=[UIFont systemFontOfSize:12];
    lblLifeTime.text=@"5:00";
    lblLifeTime.textColor=[UIColor blackColor];
    [self.boosterView addSubview:lblLifeTime];
    
    UIButton *btnLifePlus = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnLifePlus.frame=CGRectMake(btnLife.frame.origin.x+btnLife.frame.size.width+35, 10, 15, 15);
    [btnLifePlus setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    [btnLifePlus addTarget:self action:@selector(btnLifePlusAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.boosterView addSubview:btnLifePlus];
    
    //    viewBooster = [[UIView alloc]init];
    //    viewBooster.frame=CGRectMake(5, 50, self.view.frame.size.width-10, self.view.frame.size.height-100);
    //    viewBooster.hidden=YES;
    //    viewBooster.backgroundColor=[UIColor whiteColor];
    //    viewBooster.layer.cornerRadius=5;
    //    viewBooster.layer.borderColor=[UIColor blackColor].CGColor;
    //    viewBooster.layer.borderWidth=2;
    //    viewBooster.clipsToBounds=YES;
    //    [self.view addSubview:viewBooster];
}

#pragma mark
#pragma mark Button Action Methods

-(void)btnLifePlusAction:(id)sender {
    
    //    viewBooster.hidden=NO;
    
    //  self.headerView.userInteractionEnabled=NO;
    //self.contentContainerView.userInteractionEnabled=NO;
    //    viewBooster.hidden=NO;
    
    PurchaseView *obj = [[PurchaseView alloc]initWithButton:@"life"];
    obj.view.frame=CGRectMake(5, 50, self.view.frame.size.width-10, self.view.frame.size.height-100);
    obj.delegate=self;
    //    [self.view addSubview:obj.view];
    [self presentPopupViewController:obj animationType:MJPopupViewAnimationSlideTopBottom];
}
-(void)btnBoosterPlusAction:(id)sender {
    
    self.headerView.backgroundColor=[UIColor colorWithRed:(CGFloat)26/255 green:(CGFloat)26/255 blue:(CGFloat)26/255 alpha:1];
    self.contentContainerView.backgroundColor=[UIColor colorWithRed:(CGFloat)26/255 green:(CGFloat)26/255 blue:(CGFloat)26/255 alpha:1];
    //    self.headerView.userInteractionEnabled=NO;
    //    self.contentContainerView.userInteractionEnabled=NO;
    //    viewBooster.hidden=NO;
    
    PurchaseView *obj = [[PurchaseView alloc]initWithButton:@"booster"];
    obj.view.frame=CGRectMake(5, 50, self.view.frame.size.width-10, self.view.frame.size.height-100);
    obj.delegate=self;
    [self presentPopupViewController:obj animationType:MJPopupViewAnimationSlideTopBottom];
    //    [self.view addSubview:obj.view];
}
-(void)btnDiamondPlusAction:(id)sender {
    
    //    viewBooster.hidden=NO;
    
    //  self.headerView.userInteractionEnabled=NO;
    //self.contentContainerView.userInteractionEnabled=NO;
    //    viewBooster.hidden=NO;
    
    PurchaseView *obj = [[PurchaseView alloc]initWithButton:@"diamond"];
    obj.view.frame=CGRectMake(5, 50, self.view.frame.size.width-10, self.view.frame.size.height-100);
    obj.delegate=self;
    [self presentPopupViewController:obj animationType:MJPopupViewAnimationSlideTopBottom];
    //    [self.view addSubview:obj.view];
}
- (void)cancelButtonClicked:(PurchaseView *)aSecondDetailViewController
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) handleSwipeGesture:(UISwipeGestureRecognizer *)swipeGesture{
    
    if (self.mainsubView.frame.origin.x<0) {
        
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(0, 0,self.view.frame.size.width, self.screen_height);
            //              self.mainsubView.frame = CGRectMake(self.view.frame.size.width, 0,self.view.frame.size.width, self.screen_height);
        }completion:^(BOOL finish){
            
            self.swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        }];
        
    }
    else{
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(-200, 0, self.view.frame.size.width, self.screen_height);
            //             self.mainsubView.frame = CGRectMake(80, 0, self.view.frame.size.width, self.screen_height);
        }completion:^(BOOL finish){
            self.swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
        }];
    }
}
-(void) createMenuTableView{
    
    if (!self.menuTableView) {
        self.selectedIndex = 0;
        self.menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-200, 70, 200, self.screen_height) style:UITableViewStylePlain];
        //          self.menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 70, 20, self.screen_height) style:UITableViewStylePlain];
        //self.menuTableView.backgroundColor =  [UIColor colorWithRed:(CGFloat)112/255 green:(CGFloat)147/255 blue:(CGFloat)148/255 alpha:1];
        
        self.menuTableView.backgroundColor =  [UIColor colorWithRed:(CGFloat)39/255 green:(CGFloat)39/255 blue:(CGFloat)41/255 alpha:1];
        
        self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.menuTableView.delegate = self;
        self.menuTableView.dataSource = self;
        
    }
    else{
        [self.menuTableView reloadData];
    }
    
    [self.view insertSubview:self.menuTableView belowSubview:self.mainsubView];
    
    
    if (!imageVUser) {
        imageVUser = [[UIImageView alloc] init];
        imageVUser.frame=CGRectMake(self.view.frame.size.width-180, 2, 60, 60);
        //        [self.headerView addSubview:imageVUser];
        [self.view insertSubview:imageVUser belowSubview:self.mainsubView];
    }
    if (!lblUserName) {
        
        lblUserName = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-100,self.headerView.frame.size.height/2 , 50, 20)];
        lblUserName.font=[UIFont boldSystemFontOfSize:12];
        lblUserName.textColor=[UIColor whiteColor];
        //        [self.headerView addSubview:lblUserName];
        [self.view insertSubview:lblUserName belowSubview:self.mainsubView];
    }
    // Rajeev
    
    // Add label and Image of User
    
    
    
    
    //[self.view addSubview:self.menuTableView];
    
    /*
     //Display Menu table With Animation
     [UIView animateWithDuration:.5 animations:^{
     
     self.menuTableView.frame = CGRectMake(0, 0, self.view.frame.size.width/2, self.contentContainerView.frame.size.height);
     
     }];*/
    
    BOOL checkInternet =  [ViewController networkCheck];
    
    if (checkInternet) {
        [NSThread detachNewThreadSelector:@selector(fetchUserNameAndImage) toTarget:self withObject:nil];
    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Check internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    
}

-(void)fetchUserNameAndImage {
    
    PFQuery *query = [PFUser query];
    NSLog(@"Object Id =--= %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"objectid"]);
    [query whereKey:@"objectId" equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:@"objectid"]];
    
    [SingletonClass sharedSingleton].objectId=[[NSUserDefaults standardUserDefaults]objectForKey:@"objectid"];
    NSArray *arr = [query findObjects];
    
    NSDictionary *dict = [arr objectAtIndex:0];
    
    NSString *strName = [dict objectForKey:@"username"];
    lblUserName.text=strName;
    [SingletonClass sharedSingleton].strUserName = strName;
    NSString *rank = [dict objectForKey:@"Rank"];
    [SingletonClass sharedSingleton].userRank=rank;
    
    PFFile  *strImage = [dict objectForKey:@"userimage"];
    
    NSData *imageData = [strImage getData];
    UIImage *image = [UIImage imageWithData:imageData];
    imageVUser.image=image;
    
    [SingletonClass sharedSingleton].imageUser=image;
    
    /*
     NSString *strUserFbId = [[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
     NSNumber *numFbIdUser =  [NSNumber numberWithLongLong:[strUserFbId longLongValue]];
     
     NSString *urlString = [NSString   stringWithFormat:@"https://graph.facebook.com/%@",numFbIdUser];
     // NSLog(@"url String=-=- %@",urlString);
     
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
     [request setURL:[NSURL URLWithString:urlString]];
     [request setHTTPMethod:@"GET"];
     [request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
     NSURLResponse* response;
     NSError* error = nil;
     
     //Capturing server response
     NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
     
     NSString *str = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
     // NSLog(@"Data =-= %@",str);
     if (str) {
     
     NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:0 error:NULL];
     lblUserName = [dict objectForKey:@"first_name"];
     
     //        self.lblFbLastName = [dict objectForKey:@"last_name"];
     
     // NSLog(@"First Name =-=- %@",self.lblFbFirstName);
     // NSLog(@"last name =-=- %@",self.lblFbLastName);
     }
     */
}
#pragma mark -
-(void) menuButtonClciked:(id)sender{
    
    if (self.mainsubView.frame.origin.x<0 ) {
        
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(0, 0,self.view.frame.size.width, self.screen_height);
            
        }completion:^(BOOL finish){
            self.swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
            
        }];
    }
    else{
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(-200, 0, self.view.frame.size.width, self.screen_height);
            
        }completion:^(BOOL finish){
            
            self.swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
            
        }];
    }
    
    //    if (self.mainsubView.frame.origin.x>100 ) {
    //
    //        [UIView animateWithDuration:.5 animations:^{
    //            self.mainsubView.frame = CGRectMake(0, 0,self.view.frame.size.width, self.screen_height);
    //
    //        }completion:^(BOOL finish){
    //            self.swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    //
    //        }];
    //    }
    //    else{
    //        [UIView animateWithDuration:.5 animations:^{
    //            self.mainsubView.frame = CGRectMake(250, 0, self.view.frame.size.width, self.screen_height);
    //
    //        }completion:^(BOOL finish){
    //
    //            self.swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    //
    //        }];
    //    }
}

#pragma mark -
#pragma mark TableView Delegate and DataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        
        return self.viewControllers.count;
    }
    else if (section == 1){
        return self.secondSectionViewControllers.count;
    }
    return 0;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIColor *firstColor =  [UIColor colorWithRed:(CGFloat)39/255 green:(CGFloat)39/255 blue:(CGFloat)41/255 alpha:1];
    UIColor *secColor = [UIColor colorWithRed:(CGFloat)48/255 green:(CGFloat)48/255 blue:(CGFloat)50/255 alpha:1];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = cell.contentView.frame;
    layer.colors = [NSArray arrayWithObjects:(id)firstColor.CGColor,(id)secColor.CGColor, nil];
    
    [cell.contentView.layer insertSublayer:layer atIndex:0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    // CGRect frame = CGRectMake(cell.frame.origin.x, cell.frame.size.height-2, cell.frame.size.width, 2);
    //    UIImageView *dividerImageView = [[UIImageView alloc] initWithFrame:frame];
    //    dividerImageView.image = [UIImage imageNamed:@"vesyl_border_setting.png"];
    //    [cell.contentView addSubview:dividerImageView];
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //Check Section
    NSString * title=[NSString stringWithFormat:@"  %@",[(UIViewController *)[self.viewControllers objectAtIndex:indexPath.row] title]];
    
    //cell.textLabel.text = [NSString stringWithFormat:@"  %@",[(UIViewController *)[self.viewControllers objectAtIndex:indexPath.row] title]];
    cell.textLabel.text =  [ViewController languageSelectedStringForKey:title];
    NSString *cellValue = [(UIViewController *)[self.viewControllers objectAtIndex:indexPath.row]title];
    //adding now
    NSLog(@"cell value %@",cellValue);
    
    if ([cellValue isEqualToString:@"Home"] || [cellValue isEqualToString:@"홈"]) {
        cell.imageView.image=[UIImage imageNamed:@"home.png"];
    }
    else if ([cellValue isEqualToString:@"Topic"] || [cellValue isEqualToString:@"주제"]) {
        cell.imageView.image=[UIImage imageNamed:@"topic.png"];
    }
    else if ([cellValue isEqualToString:@"Friend"] || [cellValue isEqualToString:@"친구"]) {
        cell.imageView.image=[UIImage imageNamed:@"friends.png"];
    }
    else if ([cellValue isEqualToString:@"History"] || [cellValue isEqualToString:@"역사"]) {
        cell.imageView.image=[UIImage imageNamed:@"slideHistory.png"];
    }
    else if ([cellValue isEqualToString:@"Messages"] || [cellValue isEqualToString:@"메시지"]) {
        cell.imageView.image=[UIImage imageNamed:@"message.png"];
    }
    else if ([cellValue isEqualToString:@"Discussions"] || [cellValue isEqualToString:@"수다방"]) {
        cell.imageView.image=[UIImage imageNamed:@"discussion.png"];
    }
    else if ([cellValue isEqualToString:@"Achievements"] || [cellValue isEqualToString:@"성과"]) {
        cell.imageView.image=[UIImage imageNamed:@"achievements.png"];
    }
    else if ([cellValue isEqualToString:@"Store"] || [cellValue isEqualToString:@"스토어"]) {
        cell.imageView.image=[UIImage imageNamed:@"store.png"];
    }
    else if ([cellValue isEqualToString:@"Settings"] || [cellValue isEqualToString:@"설정"]) {
        cell.imageView.image=[UIImage imageNamed:@"settings.png"];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section==0) {
        
        //Dismiss Menu TableView with Animation
        [UIView animateWithDuration:.5 animations:^{
            
            self.mainsubView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.screen_height);
            //                self.mainsubView.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.screen_height);
            
        }completion:^(BOOL finished){
            //After completion
            //first check if new selected view controller is equals to previously selected view controller
            //self.isSignIn=YES;
            
            if (indexPath.row==self.viewControllers.count) {
                self.isSignIn = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateMenuTable" object:@"LoggedOut"];
                return;
            }
            
            if (self.selectedIndex==indexPath.row  && self.selectedSection == indexPath.section) {
                return;
            }
            
            UIViewController *newViewController = [_viewControllers objectAtIndex:indexPath.row];
            _selectedSection = indexPath.section;
            _selectedIndex = indexPath.row;
            
            [self getSelectedViewControllers:newViewController];
        }];
        
    }//Index Path 1 End
    else if (indexPath.section == 1){
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.mainsubView.frame = CGRectMake(320, 0, self.view.frame.size.width, self.screen_height);
        }completion:^(BOOL finished){
            
            UIViewController *newViewController = [_secondSectionViewControllers objectAtIndex:indexPath.row];
            _selectedSection = indexPath.section;
            _selectedIndex = indexPath.row;
            
            [self getSelectedViewControllers:newViewController];
            
            [UIView animateWithDuration:.5 animations:^{
                self.mainsubView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.screen_height);
                //                  self.mainsubView.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.screen_height);
            }completion:^(BOOL finished){
                
                
            }];
        }];
    }
}
-(void) getSelectedViewControllers:(UIViewController *)newViewController{
    // selected new view controller
    UIViewController *oldViewController = _selectedViewController;
    
    if (newViewController != nil) {
        [oldViewController.view removeFromSuperview];
        _selectedViewController = newViewController;
        
        //        if ([_selectedViewController.title isEqualToString:@"Topic"]) {
        //            _selectedViewController.view.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height);
        //        }
        //        else{
        //Update Container View with selected view controller view
        //            [self updateViewContainer];
        //        }
        //Update Container View with selected view controller view
        [self updateViewContainer];
        //Check Delegate assign or not
    }
}
-(void) updateViewContainer{
    self.selectedViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    //NSLog(@"View Height  = %f",self.contentContainerView.frame.size.height);
    self.selectedViewController.view.frame = self.contentContainerView.bounds;
    //    NSLog(@"Selected view frame = %f",self.selectedViewController.view.frame.size.width);
    //NSLog(@"Selected View Height = %f",self.selectedViewController.view.frame.size.height);
    self.menuLabel.text = self.selectedViewController.title;
    NSLog(@"menu label -=- %@",self.menuLabel.text);
    [self.contentContainerView addSubview:self.selectedViewController.view];
}

@end

static void * const kMyPropertyAssociatedStorageKey = (void*)&kMyPropertyAssociatedStorageKey;

@implementation UIViewController (CustomMenuViewControllerItem)
@dynamic customMenuViewController;

static char const * const orderedElementKey;

-(void) setCustomMenuViewController:(CustomMenuViewController *)customMenuViewController{
    
    NSLog(@"cc==%@",customMenuViewController.viewControllers);
    
    objc_setAssociatedObject(self, &orderedElementKey, customMenuViewController,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //        objc_setAssociatedObject(self, @selector(customMenuViewController), customMenuViewController,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CustomMenuViewController *) customMenuViewController{
    
    if (objc_getAssociatedObject(self, &orderedElementKey) != nil)
    {
        NSLog(@"Element: %@", objc_getAssociatedObject(self, orderedElementKey));
    }
    
    NSLog(@"Element: %@", objc_getAssociatedObject(self, &orderedElementKey));
    //    return objc_getAssociatedObject(self, @selector(customMenuViewController));
    return objc_getAssociatedObject(self, orderedElementKey);
    //return  self.customMenuViewController;
}

/*
 -(CustomMenuViewController *) customViewController{
 //return objc_getAssociatedObject(self, kMyPropertyAssociatedStorageKey);
 return objc_getAssociatedObject(self, @selector(customMenuViewController));
 }
 -(CustomMenuViewController *)firstAvailableViewController{
 return (CustomMenuViewController*)[self traverseResponderChainforUIViewController];
 }
 
 -(id) traverseResponderChainforUIViewController{
 
 id nextResponse = [self nextResponder];
 
 if ([nextResponse isKindOfClass:[CustomMenuViewController class]]){
 return nextResponse;
 }
 else if ([nextResponse isKindOfClass:[UIViewController class]]) {
 return nextResponse;
 }
 else{
 [self traverseResponderChainforUIViewController];
 }
 return  nil;
 }
 */

@end
