Config = {}

Config.GaragePools = { -- VALID GARAGEPOOLS (NESSESSARY FOR THE INPUT WHEN YOU CONFISCATE A VEHICLE)
    'police',
    'fib',
}

Config.Locations = {
    ['police'] = { -- NAME IS UNIMPORTANT (CAN BE ANYTHING)
        coords          = vector3(369.8558, -1607.885, 28.25193), -- WHERE SHOULD THE MARKER BE?
        spawnCoords     = vector3(375.9501, -1612.182, 29.29193), -- WHERE SHOULD THE VEHICLE SPAWN?
        spawnRotation   = 229.88, -- THE ROTATIONS OF THE VEHICLE WHEN IS SPAWNS?
        garagePool      = 'police', -- WHICH VEHICLES SHOULD THE LIST CONTAIN? (YOU CAN SPECIFY THE GARAREPOOL WHEN YOU CONFISCATE THE VEHICLE)
        job             = 'police', -- WHICH JOB SHOULD BE ABLE TO SEE THE MARKER? (FALSE IS NONE)
        grade           = -1, -- WHICH JOB GRADE SHOULD THE PERSON HAVE AT LEAST? (KEEP THIS AT -1 IF JOB = FALSE)
        canTakeOut      = true, -- SHOULD YOU BE ABLE TO SPAWN THE VEHICLES? (THIS SEEMS TO BE UNNESSESSARY BUT SOMETIMES YOU JUST WANT TO LIST THE VEHICLES)
        isList          = false, -- SHOULD THE GARAGE IGNORE GARAGEPOOL AND SHOW EVERY CONFISCATED VEHICLE?
        markerType      = 1, -- MARKER TYPE (https://docs.fivem.net/docs/game-references/markers)
        markerDensity   = 100, -- DENSITY OF THE MARKER (0-255)
        markerSize      = vector3(1.0, 1.0, 1.0), -- SIZE OF THE MARKER
        markerColor     = vector3(0, 0, 255), -- COLOR OF THE MARKER (https://htmlcolorcodes.com)
    },

    ['fib'] = { -- NAME IS UNIMPORTANT (CAN BE ANYTHING)
        coords          = vector3(371.6619, -1612.422, 28.25195), -- WHERE SHOULD THE MARKER BE?
        spawnCoords     = vector3(385.7841, -1621.239, 29.29195), -- WHERE SHOULD THE VEHICLE SPAWN?
        spawnRotation   = 317.34, -- THE ROTATIONS OF THE VEHICLE WHEN IS SPAWNS?
        garagePool      = 'fib', -- WHICH VEHICLES SHOULD THE LIST CONTAIN? (YOU CAN SPECIFY THE GARAREPOOL WHEN YOU CONFISCATE THE VEHICLE)
        job             = false, -- WHICH JOB SHOULD BE ABLE TO SEE THE MARKER? (FALSE IS NONE)
        grade           = -1, -- WHICH JOB GRADE SHOULD THE PERSON HAVE AT LEAST? (KEEP THIS AT -1 IF JOB = FALSE)
        canTakeOut      = false, -- SHOULD YOU BE ABLE TO SPAWN THE VEHICLES? (THIS SEEMS TO BE UNNESSESSARY BUT SOMETIMES YOU JUST WANT TO LIST THE VEHICLES)
        isList          = true, -- SHOULD THE GARAGE IGNORE GARAGEPOOL AND SHOW EVERY CONFISCATED VEHICLE?
        markerType      = 1, -- MARKER TYPE (https://docs.fivem.net/docs/game-references/markers)
        markerDensity   = 100, -- DENSITY OF THE MARKER (0-255)
        markerSize      = vector3(1.0, 1.0, 1.0), -- SIZE OF THE MARKER
        markerColor     = vector3(0, 0, 255), -- COLOR OF THE MARKER (https://htmlcolorcodes.com)
    },
}

--[[IMPORTANT: if you look down in the client.lua you'll find a command that allows averyone with police or fib job to confiscate 
any vehicle. if you want to implement the script into anything, use:     exports['esx_confiscations']:ConfiscateVehicle()     ]]