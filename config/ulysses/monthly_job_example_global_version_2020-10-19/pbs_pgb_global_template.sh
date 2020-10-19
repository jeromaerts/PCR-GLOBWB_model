#!/bin/bash
 
#PBS -N pcrglobwb

#PBS -q nf

#PBS -l EC_total_tasks=32
#PBS -l EC_hyperthreads=2
#PBS -l EC_billing_account=c3s432l3

#PBS -l walltime=3:00:00
#~ #PBS -l walltime=48:00:00
#~ #PBS -l walltime=8:00
#~ #PBS -l walltime=1:00:00
#~ #PBS -l walltime=12:00:00


set -x


# set the folder that contain PCR-GLOBWB model scripts (note that this is not always the latest version)
#~ PCRGLOBWB_MODEL_SCRIPT_FOLDER="/perm/mo/nest/ulysses/src/edwin/ulysses_pgb_source/model/"
PCRGLOBWB_MODEL_SCRIPT_FOLDER="/home/ms/copext/cyes/github/edwinkost/PCR-GLOBWB_model_edwin-private-development/model/"

# set the configuration file (*.ini) that will be used (assumption: the .ini file is located within the same directory as this job, i.e. ${PBS_O_WORKDIR})
INI_FILE=${PBS_O_WORKDIR}/"setup_6arcmin_version_2020-10-19.ini"

# set the output folder
MAIN_OUTPUT_DIR="/scratch/ms/copext/cyes/test_monthly_runs_version_2020-10-19/"

# set the starting and end simulation dates
STARTING_DATE=1982-01-01
END_DATE=1982-01-31

# set the initial conditions (folder and time stamp for the files)
MAIN_INITIAL_STATE_FOLDER="scratch/ms/copext/cyes/data/pcrglobwb_input_ulysses/version_2020-10-19/global_06min/initialConditions/dummy_version_2020-10-19/global/states/"
DATE_FOR_INITIAL_STATES=1981-12-31

# set the forcing files
PRECIPITATION_FORCING_FILE="/scratch/mo/nest/ulysses/data/meteo/era5land/1982/01/precipitation_daily_01_1982.nc"
TEMPERATURE_FORCING_FILE="/scratch/mo/nest/ulysses/data/meteo/era5land/1982/01/tavg_01_1982.nc"
REF_POT_ET_FORCING_FILE="/scratch/mo/nest/ulysses/data/meteo/era5land/1982/01/pet_01_1982.nc"



# load modules on cca (or ccb)
module load python3/3.6.10-01
module load pcraster/4.3.0
module load gdal/3.0.4


# use 30 cores (working threads)
export PCRASTER_NR_WORKER_THREADS=30


# go to the folder that contain PCR-GLOBWB scripts
cd ${PCRGLOBWB_MODEL_SCRIPT_FOLDER}

# run PCR-GLOBWB
python3 deterministic_runner_parallel_for_ulysses.py ${INI_FILE} debug global -mod ${MAIN_OUTPUT_DIR} -sd ${STARTING_DATE} -ed ${END_DATE} -misd ${MAIN_INITIAL_STATE_FOLDER} -dfis ${DATE_FOR_INITIAL_STATES} -pff ${PRECIPITATION_FORCING_FILE} -tff ${TEMPERATURE_FORCING_FILE} -rpetff ${REF_POT_ET_FORCING_FILE}


set +x
