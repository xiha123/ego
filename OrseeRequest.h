//
//  OrseeRequest.h
//  pruebaxml
//
//  Created by David Muñoz Díaz on 14/12/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface OrseeRequest : NSObject 
{
	NSURL* endPoint;
	NSString* username;
	NSString* password;
	
	NSXMLElement* root;
	NSXMLDocument* xmlDoc;
	
	NSMutableData* receivedData;
	
	NSMutableURLRequest* request;
	NSURLConnection* connection;
	
	id delegate;
}

- (id) initWithEndpoint: (NSString*) newEndpoint user: (NSString*) user pass: (NSString*) pass delegate: (id) newDelegate;
- (void) initRequest;
- (void) initRequestWithMethodName: (NSString*) methodName;

- (void) addString: (NSString*) string to: (NSXMLElement*) params;
- (NSXMLElement*) addStructTo: (NSXMLElement*) params;
- (NSXMLElement*) addMemberTo: (NSXMLElement*) struc;
- (NSXMLElement*) addName: (NSString*)name to: (NSXMLElement*) member;

- (NSXMLElement*) addArrayTo: (NSXMLElement*) member;

- (void) send;
- (void) notifyError: (NSString*) errorCode;
- (void) notifyResponse: (NSXMLDocument*) response;

@end
