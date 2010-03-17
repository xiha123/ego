//
//  EditorSupport.m
//  Ego
//
//  Created by David Muñoz Díaz on 22/12/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "EditorSupport.h"


@implementation EditorSupport

- (void) setPost: (NSManagedObject*) newPost
{
	post = newPost;
}

- (NSManagedObject*) post
{
	return post;
}

- (void) setManagedObjectContext: (NSManagedObjectContext*) newContext
{
	managedObjectContext = newContext;
}

- (NSManagedObjectContext*) managedObjectContext
{
	return managedObjectContext;
}

- (void) setCategoriesController: (NSArrayController*) newController
{
	categoriesController = newController;
}

- (NSArrayController*) categoriesController
{
	return categoriesController;
}

@end
