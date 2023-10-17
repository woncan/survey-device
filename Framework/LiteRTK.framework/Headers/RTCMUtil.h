//
//  RTCMUtil.h
//  LiteRTK
//
//  Created by iband on 2022/1/27.
//  Copyright © 2022 武汉桓参工程科技有限公司. All rights reserved.
//  RTCM基站处理库

#import <Foundation/Foundation.h>
#import "StationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTCMUtil : NSObject
/// data: 从千寻获取到的差分数据
- (nullable StationModel *)getStationModelFromData:(NSData *)data;

/// 过滤差分数据
- (NSData *)getFilteredRTCMInfoFromData:(NSData *)data;

/// data：收到的rtcm数据
- (NSInteger)getMsgNumFromData:(NSData *)data;


@end

NS_ASSUME_NONNULL_END
