
This remains the active public repository as of 29 Apr 2019.  

Also, if you have docker installed, run the following to get the TAGA Docker Image:

$ sudo docker run -it dmeekabc/taga

GIT Version V28 - the MGEN SOURCE has been removed from the main branch.

# tagaProducts
# tagaProductized
Letter to Potential Partners April 2016
Beneficial LLC and IBOA Corp are seeking partners in pursuit of DOD and other Government agency contracts.  We are specifically targeting the U.S. Army CERDEC Industry Day as an enabling event to further our goals.  Our core strengths include systems and software engineering, network management, database management, and Test and Evaluation.  We are a small organization which provides fluidity and flexibility in our endeavors.  We have developed two key products which we are introducing in this letter and in our effort to gain partnerships and win DoD business.  These two products are independent of one another, however when deployed in an integrated manner, significant synergistic gains are realized.   When deployed smartly and proactively, these two products become “extreme force multipliers.”  Benefits include efficient integration, reduced cycle times, less time preparing, more time analyzing, reduced staff, and reduced costs.  Our business model assumes large-scale deployment of these two products into a large number of DoD network laboratories.  Our in-depth knowledge and experience with these two products positions us to win or help win large DOD contracts when test automation is a goal and priority. These two key products are the following:
         IBOA Auto-Alias / Auto-Alias Creation Utility
         IBOA TAGA (Test Auto Generation and Analysis) Framework 
 
IBOA Product
File Count (Note1)  
SLOC (Note1)
IBOA Product Description
IBOA Auto-Alias Utility
Min Files: 1
Max Files: 5
Min: 250
Max: 1000
Increases general productivity in standard Unix/Linux shell environments
IBOA TAGA Framework
Files: 100
Subdirs: 20
7000
Provides simple and repeatable automated testing and unique insights into test networks

(1) Counts are approximate; Min/Max file counts provide differing levels of capability; Note that significant and large amounts of processing are possible with small Unix/Linux Shell Script SLOC.

Early versions of the IBOA Auto-Alias Utility were successfully deployed at Alcatel USA and many other telecom and software companies.  Early versions of the TAGA framework were successfully deployed at Harris Corp during performance and functional testing of the Soldier Radio Waveform (SRW).  The TAGA framework has integrated with Harris Network Simulation (NetSim) scripts and in the Harris 10 and 40 node network simulations.  The framework has been used in the CERDEC C4ISR Systems Integration Lab (CSIL) during the Mid-tier Networking Vehicular Radio (MNVR) Lab-based risk reduction and has been used in the assessment of emerging standards and technologies within the U.S. Army CERDEC S&TCD SEAMS.  
Specific areas of interest at the CERDEC Industry Day:

Contract Type: FFP/CPFF  Contact: ACC-APG
Estimated Solicitation Release Date: 2QFY16
S&TCD Enabling Infrastructure
Est. Value $TBD
Systems Engineering Support (GSA Schedule)
Est. Value $75M
IBOA Auto-Alias / Auto-Alias Creation Utility April 2016
The IBOA Auto-Alias utility is used to easily add, insert, edit, trace, and manage (archive) unix/linux alias commands.  The IBOA Utility provides a standardized and simplified mechanism to create and manage aliases allowing for more prolific usage and larger benefit as a result.  By reducing keystrokes and providing meaningful shortcuts, smart alias command usage significantly improves the productivity of test and development staffs.  When deployed smartly and proactively, the IBOA Auto-Alias utility becomes an “extreme force multiplier.”  Benefits include efficient integration, reduced cycle times, less time preparing, more time analyzing, reduced staff, and reduced costs.  Our in-depth knowledge and experience with this product positions us to win or help win large DOD contracts when DT&E cycle time reductions are a goal and priority. The IBOA Auto-Alias Utility is easily installed via the single IBOA Install File.  The IBOA Auto-Alias Utility is described as follows:
         IBOA Auto-Alias / Auto Alias Creation Utility is described here.
 
File Count 
SLOC
IBOA Product Description
Min: 1
Max: 5
Min: 250
Max: 1000
Increases general productivity in standard Unix/Linux shell environ; Min (1) to max (5) file counts provide increasing levels of capability.

         Six (6)  CORE Comands: IBOA Auto-Alias Utility Six (6) Core Commands are described.

IBOA Utility Core Alias
IBOA Utility Core Command
IBOA Utility Alias Six (6) Core Command Description
aa
Add alias
Used to add a new alias or edit an existing alias into the default .bashrc.iboa.* file for which it has been default configured; Note that the add alias (aa) and edit alias (ea) provide identical functions.
ea
Edit alias
Used to add a new alias or edit an existing alias into the default .bashrc.iboa.* file for which it has been default configured; Note that the add alias (aa) and edit alias (ea) provide identical functions.
ia
Insert Alias
Used to insert an existing alias into the default .bashrc.iboa.* file.
iap
Insert Alias (P)revious
Used to (create and) insert an alias ((p)revious command as value) into the default .bashrc.iboa.* file.
iapw
Insert Alias (P)revious (W)atch
Used to (create and) insert an alias ((p)revious command as value) with capability to ((w)atch) repeatedly) into the default .bashrc.iboa.* file.
ta
Trace Alias
Used to trace an alias to the root of the alias command intent

A complete description of the IBOA Auto-Alias Utility can be found in the Appendix A.

IBOA Test Auto Generation and Analysis (TAGA) Capabilities / Features April 2016

#####################################################
# Copyright 2016 IBOA Corp
# All Rights Reserved
#####################################################

=============================
TAGA Features:
=============================

  Deployment:
  -----------
  1. Unix/Linux shell script-based capabilities reduce dependencies and simplify deployment
  2. Auto Self Replication
  3. Auto Key Generation and Distribution

  Run-time:
  -----------
  1. Auto Configuration of Interface Names and Host Names (via targetList)
  2. Auto Determination of Network Environment and Environment based Auto Configuration
  3. Auto Network Node Time Synchronization Verification
  4. Auto Distribution of (updates to) Configuration
  5. Auto File Collection and Process Cleanup
  6. Auto Generation of Analytical Artifacts
  7. Auto resource utilization monitor and display
  8. Distributed and Parallel Processing provides for timely and robust data generation and collection
  9. Policy-Based Management (e.g. Log Mgt and Network Overhead Control) (Note1)
  10. Auto Fault Detection and Recovery (Condition-based Automatic Node and Network-wide Reboots) 
         - this automatically pinpoints network faults 
         - this allows for *unmanned* and *24x7* testing 
  11. TAGA Convergence utility
         - simplifies determination of network stability, usability and test scenario repeatability
         - allows for user-configurable blacklist handling
  12. Precise synchronization of traffic generation initiation
  13. Six levels of run-time output - user specified

  Extendability:
  -----------
  1. Start of Test (Traffic), Middle of Test (Traffic), and End of Run Test (Traffic) Test Shells Provided
  2. TAGA Provided Samples include Pub/Sub implementation and File Input/output in Python and C languages 

  Scalability:
  -----------
  1. TAGA Display scales automatically based on node count and duration 
  2. TAGA 'Run and Mon' Utility scales automatically based on target list update 
  3. TAGA Utility scales well by limiting configuration changes to two primary configuration 
     files (config, targetList.sh) and a few key params (timer delays, traffic rates/counts, etc)
  4. Round-robin and staggered starts help avoid traffic overload during large network tests

  Ease of Use:
  -----------
  1. Basic Network Health Check at a single commmand (run or mon)
  2. Tailorability of Displays
  3. Standardized INFO, WARN, and ALARM tags simplify filtering (Note1)
  4. "Go Remote" "Probe" "Prep" "TimeTimer" and other time saving utilities
  5. Human Readable and Tailorable Timestamps
  6. Multiple Interfaces per Host supported (Note1)

  Other:
  -----------
  1. IBOA Auto Alias Utility is bundled with the TAGA Framework Release
      - enables fast and automatic creation of individual and group (team) specialized aliases
          - smart aliases increase workflow and productivity by reducing keystrokes and input errors
          - smart aliases allow for more work at the end of the day and reduce cycle times 
      - enables fast filter creation for enhanced data analysis
      - fosters teamwork, collaboration, and communication
  2. Sample Filters and other extensions available upon request to info@iboa.us

=============================
TAGA Future Extensions:
=============================
  1. More capable Automated Test Analytic Artifact Generation (ATAAG) (TM pending) (IBOA AI filters).
  2. Complete implementation of items identified by Note1 (Initially/Partially supported items).
  3. Additional protocol support (options to UDP, TCP, SSH, etc.)
  4. Scalability and Performance Improvements
  5. IPv6 Support

=============================
TAGA System Requirements:
=============================

1. Linux-like operating environment
2. Bash or equivalent shell (for full capabilities)
3. libssh (ssh)
4. libpcap (tcpdump)
5. mgen, iperf, or similar traffic generation engines
6. IPv4-based network addressing scheme

---------
NOTES:
---------
Note1: Initial/Partial Support Only


Appendix A

IBOA Auto-Alias / Auto-Alias Creation Utility April 2016
The IBOA Auto-Alias utility is used to easily add, insert, edit, trace, and manage (archive) unix/linux alias commands.  The IBOA Utility provides a standardized and simplified mechanism to create and manage aliases allowing for more prolific usage and larger benefit as a result.  By reducing keystrokes and providing meaningful shortcuts, smart alias command usage significantly improves the productivity of test and development staffs.  When deployed smartly and proactively, the IBOA Auto-Alias utility becomes an “extreme force multiplier.”  Benefits include efficient integration, reduced cycle times, less time preparing, more time analyzing, reduced staff, and reduced costs.  Our in-depth knowledge and experience with this product positions us to win or help win large DOD contracts when DT&E cycle time reductions are a goal and priority. The IBOA Auto-Alias Utility is easily installed via the single IBOA Install File.  The IBOA Auto-Alias Utility is described as follows:
         IBOA Auto-Alias / Auto Alias Creation Utility is described here.
 
File Count 
SLOC
IBOA Product Description
Min: 1
Max: 5
Min: 250
Max: 1000
Increases general productivity in standard Unix/Linux shell environ; Min (1) to max (5) file counts provide increasing levels of capability.

         Six (6)  CORE Comands: IBOA Auto-Alias Utility Six (6) Core Commands are described.

IBOA Utility Core Alias
IBOA Utility Core Command
IBOA Utility Alias Six (6) Core Command Description
aa
Add alias
Used to add a new alias or edit an existing alias into the default .bashrc.iboa.* file for which it has been default configured; Note that the add alias (aa) and edit alias (ea) provide identical functions.
ea
Edit alias
Used to add a new alias or edit an existing alias into the default .bashrc.iboa.* file for which it has been default configured; Note that the add alias (aa) and edit alias (ea) provide identical functions.
ia
Insert Alias
Used to insert an existing alias into the default .bashrc.iboa.* file.
iap
Insert Alias (P)revious
Used to (create and) insert an alias ((p)revious command as value) into the default .bashrc.iboa.* file.
iapw
Insert Alias (P)revious (W)atch
Used to (create and) insert an alias ((p)revious command as value) with capability to ((w)atch) repeatedly) into the default .bashrc.iboa.* file.
ta
Trace Alias
Used to trace an alias to the root of the alias command intent

         User/Group/System Config: IBOA Auto-Alias Default Configurations is described here.

IBOA Utility Alias
IBOA Utility Command
IBOA Utility Alias Command Description
aau
Add alias (U)ser
Used to add a new alias or edit an existing alias into the .bashrc.iboa.user.$userId file for which it has been automatically configured; Note that the add alias (aa) and edit alias (ea) provide identical functions. Note that this alias is NOT normally used since the more terse ‘aa’ command is typically configured and preferred instead.
aag
Add alias (G)roup
Used to add a new alias or edit an existing alias into the .bashrc.iboa.group.$groupId file for which it has been automatically configured; Note that the add alias (aa) and edit alias (ea) provide identical functions. This alias is used when changes for all users of an entire group (unix/linux work group) are desired.
aas
Add alias (S)ystem
Used to add a new alias or edit an existing alias into the .bashrc.iboa.system file for which it has been automatically configured; Note that the add alias (aa) and edit alias (ea) provide identical functions. This alias is used when changes for all users of the entire system (computer) are desired.
iau
Insert alias (U)ser
Used to insert an existing alias into the .bashrc.iboa.user.$userId file for which it has been automatically configured; Note that this alias is NOT normally used since the more terse ‘ia’ command is typically configured and preferred instead.
iag
Insert alias (G)roup
Used to insert an existing alias into the .bashrc.iboa.group.$groupId file for which it has been automatically configured; This alias is used when changes for all users of an entire group (unix/linux work group) are desired.
ias
Insert alias (S)ystem
Used to insert an existing alias into the .bashrc.iboa.system file for which it has been automatically configured;  This alias is used when changes for all users of the entire system (computer) are desired.

         Sample Utility Aliases: IBOA Auto-Alias Utility Sample Utility Commands shown here.

IBOA Utility Alias
IBOA Utility Command
IBOA Utility Alias Command Description
lr
Listing (R)everse-Time order
Listing (R)everse-Time order
s
Search
Search for Unix/Linux process
u
Up
Move up one directory (change directory up one level)
uu
Up Up
Move up two directories (change directory up two levels)
Note: The (u)p commands are supported for 10 levels by default
gt,
ge
(g)o to (t)mp,
(g)o to (e)tc
Go to /tmp directory (provided here as sample ‘goto’ command)
Note: Such “Goto” commands are extremely useful by streamlining navigation to commonly used user, group, or system directories.



Appendix B


Watch our IBOA video on Youtube:   https://www.youtube.com/watch?v=T2YWFmDozqc

          Watch our TAGA video on Youtube: https://www.youtube.com/watch?v=ZzIcV9wDWu4




For more information or TAGA/IBOA product demonstration, please contact:  info@iboa.us

Hahn Kang, Business Manager
LTC (R) Joseph Farrell, Security Manager
David Doerries, Operations Manager
Darrin Meek, Technology Manager
info@iboa.us,   469-879-3496
