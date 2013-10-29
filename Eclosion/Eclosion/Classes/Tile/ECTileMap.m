//
//  ECTileMap.m
//  Eclosion
//
//  Created by Tsubasa on 13-10-2.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ECTileMap.h"
#import "ECTile.h"
#import "ECHero.h"

@implementation ECTileMap

+ (ECTileMap *)mapBuildWithFile:(NSString *)filename {
    ECTileMap * map = [[ECTileMap alloc] init];
    [map buildMap:filename];
    return [map autorelease];
}

- (id)init {
    if ( self = [super init ]) {
        _tileMatrix = [[NSMutableArray alloc] init];
        _myItems = [[NSMutableArray alloc] init];
        memset(_pixelMap, 0, sizeof(int) * MAP_ROW * TILE_SIZE * MAP_COL * TILE_SIZE);
    }
    return self;
}

- (void)dealloc {
    [_tileMatrix release];
    [_myItems release];
    [_hero removeFromParentAndCleanup:YES];
    [_hero release];
    [super dealloc];
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
        int tileX = [[[objDic objectForKey:@"position"] objectForKey:@"x"] intValue];
        int tileY = [[[objDic objectForKey:@"position"] objectForKey:@"y"] intValue];_hero.tileX = tileX;
        tile.tileY = tileY;
        tile.x = TILE_SIZE * tileX + tile.tileW/2;
        tile.y = TILE_SIZE * tileY + tile.tileH/2;
        tile.position = ccp(tile.x, tile.y);
        [self addChild:tile];
        [_myItems addObject:tile];
    }
    
    // read hero position
    NSDictionary *heroDic = [dic objectForKey:@"hero"];
    int tileX = [[[heroDic objectForKey:@"position"] objectForKey:@"x"] intValue];
    int tileY = [[[heroDic objectForKey:@"position"] objectForKey:@"y"] intValue];
    _hero = [[ECHero alloc] init];
    _hero.tileX = tileX;
    _hero.tileY = tileY;
    _hero.x = TILE_SIZE * tileX + _hero.tileW/2;
    _hero.y = TILE_SIZE * tileY + _hero.tileH/2;
    _hero.position = ccp(_hero.x, _hero.y);
    [self addChild:_hero];
}


- (void)fixUpdate:(ccTime)interval {
    
    // 刷新地图状态
    memset(_pixelMap, nil, sizeof(CCSprite *) * MAP_ROW * TILE_SIZE * MAP_COL * TILE_SIZE);
    for ( BaseTile* tile in _myItems ) {
        for ( int x = tile.position.x - tile.tileW/2; x < (tile.position.x + tile.tileW/2); x ++ ) {
            for ( int y = tile.position.y - tile.tileH/2; y < (tile.position.y + tile.tileH/2); y ++ ) {
                if (( x > MAP_COL * TILE_SIZE ) || ( x < 0 )) continue;
                if (( y > MAP_ROW * TILE_SIZE ) || ( y < 0 )) continue;
                _pixelMap[x][y] = tile;
            }
        }
    }
    
    // 刷新Hero
    [self moveHero:_hero x:1 y:0];
}


- (void)fpsUpdate:(ccTime)interval {
    
    // 刷新Hero
    [_hero fpsUpdate:interval];
    
    _hero.position = ccp(_hero.x, _hero.y);
}

- (BaseTile *)getMyCorners:(BaseTile *)tile x:(float)x y:(float)y {
    BaseTile *next = [[[BaseTile alloc] init] autorelease];
    next.downL = ccp(( tile.x + x - tile.tileW/2 ), ( tile.y + y - tile.tileH/2 ));
    next.downR = ccp(( tile.x + x + tile.tileW/2 ), ( tile.y + y - tile.tileH/2 ));
    next.upL =   ccp(( tile.x + x - tile.tileW/2 ), ( tile.y + y + tile.tileH/2 ));
    next.upR =   ccp(( tile.x + x + tile.tileW/2 ), ( tile.y + y + tile.tileH/2 ));
    return next;
}

- (void)moveHero:(ECHero *)hero x:(float)dirx y:(float)diry  {
    BaseTile *nextY = [self getMyCorners:hero x:0 y:diry * hero.speed];
    if ( diry == -1 ) {
        BaseTile * itemL = [self getItemAtPointX:nextY.downL.x Y:nextY.downL.y];
        BaseTile * itemR = [self getItemAtPointX:nextY.downR.x Y:nextY.downR.y];
        
        // 下方有墙
        if (( itemL.prototype == ECTileTypeWall ) || ( itemR.prototype == ECTileTypeWall )) {
            hero.y = hero.tileY * hero.tileH + hero.tileH / 2;
        }
        
        // 下方悬空
        else {
            hero.y -= hero.speed * diry;
        }
    }
    
    if ( diry == 1 ) {
        BaseTile * itemL = [self getItemAtPointX:nextY.upL.x Y:nextY.upL.y];
        BaseTile * itemR = [self getItemAtPointX:nextY.upR.x Y:nextY.upR.y];
        
        // 上方有墙
        if (( itemL.prototype == ECTileTypeWall ) || ( itemR.prototype == ECTileTypeWall )) {
            hero.y = (hero.tileY + 1) * hero.tileH + hero.tileH / 2;
        }
        
        // 上方悬空
        else {
            hero.y += hero.speed * diry;
        }
    }
    
    BaseTile *nextX = [self getMyCorners:hero x:dirx y:0];
    if ( dirx == -1 ) {
        BaseTile * itemU = [self getItemAtPointX:nextX.upL.x Y:nextY.upL.y];
        BaseTile * itemD = [self getItemAtPointX:nextX.downL.x Y:nextY.downL.y];
        
        // 左方有墙
        if (( itemU.prototype == ECTileTypeWall ) || ( itemD.prototype == ECTileTypeWall )) {
            hero.x = hero.tileX * hero.tileW + hero.tileW / 2;
        }
        
        // 左方道路
        else {
            hero.x -= hero.speed * dirx;
        }
    }
    
    if ( dirx == 1 ) {
        BaseTile * itemU = [self getItemAtPointX:nextX.upR.x Y:nextY.upR.y];
        BaseTile * itemD = [self getItemAtPointX:nextX.downR.x Y:nextY.downR.y];
        // 右方有墙
        if (( itemU.prototype == ECTileTypeWall ) || ( itemD.prototype == ECTileTypeWall )) {
            hero.x = (hero.tileX + 1) * hero.tileW + hero.tileW / 2;
        }
        
        // 右方道路
        else {
            hero.x += hero.speed * dirx;
        }
    }
}

// 获取覆盖某坐标的Obj
- (BaseTile *)getItemAtPointX:(int)x Y:(int)y {
    // 越界
    if (( x < 0 ) || ( x >= MAP_COL*TILE_SIZE)) return [ECTileWall node];
    if (( y < 0 ) || ( y >= MAP_ROW*TILE_SIZE)) return [ECTileWall node];
    
    return (BaseTile *)_pixelMap[x][y];
}



// 检查Hero脚下地图状态, 不可乱序
- (void)checkStatus {
}

@end





