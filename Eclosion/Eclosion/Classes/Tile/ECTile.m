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
                             @"ECTileRoad",[NSNumber numberWithInt:ECTileTypeRoad],
                             @"ECTileWall",[NSNumber numberWithInt:ECTileTypeWall],
                             @"ECTileTypeJump",[NSNumber numberWithInt:ECTileTypeJump],
                             @"ECTileTypeLadder",[NSNumber numberWithInt:ECTileTypeLadder],
                             @"ECTileTypeTrap",[NSNumber numberWithInt:ECTileTypeTrap],
                             @"ECTileTypeEnd",[NSNumber numberWithInt:ECTileTypeEnd],
                             nil];
    }
    return self;
}

+ (BaseTile *)getTileByIndex:(ECTileType)index {
    if ( !_ectileUtil ) {
        _ectileUtil = [[ECTileUtil alloc] init];
    }
    
    // Dynamic class
    NSString *classString = [_ectileUtil.classMapping objectForKey:[NSNumber numberWithInt:index]];
    if ([classString length] == 0) return nil;
    
    Class tileClass = NSClassFromString(classString);
    return [(BaseTile *)[[tileClass alloc] init] autorelease];
}

@end

@implementation ECTileRoad
- (id)init {
    if ( self = [super init]) {
        
        // Set texture
        CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:@"tile_road.png"];
        [self setTexture: texture];
        CGRect rect = CGRectZero;
		rect.size = texture.contentSize;
        [self setTextureRect:rect];
        
        // Set Propertys
        self.contentSize = CGSizeMake(80, 40);
        self.tileWidth = 305;
        self.tileHeight = 105;
        self.prototype = TileProtoWall;
    }
    return self;
}
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

