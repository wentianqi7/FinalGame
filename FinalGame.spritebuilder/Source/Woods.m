//
//  Woods.m
//  FinalGame
//
//  Created by Rainy Yang on 5/2/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Woods.h"

@implementation Woods
static int price = 350;

- (id)init {
	self = [super init];
	
	if (self) {
		CCLOG(@"Wood created");
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
