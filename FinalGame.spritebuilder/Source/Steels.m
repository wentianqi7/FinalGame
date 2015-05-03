//
//  Steels.m
//  FinalGame
//
//  Created by Rainy Yang on 5/2/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Steels.h"

@implementation Steels
static int price = 400;

- (id)init {
	self = [super init];
	
	if (self) {
		CCLOG(@"Steel created");
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
