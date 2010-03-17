//
//  OrseeRecentPostsRequest.m
//  Ego
//
//  Created by David Muñoz Díaz on 16/12/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "OrseeRecentPostsRequest.h"

@implementation OrseeRecentPostsRequest

- (id) initWithEndpoint: (NSString*) newEndpoint user: (NSString*) user pass: (NSString*) pass delegate: (id) newDelegate
{
	[super initWithEndpoint:newEndpoint user:user pass:pass delegate:newDelegate];
	[self getRecentPosts];
	return self;
}

- (void) getRecentPosts
{
	[self initRequestWithMethodName: @"metaWeblog.getRecentPosts"];
	
	NSXMLElement* params = [NSXMLElement elementWithName:@"params"];
	[root addChild: params];
	
	[self addString:@"1" to:params];
	[self addString:username to:params];
	[self addString:password to:params];
	[self addString:@"25" to:params];
	
	//	NSString *displayString = [xmlDoc XMLStringWithOptions:NSXMLNodePrettyPrint];
	//	NSLog(@"%@", displayString);
	
	[self send];
}

- (void) notifyResponse: (NSXMLDocument*) response
{
	NSLog(@"me ha llegado la respuesta!");

//	NSString *displayString = [response XMLStringWithOptions:NSXMLNodePrettyPrint];
//	NSLog(@"%@", displayString);

	NSMutableArray* posts = [[NSMutableArray alloc] init];

	NSArray* datanodes = [response nodesForXPath:@"/methodResponse/params/param/value/array/data/*" error:nil];
	
	for (NSXMLNode* value in datanodes)
	{ 
		NSString* title = [[[value nodesForXPath:@"./struct/member[name='title']/value" error:nil] objectAtIndex:0] stringValue];
		NSString* description = [[[value nodesForXPath:@"./struct/member[name='description']/value" error:nil] objectAtIndex:0] stringValue];
		NSNumber* postid = [NSNumber numberWithInt: [[[[value nodesForXPath:@"./struct/member[name='postid']/value" error:nil] objectAtIndex:0] stringValue] intValue]];
		NSString* stringdate = [[[value nodesForXPath:@"./struct/member[name='dateCreated']/value" error:nil] objectAtIndex:0] stringValue];
		NSDate *date = [NSCalendarDate calendarDateWithString:stringdate strictly:NO];

		NSString* permalink = [[[value nodesForXPath:@"./struct/member[name='permaLink']/value" error:nil] objectAtIndex:0] stringValue];
		
//		NSArray* categorias = [value nodesForXPath:@"./struct/member[name='categories']//string" error:nil];
		
		NSMutableDictionary* newPost = [[NSMutableDictionary alloc] init];
		
		[newPost setValue:title forKey:@"title"];
		[newPost setValue:description forKey:@"description"];
		[newPost setValue:postid forKey:@"id"];
		[newPost setValue:date forKey:@"date"];
		[newPost setValue:permalink forKey:@"permalink"];
		
		[posts addObject:newPost];
	}
	
	[delegate performSelector:@selector(didLoadRecentPosts:) withObject: posts];
}

- (void) notifyError: (NSString*) errorCode
{
	NSLog(@"no se han podido obtener las entradas recientes: %@", errorCode);
	[delegate performSelector:@selector(didFailWithCode:) withObject:errorCode];
}




@end
