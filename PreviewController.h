//
//  PreviewController.h
//  Ego
//
//  Created by David Muñoz Díaz on 17/12/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebView.h>
#import <WebKit/WebFrame.h>

@interface PreviewController : NSObject 
{
	IBOutlet WebView* webView;
	IBOutlet id panel;
	IBOutlet id themes;
	NSManagedObject* post;
}

- (id) panel;
- (id) webView;
- (void) showPost: (NSManagedObject*) post;

@end
