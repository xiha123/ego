//
//  OrseeRecentPostsRequest.h
//  Ego
//
//  Created by David Muñoz Díaz on 16/12/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OrseeRequest.h"
#import "NSCalendarDate+ISO8601Parsing.h"

@interface OrseeRecentPostsRequest : OrseeRequest
{

}

- (id) initWithEndpoint: (NSString*) newEndpoint user: (NSString*) user pass: (NSString*) pass delegate: (id) newDelegate;
- (void) getRecentPosts;
- (void) notifyError: (NSString*) errorCode;
- (void) notifyResponse: (NSXMLDocument*) response;   

@end
