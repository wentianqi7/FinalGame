//
//  Bones.m
//  GameOfLife
//
//  Created by Tianqi Wen on 4/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Bones.h"

@implementation Bones

static int price = 300;

- (id)init {
    self = [super init];
    
    if (self) {
        CCLOG(@"Bone created");
    }
	
    return self;
}

- (void)didLoadFromCCB {
	self.physicsBody.collisionType = @"bone";
}

+ (int)getPrice {
	return price;
}

@end
