//
//  DMChatRoomViewController.h
//  TextbookExchange
//
//  Created by Haley Elliott on 12/2/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DMChatRoomViewController : UIViewController<UITextFieldDelegate>
{
    UITextField             *tfEntry;
    IBOutlet UITableView    *chatTable;
   
    //PF_EGORefreshTableHeaderView *_refreshHeaderView;
}

@property (nonatomic,retain) IBOutlet UITextField *tfEntry;
@property (nonatomic, retain) UITableView *chatTable;
@property (nonatomic, retain) NSArray *chatData;
@property (strong, nonatomic) id sentBook;
@property (nonatomic) BOOL newChat;
@property (nonatomic, retain) NSMutableString *chatRoom;



-(void) registerForKeyboardNotifications;
-(void) freeKeyboardNotifications;
-(void) keyboardWasShown:(NSNotification*)aNotification;
-(void) keyboardWillHide:(NSNotification*)aNotification;


@end
