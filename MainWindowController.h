#import <Cocoa/Cocoa.h>

#import "Orsee.h"

#import "PreviewController.h"
#import "EditorSupport.h"

#define REFRESHING_ALL 1
#define REFRESHING_CATEGORIES 2

@interface MainWindowController : NSObject
{
    IBOutlet id categoriesController;
    IBOutlet id categoriesPanel;
	IBOutlet id categoriesTextField;

	IBOutlet id blogsController;
    IBOutlet id blogsPanel;

	IBOutlet id postsController;

	IBOutlet id postsTable;
	
	IBOutlet id webViewPanel;
	IBOutlet id webView;
	
	OrseeRequest* request;
	
	PreviewController* previewController;
	
	int state;
}

- (IBAction)refreshBlog:(id)sender;
- (IBAction)newPost:(id)sender;
- (IBAction)editPost:(id)sender;
- (IBAction)addBlog:(id)sender;
- (IBAction)showPreview:(id)sender;
- (IBAction)addCategory:(id)sender;
- (void) refreshPreview;
@end
