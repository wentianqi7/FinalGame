//
//  MapScene.m
//  FinalGame
//
//  Created by Rainy Yang on 5/2/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "MapScene.h"

@implementation MapScene

- (void)stoneLevel {
	CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
	[GameProperty setMaterial:@"Bones"];
	[[CCDirector sharedDirector] replaceScene:mainScene];
}

- (void)midLevel {
	CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
	[GameProperty setMaterial:@"Woods"];
	[[CCDirector sharedDirector] replaceScene:mainScene];
}

- (void)modernLevel {
	CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
	[GameProperty setMaterial:@"Steels"];
	[[CCDirector sharedDirector] replaceScene:mainScene];
}

- (void)techTree {
	
}

@end
