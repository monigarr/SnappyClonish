//
//  MPCameraViewController.m
//  Ribbit
//
//  Created by Monica Peters on 1/27/14.
//  Copyright (c) 2014 MoniGarr. All rights reserved.
//

#import "MPCameraViewController.h"
#import "MSCellAccessory.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface MPCameraViewController ()

@end

@implementation MPCameraViewController

UIColor *disclosureColor;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.recipients = [[NSMutableArray alloc] init];
	disclosureColor = [UIColor colorWithRed:0.553 green:0.439 blue:0.718 alpha:1.0];
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
	
	if (self.image == nil && [self.videoFilePath length] == 0) {
		//setup a camera
		self.imagePicker = [[UIImagePickerController alloc] init];
		self.imagePicker.delegate = self;
		self.imagePicker.allowsEditing = NO;
		self.imagePicker.videoMaximumDuration = 10;
	
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
		
	} else {
		self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	
	self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
	//present camera modally
	[self presentViewController:self.imagePicker animated:NO completion:nil];
	}
	
	
	
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
	
	if ([self.recipients containsObject:user.objectId]) {
		cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureColor];
	} else {
		cell.accessoryView = nil;
	}
	
    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	PFUser *user = [self.friends objectAtIndex:indexPath.row];
	
	if (cell.accessoryView == nil) {
		cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureColor];
		[self.recipients addObject:user.objectId];
	} else {
		cell.accessoryView = nil;
		[self.recipients removeObject:user.objectId];
	}
	
	//NSLog(@"%@", self.recipients);
}

#pragma mark - Image Picker Controller Delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissViewControllerAnimated:NO completion:nil];
	[self.tabBarController setSelectedIndex:0];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	
	if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
		// pic was taken or selected
		self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
		if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
			//save the image only if its from camera
			UIImageWriteToSavedPhotosAlbum(self.image, nil,nil,nil);
		}
	} else {
		//video was taken or selected
		self.videoFilePath = (__bridge NSString *)([[info objectForKey:UIImagePickerControllerMediaURL] path]);
		if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
			//save video only if its from camera
			if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)){
				UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath,nil,nil,nil);
			}
		}
	}
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBActions


- (IBAction)cancel:(id)sender {
	[self reset];
	
	[self.tabBarController setSelectedIndex:0];
}

- (IBAction)send:(id)sender {
	if (self.image == nil && [self.videoFilePath length] == 0) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Try Again" message:@"Capture or Pick an Image or Video" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[self presentViewController:self.imagePicker animated:NO completion:nil];
	} else {
		[self uploadMessage];
		
		[self.tabBarController setSelectedIndex:0];
	}
}

#pragma mark - Helper Methods

- (void)uploadMessage {
	
	NSData *fileData;
	NSString *fileName;
	NSString *fileType;
	
	//nbprogresshub 3rd party library to show nice message in future
	
	// check if image or video
	// if image shrink it
	// upload file
	// upload message details
	
	if (self.image != nil) {
		UIImage *newImage = [self resizeImage:self.image toWidth:320.0f andHeight:480.0f];
		fileData = UIImagePNGRepresentation(newImage);
		fileName = @"image.png";
		fileType = @"image";
	} else {
		fileData = [NSData dataWithContentsOfFile:self.videoFilePath];
		fileName = @"video.mov";
		fileType = @"video";
	}
	
	PFFile *file = [PFFile fileWithName:fileName data:fileData];
	[file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (error) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Try Sending Your Message Again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alertView show];
		} else {
			PFObject *message = [PFObject objectWithClassName:@"Messages"];
			[message setObject:file forKey:@"file"];
			[message setObject:fileType forKey:@"fileType"];
			[message setObject:self.recipients forKey:@"recipientIds"];
			[message setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
			[message setObject:[[PFUser currentUser] username] forKey:@"senderName"];
			[message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
				
				if (error) {
					UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Try Sending Your Message Again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
					[alertView show];
				} else {
					//all was successful
					[self reset];
				}
	
			}];
		}
	}];
}

- (void)reset {
	self.image = nil;
	self.videoFilePath = nil;
	[self.recipients removeAllObjects];
}

- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height {
	CGSize newSize = CGSizeMake(width, height);
	CGRect newRectangle = CGRectMake(0, 0, width, height);
	UIGraphicsBeginImageContext(newSize);
	[self.image drawInRect:newRectangle];
	UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return resizedImage;
}


@end
