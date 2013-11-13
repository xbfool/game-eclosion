//
//  ECLevel.h
//  Eclosion
//
//  Created by Tsubasa on 13-11-6.
//
//

#import <Foundation/Foundation.h>

@interface ECLevel : NSObject

@property (nonatomic, assign) int   levelId;
@property (nonatomic, assign) int   score;
@property (nonatomic, assign) BOOL  cleared;

+ (ECLevel *)instance;
@end
