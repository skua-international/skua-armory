class ACEGVAR(medical_treatment,actions) {
    class BloodIV;
    class PlasmaIV;
    class SalineIV;
    class BloodIV_250: BloodIV {
        medicRequired = 0;
        allowSelfTreatment = 1;
    };

    class PlasmaIV_250: PlasmaIV {
        medicRequired = 0;
        allowSelfTreatment = 1;
    };

    class SalineIV_250: SalineIV {
        medicRequired = 0;
        allowSelfTreatment = 1;
    };
};
