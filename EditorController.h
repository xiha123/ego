#import <Cocoa/Cocoa.h>

#import "Orsee.h"
#import "EditorSupport.h"

@interface EditorController : NSObject
{
	IBOutlet id window;
	IBOutlet id textField;
	IBOutlet id textView;
	IBOutlet id editorSupport;
	IBOutlet id sendingPanel;
	OrseeRequest* request;
}
- (IBAction)sendPost:(id)sender;
- (void) didSendNewPost: (NSNumber*) postId;
@end
