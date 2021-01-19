#include "inc/dpm_policies.h"

int dpm_simulate(psm_t psm, dpm_policy_t sel_policy, dpm_timeout_params
		tparams, dpm_history_params hparams, char* fwl,char *res_address)
{

	FILE *fp;
	psm_interval_t idle_period,active_period;
	psm_time_t history[DPM_HIST_WIND_SIZE*2];
	psm_time_t curr_time = 0;
	psm_state_t curr_state = PSM_STATE_ACTIVE;
    psm_state_t prev_state = PSM_STATE_ACTIVE;
    psm_energy_t e_total = 0;
    psm_energy_t e_tran;
    psm_energy_t e_tran_total = 0;
    psm_energy_t e_total_no_dpm = 0;
    psm_time_t t_tran_total = 0;
    psm_time_t t_waiting = 0;
	psm_time_t t_idle_ideal = 0;
    psm_time_t t_state[PSM_N_STATES] = {0};
    int n_tran_total = 0;

	fp = fopen(fwl, "r");
	if(!fp) {
		printf("[error] can't open file %s!\n", fwl);
		return 0;
	}

	dpm_init_history(history);
	active_period.start = 0;
    // main loop
    while(fscanf(fp, "%lf%lf", &idle_period.start, &idle_period.end) == 2) {

		active_period.end = idle_period.start;
        t_idle_ideal += psm_duration(idle_period);
		dpm_update_history(history, psm_duration(idle_period),psm_duration(active_period));
		active_period.start = idle_period.end;
        /*printf("idle: %lf %lf\n", idle_period.start, idle_period.end);*/

        // for each instant until the end of the current idle period
		for (; curr_time < idle_period.end; curr_time++) {

            // compute next state
            if(!dpm_decide_state(&curr_state, curr_time, idle_period, history,
                        sel_policy, tparams, hparams)) {
                printf("[error] cannot decide next state!\n");
                return 0;
            }
            /*printf("curr: %lf, state: %s\n", curr_time, PSM_STATE_NAME(curr_state));*/

            if (curr_state != prev_state) {
                if(!psm_tran_allowed(psm, prev_state, curr_state)) {
                    printf("[error] prohibited transition!\n");
                    return 0;
                }
                e_tran = psm_tran_energy(psm, prev_state, curr_state);
                e_tran_total += e_tran;
                t_tran_total += psm_tran_time(psm, prev_state, curr_state);
                n_tran_total++;
                e_total += psm_state_energy(psm, curr_state) + e_tran;
            } else {
                e_total += psm_state_energy(psm, curr_state);
            }
            e_total_no_dpm += psm_state_energy(psm, PSM_STATE_ACTIVE);
            // statistics of time units spent in each state
            t_state[curr_state]++;
            // time spent actively waiting for timeout expirations
            if(curr_state == PSM_STATE_ACTIVE && curr_time >=
                    idle_period.start) {
                t_waiting++;
            }

            prev_state = curr_state;
        }
    }
    fclose(fp);
	#ifdef PRINT
		printf("[sim] Active time in profile = %.6lfs \n", (curr_time - t_idle_ideal) * PSM_TIME_UNIT);
		printf("[sim] Idle time in profile = %.6lfs\n", t_idle_ideal * PSM_TIME_UNIT);
		printf("[sim] Total time = %.6lfs\n", curr_time * PSM_TIME_UNIT);
		printf("[sim] Timeout waiting time = %.6lfs\n", t_waiting * PSM_TIME_UNIT);
		for(int i = 0; i < PSM_N_STATES; i++) {
			printf("[sim] Total time in state %s = %.6lfs\n", PSM_STATE_NAME(i),
					t_state[i] * PSM_TIME_UNIT);
		}
		printf("[sim] Time overhead for transition = %.6lfs\n",t_tran_total * PSM_TIME_UNIT);
		printf("[sim] N. of transitions = %d\n", n_tran_total);
		printf("[sim] Energy for transitions = %.6fJ\n", e_tran_total * PSM_ENERGY_UNIT);
		printf("[sim] Energy w/o DPM = %.6fJ, Energy w DPM = %.6fJ\n",
				e_total_no_dpm * PSM_ENERGY_UNIT, e_total * PSM_ENERGY_UNIT);
		printf("[sim] %2.1f percent of energy saved.\n", 100*(e_total_no_dpm - e_total) /
				e_total_no_dpm);
				
	#endif		
	//////////////////////////////////////////////////////save resukt in file	
	#ifdef PRINTTOFILE
		/* File pointer to hold reference to our file */
		
		//char res_address[2*MAX_FILENAME] = "example/Rdata/";
		//strcat (res_address,arg);
		//strcat (res_address,"_result.txt");
		FILE * fPtr;
		// Open file in w (write) mode. 
		fPtr = fopen(res_address, "w");
		/* fopen() return NULL if last operation was unsuccessful */
		if(fPtr == NULL)
		{
			/* File not created hence exit */
			printf("Unable to create \"%s\".\n",res_address);
			return 0;
		}else {
		/*save in file*/
			fprintf(fPtr,"%.6lf\n", (curr_time - t_idle_ideal) * PSM_TIME_UNIT);
			fprintf(fPtr,"%.6lf\n", t_idle_ideal * PSM_TIME_UNIT);
			fprintf(fPtr,"%.6lf\n", curr_time * PSM_TIME_UNIT);
			fprintf(fPtr,"%.6lf\n", t_waiting * PSM_TIME_UNIT);
			for(int i = 0; i < PSM_N_STATES; i++) {
				//fprintf(fPtr,"%s = %.6lfs\n", PSM_STATE_NAME(i),t_state[i] * PSM_TIME_UNIT);
				fprintf(fPtr,"%.6lf\n", t_state[i] * PSM_TIME_UNIT);

			}
			fprintf(fPtr,"%.6lf\n",t_tran_total * PSM_TIME_UNIT);
			fprintf(fPtr,"%d\n", n_tran_total);
			fprintf(fPtr,"%.6f\n", e_tran_total * PSM_ENERGY_UNIT);
			fprintf(fPtr,"%.6f\n%.6f\n",
					e_total_no_dpm * PSM_ENERGY_UNIT, e_total * PSM_ENERGY_UNIT);
			fprintf(fPtr,"%2.1f \n", 100*(e_total_no_dpm - e_total) /
					e_total_no_dpm);

			/* Close file to save file data */
			fclose(fPtr);	
			printf("%s has saved!\n",res_address);
		}
	#endif
	return 1;
}

int dpm_decide_state(psm_state_t *next_state, psm_time_t curr_time,
        psm_interval_t idle_period, psm_time_t *history, dpm_policy_t policy,
        dpm_timeout_params tparams, dpm_history_params hparams)
{
    switch (policy) {

        case DPM_TIMEOUT:
            if(curr_time > idle_period.start + tparams.timeout[0]) {
                *next_state = PSM_STATE_IDLE;
			} else {
                *next_state = PSM_STATE_ACTIVE;
            }
			/* LAB 2 EDIT */
			
			if ((tparams.timeout[1] >= tparams.timeout[0]) && (curr_time > idle_period.start + tparams.timeout[1])) {
				*next_state = PSM_STATE_SLEEP;
			} 
            break;

        case DPM_HISTORY:
            if(curr_time < idle_period.start) {
                *next_state = PSM_STATE_ACTIVE;
            } else {
                *next_state = PSM_STATE_ACTIVE;
                /* LAB 3 EDIT */
				/*
				   a =       46.61  (43.31, 49.92)
				   b =      0.1357  (0.0247, 0.2466)
				   c =   -0.001201  (-0.002274, -0.0001294)
				   d =    0.007415  (-0.01493, 0.02976)
				   e =  -1.574e-05  (-5.887e-05, 2.739e-05)
				*/
				//./dpm_simulator -h 46.61 0.1357 -0.001201 0.007415 -1.574e-05 10 100 -psm example/psm_new.txt -wl example/Generated_workload_1.1.txt

				//Tidle[i]= K0+ K1·Tidle[i-1]+ K2·Tidle[i-1]^2 + K3·Tactive[i]+ K4·Tactive[i]^2
				double value_prediction = 	hparams.alpha[0]+ 
									hparams.alpha[1] * history[DPM_HIST_WIND_SIZE-1] + 
									hparams.alpha[2] * history[DPM_HIST_WIND_SIZE-1] * history[DPM_HIST_WIND_SIZE-1] + 
									hparams.alpha[3] * history[2*DPM_HIST_WIND_SIZE-1] + 
									hparams.alpha[4] * history[2*DPM_HIST_WIND_SIZE-1] * history[2*DPM_HIST_WIND_SIZE-1];
				//printf("%f\n", value_prediction);
				if(value_prediction < hparams.threshold[0]) {
					*next_state = PSM_STATE_ACTIVE;
				} else if(value_prediction > hparams.threshold[1] && hparams.threshold[1] >= hparams.threshold[0] ) {
					*next_state = PSM_STATE_SLEEP;
				} else {
					*next_state = PSM_STATE_IDLE;	
				}
            }
            break;

        default:
            printf("[error] unsupported policy\n");
            return 0;
    }
	return 1;
}

/* initialize idle time history */
void dpm_init_history(psm_time_t *h)
{
	for (int i=0; i<DPM_HIST_WIND_SIZE*2; i++) {
		h[i] = 0;
	}
}

/* update idle time history */
void dpm_update_history(psm_time_t *h, psm_time_t new_idle, psm_time_t new_active)
{
	for (int i=0; i<DPM_HIST_WIND_SIZE-1; i++){
		h[i] = h[i+1];
	}
	h[DPM_HIST_WIND_SIZE-1] = new_idle;
	for (int i=DPM_HIST_WIND_SIZE; i<2*DPM_HIST_WIND_SIZE-1; i++){
		h[i] = h[i+1];
	}
	h[2*DPM_HIST_WIND_SIZE-1] = new_active;
}
