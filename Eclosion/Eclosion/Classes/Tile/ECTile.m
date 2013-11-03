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
                             @"ECTileStar",[NSNumber numberWithInt:ECTileTypeStar],
                             @"ECTileTree",[NSNumber numberWithInt:ECTileTypeTree],
                             @"ECTileTrap",[NSNumber numberWithInt:ECTileTypeTrap],
                             @"ECTileEnd",[NSNumber numberWithInt:ECTileTypeEnd],
                             @"ECTileRoadH1",[NSNumber numberWithInt:ECTileTypeMovH1],
                             @"ECTileRoadH2",[NSNumber numberWithInt:ECTileTypeMovH2],
                             @"ECTileRoadH3",[NSNumber numberWithInt:ECTileTypeMovH3],
                             @"ECTileRoadL1",[NSNumber numberWithInt:ECTileTypeMovL1],
                             @"ECTileRoadL2",[NSNumber numberWithInt:ECTileTypeMovL2],
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
        // Set Propertys
        self.prototype = TileMapWall;
        
        // Moveble
        self.movebal = YES;
    }
    return self;
}
@end

@implementation ECTileRoadH1
- (id)init {
    if ( self = [super init]) {
        
        // Set texture
        [self setTextureFile:@"blockG11.png" highlight:@"blockG11_on.png"];
        
        // Set Propertys
        self.contentSize = CGSizeMake(ECTileSize, ECTileSize);
        self.tileW = self.contentSize.width;
        self.tileH = self.contentSize.height;
        self.alowingDirection = ECDirectionUp | ECDirectionDown;
    }
    return self;
}
@end

@implementation ECTileRoadH2
- (id)init {
    if ( self = [super init]) {
        
        // Set texture
        [self setTextureFile:@"blockR12.png" highlight:@"blockR12_on.png"];
        
        // Set Propertys
        self.contentSize = CGSizeMake(ECTileSize, 2 * ECTileSize);
        self.tileW = self.contentSize.width;
        self.tileH = self.contentSize.height;
        self.alowingDirection = ECDirectionUp | ECDirectionDown;
    }
    return self;
}
@end

@implementation ECTileRoadH3
- (id)init {
    if ( self = [super init]) {
        
        // Set texture
        [self setTextureFile:@"blockR13.png" highlight:@"blockR13_on.png"];
        
        // Set Propertys
        self.contentSize = CGSizeMake(ECTileSize, 3 * ECTileSize);
        self.tileW = self.contentSize.width;
        self.tileH = self.contentSize.height;
        self.alowingDirection = ECDirectionUp | ECDirectionDown;
    }
    return self;
}
@end

@implementation ECTileRoadL1
- (id)init {
    if ( self = [super init]) {
        
        // Set texture
        [self setTextureFile:@"tile_road.png" highlight:@"tile_road_on.png"];
        
        // Set Propertys
        self.contentSize = CGSizeMake(3*ECTileSize, ECTileSize);
        self.tileW = self.contentSize.width;
        self.tileH = self.contentSize.height;
        self.alowingDirection = ECDirectionRight | ECDirectionLeft;
    }
    return self;
}
@end

@implementation ECTileRoadL2
- (id)init {
    if ( self = [super init]) {
        
        // Set texture
        [self setTextureFile:@"blockY21.png" highlight:@"blockY21_on.png"];
        
        // Set Propertys
        self.contentSize = CGSizeMake(2*ECTileSize, ECTileSize);
        self.tileW = self.contentSize.width;
        self.tileH = self.contentSize.height;
        self.alowingDirection = ECDirectionRight | ECDirectionLeft;
    }
    return self;
}
@end


@implementation ECTileWall
- (id)init {
    if ( self = [super init]) {
        
        // Set texture
        [self setTextureFile:@"wall.png" highlight:@"wall.png"];
        
        // Set Propertys
        self.contentSize = CGSizeMake(ECTileSize, ECTileSize);
        self.tileW = self.contentSize.width;
        self.tileH = self.contentSize.height;
        self.prototype = TileMapWall;
    }
    return self;
}
@end

@implementation ECTileStar
- (id)init {
    if ( self = [super init]) {
        
        // Set texture
        [self setTextureFile:@"star.png" highlight:@"star.png"];
        
        // Set Propertys
        self.contentSize = CGSizeMake(ECTileSize, ECTileSize);
        self.tileW = self.contentSize.width;
        self.tileH = self.contentSize.height;
        self.prototype = TileMapStar;
    }
    return self;
}
@end

@implementation ECTileTree

@end

@implementation ECTileTrap
- (id)init {
    if ( self = [super init]) {
        
        // Set texture
        [self setTextureFile:@"hole.png" highlight:@"hole.png"];
        
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
        [self setTextureFile:@"flower.png" highlight:@"flower.png"];
        
        // Set Propertys
        self.contentSize = CGSizeMake(ECTileSize, ECTileSize);
        self.tileW = self.contentSize.width;
        self.tileH = self.contentSize.height;
        self.prototype = TileMapEnd;
    }
    return self;
}
@end

