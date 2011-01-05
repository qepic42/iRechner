//
//  CalcModel.h
//  iRechner
//
//  Created by Jan Galler on 04.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CalcModel : NSObject {

}

-(double)calc:(double)diggitData :(double)calcData :(int)calcOperator;
-(double)calcExponent:(double)diggitData;
-(double)calcSquareRoot:(double)diggitData;

@end
