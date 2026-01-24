#include "\z\ace\addons\main\script_macros.hpp"

// BEGIN ACE3 reference macros
// base prefix: \z\

#define ACE_PREFIX ace

#define ACE_ADDON(component)        DOUBLES(ACE_PREFIX,component)

#define ACEGVAR(module,var)         TRIPLES(ACE_PREFIX,module,var)
#define QACEGVAR(module,var)        QUOTE(ACEGVAR(module,var))
#define QQACEGVAR(module,var)       QUOTE(QACEGVAR(module,var))

#define ACEFUNC(module,function)    TRIPLES(DOUBLES(ACE_PREFIX,module),fnc,function)
#define QACEFUNC(module,function)   QUOTE(ACEFUNC(module,function))

#define ACELSTRING(module,string)   QUOTE(TRIPLES(STR,DOUBLES(ACE_PREFIX,module),string))
#define ACELLSTRING(module,string)  localize ACELSTRING(module,string)
#define ACECSTRING(module,string)   QUOTE(TRIPLES($STR,DOUBLES(ACE_PREFIX,module),string))

#define ACEPATHTOF(component,path) \z\ace\addons\component\path
#define QACEPATHTOF(component,path) QUOTE(ACEPATHTOF(component,path))

// END ACE3 reference macros

// BEGIN Zeus Enhanced reference macros
// base prefix: \x\

#define ZEN_PREFIX zen

#define ZEN_ADDON(component)        DOUBLES(ZEN_PREFIX,component)

#define ZENGVAR(module,var)         TRIPLES(ZEN_PREFIX,module,var)
#define QZENGVAR(module,var)        QUOTE(ZENGVAR(module,var))
#define ZENFUNC(module,function)    TRIPLES(DOUBLES(ZEN_PREFIX,module),fnc,function)
#define QZENFUNC(module,function)   QUOTE(ZENFUNC(module,function))
#define ZENPATHTOF(component,path) \x\zen\addons\component\path
#define QZENPATHTOF(component,path) QUOTE(ZENPATHTOF(component,path))

// END Zeus Enhanced reference macros

#define CLASS(classname) DOUBLES(PREFIX,classname)
#define QCLASS(classname) QUOTE(CLASS(classname))
#define SLOT_GOGGLES 603
#define SLOT_HEADGEAR 605
#define SLOT_MAP 608
#define SLOT_COMPASS 609
#define SLOT_WATCH 610
#define SLOT_RADIO 611
#define SLOT_GPS 612
