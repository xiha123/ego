//
//  OrseeEditPostRequest.h
//  Ego
//
//  Created by David Muñoz Díaz on 24/12/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OrseeRequest.h"

@interface OrseeEditPostRequest : OrseeRequest 
{

}

- (id) initWithEndpoint: (NSString*) newEndpoint user: (NSString*) user pass: (NSString*) pass delegate: (id) newDelegate postid: (NSNumber*) postid title: (NSString*) title body:(NSString*) body categories:(NSArray*)categories;
- (void) sendEditPost: (NSNumber*) postid title: (NSString*) title body: (NSString*) body categories: (NSArray*) categories;
- (void) notifyError: (NSString*) errorCode;
- (void) notifyResponse: (NSXMLDocument*) response;   

@end
