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
#include <string>

using std::string;

class tagaServiceBase {
   int myx;
   int myy;

  protected:
   int myRetCode;

  public:

    tagaServiceBase() { myx=0; myy=0; }
    void setx(int newx);
    void sety(int newy);
    int  getx();
    int  gety();
    int  getSum();
};


class myclass {
   int myx;

  public:

    myclass() { myx=0; }
    void setx(int newx);
    int  getx();
};


class myclass2 {
   int myx;

  public:

    myclass2() { myx=0; }
    void setx(int newx);
    int  getx();
};


class tagaCommsService : public tagaServiceBase {

  public:

    tagaCommsService() { }

//    void setx(int newx);
//    void sety(int newy);
//    int  getx();
//    int  gety();

    int  sendFile();
    int  sendFile(int, int, int);

};


class tagaLogService : public tagaServiceBase {

  public:

    tagaLogService() { }
    void setx(int newx);
    int  getx();
    int  logEvent();
    int  logEvent(int, int, int);

};


class tagaMonitoringService : public tagaServiceBase {

  public:

    tagaMonitoringService() { }
    void setx(int newx);
    int  getx();
    int  monitor();
    int  monitor(int, int, int);

};


class tagaMessagingService : public tagaServiceBase {

  public:

    tagaMessagingService() { }
    void setx(int newx);
    int  getx();
    int  sendFile();
    int  sendFile(string, string);
    int  sendFile(int, int, int);

};


class tagaConfigurationService : public tagaServiceBase {

  public:

    tagaConfigurationService() { }
    void setx(int newx);
    int  getx();
    int  configure();
    int  configure(int, int, int);

};


class tagaTranslationService : public tagaServiceBase {

  public:

    tagaTranslationService() { }
    void setx(int newx);
    int  getx();
    int  translate();
    int  translate(int, int, int);

};


class tagaPolicyService : public tagaServiceBase {

  public:

    tagaPolicyService() { }
    void setx(int newx);
    int  getx();
    int  policy();
    int  policy(int, int, int);

};


