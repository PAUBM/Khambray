//
//  MotionDnaManager.m
//  reactNativeHelloworld
//
//  Created by James Grantham on 3/14/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "MotionDnaReactBridge.h"

@implementation MotionDnaReactBridge
RCT_EXPORT_MODULE();

- (instancetype)init {
  if (self = [super init]) {

  }
  return self;
}

- (NSDictionary *)constantsToExport
{
  return @{ @"statusBarAnimationNone" : @(UIStatusBarAnimationNone),
            @"statusBarAnimationFade" : @(UIStatusBarAnimationFade),
            @"statusBarAnimationSlide" : @(UIStatusBarAnimationSlide) };
};

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"MotionDnaEvent"];
}

+ (BOOL)requiresMainQueueSetup
{
  return YES;
}

-(void)receiveMotionDna:(MotionDna*)motionDna {
  NSLog(@"Calling motionDNA");
//  -(Location)getLocation;
//  -(Location)getGPSLocation;
//  -(Attitude)getAttitude;
//  -(Motion)getMotion;
//  -(CalibrationStatus)getCalibrationStatus;
//  -(NSString*)getID;
//  -(NSString*)getDeviceName;
//  -(MotionStatistics)getMotionStatistics;
//  -(MotionStatistics)getPolygonMotionStatistics;
//  -(OrientationQuaternion)getQuaternion;
//  -(XY)getDebugVector;
  Location location = [motionDna getLocation];
  XYZ localLocation = location.localLocation;
  double heading = location.localHeading;
  Motion motion = [motionDna getMotion];
  
  NSString *motionDNAString = [NSString stringWithFormat:@"X:%.2f Y:%.2f Z:%.2f\nHeading:%.2f\nMotion: %@",localLocation.x,localLocation.y,localLocation.z,heading,[self NSStringFromMotionType:motion.motionType]];
//  NSLog(@"MotionDNA DATA\n%@",motionDNAString);
  NSDictionary *motionDnaDictionary = @{@"MotionDnaString": motionDNAString,
                                        @"location_localLocation_x":@([motionDna getLocation].localLocation.x),
                                        @"location_localLocation_y":@([motionDna getLocation].localLocation.y),
                                        @"location_localLocation_z":@([motionDna getLocation].localLocation.z),
                                        @"location_localHeading":@([motionDna getLocation].localHeading),
                                        @"motion_motionType":[self NSStringFromMotionType:[motionDna getMotion].motionType]
                                        };
  [self sendEventWithName:@"MotionDnaEvent" body:motionDnaDictionary];

}

- (void)reportError:(ErrorCode)error WithMessage:(NSString *)message {
  
}


- (NSString *)NSStringFromMotionType:(MotionType)mt {
  switch (mt) {
    case STATIONARY:
      return @"STATIONARY";
      break;
    case FIDGETING:
      return @"FIDGETING";
      break;
    case FORWARD:
      return @"FORWARD";
    default:
      break;
  }
  return nil;
}

RCT_EXPORT_METHOD(runMotionDna:(NSString*)key)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    _motionDnaManager = [[MotionDnaManager alloc] init];
    [_motionDnaManager runMotionDna:key];
    _motionDnaManager.controller = self;
  });
}

RCT_EXPORT_METHOD(receiveNetworkData:(MotionDna*)motionDna)
{
  [_motionDnaManager receiveNetworkData:motionDna];
}
//-(void)receiveNetworkData:(NetworkCode)opcode WithPayload:(NSDictionary*)payload;

RCT_EXPORT_METHOD(runMotionDnaWithoutMotionManager:(NSString*)ID)
{
  [_motionDnaManager runMotionDnaWithoutMotionManager:ID];
}

//-(void)reportError:(ErrorCode)error WithMessage:(NSString*)message;
//RCT_EXPORT_METHOD(receiveDeviceMotion:(CMDeviceMotion*)deviceMotion)
//{
//  [_motionDnaManager receiveDeviceMotion:deviceMotion];
//}

RCT_EXPORT_METHOD(setFloorNumber:(int)floor)
{
  [_motionDnaManager setFloorNumber:floor];
}

RCT_EXPORT_METHOD(setLocationLatitude:(double)latitude Longitude:(double)longitude AndHeadingInDegrees:(double)heading)
{
  [_motionDnaManager setLocationLatitude:latitude Longitude:longitude AndHeadingInDegrees:heading];
}

RCT_EXPORT_METHOD(setLocationAndHeadingGPSMag)
{
  [_motionDnaManager setLocationAndHeadingGPSMag];
}

RCT_EXPORT_METHOD(setLocationLatitude:(double)latitude Longitude:(double)longitude)
{
  [_motionDnaManager setLocationLatitude:latitude Longitude:longitude];
}

RCT_EXPORT_METHOD(setLocationGPSOnly)
{
  [_motionDnaManager setLocationGPSOnly];
}
RCT_EXPORT_METHOD(setHeadingMagInDegrees)
{
  [_motionDnaManager setHeadingMagInDegrees];
}
RCT_EXPORT_METHOD(setHeadingInDegrees:(double)heading)
{
  [_motionDnaManager setHeadingInDegrees:heading];
}
RCT_EXPORT_METHOD(setLocationBeacon)
{
  [_motionDnaManager setLocationBeacon];
}
RCT_EXPORT_METHOD(setLocationNavisens)
{
  [_motionDnaManager setLocationNavisens];
}

RCT_EXPORT_METHOD(pause)
{
  [_motionDnaManager pause];
}
RCT_EXPORT_METHOD(resume)
{
  [_motionDnaManager resume];
}

RCT_EXPORT_METHOD(startCalibration)
{
  [_motionDnaManager startCalibration];
}

RCT_EXPORT_METHOD(stop)
{
  [_motionDnaManager stop];
}

//+(NSString*)checkSDKVersion;
//-(NSString*)getDeviceID;
//-(NSString*)getDeviceName;

RCT_EXPORT_METHOD(setMapCorrectionEnabled:(BOOL)state)
{
  [_motionDnaManager setMapCorrectionEnabled:state];
}

RCT_EXPORT_METHOD(setCallbackUpdateRateInMs:(double)rate)
{
  [_motionDnaManager setCallbackUpdateRateInMs:rate];
}

RCT_EXPORT_METHOD(setNetworkUpdateRateInMs:(double)rate)
{
  [_motionDnaManager setNetworkUpdateRateInMs:rate];
}

RCT_EXPORT_METHOD(setBinaryFileLoggingEnabled:(BOOL)state)
{
  [_motionDnaManager setBinaryFileLoggingEnabled:state];
}

RCT_EXPORT_METHOD(setExternalPositioningState:(NSString*)state)
{
//  OFF,
//  HIGH_ACCURACY,
//  LOW_ACCURACY,
//  EXTERNAL_UNDEFINED
  if ([state isEqualToString:@"OFF"]) {
    [_motionDnaManager setExternalPositioningState:OFF];
    NSLog(@"Entering %@ mode",state);
  }
  if ([state isEqualToString:@"HIGH_ACCURACY"]) {
    [_motionDnaManager setExternalPositioningState:HIGH_ACCURACY];
    NSLog(@"Entering %@ mode",state);
  }
  if ([state isEqualToString:@"LOW_ACCURACY"]) {
    [_motionDnaManager setExternalPositioningState:LOW_ACCURACY];
    NSLog(@"Entering %@ mode",state);
  }
  else {
    NSLog(@"UNDEFINED");
    [_motionDnaManager setExternalPositioningState:EXTERNAL_UNDEFINED];
  }
}

RCT_EXPORT_METHOD(startUDPRoom:(NSString*)room AtHost:(NSString*)host AndPort:(NSString*)port)
{
  [_motionDnaManager startUDPRoom:room AtHost:host AndPort:port];
}

RCT_EXPORT_METHOD(startUDPHost:(NSString*)host AndPort:(NSString*)port)
{
  [_motionDnaManager startUDPHost:host AndPort:port];
}

RCT_EXPORT_METHOD(startUDPRoom:(NSString*)room)
{
  [_motionDnaManager startUDPRoom:room];
}

RCT_EXPORT_METHOD(startUDP)
{
  [_motionDnaManager startUDP];
}
                  
RCT_EXPORT_METHOD(stopUDP)
{
  [_motionDnaManager stopUDP];
}

RCT_EXPORT_METHOD(setUDPRoom:(NSString*)room)
{
  [_motionDnaManager setUDPRoom:room];
}

RCT_EXPORT_METHOD(sendUDPPacket:(NSString*)msg)
{
  [_motionDnaManager sendUDPPacket:msg];
}

RCT_EXPORT_METHOD(sendUDPQueryRooms:(NSMutableArray*)rooms)
{
  [_motionDnaManager sendUDPQueryRooms:rooms];
}

RCT_EXPORT_METHOD(setBackgroundModeEnabled:(BOOL)state)
{
  [_motionDnaManager setBackgroundModeEnabled:state];
}

RCT_EXPORT_METHOD(logBeaconWithName:(NSString*)name ID:(NSString*)id RSSI:(int)RSSI andTimestamp:(double)timestamp)
{
  [_motionDnaManager logBeaconWithName:name ID:id RSSI:RSSI andTimestamp:timestamp];
}

RCT_EXPORT_METHOD(setBeaconRangingEnabled:(BOOL)state)
{
  [_motionDnaManager setBeaconRangingEnabled:state];
}

RCT_EXPORT_METHOD(setBeaconCorrectionsEnabled:(BOOL)state)
{
  [_motionDnaManager setBeaconCorrectionsEnabled:state];
}

RCT_EXPORT_METHOD(removeBeaconRegionWithUUID:(NSUUID *)proximityUUID andIdentifier:(NSString*)identifierForVendor)
{
  [_motionDnaManager removeBeaconRegionWithUUID:proximityUUID andIdentifier:identifierForVendor];
}

RCT_EXPORT_METHOD(registerBeaconRegionWithUUID:(NSUUID *)proximityUUID andIdentifier:(NSString*)identifier)
{
  [_motionDnaManager registerBeaconRegionWithUUID:proximityUUID andIdentifier:identifier];
}
//-(BOOL)isRangingBLE;

RCT_EXPORT_METHOD(setPowerMode:(NSString *)mode)
{
  if ([mode isEqualToString:@"SUPER_LOW_CONSUMPTION"]) {
    [_motionDnaManager setPowerMode:SUPER_LOW_CONSUMPTION];
    NSLog(@"Entering %@ mode",mode);

  }
  else if ([mode isEqualToString:@"LOW_CONSUMPTION"]) {
    [_motionDnaManager setPowerMode:LOW_CONSUMPTION];
    NSLog(@"Entering %@ mode",mode);
  }
  else if ([mode isEqualToString:@"MEDIUM_CONSUMPTION"]) {
    [_motionDnaManager setPowerMode:MEDIUM_CONSUMPTION];
    NSLog(@"Entering %@ mode",mode);

  }
  else if ([mode isEqualToString:@"PERFORMANCE"]) {
    [_motionDnaManager setPowerMode:PERFORMANCE];
    NSLog(@"Entering %@ mode",mode);

  } else {
    NSLog(@"%@ mode is invalid",mode);
  }
}

RCT_EXPORT_METHOD(setVehicleModeEnabled:(BOOL)state)
{
  [_motionDnaManager setVehicleModeEnabled:state];
}

RCT_EXPORT_METHOD(setTransportAutoswitchModeEnabled:(BOOL)state)
{
  [_motionDnaManager setTransportAutoswitchModeEnabled:state];
}

RCT_EXPORT_METHOD(setLocalHeadingOffsetInDegrees:(double)hdg)
{
  [_motionDnaManager setLocalHeadingOffsetInDegrees:hdg];
}

RCT_EXPORT_METHOD(setCartesianOffsetInMetersX:(double)x Y:(double)y)
{
  [_motionDnaManager setCartesianOffsetInMetersX:x Y:y];
}

RCT_EXPORT_METHOD(setARModeEnabled:(BOOL)state)
{
  [_motionDnaManager setARModeEnabled:state];
}

RCT_EXPORT_METHOD(setEstimationMode:(EstimationMode)mode)
{
  [_motionDnaManager setEstimationMode:mode];
}

RCT_EXPORT_METHOD(resetLocalEstimation)
{
  [_motionDnaManager resetLocalEstimation];
}

RCT_EXPORT_METHOD(enableBackgroundSensors)
{
  [_motionDnaManager enableBackgroundSensors];
}

RCT_EXPORT_METHOD(start)
{
  //[_motionDnaManager setLocationAndHeadingGPSMag];
  //[_motionDnaManager setLocationNavisens];
  //    [_motionDnaManager setExternalPositioningState:LOW_ACCURACY];
  
  [_motionDnaManager setBackgroundModeEnabled:YES];
  [_motionDnaManager setCallbackUpdateRateInMs:100];
  [_motionDnaManager setNetworkUpdateRateInMs:100];
  [_motionDnaManager setExternalPositioningState:HIGH_ACCURACY];
}

@end
