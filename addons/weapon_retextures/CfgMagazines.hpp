class CfgMagazines {
    class CA_Magazine;

    // 7Rnd .408 magazine
    class 7Rnd_408_Mag: CA_Magazine {
        picture = QPATHTOF(data\m200\icon_mag_408.paa);
    };

    // 30Rnd 6.5x39mm magazines
    class 30Rnd_65x39_caseless_mag: CA_Magazine {
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_Base_co.paa)};
    };
    class 30Rnd_65x39_caseless_black_mag: 30Rnd_65x39_caseless_mag {
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_Base_blk_co.paa)};
    };
    class 30Rnd_65x39_caseless_khaki_mag: 30Rnd_65x39_caseless_mag {
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_Base_khk_co.paa)};
    };
    class 30Rnd_65x39_caseless_mag_Tracer;
    class 30Rnd_65x39_caseless_black_mag_Tracer: 30Rnd_65x39_caseless_mag_Tracer {
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_Base_blk_co.paa)};
    };
    class 30Rnd_65x39_caseless_khaki_mag_Tracer: 30Rnd_65x39_caseless_mag_Tracer {
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_Base_khk_co.paa)};
    };

    // 100Rnd 6.5x39mm magazines
    class 100Rnd_65x39_caseless_mag: CA_Magazine {
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_LMG_co.paa)};
    };
    class 100Rnd_65x39_caseless_black_mag: 100Rnd_65x39_caseless_mag {
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_LMG_blk_co.paa)};
    };
    class 100Rnd_65x39_caseless_khaki_mag: 100Rnd_65x39_caseless_mag {
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_LMG_khk_co.paa)};
    };
    class 100Rnd_65x39_caseless_mag_Tracer: 100Rnd_65x39_caseless_mag {
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_LMG_co.paa)};
    };
    class 100Rnd_65x39_caseless_black_mag_Tracer: 100Rnd_65x39_caseless_mag_Tracer {
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_LMG_blk_co.paa)};
    };
    class 100Rnd_65x39_caseless_khaki_mag_Tracer: 100Rnd_65x39_caseless_mag_Tracer {
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_LMG_khk_co.paa)};
    };
};
