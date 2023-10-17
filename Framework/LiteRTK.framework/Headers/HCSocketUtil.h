//
//  HCSocketUtil.h
//  LiteRTK
//
//  Created by iband on 2021/6/3.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//  tcp连接库

#import <Foundation/Foundation.h>
#import "HCDiffModel.h"

NS_ASSUME_NONNULL_BEGIN

#define HCNotNull(obj)    ((obj == nil || obj == NULL) ? @"" : obj)

@class HCSocketUtil;
@protocol HCSocketUtilDelegate <NSObject>

@optional
/// 登录成功
- (void)loginSuccess:(HCSocketUtil *)socketUtil;
/// 登录失败
- (void)loginFailure:(HCSocketUtil *)socketUtil error:(nullable NSError *)error;
/// 写数据成功
- (void)didWriteDataSuccess:(HCSocketUtil *)socketUtil;
/// 获取到挂载点
- (void)didGetMountPointsSuccess:(HCSocketUtil *)socketUtil;
/// 获取到差分数据
- (void)didReadDiffDataSuccess:(NSArray<NSData *> *)datas socketUtil:(HCSocketUtil *)socketUtil;
/// 获取到原始的差分数据，不做分包处理
- (void)didReadOriginDiffDataSuccess:(NSData *)data socketUtil:(HCSocketUtil *)socketUtil;

@end

@interface HCSocketUtil : NSObject

@property (nonatomic, weak) id<HCSocketUtilDelegate> delegate;

@property (nonatomic, retain, readonly) HCDiffModel *diffModel;

@property (nonatomic, retain) NSString *deviceNum;
/// 是否允许分包
@property (nonatomic, assign) BOOL enableMorePackages;
//
///// 返回原始的差分数据，做分包处理
//@property (nonatomic, assign) BOOL returnOriginDiffDataAndPackage;

+ (instancetype)shared;

/// 注册IP和端口号
- (void)registerIP:(NSString *)ip port:(NSInteger)port;

/// 替换model
- (void)replaceDiffModel:(HCDiffModel *)diffModel;

/// 登录
- (void)toLogin;

/// 网络差分登录
- (void)toLoginWithHost:(NSString *)host port:(NSInteger)port;
/// 发送网络差分心跳包
- (void)sendHeartPackage;

/// 获取挂载点
- (void)getMountPoints;

/// 发送文本型数据，自动转data
- (void)sendData:(NSString *)text;

/// 是否已经连接
- (BOOL)isConnected;

/// 断开连接
- (void)disconnect;

/// 销毁实例
- (void)destroy;

/// 获取字符串转换后的数据
- (NSData *)getDataFromText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
