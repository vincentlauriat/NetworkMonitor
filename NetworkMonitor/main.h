//
//  main.h
//  NetworkMonitor
//
//  Created by Patrick Wardle on 7/14/19.
//  Copyright © 2019 Objective-See. All rights reserved.
//

#ifndef main_h
#define main_h

/* FUNCTIONS */

//register bundled fonts (Geist/Geist Mono) before any nib loads
void registerCustomFonts(void);

//print usage
void usage(void);

//perform a cmdline scan
void cmdlineInterface(void);

#endif /* main_h */
