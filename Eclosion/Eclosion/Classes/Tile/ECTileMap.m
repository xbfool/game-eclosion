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
        int x = [[[objDic objectForKey:@"position"] objectForKey:@"x"] intValue];
        int y = [[[objDic objectForKey:@"position"] objectForKey:@"y"] intValue];
        tile.position = ccp(TILE_SIZE * x, TILE_SIZE * y);
        [self addChild:tile];
        [_myItems addObject:tile];
    }
    
    // read hero position
    NSDictionary *heroDic = [dic objectForKey:@"hero"];
    int x = [[[heroDic objectForKey:@"position"] objectForKey:@"x"] intValue];
    int y = [[[heroDic objectForKey:@"position"] objectForKey:@"y"] intValue];
    _hero = [[ECHero alloc] init];
    _hero.position = ccp(TILE_SIZE * x, TILE_SIZE * y);
    _hero.speed = 5;
    [self addChild:_hero];
}

- (void)run {
    [_hero run];
}

- (void)step:(ccTime)interval {
    // 刷新地图状态
    memset(_pixelMap, nil, sizeof(CCSprite *) * MAP_ROW * TILE_SIZE * MAP_COL * TILE_SIZE);
    for ( BaseTile* tile in _myItems ) {
        for ( int x = tile.position.x; x < (tile.position.x + tile.contentSize.width); x ++ ) {
            for ( int y = tile.position.y; y < (tile.position.y + tile.contentSize.height); y ++ ) {
                if (( x > MAP_COL * TILE_SIZE ) || ( x < 0 )) continue;
                if (( y > MAP_ROW * TILE_SIZE ) || ( y < 0 )) continue;
                _pixelMap[x][y] = tile;
            }
        }
    }
    
    // 刷新各元素状态
    [self checkStatus];
}

// 获取覆盖某坐标的Obj
- (BaseTile *)getItemAtPointX:(int)x Y:(int)y {
    // 越界
    if (( x < 0 ) || ( x >= MAP_COL*TILE_SIZE)) return [ECTileWall node];
    if (( y < 0 ) || ( y >= MAP_ROW*TILE_SIZE)) return [ECTileWall node];
    
    return (BaseTile *)_pixelMap[x][y];
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

// 获取道具移动方向上最远可达地点, 返回步数(有个bug, 碰撞时没考虑宽度, 但暂不需要)
- (int)getDistination:(CCSprite *)tile direction:(ECDirection)direction {
    // 坐标增量
    CGPoint vector = ccp(0,0);
    CGPoint position = tile.position;
    switch (direction) {
        case ECDirectionRight:
            vector = ccp (1, 0);
            position = ccp (tile.position.x + tile.contentSize.width, tile.position.y);
            break;
        case ECDirectionLeft:
            vector = ccp (-1, 0);
            position = ccp (tile.position.x - ECTileSize, tile.position.y);
            break;
        case ECDirectionUp:
            vector = ccp (0, 1);
            position = ccp (tile.position.x, tile.position.y + ECTileSize);
            break;
        case ECDirectionDown:
            vector = ccp (0, -1);
            position = ccp (tile.position.x, tile.position.y - tile.contentSize.height);
            break;
        default:
            break;
    }
    
    BaseTile *next = nil;
    int step = 0;
    while ( next == nil ) {
        next = [self getItemAtPointX:position.x Y:position.y];
        if ( next == nil ) {
            position = ccp(position.x + vector.x * ECTileSize, position.y + vector.y * ECTileSize);
            step ++;
        } else {
            return step;
        }
    }
    return step;
}

// 获取hero下一步方向
- (ECDirection)getHeroNextDirection:(ECHero *)hero {
    
    // 获取相邻边界坐标
    CGPoint position = ccp((int)(hero.position.x + 0.5), (int)(hero.position.y + 0.5));
    switch (hero.direction) {
        case ECDirectionRight:
            position = ccp (position.x + ECTileSize, position.y);
            break;
        case ECDirectionLeft:
            position = ccp (position.x - 1, position.y);
            break;
        case ECDirectionUp:
            position = ccp (position.x, position.y + ECTileSize);
            break;
        case ECDirectionDown:
            position = ccp (position.x, position.y - 1);
            break;
        default:
            break;
    }
    
    BaseTile *next = [self getItemAtPointX:position.x Y:position.y];
    BaseTile *bottom = [self getItemAtPointX:(int)(hero.position.x + 0.5)
                                           Y:(int)(hero.position.y + 0.5) - 1];
    ECDirection nextDirection = hero.direction;
    
    // 底部悬空, 下坠
    if (( bottom == nil ) || (( bottom != nil ) && ( bottom.prototype != TileMapWall ))) {
        if ( hero.direction != ECDirectionDown ) {
            nextDirection = ECDirectionDown;
        }
    }
    
    else {
        // 底部有道路, 默认向右行进
        if ( bottom.prototype == TileMapWall ) {
            if (( hero.direction != ECDirectionRight )&&(hero.direction != ECDirectionLeft )) {
                nextDirection = ECDirectionRight;
            }
        }
        
        // 前方有墙, 转向
        if ((( hero.direction == ECDirectionRight )||(hero.direction == ECDirectionLeft ))&&
            ( next != nil ) && ( next.prototype == TileMapWall )) {
            if ( hero.direction == ECDirectionRight ) {
                nextDirection = ECDirectionLeft;
            } else if ( hero.direction == ECDirectionLeft ) {
                nextDirection = ECDirectionRight;
            }
        }
    }
    return nextDirection;
}

// 获取hero移动方向上最远可达的点, 返回步数
- (int)getHeroDistination:(ECHero *)hero {
    
    // 计算步数
    CGPoint vector = [self getVectorForDirection:hero.direction];
    CGPoint nextPosition = ccp((int)(hero.position.x + 0.5) + vector.x * ECTileSize,
                               (int)(hero.position.y + 0.5) + vector.y * ECTileSize);
    BaseTile *next = nil;
    BaseTile *bottom = nil;
    int step = 1;
    
    while ( 1 ) {
        next = [self getItemAtPointX:nextPosition.x Y:nextPosition.y];
        switch (hero.direction) {
            case ECDirectionDown:
                // 落地
                if (( next != nil ) && ( next.prototype == TileMapWall )) {
                    return step;
                }
                break;
            case ECDirectionLeft:
            case ECDirectionRight:
                bottom = [self getItemAtPointX:nextPosition.x - vector.x * ECTileSize Y:nextPosition.y - 1];
                // 悬空
                if (( bottom == nil ) || (( bottom != nil ) && ( bottom.prototype != TileMapWall ))) {
                    return step;
                }
                // 撞墙
                if (( next != nil ) && ( next.prototype == TileMapWall )) {
                    return step;
                }
                break;
            default:
                break;
        }
        
        nextPosition = ccp(nextPosition.x + vector.x * ECTileSize, nextPosition.y + vector.y * ECTileSize);
        step ++;
    }
    return step;
}


// 传递力
- (void)passForce:(BaseTile *)tile {
    /*
    BaseTile *next = [self getNextForceItem:tile];
    if ( next != nil ) {
        // 传递
        next.forceDirection = tile.forceDirection;
        // 递归
        [self passForce:next];
    }
     */
}

// 检查是否需要移动道具
- (void)checkItemForce {
    for ( BaseTile* tile in _myItems ) {
        if ( tile.forceDirection != ECDirectionNone ) {
            // 将力传递给当前受力道具相邻的道具.
            //[self passForce:tile];
            
            // 检查道具在受力方向上可移动的距离
            int step = [self getDistination:tile direction:tile.forceDirection];
    
            // 移动道具
            [tile pushByStep:step];
            
            tile.forceDirection = ECDirectionNone;
        }
    }
}

// 检查Hero脚下地图状态, 不可乱序
- (void)checkStatus {
    [self checkEnd];            // 检查是否触发了结局
    [self checkItemForce];      // 检查是否需要移动道具
    [self checkGettingItem];    // 检查是否碰触道具
    [self updateHeroStatus];       // 检查地形
}

// 检查是否触发了结局
- (void)checkEnd {
    // 陷阱
    
    // 成功
}   

// 检查是否碰触道具
- (void)checkGettingItem {
    
}

// 更新Hero移动状态
- (void)updateHeroStatus {
    // 检查hero是否需转向
    ECDirection nextDirection = [self getHeroNextDirection:_hero];
    if (( _hero.direction != nextDirection ) || ( ! _hero.running )) {
        _hero.direction = nextDirection;
        int step = [self getHeroDistination:_hero];
        [_hero runByStep:step];
    }
}

@end





