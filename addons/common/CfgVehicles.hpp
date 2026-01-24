class CfgVehicles {
    class Module_F;

    class CLASS(module): Module_F {
        scope = 2;
        displayName = "Skua Master Module";
        init = QUOTE(GVAR(isSkuaMission) = true;);
        class CBA_Extended_EventHandlers: CBA_Extended_EventHandlers {};
    };
};
