/**********************************************************************
 *
 * Copyright (c) IBOA Corp 2017
 *
 * All Rights Reserved
 *                                                                     
 * Redistribution and use in source and binary forms, with or without  
 * modification, are permitted provided that the following conditions 
 * are met:                                                             
 * 1. Redistributions of source code must retain the above copyright    
 *    notice, this list of conditions and the following disclaimer.     
 * 2. Redistributions in binary form must reproduce the above           
 *    copyright notice, this list of conditions and the following       
 *    disclaimer in the documentation and/or other materials provided   
 *    with the distribution.                                            
 *                                                                      
 * THIS SOFTWARE IS PROVIDED BY THE AUTHORS ``AS IS'' AND ANY EXPRESS   
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED    
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE   
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE     
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR  
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT    
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR   
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF           
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT            
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE    
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH     
 * DAMAGE.                                                              
 *
**********************************************************************/
#include <cstdlib>
#include <stdio.h>
#include "tagaServiceBase.h"

void myclass::setx(int newx) { myx = newx; }
int  myclass::getx() { return myx; }

void myclass2::setx(int newx) { myx = newx; }
int  myclass2::getx() { return myx; }

void tagaServiceBase::setx(int newx) { myx = newx; }
void tagaServiceBase::sety(int newy) { myy = newy; }
int  tagaServiceBase::getx() { return myx; }
int  tagaServiceBase::gety() { return myy; }

// dlm temp, I shouldn't need to define these, should get these from base but not working so define again here
// dlm temp, I shouldn't need to define these, should get these from base but not working so define again here
void tagaCommsService::setx(int newx) { tagaServiceBase::setx(newx); }
int  tagaCommsService::getx() { return tagaServiceBase::getx(); }

int  tagaCommsService::sendFile() { myRetCode = 99; return myRetCode; }
int  tagaCommsService::sendFile(int p1, int p2, int p3) { myRetCode = p1+p2+p3; return myRetCode; }
int  tagaLogService::logEvent() { myRetCode = 99; return myRetCode; }
int  tagaLogService::logEvent(int p1, int p2, int p3) { myRetCode = p1+p2+p3; return myRetCode; }
int  tagaMonitoringService::monitor() { myRetCode = 99; return myRetCode; }
int  tagaMonitoringService::monitor(int p1, int p2, int p3) { myRetCode = p1+p2+p3; return myRetCode; }
int  tagaMessagingService::sendFile() { myRetCode = 99; return myRetCode; }
int  tagaMessagingService::sendFile(int p1, int p2, int p3) { myRetCode = p1+p2+p3; return myRetCode; }
int  tagaConfigurationService::configure() { myRetCode = 99; return myRetCode; }
int  tagaConfigurationService::configure(int p1, int p2, int p3) { myRetCode = p1+p2+p3; return myRetCode; }
int  tagaTranslationService::translate() { myRetCode = 99; return myRetCode; }
int  tagaTranslationService::translate(int p1, int p2, int p3) { myRetCode = p1+p2+p3; return myRetCode; }
int  tagaPolicyService::policy() { myRetCode = 99; return myRetCode; }
int  tagaPolicyService::policy(int p1, int p2, int p3) { myRetCode = p1+p2+p3; return myRetCode; }


//void tagaCommsService::setx(int newx) { myx = newx; }
//int  tagaCommsService::getx() { return myx; }
//int  tagaCommsService::sendFile() { myRetCode = 99; return myRetCode; }
//int  tagaCommsService::sendFile(int p1, int p2, int p3) { myRetCode = p1+p2+p3; return myRetCode; }
//int  tagaLogService::logEvent() { myRetCode = 99; return myRetCode; }
//int  tagaLogService::logEvent(int p1, int p2, int p3) { myRetCode = p1+p2+p3; return myRetCode; }
//int  tagaMonitoringService::monitor() { myRetCode = 99; return myRetCode; }
//int  tagaMonitoringService::monitor(int p1, int p2, int p3) { myRetCode = p1+p2+p3; return myRetCode; }
//int  tagaMessagingService::sendFile() { myRetCode = 99; return myRetCode; }
//int  tagaMessagingService::sendFile(int p1, int p2, int p3) { myRetCode = p1+p2+p3; return myRetCode; }
//int  tagaConfigurationService::configure() { myRetCode = 99; return myRetCode; }
//int  tagaConfigurationService::configure(int p1, int p2, int p3) { myRetCode = p1+p2+p3; return myRetCode; }
//int  tagaTranslationService::translate() { myRetCode = 99; return myRetCode; }
//int  tagaTranslationService::translate(int p1, int p2, int p3) { myRetCode = p1+p2+p3; return myRetCode; }
//int  tagaPolicyService::policy() { myRetCode = 99; return myRetCode; }
//int  tagaPolicyService::policy(int p1, int p2, int p3) { myRetCode = p1+p2+p3; return myRetCode; }

int  tagaMessagingService::sendFile(string source, string dest) 
{ 
   
   char popenResponseBuf[100];
   for (int i = 0; i < 100; i++ )
   { popenResponseBuf[i] = 0; }

   // Prepare to get the Target List Index
   string popenCmdBuf("/home/pi/scripts/taga/tagaScripts/tagaScriptsUtils/targetListIndex.sh");

   // get the Target List Index into the popenResponseBuf buffer
   FILE *fp = popen(popenCmdBuf.c_str(), "r");
   fscanf(fp, "%s", popenResponseBuf);
   pclose(fp);

   string systemCmdBuf("echo ");
   systemCmdBuf += source;
   systemCmdBuf += " ";
   systemCmdBuf += popenResponseBuf;
   systemCmdBuf += " >> /tmp/tagaServiceBase.out";
   int systemReturnCode = system(systemCmdBuf.c_str());
   myRetCode = systemReturnCode; 
   return myRetCode; 

}
