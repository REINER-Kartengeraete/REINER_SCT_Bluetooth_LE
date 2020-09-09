//
//  SecoderApplicationCapabilitys.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 03.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation

public class SecoderApplicationsCapabilitys
{
    
    /**  the last byte. */
    private var lastbyte: Bool
    
    /**
    * gets the last byte.
    *
    * @return the lastbyte
    */
    func getlastbyte()-> Bool
    {
    return lastbyte;
    }
    
    /**
    * sets the last byte.
    *
    * @param value the new lastbyte
    */
    func setlastbyte(_ value: Bool)
    {
    lastbyte = value;
    }
    
    /** ICCardComandsBlockedCompletely value. */
    private var ICCardComandsBlockedCompletely: Bool
    
    /**
    * gets the ICCardComandsBlockedCompletely value.
    *
    * @return the IC card comands blocked completely
    */
   func getICCardComandsBlockedCompletely() -> Bool
    {
    return ICCardComandsBlockedCompletely;
    }
    
    /**
    * sets the ICCardComandsBlockedCompletely value.
    *
    * @param value the new IC card comands blocked completely
    */
   func setICCardComandsBlockedCompletely(_ value: Bool)
    {
    ICCardComandsBlockedCompletely = value;
    }
    
    /** the PinHandlingFunktionsBlockedCompletely value. */
    private var PinHandlingFunktionsBlockedCompletely: Bool
    
    /**
    * gets the PinHandlingFunktionsBlockedCompletely value.
    *
    * @return the pin handling funktions blocked completely
    */
    func getPinHandlingFunktionsBlockedCompletely() -> Bool
    {
    return PinHandlingFunktionsBlockedCompletely;
    }
    
    /**
    * sets PinHandlingFunktionsBlockedCompletely value.
    *
    * @param value the new pin handling funktions blocked completely
    */
    func setPinHandlingFunktionsBlockedCompletely(_ value: Bool)
    {
    PinHandlingFunktionsBlockedCompletely = value;
    }
    
    /** the rfu values. */
    public var RFU: [Bool] = []
    
    /**
    * gets the rfu values.
    *
    * @return the rfu
    */
    public func getRFU() -> [Bool]
    {
        return RFU;
    }
    
    /**
    * sets the rfu values.
    *
    * @param value the new rfu
    */
    func setRFU(_ value: [Bool])
    {
        RFU = value;
    }
    
    init()
    {
        

       lastbyte = false
       ICCardComandsBlockedCompletely = false
       PinHandlingFunktionsBlockedCompletely = false
       RFU = [Bool]()
    }
}
