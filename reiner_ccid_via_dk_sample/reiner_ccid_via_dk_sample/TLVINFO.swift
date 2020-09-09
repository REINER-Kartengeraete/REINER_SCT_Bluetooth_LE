//
//  TLVINFO.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 03.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation

public class TLVINFO
{
    
    /** the tag. */
    var TAG: Int
    
    /**
    * gets the tag.
    *
    * @return the tag
    */
    public func getTAG() -> Int
    {
    return TAG;
    }
    
    /**
    * sets the tag.
    *
    * @param value the new tag
    */
    public func setTAG(_ value: Int)
    {
        TAG = value;
    }
    
    /** the len. */
    var LEN : byte
    
    /**
    * gets the len.
    *
    * @return the len
    */
    func getLEN() ->byte
    {
        return LEN;
    }
    
    /**
    * sets the len.
    *
    * @param value the new len
    */
    func setLEN(_ value: byte)
    {
        LEN = value;
    }
    
    /** the value. */
    var VALUE : [byte]
    
    /**
    * gets the value.
    *
    * @return the value
    */
    func getVALUE() -> [byte]
    {
        return VALUE
    }
    
    /**
    * sets the value.
    *
    * @param value the new value
    */
    func setVALUE(_ value: [byte])
    {
        VALUE = value;
    }

    
    /**
    * constructor for TLVINFO.
    *
    * @param tag the tag
    * @param len the len
    */
    public init(tag: Int, len: byte, value: [byte])
    {
        TAG = tag
        LEN = len
        VALUE = value
    }
 }
