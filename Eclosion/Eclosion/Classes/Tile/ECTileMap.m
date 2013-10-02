//
//  ECTileMap.m
//  Eclosion
//
//  Created by Tsubasa on 13-10-2.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ECTileMap.h"
#import "ECTile.h"

@implementation ECTileMap

+ (ECTileMap *)mapBuildWithFile:(NSString *)filename {
    ECTileMap * ECTileMap = [[ECTileMap alloc] init];
    [ECTileMap buildMap:filename];
    return [ECTileMap autorelease];
}

- (id)init {
    if ( self = [super init ]) {
        _tileMatrix = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)buildMap:(NSString *)filename {
    
    // read file
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@".plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    _tileMatrix = [[dic objectForKey:@"map"] copy];
    
    // read map matrix
    for ( int row = 0; row < [_tileMatrix count]; row++ ) {
        NSArray *tileRow = [_tileMatrix objectAtIndex:row];
        for ( int col = 0; col < [tileRow count]; col++ ) {
            
        }
    }
}

- (void)dealloc {
    [_tileMatrix release];
    [super dealloc];
}

@end





