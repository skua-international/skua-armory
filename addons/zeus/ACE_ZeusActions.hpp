class ACE_ZeusActions {
    class CLASS(hideZeus) {
        displayName = "Hide Zeus";
        icon = "\a3\Ui_F_Curator\Data\Logos\arma3_curator_eye_256_ca.paa";
        statement = QUOTE(call FUNC(hideZeus));
        condition = "true";
    };
    class CLASS(toggleZeusSpeak) {
        displayName = "Toggle Zeus Speak";
        icon = "\a3\Ui_F_Curator\Data\Logos\arma3_curator_eye_256_ca.paa";
        statement = QUOTE(call FUNC(toggleZeusSpeak));
        condition = "true";
        modifierFunction = QUOTE(_this call FUNC(modifyAction_toggleZeusSpeak));
    };
};
