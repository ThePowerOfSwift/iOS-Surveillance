//
//  MultipeerViewController.h
//  Surveillance
//
//  Created by Dillon Butt on 2016-04-02.
//  Copyright © 2016 Dillon Butt. All rights reserved.
//

#ifndef MultipeerViewController_h
#define MultipeerViewController_h
#import <UIKit/UIKit.h>

@interface MultipeerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableData;

@end

#endif /* MultipeerViewController_h */
