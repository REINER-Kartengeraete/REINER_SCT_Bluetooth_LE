//
//  TLVBridge.m
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 17.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLVBridge.h"
#import "DER_Helper.h"



@implementation TLVBridge : NSObject 


+(NSArray *) getTLVTagsFromBytes: (NSData *) data
{

    NSData * daten = data;
    NSMutableArray *tlvHelpers = [[NSMutableArray alloc] init];
    int secnumber = 1;
    
    tTLV_Helper helper;
    secnumber =  InitTLV_Helper(&helper, [daten bytes], daten.length );
    
    
    while(secnumber != 0){
        
      //  TLVINFO *tag;
        NSData *temp = [NSData dataWithBytes:(Byte*)helper.V length:helper.L];
        [tlvHelpers addObject: [[TLVTag alloc] initTLVTagwithTag:*helper.T AndLength: helper.L  andValue: temp]];
        secnumber = TLV_HelperNext(&helper);
    }
    return tlvHelpers;
}


@end

@implementation TLVTag : NSObject

@synthesize Tag;
@synthesize Len;
@synthesize Value;

-(id) initTLVTagwithTag:(Byte) tag AndLength:(Byte) len andValue:(NSData*) value
{
    self.Tag = tag;
    self.Len = len;
    self.Value = value;
    
    return self;
}

@end



