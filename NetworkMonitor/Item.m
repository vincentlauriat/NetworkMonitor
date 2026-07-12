//
//  Item.m
//  NetworkMonitor
//
//  Created by Patrick Wardle on 7/20/19.
//  Copyright © 2019 Objective-See. All rights reserved.
//

#import "Item.h"

@implementation Item

//init
-(id)init:(Process*)process
{
    //super
    self = [super init];
    if(self != nil)
    {
        //init
        self.connections = [NSMutableArray array];
    
        //save
        self.process = process;
    }
    
    return self;
}

@end
