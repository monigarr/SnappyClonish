//
//  MPSignupViewController.m
//  Ribbit
//
//  Created by Monica Peters on 1/27/14.
//  Copyright (c) 2014 MoniGarr. All rights reserved.
//

#import "MPSignupViewController.h"
#import <Parse/Parse.h>

@interface MPSignupViewController ()

@end

@implementation MPSignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationController.navigationBar setHidden:YES];
	
	if ([UIScreen mainScreen].bounds.size.height == 568) {
		self.backgroundImageView.image = [UIImage imageNamed:@"loginBackground"];
	}
}

- (IBAction)signup:(id)sender {
	//get values from fields store in vars
	NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if ([username length] == 0 || [email length] == 0 || [password length] == 0) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ooops!" message:@"Enter a Username, Password, & Email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		
		[alertView show];
	} else {
		PFUser *newUser = [PFUser user];
		newUser.username = username;
		newUser.password = password;
		newUser.email = email;
		
		[newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
			if (error){
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alertView show];
			} else {
				[self.navigationController popToRootViewControllerAnimated:YES];
			}
		}];
	}
	
}

- (IBAction)dismiss:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
