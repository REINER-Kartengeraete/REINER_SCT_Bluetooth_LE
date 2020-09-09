//
//  SecoderInfo.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 03.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation



let GetSecoderInfoCommandString = "20 70 00 00 00 00 01 00 00 00"


public class SecoderInfo
{
    
  
    
    /** The actual secoder info data. */
    public var Data: SecoderInfoData?
    
    /**
    *  constructor with string.
    *
    * @param data the data
    */
    init(data: String)
    {
        Data = SecoderInfoData()
        Data = ParseSecoderInfo(hexStringToByteArray(data));
    }
    
    /**
    *  constructor with [byte]
    *
    * @param data the data
    */
    init(data: [byte])
    {
        Data = SecoderInfoData()
        Data = ParseSecoderInfo(data)
    }
    
    
    /**
    * parses the secoder info data.
    *
    * @param data the data
    * @return the secoder info data
    */
    private func ParseSecoderInfo(_ data: [byte]) -> SecoderInfoData!
    {
    //    var tlv: TLV
    //
        let toParse: Foundation.Data = Foundation.Data(bytes: UnsafePointer<UInt8>(data), count: data.count)
        let children: [TLVTag] = TLVBridge.getTLVTags(fromBytes: toParse) as NSArray as! [TLVTag]
        var tags:[TLVINFO] = [TLVINFO]()
        
        
      
        
        for tag in children
        {
            let temp:Foundation.Data = tag.value
            tags.append(TLVINFO(tag: Int(tag.tag), len: byte(tag.len), value: nsDataToByteArray(temp)))
        }
        
        
        
    
    for part in tags
    {
            if (part.getTAG() == SecoderInfoData().IdentifierTLVINFO.TAG)
            {
                Data!.setIdentifier( getStringFromASCIIBytes(part.getVALUE() ,maxLength: part.getVALUE().count))
            }
            if (part.getTAG() == SecoderInfoData().SupportedInterfaceVersionsTLVINFO.TAG)
            {
                Data!.appendSupportedInterfaceVersions( getStringFromASCIIBytes(part.getVALUE(),maxLength: part.getVALUE().count))
            }
            if (part.getTAG() == SecoderInfoData().HerstellerNameTLVINFO.TAG)
            {
                Data!.setHerstellerName( getStringFromASCIIBytes(part.getVALUE(),maxLength: part.getVALUE().count))
            }
            if (part.getTAG() == SecoderInfoData().ReaderPropertiesTLVINFO.TAG)
            {
                Data!.setReaderProperties( SecoderInfoReaderProperties(properties: part.getVALUE()))
            }
            if (part.getTAG() == SecoderInfoData().NumericReaderIDTLVINFO.TAG)
            {
                Data!.setNumericReaderID( SecoderInfoNumericReaderID(readerID: part.getVALUE()))
            }
            if (part.getTAG() == SecoderInfoData().FirmwareVersionTLVINFO.TAG)
            {
                Data!.setFirmwareVersion(getStringFromASCIIBytes(part.getVALUE(),maxLength: part.getVALUE().count))
            }
            if (part.getTAG() == SecoderInfoData().CSISpecificSupoortedCharacterSetsTLVINFO.TAG)
            {
               Data!.appendCSISpecificSupoortedCharacterSets(getStringFromASCIIBytes(part.getVALUE(),maxLength: part.getVALUE().count))
            }
            if (part.getTAG() == SecoderInfoData().SupportedSecoderApplicationsTLVINFO.TAG)
            {
                Data!.appendSupportedSecoderApplications(SecoderApplications(data: part.getVALUE()))
            }
    }
    
        if(Data != nil)
        {
            return Data!
        }
        
        return nil
    }
}









