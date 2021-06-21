Config = {
    targettingModes = { -- dont edit these
        ['ped']=true,
        ['vehicle']=true,
        ['object']=true,
    },
    range = {
        ['person']=25.0, -- range required to target ped
        ['object']=10.0, -- range required to target object
        ['vehicle']=15.0, -- range required to target vehicle
    },
    animations = {
        ['phone'] = {
            ['idle'] = {dict="cellphone@",anim="cellphone_text_in"},
        }
    },
    props = { 
        ['phone']="prop_npc_phone_02"
    },
    disallowed = {
        pedTypes = { -- Contain list of pedTypes that are not hackable (animals etc.)
            [25]=true,
            [26]=true,
            [28]=true,
        }
    },
    peds = {
        minAge = 20, -- minimum age for ped
        maxAge = 85, -- maximum age for ped
        minIncome = 5000, -- minimum income for ped
        maxIncome = 250000 -- maximum income for ped
    },
    import = { -- dont edit these
        lastNames = {},
        firstNames = {
            female = {},
            male = {},
        },
        workplaces = {},
        facts = {}
    }
}