//
//  DER_Helper.c
//  rsct_hhd_le_sample
//
//
//  Copyright (c) 2014 REINER SCT. All rights reserved.
//
//  Version:    1.0.7
//  Date:       10.2.2015
//  Autor:
//  eMail:      mobile-sdk@reiner-sct.com

#ifdef WIN32
#include <stddef.h>
#include <memory.h>
#else
#include <string.h>
#endif

#include "DER_Helper.h"


static unsigned int GetTagIndexLength(const unsigned char *Data, unsigned long maxlength,unsigned long *TagNumber)
{
    unsigned int Result=1;
    if(maxlength==0)
        return 0;
    if((*Data & 0x1f) == 0x1f)
    {
        *TagNumber=0;
        do
        {
            Data++;
            maxlength--;
            Result++;
            *TagNumber<<=7;
            if(maxlength==0)
                return 0;
            *TagNumber|=*Data & 0x7f;
        }while(*Data & 0x80);
    }
    else
        *TagNumber=*Data & 0x1f;
    return Result;
}

static unsigned int GetTagLengthLength(const unsigned char *Data, unsigned long maxlength,unsigned long *TagLength)
{
    unsigned int Result=1;
    unsigned int i;
    if(maxlength==0)
        return 0;
    if(*Data & 0x80)
    {
        i=*Data & 0x7f;
        if(i==0 || i>4)
            return 0;
        *TagLength=0;
        do
        {
            Data++;
            maxlength--;
            Result++;
            *TagLength<<=8;
            if(maxlength==0)
                return 0;
            *TagLength|=*Data;
            //   		if(*TagLength==0)
            //	   		return 0;
        }while(--i);
    }
    else
        *TagLength=*Data;
    return Result;
}


int InitTLV_Helper(tTLV_Helper *TLV,const unsigned char *Data, unsigned long fulllength)
{
    unsigned int Length;
    unsigned long Value;
    unsigned long Rest;
    unsigned int TagCount=0;
    const unsigned char *ptr;
    memset(TLV,0,sizeof(tTLV_Helper));
    while(fulllength && *Data==0)
    {
        fulllength--;
        Data++;
    }
    if(fulllength==0)
        return 0;
    ptr=Data;
    Rest=fulllength;
    do
    {
        while(Rest && *ptr==0)
        {
            Rest--;
            ptr++;
        }
        if(Rest==0)
            break;
        if((Length=GetTagIndexLength(ptr,Rest,&Value))==0)
            return 0;
        ptr+=Length;
        Rest-=Length;
        if((Length=GetTagLengthLength(ptr,Rest,&Value))==0)
            return 0;
        ptr+=Length;
        Rest-=Length;
        if(Value>Rest)
            return 0;
        ptr+=Value;
        Rest-=Value;
        TagCount++;
    }while(Rest);
    TLV->fullLength=fulllength;
    TLV->TagCount=TagCount;
    TLV->TagIndex=1;
    TLV->T=Data;
    TLV->Start=Data;
    TLV->lT=GetTagIndexLength(Data,fulllength,&(TLV->TagNumber));
    Data+=TLV->lT;
    fulllength-=TLV->lT;
    Data+=GetTagLengthLength(Data,fulllength,&(TLV->L));
    TLV->V=Data;
    return (TLV->T[0] & 0xe0) | 0x01;
}

int TLV_HelperNext(tTLV_Helper *TLV)
{
    const unsigned char *Data;
    unsigned long fulllength;
    if(TLV->TagIndex>=TLV->TagCount)
        return 0;
    fulllength=TLV->fullLength;
    TLV->TagIndex++;
    Data=TLV->V + TLV->L;
    while(fulllength && *Data==0)
    {
        fulllength--;
        Data++;
    }
    if(fulllength==0)
        return 0;
    TLV->T=Data;
    TLV->lT=GetTagIndexLength(Data,fulllength,&(TLV->TagNumber));
    Data+=TLV->lT;
    fulllength-=TLV->lT;
    Data+=GetTagLengthLength(Data,fulllength,&(TLV->L));
    TLV->V=Data;
    return (TLV->T[0] & 0xe0) | 0x01;
}


int InitTL_Helper(tTLV_Helper *TLV,const unsigned char *Data, unsigned long fulllength)
{
    unsigned int Length;
    unsigned long Value;
    unsigned long Rest;
    unsigned int TagCount=0;
    const unsigned char *ptr;
    memset(TLV,0,sizeof(tTLV_Helper));
    while(fulllength && *Data==0)
    {
        fulllength--;
        Data++;
    }
    if(fulllength==0)
        return 0;
    ptr=Data;
    Rest=fulllength;
    do
    {
        while(Rest && *ptr==0)
        {
            Rest--;
            ptr++;
        }
        if(Rest==0)
            break;
        if((Length=GetTagIndexLength(ptr,Rest,&Value))==0)
            return 0;
        ptr+=Length;
        Rest-=Length;
        if((Length=GetTagLengthLength(ptr,Rest,&Value))==0)
            return 0;
        ptr+=Length;
        Rest-=Length;
        TagCount++;
    }while(Rest);
    TLV->fullLength=fulllength;
    TLV->TagCount=TagCount;
    TLV->TagIndex=1;
    TLV->T=Data;
    TLV->Start=Data;
    TLV->lT=GetTagIndexLength(Data,fulllength,&(TLV->TagNumber));
    Data+=TLV->lT;
    fulllength-=TLV->lT;
    Data+=GetTagLengthLength(Data,fulllength,&(TLV->L));
    TLV->V=Data;
    return (TLV->T[0] & 0xe0) | 0x01;
}

int TL_HelperNext(tTLV_Helper *TLV)
{
    const unsigned char *Data;
    unsigned long fulllength;
    if(TLV->TagIndex>=TLV->TagCount)
        return 0;
    fulllength=TLV->fullLength;
    TLV->TagIndex++;
    Data=TLV->V;
    TLV->T=Data;
    TLV->lT=GetTagIndexLength(Data,fulllength,&(TLV->TagNumber));
    Data+=TLV->lT;
    fulllength-=TLV->lT;
    Data+=GetTagLengthLength(Data,fulllength,&(TLV->L));
    TLV->V=Data;
    return (TLV->T[0] & 0xe0) | 0x01;
}

