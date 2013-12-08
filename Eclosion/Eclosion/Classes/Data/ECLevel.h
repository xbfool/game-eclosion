//
//  ECLevel.h
//  Eclosion
//
//  Created by Tsubasa on 13-11-6.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    LevelStatusLock     = 0,
    LevelStatusOpen     = 1,
    LevelStatusCleared  = 2,
}LevelStatus;

@interface ECLevel : NSObject

@property (nonatomic, assign) int   levelId;
@property (nonatomic, assign) int   score;
@property (nonatomic, assign) int  cleared;

+ (ECLevel *)instance;
@end
