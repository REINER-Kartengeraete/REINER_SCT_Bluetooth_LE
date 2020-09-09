//
//  DER_Helper.h
//
//
//
//  Copyright (c) 2014 REINER SCT. All rights reserved.
//
//  Version:    1.0.7
//  Date:       10.2.2015
//  Autor:
//  eMail:      mobile-sdk@reiner-sct.com

#ifndef DER_HELPER_H
#define DER_HELPER_H
#if defined __cplusplus
extern "C"
{
#endif

typedef struct
{
	unsigned long fullLength;
	const unsigned char *Start;
	unsigned int TagCount;
	unsigned int TagIndex;
	unsigned long TagNumber;
	unsigned int lT;
	const unsigned char *T;
	unsigned long L;
	const unsigned char *V;
}tTLV_Helper;

extern int InitTLV_Helper(tTLV_Helper *TLV,const unsigned char *Data, unsigned long fulllength);
extern int TLV_HelperNext(tTLV_Helper *TLV);
extern int InitTL_Helper(tTLV_Helper *TLV,const unsigned char *Data, unsigned long fulllength);
extern int TL_HelperNext(tTLV_Helper *TLV);
#if defined __cplusplus
}
#endif

#endif
