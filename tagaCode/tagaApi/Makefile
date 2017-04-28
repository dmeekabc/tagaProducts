#######################################################################
#
# Copyright (c) IBOA Corp 2017
#
# All Rights Reserved
#                                                                     
# Redistribution and use in source and binary forms, with or without  
# modification, are permitted provided that the following conditions 
# are met:                                                             
# 1. Redistributions of source code must retain the above copyright    
#    notice, this list of conditions and the following disclaimer.     
# 2. Redistributions in binary form must reproduce the above           
#    copyright notice, this list of conditions and the following       
#    disclaimer in the documentation and/or other materials provided   
#    with the distribution.                                            
#                                                                      
# THIS SOFTWARE IS PROVIDED BY THE AUTHORS ``AS IS'' AND ANY EXPRESS   
# OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED    
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE   
# ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE     
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR  
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT    
# OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR   
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF           
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT            
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE    
# USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH     
# DAMAGE.                                                              
#
#######################################################################

tagaUser: libtagaApi.so tagaUser.o
	$(CXX) -o tagaUser tagaUser.o -L. -ltagaApi

tagaUser2: libtagaApi2.so tagaUser2.o
	$(CXX) -o tagaUser2 tagaUser2.o -L. -ltagaApi2

tagaUser3: libtagaApi3.so tagaUser3.o
	$(CXX) -o tagaUser3 tagaUser3.o -L. -ltagaApi3

tagaUser4: libtagaApi4.so tagaUser4.o
	$(CXX) -o tagaUser4 tagaUser4.o -L. -ltagaApi4

tagaUser5: libtagaApi5.so tagaUser5.o
	$(CXX) -o tagaUser5 tagaUser5.o -L. -ltagaApi5

tagaClient: libtagaServiceBase.so tagaClient.o
	$(CXX) -o tagaClient tagaClient.o -L. -ltagaServiceBase

tagaClient2: libtagaServiceBase.so tagaClient2.o
	$(CXX) -o tagaClient2 tagaClient2.o -L. -ltagaServiceBase

tagaClient3: libtagaServiceBase.so tagaClient3.o
	$(CXX) -o tagaClient3 tagaClient3.o -L. -ltagaServiceBase

tagaClient4: libtagaServiceBase.so tagaClient4.o
	$(CXX) -o tagaClient4 tagaClient4.o -L. -ltagaServiceBase

tagaClient5: libtagaServiceBase.so tagaClient5.o
	$(CXX) -o tagaClient5 tagaClient5.o -L. -ltagaServiceBase

libtagaApi.so: tagaApi.cpp
	$(CXX) -fPIC -c tagaApi.cpp -o tagaApi.o
	$(CXX) -shared -Wl,-soname,libtagaApi.so -o libtagaApi.so tagaApi.o

libtagaApi2.so: tagaApi2.cpp
	$(CXX) -fPIC -c tagaApi2.cpp -o tagaApi2.o
	$(CXX) -shared -Wl,-soname,libtagaApi2.so -o libtagaApi2.so tagaApi2.o

libtagaApi3.so: tagaApi3.cpp
	$(CXX) -fPIC -c tagaApi3.cpp -o tagaApi3.o
	$(CXX) -shared -Wl,-soname,libtagaApi3.so -o libtagaApi3.so tagaApi3.o

libtagaApi4.so: tagaApi4.cpp
	$(CXX) -fPIC -c tagaApi4.cpp -o tagaApi4.o
	$(CXX) -shared -Wl,-soname,libtagaApi4.so -o libtagaApi4.so tagaApi4.o

libtagaApi5.so: tagaApi5.cpp
	$(CXX) -fPIC -c tagaApi5.cpp -o tagaApi5.o
	$(CXX) -shared -Wl,-soname,libtagaApi5.so -o libtagaApi5.so tagaApi5.o

libtagaServiceBase.so: tagaServiceBase.cpp
	$(CXX) -fPIC -c tagaServiceBase.cpp -o tagaServiceBase.o
	$(CXX) -shared -Wl,-soname,libtagaServiceBase.so -o libtagaServiceBase.so tagaServiceBase.o

all: tagaUser tagaUser2 tagaUser3 tagaUser4 tagaUser5 tagaClient tagaClient2 tagaClient3 tagaClient4 tagaClient5

clean:
	rm *.o *.so
