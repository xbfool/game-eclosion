//
//  ECLevelManager.m
//  Eclosion
//
//  Created by Tsubasa on 13-11-4.
//
//

#import "ECLevelManager.h"

static ECLevelManager * _sharedManager;

@implementation ECLevelManager
@synthesize levelDataArray;

+ (ECLevelManager *)manager {
    if ( _sharedManager == nil ) {
        _sharedManager = [[ECLevelManager alloc] init];
    }
    return _sharedManager;
}

- (void)setCurrentLevel:(int)currentLevel {
    NSAssert(currentLevel < MAX_LEVEL, @"Error! Level index beyond the bounds!");
    _currentLevel = currentLevel;
}

- (void)setCurrentStage:(int)currentStage {
    NSAssert(currentStage < MAX_STAGE, @"Error! Stage index beyond the bounds!");
    _currentStage = currentStage;
}

- (int)totalScore {
    int score = 0;
    for ( int i = 0; i < MAX_LEVEL; i++ ) {
        ECLevel *lev = [self.levelDataArray objectAtIndex:i];
        score += lev.score;
    }
    return score;
}

- (void)save {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [documentDirectories objectAtIndex:0];
	NSString *myFilePath = [documentDirectory stringByAppendingPathComponent:@"EclosionData.data"];
    
	NSMutableData *settingsData = [NSMutableData data];
	NSKeyedArchiver *encoder =  [[NSKeyedArchiver alloc] initForWritingWithMutableData:settingsData];
    
	//Archive each instance variable/object using its name
	[encoder encodeObject:[NSNumber numberWithInt:self.currentStage] forKey:@"currentStage"];
	[encoder encodeObject:[NSNumber numberWithInt:self.currentLevel] forKey:@"currentLevel"];
	[encoder encodeObject:self.levelDataArray forKey:@"levelDataArray"];
    
	[encoder finishEncoding];
	[settingsData writeToFile:myFilePath atomically:YES];
	[encoder release];
}

- (id)init {
    if ( self = [super init] ) {
        //----- READ CLASS FROM FILE -----
		NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentDirectory = [documentDirectories objectAtIndex:0];
		NSString *myFilePath = [documentDirectory stringByAppendingPathComponent:@"EclosionData.data"];
		NSData *settingsData = [[NSMutableData alloc] initWithContentsOfFile:myFilePath];
        
		if (settingsData) {
			//----- EXISTING DATA EXISTS -----
			NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:settingsData];
            
			//Decode each instance variable/object that is archived
			self.currentStage = [[decoder decodeObjectForKey:@"currentStage"] intValue];
			self.currentLevel = [[decoder decodeObjectForKey:@"currentLevel"] intValue];
			self.levelDataArray = [decoder decodeObjectForKey:@"levelDataArray"];
            
			[decoder finishDecoding];
			[decoder release];
			[settingsData release];
		} else {
			//----- NO DATA EXISTS -----
            self.levelDataArray = [[NSMutableArray alloc] init];
            for ( int i = 0; i < MAX_LEVEL; i++ ) {
                [self.levelDataArray addObject:[ECLevel instance]];
            }
            
		}
    }
    return self;
}

- (ECLevel *)getCurrentLevelData {
    NSAssert([self.levelDataArray count] > self.currentLevel, @"Error! Level index beyond the bounds!");
    return [self.levelDataArray objectAtIndex:self.currentLevel];
}

@end
