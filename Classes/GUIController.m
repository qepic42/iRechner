//
//  GUIController.m
//  iRechner
//
//  Created by Jan Galler on 04.01.11.
//  Copyright 2011 PQ-Developing.com. All rights reserved.
//

#import "GUIController.h"
#import "CalcModel.h"
#import <math.h>

@implementation GUIController
@synthesize operatorPushed, lastOperator, lastNumbers, currentNumbers, isNegativ, removeText, exponentPushed;

// Diese Methode ist die Initialisierung der Klasse und wird beim Öffnen des Programms gestartet
// Hier setzen wir die Standardwerte für unsere Propertys
- (id) init{
	self = [super init];
	if (self != nil) {
		
		numberFormatter = [[NSNumberFormatter alloc]init];
		
		NSLog(@"%@",[numberFormatter decimalSeparator]);
		
		self.operatorPushed = NO;
		self.lastNumbers = 0;
		self.lastOperator = 0;
		self.isNegativ = NO;
		self.removeText = NO;
		self.exponentPushed = NO;
		
		[commaButton setTitle:[numberFormatter decimalSeparator]];
	}
	return self;
}

// Wenn Pi in den Zahlen als Zeichen vorhanden ist, es durch die Zahl ersetzen
-(NSNumber *)convertPi:(NSString *)convertString{
	
	// Die übergebene Zahl in einen String umwandeln
	NSString *data = [NSString stringWithFormat:@"%@",convertString];
	
	// Vorherigen erzeugten NSString in einen NSMutableString umwandeln, um π zu ersetzen
	NSMutableString *cache = [NSMutableString stringWithFormat:@"%@",data];
	
	// NSRange von π im erzeugten MutableString erzeugen
	NSRange cacheRange = [cache rangeOfString:@"π"];
	
	// Nur ersetzen, wenn ein π gefunden wurde
	if (cacheRange.length == 0) {
	}else {
		
		// Nach π im String suchen
		NSRange myRange =  [cache rangeOfString:@"π"options:NSCaseInsensitiveSearch];
		
		// π ersetzen
		[cache replaceCharactersInRange:myRange withString:[NSString stringWithFormat:@"%f",M_PI]];
		
	}
	
	// Den ersetzten Text wieder in ein double verwandeln
	NSNumber *result = [NSDecimalNumber numberWithDouble:[cache doubleValue]];
	
	// Den verwandelten double zurück geben
	return result;
}


// Wird ausgelöst, wenn Enter gedrückt wurde
-(void)pushEnter:(id)sender{
	
	// Gucken ob Exponent vorher gedrückt wurde
	if (self.exponentPushed == NO) {
		
		// TextFeld leeren, wenn vorher wenn Enter gedrückt wurde
		[diggitData setStringValue:@"calc…"];
		
		// Eine neue Instanz von 'CalcModel' schaffen, um die Berechnungsmethode aufzurufen
		calcModel = [[CalcModel alloc]init];
		
		// Prüfen ob eine Rechnung überhaupt notwendig ist
		// Wenn die letzte Zahl 0 ist 
		if(self.lastNumbers == 0){
			
			// Dann die aktuelle Zahl wieder ins Display schreiben
			[diggitData setStringValue:[NSString stringWithFormat:@"%@",[NSDecimalNumber numberWithDouble:self.currentNumbers]]];
			
			// Wenn die aktuelle Zahl 0 ist
		}else if (self.currentNumbers == 0){
			
			// Dann die letzte Zahl wieder ins Display schreiben
			[diggitData setStringValue:[NSString stringWithFormat:@"%@",[NSDecimalNumber numberWithDouble:self.lastNumbers]]];
			
			// Wenn keine beider Zahlen 0 ist
		}else {
			
			// Berechnungsmethode mit Daten der Propertys aufrufen und das Ergebnis zwischenspeichern
			double cache = [calcModel calc:self.lastNumbers :self.currentNumbers :self.lastOperator];
			
			// Das Zwischengespeicherte erst umwandeln lassen und danach ins Display zurück geben
			[diggitData setStringValue:[NSString stringWithFormat:@"%@",[NSDecimalNumber numberWithDouble:cache]]];
			
			
		}
		
		// Bool setzen, damit der Inhalt des Textfelds resetted wird
		self.removeText = YES;
		
		// Property für die aktuelle Zahl aktualisieren
		NSNumber *cache = [self convertPi:[diggitData stringValue]];
		self.currentNumbers = [cache doubleValue];
		
	}
	
}

// Wird ausgelöst, wenn ein Operator gedrückt wurde
-(void)pushOperator:(NSButton *)sender{
	
	// Property setzen, damit beim nächsten Eingeben einer Zahl das TextFeld geleert wird!
	self.operatorPushed = YES;
	
	// Den letzten Operator in einer Property festhalten
	self.lastOperator = [sender tag];
	
	// Die letzten Zahlen aus dem Display in einer Property festhalten
	NSNumber *cache = [self convertPi:[diggitData stringValue]];
	self.lastNumbers = [cache doubleValue];
	
}

// Wird ausgelöst, wenn eine Zahl gedrückt wurde
-(void)pushInteger:(NSButton *)sender{
	
	// Die Property wieder zurück setzen
	self.exponentPushed = NO;
	
	// Überprüfen, ob vorher ein Ergebnis im Feld stand. Wenn ja das Feld leeren
	if (self.removeText == YES) {
		
		// TextFeld leeren
		[diggitData setStringValue:@""];
		
		// BOOL wieder zurücksetzen
		self.removeText = NO;
	}
	
	// TextFeld leeren, wenn vorher ein Operator gedrückt wurde
	if (self.operatorPushed == YES) {
		
		// TextFeld leeren
		[diggitData setStringValue:@""];
		
		// Bool wieder zurück setzen, damit der neue Text eingegeben werden kann
		self.operatorPushed = NO;
	}
	
	// Prüfen ob Pi eingegeben wurde
	if ([sender tag] == 10){
		
		// Display leeren, bevor Pi hineingeschrieben wird
		[diggitData setStringValue:@""];
		
		// Pi ergänzen und ins Display schreiben
	//	[diggitData setStringValue:[NSString stringWithFormat:@"%@%f",[diggitData stringValue],M_PI]];
		[diggitData setStringValue:[NSString stringWithFormat:@"%@%@",[diggitData stringValue],@"π"]];
		
		NSNumber *cache = [self convertPi:[diggitData stringValue]];
		self.currentNumbers = [cache doubleValue];
		NSLog(@"CurrentNumbers: %f",self.currentNumbers);
		
	}else{
		
		// Die neuen Zahlen ergänzen und ins Display schreiben
		[diggitData setStringValue:[NSString stringWithFormat:@"%@%i",[diggitData stringValue],[sender tag]]];
		
		// Alle aktuell im Display stehenden Zahlen in einer Property speichern
		self.currentNumbers = [[diggitData stringValue]doubleValue];
		
	}
	
	// AC Button wieder auf C stellen
	[clearButton setTitle:@"C"];
	
}

// Wird aufgerufen, wenn 'AC' im GUI geklickt wurde, um das Display zu leeren
-(void)pushClear:(NSButton *)sender{
	
	// Titel des Buttons prüfen
	if ([[clearButton title]isEqualToString:@"C"]) {
		
		// Displayinhalt als 'leer' setzen
		[diggitData setStringValue:@""];
		
		// Button umbennen, um AllClear durchzuführen beim nächsten Klick
		[clearButton setTitle:@"AC"];
		
	}else if ([[clearButton title]isEqualToString:@"AC"]) {
		
		// Alle Propertys zurücksetzen
		self.lastNumbers = 0;
		self.lastOperator = 0;
		self.currentNumbers = 0;
		
		// Display-Text zurücksetzen
		[diggitData setStringValue:@""];
		
		// Button wieder umbennen
		[clearButton setTitle:@"C"];
		
	}
	
}

// Wird aufgerufen, wenn '±' im GUI geklickt wurde, um die Zahl negativ/positiv zu machen
-(void)pushPlusMinus:(NSButton *)sender{
	
	// Wenn die Zahl aktuell negativ ist, die Zahl mit -1 multiplizieren und zurück ins Display schreiben
	[diggitData setStringValue:[NSString stringWithFormat:@"%@",[NSDecimalNumber numberWithDouble:self.currentNumbers*-1]]];
	
	// Property für die aktuelle Zahl aktualisieren
	self.currentNumbers = [diggitData doubleValue];
	
}

// Wird aufgerufen, wenn der Komma Button gedrückt wurde
-(void)pushComma:(NSButton *)sender{
	
	// Komplette Zahl aus dem Display als String setzen
	NSString *data = [diggitData stringValue];
	
	// Ein 'NSRange' erzeugen, um festzustellen, ob schon ein Komma im Display steht.
	NSRange dataRange = [data rangeOfString:[numberFormatter decimalSeparator] options:NSCaseInsensitiveSearch];
	
	// Überprüfung, ob das Range leer ist, wenn ja, ist kein Komma im Display und es muss eins hinzugefügt werden
	if (dataRange.length == 0) {
		
		// Erzeugt einen cache String, mit angebendem Format und hängen einfach ein '.' hinten dran
		NSString *cache = [NSString stringWithFormat:@"%@%@",[diggitData stringValue], [numberFormatter decimalSeparator]];
		
		// Aktualisiert die Anzeige im Display
		[diggitData setStringValue:cache];
	}
	
	// Property für die aktuelle Zahl aktualisieren
	self.currentNumbers = [diggitData doubleValue];
	
}

// Wird aufgerufen, wenn delete gedrückt wurde
-(void)deleteLastNumber:(NSButton *)sender{
	
	// Daten aus dem Display auslesen und als String speichern
	NSString *cache = [diggitData stringValue];
	
	// Den ausgelesenen String umwandeln in einen NSMutableString
	NSMutableString *mutableCache = [NSMutableString stringWithFormat:@"%@",cache];
	
	// Im MutableString den letzten Character durch '' ersetzen
	[mutableCache replaceCharactersInRange:NSMakeRange([mutableCache length]-1, 1) withString:@""];
		 
	// Aktualisiert die Anzeige im Display
	[diggitData setStringValue:mutableCache];
	
	// Property für die aktuelle Zahl aktualisieren
	self.currentNumbers = [diggitData doubleValue];
	
}

// Wird aufgerufen, wenn 'x^2' an geklickt wird
-(void)pushExponent:(NSButton *)sender{
	
	// Eine Instanz der ModelKlasse erzeugen
	calcModel = [[CalcModel alloc]init];
	
	// Den Wert im Display quadrieren
	[diggitData setStringValue:[NSString stringWithFormat:@"%@",[NSDecimalNumber numberWithDouble:[calcModel calcExponent:self.currentNumbers]]]];
	
	// Property für die aktuelle Zahl aktualisieren
	self.currentNumbers = [diggitData doubleValue];
	
	// Property auf YES setzen, damit die Entertaste deaktiviert wird
	self.exponentPushed = YES;
	
}

// Wird aufgerufen, wenn die Wurzeltaste gedrückt wurde
-(void)pushSquareRoot:(NSButton *)sender{
	
	// Eine Instanz der ModelKlasse erzeugen
	calcModel = [[CalcModel alloc]init];
	
	// Den Wert im Display quadrieren
	[diggitData setStringValue:[NSString stringWithFormat:@"%@",[NSDecimalNumber numberWithDouble:[calcModel calcSquareRoot :self.currentNumbers]]]];
	
	// Property für die aktuelle Zahl aktualisieren
	self.currentNumbers = [diggitData doubleValue];
	
}


// Wird aufgerufen, wenn das Programm beendet wird
// Hier werden alle Variablen (auch Propertys!), die in der h Datei definiert wurden, freigegeben
// Propertys, die keine Objekte sind, müssen hier nicht released werden. Keine Objekte sind beispieltsweise: double, float, int, BOOL, …
- (void) dealloc{
	[numberFormatter release];
	[calcModel release];
	[super dealloc];
}


@end
