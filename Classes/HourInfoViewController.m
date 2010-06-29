//
//  HourInfoViewController.m
//  Bowdoin
//
//  Created by Ben Johnson on 8/14/09.
//  Copyright 2009 Bowdoin College. All rights reserved.
//
//	Responsible for formatting the Hour Informational Page
//

#import "HourInfoViewController.h"
#import "HourScrollViewController.h"
#import "GrillAreaViewController.h"


@implementation HourInfoViewController

@synthesize hallLabel, grillLabel, mealOne, mealTwo, mealThree, mealFour, hoursOne, hoursTwo, 
hoursThree, hoursFour, grillHours, cafeHoursOne, cafeHoursTwo, tempDayController, hotOne, hotTwo, 
hotThree, creditsLabel, doneButton, leftHallButton, rightHallButton, emailButton, callGrillButton, dateLabel;

@synthesize nextController, delegate, grillMenuController;

- (id)initWithHall:(int)hall; {
	hallCode = hall;
	NSLog(@"HourView Controller Initialzied");
	NSLog(@"Setting up Layout of Hour Information");


	return self;
	
	
	
}

- (void)viewDidLoad {
    [super viewDidLoad];

	[self setDiningLabels];
	
	
	

	// This code creates a larger area for the info button to increase the
	// likeliness that it will be selected when a tap originated in the general area
	/*
	CGRect newInfoButtonRect = CGRectMake(doneButton.frame.origin.x-25, 
										  doneButton.frame.origin.y-25, 
										  doneButton.frame.size.width+50, 
										  doneButton.frame.size.height+50); 
	
	[doneButton setBackgroundColor:[UIColor clearColor]];
	[doneButton setFrame:newInfoButtonRect];
	[doneButton bringSubviewToFront:[self view]];
	
	*/
	
	// Intelligence for Hour Information Below	
}
- (void)setDiningLabels {
	//Checks to see what device is running the application
	UIDevice *device = [UIDevice currentDevice];
	if (![device.model isEqualToString:@"iPhone"]){
		callGrillButton.enabled = NO;
		[callGrillButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
	}
	
	
	
	ContentAreaViewController *tempController = [[ContentAreaViewController alloc] init];
	//Establishing Variables for Time
	NSInteger weekDay, minute, hour;
	
	weekDay = [tempController getWeekDay];
	minute = [tempController getMinute];
	hour = [tempController getHour];
	dateLabel.text = [tempController getDateString];
	
	// Sets Grill / Cafe Labels
	[callGrillButton setTitle:@"Call The Grill: 207-725-3888" forState:UIControlStateNormal];
	grillLabel.text = @"Grill | Cafe";
	[emailButton setTitle:@"Ben Johnson '11" forState:UIControlStateNormal];
	
	if (weekDay == 1){
		// Sets Default Hours for Sunday
		grillHours.text = @"6:30 PM - Midnight";
		cafeHoursOne.text = @"11:00 AM - 4:00 PM";
		cafeHoursTwo.text = @"8:00 PM - Midnight";
		
		if (hour < 16){
			if (hour > 11 || hour == 11){
				cafeHoursOne.text = @"Closes at 4:00 PM";
				cafeHoursOne.textColor = [UIColor blueColor];
			}
		}
		
		if (hour > 16){
			cafeHoursOne.text = @"8:00 PM - Midnight";
			cafeHoursTwo.text = @"";
		}
		
		if (hour >= 18 && minute >= 30 || hour > 18){
			grillHours.text = @"Closes at Midnight";
			grillHours.textColor = [UIColor blueColor];
		}
		
		if (hour >= 20){
			cafeHoursOne.text = @"Closes at Midnight";
			cafeHoursOne.textColor = [UIColor blueColor];
			cafeHoursTwo.text = @"";
		}
		
	}
	
	if (weekDay > 1 && weekDay < 5){
		// Sets Default Hours for Mon > Wed
		grillHours.text = @"11:30 AM - Midnight";
		cafeHoursOne.text = @"7:30 AM - 4:30 PM";
		cafeHoursTwo.text = @"8:00 PM - Midnight";
		
		if (hour == 11 && minute >= 30 || hour > 11){
			grillHours.text = @"Closes at Midnight";
			grillHours.textColor = [UIColor blueColor];

		}
		
		if (hour < 16 || hour == 16 && minute < 30){
			if (hour > 7 || hour == 7 && minute >= 30){
				cafeHoursOne.text =@"Closes at 4:30 PM";
				cafeHoursOne.textColor = [UIColor blueColor];
			}
		}
		
		if (hour > 16 || hour == 16 && minute >= 30){
			cafeHoursOne.text = @"8:00 PM - Midnight";
			cafeHoursTwo.text = @"";
		}
		
		if (hour >= 20){
			cafeHoursOne.text = @"Closes at Midnight";
			cafeHoursOne.textColor = [UIColor blueColor];
			cafeHoursTwo.text = @"";
		}
	}
	if (weekDay > 4 && weekDay < 7){
		// Sets Default Hours for Thu > Fri
		grillHours.text = @"11:30 AM - 1:00 AM";
		cafeHoursOne.text = @"7:30 AM - 4:30 PM";
		cafeHoursTwo.text = @"8:00 PM - 10:00 PM";
		
		//Special Case for Midnight Viewing of Grill
		if (hour == 0){
			grillHours.text = @"Closes at 1:00 AM";
			grillHours.textColor = [UIColor blueColor];
			cafeHoursOne.text = @"Opens at 7:30 AM";
			cafeHoursTwo.text = @"";
		}
		
		if (hour == 11 && minute >= 30 || hour > 11){
			grillHours.text = @"Closes at 1:00 AM";
			grillHours.textColor = [UIColor blueColor];

		}
		
		if (hour < 16 || hour == 16 && minute < 30){
			if (hour > 7 || hour == 7 && minute >= 30){
				cafeHoursOne.text =@"Closes at 4:30 PM";
				cafeHoursOne.textColor = [UIColor blueColor];

			}
		}
		
		if (hour > 16 || hour == 16 && minute >= 30){
			cafeHoursOne.text = @"8:00 PM - 10:00 PM";
			cafeHoursTwo.text = @"";
		}
		
		if (hour >= 20 && hour < 22){
			cafeHoursOne.text = @"Closes at 10:00 PM";
			cafeHoursOne.textColor = [UIColor blueColor];
			cafeHoursTwo.text = @"";
		}
		
		if (hour >= 22){
			cafeHoursOne.text = @"Closed at 10:00 PM";
			cafeHoursTwo.text = @"";
		}
		
	}
	if (weekDay == 7){
		// Sets Default Hours for Saturday
		grillHours.text = @"6:00 PM - Midnight";
		cafeHoursOne.text = @"11:00 AM - 4:00 PM";
		cafeHoursTwo.text = @"";
		
		//special case for Friday night Grill
		if (hour == 0){
			grillHours.text = @"Closes at 1:00 AM";
			grillHours.textColor = [UIColor blueColor];
			cafeHoursOne.text = @"Opens at 11:00 AM";
			cafeHoursTwo.text = @"";
		}
		
		if (hour >= 18){
			grillHours.text = @"Closes at Midnight";
			grillHours.textColor = [UIColor blueColor];
		}
		
		if (hour < 16 && hour >= 11){
			cafeHoursOne.text =@"Closes at 4:00 PM";
			cafeHoursOne.textColor = [UIColor blueColor];

		}
		
		if (hour >= 16){
			cafeHoursOne.text = @"Closed for the Day";
			cafeHoursTwo.text = @"";
		}
	}
	
	
	// Thorne
	if (hallCode == 49){
		
		hallLabel.text = @"Thorne Hours";
		
	if (weekDay > 1 && weekDay < 7){
		//Sets Default Meal Labels
		mealOne.text = @"Breakfast:";
		mealTwo.text = @"Deli Lunch:";
		mealThree.text = @"Lunch:";
		mealFour.text = @"Dinner:";
		
		//Sets Default Hours		
		hoursOne.text = @"7:30 AM - 9:30 AM";
		hoursTwo.text = @"11:00 AM - 11:30 AM";
		hoursThree.text = @"11:30 AM - 1:15 PM";
		hoursFour.text = @"5:00 PM - 7:30 PM";
		
		//Sets "Hot" | "Cold" Notifiers
		hotOne.text = @"";
		hotTwo.text = @"";
		hotThree.text = @"Hot";

	    //Alert Statements for Dining Halls
		if ([tempController inSession:@"Breakfast" atHallCode:49]){
			hoursOne.text = @"Ends at 9:30 AM";
			hoursOne.textColor = [UIColor blueColor];

			if (hour == 9 && minute >= 15){
				hourInfoAlert = 30 - minute;
				hoursOne.text = [NSString stringWithFormat:@"Ends in %i Minutes", hourInfoAlert];
				hoursOne.textColor = [UIColor redColor];
				if (hourInfoAlert == 1){
					hoursOne.text = [NSString stringWithFormat:@"Ends in %i Minute", hourInfoAlert];
					hoursOne.textColor = [UIColor redColor];
				}
			}
		}
		
		//Special Blue Statement for Deli Lunch
		if (hour == 11 && minute < 30){
			hoursTwo.textColor = [UIColor blueColor];
		}
		
		
		if ([tempController inSession:@"Lunch" atHallCode:49]){
			hoursThree.text = @"Ends at 1:15 PM";
			hoursThree.textColor = [UIColor blueColor];
			if (hour == 13 && minute >= 0){
				hourInfoAlert = 15 - minute;
				hoursThree.text = [NSString stringWithFormat:@"Ends in %i Minutes", hourInfoAlert];
				hoursThree.textColor = [UIColor redColor];
				if (hourInfoAlert == 1){
					hoursThree.text = [NSString stringWithFormat:@"Ends in %i Minute", hourInfoAlert];
					hoursThree.textColor = [UIColor redColor];
				}
			}
		}
		if ([tempController inSession:@"Dinner" atHallCode:49]){
			hoursFour.text = @"Ends at 7:30 PM";
			hoursFour.textColor = [UIColor blueColor];
			if (hour == 19 && minute >= 15){
				hourInfoAlert = 30 - minute;
				hoursFour.text = [NSString stringWithFormat:@"Ends in %i Minutes", hourInfoAlert];
				hoursFour.textColor = [UIColor redColor];
				if (hourInfoAlert == 1){
					hoursFour.text = [NSString stringWithFormat:@"Ends in %i Minute", hourInfoAlert];
					hoursFour.textColor = [UIColor redColor];

				}
			}
		}
	}
		
	else { // Weekend Dining Control
		
		//Sets Default Meal Labels
		mealOne.text = @"Brunch:";
		mealTwo.text = @"Dinner:";
		mealThree.text = @"";
		mealFour.text = @"";
		
		//Sets Default Hours		
		hoursOne.text = @"11:00 AM - 1:30 PM";
		hoursTwo.text = @"5:00 PM - 7:30 PM";
		hoursThree.text = @"";
		hoursFour.text = @"";
		
		//Sets "Hot" | "Cold" Notifiers
		hotOne.text = @"";
		hotTwo.text = @"";
		hotThree.text = @"";
		
		//Alert Statements for Dining Halls
		if ([tempController inSession:@"Brunch" atHallCode:49]){
			hoursOne.text = @"Ends at 1:30 PM";
			hoursOne.textColor = [UIColor blueColor];
			//NSLog(@"Blue Color set");
			if (hour == 13 && minute >= 15){
				hourInfoAlert = 30 - minute;
				hoursOne.text = [NSString stringWithFormat:@"Ends in %i Minutes", hourInfoAlert];
				hoursOne.textColor = [UIColor redColor];
				if (hourInfoAlert == 1){
					hoursOne.text = [NSString stringWithFormat:@"Ends in %i Minute", hourInfoAlert];
					hoursOne.textColor = [UIColor redColor];
				}
			}
		}
		if ([tempController inSession:@"Dinner" atHallCode:49]){
			hoursTwo.text = @"Ends at 7:30 PM";
			hoursTwo.textColor = [UIColor blueColor];
			//NSLog(@"Blue Color set");
			if (hour == 19 && minute >= 15){
				hourInfoAlert = 30 - minute;
				hoursTwo.text = [NSString stringWithFormat:@"Ends in %i Minutes", hourInfoAlert];
				hoursTwo.textColor = [UIColor redColor];
				if (hourInfoAlert == 1){
					hoursTwo.text = [NSString stringWithFormat:@"Ends in %i Minute", hourInfoAlert];
					hoursTwo.textColor = [UIColor redColor];
				}
			}
		}
	}
		
	} // end Thorne
	
	// Moulton
	if (hallCode == 48){
		
		hallLabel.text = @"Moulton Hours";
		
	if (weekDay > 1 && weekDay < 7){
			
		//Sets Default Meal Names
		mealOne.text = @"Breakfast:";
		mealTwo.text = @"Breakfast:";
		mealThree.text = @"Lunch:";
		mealFour.text = @"Dinner:";
		
		//Sets Default Hours
		hoursOne.text = @"7:15 AM - 9:00 AM";
		hoursTwo.text = @"9:00 AM - 10:30 AM";
		hoursThree.text = @"11:00 AM - 2:00 PM";
		hoursFour.text = @"5:00 PM - 7:00 PM";
		
		//Sets "Hot" | "Cold" notifiers
		hotOne.text = @"Hot";
		hotTwo.text = @"Cold";
		hotThree.text = @"";
		
	    //Alert Statements for Dining Halls
		if ([tempController inSession:@"Hot Breakfast" atHallCode:48]){
			hoursOne.text = @"Ends at 9:00 AM";
			hoursOne.textColor = [UIColor blueColor];
			//NSLog(@"Blue Color set");
			if (hour == 8 && minute >= 45){
				hourInfoAlert = 60 - minute;
				hoursOne.text = [NSString stringWithFormat:@"Ends in %i Minutes", hourInfoAlert];
				hoursOne.textColor = [UIColor redColor];
				if (hourInfoAlert == 1){
					hoursOne.text = [NSString stringWithFormat:@"Ends in %i Minute", hourInfoAlert];
					hoursOne.textColor = [UIColor redColor];
				}
			}
		}
		
		if ([tempController inSession:@"Cold Breakfast" atHallCode:48]){
			hoursTwo.text = @"Ends at 10:30 AM";
			hoursTwo.textColor = [UIColor blueColor];
			//NSLog(@"Blue Color set");
			if (hour == 10 && minute >= 15){
				hourInfoAlert = 30 - minute;
				hoursTwo.text = [NSString stringWithFormat:@"Ends in %i Minutes", hourInfoAlert];
				hoursTwo.textColor = [UIColor redColor];
				if (hourInfoAlert == 1){
					hoursTwo.text = [NSString stringWithFormat:@"Ends in %i Minute", hourInfoAlert];
					hoursTwo.textColor = [UIColor redColor];
				}
			}
		}
		
		if ([tempController inSession:@"Lunch" atHallCode:48]){
			hoursThree.text = @"Ends at 2:00 PM";
			hoursThree.textColor = [UIColor blueColor];

			if (hour == 13 && minute >= 45){
				hourInfoAlert = 60 - minute;
				hoursThree.text = [NSString stringWithFormat:@"Ends in %i Minutes", hourInfoAlert];
				hoursThree.textColor = [UIColor redColor];
				if (hourInfoAlert == 1){
					hoursThree.text = [NSString stringWithFormat:@"Ends in %i Minute", hourInfoAlert];
					hoursThree.textColor = [UIColor redColor];
				}
			}
		}
		if ([tempController inSession:@"Dinner" atHallCode:48]){
			hoursFour.text = @"Ends at 7:00 PM";
			hoursFour.textColor = [UIColor blueColor];
			//NSLog(@"Blue Color set");
			if (hour == 18 && minute >= 45){
				hourInfoAlert = 60 - minute;
				hoursFour.text = [NSString stringWithFormat:@"Ends in %i Minutes", hourInfoAlert];
				hoursFour.textColor = [UIColor redColor];
				if (hourInfoAlert == 1){
					hoursFour.text = [NSString stringWithFormat:@"Ends in %i Minute", hourInfoAlert];
					hoursFour.textColor = [UIColor redColor];
				}
			}
		}
	}
	else { // Weekend Dining Control for Moulton
		
		//Sets Default Meal Labels
		mealOne.text = @"Breakfast:";
		mealTwo.text = @"Brunch:";
		mealThree.text = @"Dinner:";
		mealFour.text = @"";
		
		//Sets Default Hours		
		hoursOne.text = @"9:00 AM - 11:00 AM";
		hoursTwo.text = @"11:00 AM - 12:30 PM";
		hoursThree.text = @"5:00 PM - 7:00 PM";
		hoursFour.text = @"";
		
		//Sets "Hot" | "Cold" Notifiers
		hotOne.text = @"";
		hotTwo.text = @"";
		hotThree.text = @"";
		
		//Alert Statements for Dining Halls
		if ([tempController inSession:@"Breakfast" atHallCode:48]){
			hoursOne.text = @"Ends at 11:00 AM";
			hoursOne.textColor = [UIColor blueColor];

			if (hour == 10 && minute >= 45){
				hourInfoAlert = 60 - minute;
				hoursOne.text = [NSString stringWithFormat:@"Ends in %i Minutes", hourInfoAlert];
				hoursOne.textColor = [UIColor redColor];
				if (hourInfoAlert == 1){
					hoursOne.text = [NSString stringWithFormat:@"Ends in %i Minute", hourInfoAlert];
					hoursOne.textColor = [UIColor redColor];
				}
			}
		}		
		
		if ([tempController inSession:@"Brunch" atHallCode:48]){
			hoursTwo.text = @"Ends at 12:30 PM";
			hoursTwo.textColor = [UIColor blueColor];

			if (hour == 12 && minute >= 15){
				hourInfoAlert = 30 - minute;
				hoursTwo.text = [NSString stringWithFormat:@"Ends in %i Minutes", hourInfoAlert];
				hoursTwo.textColor = [UIColor redColor];
				if (hourInfoAlert == 1){
					hoursTwo.text = [NSString stringWithFormat:@"Ends in %i Minute", hourInfoAlert];
					hoursTwo.textColor = [UIColor redColor];
				}
			}
		}
		if ([tempController inSession:@"Dinner" atHallCode:48]){
			hoursThree.text = @"Ends at 7:00 PM";
			hoursThree.textColor = [UIColor blueColor];

			if (hour == 18 && minute >= 45){
				hourInfoAlert = 60 - minute;
				hoursThree.text = [NSString stringWithFormat:@"Ends in %i Minutes", hourInfoAlert];
				hoursThree.textColor = [UIColor redColor];
				if (hourInfoAlert == 1){
					hoursThree.text = [NSString stringWithFormat:@"Ends in %i Minute", hourInfoAlert];
					hoursThree.textColor = [UIColor redColor];
				}
			}
		}
	}
		
		
		
	} // End Moulton
	[tempController release];
	creditsLabel.text = @"Application Developed by";
	
}

// determines the order in which order the hourInfo page has been initialized and where to set the Buttons
-(void)setOnLeft{
	
	if ([self currentHallCode] == 48){
		[rightHallButton setTitle:@"Thorne" forState:UIControlStateNormal];
		[leftHallButton setHidden:YES];
	} else {
		[rightHallButton setTitle:@"Moulton" forState:UIControlStateNormal];
		[leftHallButton setTitle:@"" forState:UIControlStateNormal];
		[leftHallButton setHidden:YES];

	}

}

// determines the order in which the hourInfo page has been initialized and where to set the Buttons
-(void)setOnRight{
	
	if ([self currentHallCode] == 48){
		[leftHallButton setTitle:@"Thorne" forState:UIControlStateNormal];
		[rightHallButton setHidden:YES];
	} else {
		[leftHallButton setTitle:@"Moulton" forState:UIControlStateNormal];
		[rightHallButton setHidden:YES];

	}
	
}

- (int)currentHallCode{
	return hallCode;
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (IBAction)returnView:(id)sender {
	
	[delegate exitHourView];

}

// delegate method to pass call the grill to delegate
- (void)setAppDelegate:(id)sender{
	self.delegate = sender;
}

// changes the hour information that is on page to a new dining location
- (IBAction)changeDiningHall{
	// Calls the Hour Scroll View Controller
	[delegate switchHourView];
	
}

// sends an email to the developer
- (IBAction)sendEmail{
	NSString *recipients = @"mailto:ebjohnso@bowdoin.edu?&subject=Bowdoin iPhone Application";
	NSString *body = @"";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];}

// calls the grill
- (IBAction)callTheGrill{
	printf("CallTheGrill");
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://2077253888"]];

}

// shows the grill PDF
- (IBAction)displayGrillPDF{
	
	[delegate presentModalController];
}



- (void)dealloc {
	[hallLabel release];
	[grillLabel release];
	[dateLabel release];
	[creditsLabel release];
	[mealOne release]; 
	[mealTwo release]; 
	[mealThree release]; 
	[hoursOne release];
	[hoursTwo release];
	[hoursThree release];
	[grillHours release];
	[cafeHoursOne release]; 
	[cafeHoursTwo release]; 
	[tempDayController release];
	[nextController release];
	[doneButton release];
	[leftHallButton release];
	[rightHallButton release];
	[emailButton release];
	[callGrillButton release];
	[grillMenuController release];
	[delegate dealloc];
    [super dealloc];
}


@end
