#include "inc/utilities.h"

int parse_args(int argc, char *argv[], char *fwl, psm_t *psm, dpm_policy_t
        *selected_policy, dpm_timeout_params *tparams, dpm_history_params
        *hparams, char *res_name)
{
    int cur = 1;
    while(cur < argc) {

        if(strcmp(argv[cur], "-help") == 0) {
            print_command_line();
            return 0;
        }
	
        // set policy to timeout and get timeout value
        if(strcmp(argv[cur], "-t") == 0) {
            *selected_policy = DPM_TIMEOUT;
            if(argc > cur + DPM_N_TIMEOUTS) {
				int i;
				//result file name
				//if (cur == 1){
					strcat(res_name,argv[cur]);
					strcat(res_name,PRINTTOFILE_DELIMITER);
				//}
                for(i = 0; i < DPM_N_TIMEOUTS; i++) {
					tparams->timeout[i] = atof(argv[++cur]);
					// result file name
					//if (cur == 2 ||cur == 3 ){
						strcat(res_name,argv[cur]);
						strcat(res_name,PRINTTOFILE_DELIMITER);
					//}
                }
            }
            else return	0;
        }

        // set policy to history based and get parameters and thresholds
        if(strcmp(argv[cur], "-h") == 0) {
            *selected_policy = DPM_HISTORY;
            if(argc > cur + DPM_HIST_WIND_SIZE + DPM_N_THRESHOLDS){
                int i;
				//result file name
				//if (cur == 1){
					strcat(res_name,argv[cur]);
					strcat(res_name,PRINTTOFILE_DELIMITER);
				//}
                for(i = 0; i < DPM_HIST_WIND_SIZE; i++) {
                    hparams->alpha[i] = atof(argv[++cur]);
                }
				for(i = 0; i < DPM_N_THRESHOLDS; i++) {
                    hparams->threshold[i] = atof(argv[++cur]);
					//result file name
					//if (cur == 7 ||cur == 8 ){
						strcat(res_name,argv[cur]);
						strcat(res_name,PRINTTOFILE_DELIMITER);
					//}
                }
				//printf("%f,%f,%f,%f,%f\t%f,%f\n",hparams->alpha[0],hparams->alpha[1],hparams->alpha[2],hparams->alpha[3],hparams->alpha[4],hparams->threshold[0],hparams->threshold[1]);
            } else return 0;
        }

        // set name of file for the power state machine
        if(strcmp(argv[cur], "-psm") == 0) {
            if(argc <= cur + 1 || !psm_read(psm, argv[++cur]))
                return 0;
			//result file name
			strcat(res_name,&argv[cur][8]);
			res_name[strlen(res_name) - 4] = 0;//remove ".txt"
			strcat(res_name,PRINTTOFILE_DELIMITER);

        }
		
        // set name of file for the workload
        if(strcmp(argv[cur], "-wl") == 0)
        {
            if(argc > cur + 1)
            {
                strcpy(fwl, argv[++cur]);
				//result file name
				strcat(res_name,&argv[cur][8]);
				res_name[strlen(res_name) - 4] = 0;//remove ".txt"

				//strcat(res_name,PRINTTOFILE_DELIMITER);

            }
            else return	0;
        }
        cur ++;
    }
	strcat (res_name,"~data.txt");
    return 1;
}

void print_command_line(){
	printf("\n******************************************************************************\n");
	printf(" DPM simulator: \n");
	printf("\t-t <timeout>: timeout of the timeout policy\n");
	printf("\t-h <Value1> …<Value5> <Threshold1> <Threshold2>: history-based policy \n");
	printf("\t   <Value1-5> value of coefficients\n");
	printf("\t   <Threshold1-2> predicted time thresholds\n");
	printf("\t-psm <psm filename>: the power state machine file\n");
	printf("\t-wl <wl filename>: the workload file\n");
	printf("******************************************************************************\n\n");
}
