//
//  MPEditFriendsViewController.m
//  Ribbit
//
//  Created by Monica Peters on 1/27/14.
//  Copyright (c) 2014 MoniGarr. All rights reserved.
//

#import "MPEditFriendsViewController.h"
#import "MSCellAccessory.h"

@interface MPEditFriendsViewController ()

@end

@implementation MPEditFriendsViewController

//global var
UIColor *disclosureColor;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	//query all users
	PFQuery *query = [PFUser query];
	[query orderByAscending:@"username"];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (error) {
			NSLog(@"Error: %@ %@", error, [error userInfo]);
		} else {
			self.allUsers = objects;
			//NSLog(@"%@", self.allUsers);
			[self.tableView reloadData];
		}
	}];
	
	self.currentUser = [PFUser currentUser];
	
	disclosureColor = [UIColor colorWithRed:0.553 green:0.439 blue:0.718 alpha:1.0];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
	cell.textLabel.text = user.username;
    
	if ([self isFriend:user]) {
		//custom disclosure arrows
		cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureColor];
	} else {
		cell.accessoryView = nil;
	}
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
	PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
	
	if ([self isFriend:user]) {
		//1 remove checkmark
		cell.accessoryView = nil;
		
		//2 remove from friend array dont use this loop with large data
		for (PFUser *friend in self.friends) {
			if ([friend.objectId isEqualToString:user.objectId]) {
				[self.friends removeObject:friend];
				break;
			}
		}
		//3 remove friend from backend
		[friendsRelation removeObject:user];
	} else {
		cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureColor];
		[self.friends addObject:user];
		[friendsRelation addObject:user];
	}
	
	//save to backend asynchronously
	[self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (error) {
			NSLog(@"Error %@ %@", error, [error userInfo]);
		}
	}];
}

#pragma mark - Helper Methods
- (BOOL)isFriend:(PFUser *)user {
	for (PFUser *friend in self.friends) {
		if ([friend.objectId isEqualToString:user.objectId]) {
			return YES;
		}
	}
	
	return NO;
}


@end
