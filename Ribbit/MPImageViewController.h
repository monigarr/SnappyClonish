//
//  MPImageViewController.h
//  Ribbit
//
//  Created by Monica Peters on 1/28/14.
//  Copyright (c) 2014 MoniGarr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MPImageViewController : UIViewController

@property (nonatomic,strong) PFObject *message;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
