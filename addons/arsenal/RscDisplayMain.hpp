class RscStandardDisplay;
class RscControlsGroupNoScrollbars;
class RscDisplayMain: RscStandardDisplay {
    class controls {
        class GroupSingleplayer: RscControlsGroupNoScrollbars {
            class Controls;
        };
        class GroupTutorials: GroupSingleplayer {
            class Controls: Controls {
                class Bootcamp;
                class Arsenal: Bootcamp {
                    onButtonClick = "";
                };
            };
        };
    };
};
