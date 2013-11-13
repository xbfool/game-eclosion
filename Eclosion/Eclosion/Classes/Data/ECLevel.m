//
//  ECLevel.m
//  Eclosion
//
//  Created by Tsubasa on 13-11-6.
//
//

#import "ECLevel.h"

@implementation ECLevel

+ (ECLevel *)instance {
    return [[[ECLevel alloc] init] autorelease];
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super init];
    self.score = [aCoder decodeIntForKey:@"score"];
    self.levelId = [aCoder decodeIntForKey:@"levelId"];
    self.cleared = [aCoder decodeBoolForKey:@"cleared"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithInt:self.score] forKey:@"score"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.levelId] forKey:@"levelId"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.cleared] forKey:@"cleared"];
}

@end
