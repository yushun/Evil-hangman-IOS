//
//  MainViewController.m
//  Hangman
//
//  Created by yushun he on 8/9/11.
//  Id: 60837155
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

@synthesize hangManPic=_hangManPic;
@synthesize dialogView=_dialogView;
@synthesize hangManImageView=_hangManImageView;
@synthesize talkBox=_talkBox;
@synthesize label=_label;
@synthesize letterUsedLabel=_letterUsedLabel;
@synthesize numOfMissesLabel=_numOfMissesLabel;
@synthesize textField=_textField;
@synthesize completePlist=_completePlist;
@synthesize mutableArray=_mutableArray;
@synthesize currentWord=_currentWord;
@synthesize lettersUsed=_lettersUsed;
@synthesize n=_n;
@synthesize maxMiss=_maxMiss;
@synthesize missCount=_missCount;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        // get defaults of preferences from plist
    [defaults registerDefaults:[NSDictionary dictionaryWithContentsOfFile:
                                [[NSBundle mainBundle] pathForResource:@"registerDefaults" ofType:@"plist"]]];
    
    // Set n's default from the retrieved value
    self.n =[defaults integerForKey:@"n"];
    // Set maxMiss's default from the retrieved value
    self.maxMiss = [defaults integerForKey:@"maxMiss"];
    
    // Get the words.plist and save it in completePlist array
    NSString *postFile = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
    self.completePlist = [[NSMutableArray alloc]initWithContentsOfFile:postFile]; 
    
    // Gtart game
    [self loadGame];
    // Destroy the array when the game is completely over
    [self.completePlist release];
}

- (void)loadGame
{
    // Get the setting values from sliders for n and maxMiss
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"sliderValue"] != nil)
    {
        self.n = [[NSUserDefaults standardUserDefaults]floatForKey:@"sliderValue"];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"numOfTrysSliderValue"] != nil)
    {
        self.maxMiss = [[NSUserDefaults standardUserDefaults]floatForKey:@"numOfTrysSliderValue"];
    }
    
    // Set the default number of misses to zero
    self.missCount = 0;
    
    // The blanks for the label
    NSString *blank = @"_ ";
   
    // The letters found and the blanks
    self.currentWord = [[NSMutableArray alloc]initWithCapacity:self.n+1];
    
    // The letters entered by the user
    self.lettersUsed = [[NSMutableArray alloc]initWithCapacity:self.maxMiss];
   
    // The n blanks to represent in the begining of the game
    NSMutableString *result = [[NSMutableString alloc] init];
    
    // Set up the blank in the array and for the label
    for (int x=0;x<self.n;x++){
        [self.currentWord addObject:blank];
        [result appendString:[blank description]];
    }
    // Dislay the blanks
    self.label.text = result;
    // Destroy the result because the blanks are already diplayed on screen
    [result release];
    
    // Set the font size depending the on the number of blanks
    [self setFontSize];
    
    // Used to save the current equivence class
    self.mutableArray = [[NSMutableArray alloc] init]; 
    
    // Parse the plist to words of only n length
    for (NSString *string in self.completePlist)
    {
        if ([string length] == self.n){
            [self.mutableArray addObject:string];
        }
    }
    
    // Release all the allocated memory
    [_lettersUsed release];
    [_currentWord release];
    [_mutableArray release];
}

// Set the font size depending on the word length, for better aesthetics
- (void)setFontSize
{
    if(self.n < 12){
        [self.label setFont:[UIFont fontWithName:@"Helvetica" size:24]];
    } else if (self.n <=16){
        [self.label setFont:[UIFont fontWithName:@"Helvetica" size:20]];
    } else if (self.n <=20){
        [self.label setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    } else {
        [self.label setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    }
}

// When user clicks the new game
- (IBAction) buttonNewGame:(id)sender
{
    self.textField.enabled      =   YES;                        // Allows user to enter letters in the text field
    self.numOfMissesLabel.text  =   @"0";                       // Set the miss count dsplayed to 0
    self.letterUsedLabel.text   =   @"";                        // Take off any letters the is displayed
    self.textField.text         =   @"";                        // Remove any letter in the textfield

    // Change the pic to the default image
    self.hangManPic = [UIImage imageNamed: @"hangman1.png"];        
    [self.hangManImageView setImage:self.hangManPic];
    
    [self hideTalkBox];

    
    [self loadGame];                                            // Load the game
}

// When user clicks enter on the keyboard
- (IBAction) returnClicked:(id)sender
{
    @try{
        // Remove what is displayed in the last phase
        [self hideTalkBox];
        // Get the NSString* from the textfield's text
        NSString *textFieldText = self.textField.text;
        
        // If the user enter nothing, then complain
        if ([textFieldText length]==0) {
            [self setTalkText:@"Please Enter something!"];
            return;
        }
        
        // Save the letter as a capitalzed char 
        const char *s = [[textFieldText capitalizedString]cStringUsingEncoding:NSASCIIStringEncoding];
        // Make a set with all symbols not in the alphabet
        NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLKMNOPQRSTUVWXYZ"]invertedSet];
        
        // If the unichar is not a letter or more than one letter, then complain
        if ([[NSString stringWithUTF8String: s] rangeOfCharacterFromSet:set].location != NSNotFound){
            [self setTalkText:@"Please, enter only one letter."];
            return;
        }
        
        // Set the one letter string to unichar for later use
        unichar sAtIndexZero = s[0];
        // Set That to a NSString
        NSString *sAtIndexZeroString = [NSString stringWithFormat:@"%C", sAtIndexZero];
        
        // Check if the letter is one of the used letters
        for(NSString *usedLetter in self.lettersUsed){
            if ([sAtIndexZeroString isEqualToString:usedLetter])
            {
                [self setTalkText:[NSString stringWithFormat:@"The letter %@ is already used. Please try another.", 
                                   sAtIndexZeroString]];
                return;
            }
        }
        
        // the placeholder 0 is used for making the name of an equivalence class
        NSString *zeroPlaceHolder = [NSString stringWithString:@"0"];
        
        // Stores the equivalence class in an NSDictionary of keys and arrays 
        NSMutableDictionary *equivalenceSet = [[[NSMutableDictionary alloc]init]autorelease];
        // Break down the current equivalence class to smaller equavalence classes. All stored in equivalenceset
        for(NSString *word in self.mutableArray){
           
            // Used for the name of the equivalence classes, and the keys in the NSdictionary
            NSMutableString *binaryEC = [NSMutableString stringWithCapacity:self.n];
            
            // Constructing the name depending on the letter placement in the word
            for(int i=0; i<self.n ;i++){
                unichar testChar =[word characterAtIndex:i];
                
                if(testChar == sAtIndexZero){
                    [binaryEC appendString:sAtIndexZeroString];
                }else{
                    [binaryEC appendString:zeroPlaceHolder];
                }
            }
            
            // Storing the word and key in the dictionary
            if ([equivalenceSet objectForKey:binaryEC]) // If the key already exists
            {   
                // Get the array with that key
                NSMutableArray *obj = [equivalenceSet objectForKey:binaryEC];
                // Store the word in that array
                [obj addObject:word];
                // update the NSDictionary
                //[equivalenceSet setObject:obj forKey:binaryEC];//////
                
            }else{
                // Create a new array to hold the words of the same EC
                NSMutableArray *binaryECArray = [[[NSMutableArray alloc]init]autorelease];
                // Add the word to the array
                [binaryECArray addObject:word];
                // Add the array to the object
                [equivalenceSet setObject:binaryECArray forKey:binaryEC];
                
            }
        }
        
        // Set the best EC in the mutableArray and return the best key
        NSMutableString *bestKey = [self chooseTheBestECfrom:equivalenceSet];
    
        // Used to store to the label
        NSMutableString *result = [[NSMutableString alloc]init];
        
        BOOL letterExists   = NO;
        BOOL winning        = YES;
        
        // Going through the best class's name to update the label.
        for (int x=0; x<self.n; x++) {
            // If the best key does not have 0 in that index that means it's the index of the letter.
            if ([bestKey characterAtIndex:x] != '0' ) {
                // The letter in the current word array
                [self.currentWord insertObject:sAtIndexZeroString atIndex:x];
                // Delete the blank space that have shifted down because of the added letter
                [self.currentWord removeObjectAtIndex:x+1];
                letterExists = YES;
            }else{
                // Check to see if there are still blanks in the word, if no then implies Win
                if ([[self.currentWord objectAtIndex:x] isEqualToString:@"_ "]){
                    winning = NO;
                }
            }
            // append to result, to store in label
            [result appendString:[self.currentWord objectAtIndex:x]];
        }
        // check if player missed the letter or check if player wins
        if (letterExists == NO){
            [self hangManSpeak];    // Hangman talks to the users
            [self updateMissInfo];  // This also checks if user loses the game
        }else{
            [self checkWin:winning];
        }
        // Update the letters used to include the new letter
        [self updateLetterUsedArray:sAtIndexZeroString];
        // update the label
        self.label.text = result;
        // destroy 
        [result release];
    }
    // Catch any execptions, if player is using a custom keyoard and enters unknown symbols
    @catch (NSException *exception) {
        [self setTalkText:@"Did you try to break the app? That's one more miss for you!"];
        [self updateMissInfo];
        return;
    }
}

- (void)hangManSpeak
{
    // Depending on the number of misses hangman say different sentences
    switch (self.missCount) {
        case 1:
            [self setTalkText:@"Hi, can you give me a hand?"];
            break;
        case 3:
            [self setTalkText:@"Please, solve the word."];
            break;
        case 6:
            [self setTalkText:@"I know you can do this.  *cuff*"];
            break;
        case 8:
            [self setTalkText:@"Help me! I don't think I can make it."];
            break;
        NSString * words;
        case 9:
            words = [NSString stringWithFormat:@"Have you tried the letter %@ *chock*",[self.lettersUsed objectAtIndex:3]];
            [self setTalkText:words];
            break;
        case 10:
            [self setTalkText:@"Help m..."];
            break;
        case 13:
            [self setTalkText:@"Try J."];
            break;
        case 15:
            [self setTalkText:@"Hel..."];
            break;
        case 24:
            [self setTalkText:@"... Really you cannot solve this?"];
            break;
    }
}

-(NSMutableString *) chooseTheBestECfrom:(NSMutableDictionary *)set
{
    id key;
    int max=0, keyCount=0;
    
    // used to traverse through the nsdictionary
    NSEnumerator *enumerator = [set keyEnumerator];
    // Best equivalence class
    NSMutableArray *bestEC = [[[NSMutableArray alloc]init]autorelease];
    // Best equvalence classes' key
    NSMutableString *bestKey = [[[NSMutableString alloc]init]autorelease];
    
    // Ges through the dictionary
    while ((key = [enumerator nextObject])) {
        
        // Make a temp array to store the current class
        /* currentEC is instantiated inside the while loop because bestEC will need to certain currentEC
         while currentEC should still be able to change */
        NSMutableArray *currentEC = [[[NSMutableArray alloc]init]autorelease];
        
         // poplate the current class
        currentEC = [set objectForKey:key];
        // set the current key
        keyCount =[currentEC count];
        
        // Choose the first class with the most elements in there
        if(max < keyCount){
            max = keyCount;
            bestKey = key;
            bestEC = currentEC;
        }/*else if(max == keyCount){
          max = keyCount;
          bestKey = key;
          bestEC = currentEC;
          }*/
        
    }
    // Incase the best set is the original set
    if (self.mutableArray != bestEC){
        self.mutableArray = bestEC; // If it is not the same then update it to the new one
    }
    // returns the best key for reference later 
    return bestKey;
}

// When the letter is not in the answer
-(void) updateMissInfo
{
    // miss count is increased by 1 and setted to the label
    self.numOfMissesLabel.text = [NSString stringWithFormat:@"%d", ++self.missCount];
    // Calculate the percentage to determin which picture to show
    float percent = self.missCount/(float)self.maxMiss;
    [self setHangManImage:percent];
    // check if this miss make the user run out of chances
    [self checkLose];
}

// Set the hangman pic
-(void) setHangManImage:(float)percent
{    
    // 1 repesents the player loses
    if(percent == 1){
        self.hangManPic = [UIImage imageNamed: @"hangman8.png"];
    } else if (percent > 0.83) {
        self.hangManPic = [UIImage imageNamed: @"hangman7.png"];
    } else if (percent > 0.66) {
        self.hangManPic = [UIImage imageNamed: @"hangman6.png"];
    } else if (percent >= 0.50) {
        self.hangManPic = [UIImage imageNamed: @"hangman5.png"];
    } else if (percent > 0.33) {
        self.hangManPic = [UIImage imageNamed: @"hangman4.png"];
    } else if (percent > 0.16) {
        self.hangManPic = [UIImage imageNamed: @"hangman3.png"];
    } else if (percent > 0.00) {
        self.hangManPic = [UIImage imageNamed: @"hangman2.png"];
    }
    [self.hangManImageView setImage:self.hangManPic];
}

// Sets what the image (hangman) says
- (void)setTalkText:(NSString *)words
{
    [self.dialogView setHidden:NO];
    [self.talkBox setHidden:NO];
    self.talkBox.text = words;
}

// Hides what hangman is saying
-(void)hideTalkBox
{
    [self.talkBox setHidden:YES];
    [self.dialogView setHidden:YES];
}

// Adds the lastest letter the user types to the rest
- (void)updateLetterUsedArray:(NSString *)letter
{
    // Adds it to the array
    [self.lettersUsed addObject:letter];
    
    // Updates the letterUsedLabel so user know the used letters
    self.letterUsedLabel.text = [self.letterUsedLabel.text stringByAppendingString: [NSString stringWithFormat:@" %@", letter]];
    
}

// Check if player wins
- (void) checkWin:(BOOL)won
{
    //check if they win
    if (won == YES)
    {
        // Set textfield to uneditable so users cannot continue playing
        self.textField.enabled = NO;
        // Set text that hangman says
        [self setTalkText:@"Thank You for saving me!"];
        // Display a message to notify the user
        NSString *loseMessage =[@"Congratulations! You saved him. The word is " stringByAppendingString: [self.mutableArray objectAtIndex:0]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"YOU WON!!!!" 
                                                        message:loseMessage
                                                       delegate:nil 
                                              cancelButtonTitle:@"Close" 
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
    }
}

// Check if player loses
- (void) checkLose
{
    // If player does not lose then return
    if(self.missCount < self.maxMiss)
        return;
    
    // If player loses
    // Set textfield to uneditable so users cannot continue playing
    self.textField.enabled = NO;
    // Set the text the hangman says
    [self setTalkText:@". . ."];
    
    // Show dialog to notify the user
    NSString *loseMessage =[@"Oh no, he died from sadness. The word is " stringByAppendingString: [self.mutableArray objectAtIndex:0]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"YOU LOSE" 
                                                    message:loseMessage
                                                   delegate:nil 
                                          cancelButtonTitle:@"Close" 
                                          otherButtonTitles:nil];
    
    [alert show];
    [alert release];
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
    controller.delegate = self;
    
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
    
    [controller release];
}

// Set portrait only
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [_talkBox release];
    [_hangManPic release];
    [_dialogView release];
    [_hangManImageView release];
    [_lettersUsed release];
    [_currentWord release];
    [_completePlist release];
    [_mutableArray release];
    [_textField release];
    [_numOfMissesLabel release];
    [_letterUsedLabel release];
    [_label release];
    
    [super dealloc];
}

@end
