//
//  MPInboxViewController.h
//  Ribbit
//
//  Created by Monica Peters on 1/26/14.
//  Copyright (c) 2014 MoniGarr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Parse/Parse.h>

@interface MPInboxViewController : UITableViewController

@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) PFObject *selectedMessage;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong) UIRefreshControl *refreshControl;


- (IBAction)logout:(id)sender;

@end
