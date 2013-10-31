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
                             @"ECTileJump",[NSNumber numberWithInt:ECTileTypeJump],
                             @"ECTileLadder",[NSNumber numberWithInt:ECTileTypeLadder],
                             @"ECTileTrap",[NSNumber numberWithInt:ECTileTypeTrap],
                             @"ECTileEnd",[NSNumber numberWithInt:ECTileTypeEnd],
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

@implementation ECTileBlank
- (id)init {
    if ( self = [super init]) {

        // Set Propertys
        self.contentSize = CGSizeMake(ECTileSize, ECTileSize);
        self.tileW = self.contentSize.width;
        self.tileH = self.contentSize.height;
        self.prototype = TileMapWalkable;
        self.alowingDirection = ECDirectionRight | ECDirectionLeft;
        
    }
    return self;
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
        self.contentSize = CGSizeMake(3*ECTileSize, ECTileSize);
        self.tileW = self.contentSize.width;
        self.tileH = self.contentSize.height;
        self.prototype = TileMapWall;
        self.alowingDirection = ECDirectionRight | ECDirectionLeft;
        
        // Moveble
        self.movebal = YES;
    }
    return self;
}
@end

@implementation ECTileWall
- (id)init {
    if ( self = [super init]) {
        
        // Set texture
        CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:@"wall.png"];
        [self setTexture: texture];
        CGRect rect = CGRectZero;
		rect.size = texture.contentSize;
        [self setTextureRect:rect];
        
        // Set Propertys
        self.contentSize = CGSizeMake(ECTileSize, ECTileSize);
        self.tileW = self.contentSize.width;
        self.tileH = self.contentSize.height;
        self.prototype = TileMapWall;
    }
    return self;
}
@end

@implementation ECTileJump

@end

@implementation ECTileLadder

@end

@implementation ECTileTrap
- (id)init {
    if ( self = [super init]) {
        
        // Set texture
        CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:@"hole.png"];
        [self setTexture: texture];
        CGRect rect = CGRectZero;
		rect.size = texture.contentSize;
        [self setTextureRect:rect];
        
        // Set Propertys
        self.contentSize = CGSizeMake(ECTileSize, ECTileSize);
        self.tileW = self.contentSize.width;
        self.tileH = self.contentSize.height;
        self.prototype = TileMapTrap;
    }
    return self;
}
@end

@implementation ECTileEnd
- (id)init {
    if ( self = [super init]) {
        
        // Set texture
        CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:@"flower.png"];
        [self setTexture: texture];
        CGRect rect = CGRectZero;
		rect.size = texture.contentSize;
        [self setTextureRect:rect];
        
        // Set Propertys
        self.contentSize = CGSizeMake(ECTileSize, ECTileSize);
        self.tileW = self.contentSize.width;
        self.tileH = self.contentSize.height;
        self.prototype = TileMapEnd;
    }
    return self;
}
@end

