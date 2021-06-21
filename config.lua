Config = {
    range = {
        ['person']=25.0, -- range required to target ped
        ['object']=4.0, -- range required to target object
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
    peds = {
        minAge = 20, -- minimum age for ped
        maxAge = 85, -- maximum age for ped
        minIncome = 5000, -- minimum income for ped
        maxIncome = 250000, -- maximum income for ped
        minHackCash = 100, -- minimum cash that player can get for hacking bank account
        maxHackCash = 1000, -- maximum cash that player can get for hacking bank account
        divHackCash = 2, -- Set to 1 if you want random abount between min & max values
    },
    -- Not recommended to edit values under this line
    import = { 
        lastNames = {},
        firstNames = {
            female = {},
            male = {},
        },
        workplaces = {},
        facts = {}
    },
    targettingModes = {
        ['ped']=true,
        ['vehicle']=true,
        ['object']=true,
    },
    disallowed = {
        pedTypes = { -- Contain list of pedTypes that are not hackable (animals etc.)
            [25]=true,
            [26]=true,
            [28]=true,
        }
    },
    models = {
        ['1043035044'] = true,         
        ['3639322914'] = true,
        ['862871082'] = true,
    },
}