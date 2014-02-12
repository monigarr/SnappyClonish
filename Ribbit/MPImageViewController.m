//
//  MPImageViewController.m
//  Ribbit
//
//  Created by Monica Peters on 1/28/14.
//  Copyright (c) 2014 MoniGarr. All rights reserved.
//

#import "MPImageViewController.h"

@interface MPImageViewController ()

@end

@implementation MPImageViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	//download file from parse
	PFFile *imageFile = [self.message objectForKey:@"file"];
	NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
	NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
	self.imageView.image = [UIImage imageWithData:imageData];
	
	NSString *senderName = [self.message objectForKey:@"senderName"];
	NSString *title = [NSString stringWithFormat:@"Message from %@", senderName];
	self.navigationItem.title = title;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if ([self respondsToSelector:@selector(timeOut)]) {
		[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeOut) userInfo:Nil repeats:NO];
	} else {
		NSLog(@"Error: selector missing");
	}
}

#pragma mark - Helper Methods

- (void)timeOut {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

@end
