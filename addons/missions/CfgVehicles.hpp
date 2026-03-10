#define BASE_ATTRIBUTES class ModuleDescription: ModuleDescription {}

#define SIDE_ATTRIBUTE class Side: Combo { \
    displayName = "$STR_eval_typeside"; \
    property = QGVAR(moduleSide); \
    typeName = "NUMBER"; \
    defaultValue = 5; /* Default to all */ \
    class values { \
        class West { name = "$STR_WEST"; value = 1; }; \
        class East { name = "$STR_east"; value = 2; }; \
        class Indp { name = "$STR_guerrila"; value = 3; }; \
        class Civ { name = "$STR_civilian"; value = 4; }; \
        class All { name = "$STR_word_all"; value = 5; }; \
    }; \
}

#define MODULE_DESCRIPTION(desc) class ModuleDescription: ModuleDescription { \
    description = QUOTE(desc); \
}

#define DEFAULT_AREA_SIZE(x,y,z,rectangle) class AttributeValues { \
    size3[] = {ARR_3(x,y,z)}; \
    isRectangle = rectangle; \
} 


class CfgVehicles {
    class Logic;
    class Module_F: Logic {
        class AttributesBase {
            class Combo;
            class Edit;
            class ModuleDescription;
        };

        class ModuleDescription;
    };

    class GVAR(moduleArsenalSetReference): Module_F {
        author = "LinkIsGrim";
        scope = 2;
        scopeCurator = 0; // Zeus no touchy
        category = QGVAR(modules);
        displayName = "Set Arsenal Reference";
        function = QFUNC(moduleArsenalSetReference);
        canSetArea = 0;
        canSetAreaShape = 0;
        isGlobal = 1; // Set to 1 to ensure the module is executed on all machines, not just the server

        class Attributes: AttributesBase {
            SIDE_ATTRIBUTE;
            class RefObject: Edit {
                displayName = "Reference Object";
                property = QGVAR(moduleObject);
                typeName = "STRING";
                defaultValue = "''";
                tooltip = "Variable name of the reference object.";
            };
            BASE_ATTRIBUTES;
        };

        MODULE_DESCRIPTION(Set the object that will be used as the reference for the base arsenal. You can then restrict items as usual with ACE black/whitelist.);
    };

    class GVAR(areaModuleBase): Module_F {
        author = "LinkIsGrim";
        category = QGVAR(modules);
        scope = 0;
        scopeCurator = 0; // Zeus no touchy
        canSetArea = 1;
        canSetAreaShape = 1;
        isGlobal = 1; // Set to 1 to ensure the module is executed on all machines, not just the server

        DEFAULT_AREA_SIZE(10,10,5,0);

        class Attributes: AttributesBase {
            SIDE_ATTRIBUTE;
            BASE_ATTRIBUTES;
        };

        MODULE_DESCRIPTION("");
    };

    class GVAR(moduleArsenalAddArea): GVAR(areaModuleBase) {
        author = "LinkIsGrim";
        scope = 2;
        displayName = "Add Arsenal Area";
        function = QFUNC(moduleArsenalAddArea);

        DEFAULT_AREA_SIZE(20,20,-1,0);

        class Attributes: Attributes {
            SIDE_ATTRIBUTE;
            BASE_ATTRIBUTES;
        };

        MODULE_DESCRIPTION(Add an area inside of which players are allowed to open the arsenal by self-interacting.);
    };

    class GVAR(moduleLogisticsAddArea): GVAR(areaModuleBase) {
        author = "LinkIsGrim";
        scope = 2;
        displayName = "Add Logistics Area";
        function = QFUNC(moduleLogisticsAddArea);

        DEFAULT_AREA_SIZE(20,20,-1,0);

        class Attributes: Attributes {
            SIDE_ATTRIBUTE;
            BASE_ATTRIBUTES;
        };

        MODULE_DESCRIPTION(Add an area inside of which players are allowed to open the logistics menu by self-interacting.);
    };

    class Man;
    class CAManBase: Man {
        class ACE_SelfActions {
            class GVAR(arsenal) {
                displayName = "Arsenal";
                condition = QUOTE(_player call FUNC(canOpenBaseArsenal));
                icon = "\A3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa";
                class GVAR(openBaseArsenal) {
                    displayName = "Open Base Arsenal";
                    icon = "\A3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa";
                    statement = QUOTE(_player call FUNC(openBaseArsenal));
                };
            };
            class GVAR(logisticsMenu) {
                displayName = "Logistics";
                condition = QUOTE(_player call FUNC(canOpenLogisticsMenu));
                icon = "\A3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa";
                insertChildren = QUOTE(_target call FUNC(makeLogisticsActions));
            };
        };
    };
};
