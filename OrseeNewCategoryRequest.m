//
//  OrseeNewCategoryRequest.m
//  Ego
//
//  Created by David Muñoz Díaz on 23/12/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "OrseeNewCategoryRequest.h"


@implementation OrseeNewCategoryRequest

- (id) initWithEndpoint: (NSString*) newEndpoint 
				   user: (NSString*) user 
				   pass: (NSString*) pass 
			   delegate: (id) newDelegate 
				   name: (NSString*) name 
{
	[super initWithEndpoint:newEndpoint user:user pass:pass delegate:newDelegate];
	[self sendNewCategory:name];
	return self;
}

- (void) sendNewCategory: (NSString*) name
{
	NSLog(@"sending category %@", name);
	[self initRequestWithMethodName: @"wp.newCategory"];
	
	NSXMLElement* params = [NSXMLElement elementWithName:@"params"];
	[root addChild: params];
	
	[self addString:@"1" to:params];
	[self addString:username to:params];
	[self addString:password to:params];
	
	NSXMLElement* structElement = [self addStructTo:params];
	
	NSXMLElement* nameMember = [self addMemberTo:structElement];
	[self addName:@"name" to:nameMember];
	[self addString:name to:nameMember];
	
//	NSString *displayString = [xmlDoc XMLStringWithOptions:NSXMLNodePrettyPrint];
//	NSLog(@"%@", displayString);
	
	[self send];
}

- (void) notifyError: (NSString*) errorCode
{
	NSLog(@"no se ha podido enviar la categoria: %@", errorCode);
	[delegate performSelector:@selector(didFailWithCode:) withObject:errorCode];
}

- (void) notifyResponse: (NSXMLDocument*) response
{
	NSLog(@"habemus respuesta");
//	NSString *displayString = [response XMLStringWithOptions:NSXMLNodePrettyPrint];
//	NSLog(@"%@", displayString);
	
	[delegate performSelector:@selector(didSendNewCategory)];
}


@end
