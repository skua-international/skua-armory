#define COMPONENT admin
#define COMPONENT_BEAUTIFIED Admin
#include "\z\skua\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_MAIN
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_MAIN
    #define DEBUG_SETTINGS DEBUG_SETTINGS_MAIN
#endif

#include "\z\skua\addons\main\script_macros.hpp"

#define DB_STATE_NO_CONNECTION 0
#define DB_STATE_CONNECTING    1
#define DB_STATE_CONNECTED     2
#define DB_STATE_ERROR        -1
