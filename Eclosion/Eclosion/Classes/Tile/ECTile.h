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
    ECTileTypeTree     = 2,
    ECTileTypeStar     = 3,
    ECTileTypeTrap     = 4,
    ECTileTypeEnd      = 5,
    ECTileTypeHero     = 6,
    ECTileTypeMovH1    = 7,
    ECTileTypeMovH2    = 8,
    ECTileTypeMovH3    = 9,
    ECTileTypeMovL1    = 10,
    ECTileTypeMovL2    = 11,
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

@interface ECTileRoadH1 : ECTileRoad {
    
}

@end

@interface ECTileRoadH2 : ECTileRoad {
    
}

@end

@interface ECTileRoadH3 : ECTileRoad {
    
}

@end

@interface ECTileRoadL1 : ECTileRoad {
    
}

@end

@interface ECTileRoadL2 : ECTileRoad {
    
}

@end

@interface ECTileWall : BaseTile {
    
}

@end

@interface ECTileStar : BaseTile {
    
}

@end

@interface ECTileTree : BaseTile {
    
}

@end

@interface ECTileTrap : BaseTile {
    
}

@end

@interface ECTileEnd : BaseTile {
    
}

@end
