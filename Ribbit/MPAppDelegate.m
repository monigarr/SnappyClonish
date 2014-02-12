//
//  MPAppDelegate.m
//  Ribbit
//
//  Created by Monica Peters on 1/26/14.
//  Copyright (c) 2014 MoniGarr. All rights reserved.
//

#import "MPAppDelegate.h"
#import <Parse/Parse.h>

@implementation MPAppDelegate

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	// Store the deviceToken in the current installation and save it to Parse.
	PFInstallation *currentInstallation = [PFInstallation currentInstallation];
	[currentInstallation setDeviceTokenFromData:deviceToken];
	[currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
	[PFPush handlePush:userInfo];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	//show launch image a little while longer
    [NSThread sleepForTimeInterval:1.5];
	
	[Parse setApplicationId:@"LGFstSvVx9KWsWyaUIvHN51AX727rP9Gi2nm1Vdp"
				  clientKey:@"JsF0P2NXWceQDUdVgtHkK0aiQRmtpGau3CR8TotJ"];
	[application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
	 UIRemoteNotificationTypeAlert|
	 UIRemoteNotificationTypeSound];
	
	[self customizeUserInterface];
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Helper Methods

- (void)customizeUserInterface {
	// Nav Bar
	//convert hex to uicolor http://scratch.johnnypez.com/hex-to-uicolor/
	//[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.553 green:0.435 blue:0.758 alpha:1.0]];
	[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBarBackground"] forBarMetrics:UIBarMetricsDefault];
	
	
	[[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
	
	//button text color
	[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
	
	// Tab Bar
	[[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
	
	UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
	UITabBar *tabBar = tabBarController.tabBar;
	
	
	UITabBarItem *tabInbox = [tabBar.items objectAtIndex:0];
	UITabBarItem *tabFriends = [tabBar.items objectAtIndex:1];
	UITabBarItem *tabCamera = [tabBar.items objectAtIndex:2];
	
	[tabInbox setImage:[[UIImage imageNamed:@"inbox"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
	[tabFriends setImage:[[UIImage imageNamed:@"friends"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
	[tabCamera setImage:[[UIImage imageNamed:@"camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}


@end
