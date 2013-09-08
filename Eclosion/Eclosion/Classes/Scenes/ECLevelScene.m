//
//  ECLevelScene.m
//  Eclosion
//
//  Created by Tsubasa on 13-9-4.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ECLevelScene.h"

@implementation ECLevelScene

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	ECLevelScene *layer = [ECLevelScene node];
	[scene addChild: layer];
	return scene;
}

-(void) onEnter
{
	[super onEnter];
    
    // Set background
    CC_CREATE_SPRITE_CENTER(background, @"bg_levelselect.png", 0);
}

@end
