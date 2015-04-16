//
//  Enemy.m
//  GameOfLife
//
//  Created by Rainy Yang on 4/15/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy
- (id)init {
	self = [super init];
	if (self) {
		health = 1;
	}
	return self;
}

- (void) reduceHealth {
	[super reduceHealth];
}

@end
