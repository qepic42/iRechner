//
//  CalcModel.m
//  iRechner
//
//  Created by Jan Galler on 04.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import "CalcModel.h"


@implementation CalcModel

// Diese Methode wird aufgerufen, wenn 'Enter' gedrückt wurde. (Eigentlich erfolgt der Aufruf aus dem GUIController!)
// Hier wird berechnet
-(double)calc:(double)diggitData :(double)calcData :(int)calcOperator{
	
	NSLog(@"Model-Parameter: \nDiggitData: %f\ncalcData: %f\nOperator: %i",diggitData, calcData, calcOperator);
	
	// Variable 'result' erstellen (Standardwert: 0)
	double result = 0;
	
	// Überprüfen, welcher Operator übergeben wurde
	if (calcOperator == 0) {
		result = diggitData + calcData;
	}else if (calcOperator == 1) {
		result = diggitData - calcData;
	}else if (calcOperator == 2) {
		result = diggitData * calcData;
	}else if (calcOperator == 3) {
		result = diggitData / calcData;
	}
	
	NSLog(@"Model-Result: %f",result);
	
	// Das Ergebnis der Berechnung zurück geben
	return result;
}

-(double)calcExponent:(double)diggitData{
	
	// Standardwert für result festlegen
	double result = 0;
	
	// Quadrieren
	result = pow(diggitData, 2);
	
	// Wert wieder zurück geben
	return result;
}

-(double)calcSquareRoot:(double)diggitData{
	
	// Standardwert für result festlegen
	double result = 0;
	
	// Quadrieren
	result = pow(diggitData, 0.5);
	
	// Wert wieder zurück geben
	return result;
	
}

@end
