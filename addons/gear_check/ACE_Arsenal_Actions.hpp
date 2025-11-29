class ACEGVAR(arsenal,actions) {
    class ADDON {
        displayName = "Gear Checklist";
        condition = QUOTE([ARR_3(_this select 0,true,false)] call FUNC(showGearCondition));
        updateOnCargoChanged = 1;
        tabs[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14}; // All left panel gear tabs
        class missingBasicGearContent {
            condition = QUOTE([ARR_3(_this select 0,true,false)] call FUNC(showGearCondition));
            textStatement = QUOTE(_this select 0 call FUNC(getMissingGear));
        };
        class addMissingGear {
            label = "Add Missing Gear";
            statement = QUOTE(_this select 0 call FUNC(addMissingGear));
        };
        /*class missingSpecialGearContent {
            condition = QUOTE([ARR_3(_this select 0,false,true)] call FUNC(showGearCondition));
            textStatement = QUOTE(_this select 0 call FUNC(getSpecialGear));
        };*/
    };
};
