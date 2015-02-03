//
//  YelpItem.m
//  Yelp
//
//  Created by Sai Anudeep Machavarapu on 1/29/15.
//  Copyright (c) 2015 salome. All rights reserved.
//

#import "Business.h"

@implementation Business


-(instancetype) initWithDictionary:(NSDictionary *) dictionary{
    self = [super init];
    self.imageURL= [NSString stringWithFormat:@"%@",dictionary[@"image_url"]];
    self.name= [NSString stringWithFormat:@"%@",dictionary[@"name"] ];
    self.ratingImageURL=[NSString stringWithFormat:@"%@",dictionary[@"rating_img_url"]];
    self.numReviews=[dictionary[@"review_count"]integerValue];
    
    NSString *street  = [dictionary valueForKeyPath:@"location.address"][0];
    NSString * neighborhood = [dictionary valueForKeyPath:@"location.neighborhoods"][0];
    self.address= [NSString stringWithFormat:@"%@, %@",street, neighborhood];
    
    
    NSArray *categories = dictionary[@"categories"];
    NSMutableArray *categoriesNames =[[NSMutableArray alloc]init];
    [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [categoriesNames addObject:obj[0]];
    }];
    self.categories=[categoriesNames componentsJoinedByString:@","];
    
    float milesPerMeter = 0.000621371;
    self.distance= [dictionary[@"distance"]integerValue] * milesPerMeter;
    
    self.lat = [[dictionary valueForKeyPath:@"location.coordinate.latitude"] floatValue];
    self.lng = [[dictionary valueForKeyPath:@"location.coordinate.longitude"] floatValue];
    return  self;
};

// returns an Array of Movie Objects from Movie Json Array
+ (NSArray *) businessWithDictionaries: (NSArray *) dictionaries{
    
    NSMutableArray *businessArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in dictionaries) {
        Business *business = [[Business alloc]initWithDictionary:dictionary];
        [businessArray addObject:business];
    }
    
    return businessArray;
}

@end
