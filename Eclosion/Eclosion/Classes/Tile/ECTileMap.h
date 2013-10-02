//
//  TileMap.h
//  Eclosion
//
//  Created by Tsubasa on 13-10-2.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ECTileMap : CCSprite {
    NSMutableArray *_tileMatrix;
}

+ (ECTileMap *)mapBuildWithFile:(NSString *)filename;
@end

