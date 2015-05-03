//
//  Tower.m
//  FinalGame
//
//  Created by Rainy Yang on 5/2/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Tower.h"

@implementation Tower

- (void)didLoadFromCCB {
	self.physicsBody.collisionType = @"scene";
}
@end
