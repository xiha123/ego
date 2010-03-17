//
//  EditorSupport.h
//  Ego
//
//  Created by David Muñoz Díaz on 22/12/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface EditorSupport : NSObject 
{
	NSManagedObject* post;
	NSManagedObjectContext* managedObjectContext;
	NSArrayController* categoriesController;	
}
- (void) setPost: (NSManagedObject*) newPost;
- (NSManagedObject*) post;

- (void) setManagedObjectContext: (NSManagedObjectContext*) newContext;
- (NSManagedObjectContext*) managedObjectContext;

- (void) setCategoriesController: (NSArrayController*) newController;
- (NSArrayController*) categoriesController;
@end
