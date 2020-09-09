//
//  CBPeripheral+GzipInflater.m
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 09.08.16.
//  Copyright © 2016 Reiner SCT. All rights reserved.
//

#import "GzipInflater.h"


@implementation GzipInflater

+(NSData*) gzipInflate:(NSData*)compressedData
{
    if ([compressedData length] == 0) return compressedData;
    
    NSUInteger full_length = [compressedData length];
    NSUInteger half_length = [compressedData length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[compressedData bytes];
    strm.avail_in = (unsigned int)[compressedData length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    while (!done) {
        
        if (strm.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy: half_length];
        }
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = (unsigned int)([decompressed length] - strm.total_out);
        
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        
        if (status == Z_STREAM_END) {
            done = YES;
        }else if (status != Z_OK) {
            
            break;
        }
    }
    if (inflateEnd (&strm) != Z_OK){
        status = inflate (&strm, Z_SYNC_FLUSH);
       
        return nil;
    }
//    if (done) {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
//    } else {
//        return nil;
//    }
}

@end
