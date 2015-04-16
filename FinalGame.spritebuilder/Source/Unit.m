//
//  Unit.m
//  GameOfLife
//
//  Created by Rainy Yang on 4/15/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Unit.h"

@implementation Unit {
	
}

- (void) reduceHealth {
	health--;
}

- (bool) isDead {
	return (health <= 0);
}
@end
