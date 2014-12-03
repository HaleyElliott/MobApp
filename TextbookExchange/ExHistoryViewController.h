//
//  ExHistoryViewController.h
//  TextbookExchange
//
//  Created by JINGXIAN FENG on 11/5/14.
//
//

#import <UIKit/UIKit.h>

@interface ExHistoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *exchangedBooks;


@end
