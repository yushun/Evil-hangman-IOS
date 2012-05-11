//
//  MainViewController.h
//  Hangman
//
//  Created by yushun he on 8/9/11.
//  id: 60837155
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {

}

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UILabel *talkBox;
@property (nonatomic, retain) IBOutlet UILabel *letterUsedLabel;
@property (nonatomic, retain) IBOutlet UILabel *numOfMissesLabel;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UIImageView *dialogView; 
@property (nonatomic, retain) IBOutlet UIImageView *hangManImageView;
@property (nonatomic, retain) UIImage *hangManPic;
@property (nonatomic, retain) NSMutableArray *completePlist;
@property (nonatomic, retain) NSMutableArray *mutableArray;
@property (nonatomic, retain) NSMutableArray *currentWord;
@property (nonatomic, retain) NSMutableArray *lettersUsed;
@property (assign, nonatomic) int n;
@property (assign, nonatomic) int maxMiss;
@property (assign, nonatomic) int missCount;


- (IBAction)showInfo:(id)sender;
- (IBAction)returnClicked:(id)sender;
- (IBAction)buttonNewGame:(id)sender;
- (void)loadGame;
- (void)setHangManImage:(float)percent;
- (void)checkLose;
- (void)hangManSpeak;
- (void)hideTalkBox;
- (void)setTalkText:(NSString *)words;
- (void)updateMissInfo;
- (void)checkWin:(BOOL)won;
- (void)updateLetterUsedArray:(NSString *)letter;
- (NSMutableString*) chooseTheBestECfrom:(NSMutableDictionary *)set;
- (void)setFontSize;

@end
