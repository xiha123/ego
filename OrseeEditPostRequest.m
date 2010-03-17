//
//  OrseeEditPostRequest.m
//  Ego
//
//  Created by David Muñoz Díaz on 24/12/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "OrseeEditPostRequest.h"


@implementation OrseeEditPostRequest


- (id) initWithEndpoint: (NSString*) newEndpoint 
				   user: (NSString*) user 
				   pass: (NSString*) pass 
			   delegate: (id) newDelegate 
				 postid: (NSNumber*) postid
				  title: (NSString*) title 
				   body: (NSString*) body 
			 categories: (NSArray*)categories
{
	[super initWithEndpoint:newEndpoint user:user pass:pass delegate:newDelegate];
	[self sendEditPost:postid title:title body:body categories:categories];
	return self;
}

- (void) sendEditPost: (NSNumber*) postid 
				title: (NSString*) title 
				 body: (NSString*) body 
		   categories: (NSArray*) categories
{
	NSLog(@"sending post %@", title);
	[self initRequestWithMethodName: @"metaWeblog.editPost"];
	
	NSXMLElement* params = [NSXMLElement elementWithName:@"params"];
	[root addChild: params];
	
	[self addString:[postid stringValue] to:params];
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
	NSLog(@"no se ha podido enviar el post editado: %@", errorCode);
	[delegate performSelector:@selector(didFailWithCode:) withObject:errorCode];
}

- (void) notifyResponse: (NSXMLDocument*) response
{
	NSLog(@"habemus respuesta");
	//	NSString *displayString = [response XMLStringWithOptions:NSXMLNodePrettyPrint];
	//	NSLog(@"%@", displayString);
	
	[delegate performSelector:@selector(didEditPost)];
}


@end
