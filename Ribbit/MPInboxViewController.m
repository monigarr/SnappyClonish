//
//  MPInboxViewController.m
//  Ribbit
//
//  Created by Monica Peters on 1/26/14.
//  Copyright (c) 2014 MoniGarr. All rights reserved.
//

#import "MPInboxViewController.h"
#import "MPImageViewController.h"
#import "MSCellAccessory.h"

@interface MPInboxViewController ()

@end

@implementation MPInboxViewController

UIColor *disclosureColor;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.moviePlayer = [[MPMoviePlayerController alloc]init];
	
	//PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
	//testObject[@"foo"] = @"bar";
	//[testObject saveInBackground];
	
	PFUser *currentUser = [PFUser currentUser];
	if (currentUser) {
		NSLog(@"current user: %@", currentUser.username);
	} else {
		[self performSegueWithIdentifier:@"showLogin" sender:self];
	}
	self.refreshControl = [[UIRefreshControl alloc] init];
	[self.refreshControl addTarget:self action:@selector(retrieveMessages) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self retrieveMessages];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
	cell.textLabel.text = [message objectForKey:@"senderName"];
	
	//custom disclosure arrows
	UIColor *disclosureColor = [UIColor colorWithRed:0.553 green:0.439 blue:0.718 alpha:1.0];
	cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR color:disclosureColor];
	
	//is message photo or video?
	NSString *fileType = [message objectForKey:@"fileType"];
	if ([fileType isEqualToString:@"image"]) {
		cell.imageView.image = [UIImage imageNamed:@"icon_image"];
	} else {
		cell.imageView.image = [UIImage imageNamed:@"icon_video"];
	}
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//if image view in imagecontroller
	//if movie use mpmoviecontroller
	self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
	
	//is message photo or video?
	NSString *fileType = [self.selectedMessage objectForKey:@"fileType"];
	if ([fileType isEqualToString:@"image"]) {
		//image
		[self performSegueWithIdentifier:@"showImage" sender:self];
	} else {
		//video
		PFFile *videoFile = [self.selectedMessage objectForKey:@"file"];
		NSURL *fileUrl = [NSURL URLWithString:videoFile.url];
		self.moviePlayer.contentURL = fileUrl;
		//prep for playing after content url is set
		[self.moviePlayer prepareToPlay];
		//[self.moviePlayer thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
		[self.moviePlayer requestThumbnailImagesAtTimes:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
		
		//add it to view controller so we can see it
		[self.view addSubview:self.moviePlayer.view];
		[self.moviePlayer setFullscreen:YES animated:YES];
	}
	
	// Destruct Message.
	NSMutableArray *recipientIds = [NSMutableArray arrayWithArray:[self.selectedMessage objectForKey:@"recipientIds"]];
	NSLog(@"Recipients %@", recipientIds);
	
	if ([recipientIds count] == 1) {
		//delete it
		[self.selectedMessage deleteInBackground];
	} else {
		//only remove recipient and save message
		[recipientIds removeObject:[[PFUser currentUser] objectId]];
		[self.selectedMessage setObject:recipientIds forKey:@"recipientIds"];
		[self.selectedMessage saveInBackground];
		
		//todo in future use parse api rest call to delete file later for extra credit
		
		//clean up files for now
		
	}
}

#pragma mark - Helper Methods
- (IBAction)logout:(id)sender {
	[PFUser logOut];
	[self performSegueWithIdentifier:@"showLogin" sender:self];
	//hide backbutton and tabs
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"showLogin"]) {
		[segue.destinationViewController setHidesBottomBarWhenPushed:YES];
	} else if ([segue.identifier isEqualToString:@"showImage"]) {
		[segue.destinationViewController setHidesBottomBarWhenPushed:NO];
		MPImageViewController *imageViewController = (MPImageViewController *)segue.destinationViewController;
		imageViewController.message = self.selectedMessage;
	}
}

- (void)retrieveMessages {
	//get our own messages, not all messages
	PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
	[query whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
	[query orderByDescending:@"createdAt"];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (error) {
			NSLog(@"Error: %@ %@", error, [error userInfo]);
		} else {
			// We Found Messages.
			self.messages = objects;
			[self.tableView reloadData];
			NSLog(@"Retrieved %d messages", [self.messages count]);
		}
		
		if ([self.refreshControl isRefreshing]) {
			[self.refreshControl endRefreshing];
		}
	}];
}


@end
