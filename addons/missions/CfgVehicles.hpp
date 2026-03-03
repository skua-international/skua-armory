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
            class Side: Combo {
                displayName = "$STR_eval_typeside";
                property = QGVAR(moduleSide);
                typeName = "NUMBER";
                defaultValue = 1;
                class values {
                    class West {
                        name = "$STR_WEST";
                        value = 1;
                    };
                    class East {
                        name = "$STR_east";
                        value = 2;
                    };
                    class Indp {
                        name = "$STR_guerrila";
                        value = 3;
                    };
                    class Civ {
                        name = "$STR_civilian";
                        value = 4;
                    };
                    class All {
                        name = "$STR_word_all";
                        value = 5;
                    };
                };
            };
            class RefObject: Edit {
                displayName = "Reference Object";
                property = QGVAR(moduleObject);
                typeName = "STRING";
                defaultValue = "";
                tooltip = "Variable name of the reference object.";
            };
            class ModuleDescription: ModuleDescription {};
        };

        class ModuleDescription: ModuleDescription {
            description = "Set the object that will be used as the reference for the base arsenal. You can then restrict items as usual with ACE black/whitelist.";
        };
    };

    class GVAR(moduleArsenalAddArea): Module_F {
        author = "LinkIsGrim";
        scope = 2;
        scopeCurator = 0; // Zeus no touchy
        category = QGVAR(modules);
        displayName = "Add Arsenal Area";
        function = QFUNC(moduleArsenalAddArea);
        canSetArea = 1; // Set to 1 to allow the module to define an area in the editor
        canSetAreaShape = 1;
        isGlobal = 1; // Set to 1 to ensure the module is executed on all machines, not just the server

        class AttributeValues {
            size3[] = {20,20,-1};
            isRectangle = 0;
        };

        class Attributes: AttributesBase {
            class Side: Combo {
                displayName = "$STR_eval_typeside";
                property = QGVAR(moduleSide);
                typeName = "NUMBER";
                defaultValue = 1;
                class values {
                    class West {
                        name = "$STR_WEST";
                        value = 1;
                    };
                    class East {
                        name = "$STR_east";
                        value = 2;
                    };
                    class Indp {
                        name = "$STR_guerrila";
                        value = 3;
                    };
                    class Civ {
                        name = "$STR_civilian";
                        value = 4;
                    };
                    class All {
                        name = "$STR_word_all";
                        value = 5;
                    };
                };
            };
            class ModuleDescription: ModuleDescription {};
        };

        class ModuleDescription: ModuleDescription {
            description = "Add an area inside of which players are allowed to open the arsenal by self-interacting.";
        };
    };

    class Man;
    class CAManBase: Man {
        class ACE_SelfActions {
            class GVAR(arsenal) {
                displayName = "Arsenal";
                condition = QUOTE(_player call FUNC(canOpenBaseArsenal));
                icon = "\A3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa";
                statement = "";
                class GVAR(openBaseArsenal) {
                    displayName = "Open Base Arsenal";
                    condition = "true";
                    icon = "\A3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa";
                    statement = QUOTE(_player call FUNC(openBaseArsenal));
                    showDisabled = 0;
                };
            };
        };
    };
};
