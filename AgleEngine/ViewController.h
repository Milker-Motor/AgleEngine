//
//  ViewController.h
//  AgleEngine
//
//  Created by Lesha on 16.08.16.
//  Copyright © 2016 Lesha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *mainSegmentedControl;
@property (weak, nonatomic) IBOutlet UISearchBar *mainSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@end
