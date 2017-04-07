//
//  DataManager.h
//  fmdb_pickviewController
//
//  Created by lcy on 16/4/7.
//  Copyright © 2016年 ZG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ResidenceModel;
@interface DataManager : NSObject

+ (id)sharedInstance;

- (void)addResidence:(ResidenceModel*)residence;
- (void)deleteResidence:(ResidenceModel*)residence;
- (void)updateResidence:(ResidenceModel*)residence :(NSString*)newString;
- (NSArray *)residenceArray;


@end
