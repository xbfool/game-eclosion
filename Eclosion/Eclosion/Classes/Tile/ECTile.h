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

@interface ECTileUtil : NSObject {
    
}

@property(nonatomic,retain) NSDictionary *classMapping;
+ (BaseTile *)getTileByName:(NSString *)name;

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

@interface ECTileRoadL2 : ECTileRoad {
    
}

@end

@interface ECTileRoadL3 : ECTileRoad {
    
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
