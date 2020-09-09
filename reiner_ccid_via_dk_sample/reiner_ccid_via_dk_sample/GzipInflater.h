//
//  CBPeripheral+GzipInflater.h
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 09.08.16.
//  Copyright © 2016 Reiner SCT. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "zlib.h"

@interface GzipInflater : NSObject


+(NSData*) gzipInflate:(NSData*)compressedData;

@end
