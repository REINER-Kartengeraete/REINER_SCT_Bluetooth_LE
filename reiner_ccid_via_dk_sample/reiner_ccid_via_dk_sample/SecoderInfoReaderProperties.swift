//
//  SecoderInfoReaderPRoperties.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 03.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation

public class SecoderInfoReaderProperties
{
    
    /** Quallifiers. */
    private var Quallifiers = SecoderReaderQuallifiers(info: 0x00)
    
    /**
    * get the Quallifiers.
    *
    * @return the quallifiers
    */
     func getQuallifiers()->SecoderReaderQuallifiers
    {
        return Quallifiers
    }
    
    /**
    * set the Quallifiers.
    *
    * @param value the new quallifiers
    */
    func setQuallifiers(_ value: SecoderReaderQuallifiers)
    {
        Quallifiers = value
    }
    
    /** the DisplayLineSize. */
    private var DisplayLineSize:byte = 0x00
    
    /**
    * get the DisplayLineSize.
    *
    * @return the display line size
    */
    func getDisplayLineSize() -> byte
    {
        return DisplayLineSize
    }
    
    /**
    * set the DisplayLineSize.
    *
    * @param value the new display line size
    */
    func setDisplayLineSize(_ value: Byte)
    {
        DisplayLineSize = value
    }
    
    /** the DisplayLineNumber. */
    private var DisplayLineNumber:byte = 0x00
    
    
    /**
    * get the DisplayLineNumber.
    *
    * @return the display line number
    */
    func getDisplayLineNumber()->byte
    {
        return DisplayLineNumber
    }
    
    /**
    * set the DisplayLineNumber.
    *
    * @param value the new display line number
    */
    public func setDisplayLineNumber(_ value:byte)
    {
        DisplayLineNumber = value
    }
    
    /** the VisDataBuffer. */
    private var VisDataBuffer:byte = 0x00
    
    /**
    * get the VisDataBuffer .
    *
    * @return the vis data buffer
    */
    func getVisDataBuffer() ->byte
    {
    return VisDataBuffer
    }
    
    /**
    * set the VisDataBuffer.
    *
    * @param value the new vis data buffer
    */
    func setVisDataBuffer(_ value: byte)
    {
    VisDataBuffer = value
    }
    
    /** the MaxApduLenTransparent. */
    private var MaxApduLenTransparent: Int = 0
    
    /**
    * get the MaxApduLenTransparent.
    *
    * @return the max apdu len transparent
    */
    func getMaxApduLenTransparent() -> Int
    {
        return MaxApduLenTransparent
    }
    
    /**
    * set the MaxApduLenTransparent.
    *
    * @param value the new max apdu len transparent
    */
    func setMaxApduLenTransparent(_ value: Int)
    {
        MaxApduLenTransparent = value
    }
    
    /** the MaxApduLenInternal. */
    private var MaxApduLenInternal:Int = 0
    
    /**
    * get the MaxApduLenInternal.
    *
    * @return the max apdu len internal
    */
    func getMaxApduLenInternal() ->Int
    {
        return MaxApduLenInternal
    }
    
    /**
    * set the MaxApduLenInternal.
    *
    * @param value the new max apdu len internal
    */
    func setMaxApduLenInternal(_ value: Int)
    {
        MaxApduLenInternal = value
    }
    
    init()
    {
            setQuallifiers(SecoderReaderQuallifiers(info: 0x00))
            setDisplayLineSize(0x00)
            setDisplayLineNumber(0x00)
            setVisDataBuffer(0x00)
            let tLen:UInt16 = UInt16(UInt16(0x00) << UInt16(8)) | UInt16(0x00)
            setMaxApduLenTransparent(Int(tLen))
            let iLen:UInt16 = UInt16(UInt16(0x00) << UInt16(8)) | UInt16(0x00)
            setMaxApduLenInternal(Int(iLen))

    }

    
    /**
    * constructor for SecoderInfoReaderProperties.
    *
    * @param properties the properties
    */
    init(properties: [byte])
    {
        if (properties.count == 9)
        {
            setQuallifiers(SecoderReaderQuallifiers(info: properties[0]))
            setDisplayLineSize(properties[1])
            setDisplayLineNumber(properties[2])
            setVisDataBuffer(properties[3])
            let tLen:UInt16 = UInt16(UInt16(properties[5]) << UInt16(8)) | UInt16(properties[4])
            setMaxApduLenTransparent(Int(tLen))
            let iLen:UInt16 = UInt16(UInt16(properties[6]) << UInt16(8)) | UInt16(properties[7])
            setMaxApduLenInternal(Int(iLen))
        }
       
    }
}
