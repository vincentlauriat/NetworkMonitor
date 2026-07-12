//
//  CategoryRow.m
//  NetworkMonitor
//
//  Created by Patrick Wardle on 4/4/15.
//  Copyright (c) 2015 Objective-See. All rights reserved.
//

#import "CustomRow.h"

@implementation CustomRow

//custom row selection
-(void)drawSelectionInRect:(NSRect)dirtyRect
{
    //selection rect
    NSRect selectionRect = {0};

    //selection path
    NSBezierPath *selectionPath = nil;

    //highlight selected rows
    if(self.selectionHighlightStyle != NSTableViewSelectionHighlightStyleNone)
    {
        //make selection rect
        selectionRect = NSInsetRect(self.bounds, 2.5, 2.5);

        //dynamic system colors
        // ...adapt to light/dark and accent tint on their own, no manual branching needed
        [[NSColor selectedContentBackgroundColor] setStroke];
        [[[NSColor selectedContentBackgroundColor] colorWithAlphaComponent:0.35] setFill];

        //create selection path
        // ...with rounded corners
        selectionPath = [NSBezierPath bezierPathWithRoundedRect:selectionRect xRadius:5 yRadius:5];

        //fill
        [selectionPath fill];

        //stroke
        [selectionPath stroke];
    }

    return;
}

@end
