

PROGRAM _INIT
	(* Insert code here *)
	stProcessSimConfig.rDelayTime := 0.5;
	stProcessSimConfig.rGain := 0.9;
	stProcessSimConfig.rTimeConstant := 5;

	iMaxStopTime := 5; //5s init value
	
	stPidPar.DerivativeTime := 0;
	stPidPar.FilterTime := 0;
	stPidPar.Gain := 2;
	stPidPar.IntegrationTime := 10;
	
	fbRtInfo(enable := TRUE);
	udiCycleTime_us := fbRtInfo.cycle_time;
	
	fbMtBasicLimiter.MaxNegSlewRate := 250;
	fbMtBasicLimiter.MaxPosSlewRate := 350;
	fbMtBasicLimiter.MinOut := 0;
	fbMtBasicLimiter.MaxOut := 1500;

END_PROGRAM