//
//  EditBookViewController.h
//  TextbookExchange
//
//  Created by Haley Elliott on 11/5/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditBookViewController : UIViewController
- (IBAction)savBookButt:(UIButton *)sender;
- (IBAction)exchangedButt:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *titleLBL;
@property (weak, nonatomic) IBOutlet UITextField *authorLBL;
@property (weak, nonatomic) IBOutlet UITextField *isbnLBL;
@property (strong, nonatomic) id sentBook;
@end
