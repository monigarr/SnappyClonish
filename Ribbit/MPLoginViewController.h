//
//  MPLoginViewController.h
//  Ribbit
//
//  Created by Monica Peters on 1/27/14.
//  Copyright (c) 2014 MoniGarr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (IBAction)login:(id)sender;

@end
