//
//  ChatViewController.h
//  TextbookExchange
//
//  Created by Haley Elliott on 12/2/14.
//
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableChat;

@property (weak, nonatomic) IBOutlet UITextField *chatField;
@property (weak, nonatomic) IBOutlet UILabel *chatLable;

@end
