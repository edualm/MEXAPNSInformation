//
//  MEXAPNSInformation.m
//

/*
 Copyright (c) 2012 Eduardo Almeida
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "MEXAPNSInformation.h"

static NSDictionary *MEXAPNSDictionary = nil;

@interface NSString (MEXAddons)

- (NSString *)stringBetweenString:(NSString *)start andString:(NSString *)end;

- (BOOL)containsString:(NSString *)string;

@end

@implementation NSString (MEXAddons)

- (NSString *)stringBetweenString:(NSString *)start andString:(NSString *)end {
    NSRange startRange = [self rangeOfString:start];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [self length] - targetRange.location;
        NSRange endRange = [self rangeOfString:end options:0 range:targetRange];
        if (endRange.location != NSNotFound) {
            targetRange.length = endRange.location - targetRange.location;
            return [self substringWithRange:targetRange];
        }
    }
    return nil;
}

- (BOOL)containsString:(NSString *)string {
    if ([[self stringByReplacingOccurrencesOfString:string withString:@""] isEqualToString:self])
        return NO;
    return YES;
}

@end

@implementation MEXAPNSInformation

+ (NSDictionary *)APNSInformationForCurrentDevice {
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    NSString *mcc = [carrier mobileCountryCode];
    NSString *mnc = [carrier mobileNetworkCode];
    
    return [MEXAPNSInformation APNSInformationForMCC:mcc MNC:mnc];
}

+ (NSDictionary *)APNSInformationForMCC:(NSString *)MCC MNC:(NSString *)MNC {
    if (!MEXAPNSDictionary) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        NSError *error = nil;
        
        NSString *xmlStr = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kAndroidAPNSXMLFileName ofType:@"xml"] encoding:NSUTF8StringEncoding error:nil];
        
        NSArray *lines = [xmlStr componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return nil;
        }
        
        for (NSString *line in lines) {
            if ((([line containsString:@"<apn carrier="] && ![line containsString:@"MMS"]) && ![line containsString:@"mms"]) && ![line containsString:@"Prepaid"]) {
                NSString *mcc = [line stringBetweenString:@"mcc=\"" andString:@"\""];
                NSString *mnc = [line stringBetweenString:@"mnc=\"" andString:@"\""];
                NSString *apn = [line stringBetweenString:@"apn=\"" andString:@"\""];
                NSString *user = [line stringBetweenString:@"user=\"" andString:@"\""];
                NSString *password = [line stringBetweenString:@"password=\"" andString:@"\""];
                
                NSString *mccmnc = [NSString stringWithFormat:@"%@-%@", mcc, mnc];
                
                NSMutableString *obj = [[NSString stringWithFormat:@"%@", apn] mutableCopy];
                
                if (user)
                    [obj appendFormat:@"-%@", user];
                
                if (password) {
                    [obj appendFormat:@"-%@", password];
                }
                
                [dict setObject:obj forKey:mccmnc];
            }
        }
        
        MEXAPNSDictionary = [dict copy];
    }
    
    NSString *str = [NSString stringWithFormat:@"%@-%@", MCC, MNC];
    NSString *details = [MEXAPNSDictionary objectForKey:str];
    
    NSArray *components = [details componentsSeparatedByString:@"-"];
    
    if (components.count == 1)
        return [NSDictionary dictionaryWithObject:[components objectAtIndex:0] forKey:@"APN"];
    
    if (components.count == 2)
        return [NSDictionary dictionaryWithObjectsAndKeys:[components objectAtIndex:0], @"APN", [components objectAtIndex:1], @"Username", nil];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:[components objectAtIndex:0], @"APN", [components objectAtIndex:1], @"Username", [components objectAtIndex:2], @"Password", nil];
}

+ (NSDictionary *)rawAPNSInformationDictionary {
    if (!MEXAPNSDictionary) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        NSError *error = nil;
        
        NSString *xmlStr = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kAndroidAPNSXMLFileName ofType:@"xml"] encoding:NSUTF8StringEncoding error:nil];
        
        NSArray *lines = [xmlStr componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return nil;
        }
        
        for (NSString *line in lines) {
            if ((([line containsString:@"<apn carrier="] && ![line containsString:@"MMS"]) && ![line containsString:@"mms"]) && ![line containsString:@"Prepaid"]) {
                NSString *mcc = [line stringBetweenString:@"mcc=\"" andString:@"\""];
                NSString *mnc = [line stringBetweenString:@"mnc=\"" andString:@"\""];
                NSString *apn = [line stringBetweenString:@"apn=\"" andString:@"\""];
                NSString *user = [line stringBetweenString:@"user=\"" andString:@"\""];
                NSString *password = [line stringBetweenString:@"password=\"" andString:@"\""];
                
                NSString *mccmnc = [NSString stringWithFormat:@"%@-%@", mcc, mnc];
                
                NSMutableString *obj = [[NSString stringWithFormat:@"%@", apn] mutableCopy];
                
                if (user)
                    [obj appendFormat:@"-%@", user];
                
                if (password) {
                    [obj appendFormat:@"-%@", password];
                }
                
                [dict setObject:obj forKey:mccmnc];
            }
        }
        
        MEXAPNSDictionary = [dict copy];
    }
    
    return MEXAPNSDictionary;
}

@end
