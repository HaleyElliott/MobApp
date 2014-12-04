//
//  chatCell.h
//  TextbookExchange
//
//  Created by Haley Elliott on 12/2/14.
//
//

#import <UIKit/UIKit.h>

@interface chatCell : UITableViewCell
{
    IBOutlet UILabel *userLabel;
    IBOutlet UITextView *textString;
    IBOutlet UILabel *timeLabel;
}
@property (nonatomic,retain) IBOutlet UILabel *userLabel;
@property (nonatomic,retain) IBOutlet UITextView *textString;
@property (nonatomic,retain) IBOutlet UILabel *timeLabel;

@end
