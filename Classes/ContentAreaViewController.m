//
//  ContentAreaViewController.m
//  Bowdoin
//
//  Created by Ben Johnson on 7/21/09.
//  Copyright 2009 __Bowdoin__. All rights reserved.
//
//  The ContentAreaViewController is the brains of the operation.
//  based on parameters specified it loads webView's of 8 possible meals
//  Today / Tomorrow (Breakfast / Lunch / Brunch / Dinner) for two dining halls
//	
//	For formatting issues these webViews are stored as HTML string and mutated by
//  javascript commands to make the text appear larger than what is displayed on the
//  Bowdoin Dining website.
//
//  In addition the ContentAreaViewController is responsible for knowing what meal to display
//  based on what the current day is, hour is, etc etc. Essentially the CAVC maintains the look and 
//  feel of the application and tells it when to display messages, what meals to show, and how and when
//  to act on itself.

#import "ContentAreaViewController.h"
#import "XMLFeedViewController.h"
#import "BowdoinAppDelegate.h"

@implementation ContentAreaViewController

@synthesize loadImage, loadMessage, activityIndicator, timerMeal, timerTomorrowBoolean, closingTimer, performNewLoad;
@synthesize webView, hiddenWebView, tomorrowSelected, todaySelected, mealToDisplay, currentMeal, webURLStrings, webURLRequests, timeDataArray, closingHeader, closingMinutes, closingVisible, warningNecessary, endedNecessary, hotBreakfast;
//@synthesize errorHeader, errorMessage;

// Load the view nib and initialize with appropriate information
- (id)initWithLocation:(int)hallcode loadFromPrevious:(BOOL)loadNeeded; {
	
	webView.userInteractionEnabled = NO;
	hiddenWebView.userInteractionEnabled = NO;
	
	// variables set on init
	diningHallCode = hallcode;
	year = [self getYear];
	month = [self getMonth];
	day = [self getDay];
	NSString *meal = [self getMeal];
	mealToDisplay = meal;
	currentMeal = meal;	
	todaySelected = YES;
	tomorrowSelected = NO;
	performNewLoad = YES;

	
	if ([self eveningMenuEnabled]){
		day++;
		[self resetDay];
	}
	
	// specified if new data is needed
	if (loadNeeded) {
		arrayCounter = 1; // for counting through array
		
		//Initializes the Array for storing web pages
		NSMutableArray *controllers = [[NSMutableArray alloc] init];
		for (unsigned i = 0; i <= 7; i++) {
			[controllers addObject:[NSNull null]];
		}
		self.webURLStrings = controllers;
		[controllers release];
		
		//Initializes the Array for storing web requests
		NSMutableArray *webRequests = [[NSMutableArray alloc] init];
		for (unsigned i = 0; i <= 7; i++) {
			[webRequests addObject:[NSNull null]];
		}
		self.webURLRequests = webRequests;
		[webRequests release];
		
	}
	// loads from previous array stored locally
	else {
	
		arrayCounter = 9; // set so that loop is not entered with UIWebViewDidLoad
		NSString *archivePath = [NSString stringWithFormat:@"%@/webArray%i",[self documentsDirectory],diningHallCode];
		NSMutableArray *convertedArray = [[NSMutableArray alloc] initWithContentsOfFile:archivePath];
		self.webURLStrings = convertedArray;
		
		[convertedArray release];
		
		performNewLoad = NO;
				
	}
		
	return self;
	
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//NSLog(@"ViewDidLoad");
	if (performNewLoad){
		//NSLog(@"New Load Performing");
		[activityIndicator startAnimating];
		[self initializeURLS];
		[hiddenWebView loadRequest:[webURLRequests objectAtIndex:0]];
		
	}
	else {
		//NSLog(@"Old Load Performing");
		[self loadFromPrevious];
	}
		
	

	
}

- (void)webViewDidStartLoad:(UIWebView *)sender {
	//NSLog(@"WebView Trying to Load");
}
	
- (void)webViewDidFinishLoad:(UIWebView *)sender {
	// various actions perform based on the array counter
	// this is implemented so that we know that 8 successive
	// UIWebViews have loaded in the background and have been stored in
	// the array of webURLStrings which stores the HTML Locally
	
	if (arrayCounter == 8){
		NSString *lastFormattedHTML = [sender stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
		[webURLStrings replaceObjectAtIndex:7 withObject:lastFormattedHTML];
		[self resetDay];
		// Hides the Bear (need to find a way for this to work if webViews do not load)
		[loadImage setAlpha:1.0];
		[loadMessage setAlpha:1.0];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[loadImage setAlpha:0];
		[loadMessage setAlpha:0];
		[UIView commitAnimations];
		[webView setBackgroundColor:[UIColor whiteColor]];
		[activityIndicator stopAnimating];
		
		NSMutableArray *tempArray = [[NSMutableArray alloc] init];
		for (unsigned x = 0; x <= 2; x++) {
			[tempArray addObject:[NSNull null]];
		}
		self.timeDataArray = tempArray;
		[tempArray release];
		
		// CODE TO STORE MENUS LOCALLY //
		
		// inserts month, day, and hour in the correct places
		NSNumber *currentMonth = [NSNumber numberWithInt:[self getMonth]];
		NSNumber *currentDay = [NSNumber numberWithInt:[self getDay]];		
		NSNumber *currentHour = [NSNumber numberWithInt:[self getHour]];		
		
		// this data used to tell whether stored data is the current meal
		[timeDataArray replaceObjectAtIndex:0 withObject:currentMonth];
		[timeDataArray replaceObjectAtIndex:1 withObject:currentDay];		
		[timeDataArray replaceObjectAtIndex:2 withObject:currentHour];		
		
		[self writeApplicationData:timeDataArray toFile:[NSString stringWithFormat:@"timeArray%i" , diningHallCode]];
		[timeDataArray release];
		
		
		//stores HTML to local documents folder
		NSString *archivePath = [NSString stringWithFormat:@"%@/webArray%i",[self documentsDirectory],diningHallCode];
		
		//archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
		BOOL result = [webURLStrings writeToFile:archivePath atomically:YES];
		
		if (result == YES){
			//NSLog(@"Succesful Encode");
			//NSLog([NSString stringWithFormat:@"Coded to %@", archivePath]);
		}
		
		else {
			//NSLog(@"Error Saving");
		}

		

		arrayCounter++;
	}
	
	// if the array counter has not reach 8 a hiddenWebView is loaded
	// with the next menu, its content is stored to webURLStrings and the process
	// continues
	
	if (arrayCounter < 8){
		NSString *reFormattedHTML = [sender stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
		[self.webURLStrings replaceObjectAtIndex:arrayCounter-1 withObject:reFormattedHTML];
		[hiddenWebView loadRequest:[webURLRequests objectAtIndex:arrayCounter]];
		arrayCounter++;
	}
	
	//NSLog(@"Web View Did Load");
	
}

- (void)webView:(UIWebView *)theWebView didFailLoadWithError:(NSError *)error{
	//NSLog(@"Webview Failed");
	if (diningHallCode == 49){
		NSString *title = @"Server Error";
		NSString *message = @"An error occurred accessing the menus. The server may be down. Please try again later.";
		NSString *cancelButtonTitle = @"Close Notification";			  
		
		//allert view created if necessary				  
		UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:title 
														message:(NSString *)message 
													   delegate: self 
											  cancelButtonTitle:(NSString *)cancelButtonTitle
											  otherButtonTitles: NULL];

		[tempAlert show];
	}
	
	[activityIndicator stopAnimating];
	[loadMessage setText:@"Load Failed"];
	
}
// method for loading from locally stored data
- (void)loadFromPrevious {
	
	[self resetDay];
	
	// Hides the Bear 
	[loadImage setAlpha:1.0];
	[loadMessage setAlpha:1.0];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[loadImage setAlpha:0];
	[loadMessage setAlpha:0];
	[UIView commitAnimations];
	[webView setBackgroundColor:[UIColor whiteColor]];
	[activityIndicator stopAnimating];
	
}

// on a new load situation URLS are initialized for each of the 8 possibilities
- (void)initializeURLS {

	
	NSString *theMeal = @"Breakfast";
	NSURL *url = [self formatURLLocation:(int)diningHallCode
									year:(int)year 
								   month:(int)month 
									 day:(int)day 
									meal:(NSString *) theMeal];
		
	NSURLRequest *newRequest = [NSURLRequest requestWithURL:url];
	[webURLRequests insertObject:newRequest atIndex:0];
	
	theMeal = @"Lunch";
	url = [self formatURLLocation:(int)diningHallCode
							 year:(int)year 
							month:(int)month 
							  day:(int)day 
							 meal:(NSString *) theMeal];
	
	newRequest = [NSURLRequest requestWithURL:url];
	[webURLRequests insertObject:newRequest atIndex:1];	
	
	theMeal = @"Dinner";
	url = [self formatURLLocation:(int)diningHallCode
							 year:(int)year 
							month:(int)month 
							  day:(int)day 
							 meal:(NSString *) theMeal];
	
	newRequest = [NSURLRequest requestWithURL:url];
	[webURLRequests insertObject:newRequest atIndex:2];
	
	theMeal = @"Brunch";
	url = [self formatURLLocation:(int)diningHallCode
							 year:(int)year 
							month:(int)month 
							  day:(int)day 
							 meal:(NSString *) theMeal];
	
	newRequest = [NSURLRequest requestWithURL:url];
	[webURLRequests insertObject:newRequest atIndex:3];
	
	
	theMeal = @"Breakfast";
	url = [self formatURLLocation:(int)diningHallCode
							 year:(int)year 
							month:(int)month 
							  day:(int)day+1 
							 meal:(NSString *) theMeal];
	
	newRequest = [NSURLRequest requestWithURL:url];
	[webURLRequests insertObject:newRequest atIndex:4];
	
	
	theMeal = @"Lunch";
	url = [self formatURLLocation:(int)diningHallCode
							 year:(int)year 
							month:(int)month 
							  day:(int)day+1 
							 meal:(NSString *) theMeal];
	
	newRequest = [NSURLRequest requestWithURL:url];
	[webURLRequests insertObject:newRequest atIndex:5];
	
	
	theMeal = @"Dinner";
	url = [self formatURLLocation:(int)diningHallCode
							 year:(int)year 
							month:(int)month 
							  day:(int)day+1 
							 meal:(NSString *) theMeal];
	
	newRequest = [NSURLRequest requestWithURL:url];
	[webURLRequests insertObject:newRequest atIndex:6];
	
	
	theMeal = @"Brunch";
	url = [self formatURLLocation:(int)diningHallCode
							 year:(int)year 
							month:(int)month 
							  day:(int)day+1 
							 meal:(NSString *) theMeal];
	newRequest = [NSURLRequest requestWithURL:url];
	[webURLRequests insertObject:newRequest atIndex:7];
	
	
	
	
}

// reset day changes the UI environment and causes the menus to update
- (void)resetDay {
	
	//NSLog(@"ResettingFromDay");


	if (tomorrowSelected != YES){

		if ([currentMeal isEqualToString:@"Breakfast"]){
			[self loadArrayIndex:0];
			[self changeClosingButton:@"Breakfast" tomorrow:NO];
		}
		
		if ([currentMeal isEqualToString:@"Lunch"]){
			[self loadArrayIndex:1];
			[self changeClosingButton:@"Lunch" tomorrow:NO];
		}
		
		if ([currentMeal isEqualToString:@"Dinner"]){
			[self loadArrayIndex:2];
			[self changeClosingButton:@"Dinner" tomorrow:NO];
		}
		
		if ([currentMeal isEqualToString:@"Brunch"]){
			[self loadArrayIndex:3];
			[self changeClosingButton:@"Brunch" tomorrow:NO];
		}
		
		
	} else {
		if ([currentMeal isEqualToString:@"Breakfast"]){
			[self loadArrayIndex:4];
			[self changeClosingButton:@"Breakfast" tomorrow:YES];
		}
		
		if ([currentMeal isEqualToString:@"Lunch"]){
			[self loadArrayIndex:5];
			[self changeClosingButton:@"Lunch" tomorrow:YES];
		}
		
		if ([currentMeal isEqualToString:@"Dinner"]){
			[self loadArrayIndex:6];
			[self changeClosingButton:@"Dinner" tomorrow:YES];
		}
		
		if ([currentMeal isEqualToString:@"Brunch"]){
			[self loadArrayIndex:7];
			[self changeClosingButton:@"Brunch" tomorrow:YES];
			
		}
		
	}
	
}

// this is the workaround for 2.* code and essentiall evaluates a javascript on document.body.innerHTML
// this code is not mine and was found on the iPhone dev forums
- (void)refreshWebView {
	//NSLog(@"Refreshing");
	[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.innerHTML += '  ';"]];
}

// loads the specified index
- (void)loadArrayIndex:(NSUInteger)index {
	//NSLog([NSString stringWithFormat:@"Within loadArrayindex at index = %i", index]);

	if ([[self.webURLStrings objectAtIndex:index] isEqual:[NSNull null]]){
		NSLog(@"Array Element Doesn't Exist");
	
	}
	
	
	else{
		[webView loadHTMLString:[webURLStrings objectAtIndex:index] baseURL:nil];
		//[webView reload];
	}
}


- (void)resetMeal:(NSString *)newMealToDisplay {
	//NSLog(@"Reset Meal Called with %@", newMealToDisplay);
	
	
	// sets the currentMeal so resetDay knows what to Display
	NSString *temp = newMealToDisplay;
	self.currentMeal = temp;
	[temp release];
	

	if (tomorrowSelected != YES){
		
		if ([newMealToDisplay isEqualToString:@"Breakfast"]){
			[self loadArrayIndex:0];
			[self changeClosingButton:@"Breakfast" tomorrow:NO];
		}
		
		if ([newMealToDisplay isEqualToString:@"Lunch"]){
			[self loadArrayIndex:1];
			[self changeClosingButton:@"Lunch" tomorrow:NO];
		}
		
		if ([newMealToDisplay isEqualToString:@"Dinner"]){
			[self loadArrayIndex:2];
			[self changeClosingButton:@"Dinner" tomorrow:NO];
		}
		
		if ([newMealToDisplay isEqualToString:@"Brunch"]){
			[self loadArrayIndex:3];
			[self changeClosingButton:@"Brunch" tomorrow:NO];
		}
	} else {
		if ([newMealToDisplay isEqualToString:@"Breakfast"]){
			[self loadArrayIndex:4];
			[self changeClosingButton:@"Breakfast" tomorrow:YES];
			}
		
		if ([newMealToDisplay isEqualToString:@"Lunch"]){
			[self loadArrayIndex:5];
			[self changeClosingButton:@"Lunch" tomorrow:YES];
			}
		
		if ([newMealToDisplay isEqualToString:@"Dinner"]){
			[self loadArrayIndex:6];
			[self changeClosingButton:@"Dinner" tomorrow:YES];
			}
		
		if ([newMealToDisplay isEqualToString:@"Brunch"]){
			[self loadArrayIndex:7];
			[self changeClosingButton:@"Brunch" tomorrow:YES];
		}
	}
	
	
}

// method for updating the "Brunch Ends in 5 minutes" alert every 15 seconds
- (void)updateClosingButton{
	[self changeClosingButton:timerMeal tomorrow:timerTomorrowBoolean];
	
	
}

// intelligence for deciding whether a closing alert should be displayed or not
- (void)changeClosingButton: (NSString *)meal tomorrow: (BOOL)tomorrow{
	//Sets the specifics passed to changeClosingButton for use by the timer
	timerMeal = meal;
	timerTomorrowBoolean = tomorrow;
	
	NSInteger weekDay, minute, hour, minuteToDisplay;
	weekDay = [self getWeekDay];
	minute = [self getMinute];
	hour = [self getHour];
	warningNecessary = NO;
	
	if (diningHallCode == 49){
		if (weekDay > 1 && weekDay < 7){
			if (hour == 9 && minute > 15 && minute < 30 ){
				
				warningNecessary = YES;
				minuteToDisplay = 30 - minute;
			}
			if (hour == 13 && minute < 15){
				warningNecessary = YES;
				minuteToDisplay = 15 - minute;
			}
			if (hour == 19 && minute > 15 && minute < 30){
				warningNecessary = YES;
				minuteToDisplay = 30 - minute;
			}
			
		}
		else {
			if (hour == 13 && minute > 15 && minute < 30){
				warningNecessary = YES;
				minuteToDisplay = 30 - minute;
			}
			if (hour == 19 && minute > 15 && minute < 30){
				warningNecessary = YES;
				minuteToDisplay = 30 - minute;
			}			
		}
	}
	
	if (diningHallCode == 48 ){
		if (weekDay > 1 && weekDay < 7){
			// M-F Moulton Hot Breakfast
			if (hour == 8 && minute > 45){
				
				warningNecessary = YES;
				minuteToDisplay = 60 - minute;
			}
			// M-F Moulton Continental
			if (hour == 10 && minute > 15 && minute < 30){			
				warningNecessary = YES;
				minuteToDisplay = 30 - minute;
			}
			
			
			// M-F Moulton Lunch
			if (hour == 13 && minute > 45){
				warningNecessary = YES;
				minuteToDisplay = 60 - minute;
			}
			// M-F Moulton Dinner
			if (hour == 18 && minute > 45){
				warningNecessary = YES;
				minuteToDisplay = 60 - minute;
			}
			
		}
		else {
			// SS Moulton Breakfast
			if (hour == 10 && minute > 45){
				warningNecessary = YES;
				minuteToDisplay = 60 - minute;
			}
			// SS Moulton Brunch
			if (hour == 12 && minute > 15 && minute < 30){
				warningNecessary = YES;
				minuteToDisplay = 30 - minute;
			}
			// SS Moulton Dinner
			if (hour == 18 && minute > 45){
				warningNecessary = YES;
				minuteToDisplay = 60 - minute;
			}			
		}
		
	}
	//Warnings Not Necessary for Next Day Menus
	if (tomorrow == YES){
		warningNecessary = NO;
	}
	
	if ([meal isEqualToString:[self getMeal]] && warningNecessary){
		if (minuteToDisplay != 1)
			closingMinutes.text = [NSString stringWithFormat:@"%d Minutes", minuteToDisplay];
		else
			closingMinutes.text = [NSString stringWithFormat:@"%d Minute", minuteToDisplay];
	
		//Setting the Header Text
		closingHeader.text = [NSString stringWithFormat:@"%@ Ends:", meal];
		
		
		if (!closingVisible){
			[closingHeader setAlpha:0];
			[closingMinutes setAlpha:0];
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:2];
			[closingHeader setAlpha:1.0];
			[closingMinutes setAlpha:1.0];
			[UIView commitAnimations];
			closingVisible = YES;
			// reset used Boolean
			warningNecessary = NO;
			// starts a timer to update
			closingTimer = [NSTimer scheduledTimerWithTimeInterval:5 
											 target:self 
										   selector:@selector(updateClosingButton) 
										   userInfo:nil 
											repeats:YES]; 
		}
	}
	else {
		if (closingVisible){
			[closingHeader setAlpha:1.0];
			[closingMinutes setAlpha:1.0];
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:2];
			[closingHeader setAlpha:0];
			[closingMinutes setAlpha:0];
			[UIView commitAnimations];
			closingVisible = NO;
			[closingTimer invalidate];
			// reset used Boolean
			warningNecessary = NO;
				
		}

		
	}

}

// NSURL method formats our local time data to retrieve
// the 8 menus for each controller
- (NSURL *)formatURLLocation:(int)hallcode 
						year:(int)yr 
					   month:(int)mo
						 day:(int)dy
						meal:(NSString *)meal {
	
	// creates the string
	NSString *formattedMenuAddress = [NSString stringWithFormat: @"http://www.bowdoin.edu/atreus/views?unit=%d&meal=%@&mo=%d&dy=%d&yr=%d", 
									  hallcode, meal, mo, dy, yr];
	// creates the URL
	NSURL *url = [NSURL URLWithString:formattedMenuAddress];
	
	return url;
	
}
// *** These Methods Will Deal with Time ***//
- (int)getYear {
	NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[inputFormatter setDateFormat:@"Y"];
	NSDate *toBeFormatted = [[[NSDate alloc] init] autorelease];
	
	NSString *formattedDate = [inputFormatter stringFromDate:toBeFormatted];
	//NSLog(@"formattedYear: %@", formattedDate);
	
	return[formattedDate intValue];
	
}

- (int)getMonth {
	NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[inputFormatter setDateFormat:@"M"];
	NSDate *toBeFormatted = [[[NSDate alloc] init] autorelease];
	
	NSString *formattedDate = [inputFormatter stringFromDate:toBeFormatted];
	//NSLog(@"formattedMonth: %@", formattedDate);
	
	// compensates for Atreus server which takes values of 0-11
	NSInteger formattedMonth;
	formattedMonth = ([formattedDate intValue] - 1);
	
	return formattedMonth;
}

- (int)getDay {
	NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[inputFormatter setDateFormat:@"d"];
	NSDate *toBeFormatted = [[[NSDate alloc] init] autorelease];
	
	NSString *formattedDate = [inputFormatter stringFromDate:toBeFormatted];
	//NSLog(@"formattedDay: %@", formattedDate);
	
	return[formattedDate intValue];
}

- (int)getHour {
	NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[inputFormatter setDateFormat:@"H"];
	NSDate *toBeFormatted = [[[NSDate alloc] init] autorelease];
	
	NSString *formattedDate = [inputFormatter stringFromDate:toBeFormatted];
	//NSLog(@"formattedHour: %@", formattedDate);
	
	return[formattedDate intValue];
}

- (int)getMinute {
	NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[inputFormatter setDateFormat:@"m"];
	NSDate *toBeFormatted = [[[NSDate alloc] init] autorelease];
	
	NSString *formattedDate = [inputFormatter stringFromDate:toBeFormatted];
	//NSLog(@"formattedMinute: %@", formattedDate);
	
	return[formattedDate intValue];
}

- (int)getWeekDay {
	NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[inputFormatter setDateFormat:@"e"];
	NSDate *toBeFormatted = [[[NSDate alloc] init] autorelease];
	
	NSString *formattedDate = [inputFormatter stringFromDate:toBeFormatted];
	//NSLog(@"formattedWeekday: %@", formattedDate);
	
	return[formattedDate intValue];
	
}

-(NSString*)getCurrentDayTitle{
	
	NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[inputFormatter setDateFormat:@"EEEE"];
	NSTimeInterval zeroDays = 24 * 60 * 60;
	NSDate *toBeFormatted = [[[NSDate alloc] initWithTimeIntervalSinceNow:zeroDays] autorelease];
	
	NSString *formattedDate = [inputFormatter stringFromDate:toBeFormatted];
	//NSLog(@"formattedNextDayTitle: %@", formattedDate);
	
	return formattedDate;
}


-(NSString*)getNextDayTitle{
	
	NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[inputFormatter setDateFormat:@"EEEE"];
	NSTimeInterval oneDay = 48 * 60 * 60;
	NSDate *toBeFormatted = [[[NSDate alloc] initWithTimeIntervalSinceNow:oneDay] autorelease];
	
	NSString *formattedDate = [inputFormatter stringFromDate:toBeFormatted];
	//NSLog(@"formattedNextDayTitle: %@", formattedDate);
	
	return formattedDate;
}

-(NSString*)getDateString{
	
	NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[inputFormatter setDateFormat:@"EEEE MMMM d"];
	NSDate *toBeFormatted = [[[NSDate alloc] init] autorelease];
	
	NSString *formattedDate = [inputFormatter stringFromDate:toBeFormatted];
	//NSLog(@"formattedWeekday: %@", formattedDate);
	
	return formattedDate;
	
}

// this method returns true if a current meal is in session at
// a specified hall code - it uses the same basic intelligence as getMeal
// though certainly more involved in the hour constraints
- (BOOL)inSession:(NSString *)meal atHallCode:(int)hallCode {
	NSInteger weekDay, minute, hour;
	weekDay = [self getWeekDay];
	minute = [self getMinute];
	hour = [self getHour];
	
	//Thorne
	if (hallCode == 49){
		if (weekDay > 1 && weekDay < 7) {
			// Breakfast 7:30 - 9:30
			if ([meal isEqualToString:@"Breakfast"]){
				if (hour < 9 || hour == 9 && minute < 30){
					if (hour > 7 || hour == 7 && minute >= 30){
						return YES;
					}
				}
			}
			// Lunch 11:30 - 1:30 (deli lunch at 11)
			if ([meal isEqualToString:@"Lunch"]){
				if (hour < 13 || hour == 13 && minute < 15){
					if (hour > 11 || hour == 11 && minute >= 30){
						return YES;
					}
				}
			} 
			// Dinner 5-7:30
			if ([meal isEqualToString:@"Dinner"]){
				if (hour < 19 || hour == 19 && minute < 30){
					if (hour > 17 || hour == 17 && minute >= 0){
						return YES;
					}
				}
			} 

		} // end M-F 
		
		// Weekend conditional
		else {
			// Brunch 11:00 AM - 1:30 PM
			if ([meal isEqualToString:@"Brunch"]){
				if (hour < 13 || hour == 13 && minute < 30){
					if (hour > 11 || hour == 11){
						return YES;
					}
				}
			}
			
			//Dinner 5:00 PM - 7:30 PM
			if ([meal isEqualToString:@"Dinner"]){
				if (hour < 19 || hour == 19 && minute < 30){
					if (hour > 17 || hour == 17){
						return YES;
					}
				}
			}
		} // end Weekend
		return NO;
	} // end Thorne
	
	//Moulton
	if (hallCode == 48){
		if (weekDay > 1 && weekDay < 7) {
			// Hot Breakfast 7:15 - 9:00
			if ([meal isEqualToString:@"Hot Breakfast"]){
				if (hour < 9){
					if (hour > 7 || hour == 7 && minute >= 15){
						return YES;
					}
				}
			}
			// Cold Breakfast 9:00 - 10:30 AM
			if ([meal isEqualToString:@"Cold Breakfast"]){
				if (hour < 10 || hour == 10 && minute < 30){
					if (hour >= 9){
						return YES;
					}
				}
			}
			
			// Lunch 11:00 - 2:00PM
			if ([meal isEqualToString:@"Lunch"]){
				if (hour < 14){
					if (hour >= 11){
						return YES;
					}
				}
			} 
			// Dinner 5:00 - 7:00
			if ([meal isEqualToString:@"Dinner"]){
				if (hour < 19){
					if (hour >= 17){
						return YES;
					}
				}
			} 
			
		} // end M-F 
		
		// Weekend conditional
		else {
			// Weekend Breakfast 9:00 - 11:00
			if ([meal isEqualToString:@"Breakfast"]){
				if (hour < 11){
					if (hour >= 9){
						return YES;
					}
				}
			}
			// Brunch 11:00 AM - 12:30 PM
			if ([meal isEqualToString:@"Brunch"]){
				if (hour < 12 || hour == 12 && minute < 30){
					if (hour >= 11){
						return YES;
					}
				}
			}
			
			//Dinner 5:00 PM - 7:00 PM
			if ([meal isEqualToString:@"Dinner"]){
				if (hour < 19){
					if (hour >= 17){
						return YES;
					}
				}
			}
		} // end Weekend
		return NO;
	} // end Moulton
	return NO;
	
	
}

// get meal returns the current meal
// these are loose hours and are not dining hall specific
- (NSString*)getMeal {
	NSInteger hour, weekDay, minute;
	hour = [self getHour];
	minute = [self getMinute];
	weekDay = [self getWeekDay];
	
	
	if (hour < 10) {
		if (weekDay > 1 && weekDay < 7) {
			return @"Breakfast";
			
		} else {
			return @"Brunch";
			
			
		}
		
	}
	
	else if (hour > 10 && hour < 14 || hour == 10 && minute > 30) {
		if (weekDay > 1 && weekDay < 7) {
			return @"Lunch";
			
		}else {
			return @"Brunch";
		}

	}
	
	else if (hour >= 14 && hour < 20) {
		return @"Dinner";
		
		
		
	}
	
	else {	
		if (weekDay >= 1 && weekDay < 6) {
			return @"Breakfast";
		}   return @"Brunch";
		}
	
}

// if it is after 8PM - after dinner has closed
// the user will want to see tomorrow and the next days menus
//
// This boolean returns true if the evening menu is necessary
- (BOOL)eveningMenuEnabled {
	//NSLog(@"Checking for Evening Menu");
	NSInteger hour;
	hour = [self getHour];
	
	if (hour >= 20 && hour < 24){
			//NSLog(@"Time For Evening Menu");
			return YES;
	}
	else {
		return NO;
	}
}

// increases the day to make the application think it should
// display tomorrow and the next days menus
- (void)setEveningMenu {
	day++; // increases the current Day
	[self resetDay];
}



-(void)increaseDay {
	//NSLog(@"Increasing Day");
	if (todaySelected){
		day++;
		todaySelected = NO;
		tomorrowSelected = YES;
		//NSLog(@"Increasing Day");
		[self resetDay];
	}	else return;
	
}

-(void)decreaseDay {
	if (tomorrowSelected){
		day--;
		tomorrowSelected = NO;
		todaySelected = YES;
		//NSLog(@"Decreasing Day");
		[self resetDay];

	} else return;
}

//** End Time Methods **//


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
}

- (void)viewDidUnload {
}

- (NSMutableArray*)returnArrayMeal {
	if (webURLStrings.lastObject != NULL) {
		return webURLStrings;
	}
	else {
		return NULL;
	}
}

// returns the local document directory
- (NSString *)documentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}


#pragma mark -
#pragma mark Memory management

// ** APPLE CODE ** //
// method for writing application data 
- (BOOL)writeApplicationData:(NSData *)data toFile:(NSString *)fileName {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
    NSString *documentsDirectory = [paths objectAtIndex:0];
	
    if (!documentsDirectory) {
		
        NSLog(@"Documents directory not found!");
		
        return NO;
		
    }
	
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
	//NSLog(@"%@", appFile);
	
    return ([data writeToFile:appFile atomically:YES]);
	
}



- (void)dealloc {
	[webView release];
	[hiddenWebView release]; 
	[mealToDisplay release]; 
	[currentMeal release]; 
	[webURLStrings release]; 
	[webURLRequests release];
	[timeDataArray release];
    [super dealloc];
}


@end
