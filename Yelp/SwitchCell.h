//
//  SwitchCell.h
//  Yelp
//
//  Created by Sai Anudeep Machavarapu on 2/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchCell;
@protocol SwitchCellDelegate <NSObject>

-(void) switchCell: (SwitchCell*) switchCell
    didUpdatevalue: (BOOL) value;

@end


@interface SwitchCell : UITableViewCell

@property (nonatomic,weak) id<SwitchCellDelegate>delegate;
@property (nonatomic,assign) BOOL on;
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


- (IBAction)switchValueChanged:(id)sender;
- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
