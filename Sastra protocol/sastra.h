#ifndef __sastra_h__
#define __sastra_h__

#include "sastra_pkt.h"
#include "sastra_rtable.h"
#include <agent.h>
#include <packet.h>
#include <trace.h>
#include <timer-handler.h>
#include <random.h>
#include <classifier-port.h>
#include <mobilenode.h>
#include "arp.h"
#include "ll.h"
#include "mac.h"
#include "ip.h"
#include "delay.h"

#define CURRENT_TIME Scheduler::instance().clock()
#define JITTER (Random::uniform()*0.5)

class Sastra; // forward declaration

/* Timers */

class Sastra_PktTimer : public TimerHandler {
    public:
    Sastra_PktTimer(Sastra* agent) : TimerHandler() {
    	agent_ = agent;
    }
    
    protected:
    Sastra* agent_;
    virtual void expire(Event* e);
};

/* Agent */

class Sastra : public Agent {

   /* Friends */
   friend class Sastra_PktTimer;

   /* Private members */
   nsaddr_t ra_addr_;
   //sastra_state state_;
   sastra_rtable rtable_;
   int accesible_var_;
   u_int8_t seq_num_;

   protected:

   MobileNode* node_;
   PortClassifier* dmux_; // For passing packets up to agents.
   Trace* logtarget_; // For logging.
   Sastra_PktTimer pkt_timer_; // Timer for sending packets.

   inline nsaddr_t& ra_addr() { return ra_addr_; }
   //inline sastra_state& state() { return state_; }
   inline int& accessible_var() { return accesible_var_; }
 
   void forward_data(Packet*);
   void recv_sastra_pkt(Packet*);
   void send_sastra_pkt();
  
   void reset_sastra_pkt_timer();
 
   public:

   Sastra(nsaddr_t);
   int command(int, const char*const*);
   void recv(Packet*, Handler*);
   //void mac_failed(Packet*);
};

#endif

