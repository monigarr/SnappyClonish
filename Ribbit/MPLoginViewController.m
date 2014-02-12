//
//  MPLoginViewController.m
//  Ribbit
//
//  Created by Monica Peters on 1/27/14.
//  Copyright (c) 2014 MoniGarr. All rights reserved.
//

#import "MPLoginViewController.h"
#import <Parse/Parse.h>

@interface MPLoginViewController ()

@end

@implementation MPLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	if ([UIScreen mainScreen].bounds.size.height == 568) {
		self.backgroundImageView.image = [UIImage imageNamed:@"loginBackground"];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	//hide nav bar
	[self.navigationController.navigationBar setHidden:YES];
}

- (IBAction)login:(id)sender {
	//get values from fields store in vars
	NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if ([username length] == 0 || [password length] == 0) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ooops!" message:@"Enter a Username & Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		
		[alertView show];
	} else {
		[PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
			if (error){
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alertView show];
			} else {
				[self.navigationController popToRootViewControllerAnimated:YES];
			}
		}];
	}
}


@end
