//
//  ContentAreaViewController.h
//  Bowdoin
//
//  Created by Ben Johnson on 7/21/09.
//  Copyright 2009 __Bowdoin__. All rights reserved.
//
//  The ContentAreaViewController is the brains behind this iPhone application
//  the specificis of this class are included within the .m header

#import <UIKit/UIKit.h>



@interface ContentAreaViewController : UIViewController <UIWebViewDelegate> {
	
	IBOutlet UIWebView *webView;
	IBOutlet UIWebView *hiddenWebView;
	IBOutlet UILabel *closingHeader;
	IBOutlet UILabel *closingMinutes;
	IBOutlet UILabel *loadMessage;
	IBOutlet UIImageView *loadImage;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	NSString* mealToDisplay;
	NSString* currentMeal;
	NSString* timerMeal;
	BOOL *timerTomorrowBoolean;
	int diningHallCode;
	int year;
	int month;
	int day;
	int tempday;
	int arrayCounter;
	BOOL *tomorrowSelected;
	BOOL *todaySelected;
	BOOL loaded;
	BOOL *closingVisible;
	BOOL *endedNecessary;
	BOOL *warningNecessary;
	BOOL *hotBreakfast;
	NSTimer *closingTimer;
	
	//array for storing URL
	NSMutableArray *webURLStrings;
	
	//array for storing
	NSMutableArray *webURLRequests;
	NSMutableArray *timeDataArray;
	
	BOOL *performNewLoad;
	
	
	
	
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIWebView *hiddenWebView;
@property (nonatomic, retain) UILabel *closingHeader;
@property (nonatomic, retain) UILabel *closingMinutes;
@property (nonatomic, retain) UILabel *loadMessage;
@property (nonatomic, retain) UIImageView *loadImage;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (readwrite, copy) NSString *mealToDisplay;
@property (readwrite, copy) NSString *currentMeal;
@property (readwrite, copy) NSString *timerMeal;
@property (nonatomic) BOOL *tomorrowSelected;
@property (nonatomic) BOOL *timerTomorrowBoolean;
@property (nonatomic) BOOL *todaySelected;
@property (nonatomic) BOOL *closingVisible;
@property (nonatomic) BOOL *warningNecessary;
@property (nonatomic) BOOL *endedNecessary;
@property (nonatomic) BOOL *hotBreakfast;
@property (nonatomic) BOOL *performNewLoad;
@property (nonatomic, retain) NSMutableArray *webURLStrings;
@property (nonatomic, retain) NSMutableArray *webURLRequests;
@property (nonatomic, retain) NSMutableArray *timeDataArray;
@property (nonatomic, retain) NSTimer *closingTimer;




- (id)initWithLocation:(int)hallcode loadFromPrevious:(BOOL)loadNeeded;

// Methods for telling time
- (int)getYear;
- (int)getDay;
- (int)getMonth;
- (int)getHour;
- (int)getMinute;
- (int)getWeekDay;
- (BOOL)inSession:(NSString *)meal atHallCode:(int)hallCode;

- (NSString*)getNextDayTitle;
- (NSString*)getMeal;
- (NSString*)getDateString;

// Other Methods
- (void)increaseDay;
- (void)decreaseDay;
- (void)resetDay; 
- (void)initializeURLS;
- (void)resetMeal:(NSString *)newMealToDisplay;
- (void)changeClosingButton:(NSString *)meal tomorrow:(BOOL)tomorrow;
- (void)loadArrayIndex:(NSUInteger)index;
- (BOOL)eveningMenuEnabled;
- (void)refreshWebView;
- (void)loadFromPrevious;
- (NSString*)documentsDirectory;
- (NSString*)getCurrentDayTitle;
- (BOOL)writeApplicationData:(NSData *)data toFile:(NSString *)fileName;



// Method for Formatting URLs for UIWebview
- (NSURL *)formatURLLocation:(int)hallcode 
						year:(int)yr 
					   month:(int)mo
						 day:(int)dy
						meal:(NSString *)meal;


@end
