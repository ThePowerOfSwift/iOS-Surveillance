//
//  MultipeerViewController.m
//  Surveillance
//
//  Created by Dillon Butt on 2016-04-02.
//  Copyright © 2016 Dillon Butt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultipeerViewController.h"
#import "AppDelegate.h"
@implementation MultipeerViewController
{
   // NSMutableArray *tableData;
}
-(void) viewDidLoad
{
    //(YourAppDelegateClass *)[UIApplication sharedApplication].delegat
    AppDelegate* test = [UIApplication sharedApplication].delegate;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate* test = [UIApplication sharedApplication].delegate;
    NSMutableArray *testData = test.tableData;
    return [testData count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName = @"Timestamp Data";;

    return sectionName;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    AppDelegate* test = [UIApplication sharedApplication].delegate;
    NSMutableArray *testData = test.tableData;
    
    cell.textLabel.text = [testData objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"camera"];
    return cell;
}


- (void)viewDidAppear:(BOOL)animated
{
    //sets the tab bar badge value
    /*self.tabBarItem.badgeValue = @"1";
    //sets the current time on a label
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    //[outputFormatter setDateFormat:@"HH:mm:ss"];
    [outputFormatter setDateFormat:@"HH':'mm':'ss' 'dd'/'MM'/'yyyy'"];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    NSLog(@"Timestamp: %@", newDateString);
    
    AppDelegate* test = [UIApplication sharedApplication].delegate;
    NSMutableArray *testData = test.tableData;
    
    //[testData addObject:newDateString];*/
    
    self.tabBarItem.badgeValue = nil;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#

@end
