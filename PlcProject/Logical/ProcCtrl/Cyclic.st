
PROGRAM _CYCLIC
	(* Insert code here *)
	udiTimeCount_us := udiTimeCount_us + udiCycleTime_us;
	rTimeCount_s := udiTimeCount_us / 1000000.0;
	
	rCount := rCount + 0.01;
	
//	rTest := SIN(rTimeCount_s * 2 * rPI * rPeriode_s);
	
	fbPid.ActValue := rActValue;
	fbPid.SetValue := rSetValue;// + SIN(rCount);
	fbPid.PIDParameters := stPidPar;
	fbPid.MinOut := -50;
	fbPid.MaxOut := 50;
	fbPid.Enable := TRUE;
	fbPid();
	
	
	fbDelay.In := fbPid.Out;
	fbDelay.InitialValue := 0;
	fbDelay.DelayTime := stProcessSimConfig.rDelayTime;
	fbDelay.Enable := TRUE;
	fbDelay();
	
	fbPT1.In := fbDelay.Out;
	fbPT1.Gain := stProcessSimConfig.rGain;
	fbPT1.TimeConstant := stProcessSimConfig.rTimeConstant;
	fbPT1.Enable := TRUE;
	fbPT1();
	
	rActValue := fbPT1.Out;
	
	iRandom[0] := f_Random();
	iRandom[1] := f_Random();
	iRandom[2] := f_Random();
	iRandom[3] := f_Random();
	iRandom[4] := f_Random();
	
	fbMtBasicLimiter.Enable := TRUE;
	
	CASE diState OF
		
		diSTATE_STOPPED:
			
			fbMtBasicLimiter.In := 0;
			
			rActVelocity := fbMtBasicLimiter.Out;
			
			IF (REAL_TO_DINT(rTimeCount_s) MOD iMaxStopTime) = 0 THEN
				diState := diSTATE_RUNNING;
				iMaxRunTime := (f_Random() MOD 101) + 120; // value between 120...221
			END_IF
			
		diSTATE_RUNNING:
			
			fbMtBasicLimiter.In := 1500;
			
			rActVelocity := fbMtBasicLimiter.Out 
			+ (SIN(rTimeCount_s * 2 * rPI / 10) * 20) // Periode 20s, Amplitude 100
			+ f_Random() MOD 30; // Random-Wert +-30
			
			IF (REAL_TO_DINT(rTimeCount_s) MOD iMaxRunTime) = 0 THEN
				diState := diSTATE_STOPPED;
				iMaxStopTime := (f_Random() MOD 60) + 60; //value between 20...43 
			END_IF
			
		ELSE
			;
	END_CASE

	
	IF rActVelocity <> 0 THEN
		rMotorTemp := rMotorTemp + (75 - rMotorTemp) * 0.0001; // heating
	ELSE
		rMotorTemp := rMotorTemp - (rMotorTemp - 20) * 0.00005; // cool down
	END_IF
	
	fbMtBasicLimiter();
END_PROGRAM
