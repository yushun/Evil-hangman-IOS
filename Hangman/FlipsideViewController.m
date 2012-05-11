//
//  FlipsideViewController.m
//  Hangman
//
//  Created by yushun he on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"


@implementation FlipsideViewController

@synthesize delegate=_delegate;
@synthesize slider=_slider;
@synthesize numOfLetters=_numOfLetters;
@synthesize numOfTrysSlider=_NumOfTrysSlider;
@synthesize numOfTrys=_numOfTrys;

// When the number of letters value is changed in the slider
- (IBAction)changeSlider
{
    // Set and save the number of letters slider value
    float sliderNumber = [self.slider value];
    [[NSUserDefaults standardUserDefaults]setFloat: sliderNumber forKey:@"sliderValue"];
    self.numOfLetters.text = [NSString stringWithFormat:@"%.0f", floor(sliderNumber)];
}

// When the number of trys value is changed in the slider
- (IBAction)changeNumOfTrysSlider
{
    // Set and save the number of trys slider value
    float sliderNumber = [self.numOfTrysSlider value];
    [[NSUserDefaults standardUserDefaults]setFloat: sliderNumber forKey:@"numOfTrysSliderValue"];
    self.numOfTrys.text = [NSString stringWithFormat:@"%0.f", floor(sliderNumber)];
}


- (void)dealloc
{
    [_numOfTrys release];
    [_NumOfTrysSlider release];
    [_numOfLetters release];
    [_slider release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark - View lifecycle
#pragma mark - Run faster
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];  
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // get defaults of preferences from plist
    [defaults registerDefaults:[NSDictionary dictionaryWithContentsOfFile:
                                [[NSBundle mainBundle] pathForResource:@"registerDefaults" ofType:@"plist"]]];
    // Set n's default from the retrieved value
    int nLetter =[defaults integerForKey:@"n"];
    // Set maxMiss's default from the retrieved value
    int nTrys = [defaults integerForKey:@"maxMiss"];
    
    
    // Set the sliders so when user sees the previous and doesn't see the silders at default value
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"sliderValue"] != nil){
        nLetter = [[NSUserDefaults standardUserDefaults]floatForKey:@"sliderValue"];
        
        self.numOfLetters.text = [NSString stringWithFormat:@"%d", nLetter];
        self.slider.value = nLetter;
    }
    // If there is no previous value then the default value from plist is used
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"numOfTrysSliderValue"] != nil){
        nTrys = [[NSUserDefaults standardUserDefaults]floatForKey:@"numOfTrysSliderValue"];
        
        self.numOfTrys.text = [NSString stringWithFormat:@"%d", nTrys];
        self.numOfTrysSlider.value = nTrys;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
