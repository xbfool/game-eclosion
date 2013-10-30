//
//  ECTile.h
//  Eclosion
//
//  Created by Tsubasa on 13-10-2.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BaseTile.h"

typedef enum {
    ECTileTypeRoad     = 0,
    ECTileTypeWall     = 1,
    ECTileTypeJump     = 2,
    ECTileTypeLadder   = 3,
    ECTileTypeTrap     = 4,
    ECTileTypeEnd      = 5,
}ECTileType;

@interface ECTileUtil : NSObject {
    
}

@property(nonatomic,retain) NSDictionary *classMapping;
+ (BaseTile *)getTileByIndex:(ECTileType)index;

@end

@interface ECTileBlank : BaseTile {
    
}

@end

@interface ECTileRoad : BaseTile {
    
}

@end

@interface ECTileWall : BaseTile {
    
}

@end

@interface ECTileJump : BaseTile {
    
}

@end

@interface ECTileLadder : BaseTile {
    
}

@end

@interface ECTileTrap : BaseTile {
    
}

@end

@interface ECTileEnd : BaseTile {
    
}

@end
