//
//  GUIController.h
//  iRechner
//
//  Created by Jan Galler on 04.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CalcModel.h"

@interface GUIController : NSObject {
	
	CalcModel *calcModel;
	
	IBOutlet NSTextField *diggitData;
	IBOutlet NSButton *clearButton;
	IBOutlet NSButton *commaButton;
	BOOL operatorPushed;
	int lastOperator;
	double lastNumbers;
	double currentNumbers;
	BOOL isNegativ;
	BOOL removeText;
	BOOL exponentPushed;
	
	NSNumberFormatter* numberFormatter;
	
}

@property() BOOL operatorPushed;
@property() int lastOperator;
@property() double lastNumbers;
@property() double currentNumbers;
@property() BOOL isNegativ;
@property() BOOL removeText;
@property() BOOL exponentPushed;

-(void)pushEnter:(NSButton *)sender;
-(void)pushOperator:(NSButton *)sender;
-(void)pushInteger:(NSButton *)sender;
-(void)pushClear:(NSButton *)sender;
-(void)pushPlusMinus:(NSButton *)sender;
-(void)pushComma:(NSButton *)sender;
-(void)pushExponent:(NSButton *)sender;
-(void)pushSquareRoot:(NSButton *)sender;
-(void)deleteLastNumber:(NSButton *)sender;
-(NSNumber *)convertPi:(NSString *)convertString;

@end
