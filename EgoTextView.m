//
//  EgoTextView.m
//  Ego
//
//  Created by David Muñoz Díaz on 24/12/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "EgoTextView.h"


@implementation EgoTextView

- (void) awakeFromNib
{
	NSLog(@"EGO TEXT VIEW AWAKING FROM NIB");
}

- (void) searchInsertionPoint
{
	NSRange storedRange = [self selectedRange];
	NSRange range = NSMakeRange(storedRange.location, 0);
	NSString* text = [self string];
	
	int startBound = storedRange.location + storedRange.length;
	int stopBound = [text length];
	int i = startBound;
	while (i < stopBound)
	{
		NSString* c = [text substringWithRange:NSMakeRange(i, 1)];
		if ([c isEqualToString:@"·"] && (range.length == 0))
		{
			range.location = i;
			range.length = 1;
		}
		else if ([c isEqualToString:@"·"] && (range.length > 0))
		{
			range.length += 1;
			[self setSelectedRange:range];
			i = stopBound;
		}
		else
		{
			if (range.length > 0)
				range.length++;
		}
		i++;
	}
}

- (void)keyDown: (NSEvent *)event
{
	if ([[event charactersIgnoringModifiers] isEqualToString:@"\t"])
	{
		NSRange whereAmI = [self selectedRange];
		NSString* text = [self string];
		
		int i = whereAmI.location - 1;
		int found = 0;
		
		if (i <= 0) return;
		
		while(!found)
		{
			if (i < 0)
				return;
		
			NSString* c = [text substringWithRange:NSMakeRange(i, 1)];
			if ([c isEqualToString:@" "] || [c isEqualToString:@"\n"] || (i == 0))
			{
				found = 1;
			}
			else
			{
				i--;
			}	
		}

		NSRange codeRange = NSMakeRange(i+1, whereAmI.location - i - 1);
		NSString* code = [text substringWithRange:codeRange];

		NSManagedObjectContext *moc = [editorSupport managedObjectContext];
		
		NSEntityDescription *entityDescription = [NSEntityDescription
												  entityForName:@"Snippet"
												  inManagedObjectContext:moc];
		
		NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
		[fetchRequest setEntity:entityDescription];
		
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code like[c] %@", code];
		[fetchRequest setPredicate:predicate];
		
		NSArray *possibleSnippets = [moc executeFetchRequest:fetchRequest error:nil];
		
		if ([possibleSnippets count] > 0)
		{
			[self setSelectedRange:codeRange];
			NSManagedObject* snippet = [possibleSnippets objectAtIndex:0];
			NSString* text = [snippet valueForKey:@"text"];
			[self insertText:text];
			if ([text rangeOfString:@"··"].length > 0)
			{
				[self setSelectedRange:NSMakeRange(i+1,0)];
				[self searchInsertionPoint];
			}
		}
		else
		{
			[self searchInsertionPoint];
		}
	}
	else
	{
		[super keyDown:event];
	}	
}

- (void) colorTextFrom: (int)startBound to:(int)stopBound startingWith: (NSString*) start endingWith: (NSString*) end withColor: (NSColor*) color
{	
	NSString* text = [self string];
	
	unsigned int length = [text length];
	
	if ((!text) || (length == 0) || (length <= [start length]) || (length <= [end length]))
	{
		return;
	}
	
	int i = startBound;
	
	NSRange range;
	range.location = 0;
	range.length = 0;
	
	while(i < stopBound - ([end length]-1))
	{
		if ([[text substringWithRange:NSMakeRange(i, [start length])] isEqualToString:start] && (range.length == 0))
		{
			range.location = i;
			range.length = [start length];
		}
		else if ([[text substringWithRange:NSMakeRange(i, [end length])] isEqualToString:end] && (range.length > 0))
		{
			range.length += [end length];
			[self setTextColor:color range:range];
			range.length = 0;
		}
		else
		{
			if (range.length > 0)
				range.length++;
		}
		i++;
	}
}

- (void) didChangeText
{	
	NSString* text = [self string];
	
	if (!(text) || ([text length] == 0))
	{
		return;
	}
	
	NSRange storedRange = [self selectedRange];
	
	int startBound = storedRange.location - 1;
	int stopBound = storedRange.location+storedRange.length + 1;
	
	startBound = startBound<0?0:startBound;
	stopBound  = stopBound>[text length]?[text length]:stopBound;
	
	[self setTextColor:[NSColor blackColor] range:NSMakeRange(startBound,(stopBound - startBound))];
	
	startBound = storedRange.location-100;
	stopBound = storedRange.location+storedRange.length+100;
	
	startBound = startBound<0?0:startBound;
	stopBound  = stopBound>[text length]?[text length]:stopBound;
	
//	[self colorTextFrom:startBound to:stopBound startingWith:@">" endingWith:@"</a>" withColor:[NSColor colorWithDeviceRed:0 green:0 blue:1 alpha:1]];
	
	[self colorTextFrom:startBound to:stopBound startingWith:@"<" endingWith:@">" withColor:[NSColor colorWithCalibratedRed:.5 green:.5 blue:.5 alpha:1]];
		
	[self colorTextFrom:startBound to:stopBound startingWith:@"·" endingWith:@"·" withColor:[NSColor colorWithDeviceRed:0 green:.7 blue:0 alpha:1]];
}


@end
