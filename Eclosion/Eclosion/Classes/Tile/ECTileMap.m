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
    _hero.direction = ECDirectionRight;
    _hero.speed = 5;
    [self addChild:_hero];
}

- (void)run {
    [_hero run];
}

- (void)step:(ccTime)interval {
    // 刷新地图状态
    memset(_pixelMap, 0, sizeof(int) * MAP_ROW * TILE_SIZE * MAP_COL * TILE_SIZE);
    for ( BaseTile* tile in _myItems ) {
        for ( int x = tile.position.x; x < (tile.position.x + tile.contentSize.width); x ++ ) {
            for ( int y = tile.position.y; y < (tile.position.y + tile.contentSize.height); y ++ ) {
                if (( x > MAP_COL * TILE_SIZE ) || ( x < 0 )) continue;
                if (( y > MAP_ROW * TILE_SIZE ) || ( y < 0 )) continue;
                _pixelMap[x][y] = tile.prototype;
            }
        }
    }
    
    // 刷新Hero状态
    [self checkStatus];
    [_hero step:interval];
}

- (TileMaptype)getPixelStatusAtX:(int)x Y:(int)y{
    if (( x < 0 ) || ( x >= MAP_COL*TILE_SIZE)) return TileMapWall;
    if (( y < 0 ) || ( y >= MAP_ROW*TILE_SIZE)) return TileMapWall;
    return _pixelMap[x][y];
}

// 获取覆盖这个坐标的obj
- (BaseTile *)getItemAtPointX:(int)x Y:(int)y {
    CGPoint location = CGPointMake(x, y);
    for ( BaseTile* tile in _myItems ) {
        CGRect myRect = CGRectMake(tile.position.x, tile.position.y, tile.contentSize.width, tile.contentSize.height);
         if ( CGRectContainsPoint(myRect, location) ) {
             return tile;
         }
     }
    return nil;
}

// 检查地图, 不可乱序
- (void)checkStatus {
    [self checkEnd];        // 检查是否触发了结局
    [self checkItemForce];  // 检查是否需要移动道具
    [self checkItem];       // 检查是否碰触道具
    [self checkMove];       // 检查地形
}

// 检查是否触发了结局
- (void)checkEnd {
    // 陷阱
    
    // 成功
}   

// 检查是否碰触道具
- (void)checkItem {
    
}

// 检查是否需要移动道具
- (void)checkItemForce {
    for ( BaseTile* tile in _myItems ) {
        if ( tile.forceDirection != ECDirectionNone ) {
            // 将力传递给当前受力道具相邻的道具.
            [self passForce:tile];
            
            // 检查道具在受力方向上是否可移动
            if( [self checkItemMovebal:tile] ) {
                // 移动道具
                [tile pushByForce];
            }
            
            tile.forceDirection = ECDirectionNone;
        }
    }
}

// 检查道具在受力方向上是否可移动
- (BOOL)checkItemMovebal:(BaseTile *)tile {
    BaseTile *next = [self getNextItem:tile];
    if ( next == nil ) {
        return YES;
    }
    if ( [next isKindOfClass:[ECTileRoad class]] ) {
        return YES;
    }
    return NO;
}

// 传递力
- (void)passForce:(BaseTile *)tile {
    BaseTile *next = [self getNextItem:tile];
    if ( next != nil ) {
        // 传递
        next.forceDirection = tile.forceDirection;
        // 递归
        [self passForce:next]; 
    }
}

// 获取受力方向上相邻的Obj
- (BaseTile *)getNextItem:(BaseTile *)tile {
    int leftX = tile.position.x - 1;
    int rightX = tile.position.x + tile.contentSize.width;
    int belowY = tile.position.y - 1;
    int beyoundY = tile.position.y + tile.contentSize.height;
    int tileWidth = ( tile.contentSize.width / ECTileSize );
    int tileHeight = ( tile.contentSize.height / ECTileSize );
    
    int i = 0;
    BaseTile *next = nil;
    
    switch (tile.forceDirection) {
        case ECDirectionRight:
            for ( i = 0; i < tileHeight; i++ ){
                next = [self getItemAtPointX:rightX Y:tile.position.y + i * ECTileSize];
                if ( next != nil ) break;
            }
            break;
        case ECDirectionLeft:
            for ( i = 0; i < tileHeight; i++ ){
                next = [self getItemAtPointX:leftX Y:tile.position.y + i * ECTileSize];
                if ( next != nil ) break;
            }
            break;
        case ECDirectionUp:
            for ( i = 0; i < tileWidth; i++ ){
                next = [self getItemAtPointX:tile.position.x + i * ECTileSize Y:beyoundY];
                if ( next != nil ) break;
            }
            break;
        case ECDirectionDown:
            for ( i = 0; i < tileWidth; i++ ){
                next = [self getItemAtPointX:tile.position.x + i * ECTileSize Y:belowY];
                if ( next != nil ) break;
            }
            break;
        default:
            break;
    }
    return next;
}

// 检查英雄移动地形
- (void)checkMove {
    int headX = _hero.position.x + ((_hero.direction == ECDirectionRight) ? _hero.contentSize.width - 1 : 0);
    int tailX = _hero.position.x + ((_hero.direction == ECDirectionRight) ? 0 : _hero.contentSize.width - 1);
    int frontX = headX + ((_hero.direction == ECDirectionRight) ? 1 : (-1)); // 有bug, 应检查一条线
    int bottomY = _hero.position.y;
    int belowY = bottomY - 1;
    
    // 底部悬空, 下坠
    //NSLog(@"bottom:%d",[self getPixelStatusAtX:tailX Y:belowY]);
    if ( [self getPixelStatusAtX:tailX Y:belowY] == TileMapWalkable ) {
        if ( _hero.direction != ECDirectionDown ) {
            _hero.direction = ECDirectionDown;
        }
        return;
    }
    
    // 底部有道路, 按原路行进
    if ( [self getPixelStatusAtX:tailX Y:belowY] == TileMapWall ) {
        if (( _hero.direction == ECDirectionRight )||(_hero.direction == ECDirectionLeft )) {
            
        } else {
            _hero.direction = ECDirectionRight;
        }
        //return;
    }
    
    // 前方有墙, 转向
    //NSLog(@"frount:%d",[self getPixelStatusAtX:frontX Y:bottomY]);
    if ( [self getPixelStatusAtX:frontX Y:(bottomY+2)] == TileMapWall) { // 底部留2px误差
        if ( _hero.direction == ECDirectionRight ) {
            _hero.direction = ECDirectionLeft;
        } else if ( _hero.direction == ECDirectionLeft ) {
            _hero.direction = ECDirectionRight;
        }
        return;
    }
}

@end





