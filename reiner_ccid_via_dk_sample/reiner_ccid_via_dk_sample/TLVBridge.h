//
//  TLVBridge.h
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 17.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TLVINFO;


@interface TLVTag : NSObject

@property () Byte Tag;
@property () Byte Len;
@property () NSData* Value;

-(id) initTLVTagwithTag:(Byte) tag AndLength:(Byte) len andValue:(NSData*) value;

@end


@interface TLVBridge : NSObject

+(NSArray *) getTLVTagsFromBytes: (NSData *) data;

@end
