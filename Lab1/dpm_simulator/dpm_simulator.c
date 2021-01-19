/**
 * @brief The main DPM simulator program
 */

#include "inc/psm.h"
#include "inc/dpm_policies.h"
#include "inc/utilities.h"

int main(int argc, char *argv[]) {

    char fwl[MAX_FILENAME];
    psm_t psm;
    dpm_timeout_params tparams;
    dpm_history_params hparams;
    dpm_policy_t sel_policy;
	char res_name [2*MAX_FILENAME] = "example/Rdata/";

    if(!parse_args(argc, argv, fwl, &psm, &sel_policy, &tparams, &hparams, res_name)) {
        printf("[error] reading command line arguments\n");
        return -1;
    }
	#ifdef PRINT
    psm_print(psm);
	#endif
	
	dpm_simulate(psm, sel_policy, tparams, hparams, fwl, res_name);

    return 0;
}
