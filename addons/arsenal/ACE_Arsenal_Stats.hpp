class ACEGVAR(arsenal,stats) {
    class statBase;
    class CLASS(magDamage): statBase {
        scope = 2;
        priority = 2.9;
        showText = 1;
        displayName = "Damage";
        condition = QUOTE([ARR_2(_this select 0,_this select 1)] call FUNC(showDamageStats));
        textStatement = QUOTE([ARR_2(_this select 0,_this select 1)] call FUNC(statTextStatement_magazineDamage));
        tabs[] = {{},{4}};
    };
    class CLASS(magPenetration): statBase {
        scope = 2;
        priority = 3.1;
        showText = 1;
        displayName = "Penetration (RHA)";
        condition = QUOTE([ARR_2(_this select 0,_this select 1)] call FUNC(showDamageStats));
        textStatement = QUOTE([ARR_2(_this select 0,_this select 1)] call FUNC(statTextStatement_magazinePenetration));
        tabs[] = {{},{4}};
    };
    class CLASS(weaponDamage): statBase {
        scope = 2;
        priority = 3.1;
        showText = 1;
        displayName = "Damage";
        textStatement = QUOTE([ARR_2(_this select 0,_this select 1)] call FUNC(statTextStatement_weaponDamage));
        tabs[] = {{0,1,2},{}};
    };
    class ACE_weaponMuzzleVelocity: statBase {
        priority = 1.6; // move this above weight
    };
    class ACE_explosiveResistance: statBase {
        displayName = "$STR_ui_abar";
    };

    // These don't actually indicate anything useful
    delete ACE_impact;
    delete ACE_maxZeroing;
    delete ACE_ballisticProtection;
    class ACE_gReduction: statBase { // only show g-force reduction stat when it's actually useful
        condition = "isNumber (_this select 1 >> (_this select 0) select 0) && {getNumber (_this select 1 >> (_this select 0) select 0) < 1}";
    };
};
