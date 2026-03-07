class ctrlMenuStrip;
class Display3DEN {
    class Controls {
        class MenuStrip: ctrlMenuStrip {
            class Items {
                class Tools {
                    items[] += {QGVAR(attributeSetter), QGVAR(descriptionExt)};
                };
                class GVAR(attributeSetter) {
                    text = "[Skua] Set Default Scenario Attributes";
                    data = "";
                    shortcuts[] = {};
                    opensNewWindow = 0;
                    action = QUOTE(call (uiNamespace getVariable QQFUNC(setDefault3DENAttributes)));
                    enable = 1;
                };
                class GVAR(descriptionExt) {
                    text = "[Skua] Make Description.ext";
                    data = "";
                    shortcuts[] = {};
                    opensNewWindow = 0;
                    action = """skua"" callExtension [""descriptionExt"", [getMissionPath """"]]; systemChat ""description.ext created. Open mission folder with ALT-O or Open in VSCode to edit.""";
                    enable = 1;
                };
            };
        };
    };
};
