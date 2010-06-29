//
//  XMLFeedViewController.m
//  Bowdoin
//
//  Created by Ben Johnson on 7/17/09.
//  Copyright 2009 __Bowdoin__. All rights reserved.


#import "XMLFeedViewController.h"
#import "BowdoinAppDelegate.h"
#import "ContentAreaViewController.h"
#import "GrillAreaViewController.h"
#import "HourScrollViewController.h"

static NSUInteger kNumberOfPages = 2;

#pragma mark -
#pragma mark InterFace and Initialization

@interface XMLFeedViewController (PrivateMethods)

- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;

@end

@implementation XMLFeedViewController

@synthesize diningHallLabel, segmentedControlBar, daySegmentedControl, scrollView,
			leftButton, rightButton, infoButton, //toolBar, 
			//todayButton, tomorrowButton,
			eveningMenuBoolean,
			loadNeeded;

@synthesize thorneController, moultonController, hourController, grillMenuController;

#pragma mark -
#pragma mark ViewController Initialization

- (void)viewDidLoad {
	NSLog(@"Establishing Atreus Dining Server Connection");

	//** Apple Code for the Segmented Control Bar **//
	UISegmentedControl *tempControlBar = self.navigationItem.titleView;
	self.segmentedControlBar = tempControlBar;
	[tempControlBar release];
	
	[segmentedControlBar addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	
	[daySegmentedControl addTarget:self action:@selector(dayAction:) forControlEvents:UIControlEventValueChanged];
	daySegmentedControl.tintColor = [UIColor darkGrayColor];
	daySegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	

	
	//This code initializes an instance of the ContentArea to determine
	//segmented control button to initialize with
	ContentAreaViewController *tempController = [[ContentAreaViewController alloc] init];
	NSString* tempString = [tempController getMeal];
	[segmentedControlBar setSelectedSegmentIndex:-1];
	
	// Sets the segmented control button labels
	if (tempString == @"Breakfast")
		[segmentedControlBar setSelectedSegmentIndex:0];
	else if (tempString == @"Lunch")
		[segmentedControlBar setSelectedSegmentIndex:1];
	else if (tempString == @"Dinner")
		[segmentedControlBar setSelectedSegmentIndex:2];
	else if (tempString == @"Brunch")
		[segmentedControlBar setSelectedSegmentIndex:3];
	
	// Sets the selectedSegment integer to represent the selectedSegmentIndex
	selectedSegment = [segmentedControlBar selectedSegmentIndex];
	self.navigationItem.titleView = segmentedControlBar;
	
    [super viewDidLoad];
	
	//**** Scroll View Code *****/
	scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    scrollView.showsVerticalScrollIndicator = NO;
	scrollView.scrollEnabled = NO;
    scrollView.scrollsToTop = NO;
	scrollView.delegate = self;
	scrollView.directionalLockEnabled = YES;
	scrollView.delaysContentTouches = NO;
	scrollView.canCancelContentTouches = NO;
	
	
	//** Left|Right Button Code **//
	[leftButton addTarget:self action:@selector(leftButtonPressed) forControlEvents: UIControlEventTouchDown];
	[rightButton addTarget:self action:@selector(rightButtonPressed) forControlEvents: UIControlEventTouchDown];
	[rightButton setBackgroundColor:[UIColor grayColor]];
	
	

	
	
	// Checks the same temp Content Controller to determine whether
	// the 'Evening Menu' (displaying the next day's breakfast) is 
	// being displayed. If so buttons at the bottom are set to reflect
	// the change
	[daySegmentedControl setTitle:[tempController getCurrentDayTitle] forSegmentAtIndex:1];

	
	if ([tempController eveningMenuEnabled]){
		[daySegmentedControl setTitle:@"Tomorrow" forSegmentAtIndex:0];
		[daySegmentedControl setTitle:[tempController getNextDayTitle] forSegmentAtIndex:1];
	}
	
	[tempController release];
	loadNeeded = YES; // unless checkIfCurrentDataExists indicates otherwise
	[self checkIfCurrentDataExists];
	[self loadScrollView];
	
	// This code creates a larger area for the info button to increase the
	// likeliness that it will be selected when a tap originated in the general area
	CGRect newInfoButtonRect = CGRectMake(infoButton.frame.origin.x-25, 
										  infoButton.frame.origin.y-25, 
										  infoButton.frame.size.width+50, 
										  infoButton.frame.size.height+50); 
	
	
	[infoButton setFrame:newInfoButtonRect]; 
		
}

// method for returning the documentsDirectory for local storage
- (NSString *)documentsDirectory {
	NSLog(@"......Accessing Documents Directory");

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

// checks to see if current data exists
- (BOOL)checkIfCurrentDataExists {
	NSLog(@"Checking For Past Content");

	// Loads a stored array of Month, Day, and Hour for
	// comparison with current values
	NSMutableArray *pastData = [[NSMutableArray alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/timeArray%i",[self documentsDirectory],49]];
	//NSLog([NSString stringWithFormat:@"Trying to Load Path %@/timeArray%i",[self documentsDirectory],49]);
	
	if (pastData == nil){
		return YES;
	}
	int storedMonth = [[pastData objectAtIndex:0] intValue];
	int storedDay =   [[pastData objectAtIndex:1] intValue];
	int storedHour =  [[pastData objectAtIndex:2] intValue];
	
	[pastData release];
	
	/*
	NSLog([NSString stringWithFormat:@"Stored Month = %i", storedMonth]);
	NSLog([NSString stringWithFormat:@"Stored Day = %i", storedDay]);
	NSLog([NSString stringWithFormat:@"Stored Hour = %i", storedHour]);
	*/
	
	

	
	// creates a tempController to find the currentTime values
	ContentAreaViewController *tempController = [[ContentAreaViewController alloc] init];
	int currentMonth = [tempController getMonth];
	int currentDay = [tempController getDay];
	int currentHour = [tempController getHour];
	[tempController release];

	// The intelligence behind whether a menu is current
	if (currentMonth == storedMonth){							//same Month
		if (currentDay == storedDay){							//same Day
			if (storedHour < 20 && currentHour >= 20) {			//stored before Evening
				loadNeeded = YES;
			}
			else if (storedHour >= 20 && currentHour >= 20){
				loadNeeded = NO;
			}
		    else {
				loadNeeded = NO;
			}
					
			
		}
		else if (currentDay == storedDay+1 && storedHour >= 20){
			if (currentHour < 20) {
				loadNeeded = NO;
			}
			else {
				loadNeeded = YES;
			}
		}
		else {
			loadNeeded = YES;
		}
		
	}
	else if (currentMonth == storedMonth+1){				//special case for end of month
		if (currentDay == 1){
			if (storedHour >= 20){
				loadNeeded = NO;
			}
			if (currentHour >= 20){
				loadNeeded = YES;
			}
		}
	}
		
	// returns whether load is needed
	// this seems counter-intuitive in terms of the method name
	// but it will have to stay this way for now
	return loadNeeded;
	
}
 

/*** Method for setting up Content Area View Controllers ***/
- (void)loadScrollView {
	NSLog(@"Initializing Scroll view Controller");

	// Creates the Thorne View
	ContentAreaViewController *aController = [[ContentAreaViewController alloc]
											  initWithLocation:(int) 49
											  loadFromPrevious:(BOOL)loadNeeded]; //49 = Atreus Server ID for Thorne
	self.thorneController = aController;
	[aController release];
	
	
    // add the controller's view to the scroll view
    if (nil == thorneController.view.superview) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * 0;
        frame.origin.y = 0;
        thorneController.view.frame = frame;
        [scrollView addSubview:thorneController.view];
    }
	
	// Creates the Moulton View
	ContentAreaViewController *anotherController = [[ContentAreaViewController alloc]
													initWithLocation:(int) 48
													loadFromPrevious:(BOOL)loadNeeded]; //48 = Atreus Server ID for Thorne
	
	self.moultonController = anotherController;
	[anotherController release];
	
	if (nil == moultonController.view.superview) {
		CGRect frame = scrollView.frame;
		frame.origin.x = frame.size.width * 1;
		frame.origin.y = 0;
		moultonController.view.frame = frame;
		[scrollView addSubview:moultonController.view];
	}
	
	
	
}



	
	
#pragma mark -
#pragma mark Delegate Code	
	
- (void)scrollViewDidScroll:(UIScrollView *)sender {
	// based on the scrollView buttons are changed to reflect
	// the menu currently being displayed
	
	CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	switch (page + 1) {
		case 1: diningHallLabel.text = @"Thorne Hall"; 
				[leftButton setTitle:@"" forState:UIControlStateNormal]; 
				[leftButton setBackgroundColor:[UIColor clearColor]];
				[rightButton setTitle:@"Moulton" forState:UIControlStateNormal];
				[rightButton setBackgroundColor:[UIColor grayColor]];
				break;
		case 2: diningHallLabel.text = @"Moulton Union"; 
				[leftButton setTitle:@"Thorne" forState:UIControlStateNormal];
				[leftButton setBackgroundColor:[UIColor grayColor]];
				[rightButton setTitle:@"" forState:UIControlStateNormal]; 
				[rightButton setBackgroundColor:[UIColor clearColor]];
			
				break;

		default: break;
	}
}

// this method was key for dealing with a 2.2.1 glitch with UIWebview
// the workaround is implemented in ContentAreaView but is called by the
// method refreshWebView - essentially this workaround calls a javascript redisplay
// function on the content being displayed and causes a refresh
//
// This was not a bug in 3.* only discovered in 2.*

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView {
	//NSLog(@"Did End Scrolling");
	CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	switch (page) {
		case 0: [thorneController refreshWebView];
				[leftButton setEnabled:NO];
				[rightButton setEnabled:YES];
			
				break;
		case 1: [moultonController refreshWebView]; 
				[leftButton setEnabled:YES];
				[rightButton setEnabled:NO];
			
				break;
		default: break;
			
	}
}


// when the segment controller is selected the program refreshes the view to
// display a new menu
- (void)segmentAction:(id)sender{
		UISegmentedControl *ControlBar = sender;
		selectedSegment = [ControlBar selectedSegmentIndex];
		
		switch ([ControlBar selectedSegmentIndex] + 1) {
			case 1: [self refreshScrollView:@"Breakfast"]; break;
			case 2: [self refreshScrollView:@"Lunch"]; break;
			case 3: [self refreshScrollView:@"Dinner"]; break;
			case 4: [self refreshScrollView:@"Brunch"]; break;
			default: break;
		}
}

- (void)dayAction:(id)sender{
	//NSLog(@"Day Selected");
	int segmentSelect = [sender selectedSegmentIndex];
	
	switch (segmentSelect) {
		case 0: [thorneController decreaseDay]; 
			    [moultonController decreaseDay];
			break;
		
		case 1: [thorneController increaseDay];
				[moultonController increaseDay];
			break;
		
		default:
			break;
	}
	
}
		
- (void)setSelectedSegment:(int)newIndex {
	segmentedControlBar.selectedSegmentIndex = newIndex;
}

/**** Methods for Button Responses ****/

-(void)leftButtonPressed {
	// initializes scroll points
	CGPoint thorne = CGPointMake(0, 0);
	
	//establishes current location
	CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth + 1);

	// this switch is unecessary and is only incorporated because in
	// a previous version there were two buttons on the menuViewController
	// that could be active
	switch (page) {
		case 1: [scrollView setContentOffset: thorne animated: YES]; break;

		default: break;
	}
	[moultonController refreshWebView];
	
}

- (void)rightButtonPressed {
	// initializes scroll points
	CGPoint moulton = CGPointMake((([scrollView contentSize].width)/2)*1, 0);
	
	//establishes current location
	CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth + 1);
	switch (page) {
		case 0: [scrollView setContentOffset: moulton animated: YES]; break;

	   default: break;
	}
	
	[thorneController refreshWebView];
	
}



// sends a changeMeal request to the contentControllers
- (void)refreshScrollView:(NSString*)newMeal {
	[thorneController resetMeal:(NSString*)newMeal];
	[moultonController resetMeal:(NSString*)newMeal];
}


// old method for determining whether content was
// being touched


#pragma mark -
#pragma mark Alternate View Methods	

- (IBAction)showHours:(id)sender {

	// This for loop disables all segments that are not currently
	// selected so that the current meal cannot be changed while
	// in the HourInfoView
	for (int i=0; i< 4; i++){
		if (i!= [segmentedControlBar selectedSegmentIndex]){
			[segmentedControlBar setEnabled:NO forSegmentAtIndex:i];
		}
	}
		
	 CGFloat pageWidth = scrollView.frame.size.width;
	 int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth + 1);
	
	// desides which order the hourScrollViewController will initialize
	// its hours with
	if (page == 1){
		HourScrollViewController *tempController = [[HourScrollViewController alloc] initWithLocation:(int) 48];
		self.hourController = tempController;
		[hourController setDelegate:self];
		[tempController release];
	}
	
	else {
		HourScrollViewController *tempController = [[HourScrollViewController alloc] initWithLocation:(int) 49];
		self.hourController = tempController;
		[hourController setDelegate:self];
		[tempController release];
		
	}
	
	// flip animation when info button is pressed
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
						   forView: [self view]
							 cache:YES];
	[[self view] addSubview: [hourController view]];
	[UIView commitAnimations];
	
}

//Flips to front when "Done" is pressed
- (void)returnView:(int)diningHallToDisplay {
	
	CGPoint thorne = CGPointMake(0, 0);
	CGPoint moulton = CGPointMake((([scrollView contentSize].width)/2)*1, 0);
	
	// resets buttons based on which diningHall is being flipped back to
	switch (diningHallToDisplay) {
		case 0: [scrollView setContentOffset: thorne animated: NO];
				[rightButton setEnabled:YES];
				[leftButton setEnabled:NO];	
				[thorneController refreshWebView];
			
				break;
		case 1: [scrollView setContentOffset: moulton animated: NO]; 
				[rightButton setEnabled:NO];
				[leftButton setEnabled:YES];
				[moultonController refreshWebView];

				break;
		default: break;
	}
	
	
	// Re-Initializes the SegmentedControlBar
	for (int j=0; j< 4; j++){
		if (![segmentedControlBar isEnabledForSegmentAtIndex:j]){
			[segmentedControlBar setEnabled:YES forSegmentAtIndex:j];
		}
	}
		
	// animations
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
						   forView:[self view]
							 cache:YES];
	[[hourController view] removeFromSuperview];
	[UIView commitAnimations];
	
}
																			 
																			 
// the modal grill controller is called within HourInfoViewController
// and passed up through delegates to XMLFeedViewController
- (void)presentModalController {
	GrillAreaViewController *tempController = [[GrillAreaViewController alloc] init];
	self.grillMenuController = tempController;
	[tempController release];
	[super presentModalViewController:grillMenuController animated:YES];
	
}

																			 
#pragma mark -
#pragma mark Memory Management		

- (void)dealloc {
	[diningHallLabel release];
	[scrollView release];
	[leftButton release];
	[rightButton release];
	//[todayButton release];
	//[tomorrowButton release];
	[daySegmentedControl release];
	[toolBar release];
	[thorneController release];
	[moultonController release];
	[hourController release];
	[segmentedControlBar release];
	[super dealloc];
}
	
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}





@end
