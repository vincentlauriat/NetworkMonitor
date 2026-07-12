//
//  CategoryRow.m
//  NetworkMonitor
//
//  Created by Patrick Wardle on 4/4/15.
//  Copyright (c) 2015 Objective-See. All rights reserved.
//

#import "CustomRow.h"

@implementation CustomRow

//tint process (parent) rows so they read as section headers instead
// of blending into the outline view's default alternating stripes —
// a neutral labelColor wash landed close enough to the default
// alternating gray to be invisible, so this uses the app's green
// accent instead (same language as the stat cards/state badges)
-(void)drawBackgroundInRect:(NSRect)dirtyRect
{
    if(YES == self.isProcessRow)
    {
        [[NSColor.systemGreenColor colorWithAlphaComponent:0.07] setFill];
        NSRectFillUsingOperation(self.bounds, NSCompositingOperationSourceOver);
        return;
    }

    [super drawBackgroundInRect:dirtyRect];

    return;
}

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
