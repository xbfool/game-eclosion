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
        memset(_pixelMap, 0, sizeof(int) * MAP_ROW * TILE_SIZE * MAP_COL * TILE_SIZE);
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
    for ( CCSprite* obj in self.children ) {
        if ( [obj isKindOfClass:[BaseTile class]]) {
            BaseTile *tile = (BaseTile *)obj;
            for ( int x = tile.position.x; x < (tile.position.x + tile.contentSize.width); x ++ ) {
                for ( int y = tile.position.y; y < (tile.position.y + tile.contentSize.height); y ++ ) {
                    if (( x > MAP_COL * TILE_SIZE ) || ( x < 0 )) continue;
                    if (( y > MAP_ROW * TILE_SIZE ) || ( y < 0 )) continue;
                    _pixelMap[x][y] = tile.prototype;
                }
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

// 检查地图, 不可乱序
- (void)checkStatus {
    [self checkEnd];
    [self checkItem];
    [self checkMove];
}

// 检查是否触发了结局
- (void)checkEnd {
    // 陷阱
    
    // 成功
}   

// 检查是否碰触道具
- (void)checkItem {
    
}

// 检查地形
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
    if ( [self getPixelStatusAtX:frontX Y:bottomY] == TileMapWall) {
        if ( _hero.direction == ECDirectionRight ) {
            _hero.direction = ECDirectionLeft;
        } else if ( _hero.direction == ECDirectionLeft ) {
            _hero.direction = ECDirectionRight;
        }
        return;
    }
}

- (void)dealloc {
    [_tileMatrix release];
    [_hero removeFromParentAndCleanup:YES];
    [_hero release];
    [super dealloc];
}

@end





