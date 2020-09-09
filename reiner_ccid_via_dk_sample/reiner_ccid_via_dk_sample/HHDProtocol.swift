//
//  HHDProtocol.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 08.09.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation


public class HHDProtocoll {
    
    /**
    * Generate hhd command.
    *
    * @param apdu the apdu
    * @return the string
    */
    func generateHHDCommand( _ apdu : String) -> String
    {
        var apdu = apdu
        apdu = apdu.removeWhitespace()
        apdu = "20 76 00 00 00 00 " + IntToHEXString((apdu.length / 2), padding: 2, littleEndian: true) + apdu + " 00 00"
        return apdu;
    }
    
    /**
    * Generatefinalize.
    *
    * @param following the following
    * @return the string
    */
    func Generatefinalize(_ following: Bool) -> String
    {
        let FINALIZE_DONE = "20 77 00 00 00 00 06 00 00 00 00 00 00 00 00 ";
        let FINALIZE_FOLLOWING = "20 77 00 00 00 00 06 00 00 00 00 01 00 00 00";
    
        if (following)
        {
            return FINALIZE_DONE;
        }
        else
        {
            return FINALIZE_FOLLOWING;
        }
    }
    
}
