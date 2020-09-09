
//
//  CCIDProtocol.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 03.09.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation



public class CCIDProtocoll {
    
    //select main file if a card
    /** The Constant getRootCommand. */
    public let getRootCommand = "00 A4 00 00 02 3f 00 00 "
    
    /** The Constant Device_to_SetParameter. */
    public let Device_to_RDR_SetParameter = "61"
    
    /** The Constant Device_to_RDR_IccPowerOn. */
    public var Device_to_RDR_IccPowerOn = "62"
    
    /** The Constant Device_to_RDR_IccPowerOff. */
    public let Device_to_RDR_IccPowerOff = "63"
    
    /** The Constant Device_to_RDR_GetSlotStatus. */
    public let Device_to_RDR_GetSlotStatus = "65"
    
    
    /** The Constant Device_to_RDR_XfrBlock. */
    public let Device_to_RDR_XfrBlock = "6F"
    
    /** The Constant Device_to_RDR_ESCBlock. */
    public let Device_to_RDR_ESCBlock = "6B"

    
    /** The Constant Device_to_RDR_Secure. */
    public let Device_to_RDR_Secure  = "69"
    
    /** The Constant RDR_to_DEVICE_DataBlock. */
    public let RDR_to_DEVICE_DataBlock = "80"   // PC_to_RDR_IccPowerOn, PC_to_RDR_XfrBlock PC_to_RDR_Secure
    
    /** The Constant RDR_to_DEVICE_SlotStatus. */
    public let RDR_to_DEVICE_SlotStatus = "81"  // PC_to_RDR_IccPowerOff, PC_to_RDR_GetSlotStatus, PC_to_RDR_Mechanical, PC_to_RDR_T0APDUPC_to_RDR_Abort and Class specific ABORT request
    
        /**
    * The Enum CCIDSecureReturnType.
    */
    public enum CCIDSecureReturnType: String {
        
        /** The tpdu. */
        case TPDU = "00 00 "
        
        /** The apdu. */
        case APDU  = " 00 00 "
        
        /** The apdu beginns or ends. */
        case APDU_BEGINNS_OR_ENDS = "  00 00 "
        
        /** The apdu beginns and continues. */
        case APDU_BEGINNS_AND_CONTINUES  = "00 01 "
        
        /** The apdu continues and ends. */
        case APDU_CONTINUES_AND_ENDS = " 00 01 "
        
        
    }
    
    public enum TransportProtocol: String {
        
        
        case T_Equals_0  = "00"
        case T_Equals_1  = "01"
        case Automatic =  "FF"
    }
    
        
    /**
    * The Enum PINOperation.
    */
    public enum PINOperation: String{
        
        /** The pin verification. */
        case PIN_VERIFICATION = "00"
        
        /** The pin modification. */
        case PIN_MODIFICATION  = "01"
        
        /** The transphere pin. */
        case TRANSPHERE_PIN  = "02"
        
        /** The wait icc response. */
        case WAIT_ICC_RESPONSE   = "03"
        
        /** The cancel pin funktion. */
        case CANCEL_PIN_FUNKTION   = "04"
        
        /** The resend last block. */
        case RESEND_LAST_BLOCK  = "05"
        
        /** The send nextpart. */
        case  SEND_NEXTPART = "06"
        
    }
    
    public enum CardVoltage : String{
        
        
        case  AUTOMATIC_CARD_VOLTAGE = "00" // not supported in cyberJack wave readers
        case  VOLTS_5_CARD_VOLTAGE = "01"
        case  VOLTS_3_CARD_VOLTAGE = "02"
        case  VOLTS_1_8_CARD_VOLTAGE = "03"
        
    }
    
    /**
    * The Enum CCIDReturnBlockType.
    */
    public enum CCIDReturnBlockType : byte {
        
        /** The data block. */
        case data_BLOCK = 0x80
        
        /** The slot status. */
        case slot_STATUS  = 0x81
        
        
        /** The parameter block. */
        case parameter_BLOCK  = 0x82
        
        /** The esc block. */
        case esc_BLOCK  = 0x83

    }

    
    /**
    * The Class CCID_DataBlock.
    */
    class CCID_DataBlock : CCID_AnswerBlock
    {
        
        /**
        * Gets the chain parameter.
        *
        * @return the chain parameter
        */
        func getChainParameter() -> Int {
            return chainParameter
        }
        
        /**
        * Gets the commando data.
        *
        * @return the commando data
        */
        func getCommandoData() -> String{
            return commandoData
        }
        
        override convenience init(b: [byte])
        {
            self.init(block: b)
           //data! = block
        }

        init(block:[byte])
        {
            super.init()
            data = block
            buildDataBlock()

        }
        
        func buildDataBlock()
        {
            var block = self.data
            
            let x: [byte] = [block[1],block[2],block[3],block[4]]
            length = Int(byteArrayToInt(x))
            slot = Int(block[5])
            cmdSequence = Int(block[6])
            slotstatus = Int(block[7])
            slotError = Int(block[8])
            chainParameter = Int(block[9])
            
            if (block.count < 13){
                commandoData = ""
            }
            else
            {
                let data = SplitArray (block, range: (13 ..< (block.count)))
                commandoData = byteArrayToHexString(data)
            }

        }
    }
    
    /**
    * The Class CCID_ParameterBlock.
    */
    class CCID_ParameterBlock : CCID_AnswerBlock
    {
        
        /**
        * Gets the chain parameter.
        *
        * @return the chain parameter
        */
        func getChainParameter() -> Int {
            return chainParameter
        }
        
        /**
        * Gets the commando data.
        *
        * @return the commando data
        */
        func getCommandoData() -> String{
            return commandoData
        }
        
        override convenience init(b: [byte])
        {
            self.init(block: b)
            //data! = block
        }
        
        init(block:[byte])
        {
            super.init()
            data = block
            buildParameterBlock()
            
        }
        
        func buildParameterBlock()
        {
            var block = self.data
            
            let x: [byte] = [block[1],block[2],block[3],block[4]]
            length = Int(byteArrayToInt(x))
            slot = Int(block[5])
            cmdSequence = Int(block[6])
            slotstatus = Int(block[7])
            slotError = Int(block[8])
            chainParameter = Int(block[9])
            
        }
    }
    
    
        /**
        * The Class CCID_SlotStausBlock.
        */
        class CCID_SlotStausBlock : CCID_AnswerBlock
        {
            /**
            * Gets the clock status.
            *
            * @return the clock status
            */
            func getClockStatus() -> Int{
                return clockStatus
            }
            
            
            override convenience init(b: [byte])
            {
                self.init(block: b)
                //data! = block
            }
            
            init(block:[byte])
            {
                super.init()
                data = block
                buildSlotStausBlock()
            }

            
            
            func buildSlotStausBlock()
            {
                var block = self.data
                
                let x: [byte] = [block[4],block[3],block[2],block[1]]
                length = Int(byteArrayToInt(x))
                slot = Int(block[5])
                cmdSequence = Int(block[6])
                slotstatus = Int(block[7])
                slotError = Int(block[8])
                clockStatus = Int(block[9])
                
            }
        }
    /**
     * The Class CCID_ESCBlock.
     */
    class CCID_ESCBlock : CCID_AnswerBlock
    {
        
        /**
         * Gets the chain parameter.
         *
         * @return the chain parameter
         */
        func getChainParameter() -> Int {
            return chainParameter
        }
        
        /**
         * Gets the commando data.
         *
         * @return the commando data
         */
        func getCommandoData() -> String{
            return commandoData
        }
        
        override convenience init(b: [byte])
        {
            self.init(block: b)
            //data! = block
        }
        
        init(block:[byte])
        {
            super.init()
            data = block
            buildESCBlock()
            
        }
        
        func buildESCBlock()
        {
            var block = self.data
            
            let x: [byte] = [block[1],block[2],block[3],block[4]]
            length = Int(byteArrayToInt(x))
            slot = Int(block[5])
            cmdSequence = Int(block[6])
            slotstatus = Int(block[7])
            slotError = Int(block[8])
            chainParameter = Int(block[9])
            
        }
    }

    
        
        
        /**
        * Generate power on.
        *
        * @param seq the seq
        * @return the string
        */
        func  generatePowerOn(_ seq: Int, voltage: CardVoltage, slot: byte) -> String
        {
            return (Device_to_RDR_IccPowerOn + " 00 00 00 00 " + byteArrayToHexString([slot]) + " " + IntToHEXString(seq, padding: 2, littleEndian: false)    + voltage.rawValue +      "00 00 ")
        // 	command 			length	     slot     sequence number				 voltage selection           RFu
        }
        
        /**
        * Generate power off.
        *
        * @param seq the seq
        * @return the string
        */
    func generatePowerOff(_ seq: Int , slot:byte) -> String
        {
        return (Device_to_RDR_IccPowerOff + " 00 00 00 00 " + byteArrayToHexString([slot]) + " " + IntToHEXString(seq, padding: 2,littleEndian: false) +    "00 00 00 ")
        // 	command 			length	     slot                     sequence number			          RFu
        }
        
        /**
        * Generate get slot status.
        *
        * @param seq the seq
        * @return the string
        */
    func generateGetSlotStatus(_ seq: Int, slot: byte) -> String
        {
        return (Device_to_RDR_GetSlotStatus + " 00 00 00 00 " + byteArrayToHexString([slot]) + " " + IntToHEXString(seq, padding: 2, littleEndian: false) +    "00 00 00 ")
        // 	command 			length	     slot       sequence number			                             RFu
        }
        
        /**
        * Generate xfer block.
        *
        * @param data the data
        * @param seq the seq
        * @return the string
        */
    func generateXferBlock(_ data: String,seq: Int, slot: byte)-> String
        {
            var data = data
            data = data.removeWhitespace()
            return (Device_to_RDR_XfrBlock + IntToHEXString(data.characters.count / 2, padding: 10,littleEndian: true) +  byteArrayToHexString([slot]) + " " +    IntToHEXString(seq, padding: 1, littleEndian: true) +    "FF "    + "00 00 "  +    data)
        // 	command 			length	     					slot        sequence number			  timeout  	expected return length           send block
        }
    
    /**
     * Generate esc block.
     *
     * @param data the data
     * @param seq the seq
     * @return the string
     */
    func generateESCBlock(_ data: String,seq: Int, slot: byte)-> String
    {
        var data = data
        data = data.removeWhitespace()
        return (Device_to_RDR_ESCBlock + IntToHEXString(data.characters.count / 2, padding: 10,littleEndian: true) +  byteArrayToHexString([slot]) + " " +    IntToHEXString(seq, padding: 1, littleEndian: true) +    "FF "    + "00 00 "  +    data)
        // 	command 			length	     					slot        sequence number			  timeout  	expected return length           send block
    }

    
        /**
        * Generate get secure.
        *
        * @param data the data
        * @param seq the seq
        * @param returntype the returntype
        * @param operation the operation
        * @return the string
        */
    func generateGetSecure(_ data: String, seq: Int, returntype: CCIDSecureReturnType ,  operation: PINOperation, slot:byte) -> String
        {
            var data = data
            data = data.removeWhitespace()
            return (Device_to_RDR_Secure + IntToHEXString(data.characters.count / 2, padding: 8, littleEndian: false) + byteArrayToHexString([slot]) + " " + IntToHEXString(seq, padding: 1, littleEndian: false) +    "FF "    +          returntype.rawValue + operation.rawValue  +    data)
        // 	command 			length	     				     slot        sequence number			timeout              returntype	  		 PINOperation	   send block
        }
    
    /**
    * Generate setParameters.
    *
    * @param proto the TransportProtocol
    * @param seq the sequence
    * @param atr the AtrParser
    * @return the setParameterBlock
    */
    func generateSetParameters(_ proto: TransportProtocol, seq: Int, atr: AtrParser, slot: byte) -> String
        {
            var proto = proto

            
            if(proto == TransportProtocol.Automatic ){
                
                if(atr.proto == 0x01)
                {
                        proto = TransportProtocol.T_Equals_1;
                }
                else
                {
                        proto = TransportProtocol.T_Equals_0;
                }
            }
            
            
            if(proto == TransportProtocol.T_Equals_1 ){
                
                var dataByte = [byte]()
                
                dataByte.append(atr.TA1)
                dataByte.append(0x00)
                dataByte.append(0xff)
                dataByte.append(atr.TB3)
                dataByte.append(0x00)
                dataByte.append(atr.IFSC)
                dataByte.append(0x00)
                
                let test =  (Device_to_RDR_SetParameter + IntToHEXString(7, padding: 10, littleEndian: true) + byteArrayToHexString([slot]) + " " + IntToHEXString(seq, padding: 1, littleEndian: false) +    proto.rawValue   + " 00 00 " + byteArrayToHexString(dataByte) )
                // Protocoll id 			length				slot				serquence		  t=1 		RFU 		data
                
                return test
            }
            
            if(proto == TransportProtocol.T_Equals_0 ){
                
                var dataByte =  [byte]()
                
                dataByte.append(atr.TA1)
                dataByte.append(0x00)
                dataByte.append(0xff)
                dataByte.append(atr.TB3)
                dataByte.append(0x00)
            
                let test = (Device_to_RDR_SetParameter + IntToHEXString(5, padding: 10, littleEndian: true) + byteArrayToHexString([slot]) + " " + IntToHEXString(seq, padding: 1, littleEndian: false) +    proto.rawValue    + " 00 00 " + byteArrayToHexString(dataByte) );
                // Protocoll id 			length				slot				serquence		  t=1 		RFU 		data
                return test
                
            }
            return "";
            
    }
    
      /**
        * Parses the ccid response.
        *
        * @param block the block
        * @return the CCI d_ answer block
        */
        func parseCCIDResponse(_ block: [byte]) -> CCID_AnswerBlock
        {
            return  CCID_AnswerBlock(b: block);
        }
        
    
        
        
}
