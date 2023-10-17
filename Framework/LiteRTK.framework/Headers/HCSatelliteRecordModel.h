//
//  HCSatelliteRecordModel.h
//  LiteRTK
//
//  Created by iband on 2023/3/6.
//  Copyright © 2023 武汉桓参工程科技有限公司. All rights reserved.
//  卫星数据

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCSatelliteRecordModel : NSObject

/// 卫星号
@property (nonatomic, copy) NSString *sigID;

@property (nonatomic, assign) NSInteger gnssIndex;

@property (nonatomic, copy) NSString *l1Text;

@property (nonatomic, copy) NSString *l2Text;

@property (nonatomic, copy) NSString *l5Text;

/// 高度角
@property (nonatomic, copy) NSString *elev;

/// 方位角
@property (nonatomic, copy) NSString *azi;

@end

NS_ASSUME_NONNULL_END
