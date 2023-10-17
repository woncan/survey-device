//
//  HCDeviceInfoModel.h
//  LiteRTK
//
//  Created by Woncan on 2023/8/2.
//  Copyright © 2023 武汉桓参工程科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCDeviceVerInfoModel : NSObject
/// 产品名称（英文）
@property (nonatomic, copy) NSString *nameEN;
/// 产品名称（中文）
@property (nonatomic, assign) NSString *nameZH;
/// 产品型号（SN号）
@property (nonatomic, copy) NSString *model;
/// 设备序列号
@property (nonatomic, copy) NSString *serialNum;
/// 设备ID
@property (nonatomic, copy) NSString *deviceID;
/// 设备固件版本
@property (nonatomic, copy) NSString *firmwareVer;
/// 设备硬件版本
@property (nonatomic, copy) NSString *hardwareVer;
@end

NS_ASSUME_NONNULL_END
