//
//  PreviewController.m
//  Ego
//
//  Created by David Muñoz Díaz on 17/12/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "PreviewController.h"


@implementation PreviewController

- (void) awakeFromNib
{
	NSString* path = [NSString stringWithFormat:@"%@/previewThemes", [[NSBundle mainBundle] resourcePath]];
	NSLog(@"previewcontroller awake from nib inspeccionando directorio :: %@", path);
	NSArray* availableThemes = [[NSFileManager defaultManager] directoryContentsAtPath:path];
	for(NSString* themeName in availableThemes)
	{
		NSLog(@"theme: %@", themeName);
		[themes addItemWithTitle:themeName];
	}
}

- (id) panel
{
	return panel;
}

- (id) webView
{
	return webView;
}

- (void) showPost: (NSManagedObject*) newPost withTheme: (NSString*) themeName
{
	post = newPost;
	
	NSString* link  = [post valueForKey:@"permalink"];
	NSString* title = [post valueForKey:@"title"];
	NSString* body  = [post valueForKey:@"body"];
	
	NSString* path = [[NSBundle mainBundle] resourcePath];
	
	NSString* themePath = nil;
	
	if (themeName == nil)
	{
		themePath = [NSString stringWithFormat:@"file://%@/previewThemes/%@", path, [[themes selectedItem] title]];
	}
	else
	{
		themePath = [NSString stringWithFormat:@"file://%@/previewThemes/%@", path, themeName];
	}
	
	NSString* HTMLhead = [NSString stringWithFormat:@"<meta http-equiv='content-type' content='text/html;charset=UTF-8'><link rel='stylesheet' href='%@' type='text/css' />", themePath];
	NSString* HTMLbody = [NSString stringWithFormat:@"<h1 id='title'>%@</h1><p id='permalink'><a href='%@'>%@</a></p>%@", title, link, link, body];
	NSString* webpage = [NSString stringWithFormat:@"<html><head>%@</head><body>%@</body></html>", HTMLhead, HTMLbody];
	
	[webpage writeToFile:@"/tmp/ego-preview.html" atomically:YES encoding:NSUTF8StringEncoding error:nil];
	
	[[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"file:///tmp/ego-preview.html"]]];
}

- (void) showPost: (NSManagedObject*) newPost
{
	[self showPost: newPost withTheme: nil];
}

- (void)menu:(NSMenu *)menu willHighlightItem:(NSMenuItem *)item
{
	[self showPost:post withTheme:[item title]];
}



@end
