//
//  HHDAnswer.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 08.09.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation


 class HHDAnswer {
    
    /**
    * Gets the len tan.
    *
    * @return the len tan
    */
    func  getLenTAN() -> Int {
    return lenTAN
    }
    
    
    /**
    * Gets the tan bcd.
    *
    * @return the tan bcd
    */
    func   getTAN_BCD() -> String {
    return TAN_BCD
    }
    
    
    /**
    * Gets the len atc.
    *
    * @return the len atc
    */
    func   getLenATC() -> Int {
    return lenATC
    }
    
    
    /**
    * Gets the atc.
    *
    * @return the atc
    */
    func   getATC()  -> Int{
    return ATC
    }
    
    
    /**
    * Gets the len token.
    *
    * @return the len token
    */
    func   getLenTOKEN() -> Int {
    return lenTOKEN
    }
    
    
    /**
    * Gets the token.
    *
    * @return the token
    */
    func  getTOKEN() -> String {
    return TOKEN
    }
    
    
    /**
    * Gets the len car d_ data.
    *
    * @return the len car d_ data
    */
    func   getLenCARD_DATA() -> Int {
    return lenCARD_DATA
    }
    
    
    /**
    * Gets the card data ef id.
    *
    * @return the card data ef id
    */
    func   getCARD_DATA_EF_ID() -> String{
    return CARD_DATA_EF_ID
    }
    
    
    /**
    * Gets the len cv r_ data.
    *
    * @return the len cv r_ data
    */
    func   getLenCVR_DATA() -> Int{
    return lenCVR_DATA
    }
    
    
    /**
    * Gets the cvr data.
    *
    * @return the cvr data
    */
    func   getCVR_DATA() -> String{
    return CVR_DATA
    }
    
    
    /**
    * Gets the len versioninfo.
    *
    * @return the len versioninfo
    */
    func  getLenVERSIONINFO() -> Int {
    return lenVERSIONINFO
    }
    
    
    /**
    * Gets the versioninfo.
    *
    * @return the versioninfo
    */
    func  getVERSIONINFO() -> String {
    return VERSIONINFO
    }
    
    
    /** The len tan. */
    var  lenTAN: Int = 0
    
    /** The tan bcd. */
    var  TAN_BCD: String = ""
    
    /** The len atc. */
    var  lenATC: Int = 0
    
    /** The atc. */
    var  ATC : Int = 0
    
    /** The len token. */
    var  lenTOKEN: Int = 0
    
    /** The token. */
    var TOKEN :String = ""
    
    /** The len car d_ data. */
    var lenCARD_DATA: Int = 0
    
    /** The card data ef id. */
    var  CARD_DATA_EF_ID: String
    
    /** The len cv r_ data. */
    var lenCVR_DATA: Int = 0
    
    /** The cvr data. */
    var CVR_DATA : String = ""
    
    /** The len versioninfo. */
    var lenVERSIONINFO : Int = 0
    
    /** The versioninfo. */
    var  VERSIONINFO : String = ""
    
    
    /**
    * Instantiates a new HHD answer.
    *
    * @param rsp the rsp
    */
    init( rsp: String)
    {
        var rsp = rsp
  
        var pointer: Int = 0
    
        rsp = rsp.removeWhitespace()
    
        self.lenTAN = Int(rsp[0..<2], radix: 16)! * 2
        pointer += 2
        self.TAN_BCD = rsp[pointer..<(pointer + lenTAN )]
        pointer += lenTAN
    
        self.lenATC = Int(rsp[pointer..<(pointer + 2)] , radix: 16)! * 2
        pointer += 2
        self.ATC = Int(rsp[pointer..<(pointer + lenATC )], radix: 16)!
        pointer += lenATC
    
        self.lenTOKEN = Int(rsp[pointer..<(pointer + 2)], radix: 16)! * 2
        pointer += 2
        self.TOKEN = rsp[pointer..<pointer + lenTOKEN ]
        pointer += lenTOKEN
    
        self.lenCARD_DATA = Int(rsp[pointer..<(pointer + 2)], radix: 16)! * 2
        pointer += 2
        self.CARD_DATA_EF_ID = rsp[pointer..<pointer + lenCARD_DATA ]
        pointer += lenCARD_DATA
    
        self.lenCVR_DATA = Int(rsp[pointer..<(pointer + 2)], radix: 16)! * 2
        pointer += 2
        self.CVR_DATA = rsp[pointer..<pointer + lenCVR_DATA ]
        pointer += lenCVR_DATA
    
        self.lenVERSIONINFO = Int(rsp[pointer..<pointer + 2], radix: 16)! * 2
        pointer += 2
        self.VERSIONINFO = rsp[pointer..<pointer + lenVERSIONINFO ]
        pointer += lenVERSIONINFO
   
    }

    
    
}
    
