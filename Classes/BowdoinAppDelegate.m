//
//  BowdoinAppDelegate.m
//  Bowdoin College
//
//  Created by Ben Johnson on 7/17/09.
//  Copyright __Bowdoin__ 2009. All rights reserved.
//
//  The App delegate is responsible for initializing the application
//  and checking whether previous menu data is stored and current. It also
//  checks whether there is an internet connection for updating menus when necessary.
//
//  A notification screen pops up if menus are not current and there is no interen
//  connection to update.

#import "BowdoinAppDelegate.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>

@implementation BowdoinAppDelegate

@synthesize window;
@synthesize navController, controlBar;
@synthesize noConnectionAlert, noConnectionLabel, noConnectionLabel2;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	// Test controller to check whether menus are current.
	XMLFeedViewController *testController = [[XMLFeedViewController alloc]init];
	NSLog(@"INITIAL CONTENT LOADED");
	// Checks for network connectivity
	if (![self connectedToNetwork: @"www.apple.com"] && [testController checkIfCurrentDataExists] ){
		NSString *title = @"No Internet Connection";
		NSString *message = @"The dining menus need to be updated and your device is not connected to the internet. Please make sure you are connected before restarting the application.";
		NSString *cancelButtonTitle = @"Close Notification";			  
						  
		//allert view created if necessary				  
		UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:(NSString *)title 
															message:(NSString *)message 
														   delegate: self 
												  cancelButtonTitle:(NSString *)cancelButtonTitle
												  otherButtonTitles: NULL];
		
		self.noConnectionAlert = tempAlert;
		[tempAlert release];
		
		[noConnectionAlert show];
		noConnectionLabel.text = @"No Internet Connection Detected";
		noConnectionLabel2.text = @"Please Restart the Application";
		[window makeKeyAndVisible];
		
	}  else {
		// Adds the Navigation controller to the view.
		// Initializes normally.
		controlBar.tintColor = [UIColor darkGrayColor];
		controlBar.segmentedControlStyle = UISegmentedControlStyleBar;
		[window addSubview:[navController view]];
		[window makeKeyAndVisible];
		
	}
	
	[testController release];
	
	
	
	
		
}

// This code was pulled from the iPhone Dev Forums as a means of
// testing network connectivity.

- (BOOL) connectedToNetwork: (NSString *) remoteServer {
    NSLog(@"Connnected to Network");
	NSLog(@"Content Will Begin Downloading");

	// Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
	
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
	
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags){
        NSLog(@"Error. Could not recover network reachability flags");
        return NO;
    }
	
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
	
    NSURL *testURL = [NSURL URLWithString: remoteServer];
    NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
    NSURLConnection *testConnection = [[NSURLConnection alloc] initWithRequest:testRequest delegate:self];
	
    return ((isReachable && !needsConnection) || nonWiFi) ? (testConnection ? YES : NO) : NO;
}

- (void)dealloc {
	
	[navController release];
	[controlBar release];
	[noConnectionAlert release];
	[noConnectionLabel release];
	[window release];
	[super dealloc];
}


@end

