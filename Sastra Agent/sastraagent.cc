//creation of new agent 

#include <stdio.h>
#include <string.h>
#include "agent.h"
class SastraAgent : public Agent {

public:
		SastraAgent(); //constructor
protected:
	int command(int argc,const char*const* argv);
private:
		double inches;
		void ComputeInches();
		
};
// this class connects otcl and cpp
static class SastraAgentClass : public TclClass{
public :
		SastraAgentClass(): TclClass("Agent/SASTRA") {}
		// set value [new Agent/SASTRA]
		TclObject* create(int, const char*const*){
			return (new SastraAgent());
		}
		
} class_sastra_agent;
// shadow object
/* 
when tcl obj is called then the c++ class will return an agent , if the agent is not presnt , it shows a failed shadow object error
*/
SastraAgent::SastraAgent():Agent(PT_UDP){
                  bind("Inches",&inches);
                  // binding b/w otcl and cpp variables
}

int SastraAgent::command(int argc,const char*const* argv){
	if (argc==2){
		if(strcmp(argv[1],"inchsensor")==0){
				ComputeInches();
				return (TCL_OK);
	     }
	     return (Agent::command(argc,argv));
    }
    }
// $ns 	 inchsensor
//    1     		2
//argv[0] 	argv[1]

void SastraAgent::ComputeInches(){
	Tcl& tcl =Tcl::instance();
	tcl.eval("puts  \" message from inches\" ");
	tcl.evalf("puts  \" Inches to cm  is %f\" ",inches*2.54);
	

}
