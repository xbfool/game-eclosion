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

- (id)init {
    if ( self = [super init] ) {
        self.levelDataArray = [[NSMutableArray alloc] init];
        for ( int i = 0; i < MAX_LEVEL; i++ ) {
            [self.levelDataArray addObject:[ECLevel instance]];
        }
    }
    return self;
}

- (ECLevel *)getCurrentLevelData {
    NSAssert([self.levelDataArray count] > self.currentLevel, @"Error! Level index beyond the bounds!");
    return [self.levelDataArray objectAtIndex:self.currentLevel];
}

@end
