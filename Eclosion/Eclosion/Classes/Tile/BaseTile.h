//
//  BaseTile.h
//  Eclosion
//
//  Created by Tsubasa on 13-10-2.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    TileMapWalkable = 0,
    TileMapWall     = 1,
    TileMapJump     = 2,
    TileMapLadder   = 3,
    TileMapTrap     = 4,
    TileMapEnd      = 5,
    TileMapHero     = 6,
    TileMapStar     = 7
}TileMaptype;

typedef enum {
    ECDirectionNone     = 0,
    ECDirectionRight    = 0x00000001,
    ECDirectionLeft     = 0x00000010,
    ECDirectionUp       = 0x00000100,
    ECDirectionDown     = 0x00001000,
} ECDirection;

@interface BaseTile : CCSprite<CCTargetedTouchDelegate> {
    CGPoint       _beginPoint;
    CCTexture2D* _texture;
    CCTexture2D* _highlightTexture;
}

@property(nonatomic, assign) int            tileW;
@property(nonatomic, assign) int            tileH;
@property(nonatomic, assign) int            tileX;
@property(nonatomic, assign) int            tileY;
@property(nonatomic, assign) float          x;  // middle
@property(nonatomic, assign) float          y;  // middle
@property(nonatomic, assign) CGPoint        downL;
@property(nonatomic, assign) CGPoint        downR;
@property(nonatomic, assign) CGPoint        upL;
@property(nonatomic, assign) CGPoint        upR;
@property(nonatomic, assign) float          speed; // speed 必须小于TILE_SIZE


@property(nonatomic, assign) TileMaptype    prototype;
@property(nonatomic, assign) ECDirection    forceDirection;
@property(nonatomic, assign) ECDirection    direction;
@property(nonatomic, assign) ECDirection    preDirection; // 下落之前的方向
@property(nonatomic, assign) BOOL           animating;
@property(nonatomic, assign) BOOL           movebal;
@property(nonatomic, assign) BOOL           walkball;
@property(nonatomic, assign) int            alowingDirection;

- (void)fpsUpdate:(ccTime)interval;
- (void)fixUpdate:(ccTime)interval;
- (void)setTextureFile:(NSString *)file highlight:(NSString *)highlightFile;

@end
