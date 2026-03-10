// ACE Advanced Ballistics
ace_advanced_ballistics_ammoTemperatureEnabled = true;
ace_advanced_ballistics_barrelLengthInfluenceEnabled = true;
ace_advanced_ballistics_bulletTraceEnabled = true;
ace_advanced_ballistics_enabled = true;
ace_advanced_ballistics_muzzleVelocityVariationEnabled = true;
ace_advanced_ballistics_simulationInterval = 0.05;

// ACE Advanced Fatigue
ace_advanced_fatigue_enabled = true;
ace_advanced_fatigue_enableStaminaBar = true;
ace_advanced_fatigue_loadFactor = 0.8;
ace_advanced_fatigue_performanceFactor = 1.1;
ace_advanced_fatigue_recoveryFactor = 2;
ace_advanced_fatigue_terrainGradientFactor = 1;

// ACE Advanced Vehicle Damage
ace_vehicle_damage_enableCarDamage = false;
ace_vehicle_damage_enabled = false;

// ACE AI
ace_ai_assignNVG = true;

// ACE Arsenal
ace_arsenal_allowDefaultLoadouts = true;
ace_arsenal_allowSharedLoadouts = true;

// ACE Artillery
ace_artillerytables_advancedCorrections = true;
ace_artillerytables_disableArtilleryComputer = true;
ace_mk6mortar_airResistanceEnabled = true;
ace_mk6mortar_allowCompass = true;
ace_mk6mortar_allowComputerRangefinder = false;
ace_mk6mortar_useAmmoHandling = true;

// ACE Captives
ace_captives_allowHandcuffOwnSide = true;
ace_captives_allowSurrender = true;
ace_captives_requireSurrender = 0;
ace_captives_requireSurrenderAi = false;

// ACE Common
ace_common_deployedSwayFactor = 0.25;
ace_common_enableSway = true;
ace_common_magneticDeclination = true;
ace_common_restedSwayFactor = 0.5;
ace_common_swayFactor = 0.15;

// ACE Cook-off
ace_cookoff_ammoCookoffDuration = 0.5;
ace_cookoff_cookoffDuration = 0.5;
ace_cookoff_cookoffEnableProjectiles = true;
ace_cookoff_cookoffEnableSound = true;
ace_cookoff_destroyVehicleAfterCookoff = false;
ace_cookoff_enableAmmobox = true;
ace_cookoff_enableAmmoCookoff = true;
ace_cookoff_enableFire = true;
ace_cookoff_probabilityCoef = 1;
ace_cookoff_removeAmmoDuringCookoff = true;

// ACE Crew Served Weapons
ace_csw_ammoHandling = 2;
ace_csw_defaultAssemblyMode = true;
ace_csw_dragAfterDeploy = true;
ace_csw_handleExtraMagazines = true;
ace_csw_handleExtraMagazinesType = 1;
ace_csw_progressBarTimeCoefficent = 1;

// ACE Dragging
ace_dragging_allowRunWithLightweight = true;
ace_dragging_skipContainerWeight = false;
ace_dragging_weightCoefficient = 2;

// ACE Explosives
ace_explosives_explodeOnDefuse = true;
ace_explosives_punishNonSpecialists = true;
ace_explosives_requireSpecialist = true;

// ACE Field Rations
acex_field_rations_enabled = false;

// ACE Fire
ace_fire_dropWeapon = 2;
ace_fire_enabled = true;
ace_fire_enableFlare = false;

// ACE Fragmentation Simulation
ace_frag_enabled = true;
ace_frag_reflectionsEnabled = false;
ace_frag_spallEnabled = false;

// ACE G-Forces
ace_gforces_coef = 1;
ace_gforces_enabledFor = 1;

// ACE Grenades
ace_grenades_convertExplosives = false;

// ACE Headless
acex_headless_enabled = false;

// ACE Hearing
ace_hearing_autoAddEarplugsToUnits = 0;
ace_hearing_earplugsVolume = 0.5;
ace_hearing_enableCombatDeafness = true;
ace_hearing_enabledForZeusUnits = false;
ace_hearing_explosionDeafnessCoefficient = 0.3;
ace_hearing_unconsciousnessVolume = 0.4;

// ACE Interaction
ace_interaction_disableNegativeRating = true;
ace_interaction_enableAnimActions = true;
ace_interaction_enableGroupRenaming = true;
ace_interaction_enableTeamManagement = true;
ace_interaction_interactWithEnemyCrew = 0;
ace_interaction_interactWithTerrainObjects = true;
ace_interaction_remoteTeamManagement = true;

// ACE Kill Tracker
ace_killtracker_showCrewKills = true;
ace_killtracker_showMedicalWounds = 2;
ace_killtracker_trackAI = true;

// ACE Logistics
ace_cargo_enable = true;
ace_cargo_enableDeploy = true;
ace_cargo_loadTimeCoefficient = 3;
ace_cargo_paradropTimeCoefficent = 1;
ace_cargo_unloadOnKilled = 0.5;
ace_rearm_distance = 15;
ace_rearm_enabled = true;
// Rearm "speed", 0 - Rearm the entire vehicle, 1 - Rearm a type of magazine, 2 - "Caliber-based rearming", meaning a partial rearm
// "Caliber" in this case is a points system based on the caliber of the weapon, so a 5.56mm magazine would be worth less than a 7.62mm magazine, and a 40mm grenade would be worth more than both
ace_rearm_level = 2;
// 0 - Unlimited, 1 - Limited, set by ace_rearm__supply, 2 - Individual Magazines need to be loaded
// Set to unlimited for now until we implement buying ammo, then switch to 1, or 2 if we ever get vehicle CSW
// Vehicle CSW probably ain't happening though
ace_rearm_supply = 0;
ace_refuel_cargoRate = 10;
ace_refuel_enabled = true;
ace_refuel_hoseLength = 12;
ace_refuel_progressDuration = 2;
ace_refuel_rate = 1;
ace_towing_addRopeToVehicleInventory = false;

// ACE Magazine Repack
ace_magazinerepack_timePerAmmo = 1;
ace_magazinerepack_timePerBeltLink = 1;
ace_magazinerepack_timePerMagazine = 1;

// ACE Map
ace_map_BFT_Enabled = false;
ace_map_DefaultChannel = 0;
ace_map_mapGlow = true;
ace_map_mapIllumination = true;
ace_map_mapLimitZoom = false;
ace_map_mapShake = true;
ace_map_mapShowCursorCoordinates = false;
ace_markers_moveRestriction = 0;
ace_markers_timestampEnabled = true;
ace_markers_timestampFormat = "HH:MM";
ace_markers_timestampHourFormat = 24;
ace_markers_timestampTimezone = 0;
ace_markers_TimestampUTCMinutesOffset = 0;
ace_markers_timestampUTCOffset = 0;

// ACE Map Gestures
ace_map_gestures_allowCurator = true;
ace_map_gestures_allowSpectator = true;
ace_map_gestures_briefingMode = 0;
ace_map_gestures_enabled = true;
ace_map_gestures_interval = 0.01;
ace_map_gestures_maxRange = 12;
ace_map_gestures_maxRangeCamera = 14;
ace_map_gestures_onlyShowFriendlys = true;

// ACE Medical
ace_medical_ai_enabledFor = 2;
ace_medical_ai_requireItems = 0;
ace_medical_AIDamageThreshold = 1;
ace_medical_alternateArmorPenetration = true;
ace_medical_bleedingCoefficient = 1;
ace_medical_blood_bloodLifetime = 900;
ace_medical_blood_enabledFor = 2;
ace_medical_blood_maxBloodObjects = 500;
ace_medical_deathChance = 0.7;
ace_medical_dropWeaponUnconsciousChance = 0.1;
ace_medical_enableVehicleCrashes = true;
ace_medical_fatalDamageSource = 2;
ace_medical_fractureChance = 0.4;
ace_medical_fractures = 2;
ace_medical_ivFlowRate = 4;
ace_medical_limbDamageThreshold = 5;
ace_medical_limping = 0;
ace_medical_painCoefficient = 1;
ace_medical_painUnconsciousChance = 0.15;
ace_medical_painUnconsciousThreshold = 0.5;
ace_medical_playerDamageThreshold = 3;
ace_medical_spontaneousWakeUpChance = 0.2;
ace_medical_spontaneousWakeUpEpinephrineBoost = 15;
ace_medical_statemachine_AIUnconsciousness = true;
ace_medical_statemachine_cardiacArrestBleedoutEnabled = true;
ace_medical_statemachine_cardiacArrestTime = 180;
ace_medical_statemachine_fatalInjuriesAI = 0;
ace_medical_statemachine_fatalInjuriesPlayer = 1;
ace_medical_useLimbDamage = 2;
ace_medical_vitals_simulateSpO2 = true;

// ACE Medical Interface
ace_medical_gui_maxDistance = 7;
ace_medical_gui_showBleeding = 2;
ace_medical_gui_showBloodlossEntry = false;
ace_medical_gui_showDamageEntry = true;

// ACE Medical Treatment
ace_medical_treatment_advancedBandages = 2;
ace_medical_treatment_advancedDiagnose = 1;
ace_medical_treatment_advancedMedication = true;
ace_medical_treatment_allowBodyBagUnconscious = true;
ace_medical_treatment_allowGraveDigging = 2;
ace_medical_treatment_allowLitterCreation = true;
ace_medical_treatment_allowSelfIV = 2;
ace_medical_treatment_allowSelfPAK = 1;
ace_medical_treatment_allowSelfStitch = 0;
ace_medical_treatment_allowSharedEquipment = 3;
ace_medical_treatment_bandageEffectiveness = 1;
ace_medical_treatment_clearTrauma = 1;
ace_medical_treatment_consumePAK = 0;
ace_medical_treatment_consumeSurgicalKit = 2;
ace_medical_treatment_convertItems = 0;
ace_medical_treatment_cprSuccessChanceMax = 1.0;
ace_medical_treatment_cprSuccessChanceMin = 0.4;
ace_medical_treatment_graveDiggingMarker = true;
ace_medical_treatment_holsterRequired = 0;
ace_medical_treatment_litterCleanupDelay = 600;
ace_medical_treatment_locationAdenosine = 0;
ace_medical_treatment_locationEpinephrine = 0;
ace_medical_treatment_locationIV = 0;
ace_medical_treatment_locationMorphine = 0;
ace_medical_treatment_locationPAK = 0;
ace_medical_treatment_locationsBoostTraining = true;
ace_medical_treatment_locationSplint = 0;
ace_medical_treatment_locationSurgicalKit = 0;
ace_medical_treatment_maxLitterObjects = 500;
ace_medical_treatment_medicAdenosine = 0;
ace_medical_treatment_medicEpinephrine = 0;
ace_medical_treatment_medicIV = 1;
ace_medical_treatment_medicMorphine = 0;
ace_medical_treatment_medicPAK = 2;
ace_medical_treatment_medicSplint = 0;
ace_medical_treatment_medicSurgicalKit = 1;
ace_medical_treatment_numericalPulse = 1;
ace_medical_treatment_timeCoefficientPAK = 1;
ace_medical_treatment_treatmentTimeAutoinjector = 4;
ace_medical_treatment_treatmentTimeBodyBag = 15;
ace_medical_treatment_treatmentTimeCoeffZeus = 0;
ace_medical_treatment_treatmentTimeCPR = 12;
ace_medical_treatment_treatmentTimeGrave = 30;
ace_medical_treatment_treatmentTimeIV = 12;
ace_medical_treatment_treatmentTimeSplint = 10;
ace_medical_treatment_treatmentTimeTourniquet = 7;
ace_medical_treatment_treatmentTimeTrainedAutoinjector = 2;
ace_medical_treatment_treatmentTimeTrainedIV = 8;
ace_medical_treatment_treatmentTimeTrainedSplint = 7;
ace_medical_treatment_treatmentTimeTrainedTourniquet = 4;
ace_medical_treatment_woundReopenChance = 1;
ace_medical_treatment_woundStitchTime = 5;

// ACE Name Tags
ace_nametags_showPlayerNames = 0;
ace_nametags_showPlayerRanks = false;

// ACE Nightvision
ace_nightvision_aimDownSightsBlur = 1;
ace_nightvision_disableNVGsWithSights = false;
ace_nightvision_effectScaling = 0.75;
ace_nightvision_fogScaling = 0.3;
ace_nightvision_noiseScaling = 0.5;

// ACE Overheating
ace_overheating_cookoffCoef = 0;
ace_overheating_coolingCoef = 4;
ace_overheating_displayTextOnJam = false;
ace_overheating_enabled = true;
ace_overheating_heatCoef = 1.5;
ace_overheating_jamChanceCoef = 0.8;
ace_overheating_overheatingDispersion = true;
ace_overheating_overheatingRateOfFire = true;
ace_overheating_suppressorCoef = 2;
ace_overheating_unJamFailChance = 0.1;
ace_overheating_unJamOnreload = false;
ace_overheating_unJamOnSwapBarrel = false;

// ACE Pointing
ace_finger_enabled = true;
ace_finger_indicatorColor = [0.83,0.68,0.21,0.75];
ace_finger_indicatorForSelf = true;
ace_finger_maxRange = 8;
ace_finger_proximityScaling = true;
ace_finger_sizeCoef = 1;

// ACE Quick Mount
ace_quickmount_distance = 5;
ace_quickmount_enabled = true;
ace_quickmount_speed = 18;

// ACE Repair
ace_repair_addSpareParts = true;
ace_repair_autoShutOffEngineWhenStartingRepair = true;
ace_repair_consumeItem_toolKit = 0;
ace_repair_enabled = true;
ace_repair_engineerSetting_fullRepair = 2;
ace_repair_engineerSetting_repair = 1;
ace_repair_engineerSetting_wheel = 0;
ace_repair_fullRepairLocation = 0;
ace_repair_fullRepairRequiredItems = ["ace_repair_anyToolKit"];
ace_repair_locationsBoostTraining = true;
ace_repair_miscRepairRequiredItems = ["ace_repair_anyToolKit"];
ace_repair_miscRepairTime = 15;
ace_repair_patchWheelEnabled = 1;
ace_repair_patchWheelLocation = ["ground","vehicle"];
ace_repair_patchWheelMaximumRepair = 0.3;
ace_repair_patchWheelRequiredItems = ["ace_repair_anyToolKit"];
ace_repair_patchWheelTime = 5;
ace_repair_repairDamageThreshold = 0.2;
ace_repair_repairDamageThreshold_engineer = 0;
ace_repair_timeCoefficientFullRepair = 1.5;
ace_repair_wheelChangeTime = 10;
ace_repair_wheelRepairRequiredItems = [];

// ACE Respawn
ace_respawn_removeDeadBodiesDisconnected = true;
ace_respawn_savePreDeathGear = true; // TODO: remove with shop

// ACE Scopes
ace_scopes_correctZeroing = true;
ace_scopes_defaultZeroRange = 100;
ace_scopes_enabled = true;
ace_scopes_forceUseOfAdjustmentTurrets = true;
ace_scopes_overwriteZeroRange = true;
ace_scopes_zeroReferenceBarometricPressure = 1013.25;
ace_scopes_zeroReferenceHumidity = 0;
ace_scopes_zeroReferenceTemperature = 15;

// ACE Sitting
acex_sitting_enable = true;

// ACE Uncategorized
ace_fastroping_autoAddFRIES = true;
ace_fastroping_requireRopeItems = true;
ace_hitreactions_minDamageToTrigger = 0.3;
ace_hitreactions_weaponDropChanceArmHitAI = 0.02;
ace_hitreactions_weaponDropChanceArmHitPlayer = 0.02;
ace_parachute_hideAltimeter = true;

// ACE User Interface
ace_ui_allowSelectiveUI = true;
ace_ui_ammoCount = false;
ace_ui_enableSpeedIndicator = true;
ace_ui_groupBar = false;

// ACE Vehicle Lock
ace_vehiclelock_defaultLockpickStrength = 60;
ace_vehiclelock_lockVehicleInventory = true;
ace_vehiclelock_vehicleStartingLockState = 0;

// ACE Vehicles
ace_novehicleclanlogo_enabled = true;
ace_vehicles_keepEngineRunning = true;

// ACE View Distance Limiter
ace_viewdistance_enabled = false;

// ACE Weapons
ace_reload_displayText = false;

// ACE Weather
ace_weather_enabled = true;
ace_weather_updateInterval = 60;
ace_weather_windSimulation = true;

// ACE Wind Deflection
ace_winddeflection_enabled = true;
ace_winddeflection_simulationInterval = 0.05;
ace_winddeflection_vehicleEnabled = true;

// ACE Zeus
ace_zeus_autoAddObjects = true;
ace_zeus_canCreateZeus = 1;
ace_zeus_radioOrdnance = false;
ace_zeus_remoteWind = false;
ace_zeus_revealMines = 0;
ace_zeus_zeusAscension = false;
ace_zeus_zeusBird = false;

// ACRE2
acre_sys_core_automaticAntennaDirection = false;
acre_sys_core_fullDuplex = false;
acre_sys_core_ignoreAntennaDirection = false;
acre_sys_core_interference = true;
acre_sys_core_revealToAI = 1;
acre_sys_core_terrainLoss = 1;
acre_sys_core_unmuteClients = true;
acre_sys_core_ts3ChannelSwitch = true;
acre_sys_core_ts3ChannelName = "ACRE2";
acre_sys_core_ts3ChannelPassword = "wellplayedhorse";
acre_sys_radio_defaultRadio = "ACRE_BF888S";
acre_sys_signal_signalModel = 2;

// ACRE2 Gestures
acre_sys_gestures_enabled = true;
acre_sys_gestures_stopADS = true;

// ACRE2 UI
acre_sys_list_LanguageHintPersist = true;

// ACRE2 Zeus
acre_sys_zeus_zeusCanSpectate = true;
acre_sys_zeus_zeusCommunicateViaCamera = true;
acre_sys_zeus_zeusDefaultVoiceSource = false;

// AE3 armaOS
AE3_armaos_uiOnTexUpdateInterval = 1;
AE3_ShutdownTime = 15;
AE3_StartupTime = 15;
AE3_UiEnableChangeDetection = true;
AE3_UiKeystrokeSyncInterval = 0.1;
AE3_UiMaxConcurrentViewers = 3;
AE3_UiMaxTransmitLines = 64;
AE3_UiOnTexture = true;
AE3_UiPlayerRange = 2;

// AE3 main
AE3_DeploymentType = 1;

// AE3 Power
AE3_Power_ChangeThreshold = 1;
AE3_Power_EnableStateSync = true;
AE3_Power_UpdateInterval = 1;

// Backpack On Chest
bocr_main_walk = true;

// Crows Electronic Warfare
crowsEW_spectrum_selfTracking = true;
crowsEW_spectrum_spectrumEnable = true;
crowsEW_spectrum_tfarSideTrack = true;
crowsEW_spectrum_UAVterminalUserVisibleInSpectrum = true;

// cTab
ctab_compass_enable = true;
ctab_core_bft_mode = 2;
ctab_core_defMapStyle = "SAT";
ctab_core_gridPrecision = 1;
ctab_core_helmetcam_mode = 1;
ctab_core_sync_time = 40;
ctab_core_uav_mode = 1;
ctab_core_useAceMicroDagr = true;
ctab_core_useArmaMarker = false;
ctab_core_useMils = false;

// D.I.R.T. - Dynamic Textures
dirt_main_affectAI = true;
dirt_main_enable = true;
dirt_main_maxDynTextures = 100;
dirt_main_updateFrequency = 2;

// DUI - Squad Radar - Indicators
diwako_dui_indicators_show = false;
diwako_dui_indicators_useACENametagsRange = true;

// DUI - Squad Radar - Line Compass
diwako_dui_linecompass_Enabled = false;

// DUI - Squad Radar - Main
force diwako_dui_colors = "ace";

// DUI - Squad Radar - Nametags
diwako_dui_nametags_deadRenderDistance = 3.5;
diwako_dui_nametags_drawRank = false;
diwako_dui_nametags_enabled = true;
diwako_dui_nametags_enableFOVBoost = true;
diwako_dui_nametags_enableOcclusion = true;
diwako_dui_nametags_fadeInTime = 0.05;
diwako_dui_nametags_fadeOutTime = 0.5;
diwako_dui_nametags_renderDistance = 7.5;
diwako_dui_nametags_showUnconAsDead = true;
diwako_dui_nametags_useLIS = true;
diwako_dui_nametags_useSideIsFriendly = true;

// DUI - Squad Radar - Radar
diwako_dui_compass_style = ["\z\diwako_dui\addons\radar\UI\compass_styles\classic\limited.paa","\z\diwako_dui\addons\radar\UI\compass_styles\classic\full.paa"];
diwako_dui_dir_showMildot = false;
diwako_dui_namelist_only_buddy_icon = true;
diwako_dui_radar_sortType = "fireteam";
diwako_dui_radar_sqlFirst = true;
diwako_dui_radar_syncGroup = true;

// Enhanced Movement Rework
emr_main_preventHighVaulting = true;

// Fleff's Advanced Repair
force ace_advrepair_Avionics = 20;
force ace_advrepair_ControlSurfaces = 20;
force ace_advrepair_DefaultRepair = 100;
force ace_advrepair_EngPistonLarge = 10;
force ace_advrepair_EngPistonMedium = 30;
force ace_advrepair_EngPistonSmall = 50;
force ace_advrepair_EngTurbineLarge = 5;
force ace_advrepair_EngTurbineSmall = 10;
force ace_advrepair_ERARep = 50;
force ace_advrepair_FuelTankLarge = 25;
force ace_advrepair_FuelTankSmall = 50;
force ace_advrepair_GunFCSRepair = 20;
force ace_advrepair_Hull0 = 30;
force ace_advrepair_Hull1 = 20;
force ace_advrepair_Hull2 = 10;
force ace_advrepair_MajorRepairLocations = 0;
force ace_advrepair_MajorRepairPermissions = 1;
force ace_advrepair_RotorAssembly = 20;
force ace_advrepair_TrackRepair = 25;
force ace_advrepair_TurretDrive = 20;
force ace_advrepair_WheelRepair = 50;

// GRAD Trenches
grad_trenches_functions_allowTrenchDecay = true;
grad_trenches_functions_bigEnvelopeDigTime = 20;
grad_trenches_functions_buildFatigueFactor = 0.1;
grad_trenches_functions_decayTime = 3600;
grad_trenches_functions_giantEnvelopeDigTime = 45;
grad_trenches_functions_hitDecayMultiplier = 2;
grad_trenches_functions_LongEnvelopeDigTime = 45;
grad_trenches_functions_shortEnvelopeDigTime = 10;
grad_trenches_functions_smallEnvelopeDigTime = 8;
grad_trenches_functions_timeoutToDecay = 60;
grad_trenches_functions_vehicleEnvelopeDigTime = 60;

// Inventory Dumper
force force ivn_dumper_mode = 0;

// Immersive Cigs - AI
force cigs_ai_set_cigsonai_chance = 0.05;

// KJW's Medical Expansion
KJW_MedicalExpansion_core_bloodIncompatibilityEnabled = true;

// Skua Mods
ace_medical_const_bloodLossKnockOutThreshold = 1;
ace_medical_const_stableVitalsBloodThreshold = 4.5;
skua_medical_preventInstantDeath = true;

// Zeus Enhanced
zen_building_markers_enabled = true;

// ZHC Settings
zhc_offload_Verbosity = 1;
zhc_stat_MapFpsPos = 1;

// Improved Melee System (Server Settings)
force IMS_AddKnifeToUnit = false;
force IMS_BayonetDistance = "6";
force IMS_BayonetOnAI = false;
force IMS_BluntWeapon = true;
force IMS_CustomAIHEALTH = "2";
force IMS_DamageMultiplierParam = "1";
force IMS_DamageMultiplierParamPlayer = "1";
force IMS_ExecutionChanceParametr = "0";
force IMS_isFistsAllowd = false;
force IMS_isHumansCanHitSM = false;
force IMS_isImsCanHitAllies = false;
force IMS_isKickButtInstaKill = true;
force IMS_isStaticDeaths = true;
force IMS_RifleDodgeSet = false;
force IMS_StealthAI_Ears = 15;
force IMS_StealthAI_Eyes = 40;
force IMS_WBK_CUSTOMCAMSERVER = true;
force IMS_WBK_MAINFPTP = true;

// WebKnight's Zombies
force WBK_Zommbies_Halth_Runner = "50";
force WBK_Zommbies_Halth_Shamb = "40";
force WBK_Zommbies_Halth_Trig = "30";
force WBK_Zommbies_Halth_Walker = "30";
force WBK_Zommbies_HeadshotMultiplier = "5";
force WBK_Zommbies_HowFarCanSee = "150";
force WBK_Zommbies_HowFarCanSee_Goliath = "150";
force WBK_Zommbies_HowFarCanSee_SI = "150";
force WBK_Zommbies_HowFarCanSee_Smash = "150";
force WBK_Zommbies_PathingDebug = false;
force WBK_Zommbies_PathingPositionChange = "8";
force WBK_ZommbiesBloaterHealthParam = "80";
force WBK_ZommbiesCorruptedHealthParam = "200";
force WBK_ZommbiesCorruptedTakeMusicParam = true;
force WBK_ZommbiesCorruptedTakeParam = true;
force WBK_ZommbiesCorruptedTakeTimeParam = "40";
force WBK_ZommbiesGoliathHealthParam = "15000";
force WBK_ZommbiesGoliathPickupAttackParam = true;
force WBK_ZommbiesGoliathThrowParam = true;
force WBK_ZommbiesGoliathThrowShardsParam = true;
force WBK_ZommbiesGoliathUndergroundAttackParam = true;
force WBK_ZommbiesGoliathUndergroundAttackParam_distance = "15";
force WBK_ZommbiesGoliathUndergroundAttackParam_max = "3";
force WBK_ZommbiesLeaperHealthParam = "120";
force WBK_ZommbiesMeleeHealthParam = "60";
force WBK_ZommbiesScreamerCoolParam = "20";
force WBK_ZommbiesScreamerDistParam = "100";
force WBK_ZommbiesScreamerHealthParam = "160";
force WBK_ZommbiesSmasherHealthParam = "3500";
force WBK_ZommbiesSmasherHealthParam_Acid = "4000";
force WBK_ZommbiesSmasherHealthParam_Hell = "5000";
force WBK_ZommbiesSmasherJumpParam = true;
force WBK_ZommbiesSmasherThrowParam = true;
force WBK_ZommbiesSmasherThrowParam_Deb = "45";
force WBK_ZommbiesSmasherThrowParam_Deb_Fire = "90";
force WBK_ZommbiesSmasherThrowParam_Deb_Spewer = "45";
force WBK_ZommbiesSmasherThrowParam_Deb_TP = "90";
