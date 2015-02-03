//
//  FilterViewController.h
//  Yelp
//
//  Created by Sai Anudeep Machavarapu on 1/31/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchCell.h"

//forward declaration
@class FilterViewController;

@protocol FilterViewControllerDelegate <NSObject>

- (void) filterViewController : (FilterViewController *) filterViewController
              didChangeFilters:(NSDictionary *)filters;
@end

@interface FilterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SwitchCellDelegate>

@property (nonatomic,weak) id<FilterViewControllerDelegate> delegate;

@end
