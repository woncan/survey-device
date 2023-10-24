//
//  HCUtil.h
//  LiteRTK
//
//  Created by iband on 2023/3/30.
//  Copyright © 2023 武汉桓参工程科技有限公司. All rights reserved.
//  桓参RTK库
//  支持的类型：旧RTK、新RTK（蓝牙、4G或串口连接）、苹果移动设备

#import <Foundation/Foundation.h>
#import "HCDefine.h"

NS_ASSUME_NONNULL_BEGIN

/// HCUtil代理类。反馈与各种RTK设备的连接状态，回传接收到的数据。
/// 方向：RTK(发送) -> iPhone/iPad(接收)
@class HCDeviceInfoBaseModel;
@class StationModel;

@interface HCUtil : NSObject

@property (nonatomic, weak) id<HCUtilDelegate> delegate;
/// 是否记录并传回卫星数据。false: 不回传 HCDeviceInfoBaseModel 中的 satelliteRecordModelList 参数
@property (nonatomic, assign) BOOL enableSatelliteRecord;
/// 是否自带差分服务
@property (nonatomic, assign, readonly) BOOL hasDeviceDiff;
/// 是否连接上了设备自带差分连接
@property (nonatomic, assign, readonly) BOOL isConnectDeviceDiff;
/// 连接上的设备类型
@property (nonatomic, assign, readonly) HCDeviceType deviceType;
/// 设备索引
@property (nonatomic, assign, readonly) NSInteger deviceIndex;
/// 差分坐标类型（使用设备自带差分时配置，其他情况下忽略）
@property (nonatomic, assign) HCCoordType coordType;
/// 注册代理
/// - Parameter delegate: HCUtilDelegate
- (instancetype)initWithDelegate:(id<HCUtilDelegate>)delegate;

/// 搜索设备
/// 在连接前都需要先搜索设备，返回参考 hcSearchResult 回调方法
/// - Parameter deviceType: HCDeviceType
- (void)toSearchDeviceWithType:(HCDeviceType)deviceType;

/// 连接设备
/// OldRTK、NewRTK：需要先搜索再连接，然后通过蓝牙收发数据
/// NetRTK：通过蓝牙搜索并连接上，然后配置相关参数。完成后设备重启，客户端再通过TCP接收后台返回的差分数据
/// EaRTK：通过串口连接收发数据
/// - Parameter index: index为选中的RTK设备索引，通过EaRTK调用时将忽略该值
- (void)toConnectDevice:(NSInteger)index;

/// 断开连接
- (void)toDisconnect;

/// 发送数据
/// - Parameter data: NSData
- (void)toSendData:(NSData *)data;

/// 新设备开关激光
/// - Parameter laserState: YES.开 NO.关
- (void)setLaserState:(BOOL)laserState;

/// 发送多包数据
/// - Parameter datas: 数据包
- (void)toSendDatas:(NSArray <NSData *>*)datas;

/// 停止设备自带差分
- (void)toDisconnectDeviceDiff;
/// 连接设备自带差分
- (void)toConnectDeviceDiff;

// ----------------------------仅isNewBle的RTK可以调用----------------------------
/// 是否使能NMEA输出，enable：true开，false关。nmeaType：掩码白名单
- (void)setNMEAOutputState:(BOOL)enable withNmeaType:(NmeaType)nmeaType;
/// 是否使能RTCM输出，enable：true开，false关。rtcmMsgNum：RTCM信息编号
- (void)setRTCMOutputState:(BOOL)enable withMsgNum:(NSInteger)rtcmMsgNum;
/// 是否使能RTCM输出，enable：true开，false关。msgNumList信息编号数组
- (void)setRTCMOutputState:(BOOL)enable withMsgNumList:(NSArray *)msgNumList;
- (BOOL)isNewBle;
@end

NS_ASSUME_NONNULL_END
