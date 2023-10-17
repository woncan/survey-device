//
//  RTKController.h
//  LiteRTK
//
//  Created by iband on 2021/6/10.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HCUtil;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RTCMType) {
    rtcm1074 = 1000,
    rtcm1087,
    rtcm1094,
    rtcm1124,
    rtcmTime,
    rtcmSfr
};

@interface RTKController : NSObject

/**
 发送RTK指令
 */
+ (void)sendDatas:(NSArray<NSData *> *)datas toUtil:(HCUtil *)util;

/**
 设置频率
 interval: 间隔的毫秒数，例：5000=5秒一次   2000=2秒一次
 */
+ (void)setFrequency:(NSUInteger)interval toUtil:(HCUtil *)util;

/**
 开启日志
 */
+ (void)setLoggerOntoUtil:(HCUtil *)util;

/**
 设置高度角，0-90度
 */
+ (void)setHeightAngle:(NSUInteger)angle toUtil:(HCUtil *)util;

/**
 设置激光状态(开启|关闭)
 */
+ (void)setLaserState:(BOOL)isOn toUtil:(HCUtil *)util;

/**
 获取设置频率的data
 */
+ (NSData *)getFrequencyData:(NSInteger)interval;

/**
 获取设置激光的data
 */
+ (NSData *)getLaserData:(BOOL)isOn;

/**
 获取日志开的data
 */
+ (NSData *)getLoggerData;

///------------------RTCM静态采集设置----------------------
/**
 开始RTCM记录
*/
+ (void)startRTCMReadingWithType:(RTCMType)type toUtil:(HCUtil *)util;

/**
 停止RTCM记录
 */
+ (void)stopRTCMReadingToUtil:(HCUtil *)util;

/**
 转换rtcm文件，返回转换后的文件路径
 */
+ (nullable NSString *)convertRTCMFromPath:(NSString *)fromPath version:(NSString *)version earthXYZ:(NSArray *)earthXYZ pointName:(NSString *)pointName;

/**
 转换sfr文件，返回转换后的文件路径
 */
+ (nullable NSString *)convertSfrFromPath:(NSString *)fromPath version:(NSString *)version;

@end

NS_ASSUME_NONNULL_END
