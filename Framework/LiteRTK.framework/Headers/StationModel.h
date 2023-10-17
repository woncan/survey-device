//
//  StationModel.h
//  LiteRTK
//
//  Created by iband on 2022/1/27.
//  Copyright © 2022 武汉桓参工程科技有限公司. All rights reserved.
//  RTCM包含的所有信息

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StationModel : NSObject

@property (nonatomic, assign) double b;
@property (nonatomic, assign) double l;
@property (nonatomic, assign) double h;

- (instancetype)initWithB:(double)b l:(double)l h:(double)h;

@end

NS_ASSUME_NONNULL_END
