//
//  Basket.m
//  Basket Climb
//
//  Created by Tom Longabaugh on 12/2/14.
//  Copyright (c) 2014 nyu.edu. All rights reserved.
//

#import "Basket.h"

@implementation Basket
@synthesize bottom;
@synthesize side;

/*
-(id) init
{
    if (self = [super init]) {
        
        //set basket color
        basketColor = [SKColor colorWithRed:0.184 green:0.36 blue:0.431 alpha:1.0];
        
        // Bottom
        bottom = [SKShapeNode shapeNodeWithRect:CGRectMake(0.0f, 0.0f, 30.0f, 5.0f)];
        bottom.fillColor = basketColor;
        bottom.strokeColor = basketColor;
        
        // Side
        side = [SKShapeNode node];
        side.fillColor = basketColor;
        side.strokeColor = basketColor;
        
        
    }
    return self;
}*/

-(Basket*)createBasketOnSide:(BOOL)leftSide
                  withColor:(SKColor*)color
                   andAngle:(CGFloat)angle
                    andSize:(CGFloat)size
{
    Basket *theBasket = [[Basket alloc] init];
    theBasket.bottom = [SKShapeNode shapeNodeWithRect:CGRectMake(0.0f, 0.0f, 50.0f*size, 5.0f*size)];
    theBasket.bottom.fillColor = color;
    theBasket.bottom.strokeColor = color;
    
    theBasket.side.fillColor = color;
    theBasket.side.strokeColor = color;
    if (leftSide) {
        theBasket.side = [SKShapeNode shapeNodeWithRect:CGRectMake(50.0f, 0.0f, 5.0f*size, 20.0f*size)];
    }
    else {
        theBasket.side = [SKShapeNode shapeNodeWithRect:CGRectMake(0.0f, 0.0f, 5.0f*size, 20.0f*size)];
    }
    return theBasket;
}

/*
-(void)setBasketColor:(SKColor*)color
{
    bottom.fillColor = color;
    bottom.strokeColor = color;
    side.fillColor = color;
    side.strokeColor = color;
}*/


@end
