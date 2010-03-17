#import "EditorController.h"

@implementation EditorController

- (void) awakeFromNib
{
	NSLog(@"Ego Editor awaking from NIB");
	[window makeKeyAndOrderFront:self];

	NSManagedObject* post = [editorSupport post];
	[textView setString:[post valueForKey:@"body"]];	
}

- (void) showSending
{
	[NSApp beginSheet: sendingPanel
	   modalForWindow: window
		modalDelegate: self
	   didEndSelector: nil
		  contextInfo: nil];
}


- (IBAction)sendPost:(id)sender
{
	[self showSending];
	
	NSManagedObject* post = [editorSupport post];
	
	NSString* title = [textField stringValue];
	NSString* body  = [[textView attributedString] string];
	
	[post setValue:body forKey:@"body"];

	NSManagedObjectContext *moc = [editorSupport managedObjectContext];
	
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"Category"
											  inManagedObjectContext:moc];
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	[fetchRequest setEntity:entityDescription];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"checked==YES"];
	[fetchRequest setPredicate:predicate];
	
	NSArray *checkedCategories = [moc executeFetchRequest:fetchRequest error:nil];
	NSMutableArray* categories = [[NSMutableArray alloc] init];
	
	for (NSManagedObject* category in checkedCategories)
	{
		[categories addObject:[category valueForKey:@"name"]];
	}
	
	NSManagedObject* blog = [[editorSupport post] valueForKey:@"blog"];
	
	NSString* username = [blog valueForKey:@"username"];
	NSString* password = [blog valueForKey:@"password"];
	NSString* endpoint = [blog valueForKey:@"endpoint"];
	
	NSNumber* postid = [[editorSupport post] valueForKey:@"id"];
	
	if ([postid intValue] > 0)
	{
		NSLog(@"Este post hay que actualizarlo!");
		request = [[OrseeEditPostRequest alloc] 
				   initWithEndpoint:endpoint
				   user:username
				   pass:password
				   delegate:self
				   postid:postid
				   title:title
				   body:body
				   categories:categories];		
	}
	else
	{
		NSLog(@"Este post es nuevo");
		request = [[OrseeNewPostRequest alloc] 
				   initWithEndpoint:endpoint
				   user:username
				   pass:password
				   delegate:self
				   title:title
				   body:body
				   categories:categories];		
	}
}

- (void) didSendNewPost: (NSNumber*) postId
{
	NSLog(@"Me notifican que el nuevo post tiene id %@", postId);
	[[editorSupport post] setValue:postId forKey:@"id"];

	[NSApp endSheet:sendingPanel];
	[sendingPanel orderOut:self];
	[window close];	
}

- (void) didEditPost
{
	NSLog(@"post editado");
	[NSApp endSheet:sendingPanel];
	[sendingPanel orderOut:self];
	[window close];	
}

@end
