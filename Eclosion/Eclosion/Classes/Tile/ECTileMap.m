//
//  ECTileMap.m
//  Eclosion
//
//  Created by Tsubasa on 13-10-2.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ECTileMap.h"
#import "ECTile.h"


@implementation ECTileMap

+ (ECTileMap *)mapBuildWithFile:(NSString *)filename {
    ECTileMap * map = [[ECTileMap alloc] init];
    [map buildMap:filename];
    return [map autorelease];
}

- (id)init {
    if ( self = [super init ]) {
        _tileMatrix = [[NSMutableArray alloc] init];
        memset(_picxlMap, 0, sizeof(int) * MAP_ROW * TILE_SIZE * MAP_COL * TILE_SIZE);
    }
    return self;
}

- (void)buildMap:(NSString *)filename {
    
    // read file
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    _tileMatrix = [[dic objectForKey:@"map"] copy];
    
    // read map matrix
    for ( int i = 0; i < [_tileMatrix count]; i++ ) {
        NSDictionary *objDic = [_tileMatrix objectAtIndex:i];
        BaseTile *tile = [ECTileUtil getTileByIndex:
                          [[objDic objectForKey:@"type"] intValue]];
        if (!tile) continue;
        
        int x = [[[objDic objectForKey:@"position"] objectForKey:@"x"] intValue];
        int y = [[[objDic objectForKey:@"position"] objectForKey:@"y"] intValue];
        tile.position = ccp(TILE_SIZE * x, TILE_SIZE * y);
        [self addChild:tile];
    }
}

- (void)update {
    memset(_picxlMap, 0, sizeof(int) * MAP_ROW * TILE_SIZE * MAP_COL * TILE_SIZE);
    for ( id obj in self.children ) {
        if ( [obj isKindOfClass:[BaseTile class]]) {
            BaseTile *tile = (BaseTile *)obj;
            for ( int x = tile.position.x; x < (tile.position.x + tile.contentSize.width); x ++ ) {
                for ( int y = tile.position.y; y > (tile.position.y - tile.contentSize.height); y -- ) {
                    if (( x > MAP_ROW * TILE_SIZE ) || ( x < 0 )) continue;
                    if (( y > MAP_COL * TILE_SIZE ) || ( y < 0 )) continue;
                    _picxlMap[x][y] = tile.prototype;
                }
            }
        }
    }
}

- (void)dealloc {
    [_tileMatrix release];
    [super dealloc];
}

@end





