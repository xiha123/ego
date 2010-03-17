//
//  OrseeCategoriesRequest.m
//  Ego
//
//  Created by David Muñoz Díaz on 15/12/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "OrseeCategoriesRequest.h"


@implementation OrseeCategoriesRequest

- (id) initWithEndpoint: (NSString*) newEndpoint user: (NSString*) user pass: (NSString*) pass delegate: (id) newDelegate
{
	[super initWithEndpoint:newEndpoint user:user pass:pass delegate:newDelegate];
	[self getCategories];
	return self;
}

- (void) getCategories
{
	[self initRequestWithMethodName: @"metaWeblog.getCategories"];
	
	NSXMLElement* params = [NSXMLElement elementWithName:@"params"];
	[root addChild: params];
	
	[self addString:@"1" to:params];
	[self addString:username to:params];
	[self addString:password to:params];
	
//	NSString *displayString = [xmlDoc XMLStringWithOptions:NSXMLNodePrettyPrint];
//	NSLog(@"%@", displayString);
	
	[self send];
}

- (void) notifyResponse: (NSXMLDocument*) response
{
	NSMutableArray* categories = [[NSMutableArray alloc] init];
	NSLog(@"me ha llegado la respuesta!");
	NSArray* datanodes = [response nodesForXPath:@"/methodResponse/params/param/value/array/data/*" error:nil];
	
	for (NSXMLNode* value in datanodes)
	{ 
		NSString* description = [[[value nodesForXPath:@"./struct/member[name='description']/value" error:nil] objectAtIndex:0] stringValue];
		
		NSLog(@"Categoría: %@", description);
		[categories addObject:description];
	}
	
	[delegate performSelector:@selector(didLoadCategories:) withObject: categories];
}

- (void) notifyError: (NSString*) errorCode
{
	NSLog(@"no se han podido obtener las categorias: %@", errorCode);
	[delegate performSelector:@selector(didFailWithCode:) withObject:errorCode];
}

   
@end
