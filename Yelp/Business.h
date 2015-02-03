//
//  YelpItem.h
//  Yelp
//
//  Created by Sai Anudeep Machavarapu on 1/29/15.
//  Copyright (c) 2015 salome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Business : NSObject
@property (nonatomic,strong ) NSString *imageURL;
@property (nonatomic,strong ) NSString *name;
@property (nonatomic,strong ) NSString *ratingImageURL;
@property (nonatomic,assign ) NSInteger numReviews;
@property (nonatomic,strong ) NSString *address;
@property (nonatomic,strong ) NSString *categories;
@property (nonatomic,assign ) CGFloat  distance;
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;

+ (NSArray *) businessWithDictionaries: (NSArray *) dictionaries;

@end
