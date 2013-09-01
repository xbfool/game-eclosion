//
//  BLGameScene.m
//  Blocks_Cocos
//
//  Created by Tsubasa on 13-9-1.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "BLGameScene.h"


@implementation BLGameScene
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	BLGameScene *layer = [BLGameScene node];
	[scene addChild: layer];
	return scene;
}
@end
