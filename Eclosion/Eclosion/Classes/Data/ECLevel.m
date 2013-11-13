//
//  ECLevel.m
//  Eclosion
//
//  Created by Tsubasa on 13-11-6.
//
//

#import "ECLevel.h"

@implementation ECLevel

- (id)initWithCoder:(NSCoder *)aCoder {

}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithInt:self.score]];
    [aCoder encodeObject:[NSNumber numberWithInt:self.levelId]];
    [aCoder encodeObject:[NSNumber numberWithBool:self.cleared]];
}

@end
