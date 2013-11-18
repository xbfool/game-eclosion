//
//  ECTileMap.m
//  Eclosion
//
//  Created by Tsubasa on 13-10-2.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ECTileMap.h"
#import "ECLevelManager.h"
#import "ECTile.h"
#import "ECHero.h"
#import "ECClearScene.h"

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
    }
    return self;
}

- (void)dealloc {
    [_tileMatrix release];
    [_myItems release];
    //[_hero removeFromParentAndCleanup:YES];
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
        BaseTile *tile = [ECTileUtil getTileByName:[objDic objectForKey:@"type"]];
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
    _hero.direction = ECDirectionRight;
    [self addChild:_hero];
}


- (void)fixUpdate:(ccTime)interval {
    // 刷新Item
    for ( BaseTile* item in _myItems ) {
        if ( item.forceDirection != ECDirectionNone ) {
            [item fixUpdate:interval];
            CGPoint vector = [self getVectorForDirection:item.forceDirection];
            // -- 移动Item
            [self moveItem:item x:vector.x y:vector.y];
            // -- 转向Item
            [self turnItem:item x:vector.x y:vector.y];
        }
    }
    
    // 拓印Tiles
    memset(_pixelMap, nil, sizeof(CCSprite *) * MAP_ROW * TILE_SIZE * MAP_COL * TILE_SIZE);
    memset(_pixelItemMap, nil, sizeof(CCSprite *) * MAP_ROW * TILE_SIZE * MAP_COL * TILE_SIZE);
    for ( BaseTile* tile in _myItems ) {
        for ( int x = tile.position.x - tile.tileW/2; x < (tile.position.x + tile.tileW/2); x ++ ) {
            for ( int y = tile.position.y - tile.tileH/2; y < (tile.position.y + tile.tileH/2); y ++ ) {
                if (( x >= MAP_COL * TILE_SIZE ) || ( x < 0 )) continue;
                if (( y >= MAP_ROW * TILE_SIZE ) || ( y < 0 )) continue;
                if ( tile.walkball ) {
                    _pixelItemMap[x][y] = tile;
                } else {
                    _pixelMap[x][y] = tile;
                }
            }
        }
    }
    
    // 刷新Hero
    [_hero fixUpdate:interval];
    
    // -- 移动Hero
    if ( _hero.direction == ECDirectionDown ) {
        _hero.speed = 3;
    } else {
        _hero.speed = 1;
    }
    CGPoint vector = [self getVectorForDirection:_hero.direction];
    [self moveHero:_hero x:vector.x y:vector.y];
    
    // -- 转向Hero
    [self turnHero:_hero x:vector.x y:vector.y];
    
    // -- 推Hero
    [self checkMovingTileAroundHero:_hero];
    
    // -- 检查Hero脚下道具
    [self gettingItemsOfHero:_hero];
    
    // 拓印Hero
    for ( int x = _hero.position.x - _hero.tileW/2; x < (_hero.position.x + _hero.tileW/2); x ++ ) {
        for ( int y = _hero.position.y - _hero.tileH/2; y < (_hero.position.y + _hero.tileH/2); y ++ ) {
            if (( x >= MAP_COL * TILE_SIZE ) || ( x < 0 )) continue;
            if (( y >= MAP_ROW * TILE_SIZE ) || ( y < 0 )) continue;
            _pixelMap[x][y] = _hero;
        }
    }
}


- (void)fpsUpdate:(ccTime)interval {
    
    // 刷新Hero
    [_hero fpsUpdate:interval];
    _hero.position = ccp(_hero.x, _hero.y);
    
    // 刷新Item
    for ( BaseTile* item in _myItems ) {
        [item fpsUpdate:interval];
        item.position = ccp(item.x, item.y);
    }
}

// 获取移动方向单位向量
- (CGPoint)getVectorForDirection:(ECDirection)direction {
    CGPoint vector = ccp(0,0);
    switch (direction) {
        case ECDirectionRight:
            vector = ccp (1, 0);
            break;
        case ECDirectionLeft:
            vector = ccp (-1, 0);
            break;
        case ECDirectionUp:
            vector = ccp (0, 1);
            break;
        case ECDirectionDown:
            vector = ccp (0, -1);
            break;
        default:
            break;
    }
    return vector;
}

- (BaseTile *)getMyCorners:(BaseTile *)tile x:(float)x y:(float)y {
    BaseTile *next = [[[BaseTile alloc] init] autorelease];
    next.downL = ccp(( tile.x + x - tile.tileW/2 ), ( tile.y + y - tile.tileH/2 ));
    next.downR = ccp(( tile.x + x + tile.tileW/2 - 1 ), ( tile.y + y - tile.tileH/2 ));
    next.upL =   ccp(( tile.x + x - tile.tileW/2 ), ( tile.y + y + tile.tileH/2 - 1 ));
    next.upR =   ccp(( tile.x + x + tile.tileW/2 - 1 ), ( tile.y + y + tile.tileH/2 - 1 ));
    return next;
}

// 获取覆盖某坐标的Obj
- (BaseTile *)getItemAtPointX:(int)x Y:(int)y {
    // 越界
    if (( x < 0 ) || ( x >= MAP_COL*TILE_SIZE)) return [ECTileWall node];
    if (( y < 0 ) || ( y >= MAP_ROW*TILE_SIZE)) return [ECTileWall node];
    
    BaseTile * item = (BaseTile *)_pixelItemMap[x][y];
    if ( item == nil ) {
        item = [ECTileBlank node];
    }
    return item;
}

// 获取覆盖某坐标的Obj
- (BaseTile *)getBlockAtPointX:(int)x Y:(int)y {
    // 越界
    if (( x < 0 ) || ( x >= MAP_COL*TILE_SIZE)) return [ECTileWall node];
    if (( y < 0 ) || ( y >= MAP_ROW*TILE_SIZE)) return [ECTileWall node];
    
    BaseTile * item = (BaseTile *)_pixelMap[x][y];
    if ( item == nil ) {
        item = [ECTileBlank node];
    }
    
    return item;
}



- (void)turnHero:(ECHero *)hero x:(float)dirx y:(float)diry  {
    BaseTile * nextY = [self getMyCorners:hero x:0 y:-1];
    BaseTile * itemL = [self getBlockAtPointX:nextY.downL.x Y:nextY.downL.y];
    BaseTile * itemR = [self getBlockAtPointX:nextY.downR.x Y:nextY.downR.y];
    
    // 下方有墙
    if (( itemL.walkball == NO ) || ( itemR.walkball == NO )) {
        if (( hero.direction != ECDirectionRight ) && (hero.direction != ECDirectionLeft )
            && ( itemL.forceDirection == ECDirectionNone) && ( itemR.forceDirection == ECDirectionNone)) {
            hero.direction = ECDirectionRight;
        }
    }
    // 下方悬空
    else {
        if ( hero.direction != ECDirectionDown ) {
            hero.direction = ECDirectionDown;
            return; // 悬空优先级最高.
        }
    }
    
    BaseTile *leftX = [self getMyCorners:hero x:-1 y:0];
    BaseTile *rightX = [self getMyCorners:hero x:1 y:0];
    
    // 左方有墙
    BOOL leftWall = NO; // 用于判断左右是否同时有墙
    BaseTile * itemLU = [self getBlockAtPointX:leftX.upL.x Y:leftX.upL.y];
    BaseTile * itemLD = [self getBlockAtPointX:leftX.downL.x Y:leftX.downL.y];
    if (( itemLU.walkball == NO ) || ( itemLD.walkball == NO )) {
        if ( hero.direction == ECDirectionLeft &&
            ( itemLU.forceDirection == ECDirectionNone) && ( itemLD.forceDirection == ECDirectionNone)) {
            hero.direction = ECDirectionRight;
        }
        leftWall = YES;
    }
    
    // 右方有墙
    BaseTile * itemRU = [self getBlockAtPointX:rightX.upR.x Y:rightX.upR.y];
    BaseTile * itemRD = [self getBlockAtPointX:rightX.downR.x Y:rightX.downR.y];
    if (( itemRU.walkball == NO ) || ( itemRD.walkball == NO )) {
        if ( ! leftWall && hero.direction == ECDirectionRight &&
            ( itemRU.forceDirection == ECDirectionNone) && ( itemRD.forceDirection == ECDirectionNone)) {
            hero.direction = ECDirectionLeft;
        }
    }
}

- (void)moveHero:(ECHero *)hero x:(float)dirx y:(float)diry  {
    BaseTile *nextY = [self getMyCorners:hero x:0 y:diry * hero.speed];
    if ( diry == -1 ) {
        BaseTile * itemL = [self getBlockAtPointX:nextY.downL.x Y:nextY.downL.y];
        BaseTile * itemR = [self getBlockAtPointX:nextY.downR.x Y:nextY.downR.y];
        
        // 下方有墙
        if (( itemL.walkball == NO ) || ( itemR.walkball == NO )) {
            
            // MovingTile
            BaseTile * wall = (itemL.walkball == NO) ? itemL : itemR;
            if ( wall.forceDirection == ECDirectionUp ) {
                hero.y = wall.y + wall.tileH / 2 + hero.tileH / 2;
            }
            
            // 墙
            else {
                hero.y = hero.tileY * hero.tileH + hero.tileH / 2;
            }
        }
        
        // 下方悬空
        else {
            hero.y += hero.speed * diry;
        }
    }
    
    if ( diry == 1 ) {
        BaseTile * itemL = [self getBlockAtPointX:nextY.upL.x Y:nextY.upL.y];
        BaseTile * itemR = [self getBlockAtPointX:nextY.upR.x Y:nextY.upR.y];
        
        // 上方有墙
        if (( itemL.walkball == NO ) || ( itemR.walkball == NO )) {
            
            // MovingTile
            BaseTile * wall = (itemL.walkball == NO) ? itemL : itemR;
            if ( wall.forceDirection == ECDirectionDown ) {
                hero.y = wall.y - wall.tileH / 2 - hero.tileH / 2;
            }
            
            // 墙
            else {
                hero.y = MIN((hero.tileY), (MAP_ROW - 1)) * hero.tileH + hero.tileH / 2;
            }
        }
        
        // 上方悬空
        else {
            hero.y += hero.speed * diry;
        }
    }
    
    BaseTile *nextX = [self getMyCorners:hero x: dirx * hero.speed y:0];
    if ( dirx == -1 ) {
        BaseTile * itemU = [self getBlockAtPointX:nextX.upL.x Y:nextX.upL.y];
        BaseTile * itemD = [self getBlockAtPointX:nextX.downL.x Y:nextX.downL.y];
        
        // 左方有墙
        if (( itemU.walkball == NO ) || ( itemD.walkball == NO )) {
            
            // MovingTile
            BaseTile * wall = (itemU.walkball == NO) ? itemU : itemD;
            if ( wall.forceDirection == ECDirectionRight ) {
                hero.x = wall.x + wall.tileW / 2 + hero.tileW / 2;
            }
            
            // 墙
            else {
                hero.x = hero.tileX * hero.tileW + hero.tileW / 2;
            }
        }
        
        // 左方道路
        else {
            hero.x += hero.speed * dirx;
        }
    }
    
    if ( dirx == 1 ) {
        BaseTile * itemU = [self getBlockAtPointX:nextX.upR.x Y:nextX.upR.y];
        BaseTile * itemD = [self getBlockAtPointX:nextX.downR.x Y:nextX.downR.y];
        // 右方有墙
        if (( itemU.walkball == NO ) || ( itemD.walkball == NO )) {
            
            // MovingTile
            BaseTile * wall = (itemU.walkball == NO) ? itemU : itemD;
            if ( wall.forceDirection == ECDirectionLeft ) {
                hero.x = wall.x - wall.tileW / 2 - hero.tileW / 2;
            }
            
            // 墙
            else {
                hero.x = MIN((hero.tileX),(MAP_COL - 1) ) * hero.tileW + hero.tileW / 2;
            }
        }
        
        // 右方道路
        else {
            hero.x += hero.speed * dirx;
        }
    }
}

// 检查四周的MovingTile
- (void)checkMovingTileAroundHero:(ECHero *)hero {
    BaseTile *nextX, *nextY, *itemL, *itemR, *itemU, *itemD;
    
    // ====== Down ======
    nextY = [self getMyCorners:hero x:0 y: -1];
    itemL = [self getBlockAtPointX:nextY.downL.x Y:nextY.downL.y];
    itemR = [self getBlockAtPointX:nextY.downR.x Y:nextY.downR.y];
    
    // MovingTile
    if (( itemL.walkball == NO ) || ( itemR.walkball == NO )) {
        BaseTile * wall = (itemL.walkball == NO) ? itemL : itemR;
        if ( wall.forceDirection == ECDirectionUp ) {
            hero.y = wall.y + wall.tileH / 2 + hero.tileH / 2;
        }
    }
    
    //  ====== Up ====== 
    nextY = [self getMyCorners:hero x:0 y: 1];
    itemL = [self getBlockAtPointX:nextY.upL.x Y:nextY.upL.y];
    itemR = [self getBlockAtPointX:nextY.upR.x Y:nextY.upR.y];
    
    // MovingTile
    if (( itemL.walkball == NO ) || ( itemR.walkball == NO )) {
        BaseTile * wall = (itemL.walkball == NO) ? itemL : itemR;
        if ( wall.forceDirection == ECDirectionDown ) {
            hero.y = wall.y - wall.tileH / 2 - hero.tileH / 2;
        }
    }
    
    // ====== Left ======
    nextX = [self getMyCorners:hero x: -1 y:0];
    itemU = [self getBlockAtPointX:nextX.upL.x Y:nextX.upL.y];
    itemD = [self getBlockAtPointX:nextX.downL.x Y:nextX.downL.y];
    
    // MovingTile
    if (( itemU.walkball == NO ) || ( itemD.walkball == NO )) {
        BaseTile * wall = (itemU.walkball == NO) ? itemU : itemD;
        if ( wall.forceDirection == ECDirectionRight ) {
            hero.x = wall.x + wall.tileW / 2 + hero.tileW / 2;
        }
    }
    
    // ====== Right ======
    nextX = [self getMyCorners:hero x: 1 y:0];
    itemU = [self getBlockAtPointX:nextX.upR.x Y:nextX.upR.y];
    itemD = [self getBlockAtPointX:nextX.downR.x Y:nextX.downR.y];

    // MovingTile
    if (( itemU.walkball == NO ) || ( itemD.walkball == NO )) {
        BaseTile * wall = (itemU.walkball == NO) ? itemU : itemD;
        if ( wall.forceDirection == ECDirectionLeft ) {
            hero.x = wall.x - wall.tileW / 2 - hero.tileW / 2;
        }
    }
}

- (void)moveItem:(BaseTile *)item x:(float)dirx y:(float)diry  {
    BaseTile *nextY = [self getMyCorners:item x:0 y:diry * item.speed];
    if ( diry == -1 ) {
        BaseTile * itemL = [self getBlockAtPointX:nextY.downL.x Y:nextY.downL.y];
        BaseTile * itemR = [self getBlockAtPointX:nextY.downR.x Y:nextY.downR.y];
        
        // 下方有墙
        if (( itemL.walkball == NO ) || ( itemR.walkball == NO )) {
            item.y = item.tileY * ECTileSize + ECTileSize / 2;
        }
        
        // 下方Hero
        else if (( itemL.prototype == TileMapHero ) || ( itemR.prototype == TileMapHero )) {
            BaseTile * heroY = [self getMyCorners:_hero x:dirx y:diry];
            BaseTile * heroDL = [self getBlockAtPointX:heroY.downL.x Y:heroY.downL.y];
            BaseTile * heroDR = [self getBlockAtPointX:heroY.downR.x Y:heroY.downR.y];
            
            // 贴墙的Hero
            if (( heroDL.walkball == NO ) || ( heroDR.walkball == NO )) {
                item.y = item.tileY * ECTileSize + ECTileSize / 2;
            }
            else {
                item.y += item.speed * diry;
            }
        }
        
        // 下方悬空
        else {
            item.y += item.speed * diry;
        }
    }
    
    if ( diry == 1 ) {
        BaseTile * itemL = [self getBlockAtPointX:nextY.upL.x Y:nextY.upL.y];
        BaseTile * itemR = [self getBlockAtPointX:nextY.upR.x Y:nextY.upR.y];
        
        // 上方有墙
        if (( itemL.walkball == NO ) || ( itemR.walkball == NO )) {
            item.y = item.tileY * ECTileSize + ECTileSize / 2;
        }
        
        // 上方Hero
        else if (( itemL.prototype == TileMapHero ) || ( itemR.prototype == TileMapHero )) {
            BaseTile * heroY = [self getMyCorners:_hero x:dirx y:diry];
            BaseTile * heroUL = [self getBlockAtPointX:heroY.upL.x Y:heroY.upL.y];
            BaseTile * heroUR = [self getBlockAtPointX:heroY.upR.x Y:heroY.upR.y];
            
            // 贴墙的Hero
            if (( heroUL.walkball == NO ) || ( heroUR.walkball == NO )) {
                item.y = item.tileY * ECTileSize + ECTileSize / 2;
            }
            else {
                item.y += item.speed * diry;
            }
        }
        
        // 上方悬空
        else {
            item.y += item.speed * diry;
        }
    }
    
    BaseTile *nextX = [self getMyCorners:item x:dirx * item.speed y:0];
    if ( dirx == -1 ) {
        BaseTile * itemU = [self getBlockAtPointX:nextX.upL.x Y:nextX.upL.y];
        BaseTile * itemD = [self getBlockAtPointX:nextX.downL.x Y:nextX.downL.y];
        
        // 左方有墙
        if (( itemU.walkball == NO ) || ( itemD.walkball == NO )) {
            item.x = item.tileX * ECTileSize + ECTileSize / 2;
        }
        
        // 左方是Hero
        else if (( itemU.prototype == TileMapHero ) || ( itemD.prototype == TileMapHero )) {
            BaseTile * heroX = [self getMyCorners:_hero x:dirx y:diry];
            BaseTile * heroLU = [self getBlockAtPointX:heroX.upL.x Y:heroX.upL.y];
            BaseTile * heroLD = [self getBlockAtPointX:heroX.downL.x Y:heroX.downL.y];
            
            // 贴墙的Hero
            if (( heroLU.walkball == NO ) || ( heroLD.walkball == NO )) {
                item.x = item.tileX * ECTileSize + ECTileSize / 2;
            }
            else {
                item.x += item.speed * dirx;
            }
        }
        
        // 左方道路
        else {
            item.x += item.speed * dirx;
        }
    }
    
    if ( dirx == 1 ) {
        BaseTile * itemU = [self getBlockAtPointX:nextX.upR.x Y:nextX.upR.y];
        BaseTile * itemD = [self getBlockAtPointX:nextX.downR.x Y:nextX.downR.y];
        // 右方有墙
        if (( itemU.walkball == NO ) || ( itemD.walkball == NO )) {
            item.x = item.tileX * ECTileSize + ECTileSize / 2;
        }
        
        // 右方Hero
        else if (( itemU.prototype == TileMapHero ) || ( itemD.prototype == TileMapHero )) {
            BaseTile * heroX = [self getMyCorners:_hero x:dirx y:diry];
            BaseTile * heroRU = [self getBlockAtPointX:heroX.upR.x Y:heroX.upR.y];
            BaseTile * heroRD = [self getBlockAtPointX:heroX.downR.x Y:heroX.downR.y];
            
            // 贴墙的Hero
            if (( heroRU.walkball == NO ) || ( heroRD.walkball == NO )) {
                item.x = item.tileX * ECTileSize + ECTileSize / 2;
            }
            else {
                item.x += item.speed * dirx;
            }
        }
        
        // 右方道路
        else {
            item.x += item.speed * dirx;
        }
    }
}

// 转向Item
- (void)turnItem:(BaseTile *)item x:(float)dirx y:(float)diry  {
    BaseTile * nextY = [self getMyCorners:item x:dirx y:diry];
    
    if ( diry == -1 ) {
        BaseTile * itemL = [self getBlockAtPointX:nextY.downL.x Y:nextY.downL.y];
        BaseTile * itemR = [self getBlockAtPointX:nextY.downR.x Y:nextY.downR.y];
        
        // 下方有墙
        if (( itemL.walkball == NO ) || ( itemR.walkball == NO )) {
            if ( item.forceDirection == ECDirectionDown ) {
                item.forceDirection = ECDirectionNone;
            }
        }
        
        // 下方是贴墙的Hero
        if (( itemL.prototype == TileMapHero ) || ( itemR.prototype == TileMapHero )) {
            BaseTile * heroY = [self getMyCorners:_hero x:dirx y:diry];
            BaseTile * heroDL = [self getBlockAtPointX:heroY.downL.x Y:heroY.downL.y];
            BaseTile * heroDR = [self getBlockAtPointX:heroY.downR.x Y:heroY.downR.y];
            if (( heroDL.walkball == NO ) || ( heroDR.walkball == NO )) {
                if ( item.forceDirection == ECDirectionDown ) {
                    item.forceDirection = ECDirectionNone;
                }
            }
        }
    }
    
    if ( diry == 1 ) {
        BaseTile * itemL = [self getBlockAtPointX:nextY.upL.x Y:nextY.upL.y];
        BaseTile * itemR = [self getBlockAtPointX:nextY.upR.x Y:nextY.upR.y];
        
        // 上方有墙
        if (( itemL.walkball == NO ) || ( itemR.walkball == NO )) {
            if ( item.forceDirection == ECDirectionUp ) {
                item.forceDirection = ECDirectionNone;
            }
        }
        
        // 上方是贴墙的Hero
        if (( itemL.prototype == TileMapHero ) || ( itemR.prototype == TileMapHero )) {
            BaseTile * heroY = [self getMyCorners:_hero x:dirx y:diry];
            BaseTile * heroUL = [self getBlockAtPointX:heroY.upL.x Y:heroY.upL.y];
            BaseTile * heroUR = [self getBlockAtPointX:heroY.upR.x Y:heroY.upR.y];
            if (( heroUL.walkball == NO ) || ( heroUR.walkball == NO )) {
                if ( item.forceDirection == ECDirectionUp ) {
                    item.forceDirection = ECDirectionNone;
                }
            }
        }
    }
    
    BaseTile *nextX = [self getMyCorners:item x:dirx y:0];
    if ( dirx == -1 ) {
        BaseTile * itemU = [self getBlockAtPointX:nextX.upL.x Y:nextX.upL.y];
        BaseTile * itemD = [self getBlockAtPointX:nextX.downL.x Y:nextX.downL.y];
        // 左方有墙
        if (( itemU.walkball == NO ) || ( itemD.walkball == NO )) {
            if ( item.forceDirection == ECDirectionLeft ) {
                item.forceDirection = ECDirectionNone;
            }
        }
        
        // 左方是贴墙的Hero
        if (( itemU.prototype == TileMapHero ) || ( itemD.prototype == TileMapHero )) {
            BaseTile * heroX = [self getMyCorners:_hero x:dirx y:diry];
            BaseTile * heroLU = [self getBlockAtPointX:heroX.upL.x Y:heroX.upL.y];
            BaseTile * heroLD = [self getBlockAtPointX:heroX.downL.x Y:heroX.downL.y];
            if (( heroLU.walkball == NO ) || ( heroLD.walkball == NO )) {
                if ( item.forceDirection == ECDirectionLeft ) {
                    item.forceDirection = ECDirectionNone;
                }
            }
        }
    }
    
    if ( dirx == 1 ) {
        BaseTile * itemU = [self getBlockAtPointX:nextX.upR.x Y:nextX.upR.y];
        BaseTile * itemD = [self getBlockAtPointX:nextX.downR.x Y:nextX.downR.y];
        // 右方有墙
        if (( itemU.walkball == NO ) || ( itemD.walkball == NO )) {
            if ( item.forceDirection == ECDirectionRight ) {
                item.forceDirection = ECDirectionNone;
            }
        }
        
        // 右方是贴墙的Hero
        if (( itemU.prototype == TileMapHero ) || ( itemD.prototype == TileMapHero )) {
            BaseTile * heroX = [self getMyCorners:_hero x:dirx y:diry];
            BaseTile * heroRU = [self getBlockAtPointX:heroX.upR.x Y:heroX.upR.y];
            BaseTile * heroRD = [self getBlockAtPointX:heroX.downR.x Y:heroX.downR.y];
            if (( heroRU.walkball == NO ) || ( heroRD.walkball == NO )) {
                if ( item.forceDirection == ECDirectionRight ) {
                    item.forceDirection = ECDirectionNone;
                }
            }
        }
    }
}

// 检查Hero脚下地图状态
- (void)gettingItemsOfHero:(ECHero *)hero {
    BaseTile *tile = [self getItemAtPointX:hero.position.x Y:hero.position.y];
    switch (tile.prototype) {
        case TileMapTrap:
            [self getItemTrap];
            break;
        case TileMapEnd:
            [self getItemFlower];
            break;
        case TileMapStar:
            [self getItemStar:tile];
            break;
        default:
            break;
    }
}

- (void)getItemStar:(BaseTile *)tile {
    if ( ! tile.visible ) return;
    _score ++;
    tile.visible = NO;
}

- (void)getItemTrap {
    [self.parent pauseSchedulerAndActions];
    [_hero trap];
    
    // Waiting animating
    double delayInSeconds = HERO_ANIM_DUR;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        CC_TRANSLATE_SCENE([ECClearScene scene]);
    });
}

- (void)getItemFlower {
    [self.parent pauseSchedulerAndActions];
    [_hero fly];
    
    ECLevel *level = [[ECLevelManager manager] getCurrentLevelData];
    level.cleared = YES;
    level.score = _score;
    [[ECLevelManager manager] save];
    
    // Waiting animating
    double delayInSeconds = HERO_ANIM_DUR;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        CC_TRANSLATE_SCENE([ECClearScene scene]);
    });
    
}


@end





