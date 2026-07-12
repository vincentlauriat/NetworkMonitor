//
//  CategoryRow.h
//  NetworkMonitor
//
//  Created by Patrick Wardle on 4/4/15.
//  Copyright (c) 2015 Objective-See. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CustomRow : NSTableRowView

//YES for a process (parent) row, NO for a connection (child) row
// tints process rows so they read as section headers instead of
// blending into the outline view's default alternating stripes
@property (nonatomic, assign) BOOL isProcessRow;

@end
