//
//  OrseeNewPostRequest.m
//  Ego
//
//  Created by David Muñoz Díaz on 22/12/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "OrseeNewPostRequest.h"


@implementation OrseeNewPostRequest

- (id) initWithEndpoint: (NSString*) newEndpoint 
				user: (NSString*) user 
				pass: (NSString*) pass 
				delegate: (id) newDelegate 
				title: (NSString*) title 
				body:(NSString*) body 
				categories:(NSArray*)categories
{
	[super initWithEndpoint:newEndpoint user:user pass:pass delegate:newDelegate];
	[self sendNewPost:title body:body categories:categories];
	return self;
}

- (void) sendNewPost: (NSString*) title body: (NSString*) body categories: (NSArray*) categories
{
	NSLog(@"sending post %@", title);
	[self initRequestWithMethodName: @"metaWeblog.newPost"];
	
	NSXMLElement* params = [NSXMLElement elementWithName:@"params"];
	[root addChild: params];
	
	[self addString:@"1" to:params];
	[self addString:username to:params];
	[self addString:password to:params];
	NSXMLElement* structElement = [self addStructTo:params];

	NSXMLElement* titleMember = [self addMemberTo:structElement];
	[self addName:@"title" to:titleMember];
	[self addString:title to:titleMember];

	NSXMLElement* bodyMember = [self addMemberTo:structElement];
	[self addName:@"description" to:bodyMember];
	[self addString:body to:bodyMember];

	NSXMLElement* categoriesMember = [self addMemberTo:structElement];
	[self addName:@"categories" to:categoriesMember];
	NSXMLElement* arrayElement = [self addArrayTo:categoriesMember];
	
	for (NSString* category in categories)
	{
		[self addString:category to:arrayElement];
	}
	
	[self addString:@"1" to:params];

//	NSString *displayString = [xmlDoc XMLStringWithOptions:NSXMLNodePrettyPrint];
//	NSLog(@"%@", displayString);
	
	[self send];
}

- (void) notifyError: (NSString*) errorCode
{
	NSLog(@"no se ha podido enviar el post: %@", errorCode);
	[delegate performSelector:@selector(didFailWithCode:) withObject:errorCode];
}

- (void) notifyResponse: (NSXMLDocument*) response
{
	NSLog(@"habemus respuesta");
//	NSString *displayString = [response XMLStringWithOptions:NSXMLNodePrettyPrint];
//	NSLog(@"%@", displayString);
	
	NSString* postID= [[[response nodesForXPath:@"/methodResponse/params/param/value/string" error:nil] objectAtIndex:0] stringValue];

	[delegate performSelector:@selector(didSendNewPost:) withObject: [NSNumber numberWithInt:[postID intValue]]];
}


@end
