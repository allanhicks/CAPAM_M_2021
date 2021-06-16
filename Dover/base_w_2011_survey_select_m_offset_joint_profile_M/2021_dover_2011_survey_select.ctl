#V3.30.16.02;_2020_09_21;_safe;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.2
#Stock Synthesis (SS) is a work of the U.S. Government and is not subject to copyright protection in the United States.
#Foreign copyrights may apply. See copyright.txt for more information.
#_user_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_user_info_available_at:https://vlab.ncep.noaa.gov/group/stock-synthesis
#C 2021 Dover sole assessment: Chantel Wetzel & Aaron Berger
0 # 0 means do not read wtatage.ss; 1 means read and use wtatage.ss and also read and use growth parameters
1 #_N_Growth_Patterns (Growth Patterns, Morphs, Bio Patterns, GP are terms used interchangeably in SS)
1 #_N_platoons_Within_GrowthPattern 
#_Cond 1 #_Platoon_between/within_stdev_ratio (no read if N_platoons=1)
#_Cond  1 #vector_platoon_dist_(-1_in_first_val_gives_normal_approx)
#
4 # recr_dist_method for parameters:  2=main effects for GP, Settle timing, Area; 3=each Settle entity; 4=none, only when N_GP*Nsettle*pop==1
1 # not yet implemented; Future usage: Spawner-Recruitment: 1=global; 2=by area
1 #  number of recruitment settlement assignments 
0 # unused option
#GPattern month  area  age (for each settlement assignment)
 1 1 1 0
#
#_Cond 0 # N_movement_definitions goes here if Nareas > 1
#_Cond 1.0 # first age that moves (real age at begin of season, not integer) also cond on do_migration>0
#_Cond 1 1 1 2 4 10 # example move definition for seas=1, morph=1, source=1 dest=2, age1=4, age2=10
#
4 #_Nblock_Patterns
2 3 2 1 #_blocks_per_pattern 
# begin and end years of blocks
 1910 1984 1985 1995 # CA and OR/WA Selectivity
 1910 1947 1948 2010 2011 2014 # CA Discard Blocks
 1910 2001 2002 2010 # WA/OR Discard Blocks
 1995 2004 # Triennial Block
#
# controls for all timevary parameters 
1 #_env/block/dev_adjust_method for all time-vary parms (1=warn relative to base parm bounds; 3=no bound check)
#
# AUTOGEN
1 1 1 1 1 # autogen: 1st element for biology, 2nd for SR, 3rd for Q, 4th reserved, 5th for selex
# where: 0 = autogen all time-varying parms; 1 = read each time-varying parm line; 2 = read then autogen if parm min==-12345
#
#_Available timevary codes
#_Block types: 0: P_block=P_base*exp(TVP); 1: P_block=P_base+TVP; 2: P_block=TVP; 3: P_block=P_block(-1) + TVP
#_Block_trends: -1: trend bounded by base parm min-max and parms in transformed units (beware); -2: endtrend and infl_year direct values; -3: end and infl as fraction of base range
#_EnvLinks:  1: P(y)=P_base*exp(TVP*env(y));  2: P(y)=P_base+TVP*env(y);  3: null;  4: P(y)=2.0/(1.0+exp(-TVP1*env(y) - TVP2))
#_DevLinks:  1: P(y)*=exp(dev(y)*dev_se;  2: P(y)+=dev(y)*dev_se;  3: random walk;  4: zero-reverting random walk with rho;  21-24 keep last dev for rest of years
#
#_Prior_codes:  0=none; 6=normal; 1=symmetric beta; 2=CASAL's beta; 3=lognormal; 4=lognormal with biascorr; 5=gamma
#
# setup for M, growth, maturity, fecundity, recruitment distibution, movement 
#
0 #_natM_type:_0=1Parm; 1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate
#_no additional input for selected M option; read 1P per morph
#
1 # GrowthModel: 1=vonBert with L1&L2; 2=Richards with L1&L2; 3=age_specific_K_incr; 4=age_specific_K_decr; 5=age_specific_K_each; 6=NA; 7=NA; 8=growth cessation
1 #_Age(post-settlement)_for_L1;linear growth below this
999 #_Growth_Age_for_L2 (999 to use as Linf)
-999 #_exponential decay for growth above maxage (value should approx initial Z; -999 replicates 3.24; -998 to not allow growth above maxage)
0  #_placeholder for future growth feature
#
0 #_SD_add_to_LAA (set to 0.1 for SS2 V1.x compatibility)
0 #_CV_Growth_Pattern:  0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)
#
1 #_maturity_option:  1=length logistic; 2=age logistic; 3=read age-maturity matrix by growth_pattern; 4=read age-fecundity; 5=disabled; 6=read length-maturity
0 #_First_Mature_Age
1 #_fecundity option:(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
0 #_hermaphroditism option:  0=none; 1=female-to-male age-specific fxn; -1=male-to-female age-specific fxn
2 #_parameter_offset_approach (1=none, 2= M, G, CV_G as offset from female-GP1, 3=like SS2 V1.x)
#
#_growth_parms
#_ LO HI INIT PRIOR PR_SD PR_type PHASE env_var&link dev_link dev_minyr dev_maxyr dev_PH Block Block_Fxn
#Sex:1  BioPattern                            
0.05  0.2 0.108 -2.226  0.48  3  -2 0 0 0 0 0 0 0 # NatM_p_1_Fem_GP_1
3 25  11.1  11.1  10  0 2 0 0 0 0 0 0 0 # L_at_Amin_Fem_GP_1
35  60  48.5  48.5  1 0 3 0 0 0 0 0 0 0 # L_at_Amax_Fem_GP_1
0.03  0.2 0.117 0.117 1 0 2 0 0 0 0 0 0 0 # VonBert_K_Fem_GP_1
0.01  1 0.10 0.10 1 0 3 0 0 0 0 0 0 0 # CV_young_Fem_GP_1
0.01  1 0.10 0.10 1 0 4 0 0 0 0 0 0 0 # CV_old_Fem_GP_1
0 0.1 2.97E-06  2.97E-06  0.2 0 -99  0 0 0 0 0 0 0 # Wtlen_1_Fem
2 4 3.332 3.332 2 0 -99  0 0 0 0 0 0 0 # Wtlen_2_Fem
20  40  32.84  32.84  5 0 -99  0 0 0 0 0 0 0 # Mat50%_Fem
-1  0 -0.278  -0.278 0.4 0 -99  0 0 0 0 0 0 0 # Mat_slope_Fem
-3  3 1 1 0.8 0 -99  0 0 0 0 0 0 0 # Eggs/kg_inter_Fem
-3  3 0 0 0.8 0 -99  0 0 0 0 0 0 0 # Eggs/kg_slope_wt_Fem
#Sex:2  BioPattern                            
-1  1    0 0  0.2 6 3 0 0 0 0 0 0 0 # NatM_p_1_Mal_GP_1
-1  1 0.333  0.333  0.1 0 3 0 0 0 0 0 0 0 # L_at_Amin_Mal_GP_1
-1  1 -0.118 -0.118 0.1 0 4 0 0 0 0 0 0 0 # L_at_Amax_Mal_GP_1
-1  1 -0.099 -0.099 0.1 0 3 0 0 0 0 0 0 0 # VonBert_K_Mal_GP_1
-1  1 0  0  0.1 0 4 0 0 0 0 0 0 0 # CV_young_Mal_GP_1
-1  1 0  0  0.1 0 5 0 0 0 0 0 0 0 # CV_old_Mal_GP_1
0 0.1 2.60E-06  2.60E-06  0.2 0 -99  0 0 0 0 0 0 0 # Wtlen_1_Mal
2 4 3.371 3.371 2 0 -99  0 0 0 0 0 0 0 # Wtlen_2_Mal
#  Cohort growth dev base
 0 1 1 1 0 0 -4 0 0 0 0 0 0 0 # CohortGrowDev
#  Movement
#  Age Error from parameters
#  catch multiplier
#  fraction female, by GP
 0.000001 0.999999 0.5 0.5  0.5 0 -99 0 0 0 0 0 0 0 # FracFemale_GP_1
#
#_no timevary MG parameters
#
#_seasonal_effects_on_biology_parms
 0 0 0 0 0 0 0 0 0 0 #_femwtlen1,femwtlen2,mat1,mat2,fec1,fec2,Malewtlen1,malewtlen2,L1,K
#_ LO HI INIT PRIOR PR_SD PR_type PHASE
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no seasonal MG parameters
#
3 #_Spawner-Recruitment; Options: 2=Ricker; 3=std_B-H; 4=SCAA; 5=Hockey; 6=B-H_flattop; 7=survival_3Parm; 8=Shepherd_3Parm; 9=RickerPower_3parm
0  # 0/1 to use steepness in initial equ recruitment calculation
0  #  future feature:  0/1 to make realized sigmaR a function of SR curvature
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn #  parm_name
             6            17            12            12             5             0          1          0          0          0          0          0          0          0 # SR_LN(R0)
          0.22             1           0.8           0.8          0.09             6         -7          0          0          0          0          0          0          0 # SR_BH_steep
          0.15          0.55          0.35          0.35           0.2             0        -99          0          0          0          0          0          0          0 # SR_sigmaR
            -2             2             0             0             2             0        -99          0          0          0          0          0          0          0 # SR_regime
             0             0             0             0             0             0        -99          0          0          0          0          0          0          0 # SR_autocorr
#_no timevary SR parameters
1 #do_recdev:  0=none; 1=devvector (R=F(SSB)+dev); 2=deviations (R=F(SSB)+dev); 3=deviations (R=R0*dev; dev2=R-f(SSB)); 4=like 3 with sum(dev2) adding penalty
1975 # first year of main recr_devs; early devs can preceed this era
2018 # last year of main recr_devs; forecast devs start in following year
1 #_recdev phase 
1 # (0/1) to read 13 advanced options
 1880 #_recdev_early_start (0=none; neg value makes relative to recdev_start)
 2 #_recdev_early_phase
 0 #_forecast_recruitment phase (incl. late recr) (0 value resets to maxphase+1)
 1 #_lambda for Fcast_recr_like occurring before endyr+1
 1962 #_last_yr_nobias_adj_in_MPD; begin of ramp
 2002 #_first_yr_fullbias_adj_in_MPD; begin of plateau
 2012 #_last_yr_fullbias_adj_in_MPD
 2018 #_end_yr_for_ramp_in_MPD (can be in forecast to shape ramp, but SS sets bias_adj to 0.0 for fcast yrs)
 0.76 #_max_bias_adj_in_MPD (-1 to override ramp and set biasadj=1.0 for all estimated recdevs)
 0 #_period of cycles in recruitment (N parms read below)
 -5 #min rec_dev
 5 #max rec_dev
 0 #_read_recdevs
#_end of advanced SR options
#
#_placeholder for full parameter lines for recruitment cycles
# read specified recr devs
#_Yr Input_value
#
#Fishing Mortality info 
0.04 # F ballpark
-2001 # F ballpark year (neg value to disable)
3 # F_Method:  1=Pope; 2=instan. F; 3=hybrid (hybrid is recommended)
3.5 # max F or harvest rate, depends on F_Method
# no additional F input needed for Fmethod 1
# if Fmethod=2; read overall start F value; overall phase; N detailed inputs to read
# if Fmethod=3; read N iterations for tuning for Fmethod 3
5  # N iterations for tuning F in hybrid method (recommend 3 to 7)
#
#_initial_F_parms; count = 0
#_ LO HI INIT PRIOR PR_SD  PR_type  PHASE
#
#_Q_setup for fleets with cpue or survey data
#_1:  fleet number
#_2:  link type: (1=simple q, 1 parm; 2=mirror simple q, 1 mirrored parm; 3=q and power, 2 parm; 4=mirror with offset, 2 parm)
#_3:  extra input for link, i.e. mirror fleet# or dev index number
#_4:  0/1 to select extra sd parameter
#_5:  0/1 for biasadj or not
#_6:  0/1 to float
#_   fleet      link link_info  extra_se   biasadj     float  #  fleetname
         3         1         0         1         0         1  #  AFSC_Slope
         4         1         0         1         1         0  #  Triennial
         5         1         0         1         0         1  #  NWFSC_Slope
         6         1         0         0         0         1  #  NWFSC_combo
-9999 0 0 0 0 0
#
#_Q_parms(if_any);Qunits_are_ln(q)
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn  #  parm_name
           -25            25     -0.448276             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_AFSC_Slope(3)
             0             2     0.0493471             0            99             0          3          0          0          0          0          0          0          0  #  Q_extraSD_AFSC_Slope(3)
           -10             2       -1.3354             0             1             0          1          0          0          0          0          0          4          1  #  LnQ_base_Triennial(4)
             0             2      0.294194             0            99             0          3          0          0          0          0          0          0          0  #  Q_extraSD_Triennial(4)
           -25            25     -0.531195             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_NWFSC_Slope(5)
             0             2     0.0336227             0            99             0          3          0          0          0          0          0          0          0  #  Q_extraSD_NWFSC_Slope(5)
           -25            25      0.176914             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_NWFSC_WCGBT(6)
# timevary Q parameters 
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type     PHASE  #  parm_name
           -15            15      0.698917             0             1             0      3  # LnQ_base_Triennial(4)_BLK4add_1995
#
#_size_selex_patterns
#Pattern:_0; parm=0; selex=1.0 for all sizes
#Pattern:_1; parm=2; logistic; with 95% width specification
#Pattern:_5; parm=2; mirror another size selex; PARMS pick the min-max bin to mirror
#Pattern:_15; parm=0; mirror another age or length selex
#Pattern:_6; parm=2+special; non-parm len selex
#Pattern:_43; parm=2+special+2;  like 6, with 2 additional param for scaling (average over bin range)
#Pattern:_8; parm=8; New doublelogistic with smooth transitions and constant above Linf option
#Pattern:_9; parm=6; simple 4-parm double logistic with starting length; parm 5 is first length; parm 6=1 does desc as offset
#Pattern:_21; parm=2+special; non-parm len selex, read as pairs of size, then selex
#Pattern:_22; parm=4; double_normal as in CASAL
#Pattern:_23; parm=6; double_normal where final value is directly equal to sp(6) so can be >1.0
#Pattern:_24; parm=6; double_normal with sel(minL) and sel(maxL), using joiners
#Pattern:_25; parm=3; exponential-logistic in size
#Pattern:_27; parm=3+special; cubic spline 
#Pattern:_42; parm=2+special+3; // like 27, with 2 additional param for scaling (average over bin range)
#_discard_options:_0=none;_1=define_retention;_2=retention&mortality;_3=all_discarded_dead;_4=define_dome-shaped_retention
#_Pattern Discard Male Special
 24 1 4 0 # 1 CA
 24 1 4 0 # 2 OR/WA
 27 0 1 5 # 4 AFSC_Slope
 24 0 2 0 # 5 Triennial
 27 0 1 5 # 6 NWFSC_Slope
 24 0 2 0 # 7 NWFSC_combo
#
#_age_selex_patterns
#Pattern:_0; parm=0; selex=1.0 for ages 0 to maxage
#Pattern:_10; parm=0; selex=1.0 for ages 1 to maxage
#Pattern:_11; parm=2; selex=1.0  for specified min-max age
#Pattern:_12; parm=2; age logistic
#Pattern:_13; parm=8; age double logistic
#Pattern:_14; parm=nages+1; age empirical
#Pattern:_15; parm=0; mirror another age or length selex
#Pattern:_16; parm=2; Coleraine - Gaussian
#Pattern:_17; parm=nages+1; empirical as random walk  N parameters to read can be overridden by setting special to non-zero
#Pattern:_41; parm=2+nages+1; // like 17, with 2 additional param for scaling (average over bin range)
#Pattern:_18; parm=8; double logistic - smooth transition
#Pattern:_19; parm=6; simple 4-parm double logistic with starting age
#Pattern:_20; parm=6; double_normal,using joiners
#Pattern:_26; parm=3; exponential-logistic in age
#Pattern:_27; parm=3+special; cubic spline in age
#Pattern:_42; parm=2+special+3; // cubic spline; with 2 additional param for scaling (average over bin range)
#_Pattern Discard Male Special
 10 0 0 0 # 1 CA
 10 0 0 0 # 2 OR/WA
 10 0 0 0 # 4 AFSC_Slope
 10 0 0 0 # 5 Triennial
 10 0 0 0 # 6 NWFSC_Slope
 10 0 0 0 # 7 NWFSC_combo
#
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn  #  parm_name
# CA LenSelex
            15            50       37.2802            36             5             0          1          0          0          0          0          0          1          2  #  Size_DblN_peak_CA(1)
           -15             7           -15          -0.5             2             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_CA(1)
           -10            10        3.4623          1.75             5             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_CA(1)
           -10            10             6           0.1             2             0         -4          0          0          0          0          0          0          0  #  Size_DblN_descend_se_CA(1)
           -20            30           -20            -1             5             0         -9          0          0          0          0          0          0          0  #  Size_DblN_start_logit_CA(1)
           -10            10            10             1             5             0         -4          0          0          0          0          0          0          0  #  Size_DblN_end_logit_CA(1)
# CA Retention           
            10            40       25.5956            34            99             0          2          0          0          0          0          0          2          2  #  Retain_L_infl_CA(1)
           0.1             5       1.40906             1            99             0          3          0          0          0          0          0          2          2  #  Retain_L_width_CA(1)
           -10            10       5.74144            10            99             0          3          0          0          0          0          0          2          2  #  Retain_L_asymptote_logit_CA(1)
           -10            10             0             0            99             0         -9          0          0          0          0          0          0          0  #  Retain_L_maleoffset_CA(1)
# Female Offset
           -20            20       1.31541             0            99             0          2          0          0          0          0          0          1          2  #  SzSel_Fem_Peak_CA(1)
            -5             5             0             0            99             0         -4          0          0          0          0          0          0          0  #  SzSel_Fem_Ascend_CA(1)
           -10            10             0             0            99             0         -4          0          0          0          0          0          0          0  #  SzSel_Fem_Descend_CA(1)
           -20            10      -5.76274             0            99             0          3          0          0          0          0          0          0          0  #  SzSel_Fem_Final_CA(1)
          0.01             1       0.81012             1            99             0          3          0          0          0          0          0          0          0  #  SzSel_Fem_Scale_CA(1)
# OR/WA LenSelex
            15            50       36.4685            36             5             0          2          0          0          0          0          0          1          2  #  Size_DblN_peak_OR_WA(2)
           -15             5      -11.4694          -0.5             2             0         -3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_OR_WA(2)
           -10            10       3.20379          1.75             5             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_OR_WA(2)
           -10            10      -9.97703           0.1             2             0         -4          0          0          0          0          0          0          0  #  Size_DblN_descend_se_OR_WA(2)
           -20            30           -20            -1             5             0         -9          0          0          0          0          0          0          0  #  Size_DblN_start_logit_OR_WA(2)
           -10            10     -0.647669             1             5             0          2          0          0          0          0          0          0          0  #  Size_DblN_end_logit_OR_WA(2)
# OR/WA Retention 
            15            40       23.5997            34            99             0          2          0          0          0          0          0          3          2  #  Retain_L_infl_OR_WA(2)
           0.1             5       1.55002             1            99             0          3          0          0          0          0          0          3          2  #  Retain_L_width_OR_WA(2)
           -10            10       6.27208            10            99             0          3          0          0          0          0          0          3          2  #  Retain_L_asymptote_logit_OR_WA(2)
           -10            10             0             0            99             0         -9          0          0          0          0          0          0          0  #  Retain_L_maleoffset_OR_WA(2)
# Female Offset
           -20            20       5.49996             0            99             0          2          0          0          0          0          0          1          2  #  SzSel_Fem_Peak_OR_WA(2)
            -5             5       1.24195             0            99             0         -4          0          0          0          0          0          0          0  #  SzSel_Fem_Ascend_OR_WA(2)
           -10            10     -0.888168             0            99             0         -4          0          0          0          0          0          0          0  #  SzSel_Fem_Descend_OR_WA(2)
           -20            10     -0.455577             0            99             0          3          0          0          0          0          0          0          0  #  SzSel_Fem_Final_OR_WA(2)
           0.1             1       0.61008             1            99             0          3          0          0          0          0          0          0          0  #  SzSel_Fem_Scale_OR_WA(2)
# 3   AFSC_Slope LenSelex
             0             2             0             0             0             0         -9          0          0          0          0          0          0          0  #  SizeSpline_Code_AFSC_Slope(3)
        -0.001            10      0.402777             0           0.1             0          3          0          0          0          0          0          0          0  #  SizeSpline_GradLo_AFSC_Slope(3)
           -10          0.01     -0.141594             0           0.1             0          3          0          0          0          0          0          0          0  #  SizeSpline_GradHi_AFSC_Slope(3)
             1            60            20             0             0             0        -99          0          0          0          0          0          0          0  #  SizeSpline_Knot_1_AFSC_Slope(3)
             1            60            29             0             0             0        -99          0          0          0          0          0          0          0  #  SizeSpline_Knot_2_AFSC_Slope(3)
             1            60            38             0             0             0        -99          0          0          0          0          0          0          0  #  SizeSpline_Knot_3_AFSC_Slope(3)
             1            60            47             0             0             0        -99          0          0          0          0          0          0          0  #  SizeSpline_Knot_4_AFSC_Slope(3)
             1            60            56             0             0             0        -99          0          0          0          0          0          0          0  #  SizeSpline_Knot_5_AFSC_Slope(3)
            -9             7       -2.3709             0             0             0          2          0          0          0          0          0          0          0  #  SizeSpline_Val_1_AFSC_Slope(3)
            -9             7      0.150258             0             0             0          2          0          0          0          0          0          0          0  #  SizeSpline_Val_2_AFSC_Slope(3)
            -9             7             0             0             0             0        -99          0          0          0          0          0          0          0  #  SizeSpline_Val_3_AFSC_Slope(3)
            -9             7      0.342355             0             0             0          2          0          0          0          0          0          0          0  #  SizeSpline_Val_4_AFSC_Slope(3)
            -9             7     -0.916718             0             0             0          2          0          0          0          0          0          0          0  #  SizeSpline_Val_5_AFSC_Slope(3)
           -10            60            45             0             5             0         -4          0          0          0          0          0          0          0  #  SzSel_MaleDogleg_AFSC_Slope(3)
           -10            10             0             0             5             0         -5          0          0          0          0          0          0          0  #  SzSel_MaleatZero_AFSC_Slope(3)
           -10            10       1.44199             0             5             0          5          0          0          0          0          0          0          0  #  SzSel_MaleatDogleg_AFSC_Slope(3)
           -10            10      -1.33809             0             5             0          5          0          0          0          0          0          0          0  #  SzSel_MaleatMaxage_AFSC_Slope(3)
# 4   Triennial LenSelex
            15            55       30.9687            36             5             0          2          0          0          0          0          0          0          0  #  Size_DblN_peak_Triennial(4)
           -10             5      -9.43654          -0.5             2             0          3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_Triennial(4)
           -10            10       3.93119          1.75             5             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_Triennial(4)
           -10            10       3.58591           0.1             2             0          4          0          0          0          0          0          0          0  #  Size_DblN_descend_se_Triennial(4)
           -20            30           -20            -1             5             0         -9          0          0          0          0          0          0          0  #  Size_DblN_start_logit_Triennial(4)
           -10            10      -1.62969             1             5             0          4          0          0          0          0          0          0          0  #  Size_DblN_end_logit_Triennial(4)
           -10            60            35             0             5             0         -4          0          0          0          0          0          0          0  #  SzSel_MaleDogleg_Triennial(4)
           -10            10             0             0             5             0         -5          0          0          0          0          0          0          0  #  SzSel_MaleatZero_Triennial(4)
           -10             0     -0.616367             0             5             0          5          0          0          0          0          0          0          0  #  SzSel_MaleatDogleg_Triennial(4)
           -10           0.1     0.0996832             0             5             0          5          0          0          0          0          0          0          0  #  SzSel_MaleatMaxage_Triennial(4)
# 5   NWFSC_Slope LenSelex
             0             2             0             0             0             0         -9          0          0          0          0          0          0          0  #  SizeSpline_Code_NWFSC_Slope(5)
        -0.001            10      0.612817             0           0.1             0          3          0          0          0          0          0          0          0  #  SizeSpline_GradLo_NWFSC_Slope(5)
           -10          0.01    0.00958931             0           0.1             0          3          0          0          0          0          0          0          0  #  SizeSpline_GradHi_NWFSC_Slope(5)
             1            60            20             0             0             0        -99          0          0          0          0          0          0          0  #  SizeSpline_Knot_1_NWFSC_Slope(5)
             1            60            29             0             0             0        -99          0          0          0          0          0          0          0  #  SizeSpline_Knot_2_NWFSC_Slope(5)
             1            60            38             0             0             0        -99          0          0          0          0          0          0          0  #  SizeSpline_Knot_3_NWFSC_Slope(5)
             1            60            47             0             0             0        -99          0          0          0          0          0          0          0  #  SizeSpline_Knot_4_NWFSC_Slope(5)
             1            60            56             0             0             0        -99          0          0          0          0          0          0          0  #  SizeSpline_Knot_5_NWFSC_Slope(5)
            -9             7      -3.81059             0             0             0          2          0          0          0          0          0          0          0  #  SizeSpline_Val_1_NWFSC_Slope(5)
            -9             7    -0.0812633             0             0             0          2          0          0          0          0          0          0          0  #  SizeSpline_Val_2_NWFSC_Slope(5)
            -9             7             0             0             0             0        -99          0          0          0          0          0          0          0  #  SizeSpline_Val_3_NWFSC_Slope(5)
            -9             7      0.566915             0             0             0          2          0          0          0          0          0          0          0  #  SizeSpline_Val_4_NWFSC_Slope(5)
            -9             7     -0.657856             0             0             0          2          0          0          0          0          0          0          0  #  SizeSpline_Val_5_NWFSC_Slope(5)
           -10            60            45             0             5             0         -4          0          0          0          0          0          0          0  #  SzSel_MaleDogleg_NWFSC_Slope(5)
           -10            10             0             0             5             0         -5          0          0          0          0          0          0          0  #  SzSel_MaleatZero_NWFSC_Slope(5)
           -10            10       1.47532             0             5             0          5          0          0          0          0          0          0          0  #  SzSel_MaleatDogleg_NWFSC_Slope(5)
           -10            10       -6.0638             0             5             0          5          0          0          0          0          0          0          0  #  SzSel_MaleatMaxage_NWFSC_Slope(5)
# 6   NWFSC_WCGBT LenSelex
            15            55       33.9924            36             5             0          2          0          0          0          0          0          0          0  #  Size_DblN_peak_NWFSC_WCGBT(6)
            -5             5       2.34848          -0.5             2             0          3          0          0          0          0          0          0          0  #  Size_DblN_top_logit_NWFSC_WCGBT(6)
           -10            10       4.08721          1.75             5             0          3          0          0          0          0          0          0          0  #  Size_DblN_ascend_se_NWFSC_WCGBT(6)
           -10            10       1.86577           0.1             2             0          4          0          0          0          0          0          0          0  #  Size_DblN_descend_se_NWFSC_WCGBT(6)
           -20            30           -20            -1             5             0         -9          0          0          0          0          0          0          0  #  Size_DblN_start_logit_NWFSC_WCGBT(6)
           -10            10       5.92134             1             5             0          4          0          0          0          0          0          0          0  #  Size_DblN_end_logit_NWFSC_WCGBT(6)
           -10            60            40             0             5             0         -4          0          0          0          0          0          0          0  #  SzSel_MaleDogleg_NWFSC_WCGBT(6)
           -10            10             0             0             5             0         -5          0          0          0          0          0          0          0  #  SzSel_MaleatZero_NWFSC_WCGBT(6)
           -10             0     -0.861458             0             5             0          5          0          0          0          0          0          0          0  #  SzSel_MaleatDogleg_NWFSC_WCGBT(6)
           -10           0.1      -1.90364             0             5             0          5          0          0          0          0          0          0          0  #  SzSel_MaleatMaxage_NWFSC_WCGBT(6)
# 1   CA AgeSelex
# 2   OR/WA AgeSelex
# 3   AFSC_Slope AgeSelex
# 4   Triennial AgeSelex
# 5   NWFSC_Slope AgeSelex
# 6   NWFSC_combo AgeSelex
#_Dirichlet parameters
#  -5             5       1         1         1.813             0          2          0          0          0          0          0          0          0  #  ln(DM_theta)_1
#  -5             5       1         1         1.813             0          2          0          0          0          0          0          0          0  #  ln(DM_theta)_2
#  -5             5       1         1         1.813             0          2          0          0          0          0          0          0          0  #  ln(DM_theta)_1
#  -5             5       1         1         1.813             0          2          0          0          0          0          0          0          0  #  ln(DM_theta)_2
#  -5             5       1         1         1.813             0          2          0          0          0          0          0          0          0  #  ln(DM_theta)_1
#  -5             5       1         1         1.813             0          2          0          0          0          0          0          0          0  #  ln(DM_theta)_2
#  -5             5       1         1         1.813             0          2          0          0          0          0          0          0          0  #  ln(DM_theta)_1
#  -5             5       1         1         1.813             0          2          0          0          0          0          0          0          0  #  ln(DM_theta)_2
#  -5             5       1         1         1.813             0          2          0          0          0          0          0          0          0  #  ln(DM_theta)_1
#  -5             5       1         1         1.813             0          2          0          0          0          0          0          0          0  #  ln(DM_theta)_2
# timevary selex parameters 
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type    PHASE  #  parm_name
            15            55       39.6531             0            99             0      4  # Size_DblN_peak_CA(1)_BLK1repl_1910
            15            55       35.8095             0            99             0      4  # Size_DblN_peak_CA(1)_BLK1repl_1985
            10            40            10             0            99             0     -4  # Retain_L_infl_CA(1)_BLK2repl_1910
            15            40       28.8263             0            99             0      5  # Retain_L_infl_CA(1)_BLK2repl_1948
            15            40       25.8171             0            99             0      5  # Retain_L_infl_CA(1)_BLK2repl_2011
           0.1             5           0.1             0            99             0     -4  # Retain_L_width_CA(1)_BLK2repl_1910
           0.1             5      0.990855             0            99             0      5  # Retain_L_width_CA(1)_BLK2repl_1948
           0.1             5         1.073             0            99             0      5  # Retain_L_width_CA(1)_BLK2repl_2011
           -10            10            10             0            99             0     -4  # Retain_L_asymptote_logit_CA(1)_BLK2repl_1910
           -10            10       2.36275             0            99             0      5  # Retain_L_asymptote_logit_CA(1)_BLK2repl_1948
           -10            10       3.27582             0            99             0      5  # Retain_L_asymptote_logit_CA(1)_BLK2repl_2011
           -50            50       1.11846             0            99             0      4  # SzSel_Fem_Peak_CA(1)_BLK1repl_1910
           -50            50       1.12748             0            99             0      4  # SzSel_Fem_Peak_CA(1)_BLK1repl_1985
            15            55          38.0             0            99             0      4  # Size_DblN_peak_OR_WA(2)_BLK1repl_1910
            15            55       35.4995             0            99             0      4  # Size_DblN_peak_OR_WA(2)_BLK1repl_1985
            15            40       29.6191             0            99             0      5  # Retain_L_infl_OR_WA(2)_BLK3repl_1910
            15            40       27.1717             0            99             0      5  # Retain_L_infl_OR_WA(2)_BLK3repl_2002
           0.1             5      0.268691             0            99             0      5  # Retain_L_width_OR_WA(2)_BLK3repl_1910
           0.1             5       1.32396             0            99             0      5  # Retain_L_width_OR_WA(2)_BLK3repl_2002
           -10            10       1.66609             0            99             0      5  # Retain_L_asymptote_logit_OR_WA(2)_BLK3repl_1910
           -10            10       3.26473             0            99             0      5  # Retain_L_asymptote_logit_OR_WA(2)_BLK3repl_2002
           -50            50          7.67             0            99             0      4  # SzSel_Fem_Peak_OR_WA(2)_BLK1repl_1910
           -50            50          4.83             0            99             0      4  # SzSel_Fem_Peak_OR_WA(2)_BLK1repl_1985
# info on dev vectors created for selex parms are reported with other devs after tag parameter section 
#
0   #  use 2D_AR1 selectivity(0/1):  experimental feature
#_no 2D_AR1 selex offset used
#
# Tag loss and Tag reporting parameters go next
0  # TG_custom:  0=no read and autogen if tag data exist; 1=read
#_Cond -6 6 1 1 2 0.01 -4 0 0 0 0 0 0 0  #_placeholder if no parameters
#
#
# Input variance adjustments factors: 
 #_1=add_to_survey_CV
 #_2=add_to_discard_stddev
 #_3=add_to_bodywt_CV
 #_4=mult_by_lencomp_N
 #_5=mult_by_agecomp_N
 #_6=mult_by_size-at-age_N
 #_7=mult_by_generalized_sizecomp
#Factor Fleet New_Var_adj hash Old_Var_adj New_Francis New_MI Francis_mult Francis_lo Francis_hi MI_mult Type Name Note
4 1 0.082067 # 0.082586 0.082067 0.182478 0.99372 0.760908 1.424152 2.209547 len CA 
4 2 0.092686 # 0.093153 0.092686 0.083873 0.994986 0.676071 1.565202 0.900379 len OR_WA 
4 3 1.855539 # 1.8285 1.855539 3.116548 1.014788 0.556142 12.237617 1.704429 len AFSC_Slope 
4 4 0.242664 # 0.245725 0.242664 0.61835 0.987545 0.57314 4.486333 2.516431 len Triennial 
4 5 0.28624 # 0.288536 0.28624 1.394753 0.992042 0.561846 13.155814 4.833895 len NWFSC_Slope 
4 6 0.408915 # 0.403383 0.408915 1.114975 1.013713 0.552181 3.528771 2.764061 len NWFSC_WCGBT 
5 1 0.118871 # 0.118504 0.118871 0.504771 1.003098 0.663255 1.979242 4.259526 age CA 
5 2 0.188959 # 0.188822 0.188959 0.563077 1.000726 0.661996 1.897149 2.982049 age OR_WA 
5 5 0.034437 # 0.035254 0.034437 0.183932 0.976839 0.773287 52.923339 5.217324 age NWFSC_Slope 
5 6 0.110512 # 0.111261 0.110512 0.157196 0.993265 0.675381 1.991399 1.412854 age NWFSC_WCGBT 
 -9999   1    0  # terminator
#
1 #_maxlambdaphase
1 #_sd_offset; must be 1 if any growthCV, sigmaR, or survey extraSD is an estimated parameter
# read 14 changes to default Lambdas (default value is 1.0)
# Like_comp codes:  1=surv; 2=disc; 3=mnwt; 4=length; 5=age; 6=SizeFreq; 7=sizeage; 8=catch; 9=init_equ_catch; 
# 10=recrdev; 11=parm_prior; 12=parm_dev; 13=CrashPen; 14=Morphcomp; 15=Tag-comp; 16=Tag-negbin; 17=F_ballpark; 18=initEQregime
#like_comp fleet  phase  value  sizefreq_method
# Commercial Lengths
 4 1 1 0.5 1
 4 2 1 0.5 1
# Commercial Ages
 5 1 1 0.5 1
 5 2 1 0.5 1
-9999  1  1  1  1  #  terminator
#
# lambdas (for info only; columns are phases)
#  0 #_CPUE/survey:_1
#  0 # F_ballpark_lambda
0 # (0/1) read specs for more stddev reporting 
# 0 0 0 0 0 0 0 0 0 # placeholder for # selex_fleet, 1=len/2=age/3=both, year, N selex bins, 0 or Growth pattern, N growth ages, 0 or NatAge_area(-1 for all), NatAge_yr, N Natages
# placeholder for vector of selex bins to be reported
# placeholder for vector of growth ages to be reported
# placeholder for vector of NatAges ages to be reported
999

