class ACEGVAR(arsenal,sorts) {
    class sortBase;
    class ACE_protectionBallistic: sortBase {
        tabs[] = {{},{}};
    };
    class ACE_protectionExplosive: ACE_protectionBallistic {
        displayName = "Sort by armor";
        tabs[] = {{3,4,6},{}};
    };
    class CLASS(magazineDamage): sortBase {
        scope = 2;
        tabs[] = {{}, {4}};
        displayName = "Sort by damage";
        statement = QUOTE(_this call FUNC(sortStatement_magazineDamage));
    };
    class CLASS(magazinePenetration): CLASS(magazineDamage) {
        displayName = "Sort by penetration";
        statement = QUOTE(_this call FUNC(sortStatement_magazinePenetration));
    };
};
