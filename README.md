# fivem-ctOS
Fivem ctOS - Profiler tool based on Watch Dogs game series

**This project is currently in development.**

## Installation
- Download the resource and copy the files to `resources/`.
- Start resource via `start fivem-ctOS`.

**Optional**
- Open your `server.cfg` and add `start fivem-ctOS`.
- Restart your server.

## Usage
- Use the `/target [ped/vehicle]` chat command to enable target mode.

## Editing config files
In `config.lua` you can edit: 
- Range required to target ped/vehicle/object
- Ped data i.e age, income, cash from hacking bank account

In `config/` directory you can add more:
- first/last names, workplaces or facts about peds.

## Important information
Resource dont have function to give player money  to do that follow instructions in function `ctOS_injectBankAccount` in `base.lua`.