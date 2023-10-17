//
//  HCDeviceInfoBaseModel.h
//  LiteRTK
//
//  Created by iband on 2023/1/30.
//  Copyright © 2023 武汉桓参工程科技有限公司. All rights reserved.
//  设备基本信息

#import <Foundation/Foundation.h>
#import "HCSatelliteRecordModel.h"
#import "StationModel.h"
#import "HCDeviceVerInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HCDeviceInfoBaseModel : NSObject

/// GPS数量
@property (nonatomic, copy) NSString *gpsCount;
@property (nonatomic, assign) uint8_t nSatsInUse;
@property (nonatomic, assign) uint8_t nSatsInView;
/// 水平精度
@property (nonatomic, copy) NSString *Dxy;
/// 垂直精度
@property (nonatomic, copy) NSString *Dz;
/// 定位状态原始值
@property (nonatomic, assign) NSInteger gpsLevelValue;
/// 定位状态
@property (nonatomic, copy) NSString *gpsLevel;
/// 经度方位
@property (nonatomic, copy) NSString *longitudeDiretion;
/// 经度
@property (nonatomic, copy) NSString *longitude;
/// 纬度方位
@property (nonatomic, copy) NSString *latitudeDirection;
/// 纬度
@property (nonatomic, copy) NSString *latitude;
/// 海拔
@property (nonatomic, assign) double height;
/// 高程异常值
@property (nonatomic, assign) double altitudeExceptionValue;
/// 电量
@property (nonatomic, copy) NSString *electricity;
/// 加速度
@property (nonatomic, copy) NSArray<NSString *> *accelerationList;
/// 角速度
@property (nonatomic, copy) NSArray<NSString *> *angularVelocityList;
/// NEMA原始数据，在获取差分数据时需要用到
@property (nonatomic, copy) NSString *nmeaSourceText;
/// 差分延时
@property (nonatomic, copy) NSString *diffDelayTime;
/// HDOP水平精度因子
@property (nonatomic, copy) NSString *hdop;
/// VDOP垂直精度因子
@property (nonatomic, copy) NSString *vdop;
/// PDOP位置精度因子
@property (nonatomic, copy) NSString *pdop;
/// UTC时间
@property (nonatomic, copy) NSString *UTC;
/// 创建时间
@property (nonatomic, strong) NSDate *createTime;
/// 卫星数据
@property (nonatomic, strong) NSMutableArray<HCSatelliteRecordModel *> *satelliteRecordModelList;
@property (nonatomic, strong) HCDeviceVerInfoModel *deviceInfoModel;

- (instancetype)initWithModel:(HCDeviceInfoBaseModel *)model;

@end

NS_ASSUME_NONNULL_END
