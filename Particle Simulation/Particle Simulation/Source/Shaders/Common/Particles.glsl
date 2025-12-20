#define VOID 0
#define SAND 1
#define WATER 2
#define WALL 3
#define WOOD 4
#define SMOKE 5
#define FIRE 6
#define STONE 7
#define KEROSENE 8
#define STEAM 9
#define SEAWATER 10
#define LAVA 11
#define ICE 12
#define SALT 13
#define SAWDUST 14
#define ACID 15
#define VINE 16
#define RUST 17
#define IRON 18
#define METHANE 19
#define AMMONIA 20
#define CHLORINE 21

#define PHASE_STATIC 0
#define PHASE_SOLID 1
#define PHASE_LIQUID 2
#define PHASE_GAS 3

int GetParticlePhase(int type)
{
    switch (type)
    {
        case VOID: return PHASE_GAS;
        case SAND: return PHASE_SOLID;
        case WATER: return PHASE_LIQUID;
        case WALL: return PHASE_STATIC;
        case WOOD: return PHASE_STATIC;
        case SMOKE: return PHASE_GAS;
        case FIRE: return PHASE_SOLID;
        case STONE: return PHASE_SOLID;
        case KEROSENE: return PHASE_LIQUID;
        case STEAM: return PHASE_GAS;
        case SEAWATER: return PHASE_LIQUID;
        case LAVA: return PHASE_LIQUID;
        case ICE: return PHASE_STATIC;
        case SALT: return PHASE_SOLID;
        case SAWDUST: return PHASE_SOLID;
        case ACID: return PHASE_LIQUID;
        case VINE: return PHASE_STATIC;
        case RUST: return PHASE_SOLID;
        case IRON: return PHASE_STATIC;
        case METHANE: return PHASE_GAS;
        case AMMONIA: return PHASE_GAS;
        case CHLORINE: return PHASE_GAS;
        default: return PHASE_STATIC;
    }
}

float GetParticleDensity(int type)
{
    switch (type)
    {
        case VOID: return 1.292;
        case SAND: return 1602;
        case WATER: return 999.84;
        case WALL: return 10000;
        case WOOD: return 685;
        case SMOKE: return 2.15;
        case FIRE: return 100;
        case STONE: return 2600;
        case KEROSENE: return 795;
        case STEAM: return 0.59;
        case SEAWATER: return 1023.6;
        case LAVA: return 1300;
        case ICE: return 916.8;
        case SALT: return 2170;
        case SAWDUST: return 1471;
        case ACID: return 1020;
        case VINE: return 342;
        case RUST: return 5745;
        case IRON: return 7874;
        case METHANE: return 0.717;
        case AMMONIA: return 0.769;
        case CHLORINE: return 3.2;
        default: return 1;
    }
}

Particle CreateParticle(int type, float shade)
{
    return Particle(
        type,
        GetParticlePhase(type),
        GetParticleDensity(type),
        shade
    );
}
