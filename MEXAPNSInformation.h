//
//  MEXAPNSInformation.h
//

/*
 Copyright (c) 2012 Eduardo Almeida
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

/*
 * This class works with an Android APNS XML.
 * I have used the ICS CM one.
 * It can be downloaded at https://raw.github.com/CyanogenMod/android_vendor_cm/ics/prebuilt/common/etc/apns-conf.xml
 */

#define kAndroidAPNSXMLFileName @"apns-conf"

@interface MEXAPNSInformation : NSObject

/** Gets the APN information for the current device.
 * @return A dictionary with the requested information. Returned keys: APN, Username, Password.
 */

+ (NSDictionary *)APNSInformationForCurrentDevice;

/** Gets the APN information for a given MCC and MNC. 
 * @param MNC The Mobile Network Code.
 * @param MCC The Mobile Country Code.
 * @return A dictionary with the requested information. Returned keys: APN, Username, Password.
 */

+ (NSDictionary *)APNSInformationForMCC:(NSString *)MCC MNC:(NSString *)MNC;

/** Gets the raw APN dictionary the class works with.
 * @return A dictionary with keys in the format MCC-MNC and objects in the format APN(-Username(-Password)).
 */

+ (NSDictionary *)rawAPNSInformationDictionary;

@end
