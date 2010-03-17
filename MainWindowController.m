#import "MainWindowController.h"

@implementation MainWindowController

- (void) sortPostsTable
{
	NSSortDescriptor* sortdescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
	[postsController setSortDescriptors:[NSArray arrayWithObject:sortdescriptor]];
	
	sortdescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	[blogsController setSortDescriptors:[NSArray arrayWithObject:sortdescriptor]];
}

- (void) awakeFromNib
{
	NSLog(@"MainMenu awake");
	previewController = nil;
	[self sortPostsTable];
	state = 0;
}

- (IBAction)addBlog:(id)sender
{
	[blogsController add:self];
	[blogsPanel makeKeyAndOrderFront:self];
}

- (IBAction)refreshBlog:(id)sender 
{	
	state = REFRESHING_ALL;
	
	NSManagedObject* blog = [[blogsController selectedObjects] objectAtIndex:0];
	
	NSString* username = [blog valueForKey:@"username"];
	NSString* password = [blog valueForKey:@"password"];
	NSString* endpoint = [blog valueForKey:@"endpoint"];

	request = [[OrseeCategoriesRequest alloc] 
			   initWithEndpoint:endpoint
			   user:username
			   pass:password
			   delegate:self];		
}

- (void) didLoadCategories: (NSArray*) categories
{
	NSLog(@"Me devuelven el array de categorias");

	[categoriesController removeObjects:[categoriesController arrangedObjects]];	
	NSManagedObjectContext* context = [categoriesController managedObjectContext];

	NSManagedObject* blog = [[blogsController selectedObjects] objectAtIndex:0];
	
	NSMutableSet *categorias = [blog mutableSetValueForKey:@"categories"];

	for (NSString* string in categories)
	{
		NSManagedObject* newCategory = [NSEntityDescription
										insertNewObjectForEntityForName:@"Category"
										inManagedObjectContext:context];

		[newCategory setValue:string forKey:@"name"];
		[newCategory setValue:[NSNumber numberWithBool:NO] forKey:@"checked"];
		[categorias addObject: newCategory];
	}

	[categoriesPanel orderFront:self];

	if (state == REFRESHING_ALL)
	{
		NSString* username = [blog valueForKey:@"username"];
		NSString* password = [blog valueForKey:@"password"];
		NSString* endpoint = [blog valueForKey:@"endpoint"];
	
		request = [[OrseeRecentPostsRequest alloc] 
				   initWithEndpoint:endpoint
				   user:username
				   pass:password
				   delegate:self];		
	}
}

- (void) didLoadRecentPosts: (NSArray*) recentPosts
{
	NSLog(@"Me devuelven el array de posts recientes");
	
	[postsController removeObjects:[postsController arrangedObjects]];
	NSManagedObjectContext* context = [postsController managedObjectContext];
	
	NSManagedObject* blog = [[blogsController selectedObjects] objectAtIndex:0];
	NSMutableSet *postsSet = [blog mutableSetValueForKey:@"posts"];

	for (NSMutableDictionary* post in recentPosts)
	{
		NSString* title = [post valueForKey:@"title"];
		NSString* description = [post valueForKey:@"description"];
		NSString* postid = [post valueForKey:@"id"];
		NSString* permalink = [post valueForKey:@"permalink"];
//		NSString* date = [post valueForKey:@"date"];

		NSManagedObject* newPost = [NSEntityDescription
										insertNewObjectForEntityForName:@"Post"
										inManagedObjectContext:context];
		
		[newPost setValue:title forKey:@"title"];
		[newPost setValue:description forKey:@"body"];
		[newPost setValue:postid forKey:@"id"];
		[newPost setValue:permalink forKey:@"permalink"];
//		[newPost setValue:date forKey:@"date"];

		[postsSet addObject:newPost];
	}
	
//	for (NSString* string in categories)
//	{
//		NSManagedObject* newCategory = [NSEntityDescription
//										insertNewObjectForEntityForName:@"Category"
//										inManagedObjectContext:context];
//		
//		[newCategory setValue:string forKey:@"name"];
//		[categorias addObject: newCategory];
//	}
//	
//	[categoriesPanel makeKeyAndOrderFront:self];

	state = 0;
}

- (void) didFailWithCode: (NSString*) code
{
	NSLog(@"windowcontroller: se aborta la carga de categorias");
	NSAlert* alert = [NSAlert alertWithMessageText:@"Blog data could not be loaded" 
								   defaultButton:@"Repent..."
								   alternateButton:nil 
								   otherButton:nil 
						           informativeTextWithFormat:[NSString stringWithFormat:@"The server said: %@", code]];
	
	[alert runModal];
}

- (IBAction)showPreview:(id)sender
{
	NSLog(@"show preview");
	
	previewController = [[PreviewController alloc] init];
	
	if (![NSBundle loadNibNamed:@"Preview" owner:previewController]) 
	{
		NSLog(@"Error loading Nib for preview!");
		previewController = nil;
	} 
	else 
	{
		NSLog(@"Cargado NIB preview");
		[self refreshPreview];
	}
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	if (state != 0)
		return;
	
	NSLog(@"preview");
	if (previewController != nil)
	{
		[self refreshPreview];
	}
}

- (void) refreshPreview
{
	NSArray* selectedPosts = [postsController selectedObjects];
	
	if ([selectedPosts count]>0)
	{
		NSManagedObject* post = [selectedPosts objectAtIndex:0];
		[previewController showPost:post];
	}
}

- (IBAction)newPost:(id)sender
{
	NSLog(@"new post!");
	NSManagedObjectContext* context = [postsController managedObjectContext];

	NSManagedObject* newPost = [NSEntityDescription
								insertNewObjectForEntityForName:@"Post"
								inManagedObjectContext:context];
	
	EditorSupport* support = [[EditorSupport alloc] init];
	
	[support setPost: newPost];
	[support setManagedObjectContext:context];
	[support setCategoriesController:categoriesController];
	
	[postsController addObject:newPost];
	
	if (![NSBundle loadNibNamed:@"Editor" owner:support]) 
	{
		NSLog(@"Error loading Nib for editor!");
		previewController = nil;
	} 
	else 
	{
		NSLog(@"Cargado NIB editor");
		[categoriesPanel orderFront:self];
	}	
}

- (IBAction)addCategory:(id)sender
{
	NSLog(@"Voy a crear una categoria");

	NSManagedObject* blog = [[blogsController selectedObjects] objectAtIndex:0];

	NSString* catName = [categoriesTextField stringValue];
	NSString* username = [blog valueForKey:@"username"];
	NSString* password = [blog valueForKey:@"password"];
	NSString* endpoint = [blog valueForKey:@"endpoint"];
	
	request = [[OrseeNewCategoryRequest alloc] 
			   initWithEndpoint:endpoint
			   user:username
			   pass:password
			   delegate:self
			   name:catName];		
	
}

- (void) didSendNewCategory
{
	state = REFRESHING_CATEGORIES;
	
	NSManagedObject* blog = [[blogsController selectedObjects] objectAtIndex:0];
	
	NSString* username = [blog valueForKey:@"username"];
	NSString* password = [blog valueForKey:@"password"];
	NSString* endpoint = [blog valueForKey:@"endpoint"];
	
	request = [[OrseeCategoriesRequest alloc] 
			   initWithEndpoint:endpoint
			   user:username
			   pass:password
			   delegate:self];		
	
}

- (IBAction)editPost:(id)sender
{
	NSManagedObjectContext* context = [postsController managedObjectContext];
	NSManagedObject* post = [[postsController selectedObjects] objectAtIndex:0];	

	NSNumber* postid = [post valueForKey:@"id"];
	NSLog(@"Voy a editar el post %@", postid);

	EditorSupport* support = [[EditorSupport alloc] init];
	
	[support setPost: post];
	[support setManagedObjectContext:context];
	[support setCategoriesController:categoriesController];

	if (![NSBundle loadNibNamed:@"Editor" owner:support]) 
	{
		NSLog(@"Error loading Nib for editor!");
		previewController = nil;
	} 
	else 
	{
		NSLog(@"Cargado NIB editor");
		[categoriesPanel orderFront:self];
	}	
}


@end
