class ZENGVAR(context_menu,actions) {
    class CLASS(hideZeus) {
        displayName = "Hide Zeus";
        icon = "\a3\Ui_F_Curator\Data\Logos\arma3_curator_eye_256_ca.paa";
        statement = QUOTE(call FUNC(hideZeus));
        priority = 1;
        condition = "true";
    };

    class CLASS(toggleZeusSpeak) {
        displayName = "Toggle Zeus Speak";
        icon = "\a3\Ui_F_Curator\Data\Logos\arma3_curator_eye_256_ca.paa";
        statement = QUOTE(call FUNC(toggleZeusSpeak));
        priority = 2;
        condition = "true";
        modifierFunction = QUOTE(_this call FUNC(modifyContextAction_toggleZeusSpeak));
    };
};
