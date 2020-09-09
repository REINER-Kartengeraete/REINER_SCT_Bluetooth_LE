//
//  CCIDBlock.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 08.09.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation


class CCID_AnswerBlock
{
    var  dataBlock: CCIDProtocoll.CCID_DataBlock!
    
    var  slotStatus: CCIDProtocoll.CCID_SlotStausBlock!
    
    var  parameterBlock: CCIDProtocoll.CCID_ParameterBlock!
    
    var escBlock: CCIDProtocoll.CCID_ESCBlock!
    
    //var answerblock: CCID_AnswerBlock
    
    /** The length. */
    internal var length: Int!
    
    /** The slot. */
    internal var slot: Int!
    
    /** The cmd sequence. */
    internal var cmdSequence: Int!
    
    /** The slotstatus. */
    internal var slotstatus: Int!
    
    /** The slot error. */
    internal var slotError: Int!
    
    /** The chain parameter. */
    internal var chainParameter:Int!
    
    /** The commando data. */
    internal var commandoData: String!
    
    /** The clock status. */
    internal var clockStatus: Int!
    
    internal var data:[byte]
    
    
    /**
    * Gets the length.
    *
    * @return the length
    */
    func getLength() -> Int{
        return length
    }
    
    /**
    * Gets the slot.
    *
    * @return the slot
    */
    func getSlot() -> Int{
        return slot
    }
    
    /**
    * Gets the cmd sequence.
    *
    * @return the cmd sequence
    */
    func getCmdSequence() -> Int{
        return cmdSequence
    }
    
    /**
    * Gets the slotstatus.
    *
    * @return the slotstatus
    */
    func getSlotstatus()-> Int {
        return slotstatus
    }
    
    /**
    * Gets the slot error.
    *
    * @return the slot error
    */
    func getSlotError() -> Int{
        return slotError;
    }
    
    init()
    {
        
        length = 0
        slot = 0
        cmdSequence = 0
        slotstatus = 0
        slotError = 0
        chainParameter = 0
        commandoData = ""
        clockStatus = 0
        data = [byte]()

    }

    
    
    /**
    * Instantiates a new CCID_ answer block.
    *
    * @param block the block
    */
    init(b: [byte])
    {
        
        data = b
        
        dataBlock = CCIDProtocoll.CCID_DataBlock(block: b)
        slotStatus =  CCIDProtocoll.CCID_SlotStausBlock(block: b)
        parameterBlock = CCIDProtocoll.CCID_ParameterBlock(block: b)
        
        length = 0
        slot = 0
        cmdSequence = 0
        slotstatus = 0
        slotError = 0
        chainParameter = 0
        commandoData = ""
        clockStatus = 0

        
        if(b[0] == CCIDProtocoll.CCIDReturnBlockType.data_BLOCK.rawValue)
        {
            dataBlock.buildDataBlock()
        }
        else if(b[0] == CCIDProtocoll.CCIDReturnBlockType.slot_STATUS.rawValue)
        {
            slotStatus.buildSlotStausBlock()
        }
        else if(b[0] == CCIDProtocoll.CCIDReturnBlockType.parameter_BLOCK.rawValue)
        {
            parameterBlock.buildParameterBlock()
        }
        else if(b[0] == CCIDProtocoll.CCIDReturnBlockType.esc_BLOCK.rawValue)
        {
            escBlock.buildESCBlock()
        }

    }
    
}
