//
//  ECTile.m
//  Eclosion
//
//  Created by Tsubasa on 13-10-2.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ECTile.h"

static ECTileUtil* _ectileUtil;
@implementation ECTileUtil
@synthesize classMapping;

- (id)init {
    if ( self = [super init] ) {
        self.classMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:ECTileTypeRoad],@"ECTileRoad",
                             [NSNumber numberWithInt:ECTileTypeWall],@"ECTileWall",
                             [NSNumber numberWithInt:ECTileTypeJump],@"ECTileTypeJump",
                             [NSNumber numberWithInt:ECTileTypeLadder],@"ECTileTypeLadder",
                             [NSNumber numberWithInt:ECTileTypeTrap],@"ECTileTypeTrap",
                             [NSNumber numberWithInt:ECTileTypeEnd],@"ECTileTypeEnd",
                             nil];
    }
    return self;
}

+ (BaseTile *)getTileByIndex:(ECTileType)index {
    if ( !_ectileUtil ) {
        _ectileUtil = [[ECTileUtil alloc] init];
    }
    Class tileclass = NSClassFromString([_ectileUtil.classMapping
                                         objectForKey:[NSNumber numberWithInt:index]]);
    return [[tileclass alloc] init];
}

@end

@implementation ECTileRoad

@end

@implementation ECTileWall

@end

@implementation ECTileJump

@end

@implementation ECTileLadder

@end

@implementation ECTileTrap

@end

@implementation ECTileEnd

@end

