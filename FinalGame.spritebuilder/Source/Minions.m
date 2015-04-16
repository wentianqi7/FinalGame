//
//  Minions.m
//  GameOfLife
//
//  Created by Tianqi Wen on 4/15/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Minions.h"

@implementation Minions {
	
}

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
