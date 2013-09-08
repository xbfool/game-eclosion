//
//  ECVolumeScene.m
//  Eclosion
//
//  Created by Tsubasa on 13-9-8.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ECVolumeScene.h"

@implementation ECVolumeScene

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	ECVolumeScene *layer = [ECVolumeScene node];
	[scene addChild: layer];
	return scene;
}

-(void) onEnter
{
	[super onEnter];
    
    // Set background
    CC_CREATE_SPRITE_CENTER(background, @"bg_3.png", 0);
}

@end
