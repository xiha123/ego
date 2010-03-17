//
//  OrseeNewCategoryRequest.h
//  Ego
//
//  Created by David Muñoz Díaz on 23/12/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OrseeRequest.h"

@interface OrseeNewCategoryRequest : OrseeRequest 
{
}

- (id) initWithEndpoint: (NSString*) newEndpoint user: (NSString*) user pass: (NSString*) pass delegate: (id) newDelegate name: (NSString*) name;
- (void) sendNewCategory: (NSString*) name;
- (void) notifyError: (NSString*) errorCode;
- (void) notifyResponse: (NSXMLDocument*) response;   

@end
