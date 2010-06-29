//
//  GrillAreaViewController.m
//  Bowdoin
//
//  Created by Ben Johnson on 8/3/09.
//  Copyright 2009 __Bowdoin College__ All rights reserved.
//

#import "GrillAreaViewController.h"


@implementation GrillAreaViewController
@synthesize aWebView, doneButton, callGrillButton, activityIndicator;


// Loads the Grill PDF
- (void)viewDidLoad {
    [super viewDidLoad];
	[activityIndicator startAnimating];
	
	[aWebView setDelegate:self];
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Magees3.pdf"];
	[aWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:databasePathFromApp]]];
	
}

- (void)webViewDidStartLoad:(UIWebView *)sender {

	
}

// implemented for the activityIndicator
- (void)webViewDidFinishLoad:(UIWebView *)sender {
	[activityIndicator stopAnimating];


}

// Dismisses the modal controller
- (IBAction)dismissModalController {
	[self dismissModalViewControllerAnimated:YES];
}

// Calls the Grill
- (IBAction)callTheGrill{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://2077253888"]];
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[aWebView release];
	[doneButton release];
	[callGrillButton release];
	[activityIndicator release];
    [super dealloc];
}


@end
