//
//  MultipeerViewController.m
//  Surveillance
//
//  Created by Dillon Butt on 2016-04-02.
//  Copyright © 2016 Dillon Butt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultipeerViewController.h"

@implementation MultipeerViewController
{
   // NSMutableArray *tableData;
}
@synthesize tableData;
-(void) viewDidLoad
{
    tableData = [NSMutableArray arrayWithObjects:@"TimeStamp Data", nil];
    NSLog(@"Table Made");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"camera"];
    return cell;
}


- (void)viewDidAppear:(BOOL)animated
{
    //sets the tab bar badge value
    self.tabBarItem.badgeValue = @"1";
    //sets the current time on a label
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    //[outputFormatter setDateFormat:@"HH:mm:ss"];
    [outputFormatter setDateFormat:@"HH':'mm':'ss' 'dd'/'MM'/'yyyy'"];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    NSLog(@"Timestamp: %@", newDateString);
    [tableData addObject:newDateString];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#

@end
