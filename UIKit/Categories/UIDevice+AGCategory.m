//
//  UIDevice+AGCategory.m
//  AGFoundation
//
//  Created by Andrew Garn on 19/04/2012.
//  Copyright (c) 2012 Andrew Garn. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "UIDevice+AGCategory.h"
#import "NSNumber+AGCategory.h"
#import "NSString+AGCategory.h"

#include <sys/utsname.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <mach/mach.h>

#ifdef AGFOUNDATION_FRAMEWORK
FIX_CATEGORY_BUG(UIDevice_AGCategory);
#endif

#ifndef kUTTypeMovie
#define kUTTypeMovie @"public.movie"
#endif

// http://theiphonewiki.com/wiki/iPhone
// http://theiphonewiki.com/wiki/iPod_touch
// http://theiphonewiki.com/wiki/iPad
// http://theiphonewiki.com/wiki/iPad_mini
// http://everymac.com/ultimate-mac-lookup

@implementation UIDevice (AGCategory)

#pragma mark - Device Info

+ (NSString *)deviceModel_AG
{
    static dispatch_once_t token;
	static NSString *deviceModel;
    
	dispatch_once(&token, ^{
        
        /* Get Platform */
        NSString *platform = [self platform_AG];
        
        /* iPhone */
        if ([platform isEqualToString:@"iPhone1,1"])         deviceModel = @"iPhone";
        else if ([platform isEqualToString:@"iPhone1,2"])    deviceModel = @"iPhone 3G";
        else if ([platform hasPrefix:@"iPhone2"])            deviceModel = @"iPhone 3GS";
        else if ([platform isEqualToString:@"iPhone3,1"])    deviceModel = @"iPhone 4 (GSM)";
        else if ([platform isEqualToString:@"iPhone3,2"])    deviceModel = @"iPhone 4 (GSM) (Rev A)";
        else if ([platform isEqualToString:@"iPhone3,3"])    deviceModel = @"iPhone 4 (CDMA)";
        else if ([platform hasPrefix:@"iPhone4"])            deviceModel = @"iPhone 4S";
        else if ([platform isEqualToString:@"iPhone5,1"])    deviceModel = @"iPhone 5 (GSM)";
        else if ([platform isEqualToString:@"iPhone5,2"])    deviceModel = @"iPhone 5 (GSM+CDMA)";
        else if ([platform isEqualToString:@"iPhone5,3"])    deviceModel = @"iPhone 5c (GSM)";
        else if ([platform isEqualToString:@"iPhone5,4"])    deviceModel = @"iPhone 5c (GSM+CDMA)";
        else if ([platform isEqualToString:@"iPhone6,1"])    deviceModel = @"iPhone 5s (GSM)";
        else if ([platform isEqualToString:@"iPhone6,2"])    deviceModel = @"iPhone 5s (GSM+CDMA)";
        
        /* iPod Touch */
        else if ([platform hasPrefix:@"iPod1"])              deviceModel = @"iPod touch 1G";
        else if ([platform hasPrefix:@"iPod2"])              deviceModel = @"iPod touch 2G";
        else if ([platform hasPrefix:@"iPod3"])              deviceModel = @"iPod touch 3G";
        else if ([platform hasPrefix:@"iPod4"])              deviceModel = @"iPod touch 4G";
        else if ([platform hasPrefix:@"iPod5"])              deviceModel = @"iPod touch 5G";
        else if ([platform hasPrefix:@"iPod6"])              deviceModel = @"iPod touch 6G";
        
        /* iPad */
        else if ([platform isEqualToString:@"iPad1,1"])      deviceModel = @"iPad Wi-Fi";
        else if ([platform isEqualToString:@"iPad2,1"])      deviceModel = @"iPad 2 Wi-Fi";
        else if ([platform isEqualToString:@"iPad2,2"])      deviceModel = @"iPad 2 Wi-Fi + 3G (GSM)";
        else if ([platform isEqualToString:@"iPad2,3"])      deviceModel = @"iPad 2 Wi-Fi + 3G (CDMA)";
        else if ([platform isEqualToString:@"iPad2,4"])      deviceModel = @"iPad 2 Wi-Fi (Rev A)";
        else if ([platform isEqualToString:@"iPad2,5"])      deviceModel = @"iPad mini Wi-Fi";
        else if ([platform isEqualToString:@"iPad2,6"])      deviceModel = @"iPad mini Wi-Fi + 4G (GSM)";
        else if ([platform isEqualToString:@"iPad2,7"])      deviceModel = @"iPad mini Wi-Fi + 4G (GSM+CDMA)";
        else if ([platform isEqualToString:@"iPad3,1"])      deviceModel = @"iPad 3 Wi-Fi";
        else if ([platform isEqualToString:@"iPad3,2"])      deviceModel = @"iPad 3 Wi-Fi + 4G (GSM+CDMA)";
        else if ([platform isEqualToString:@"iPad3,3"])      deviceModel = @"iPad 3 Wi-Fi + 4G (GSM)";
        else if ([platform isEqualToString:@"iPad3,4"])      deviceModel = @"iPad 4 Wi-Fi";
        else if ([platform isEqualToString:@"iPad3,5"])      deviceModel = @"iPad 4 Wi-Fi + 4G (GSM)";
        else if ([platform isEqualToString:@"iPad3,6"])      deviceModel = @"iPad 4 Wi-Fi + 4G (GSM+CDMA)";
        else if ([platform isEqualToString:@"iPad4,1"])      deviceModel = @"iPad Air WiFi";
        else if ([platform isEqualToString:@"iPad4,2"])      deviceModel = @"iPad Air WiFi + 4G";
        else if ([platform isEqualToString:@"iPad4,4"])      deviceModel = @"iPad mini 2 WiFi";
        else if ([platform isEqualToString:@"iPad4,5"])      deviceModel = @"iPad mini 2 WiFi + 4G";
        
        /* Simulator */
        else if ([UIDevice isASimulator_AG]) {
            if ([[UIScreen mainScreen] bounds].size.width < 768) {
                if ([UIDevice hasRetinaDisplay_AG]) {
                    if ([[UIScreen mainScreen] bounds].size.height == 568) {
                        deviceModel = @"iPhone Simulator (Retina 4-inch)";
                    } else if ([[UIScreen mainScreen] bounds].size.height == 480) {
                        deviceModel = @"iPhone Simulator (Retina 3.5-inch)";
                    } else {
                        deviceModel = @"iPhone Simulator (Retina)";
                    }
                } else {
                    deviceModel = @"iPhone Simulator";
                }
            } else {
                if ([UIDevice hasRetinaDisplay_AG]) {
                    deviceModel = @"iPad Simulator (Retina)";
                } else {
                    deviceModel = @"iPad Simulator";
                }
            }
        }
        
        /* Unknown */
        else deviceModel = platform;
        
	});
    return deviceModel;
}

+ (NSString *)deviceModelGeneric_AG
{
    static dispatch_once_t token;
	static NSString *deviceModel;
    
	dispatch_once(&token, ^{
        
        /* Get Platform */
        NSString *platform = [self platform_AG];
        
        /* iPhone */
        if ([platform isEqualToString:@"iPhone1,1"])         deviceModel = @"iPhone";
        else if ([platform isEqualToString:@"iPhone1,2"])    deviceModel = @"iPhone 3G";
        else if ([platform hasPrefix:@"iPhone2"])            deviceModel = @"iPhone 3GS";
        else if ([platform isEqualToString:@"iPhone3,1"])    deviceModel = @"iPhone 4";
        else if ([platform isEqualToString:@"iPhone3,2"])    deviceModel = @"iPhone 4";
        else if ([platform isEqualToString:@"iPhone3,3"])    deviceModel = @"iPhone 4";
        else if ([platform hasPrefix:@"iPhone4"])            deviceModel = @"iPhone 4S";
        else if ([platform isEqualToString:@"iPhone5,1"])    deviceModel = @"iPhone 5";
        else if ([platform isEqualToString:@"iPhone5,2"])    deviceModel = @"iPhone 5";
        else if ([platform isEqualToString:@"iPhone5,3"])    deviceModel = @"iPhone 5c";
        else if ([platform isEqualToString:@"iPhone5,4"])    deviceModel = @"iPhone 5c";
        else if ([platform isEqualToString:@"iPhone6,1"])    deviceModel = @"iPhone 5s";
        else if ([platform isEqualToString:@"iPhone6,2"])    deviceModel = @"iPhone 5s";
        
        /* iPod Touch */
        else if ([platform hasPrefix:@"iPod1"])              deviceModel = @"iPod touch 1G";
        else if ([platform hasPrefix:@"iPod2"])              deviceModel = @"iPod touch 2G";
        else if ([platform hasPrefix:@"iPod3"])              deviceModel = @"iPod touch 3G";
        else if ([platform hasPrefix:@"iPod4"])              deviceModel = @"iPod touch 4G";
        else if ([platform hasPrefix:@"iPod5"])              deviceModel = @"iPod touch 5G";
        else if ([platform hasPrefix:@"iPod6"])              deviceModel = @"iPod touch 6G";
        
        /* iPad */
        else if ([platform isEqualToString:@"iPad1,1"])      deviceModel = @"iPad";
        else if ([platform isEqualToString:@"iPad2,1"])      deviceModel = @"iPad 2";
        else if ([platform isEqualToString:@"iPad2,2"])      deviceModel = @"iPad 2";
        else if ([platform isEqualToString:@"iPad2,3"])      deviceModel = @"iPad 2";
        else if ([platform isEqualToString:@"iPad2,4"])      deviceModel = @"iPad 2";
        else if ([platform isEqualToString:@"iPad2,5"])      deviceModel = @"iPad mini";
        else if ([platform isEqualToString:@"iPad2,6"])      deviceModel = @"iPad mini";
        else if ([platform isEqualToString:@"iPad2,7"])      deviceModel = @"iPad mini";
        else if ([platform isEqualToString:@"iPad3,1"])      deviceModel = @"iPad 3";
        else if ([platform isEqualToString:@"iPad3,2"])      deviceModel = @"iPad 3";
        else if ([platform isEqualToString:@"iPad3,3"])      deviceModel = @"iPad 3";
        else if ([platform isEqualToString:@"iPad3,4"])      deviceModel = @"iPad 4";
        else if ([platform isEqualToString:@"iPad3,5"])      deviceModel = @"iPad 4";
        else if ([platform isEqualToString:@"iPad3,6"])      deviceModel = @"iPad 4";
        else if ([platform isEqualToString:@"iPad4,1"])      deviceModel = @"iPad Air";
        else if ([platform isEqualToString:@"iPad4,2"])      deviceModel = @"iPad Air";
        else if ([platform isEqualToString:@"iPad4,4"])      deviceModel = @"iPad mini 2";
        else if ([platform isEqualToString:@"iPad4,5"])      deviceModel = @"iPad mini 2";
        
        /* Simulator */
        else if ([UIDevice isASimulator_AG]) {
            if ([[UIScreen mainScreen] bounds].size.width < 768) {
                deviceModel = @"iPhone Simulator";
            } else {
                deviceModel = @"iPad Simulator";
            }
        }
        
        /* Unknown */
        else deviceModel = platform;
        
	});
    return deviceModel;
}

+ (BOOL)deviceModelIsRecognized_AIV
{
    NSString *platform = [self platform_AG];
    NSString *deviceModel = [self deviceModel_AG];
    if (![platform isEqualToString:deviceModel]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)deviceFamily_AG
{
    static dispatch_once_t token;
	static NSString *deviceFamily;
    
	dispatch_once(&token, ^{
        if ([UIDevice isAniPhone_AG]) {
             deviceFamily = @"iPhone";
        } else if ([UIDevice isAniPodTouch_AG]) {
            deviceFamily = @"iPod touch";
        } else if ([UIDevice isAniPadMini_AG]) {
            deviceFamily = @"iPad mini";
        } else if ([UIDevice isAniPad_AG]) {
            deviceFamily = @"iPad";
        } else if ([UIDevice isASimulator_AG]) {
            deviceFamily = @"Simulator";
        } else {
            deviceFamily = [[UIDevice currentDevice] model];
        }
	});
    return deviceFamily;
}

#ifdef __CORETELEPHONY_DEFINES_H__

//#import <CoreTelephony/CTTelephonyNetworkInfo.h>
//#import <CoreTelephony/CTCarrier.h>

+ (NSString *)deviceCarrier_AG
{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *cellularProvider = [networkInfo subscriberCellularProvider];
    NSString *carrierName = [cellularProvider carrierName];
    return carrierName;
}
#endif

#pragma mark - System Info

+ (NSString *)systemName_AG
{
    static dispatch_once_t token;
	static NSString *systemName;
    
	dispatch_once(&token, ^{
        systemName = [[UIDevice currentDevice] systemName];
	});
    return systemName;
}

+ (NSString *)systemVersion_AG
{
    static dispatch_once_t token;
	static NSString *systemVersion;
    
	dispatch_once(&token, ^{
        systemVersion = [[UIDevice currentDevice] systemVersion];
	});
    return systemVersion;
}

#pragma mark -

+ (BOOL)isAniPhone_AG
{
    static dispatch_once_t token;
	static BOOL isAniPhone = NO;
    
	dispatch_once(&token, ^{
        NSRange textRange = [[self platform_AG] rangeOfString:@"iPhone"];
        if(textRange.location != NSNotFound) {
            isAniPhone = YES;
        }
    });
	return isAniPhone;
}

+ (BOOL)isAniPodTouch_AG
{
    static dispatch_once_t token;
	static BOOL isAniPodTouch = NO;
    
	dispatch_once(&token, ^{
        NSRange textRange = [[self platform_AG] rangeOfString:@"iPod"];
        if(textRange.location != NSNotFound) {
            isAniPodTouch = YES;
        }
    });
	return isAniPodTouch;
}

+ (BOOL)isAniPadMini_AG
{
    static dispatch_once_t token;
	static BOOL isAniPadMini = NO;
    
	dispatch_once(&token, ^{
        NSRange textRange = [[self deviceModelGeneric_AG] rangeOfString:@"iPad mini"];
        if(textRange.location != NSNotFound) {
            isAniPadMini = YES;
        }
    });
	return isAniPadMini;
}

+ (BOOL)isAniPad_AG
{
    static dispatch_once_t token;
	static BOOL isAniPad = NO;
    
	dispatch_once(&token, ^{
        NSRange textRange = [[self platform_AG] rangeOfString:@"iPad"];
        if(textRange.location != NSNotFound) {
            isAniPad = YES;
        }
    });
	return isAniPad;
}

+ (BOOL)isASimulator_AG
{
    static dispatch_once_t token;
	static BOOL isASimulator = NO;
    
	dispatch_once(&token, ^{
        NSRange textRange = [[self platform_AG] rangeOfString:@"i386"];
        NSRange textRange2 = [[self platform_AG] rangeOfString:@"x86_64"];
        if (textRange.location != NSNotFound || textRange2.location != NSNotFound) {
            isASimulator = YES;
        }
    });
    return isASimulator;
}

#pragma mark -

+ (BOOL)hasRetinaDisplay_AG
{
    static dispatch_once_t token;
	static BOOL hasRetinaDisplay = NO;
    
	dispatch_once(&token, ^{
        if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
            if ([[UIScreen mainScreen] scale] == 2.0) {
                hasRetinaDisplay = YES;
            }
        }
    });
    return hasRetinaDisplay;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
+ (BOOL)hasCompass_AG
{
    static dispatch_once_t token;
	static BOOL headingAvailable = NO;
    
	dispatch_once(&token, ^{
        Class class = NSClassFromString(@"CLLocationManager");
        if (class != nil) headingAvailable = (BOOL)[class performSelector:@selector(headingAvailable)];
	});
    return headingAvailable;
}

+ (BOOL)hasGyroscope_AG
{
    static dispatch_once_t token;
	static BOOL isGyroAvailable = NO;
    
	dispatch_once(&token, ^{
        Class class = NSClassFromString(@"CMMotionManager");
        if (class != nil) isGyroAvailable = (BOOL)[[[class alloc] init] performSelector:@selector(isGyroAvailable)];
	});
    return isGyroAvailable;
}
#pragma clang diagnostic pop

+ (BOOL)hasCamera_AG
{
    static dispatch_once_t token;
	static BOOL hasCamera = NO;
    
	dispatch_once(&token, ^{
        hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
	});
    return hasCamera;
}

+ (BOOL)hasFrontCamera_AG
{
    static dispatch_once_t token;
	static BOOL hasFrontCamera = NO;
    
	dispatch_once(&token, ^{
        hasFrontCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
	});
    return hasFrontCamera;
}

+ (BOOL)hasRearCamera_AG
{
    static dispatch_once_t token;
	static BOOL hasRearCamera = NO;
    
	dispatch_once(&token, ^{
        hasRearCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
	});
    return hasRearCamera;
}

+ (BOOL)hasFrontFlash_AG
{
    static dispatch_once_t token;
	static BOOL hasFrontFlash = NO;
    
	dispatch_once(&token, ^{
        hasFrontFlash = [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceFront];
	});
    return hasFrontFlash;
}

+ (BOOL)hasRearFlash_AG
{
    static dispatch_once_t token;
	static BOOL hasRearFlash = NO;
    
	dispatch_once(&token, ^{
        hasRearFlash = [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear];
	});
    return hasRearFlash;
}

+ (BOOL)canRecordVideo_AG
{
    static dispatch_once_t token;
	static BOOL canRecordVideo = NO;
    
	dispatch_once(&token, ^{
        NSArray *mediaType = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([mediaType containsObject:(NSString *)kUTTypeMovie]) {
            canRecordVideo = YES;
        }
	});
    return canRecordVideo;
}

#pragma mark -

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
+ (BOOL)canSendMail_AG
{
    Class class = NSClassFromString(@"MFMailComposeViewController");
    if (class) return (BOOL)[class performSelector:@selector(canSendMail)];
    return NO;
}

+ (BOOL)canSendText_AG
{
    Class class = NSClassFromString(@"MFMessageComposeViewController");
    if (class) return (BOOL)[class performSelector:@selector(canSendText)];
    return NO;
}

+ (BOOL)canSendTweet_AG
{
    Class class = NSClassFromString(@"TWTweetComposeViewController");
    if (class) return (BOOL)[class performSelector:@selector(canSendTweet)];
    return NO;
}

+ (BOOL)canMakePayments_AG
{
    Class class = NSClassFromString(@"SKPaymentQueue");
    if (class) return (BOOL)[class performSelector:@selector(canMakePayments)];
    return NO;
}
#pragma clang diagnostic pop

+ (BOOL)supportsMultitasking_AG
{
    static dispatch_once_t token;
	static BOOL isMultitaskingSupported = NO;
    
	dispatch_once(&token, ^{
        isMultitaskingSupported = [[UIDevice currentDevice] isMultitaskingSupported];
	});
    return isMultitaskingSupported;
}

#pragma mark -

+ (UIUserInterfaceIdiom)userInterfaceIdiom_AG
{
    static dispatch_once_t token;
	static UIUserInterfaceIdiom userInterfaceIdiom;
    
	dispatch_once(&token, ^{
        userInterfaceIdiom = [[UIDevice currentDevice] userInterfaceIdiom];
	});
    return userInterfaceIdiom;
}

+ (BOOL)userInterfaceIdiomIsPhone_AG
{
    static dispatch_once_t token;
	static BOOL userInterfaceIdiomIsPhone = NO;
    
	dispatch_once(&token, ^{
        if ([UIDevice userInterfaceIdiom_AG] == UIUserInterfaceIdiomPhone) {
            userInterfaceIdiomIsPhone = YES;
        }
	});
    return userInterfaceIdiomIsPhone;
}

+ (BOOL)userInterfaceIdiomIsPad_AG
{
    static dispatch_once_t token;
	static BOOL userInterfaceIdiomIsPad = NO;
    
	dispatch_once(&token, ^{
        if ([UIDevice userInterfaceIdiom_AG] == UIUserInterfaceIdiomPad) {
            userInterfaceIdiomIsPad = YES;
        }
	});
    return userInterfaceIdiomIsPad;
}

+ (BOOL)userInterfaceIdiomIsPadMini_AG
{
    static dispatch_once_t token;
	static BOOL userInterfaceIdiomIsPadMini = NO;
    
	dispatch_once(&token, ^{
        if ([UIDevice userInterfaceIdiomIsPad_AG]) {
            NSString *platform = [self platform_AG];
            if ([platform isEqualToString:@"iPad2,5"]           // iPad mini Wi-Fi
                || [platform isEqualToString:@"iPad2,6"]        // iPad mini Wi-Fi + 4G (GSM)
                || [platform isEqualToString:@"iPad2,7"]        // iPad mini Wi-Fi + 4G (GSM+CDMA)
                || [platform isEqualToString:@"iPad4,4"]        // iPad mini 2 Wi-Fi
                || [platform isEqualToString:@"iPad4,5"]) {     // iPad mini 2 Wi-Fi + 4G
                userInterfaceIdiomIsPadMini = YES;
            }
        }
	});
    return userInterfaceIdiomIsPadMini;
}

#pragma mark -

+ (CGFloat)batteryLevel_AG
{
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    CGFloat currentBatteryLevel = [[UIDevice currentDevice] batteryLevel];
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:NO];
    return currentBatteryLevel;
}

+ (NSString *)batteryState_AG
{
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    
    NSString *batteryStateString = nil;
    UIDeviceBatteryState batteryState = [[UIDevice currentDevice] batteryState];
    switch (batteryState)
    {
        case UIDeviceBatteryStateUnknown:
            batteryStateString = NSLocalizedString(@"Unknown", @"");
            break;

        case UIDeviceBatteryStateUnplugged:
            batteryStateString = NSLocalizedString(@"Unplugged", @"");
            break;

        case UIDeviceBatteryStateCharging:
            batteryStateString = NSLocalizedString(@"Charging", @"");
            break;

        case UIDeviceBatteryStateFull:
            batteryStateString = NSLocalizedString(@"Full", @"");
            break;

        default:
            batteryStateString = NSLocalizedString(@"Unknown", @"");
            break;
    }
    
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:NO];
    return batteryStateString;
}

#pragma mark -

+ (BOOL)isJailbroken_AG
{
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    static dispatch_once_t onceToken;
	static BOOL isJailbroken = NO;
    
	dispatch_once(&onceToken, ^{
        NSString *cydiaPath = @"/Applications/Cydia.app";
        NSString *aptPath = @"/private/var/lib/apt/";
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
            isJailbroken = YES;
        } else if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
            isJailbroken = YES;
        } else {
            FILE *file = fopen("/bin/bash", "r");
            if (file != NULL) {
                isJailbroken = YES;
            }
            fclose(file);
        }
    });
    return isJailbroken;
#endif
}

+ (NSString *)jailbrokenState_AG
{
    static dispatch_once_t token;
	static NSString *jailbrokenState;
    
	dispatch_once(&token, ^{
        if ([UIDevice isJailbroken_AG]) {
            jailbrokenState = @"Jailbroken";
        } else {
            jailbrokenState = @"Not Jailbroken";
        }
    });
    return jailbrokenState;
}

#pragma mark -

+ (BOOL)isAntiquated_AIV
{
    static dispatch_once_t token;
	static BOOL isAntiquated = NO;
    
	dispatch_once(&token, ^{
        
        /* Get Platform */
        NSString *platform = [self platform_AG];
        
        if ([platform hasPrefix:@"iPod3"]               // iPod 3G
            || [platform hasPrefix:@"iPhone2"]          // iPhone 3GS
            || [platform isEqualToString:@"iPad1,1"]) { // iPad 1
            isAntiquated = YES;
        }
	});
    return isAntiquated;
}

#pragma mark -

/**
 *	Reference: https://github.com/erica/uidevice-extension
 */

+ (NSUInteger)cpuFrequency_AG
{
    return [UIDevice getSysInfo_AG:HW_CPU_FREQ];
}

+ (NSUInteger)busFrequency_AG
{
    return [UIDevice getSysInfo_AG:HW_BUS_FREQ];
}

+ (NSUInteger)totalMemory_AG
{
    return [UIDevice getSysInfo_AG:HW_PHYSMEM];
}

+ (NSUInteger)userMemory_AG
{
    return [UIDevice getSysInfo_AG:HW_USERMEM];
}

+ (NSUInteger)maxSocketBufferSize_AG
{
    return [UIDevice getSysInfo_AG:KIPC_MAXSOCKBUF];
}

+ (NSUInteger)processorCount_AG
{
    return [[NSProcessInfo processInfo] processorCount];
}

+ (NSNumber *)totalDiskSpace_AG
{
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [attributes objectForKey:NSFileSystemSize];
}

+ (NSNumber *)freeDiskSpace_AG
{
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [attributes objectForKey:NSFileSystemFreeSize];
}

+ (NSString *)freeDiskSpaceHumanReadable_AIV
{
    NSNumber *freeDiskSpace = [UIDevice freeDiskSpace_AG];
    return [freeDiskSpace humanReadableBytes_AG];
}

+ (NSString *)totalDiskSpaceHumanReadable_AIV
{
    NSNumber *freeDiskSpace = [UIDevice totalDiskSpace_AG];
    return [freeDiskSpace humanReadableBytes_AG];
}

+ (NSNumber *)freeMemory_AG
{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    
    host_page_size(host_port, &pagesize);
    (void) host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    vm_size_t vmsize = vm_stat.free_count * pagesize;
    return [NSNumber numberWithLong:vmsize];
}

+ (NSString *)macAddress_AG
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return outstring;
}

#pragma mark - Private Methods

+ (NSString *)getSysInfoByName_AG:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    free(answer);
    return results;
}

+ (NSUInteger)getSysInfo_AG:(uint)typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

+ (NSString *)platform_AG
{
    static dispatch_once_t token;
	static NSString *platform;
    
	dispatch_once(&token, ^{
        platform = [UIDevice getSysInfoByName_AG:"hw.machine"];
    });
    return platform;
}

+ (NSString *)model_AG
{
    static dispatch_once_t token;
	static NSString *model;
    
	dispatch_once(&token, ^{
        model = [UIDevice getSysInfoByName_AG:"hw.model"];
    });
    return model;
}

@end