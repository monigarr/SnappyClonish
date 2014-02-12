//
//  MPEditFriendsViewController.h
//  Ribbit
//
//  Created by Monica Peters on 1/27/14.
//  Copyright (c) 2014 MoniGarr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MPEditFriendsViewController : UITableViewController

@property (nonatomic, strong) NSArray *allUsers;
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSMutableArray *friends;

- (BOOL)isFriend:(PFUser *)user;

@end
