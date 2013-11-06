//
//  ECLevelManager.h
//  Eclosion
//
//  Created by Tsubasa on 13-11-4.
//
//

#import <Foundation/Foundation.h>

@interface ECLevelManager : NSObject {
}

@property (nonatomic, assign) int currentLevel;
@property (nonatomic, assign) int currentStage;

+ (ECLevelManager *)manager;
@end
