//
//  MPFriendsViewController.m
//  Ribbit
//
//  Created by Monica Peters on 1/27/14.
//  Copyright (c) 2014 MoniGarr. All rights reserved.
//

#import "MPFriendsViewController.h"
#import "MPEditFriendsViewController.h"
#import "MSCellAccessory.h"
#import "GravatarUrlBuilder.h"

@interface MPFriendsViewController ()

@end

@implementation MPFriendsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"showEditFriends"]) {
		MPEditFriendsViewController *viewController = (MPEditFriendsViewController *)segue.destinationViewController;
		viewController.friends = [NSMutableArray arrayWithArray:self.friends];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
	
	//get data from backend
	PFQuery *query = [self.friendsRelation query];
	[query orderByAscending:@"username"];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (error) {
			NSLog(@"%@ %@", error, [error userInfo]);
		} else {
			self.friends = objects;
			[self.tableView reloadData];
		}
	}];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
	cell.textLabel.text = user.username;

	//GCD asynch downloading
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(queue, ^{
		// 1. get email
		NSString *email = [user objectForKey:@"email"];
		
		// 2. create md5 hash
		NSURL *gravatarUrl = [GravatarUrlBuilder getGravatarUrl:email];
		
		// 3. request image from gravatar
		NSData *imageData = [NSData dataWithContentsOfURL:gravatarUrl];
		
		//above is not signalling to main thread YET

		if (imageData != nil) {
			dispatch_async(dispatch_get_main_queue(), ^{
				// 4. set image in cell - put in main thread instead
				cell.imageView.image = [UIImage imageWithData:imageData];
				//redraw the cell
				[cell setNeedsLayout];
			});
		}
	});
	
	cell.imageView.image = [UIImage imageNamed:@"icon_person"];
    return cell;
}

@end
