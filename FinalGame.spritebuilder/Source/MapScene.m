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
	[GameProperty setEnemyInterval:10.f];
	[GameProperty setPrice:300];
	[[CCDirector sharedDirector] replaceScene:mainScene];
}

- (void)midLevel {
	CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
	[GameProperty setMaterial:@"Woods"];
	[GameProperty setEnemyInterval:6.f];
	[GameProperty setPrice:350];
	[[CCDirector sharedDirector] replaceScene:mainScene];
}

- (void)modernLevel {
	CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
	[GameProperty setMaterial:@"Steels"];
	[GameProperty setEnemyInterval:3.f];
	[GameProperty setPrice:400];
	[[CCDirector sharedDirector] replaceScene:mainScene];
}

- (void)techTree {
	
}

@end
