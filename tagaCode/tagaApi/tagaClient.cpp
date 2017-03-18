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
#include <iostream>
#include <cstdlib>
#include <stdio.h>
#include "tagaServiceBase.h"

using namespace std;

int main(int argc, char *argv[])
{
  myclass m;
  myclass2 m2;
  tagaCommsService commsService;
  tagaLogService logService;
  tagaMonitoringService monitoringService;
  tagaMessagingService messagingService;
  tagaConfigurationService configurationService;
  tagaTranslationService translationService;
  tagaPolicyService policyService;

  // print file name
  cout << argv[0] << endl;

  // print all input params
  for (int i = 1; i < argc; i++ )
  {
     cout << argv[i] << endl;
  }

  cout << m.getx() << endl;
  m.setx(10);
  cout << m.getx() << endl;

  cout << m2.getx() << endl;
  m2.setx(10);
  cout << m2.getx() << endl;

  cout << commsService.getx() << endl;
  commsService.setx(10);
  cout << commsService.getx() << endl;

  cout << commsService.gety() << endl;
  commsService.sety(10);
  cout << commsService.gety() << endl;

  cout << commsService.sendFile() << endl;
  cout << commsService.sendFile() << endl;

  cout << commsService.sendFile(1,2,3) << endl;
  cout << commsService.sendFile(1,2,3) << endl;

  cout << logService.logEvent() << endl;
  cout << logService.logEvent() << endl;

  cout << logService.logEvent(4,6,8) << endl;
  cout << logService.logEvent(4,6,8) << endl;

  cout << monitoringService.monitor() << endl;
  cout << monitoringService.monitor() << endl;

  cout << monitoringService.monitor(4,6,8) << endl;
  cout << monitoringService.monitor(4,6,8) << endl;

  cout << messagingService.sendFile() << endl;
  cout << messagingService.sendFile() << endl;

  //cout << messagingService.sendFile("/opt/taga/tagaTestFilesDir/tagaTest.txt", "dummy") << endl;

  string fileToSend(argv[1]);
  cout << messagingService.sendFile(fileToSend.c_str(), "dummy") << endl;

  cout << messagingService.sendFile(4,6,8) << endl;
  cout << messagingService.sendFile(4,6,8) << endl;

  cout << configurationService.configure() << endl;
  cout << configurationService.configure() << endl;

  cout << configurationService.configure(4,6,8) << endl;
  cout << configurationService.configure(4,6,8) << endl;

  cout << translationService.translate() << endl;
  cout << translationService.translate() << endl;

  cout << translationService.translate(4,6,8) << endl;
  cout << translationService.translate(4,6,8) << endl;

  cout << policyService.policy() << endl;
  cout << policyService.policy() << endl;

  cout << policyService.policy(4,6,8) << endl;
  cout << policyService.policy(4,6,8) << endl;

}
