//
//  OrseeRequest.m
//  pruebaxml
//
//  Created by David Muñoz Díaz on 14/12/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//


//  template for showing an XML document
//	NSString *displayString = [xmlDoc XMLStringWithOptions:NSXMLNodePrettyPrint];
//	NSLog(@"%@", displayString);


#import "OrseeRequest.h"

@implementation OrseeRequest

- (id) initWithEndpoint: (NSString*) newEndpoint user: (NSString*) user pass: (NSString*) pass delegate: (id) newDelegate
{
	[super init];

	endPoint = [NSURL URLWithString:newEndpoint];
	username = [user copy];
	password = [pass copy];
	delegate = newDelegate;
	
	return self;
}

- (void) addString: (NSString*) string to: (NSXMLElement*) params
{
	NSXMLElement* wrapper = [NSXMLElement elementWithName:@"param"];
	NSXMLElement* wrapper2 = [NSXMLElement elementWithName:@"value"];
	NSXMLElement* node = [NSXMLElement elementWithName:@"string" stringValue:string];
	
	[wrapper addChild:wrapper2];
	[wrapper2 addChild:node];
	[params addChild:wrapper];
}

- (NSXMLElement*) addStructTo: (NSXMLElement*) params
{
	NSXMLElement* wrapper = [NSXMLElement elementWithName:@"param"];
	NSXMLElement* wrapper2 = [NSXMLElement elementWithName:@"value"];
	NSXMLElement* node = [NSXMLElement elementWithName:@"struct"];
	
	[wrapper addChild:wrapper2];
	[wrapper2 addChild:node];
	[params addChild:wrapper];
	return node;
}

- (NSXMLElement*) addMemberTo: (NSXMLElement*) struc
{
	NSXMLElement* node = [NSXMLElement elementWithName:@"member"];
	[struc addChild:node];
	return node;
}

- (NSXMLElement*) addName: (NSString*)name to: (NSXMLElement*) member
{
	NSXMLElement* node = [NSXMLElement elementWithName:@"name" stringValue:name];
	[member addChild:node];
	return node;
}

- (NSXMLElement*) addArrayTo: (NSXMLElement*) member
{
	NSXMLElement* wrapper = [NSXMLElement elementWithName:@"value"];
	NSXMLElement* wrapper2 = [NSXMLElement elementWithName:@"array"];
	NSXMLElement* node = [NSXMLElement elementWithName:@"data"];
	
	[wrapper addChild:wrapper2];
	[wrapper2 addChild:node];
	[member addChild:wrapper];
	return node;
}

- (void) initRequest
{
	root = (NSXMLElement *)[NSXMLNode elementWithName:@"methodCall"];
	
	xmlDoc = [[NSXMLDocument alloc] initWithRootElement:root];
	[xmlDoc setVersion:@"1.0"];
	[xmlDoc setCharacterEncoding:@"UTF-8"];	
}

- (void) initRequestWithMethodName: (NSString*) methodName
{
	[self initRequest];
	NSXMLNode* methodNameNode = [NSXMLNode elementWithName:@"methodName" stringValue:methodName];
	[root addChild:methodNameNode];
}

- (void) send
{	
	request = [NSMutableURLRequest 
			   requestWithURL:endPoint
			   cachePolicy:NSURLRequestUseProtocolCachePolicy
			   timeoutInterval:60.0];
	
	receivedData = [[NSMutableData alloc] init];
	
	[request setHTTPMethod:@"POST"];
	[request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:[xmlDoc XMLData]];
	
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) 
	{
		NSLog(@"Vamos bien");
	} 
	else 
	{
		NSLog(@"No se puede establecer la conexion");
	}	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"Hay respuesta...");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	NSLog(@"Recibo %d bytes de datos...", [data length]);
	[receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"Fin de la conexion...");
	
	NSXMLDocument* responseDocument = [[NSXMLDocument alloc] initWithData:receivedData options:0 error:nil];

//	NSString *displayString = [responseDocument XMLStringWithOptions:NSXMLNodePrettyPrint];
//	NSLog(@"%@", displayString);
	
	NSArray* datanodes = [responseDocument nodesForXPath:@"/methodResponse/fault" error:nil];

	if ([datanodes count] > 0)
	{
		NSLog(@"Ha sido fault");		
		NSArray* errornodes = [responseDocument nodesForXPath:@"//member[name='faultString']/value/string" error:nil];
		NSString* errorString = @"Unknown error";
		
		if ([errornodes count] > 0)
			errorString = [[errornodes objectAtIndex:0] stringValue];

		[self notifyError:errorString];
	}
	else
	{
		[self notifyResponse: responseDocument];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"ERROR: %@", error);
}

- (void) notifyResponse: (NSXMLDocument*) response
{
	NSLog(@"manejador por defecto de notifyResponse");
}

- (void) notifyError: (NSString*) errorCode
{
	NSLog(@"manejador por defecto de notifyError: %@", errorCode);
}

@end
