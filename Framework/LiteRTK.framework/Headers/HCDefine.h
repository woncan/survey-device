//
//  HCDefine.h
//  LiteRTK
//
//  Created by iband on 2023/4/12.
//  Copyright © 2023 武汉桓参工程科技有限公司. All rights reserved.
//

#ifndef HCDefine_h
#define HCDefine_h
#import "HCDeviceInfoBaseModel.h"

/// 设备类型
typedef NS_ENUM(NSUInteger, HCDeviceType) {
    BleRTK = 1,     // 蓝牙RTK
    NetRTK,         // 带网络功能的RTK
    EaRTK,          // 带EA(ExternalAccessory)串口功能的RTK
    None            // 未连接
};

/// NMEA类型
typedef NS_ENUM(NSUInteger, NmeaType) {
    NmeaGGA = 1,
    NmeaGSV,
    NmeaGSA,
    NmeaRMC,
    NmeaVTG,
    NmeaZDA
};

/// 设备连接出错的枚举类型
typedef NS_ENUM(NSUInteger, HCStatusError) {
    UnsupportedDeviceType = 1,     // 不支持的设备类型
    BleUnauthorized,               // 未获取到蓝牙权限
    BlePoweredOff,               // 蓝牙模块未开启
    Unknown                        // 未知类型错误
};

@protocol HCUtilDelegate <NSObject>

@optional
/// 设备已连接
- (void)hcDeviceConnected:(NSInteger)index;
/// 设备断开连接
- (void)hcDeviceDisconnected;
/// 固件更新完成
- (void)hcDevicefirwarmUpdateComplelte;
/// 设备连接出错了
- (void)hcDeviceDidFailWithError:(HCStatusError)error;
/// 搜索结果。deviceNameList：设备列表，isDone：搜索是否结束 true：结束，false：未结束，持续的返回结果
- (void)hcSearchResult:(NSArray <NSString *>*)deviceNameList isDone:(BOOL)isDone;

/// 收到RTK数据（基类输出）
- (void)hcReceiveDeviceInfoBaseModel:(HCDeviceInfoBaseModel *)deviceInfoBaseModel;
/// 收到RTCM数据
- (void)hcReceiveRTCMData:(NSData *)data;
/// 收到UBX数据
- (void)hcReceiveUBXData:(NSData *)data;
/// 收到基站数据
- (void)hcReceiveStationModel:(StationModel *)stationModel;
/// 收到NMEA数据
- (void)hcReceiveNmeaString:(NSString *)nmeaString;
/// 固件更新预计时间
- (void)hcReceiveUpdateFirwarmTime:(float)time;
/// 收到RSSI查询结果
- (void)hcReceiveRSSIResponse:(int)response;
/// 收到4G网络差分登录结果
- (void)hcReceiveNtripLoginResponse:(NSString *)response;
@end

#endif /* HCDefine_h */
