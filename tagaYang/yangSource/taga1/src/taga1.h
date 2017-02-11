
#ifndef _H_taga1
#define _H_taga1
/* 
 * Copyright (c) 2008-2012, Andy Bierman, All Rights Reserved.
 * Copyright (c) 2012 - 2016, YumaWorks, Inc., All Rights Reserved.
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *

*** Generated by yangdump-sdk 16.10-3

    Combined SIL header
    module taga1
    revision 2017-01-22
    namespace http://iboa.us/ns/taga1
    organization IBOA Corp
    Created: 2017-02-11T00:20:26Z
    CLI parameters:
        format h
        indent 4
        module taga1
        output taga1.h
        unified true

 */

#include <xmlstring.h>

#include "dlq.h"
#include "ncxtypes.h"
#include "op.h"
#include "status.h"
#include "val.h"

#ifdef __cplusplus
extern "C" {
#endif

#define y_taga1_M_taga1 (const xmlChar *)"taga1"

#define y_taga1_R_taga1 (const xmlChar *)"2017-01-22"

#define y_taga1_I_taga1_blue (const xmlChar *)"taga1-blue"
#define y_taga1_I_taga1_green (const xmlChar *)"taga1-green"
#define y_taga1_I_taga1_red (const xmlChar *)"taga1-red"
#define y_taga1_I_taga1_orange (const xmlChar *)"taga1-orange"
#define y_taga1_I_taga1_yellow (const xmlChar *)"taga1-yellow"

#define y_taga1_N_set_blue_state (const xmlChar *)"set-blue-state"
#define y_taga1_N_set_green_state (const xmlChar *)"set-green-state"
#define y_taga1_N_set_orange_state (const xmlChar *)"set-orange-state"
#define y_taga1_N_set_red_state (const xmlChar *)"set-red-state"
#define y_taga1_N_set_yellow_state (const xmlChar *)"set-yellow-state"
#define y_taga1_N_stric_state_transitions (const xmlChar *)"stric-state-transitions"
#define y_taga1_N_taga1 (const xmlChar *)"taga1"
#define y_taga1_N_taga1_PrimaryState (const xmlChar *)"taga1-PrimaryState"
#define y_taga1_N_taga1_SecondaryState (const xmlChar *)"taga1-SecondaryState"
#define y_taga1_N_taga1_TertiaryState (const xmlChar *)"taga1-TertiaryState"
#define y_taga1_N_taga1_change (const xmlChar *)"taga1-change"
#define y_taga1_N_taga1_newState (const xmlChar *)"taga1-newState"


/* container /taga1 */
typedef struct y_taga1_T_taga1_ {
    xmlChar *taga1_PrimaryState;
    xmlChar *taga1_SecondaryState;
    xmlChar *taga1_TertiaryState;
    boolean stric_state_transitions;
} y_taga1_T_taga1;

/* container /set-blue-state/input */
typedef struct y_taga1_T_set_blue_state_input_ {
} y_taga1_T_set_blue_state_input;

/* container /set-blue-state/output */
typedef struct y_taga1_T_set_blue_state_output_ {
} y_taga1_T_set_blue_state_output;

/* rpc /set-blue-state */
typedef struct y_taga1_T_set_blue_state_ {
    y_taga1_T_set_blue_state_input input;
    y_taga1_T_set_blue_state_output output;
} y_taga1_T_set_blue_state;

/* container /set-green-state/input */
typedef struct y_taga1_T_set_green_state_input_ {
} y_taga1_T_set_green_state_input;

/* container /set-green-state/output */
typedef struct y_taga1_T_set_green_state_output_ {
} y_taga1_T_set_green_state_output;

/* rpc /set-green-state */
typedef struct y_taga1_T_set_green_state_ {
    y_taga1_T_set_green_state_input input;
    y_taga1_T_set_green_state_output output;
} y_taga1_T_set_green_state;

/* container /set-red-state/input */
typedef struct y_taga1_T_set_red_state_input_ {
} y_taga1_T_set_red_state_input;

/* container /set-red-state/output */
typedef struct y_taga1_T_set_red_state_output_ {
} y_taga1_T_set_red_state_output;

/* rpc /set-red-state */
typedef struct y_taga1_T_set_red_state_ {
    y_taga1_T_set_red_state_input input;
    y_taga1_T_set_red_state_output output;
} y_taga1_T_set_red_state;

/* container /set-orange-state/input */
typedef struct y_taga1_T_set_orange_state_input_ {
} y_taga1_T_set_orange_state_input;

/* container /set-orange-state/output */
typedef struct y_taga1_T_set_orange_state_output_ {
} y_taga1_T_set_orange_state_output;

/* rpc /set-orange-state */
typedef struct y_taga1_T_set_orange_state_ {
    y_taga1_T_set_orange_state_input input;
    y_taga1_T_set_orange_state_output output;
} y_taga1_T_set_orange_state;

/* container /set-yellow-state/input */
typedef struct y_taga1_T_set_yellow_state_input_ {
} y_taga1_T_set_yellow_state_input;

/* container /set-yellow-state/output */
typedef struct y_taga1_T_set_yellow_state_output_ {
} y_taga1_T_set_yellow_state_output;

/* rpc /set-yellow-state */
typedef struct y_taga1_T_set_yellow_state_ {
    y_taga1_T_set_yellow_state_input input;
    y_taga1_T_set_yellow_state_output output;
} y_taga1_T_set_yellow_state;

/* notification /taga1-change */
typedef struct y_taga1_T_taga1_change_ {
    xmlChar *taga1_newState;
} y_taga1_T_taga1_change;


/********************************************************************
* FUNCTION y_taga1_taga1_change_send
*
* Send a y_taga1_taga1_change notification
* Called by your code when notification event occurs
*
********************************************************************/
extern void y_taga1_taga1_change_send (
    const xmlChar *taga1_newState);

/********************************************************************
* FUNCTION y_taga1_init
*
* initialize the taga1 server instrumentation library
*
* INPUTS:
*    modname == requested module name
*    revision == requested version (NULL for any)
*
* RETURNS:
*     error status
********************************************************************/
extern status_t y_taga1_init (
    const xmlChar *modname,
    const xmlChar *revision);

/********************************************************************
* FUNCTION y_taga1_init2
*
* SIL init phase 2: non-config data structures
* Called after running config is loaded
*
* RETURNS:
*     error status
********************************************************************/
extern status_t y_taga1_init2 (void);

/********************************************************************
* FUNCTION y_taga1_cleanup
*    cleanup the server instrumentation library
*
********************************************************************/
extern void y_taga1_cleanup (void);

#ifdef __cplusplus
} /* end extern 'C' */
#endif

#endif