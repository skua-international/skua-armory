class CfgGlasses {
    class None;
    class CLASS(Shemagh_Black): None {
        author = "GhostIsSpooky";
        scope = 2;
        displayName = "[SIA] Scarf (Black)";
        model = QPATHTOF(data\G_Shemagh.p3d);
        picture = QPATHTOF(data\logo.paa);
        hiddenSelections[]= {"camo"};
        hiddenSelectionsTextures[]= {QPATHTOF(data\Shemagh_Black_co.paa)};
    };
    class CLASS(Shemagh_Olive): CLASS(Shemagh_Black) {
        displayName = "[SIA] Scarf (Olive)";
        hiddenSelectionsTextures[]= {QPATHTOF(data\Shemagh_Olive_co.paa)};
    };
    class CLASS(Shemagh_Coyote): CLASS(Shemagh_Black) {
        displayName = "[SIA] Scarf (Coyote)";
        hiddenSelectionsTextures[]= {QPATHTOF(data\do_equip_co.paa)};
    };
};
