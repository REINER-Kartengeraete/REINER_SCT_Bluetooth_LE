//
//  SecoderApplications.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 03.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation

public class SecoderApplications
{
    
    /** ID off the application. */
    private var ApplicationID: String
    
    /**
    * get the Application ID.
    *
    * @return the application id
    */
    public func getApplicationID()-> String
    {
        return ApplicationID
    }
    
    /**
    * set the applicationID.
    *
    * @param value the new application id
    */
    public func setApplicationID(_ value: String)
    {
        ApplicationID = value
    }
    
    /** the ApplicationInterfaceVersion. */
    private var ApplicationInterfaceVersion: String
    
    /**
    * gets the ApplicationInterfaceVersion.
    *
    * @return the application interface version
    */
    public func getApplicationInterfaceVersion() -> String
    {
        return ApplicationInterfaceVersion
    }
    
    /**
    * sets the ApplicationInterfaceVersion.
    *
    * @param value the new application interface version
    */
    public func setApplicationInterfaceVersion(_ value: String)
    {
        ApplicationInterfaceVersion = value
    }
    
    /** the ApplicationImplementationVersion. */
    private var ApplicationImplementationVersion: String
    
    /**
    * gets the ApplicationImplementationVersion.
    *
    * @return the application implementation version
    */
    public func getApplicationImplementationVersion() -> String
    {
        return ApplicationImplementationVersion
    }
    
    /**
    * sets the ApplicationImplementationVersion.
    *
    * @param value the new application implementation version
    */
    public func setApplicationImplementationVersion(_ value: String)
    {
        ApplicationImplementationVersion = value
    }
    
    /** some AdittionalData if available. */
    private var AdittionalData: String
    
    /**
    * gets the AdittionalData.
    *
    * @return the adittional data
    */
    public func getAdittionalData() -> String
    {
        return AdittionalData
    }
    
    /**
    * sets the AdittionalData.
    *
    * @param value the new adittional data
    */
    public func setAdittionalData(_ value: String)
    {
        AdittionalData = value
    }
    
    
    /** The Application idtlvinfo. */
    public let ApplicationIDTLVINFO = TLVINFO(tag: 0x40, len: 0x07, value: [0x00])
    
    /** The Application interface version tlvinfo. */
    public let ApplicationInterfaceVersionTLVINFO =  TLVINFO(tag: 0x80,len: 0x05, value: [0x00])
    
    /** The Application implementation version tlvinfo. */
    public let ApplicationImplementationVersionTLVINFO =  TLVINFO(tag: 0x81, len: 0x00, value: [0x00])
    
    /** The Adittional data tlvinfo. */
    public let AdittionalDataTLVINFO =  TLVINFO(tag: 0x00, len: 0x00, value: [0x00])
    
    /**
    * constructor for the secoder application data.
    *
    * @param data the data
    */
    init (data: [byte])
    {
    
        ApplicationID = ""
        ApplicationInterfaceVersion = ""
        ApplicationImplementationVersion = ""
        AdittionalData = ""
        
    var tlv: TLV
    tlv = TLV(value: data)
    var tags: [TLVINFO]
    tags = tlv.getChildren()
    
        
    for tag in tags
    {
            if (tag.getTAG() == ApplicationIDTLVINFO.TAG)
            {
                ApplicationID =  getStringFromASCIIBytes(tag.getVALUE(),maxLength: tag.getVALUE().count)
            }
            if (tag.getTAG() == ApplicationInterfaceVersionTLVINFO.TAG)
            {
                ApplicationInterfaceVersion =  getStringFromASCIIBytes(tag.getVALUE(),maxLength: tag.getVALUE().count)
            }
            if (tag.getTAG() == ApplicationImplementationVersionTLVINFO.TAG)
            {
                ApplicationImplementationVersion =  getStringFromASCIIBytes(tag.getVALUE(),maxLength: tag.getVALUE().count)
            }
            if (tag.getTAG() == AdittionalDataTLVINFO.TAG)
            {
                AdittionalData = getStringFromASCIIBytes(tag.getVALUE(),maxLength: tag.getVALUE().count)
            }
        }
    }
}
