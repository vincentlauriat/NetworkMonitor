//
//  TableViewController.h
//  NetworkMonitor
//
//  Created by Patrick Wardle on 7/20/19.
//  Copyright © 2019 Objective-See. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "3rd-party/OrderedDictionary.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableViewController : NSOutlineView <NSOutlineViewDataSource, NSOutlineViewDelegate>

//scroll view
@property (weak) IBOutlet NSScrollView *scrollView;

@property (weak) IBOutlet NSView *overlay;

//outline view
@property (weak) IBOutlet NSOutlineView *outlineView;

//overlay spinner
@property (weak) IBOutlet NSProgressIndicator *activityIndicator;

//overlay msg
@property (weak) IBOutlet NSTextField *activityMessage;

//original connections
@property(nonatomic, retain)OrderedDictionary* items;

//filtered connections
@property(nonatomic, retain)OrderedDictionary* processedItems;

//filter box
@property (weak) IBOutlet NSSearchField *filterBox;

//collapsed items
@property (nonatomic, retain)NSMutableDictionary* collapsedItems;

//font size
@property CGFloat zoomScale;

//filter string
@property (nonatomic, retain)NSString* filterString;

//"at a glance" summary strip, sitting above the outline view
@property (nonatomic, retain)NSView* statsStrip;

//stat cards shown in the strip (kept around for relayout on resize)
@property (nonatomic, retain)NSArray<NSView*>* statCards;

//value labels of the stat cards, in fixed order:
// connections, established, listening, bytes up, bytes down
@property (nonatomic, retain)NSArray<NSTextField*>* statValueLabels;

/* METHODS */

//update table
-(void)update:(OrderedDictionary*)updatedItems expand:(BOOL)expand reset:(BOOL)reset;

//map column id to index
-(NSUInteger)columnIDToIndex:(NSString*)columnID;

//refresh/reload table
-(void)refresh;

//expand all
-(void)expandAll;

//collapse all
-(void)collapseAll;

//zoom in
-(void)zoomIn;

//zoom out
-(void)zoomOut;

//zoom reset
-(void)zoomReset;

@end

NS_ASSUME_NONNULL_END
