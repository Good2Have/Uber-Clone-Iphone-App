//
//  About.m
//  UberValetService
//
//  Created by Globussoft 1 on 11/25/14.
//  Copyright (c) 2014 Globussoft 1. All rights reserved.
//

#import "About.h"

@interface About ()
{
    NSArray *array;
}
@end

@implementation About

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@""]];
    
    array=[NSArray arrayWithObjects:@"Rate us in the App Store ",@"Like us on Facebook",@"Legal ",@"Uber.com", nil];
    
//    UIWebView *web=[[UIWebView alloc] initWithFrame:CGRectMake(40, 40, self.view.frame.size.width, self.view.frame.size.height)];
//    [web loadRequest:request];
//    [self.view addSubview:web];
    
    UITableView *table=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    table.delegate=self;
    table.dataSource=self;
    [self.view addSubview:table];
    
    // Do any additional setup after loading the view.
}


-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
        // Configure the cell...
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        tableView.hidden=YES;
         NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"www.uber.com"]];
        
       UIWebView *web=[[UIWebView alloc] initWithFrame:CGRectMake(40, 40, self.view.frame.size.width, self.view.frame.size.height)];
            [web loadRequest:request];
            [self.view addSubview:web];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
