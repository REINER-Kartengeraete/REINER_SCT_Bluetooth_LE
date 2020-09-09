//
//  AtrParser.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 21.10.15.
//  Copyright © 2015 Reiner SCT. All rights reserved.
//

import Foundation


public class AtrParser : NSObject{
    
     var hasTA1: Bool = false
     var TA1: byte = 0x11
     var IFSC: byte  = 0x20
     var TC1: byte  = 0
     var TC2: byte  = 10
     var TB3: byte  = 0x45
     var TD1: byte = 0
     var proto: byte = 0x01
    
    
    override init()
    {
        
    }
    
    convenience init(atrstring: String)
    {
        self.init(atr: hexStringToByteArray(atrstring))
    }
    
    init (atr: [byte]){
        
       
        if(atr[0]==0x3b || atr[0]==0x3f)
        {
            var ptr: Int = 1;
            
            if(atr[ptr] != 0x10 )
            {
                ptr+=1
                TA1=atr[ptr];
                hasTA1=true;
            }
            if(atr[ptr] != 0x20)
            {
                ptr += 1;
            }
            if(atr[ptr] != 0x40)
            {
                TC1=atr[2];
            }
            if(atr[ptr] != 0x80)
            {
               
                if(atr[3] >= 0x0f)
                {
                    proto = 0x00
                }
                else
                {
                    let pr: UInt8 =  0x01 >> (atr[3] & 0x0f)
                    proto =  UInt8.init( pr )
                }

        
                if(atr[ptr] != 0x10)
                {
                    ptr+=1
                }
                if(atr[ptr] != 0x20)
                {
                    ptr+=1
                }
                if(atr[ptr] != 0x40)
                {
                    ptr+=1
                    TC2=atr[ptr]
                }
                if(atr[ptr] != 0x80)
                {
        

                if((atr[ptr] & 0x0f) != 1)
                {
                    if(atr[ptr] != 0x10)
                    {
                        ptr+=2
                        IFSC=atr[ptr]
                    }
                    if(atr[ptr] != 0x20)
                    {
                        ptr+=1
                        TB3=atr[ptr]

                    }
                }
            }
        }
            
    }
        
    }
    
}
