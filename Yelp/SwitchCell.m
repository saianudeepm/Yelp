//
//  SwitchCell.m
//  Yelp
//
//  Created by Sai Anudeep Machavarapu on 2/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "SwitchCell.h"

@interface SwitchCell()

@end

@implementation SwitchCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = NO;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setOn:(BOOL)on{
    [self setOn:on animated:NO];
}

-(void) setOn:(BOOL)on animated:(BOOL)animated{
    _on = on;
    [self.toggleSwitch setOn:on animated:animated];

}

- (IBAction)switchValueChanged:(id)sender {
    [self.delegate switchCell:self didUpdatevalue:self.toggleSwitch.on ];
    
}
@end

