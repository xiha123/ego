//
//  OrseeCategoriesRequest.h
//  Ego
//
//  Created by David Muñoz Díaz on 15/12/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OrseeRequest.h"

@interface OrseeCategoriesRequest : OrseeRequest 
{
}

- (id) initWithEndpoint: (NSString*) newEndpoint user: (NSString*) user pass: (NSString*) pass delegate: (id) newDelegate;
- (void) getCategories;
- (void) notifyError: (NSString*) errorCode;
- (void) notifyResponse: (NSXMLDocument*) response;   
@end
