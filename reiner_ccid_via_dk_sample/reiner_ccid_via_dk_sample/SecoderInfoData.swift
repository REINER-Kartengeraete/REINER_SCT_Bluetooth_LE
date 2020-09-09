//
//  SecoderInfoData.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 03.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation


public class SecoderInfoData
{
    
    /** The Identifier tlvinfo. */
    public let IdentifierTLVINFO =  TLVINFO(tag: 0x40, len: 0x07,value: [0x00])
    
    /** The Supported interface versions tlvinfo. */
    public let SupportedInterfaceVersionsTLVINFO =  TLVINFO(tag: 0x80, len: 0x05,value: [0x00])
    
    /** The Hersteller name tlvinfo. */
    public let HerstellerNameTLVINFO =  TLVINFO(tag: 0x81, len: 0x00,value: [0x00]);
    
    /** The Reader properties tlvinfo. */
    public let ReaderPropertiesTLVINFO =  TLVINFO(tag: 0x91, len: 0x09,value: [0x00]);
    
    /** The Numeric reader idtlvinfo. */
    public let NumericReaderIDTLVINFO =  TLVINFO(tag: 0x92,len: 0x00,value: [0x00]);
    
    /** The Firmware version tlvinfo. */
    public let FirmwareVersionTLVINFO =  TLVINFO(tag: 0x83, len: 0x00,value: [0x00]);
    
    /** The CSI specific supoorted character sets tlvinfo. */
    public let CSISpecificSupoortedCharacterSetsTLVINFO =  TLVINFO(tag: 0x90, len: 0x01,value: [0x00]);
    
    /** The Supported secoder applications tlvinfo. */
    public let SupportedSecoderApplicationsTLVINFO =  TLVINFO(tag: 0xA0, len: 0x00,value: [0x00]);
    
    
    /** the identifier string. */
    private var Identifier: String = ""
    /** the SupportedInterfaceVersions. */
    private var SupportedInterfaceVersions:[String]
    /** the HerstellerName. */
    private var HerstellerName: String = ""
    /** the ReaderProperties. */
    private var ReaderProperties: SecoderInfoReaderProperties
    /** the NumericReaderID. */
    private var NumericReaderID: SecoderInfoNumericReaderID
    /** the FirmwareVersion. */
    private var FirmwareVersion: String = ""
    /** the SupportedSecoderApplications. */
    private var SupportedSecoderApplications : [SecoderApplications]
    /** the CSISpecificSupoortedCharacterSets. */
    private var CSISpecificSupoortedCharacterSets : [String]
    /** the SupportedLanguages. */
    private var  SupportedLanguages: [String]


    init()
    {
       ReaderProperties =  SecoderInfoReaderProperties()
       NumericReaderID = SecoderInfoNumericReaderID(readerID: [byte]())
       SupportedSecoderApplications = [SecoderApplications]()
       SupportedInterfaceVersions = [String]()
       SupportedLanguages = [String]()
       CSISpecificSupoortedCharacterSets  = [String]()
    }

    
    /**
    * get the identifier string.
    *
    * @return the identifier
    */
    func getIdentifier() -> String
    {
        return Identifier
    }
    
    /**
    * set the identifier string.
    *
    * @param value the new identifier
    */
    func setIdentifier(_ value: String)
    {
        Identifier = value;
    }
    
    
    /**
    * get the SupportedInterfaceVersions.
    *
    * @return the supported interface versions
    */
    func getSupportedInterfaceVersions() -> [String]
    {
        return SupportedInterfaceVersions
    }
    
    /**
    * set the SupportedInterfaceVersions.
    *
    * @param value the new supported interface versions
    */
    func setSupportedInterfaceVersions(_ value: [String])
    {
        SupportedInterfaceVersions = value;
    }

    func appendSupportedInterfaceVersions(_ value: String)
    {
        SupportedInterfaceVersions.append(value)
    }

    /**
    * gets the HerstellerName.
    *
    * @return the hersteller name
    */
    func getHerstellerName() -> String
    {
        return HerstellerName
    }
    
    /**
    * sets the HerstellerName.
    *
    * @param value the new hersteller name
    */
    func setHerstellerName(_ value: String)
    {
        HerstellerName = value;
    }
    
    
    /**
    * get the ReaderProperties.
    *
    * @return the reader properties
    */
    func getReaderProperties() -> SecoderInfoReaderProperties
    {
        return ReaderProperties;
    }
    
    /**
    * set the ReaderProperties.
    *
    * @param value the new reader properties
    */
    func setReaderProperties(_ value: SecoderInfoReaderProperties)
    {
        ReaderProperties = value;
    }
    
    
    
    /**
    * get the NumericReaderID.
    *
    * @return the numeric reader id
    */
    func getNumericReaderID() -> SecoderInfoNumericReaderID
    {
        return NumericReaderID
    }
    
    /**
    * set the NumericReaderID.
    *
    * @param value the new numeric reader id
    */
    func setNumericReaderID(_ value: SecoderInfoNumericReaderID)
    {
        NumericReaderID = value;
    }
      /**
    * get the FirmwareVersion.
    *
    * @return the firmware version
    */
    func getFirmwareVersion() -> String!
    {
        return FirmwareVersion
    }
    
    /**
    * set the FirmwareVersion.
    *
    * @param value the new firmware version
    */
    func setFirmwareVersion(_ value: String)
    {
        FirmwareVersion = value;
    }
    
    /**
    * get the SupportedLanguages.
    *
    * @return the supported languages
    */
    func getSupportedLanguages() -> [String]
    {
        return SupportedLanguages;
    }
    
    /**
    * set the SupportedLanguages .
    *
    * @param value the new supported languages
    */
    func setSupportedLanguages(_ value:[String])
    {
        SupportedLanguages = value;
    }
    
    func appendSupportedLanguages(_ value: String)
    {
        SupportedLanguages.append(value)
    }
    
    /**
    * get the CSISpecificSupoortedCharacterSets.
    *
    * @return the CSI specific supoorted character sets
    */
   func getCSISpecificSupoortedCharacterSets() -> [String]
    {
    return CSISpecificSupoortedCharacterSets
    }
    
    /**
    * set the CSISpecificSupoortedCharacterSets.
    *
    * @param value the new CSI specific supoorted character sets
    */
    func setCSISpecificSupoortedCharacterSets(_ value: [String])
    {
    CSISpecificSupoortedCharacterSets = value;
    }
    
    
    func appendCSISpecificSupoortedCharacterSets(_ value: String)
    {
        CSISpecificSupoortedCharacterSets.append(value)
    }


    /**
    * get the SupportedSecoderApplications.
    *
    * @return the supported secoder applications
    */
    func getSupportedSecoderApplications() -> [SecoderApplications]
    {
    return SupportedSecoderApplications
    }
    
    /**
    * set the SupportedSecoderApplications.
    *
    * @param value the new supported secoder applications
    */
    func setSupportedSecoderApplications(_ value: [SecoderApplications])
    {
        SupportedSecoderApplications = value;
    }
    

    func appendSupportedSecoderApplications(_ value: SecoderApplications)
    {

        SupportedSecoderApplications.append(value)
    }

    
    /* (non-Javadoc)
    * @see java.lang.Object#toString()
    */
    func toString() -> String
    {
        var returnValue: String = ""
    
    returnValue = returnValue + "Identifier: " + Identifier + "\n"
    
    returnValue = returnValue + "SupportedInterfaceVersions\n"
    for siv in self.SupportedInterfaceVersions
    {
        returnValue = returnValue + siv + "\t"
    }
    returnValue = returnValue + "\n" + "Producer: " + HerstellerName + "\n"
        
    returnValue = returnValue + "ReaderProperties: \n"
        
    returnValue = returnValue + "MaxApduLenInternal: " + String(ReaderProperties.getMaxApduLenInternal()) + "\n"
        
    returnValue = returnValue + "MaxApduLenTransparent: " + String(ReaderProperties.getMaxApduLenTransparent()) + "\n"
        
    returnValue = returnValue + "DisplayLineSize: " + String(ReaderProperties.getDisplayLineSize()) + "\n"
        
    returnValue = returnValue + "DisplayLineNumber: " + String(ReaderProperties.getDisplayLineNumber()) + "\n"
        
    
	   /* returnValue= returnValue + "SupportedLanguages\n");
    for(String s : SupportedLanguages)
    {
    returnValue= returnValue + s + "\t");
    }*/
    
    returnValue = returnValue + "FirmwareVersion: " + FirmwareVersion + "\n"
    returnValue = returnValue + "SupportedSecoderApplications\n"
        
    for ssa in self.SupportedSecoderApplications
    {
        returnValue = returnValue + ssa.getApplicationID() + ", "
    }
    
    
    return returnValue
    }
    
}
