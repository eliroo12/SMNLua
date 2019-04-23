-- IdleMode determines the set used after casting. You change it with "/console gs c <IdleMode>"
-- The modes are:
-- Refresh: Uses the most refresh available.
-- DT: A mix of refresh, PDT, and MDT to help when you can't avoid AOE.
-- PetDT: Sacrifice refresh to reduce avatar's damage taken. WARNING: Selenian Cap drops you below 119, use with caution!
-- Favor: Uses Beckoner's Horn +1 and max smn skill to boost the favor effect.
-- Pet Haste: Uses gear pet haste gear for faster TP


-- Additional Bindings:
-- F9 - Toggles between a subset of IdleModes (Refresh > DT > PetDT)
-- F10 - Toggles MeleeMode (When enabled, equips Nirvana and Elan+1, then disables those 2 slots from swapping)
--       NOTE: If you don't already have the Nirvana & Elan+1 equipped, YOU WILL LOSE TP

-- UI Elements
-- This lua contains several UI elements that you can interact with. This is thanks to Jyouya's GUI library
-- Avatar Selection UI. You can select which summon you want to call here. Will unsummon whatever you have out and summon the new one
-- Displays Pets name, their HP% and their TP
-- Warns you if Favor is off also displays Current favor values based on selected Idle mode. 
-- Creates a macro hud if you have macros enabled.
-- Nirvana lock - Equips the set nirvanal and locks those slots if the lock is on. Good for AM3 shenanigans
-- Auto Siphon - Will automatically summon the proper elemental and siphon for maximum MP
-- Autoconvert - Toggles whether or not you will automatically convert if you try to use a BP you don't have mana for during Astral conduit. Does nothing outside of conduit unless Convertall is set to true
-- Lagmode - Toggle this on if you feel like your BP damage and recast aren't registering right. This adds a minor delay to your bloodpact midcast to ensure that damage is registering
-- Repair - Refreshes UI and binds. A dropped packet can force your binds off click this to refresh that Data.
-- Accuracy mode selector
-- Idle mode selector. Can change to refresh focus, favor focus or avatar DD (Haste) focus
-- Engaged mode selector - Choose what sets to use when engaged

-- I highly recommend not putting anything important on your macro pallet in any areas you bind over. The default for this  lua is ALT 1-9. Either empty them or change them to /echo 'Something went wrong, repair the UI'

-- Other Feature
-- This Gearswap supports Optimal Astral Conduit usage
-- It doesn't lock your sets just skips Pet_precast and pet_aftercast (idle) during Astral conduit Your other precast functions will work and casting a spell normally will put you in idle.
-- This allows you to mash away at your macro with nigh impunity

-- If something doesn't work for you please contact me on Discord at Lavi#8710
-- Credits go to - Pergatory (Their base LUA was used here), Verda (Used a lot of elements from their Gearswap)
-- Jyouya - Who made the GUI library as well as helped scripted out some of the more difficult stuff.
-- Poochlove - My wife who made some of the icons!



require('Mote-Utility')
require('Mote-Mappings')
require('GUI')
require('Modes')
packets = require('packets')
function file_unload()

	--Unloads all manually set binds. Add any additional binds here to ensure a proper unload
	send_command('unbind f9')
	send_command('unbind f10')
	send_command('unbind '..carbuncleBind)
	send_command('unbind '..fenrirBind)
	send_command('unbind '..ifritBind)
	send_command('unbind '..titanBind)
	send_command('unbind '..leviathanBind)
	send_command('unbind '..garudaBind)
	send_command('unbind '..shivaBind)
	send_command('unbind '..ramuhBind)
	send_command('unbind '..diabolosBind)
	send_command('unbind '..caitsithBind)
	send_command('unbind '..atomosBind)
	send_command('unbind '..alexanderBind)
	send_command('unbind '..odinBind)
	send_command('unbind '..releasemacro)
	send_command('unbind '..retreatmacro)
	send_command('unbind '..assaultmacro)
	send_command('!unbind numpad/')
	unbind_keybinds('Carbuncle') -- Just pick carbuncle manually because that table has 1-9 listed as available macros
	
end

function get_sets()
	setup() --sets up variables and builds UI
	require('SMN-%s-Gear':format(player.name)) -- Gather gear data as well as determines favor skill values
	build_gearsets() -- Builds gearsets
	idle() -- forces idle on load
--	Currentskill = RefreshSkill
	
end
--Runs setup. Can change variables here for further customization
function setup()

--Controls starting position of UI elements. All buttons offset from these two. Can be change with the command gs c pos x y
	Xpos= 1320
	Ypos= 150
-----------------------------------------------------------------------------------------------------------------------------
	siphondelay = 7 --Enter how long you want the siphon process to take here. I highly recommend 8 seconds. Lagmode will add an additional 2 seconds to this
	BindMacros = true -- Change to false if you don't want to bind macros. Recommended if you want to use your own ingame macros
	NoHud = false -- Change to true if you want no hud display. 
	Autofavor = true -- Change to false if you don't want the lua to automatically apply Avatar's Favor when applicable
	AutoRemedy = true -- Auto Remedy when using an ability while Paralyzed. Checks Inventory
	AutoEcho = true-- Auto Echo Drop when using an ability while Silenced. Checks Inventory
	Convertall = true -- If this is set to true the Autoconvert function will work on any bloodpact regardless if you are under Astral Conduit or not
	AccMode = false 
	MeleeMode = false --Determines if you are locked into Nirvana or not.
    set_macro_page(10, 10)
-----------------------------------------------------------------------------------------------------------
--------------------------------End User Entry Section-----------------------------------------------------
-----------------------------------------------------------------------------------------------------------
	
	
	engagedMode = M{['description']='Engaged Mode', 'Off', 'Melee', 'TH'} --Sets for handling gear while engaged
	summons = M{['description']='Summons', 'blank', 'cait sith', 'carbuncle', 'fenrir', 'ifrit', 'titan', 'leviathan', 'garuda', 'shiva', 'ramuh', 'diabolos', 'atomos', 'alexander', 'odin'} --builds a table with all summon values. Needed for the Summon Cycle button
	IdleMode = M{['description']='Idle Mode','Refresh','DT','Favor','PetDT','Pet Haste'} -- Sets for handling gear while idled
	AccMode = M{['description']='Pet Accuracy', 'Normal', 'Mid', 'Acc'} -- Sets for determining the amount of accuracy to use in bloodpacts
	atconvert = M(true, 'Auto Convert') --Boolean mode for the autoconvert feature. Set to false if you want to load up with this disabled
	LagMode = M(false, 'Lag Mode') -- Boolean mode for lag mode
	Favor = "Off" -- String used in the Avatar's Favor UI. 

------------------------------------------------------------------------------------------------------------
--------------------Grouping BPs in tables to accurately determine which sets to use for them---------------
	Buff_BPs_Duration = S{'Shining Ruby','Aerial Armor','Frost Armor','Rolling Thunder','Crimson Howl','Lightning Armor','Ecliptic Growl','Glittering Ruby','Earthen Ward','Hastega','Noctoshield','Ecliptic Howl','Dream Shroud','Earthen Armor','Fleet Wind','Inferno Howl','Heavenward Howl','Hastega II','Soothing Current','Crystal Blessing'}
	Buff_BPs_Healing = S{'Healing Ruby','Healing Ruby II','Whispering Wind','Spring Water'}
	Debuff_BPs = S{'Mewing Lullaby','Eerie Eye','Lunar Cry','Lunar Roar','Nightmare','Pavor Nocturnus','Ultimate Terror','Somnolence','Slowga','Tidal Roar','Diamond Storm','Sleepga','Shock Squall'}
	Debuff_Rage_BPs = S{'Moonlit Charge','Tail Whip'}
	Magic_BPs_NoTP = S{'Holy Mist','Nether Blast','Aerial Blast','Searing Light','Diamond Dust','Earthen Fury','Zantetsuken','Tidal Wave','Judgment Bolt','Inferno','Howling Moon','Ruinous Omen','Night Terror','Thunderspark'}
	Magic_BPs_TP = S{'Impact','Conflag Strike','Level ? Holy','Lunar Bay'}
	Merit_BPs = S{'Meteor Strike','Geocrush','Grand Fall','Wind Blade','Heavenly Strike','Thunderstorm'}
	Physical_BPs_TP = S{'Rock Buster','Mountain Buster','Crescent Fang','Spinning Dive'}
	AvatarList = S{'Shiva','Ramuh','Garuda','Leviathan','Diabolos','Titan','Fenrir','Ifrit','Carbuncle','Fire Spirit','Air Spirit','Ice Spirit','Thunder Spirit','Light Spirit','Dark Spirit','Earth Spirit','Water Spirit','Cait Sith','Alexander','Odin','Atomos'}
	Spabilities = S{'Odin', 'Alexander', 'Searing Light', 'Ruinous Omen', 'Howling Moon', 'Aerial Blast', 'Inferno', 'Tidal Wave', 'Judgment Bolt', 'Diamond Dust', 'Earthen Fury' }
	NonValidFavor = S{'Odin', 'Alexander', 'Atomos'}
------------------------------------------------------------
--Initializing values used to help determine favor variables. Manually define these in your GEAR lua, not here as it won't do anything--
	jobpointbonus = false
	Currentskill = 417
	RefreshSkill = 417
	DTSkill = 417
	FavorSkill = 417
	PetDTSkill = 417
	PetHasteSkill = 417
----------------------------------------------------------
----------------------------------------------------------
	merits = {} -- Initializing empty merits table
	determinemerits() -- This function verifys if you have 550 JP and also sets your merit values for the Merit BPs
	build_UI() -- Builds UI

if buffactive['Avatar\'s Favor'] then Favor = "On" end  --Checks if Favor is on and sets value

if BindMacros then build_keybinds(pet and macros[pet.name] and pet.name or 'None') end --Builds initial Keybinds


pet_update() -- Updates pet to make UI display accurately
	

end
-- Defines macrosets for pet as well as macro settings. Modify values here to change what macros are bound
function define_macrosets()
--Replace the full text of the bind here so it appears on the UI right and then the actualy bind below
	assaulttext='Numpad+'
	assaultmacro='numpad+'
	releasetext='Numpad-'
	releasemacro='numpad-'
	retreattext='Ctrl Numpad+'
	retreatmacro='^numpad+'

	send_command('bind '..releasemacro..' gs c smn blank')
	send_command('bind '..retreatmacro..' input /pet "Retreat" <me>')
	send_command('bind '..assaultmacro..' input /pet "Assault" <t>')

-- If you want different binds for the avatars fill out them here.
-- Bind should be the actual text of key bind. Text should be what you want displayed in the HUD
---------------------------------------------------------------------------	
	carbuncleBind = '!numpad1'
	carbuncleText = 'Alt Numpad 1'
	fenrirBind = '!numpad2'
	fenrirText = 'Alt Numpad 2'
	ifritBind = '!numpad3'
	ifritText = 'Alt Numpad 3'
	titanBind = '!numpad4'
	titanText = 'Alt Numpad 4'
	leviathanBind = '!numpad5'
	leviathanText = 'Alt Numpad 5'
	garudaBind = '!numpad6'
	garudaText = 'Alt Numpad 6'
	shivaBind = '!numpad7'
	shivaText = 'Alt Numpad 7'
	ramuhBind = '!numpad8'
	ramuhText = 'Alt Numpad 8'
	diabolosBind = '!numpad9'
	diabolosText = 'Alt Numpad 9'
	caitsithBind = '!numpad0'
	caitsithText = 'Alt Numpad 0'
	atomosBind = '!0'
	atomosText ='Alt 0'
	alexanderBind = '!-'
	alexanderText = 'Alt -'
	odinBind = '!='
	odinText = 'Alt ='
---------------------------------------------------------------------------	

	send_command('bind f9 gs c ToggleIdle')
	send_command('bind f10 gs c MeleeMode true')
	send_command('bind '..carbuncleBind..' gs c smn carbuncle')
	send_command('bind '..fenrirBind..' gs c smn fenrir')
	send_command('bind '..ifritBind..' gs c smn ifrit')
	send_command('bind '..titanBind..' gs c smn titan')
	send_command('bind '..leviathanBind..' gs c smn leviathan')
	send_command('bind '..garudaBind..' gs c smn garuda')
	send_command('bind '..shivaBind..' gs c smn shiva')
	send_command('bind '..ramuhBind..' gs c smn ramuh')
	send_command('bind '..diabolosBind..' gs c smn diabolos')
	send_command('bind '..caitsithBind..' gs c smn caitsith')
	send_command('bind '..atomosBind..' gs c smn atomos')
	send_command('bind '..alexanderBind..' input /ma "Alexander" <me>')
	send_command('bind '..odinBind..' input /ma "Odin" <me>')
	
	--Special Binds for myself to run the siphon command without clicking the button. Can change manually
	send_command('bind !numpad/ gs c siphon')
	
	-- Just making a table for building a UI
	base_macros = {
	{text = releasetext, name = 'Release'},
	{text = assaulttext, name = 'Assault'}, 
	{text = retreattext, name = 'Retreat'},
	
}
-- Two ways to customize here. If you want all the same command binds edit Macrotext to equal the actual name of the bind key. EG. macrotext='Alt: ' means the UI will say my binds are on Alt
-- Macroassign is where you put the trigger command for the bind. Leave blank if neceesary. '!' = alt, '^' = ctrl
-- me, targ and selecttarget are all targetting types. shouldn't need to modify those
-- If you want different binds for different abilities (IE you don't want everything  1-9 with ALT / CTRL then go into EACH macro[] below and modify the number (what actually gets bound) and the numbertext(What the UI sees)
	macroassign= '!'	
	macrotext= 'Alt: '
-- This is setting the binds that are entered throughout the table. Currently they represent 1-9 but you can change them to whatever and they will bind to those values on the sheet. This is for highly custom Binds
-- If you just want your microbinds to all of one type (Ctrl / Alt) then just edit the two values above and that will automatically apply them. 
----------------------------------------------------
	macroassign1 = macroassign..'1'
	macrotext1 = macrotext..'1'
	macroassign2 = macroassign..'2'
	macrotext2 = macrotext..'2'
	macroassign3 = macroassign..'3'
	macrotext3 = macrotext..'3'
	macroassign4 = macroassign..'4'
	macrotext4 = macrotext..'4'
	macroassign5 = macroassign..'5'
	macrotext5 = macrotext..'5'
	macroassign6 = macroassign..'6'
	macrotext6 = macrotext..'6'
	macroassign7 = macroassign..'7'
	macrotext7 = macrotext..'7'
	macroassign8 = macroassign..'8'
	macrotext8 = macrotext..'8'
	macroassign9 = macroassign..'9'
	macrotext9 = macrotext..'9'	
----------------------------------------------------	
	me = '<me>'
	targ = '<t>'
	selecttarget = '<stpc>'
----------------------------------------------------

	macros= {}
	current_macros = {}
	--[[
	Table functions: 
	First Row is used to determine table headers
	hide if true will not bind the keys listed 
	bloodpact sets the string value displayed in the UI.
	name will not only reflect the name in the UI but also what ability to bind
	number determines what bind key is used when building
	numbertext determines what the UI displays
	target indicates how the bind will select targetting
	text is used to display help text in the UI
	Mana is used to set a mana cost for each ability. This is used in the UI and used to determine when to autoconvert. Keep as an Integer
	colorofmana determines text color based on conditions. spcolor for SP abilitys, meritbpcolor for merit abilitys, manacolor for entries with mana listed
	]]
	macros['None'] = {
		{hide=true, bloodpact= '',name = '', number = macroassign..'`', numbertext = 'Keybind', target = me, text = '', Mana = 'Mana', finalmana = 'Mana'},
		{hide=true, bloodpact= 'Summon',name = 'Carbuncle', number = carbuncleBind, numbertext = carbuncleText, target = me, Mana = 5, colorofmana = manacolor, finalmana = 5},
		{hide=true, bloodpact= 'Summon',name = 'Fenrir', number = fenrirBind, numbertext = fenrirText, target = me, Mana = 15, colorofmana = manacolor, finalmana = 15},
		{hide=true, bloodpact= 'Summon',name = 'Ifrit', number = ifritBind, numbertext = ifritText, target = me, Mana = 7, colorofmana = manacolor, finalmana = 7},
		{hide=true, bloodpact= 'Summon',name = 'Titan', number = titanBind, numbertext = titanText, target = me, Mana = 7, colorofmana = manacolor, finalmana = 7},
		{hide=true, bloodpact= 'Summon',name = 'Leviathan', number = leviathanBind, numbertext = leviathanText, target = me, Mana = 7, colorofmana = manacolor, finalmana = 7},
		{hide=true, bloodpact= 'Summon',name = 'Garuda', number = garudaBind, numbertext = garudaText, target = me, Mana = 7, colorofmana = manacolor, finalmana = 7},
		{hide=true, bloodpact= 'Summon',name = 'Shiva', number = shivaBind, numbertext = shivaText, target = me, Mana = 7, colorofmana = manacolor, finalmana = 7},
		{hide=true, bloodpact= 'Summon',name = 'Ramuh', number = ramuhBind, numbertext = ramuhText, target = me,  Mana = 7, colorofmana = manacolor, finalmana = 7},
		{hide=true, bloodpact= 'Summon',name = 'Diabolos', number = diabolosBind, numbertext = diabolosText, target = me,  Mana = 15, colorofmana = manacolor, finalmana = 15},
		{hide=true, bloodpact= 'Summon',name = 'Cait Sith', number = caitsithBind, numbertext = caitsithText, target = me, Mana = 5, colorofmana = manacolor, finalmana = 15},
		{hide=true, bloodpact= 'Summon',name = 'Atomos', number = atomosBind, numbertext = atomosText, target = targ, text = 'Dispel / Buff', Mana = 50, colorofmana = manacolor, finalmana = 50},
		{hide=true, bloodpact= 'Summon',name = 'Alexander', number = alexanderBind, numbertext = alexanderText, target = me, text = 'Requires Astral Flow -- High DT and Status Immunity', Mana = 'All', colorofmana = spcolor, finalmana = 'All'},
		{hide=true, bloodpact= 'Summon',name = 'Odin', number = odinBind, numbertext = odinText, target = me, text = ' Requires Astral Flow -- Chance to Instantly Kill ', Mana = 'All', colorofmana = spcolor, finalmana = 'All'},

}
	macros['Cait Sith'] = {
		{hide=true, bloodpact= 'Bloodpact',name = 'Ability', number = macroassign..'`', numbertext = 'Keybind', target = me, text = 'Help Text', Mana = 'Mana Cost', colorofmana ='', finalmana = 'Mana Cost'},
		{bloodpact= 'Rage',name = 'Regal Scratch', number = macroassign1, numbertext = macrotext1, target = targ, Mana = 5, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Regal Gash', number = macroassign2, numbertext = macrotext2, target = targ, Mana = 118, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Level ? Holy', number = macroassign3, numbertext = macrotext3, target = targ, Mana = 235, text = 'Deals damage randomly', colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Mewing Lullaby', number = macroassign4, numbertext = macrotext4, target = targ, text = 'AoE Sleep and TP reset', Mana = 61, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Eerie Eye', number = macroassign5, numbertext = macrotext5, target = targ, text = 'Conal Silence and Amnesia', Mana = 134, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Raise II', number = macroassign6, numbertext = macrotext6, target = targ, Mana = 160, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Reraise II', number = macroassign7, numbertext = macrotext7, target = targ, Mana = 80, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Reraise II', number = macroassign8, numbertext = macrotext8, target = me, text = 'Targets Self', Mana = 80, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Altana\'s Favor', number = macroassign9, numbertext = macrotext9, target = me, text = 'SP Ability: AoE Arise and Reraise III', Mana = 198, colorofmana = spcolor, finalmana = 198}

}
	macros['Carbuncle'] = {
		{hide=true, bloodpact= 'Bloodpact',name = 'Ability', number = macroassign..'`', numbertext = 'Keybind', target = me, text = 'Help Text', Mana = 'Mana Cost', finalmana = 'Mana Cost'},
		{bloodpact= 'Rage', name = 'Meteorite', number = macroassign1, numbertext = macrotext1, target = targ, Mana = 108, colorofmana = manacolor, finalmana = manavalue, finalmana = manavalue},
		{bloodpact= 'Rage', name = 'Holy Mist', number = macroassign2, numbertext = macrotext2, target = targ, Mana = 152, colorofmana = manacolor, finalmana = manavalue, finalmana = manavalue},
		{bloodpact= 'Ward', name = 'Healing Ruby', number = macroassign3, numbertext = macrotext3, target = targ, text='Single Target', Mana = 6, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward', name = 'Healing Ruby II', number = macroassign4, numbertext = macrotext4, target = me, text='AoE', Mana = 124, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward', name = 'Pacifying Ruby', number = macroassign5,numbertext = macrotext5, target = targ, text='Decreases Enmity by 25%',  Mana = 83, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward', name = 'Shining Ruby', number = macroassign6, numbertext = macrotext6, target = me, text= 'Protect||Shell', Mana = 44, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward', name = 'Glittering Ruby', number = macroassign7,  numbertext = macrotext7, target = me, text= 'Random Attributes', Mana = 62, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward', name = 'Soothing Ruby', number = macroassign8, numbertext = macrotext8, target = me, text = 'AoE Esuna', Mana = 74, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage', name = 'Searing Light', number = macroassign9, numbertext = macrotext9, target = targ,  text = 'SP Ability', Mana = 198, colorofmana = spcolor, finalmana = 198}

}
	macros['Fenrir'] = {
		{hide=true, bloodpact= 'Bloodpact',name = 'Ability', number = macroassign1, numbertext = 'Keybind', target = me, text = 'Help Text', Mana = 'Mana Cost', finalmana = 'Mana Cost'},
		{bloodpact= 'Rage', name = 'Impact', number = macroassign1, numbertext = macrotext1, target = targ,  text= 'Multiple Attribute down', Mana = 222, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage', name = 'Moonlit Charge', number = macroassign2, numbertext = macrotext2, target = targ, text='Blind', Mana =  17, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage', name = 'Eclipse Bite', number = macroassign3, numbertext = macrotext3, target = targ, Mana = 109, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward', name = 'Lunar Cry', number = macroassign4, numbertext = macrotext4, target = targ, text=function() return avatar_phases('Lunar Cry') end, Mana = 41, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward', name = 'Lunar Roar', number = macroassign5, numbertext = macrotext5, target = targ, text='AoE Dispel II', Mana = 27, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward', name = 'Ecliptic Growl', number = macroassign6, numbertext = macrotext6, target = me, text= function() return avatar_phases('Ecliptic Growl') end, Mana = 46, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward', name = 'Ecliptic Howl', number = macroassign7, numbertext = macrotext7, target = me, text= function() return avatar_phases('Ecliptic Howl') end, Mana = 57, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward', name = 'Heavenward Howl', number = macroassign8, numbertext = macrotext8, target = me, text= function() return avatar_phases('Heavenward Howl') end, Mana = 96, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage', name = 'Howling Moon', number = macroassign9, numbertext = macrotext9, target = targ, text = 'SP Ability', Mana = 198, colorofmana = spcolor, finalmana = 198}

}
	macros['Ifrit'] = {
		{hide=true, bloodpact= 'Bloodpact',name = 'Ability', number = macroassign1, numbertext = 'Keybind', target = me, text = 'Help Text', Mana = 'Mana Cost', finalmana = 'Mana Cost'},
		{bloodpact= 'Rage',name = 'Fire IV', number = macroassign1, numbertext = macrotext1, target = targ, Mana = 118, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Conflag Strike', number = macroassign2, numbertext = macrotext2, target = targ, text='Int -63', Mana = 141, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Meteor Strike', number = macroassign3, numbertext = macrotext3, target = targ,text = merits['Meteor Strike'] > 0 and ((merits['Meteor Strike']-1)*400)..' TP Bonus' or 'Not Merited', Mana = 182, colorofmana = meritbpcolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Flaming Crush', number = macroassign4, numbertext = macrotext4, target = targ, Mana = 164, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Crimson Howl', number = macroassign5, numbertext = macrotext5, target = me, text='11% Attack Boost', Mana = 84, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Inferno Howl', number = macroassign6,  numbertext = macrotext6, target = me, text= 'Enfire', Mana = 72, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= '',name = '', number = macroassign7, numbertext = macrotext7, target = targ, hide=true, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= '',name = '', number = macroassign8, numbertext = macrotext8, target = me, text = '', hide=true, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Inferno', number = macroassign9, numbertext = macrotext9, target = targ, text = 'SP Ability', Mana = 198, colorofmana = spcolor, finalmana = 198}

}
	macros['Titan'] = {
		{hide=true, bloodpact= 'Bloodpact',name = 'Ability', number = macroassign..'`', numbertext = 'Keybind', target = me, text = 'Help Text', Mana = 'Mana Cost', finalmana = 'Mana Cost'},
		{bloodpact= 'Rage',name = 'Stone IV', number = macroassign..'1', numbertext = macrotext1, target = targ, Mana = 118, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Crag Throw', number = macroassign2, numbertext = macrotext2, target = targ, text='30% Slow', Mana = 124, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Geocrush', number = macroassign3, numbertext = macrotext3, target = targ,text = merits['Geocrush'] > 0 and ((merits['Geocrush']-1)*400)..' TP Bonus' or 'Not Merited', Mana = 182, colorofmana = meritbpcolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Mountain Buster', number = macroassign4, numbertext = macrotext4, target = targ, Mana = 164, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Rock Buster', number = macroassign5, numbertext = macrotext5, target = targ, text='Bind', Mana = 39, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Earthen Ward', number = macroassign6, numbertext = macrotext6, target = me, text= 'Stoneskin', Mana = 92, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Earthen Armor', number = macroassign7, numbertext = macrotext7, target = me, text='Reduces Massive Damage by 45%', Mana = 156, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= '',name = '', number = macroassign8, numbertext = macrotext8, target = me, text = '', hide=true, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Earthen Fury', number = macroassign9, numbertext = macrotext9, target = targ, text = 'SP Ability', Mana = 198, colorofmana = spcolor, finalmana = manavalue}
	
}
	macros['Leviathan'] = {
		{hide=true, bloodpact= 'Bloodpact',name = 'Ability', number = macroassign..'`', numbertext = 'Keybind', target = me, text = 'Help Text', Mana = 'Mana Cost', finalmana = 'Mana Cost'},
		{bloodpact= 'Rage',name = 'Water IV', number = macroassign1, numbertext = macrotext1, target = targ, Mana = 118, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Water II', number = macroassign2, numbertext = macrotext2, target = targ, Mana = 24, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Grand Fall', number = macroassign3, numbertext = macrotext3, target = targ,text = merits['Grand Fall'] > 0 and ((merits['Grand Fall']-1)*400)..' TP Bonus' or 'Not Merited', Mana = 182, colorofmana = meritbpcolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Spinning Dive', number = macroassign4, numbertext = macrotext4, target = targ, Mana = 164, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Spring Water', number = macroassign5, numbertext = macrotext5, target = me, text='AoE Heal', Mana = 99, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Soothing Current', number = macroassign6, numbertext = macrotext6, target = me, text= '+15% Cure Potency Received', Mana = 95, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Tidal Roar', number = macroassign7, numbertext = macrotext7, target = targ, text='-25% Attack', Mana = 138, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Slowga', number = macroassign8, numbertext = macrotext8, target = targ, text = '30% AoE Slow', Mana = 48, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Tidal Wave', number = macroassign9, numbertext = macrotext9, target = targ, text = 'SP Ability', Mana = 198, colorofmana = spcolor, finalmana = 198}

}
	macros['Garuda'] = {
		{hide=true, bloodpact= 'Bloodpact',name = 'Ability', number = macroassign..'`', numbertext = 'Keybind', target = me, text = 'Help Text', Mana = 'Mana Cost', finalmana = 'Mana Cost'},
		{bloodpact= 'Rage',name = 'Aero IV', number = macroassign1, numbertext = macrotext1, target = targ, Mana = 118, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Aero II', number = macroassign2, numbertext = macrotext2, target = targ, Mana = 24, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Wind Blade', number = macroassign3, numbertext = macrotext3, target = targ, text = merits['Wind Blade'] > 0 and ((merits['Wind Blade']-1)*400)..' TP Bonus' or 'Not Merited', Mana = 182, colorofmana = meritbpcolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Predator Claws', number = macroassign4, numbertext = macrotext4, target = targ, Mana = 164, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Whispering Wind', number = macroassign5, numbertext = macrotext5, target = me, text='AoE Heal', Mana = 119, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Hastega II', number = macroassign6, numbertext = macrotext6, target = me, text= '30% Haste', Mana = 248, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Aerial Armor', number = macroassign7, numbertext = macrotext7, target = me, text='Blink', Mana = 92, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Fleet Wind', number = macroassign8, numbertext = macrotext8, target = me, text = '20% Movement Speed', Mana = 114, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Aerial Blast', number = macroassign9, numbertext = macrotext9, target = targ, text = 'SP Ability', Mana = 198, colorofmana = spcolor, finalmana = 198}

}
	macros['Shiva'] = {
		{hide=true, bloodpact= 'Bloodpact',name = 'Ability', number = macroassign..'`', numbertext = 'Keybind', target = me, text = 'Help Text', Mana = 'Mana Cost', finalmana = 'Mana Cost'},
		{bloodpact= 'Rage',name = 'Blizzard IV', number = macroassign1, numbertext = macrotext1, target = targ, Mana = 118, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Blizzard II', number = macroassign2, numbertext = macrotext2, target = targ, Mana = 24, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Heavenly Strike', number = macroassign3, numbertext = macrotext3, target = targ, text = merits['Heavenly Strike'] > 0 and ((merits['Heavenly Strike']-1)*400)..' TP Bonus' or 'Not Merited', Mana = 182, colorofmana = meritbpcolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Rush', number = macroassign4, numbertext = macrotext4, target = targ, Mana = 164, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Crystal Blessing', number = macroassign5, numbertext = macrotext5, target = me, text='250 TP Bonus Buff', Mana = 201, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Frost Armor', number = macroassign6, numbertext = macrotext6, target = me, text= 'Ice Spikes', Mana = 63, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Diamond Storm', number = macroassign7, numbertext = macrotext7, target = targ, text='-25 Evasion', Mana = 138, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Sleepga', number = macroassign8, numbertext = macrotext8, target = targ, text='AoE Sleep', Mana = 54, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Diamond Dust', number = macroassign9, numbertext = macrotext9, target = targ, text = 'SP Ability', Mana = 198, colorofmana = spcolor, finalmana = 198}

}
	macros['Ramuh'] = {
		{hide=true, bloodpact= 'Bloodpact',name = 'Ability', number = macroassign..'`', numbertext = 'Keybind', target = me, text = 'Help Text', Mana = 'Mana Cost', finalmana = 'Mana Cost'},
		{bloodpact= 'Rage',name = 'Thunder IV', number = macroassign1, numbertext = macrotext1, target = targ, Mana = 118, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Thunderspark', number = macroassign2, numbertext = macrotext2, target = targ, text='AoE Paralyze', Mana = 38, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Thunderstorm', number = macroassign3, numbertext = macrotext3, target = targ, Mana = 182, text = merits['Thunderstorm'] > 0 and ((merits['Thunderstorm']-1)*400)..' TP Bonus' or 'Not Merited', colorofmana = meritbpcolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Volt Strike', number = macroassign4, numbertext = macrotext4, target = targ, Mana = 229, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Shock Squall', number = macroassign5, numbertext = macrotext5, target = targ, text='AoE Stun', Mana = 67, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Lightning Armor', number = macroassign6, numbertext = macrotext6, target = me, text= 'Shock Spikes', Mana = 91, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Rolling Thunder', number = macroassign7, numbertext = macrotext7, target = me, text='Enthunder', Mana = 52, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= '',name = '', number = macroassign8, numbertext = macrotext8, target = me, text = '', hide=true, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Judgment Bolt', number = macroassign9, numbertext = macrotext9, target = targ, text = 'SP Ability', Mana = 198, colorofmana = spcolor, finalmana = 198}

}
	macros['Diabolos'] = {
		{hide=true,bloodpact= 'Bloodpact',name = 'Ability', number = macroassign..'`', numbertext = 'Keybind', target = me, text = 'Help Text', Mana = 'Mana Cost', finalmana = 'Mana Cost'},
		{bloodpact= 'Rage',name = 'Night Terror', number = macroassign1, numbertext = macrotext1, target = targ, Mana = 177, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Blindside', number = macroassign2, numbertext = macrotext2, target = targ, Mana = 147, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Ultimate Terror', number = macroassign3, numbertext = macrotext3, target = targ, text='Reduced all Attributes', Mana = 27, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Somnolence', number = macroassign4, numbertext = macrotext4, target = targ, text= 'Gravity', Mana =  30, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Pavor Nocturnus', number = macroassign5, numbertext = macrotext5, target = targ, text='Death or Dispel', Mana = 246, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Nightmare', number = macroassign6, numbertext = macrotext6, target = targ, text= 'AoE Sleep and DoT', Mana = 42, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Dream Shroud', number = macroassign7, numbertext = macrotext7, target = me, text= function() return avatar_phases('Dream Shroud') end, Mana = 121, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Ward',name = 'Noctoshield', number = macroassign8, numbertext = macrotext8, target = me, text = '13 Damage Reduction', Mana = 92, colorofmana = manacolor, finalmana = manavalue},
		{bloodpact= 'Rage',name = 'Ruinous Omen', number = macroassign9, numbertext = macrotext9, target = targ, text = 'SP Ability -- % Based damage', Mana = 198, colorofmana = spcolor, finalmana = 198}

}
	current_macros = macros[petname()] -- Sets macro binds to current pet on function load
	
	------ The following tables are used to determine favor tiers. No customization really needed here unless you want to fill out unknown values for each tier -----
	favortiers = {
	{skill = 316, tier = 1},
	{skill = 381, tier = 2},
	{skill = 446, tier = 3},
	{skill = 511, tier = 4},
	{skill = 574, tier = 5},
	{skill = 669, tier = 6},
	{skill = 1000, tier = 7},
	}	
	favorvalues = {}
	favorvalues['Carbuncle'] = {
		{Name = 'Regen', value = '12 / tick'},
		{Name = 'Regen', value = '14 / tick'},
		{Name = 'Regen', value = '16/ tick'},
		{Name = 'Regen', value = '18/ tick'},
		{Name = 'Regen', value = '20/ tick'},
		{Name = 'Regen', value = '21/ tick'},
		{Name = 'Regen', value = '24/ tick'},
		{Name = 'Regen', value = '26/ tick'},
		{Name = 'Regen', value = '27/ tick'},
		{Name = 'Regen', value = '28/ tick'},
		{Name = 'Regen', value = '29/ tick'},
	}
	favorvalues['Cait Sith'] = {
		{Name = 'Magic Defense Bonus', value = ''},
		{Name = 'Magic Defense Bonus', value = ''},
		{Name = 'Magic Defense Bonus', value = ''},
		{Name = 'Magic Defense Bonus', value = ''},
		{Name = 'Magic Defense Bonus', value = ''},
		{Name = 'Magic Defense Bonus', value = ''},
		{Name = 'Magic Defense Bonus', value = '24'},
		{Name = 'Magic Defense Bonus', value = '26'},
		{Name = 'Magic Defense Bonus', value = '27'},
		{Name = 'Magic Defense Bonus', value = '28'},
		{Name = 'Magic Defense Bonus', value = '29'},
	}
	favorvalues['Ifrit'] = {
		{Name = 'Double Attack Rate', value = '12%'},
		{Name = 'Double Attack Rate', value = '12~22%'},
		{Name = 'Double Attack Rate', value = '12~22%'},
		{Name = 'Double Attack Rate', value = '12~22%'},
		{Name = 'Double Attack Rate', value = '12~22%'},
		{Name = 'Double Attack Rate', value = '23%'},
		{Name = 'Double Attack Rate', value = '23%'},
		{Name = 'Double Attack Rate', value = '24%'},
		{Name = 'Double Attack Rate', value = '24%'},
		{Name = 'Double Attack Rate', value = '25%'},
		{Name = 'Double Attack Rate', value = '26%'},
	}
	favorvalues['Shiva'] = {
		{Name = 'Magic Attack Bonus', value = '15'},
		{Name = 'Magic Attack Bonus', value = '18'},
		{Name = 'Magic Attack Bonus', value = '21'},
		{Name = 'Magic Attack Bonus', value = '24'},
		{Name = 'Magic Attack Bonus', value = '27'},
		{Name = 'Magic Attack Bonus', value = '30'},
		{Name = 'Magic Attack Bonus', value = '33'},
		{Name = 'Magic Attack Bonus', value = '36'},
		{Name = 'Magic Attack Bonus', value = '39'},
		{Name = 'Magic Attack Bonus', value = '42'},
		{Name = 'Magic Attack Bonus', value = '45'},
	}
	favorvalues['Garuda'] = {
		{Name = 'Evasion', value = ''},
		{Name = 'Evasion', value = ''},
		{Name = 'Evasion', value = ''},
		{Name = 'Evasion', value = '22'},
		{Name = 'Evasion', value = '25'},
		{Name = 'Evasion', value = '28'},
		{Name = 'Evasion', value = '31'},
		{Name = 'Evasion', value = '34'},
		{Name = 'Evasion', value = '37'},
		{Name = 'Evasion', value = '40'},
		{Name = 'Evasion', value = '43'},
	}
	favorvalues['Titan'] = {
		{Name = 'Defense', value = '57'},
		{Name = 'Defense', value = '62'},
		{Name = 'Defense', value = '67'},
		{Name = 'Defense', value = '72'},
		{Name = 'Defense', value = '77'},
		{Name = 'Defense', value = '82'},
		{Name = 'Defense', value = '87'},
		{Name = 'Defense', value = '92'},
		{Name = 'Defense', value = '97'},
		{Name = 'Defense', value = '102'},
		{Name = 'Defense', value = '107'},
	}
	favorvalues['Ramuh'] = {
		{Name = 'Critical Hit Rate', value = '12%'},
		{Name = 'Critical Hit Rate', value = '12~17%'},
		{Name = 'Critical Hit Rate', value = '12~17%'},
		{Name = 'Critical Hit Rate', value = '18%'},
		{Name = 'Critical Hit Rate', value = '19%'},
		{Name = 'Critical Hit Rate', value = '21%'},
		{Name = 'Critical Hit Rate', value = '21%'},
		{Name = 'Critical Hit Rate', value = '23%'},
		{Name = 'Critical Hit Rate', value = '23%'},
		{Name = 'Critical Hit Rate', value = '24%'},
		{Name = 'Critical Hit Rate', value = '24%'},
	}
	favorvalues['Leviathan'] = {
		{Name = 'Magic Accuracy', value = ''},
		{Name = 'Magic Accuracy', value = ''},
		{Name = 'Magic Accuracy', value = ''},
		{Name = 'Magic Accuracy', value = ''},
		{Name = 'Magic Accuracy', value = ''},
		{Name = 'Magic Accuracy', value = ''},
		{Name = 'Magic Accuracy', value = ''},
		{Name = 'Magic Accuracy', value = ''},
		{Name = 'Magic Accuracy', value = ''},
		{Name = 'Magic Accuracy', value = ''},
		{Name = 'Magic Accuracy', value = ''},
	}
	favorvalues['Fenrir'] = {
		{Name = 'Magic Evasion', value = ''},
		{Name = 'Magic Evasion', value = ''},
		{Name = 'Magic Evasion', value = ''},
		{Name = 'Magic Evasion', value = ''},
		{Name = 'Magic Evasion', value = ''},
		{Name = 'Magic Evasion', value = ''},
		{Name = 'Magic Evasion', value = ''},
		{Name = 'Magic Evasion', value = ''},
		{Name = 'Magic Evasion', value = ''},
		{Name = 'Magic Evasion', value = ''},
		{Name = 'Magic Evasion', value = ''},
	}
	favorvalues['Diabolos'] = {
		{Name = 'Refresh', value = '3 / tick'},
		{Name = 'Refresh', value = '4 / tick'},
		{Name = 'Refresh', value = '4 / tick'},
		{Name = 'Refresh', value = '5 / tick'},
		{Name = 'Refresh', value = '5 / tick'},
		{Name = 'Refresh', value = '5 / tick'},
		{Name = 'Refresh', value = '6 / tick'},
		{Name = 'Refresh', value = '7 / tick'},
		{Name = 'Refresh', value = '7 / tick'},
		{Name = 'Refresh', value = '8 / tick'},
		{Name = 'Refresh', value = '8 / tick'},
	}
	favorgear = {
	{name = 'Beckoner\'s Horn +1', value = '3'},
	{name = 'Beckoner\'s Horn', value = '2'},
	{name = 'Caller\'s Horn +2', value = '2'},
	{name = 'Caller\'s Horn +1', value = '1'},
	}
return

end
--Fires off if you gain or lose a pet. Unbinds and rebinding of keys happens here
function pet_change(pet,gain)
    update_gear()
	pet_update()
	if BindMacros then	
		if not gain then
			unbind_keybinds(pet and macros[pet.name] and pet.name or 'None')
			build_keybinds('None')
			if not NoHud then 
				macrohud._track._var = macros['None'] 
			end
		elseif macros[petname()] then
			build_keybinds(pet and macros[pet.name] and pet.name or 'None')
			if not NoHud then 
				macrohud._track._var = macros[petname()] 
			end 			
		end
	end
end
	
function pretarget(spell,action)

	if not buffactive['Muddle'] then
		inventory = player.inventory
		--Auto Echo Drops if Silenced
		if AutoEcho and spell.action_type == 'Magic' and buffactive['Silence'] and inventory['Echo Drops'] then
			cancel_spell()
			send_command('input /item "Echo Drops" <me>')
		--Auto Remedy if Paralyzed
		elseif AutoRemedy and (spell.action_type == 'Magic' or spell.type == 'JobAbility') and buffactive['Paralyze'] and inventory['Remedy'] then
			cancel_spell()
			send_command('input /item "Remedy" <me>')
		end
	end
-- Autoconvert logic
	if player.sub_job == 'RDM' then -- Verifys you have the appropriate sub
		local abil_recasts = windower.ffxi.get_ability_recasts() --Collect recast date
		if atconvert.value and pet and macros[petname()] and pet.isvalid and (buffactive['Astral Conduit'] or Convertall) and abil_recasts[49] == 0 then -- Verifies that Convert is up and all other conditions are met
			spellrow = verifyAbility(macros[pet.name],spell.name) --Figures out where in the macro table this spell exists
			if (spellrow and macros[pet.name][spellrow].Mana > player.mp) or (buffactive['Apogee'] and Convertall and spellrow and macros[pet.name][spellrow].Mana*1.5 > player.mp) then --Converts if spell MP is great than Player mana
				cancel_spell()
				send_command('input /ja "Convert" <me>')
			end
		end
	end
			
end
-- Handles Spell precast
function precast(spell)
    if pet_midaction() or spell.type=="Item" then
		return
	end
	-- Spell fast cast
    if spell.action_type=="Magic" then
		if spell.name=="Stoneskin" then
			equip(sets.precast.FC,{waist="Siegel Sash"})
		else
			equip(sets.precast.FC)
		end
    end
end
-- Handles Spell midcast
function midcast(spell)
    if pet_midaction() or spell.type=="Item" then
        return
    end
	-- BP Timer gear needs to swap here
	if (spell.type=="BloodPactWard" or spell.type=="BloodPactRage") then
		if not buffactive["Astral Conduit"] then --Skips midcast BP set (Precast) if Astral COnduit is up
			equip(sets.midcast.BP)
		end
		-- If lag comp`ensation mode is on, set up a timer to equip the BP gear.
		if LagMode.value then
			send_command('wait 0.5;gs c EquipBP '..spell.name)
		end
	-- Spell Midcast & Potency Stuff
    elseif sets.midcast[spell.english] then
        equip(sets.midcast[spell.english])
	elseif spell.name=="Elemental Siphon" then 
		if pet.element=="Light" or pet.element=="Dark" then
			equip(sets.midcast.Siphon)
		else
			equip(sets.midcast.SiphonZodiac)
		end
	elseif spell.type=="SummonerPact" then
		equip(sets.midcast.Summon)
	elseif spell.type=="WhiteMagic" then
		if string.find(spell.name,"Cure") or string.find(spell.name,"Curaga") then
			equip(sets.midcast.Cure)
		elseif string.find(spell.name,"Protect") or string.find(spell.name,"Shell") then
			equip(sets.midcast.Enhancing,{ring2="Sheltered Ring"})
		elseif spell.skill=="Enfeebling Magic" then
			equip(sets.midcast.Enfeeble)
		elseif spell.skill=="Enhancing Magic" then
			equip(sets.midcast.Enhancing)
		else
			update_gear()
		end
	elseif spell.type=="BlackMagic" then
		if spell.skill=="Elemental Magic" then
			equip(sets.midcast.Nuke)
		end
	elseif spell.action_type=="Magic" then
		equip(sets.midcast.EnmityRecast)
    else
        update_gear()
    end
	-- Auto-cancel existing buffs
	if spell.name=="Stoneskin" and buffactive["Stoneskin"] then
		windower.send_command('cancel 37;')
	elseif spell.name=="Sneak" and buffactive["Sneak"] and spell.target.type=="SELF" then
		windower.send_command('cancel 71;')
	elseif spell.name=="Utsusemi: Ichi" and buffactive["Copy Image"] then
		windower.send_command('wait 1;cancel 66;')
	end
end
--Handles spell aftercast
function aftercast(spell)
    if pet_midaction() or spell.type=="Item" then
        return
    end
	if not string.find(spell.type,"BloodPact") then
        update_gear()
    end
	if spell.interrupted and summons:contains(spell.name:lower()) then
		pet_update()
	end
	
	
end

function status_change(new,old)
       update_gear()
end
-- Check for buff gained or lost
function buff_change(name,gain)
	--Auto applies favor here if it falls off. Also sets the value of the Favor String for the UI
		if name=='Avatar\'s Favor' and gain then
			Favor= "On"
		elseif name=='Avatar\'s Favor' then
			local abil_recasts = windower.ffxi.get_ability_recasts() --Collect recast date
			Favor= "Off"
			if pet.isvalid and Autofavor and abil_recasts[176] == 0 and not NonValidFavor[pet.name] then
			send_command('input /ja "Avatar\'s Favor" <me>')
		end
	end
	
end
-- Handles events during a blood pact
function pet_midcast(spell)
	if not LagMode.value then
		equipBPGear(spell.name)
	end

end
--Handles Events after a Bloodpact
function pet_aftercast(spell)
		if not buffactive["Astral Conduit"] then
			update_gear()
		end
		if atconvert.value and buffactive["Astral Conduit"] and player.mp < 229  then
			send_command('input /ja "Convert" <me>')
	end
end

--Handles BP equip swap
function equipBPGear(spell)
    equipSet = sets.pet_midcast
    if equipSet[spell] then
        equipSet = equipSet[spell]
    elseif Debuff_BPs:contains(spell) then
        equipSet = equipSet.MagicAcc_BP
    elseif Buff_BPs_Healing:contains(spell) then
        equipSet = equipSet.Buff_Healing
    elseif Buff_BPs_Duration:contains(spell) then
        equipSet = equipSet.Buff
    elseif Magic_BPs_TP:contains(spell) or string.find(spell,' II') or string.find(spell,' IV') then
		equipSet = equipSet.Magic_BP
		if pet_tp > 2500 then
			equipSet = equipSet.NoTP -- sets.pet_midcast.Magic_BP.NoTP
        else
            equipSet = equipSet.TP
        end			
	elseif Magic_BPs_NoTP:contains(spell) then
		equipSet = equipSet.Magic_BP.NoTP	
    elseif Merit_BPs:contains(spell) then
        equipSet = equipSet.Magic_BP
        if merits[spell] and (merits[spell]-1)*400 + pet_tp > 1500 then
			print((merits[spell]-1)*400 + pet_tp)
            equipSet = equipSet.NoTP -- sets.pet_midcast.Magic_BP.NoTP
        else
			print((merits[spell]-1)*400 + pet_tp)
            equipSet = equipSet.TP
        end
    elseif Debuff_Rage_BPs:contains(spell) then
        equipSet = sets.pet_midcast.Debuff_Rage
    else
        equipSet = equipSet.Physical_BP
        if Physical_BPs_TP:contains(spell) then
            equipSet = equipSet.TP
        end
    end
    if buffactive["Aftermath: Lv.3"] and equipSet[AM3] then
        equipSet = equipSet.AM3
    end
    if equipSet[AccMode.value] then
        equipSet = equipSet[AccMode.value]
    else
        if AccMode.index > 1 then
            for i=AccMode.index, 1, -1 do
                if equipSet[AccMode[i]] then
                    equipSet = equipSet[AccMode[i]]
                    break
                end
            end
        end
    end
    equip(equipSet)
end

-- This command is called whenever you input "gs c <command>". SMN release and summon commands created by Verda
function self_command(cmdParams)
	local cmdParams = cmdParams
    if type(cmdParams) == 'string' then
        cmdParams = T(cmdParams:split(' '))
        if #cmdParams == 0 then
            return
        end
    end
    command = cmdParams[1]
	IdleModeCommands = {'DD','Refresh','DT','Favor','PetDT', 'Pet Haste'}
	is_valid = false

	for _, v in ipairs(IdleModeCommands) do --Handles Idle mode swap
		if command:lower()==v:lower() then
			IdleMode:set(v)
			send_command('input /echo "Idle Mode: ['..IdleMode.value..']"')
			update_gear()
			return
		end
	end
	if string.sub(command,1,7)=="EquipBP" then
		table.remove(cmdParams, 1)
		local BP = table.concat(cmdParams," ")
		equipBPGear(BP)
		return
	elseif command:lower()=="accmode" then
		AccMode = AccMode==false
		is_valid = true
		send_command('console_echo "AccMode: '..tostring(AccMode)..'"')
		elseif command:lower()=="siphon" then
        handle_siphoning()
		is_valid = true
	elseif cmdParams[1] == 'release' then
		is_valid = true
		send_command('input /pet "Release" <me>')
	elseif command:lower()=='refreshui' then
		refreshrepair()
	elseif command:lower()=='autoconvert' then
		is_valid = true
		if atconvert.value then
			send_command('input /echo "Auto Convert On"') 
		else
			send_command('input /echo "Auto Convert Off"')
		end
	elseif command:lower()=='pos' then --Command to reposition UI eg gs c pos 1200 800
		Xpos = cmdParams[2]
		Ypos = cmdParams[3]
		refreshrepair()
	elseif command:lower()=='accupdate' then
		is_valid = true
		send_command('input /echo Accuracy Mode set to '..AccMode.value)
	elseif command:lower()=='lagmode' then
		is_valid = true
		send_command('input /echo Lag Mode set to '..tostring(LagMode.value))
	elseif command:lower()=='engagedupdate' then
		is_valid = true
		send_command('input /echo Engaged Mode set to '..engagedMode.value)
	elseif command:lower() == 'smn' then -- Summoning command. Will unsummon current pet to summon new one
		tosummon = cmdParams[2]
		is_valid = true
		smntarget = "<me>"
		if tosummon=='atomos' then 
			atomosrun()
		elseif tosummon=='odin' or tosummon=='alexander' then
			spavatar(tosummon)
		else
			if cmdParams[3]=='sith' then tosummon='cait sith' end
			if tosummon == 'lightspirit' then tosummon='light spirit' end
			if pet.isvalid and pet.name:lower()== tosummon then
				add_to_chat(122,cmdParams[2].." is already summoned!")
			elseif pet.isvalid  and tosummon=='blank' then
				windower.send_command('input /ja Release <me>') 
			elseif pet.isvalid then
				windower.send_command('input /ja Release <me>;wait 2;input /ma '..tosummon..' '..smntarget)
			else  
				windower.send_command('input /ma '..tosummon..' '..smntarget)
			end
		end
	elseif command:lower()=="meleemode" then
		if cmdParams[2] then	
			if T{'lock', 'on', 'true'}:contains(cmdParams[2]:lower()) then
				MeleeMode = true
				equip(sets.nirvanal)
				disable("main","sub")
				send_command('input /echo "Nirvana Locked"')
			elseif T{'unlock', 'off', 'false'}:contains(cmdParams[2]:lower()) then
				MeleeMode = false
				enable("main","sub")
				send_command('input /echo "Nirvana Unlocked"')
			end
			
		else
			if MeleeMode then
				MeleeMode = false
				enable("main","sub")
				send_command('input /echo "Nirvana Unlocked"')
			else
				MeleeMode = true
				equip({main="Nirvana",sub="Elan Strap"})
				disable("main","sub")
				send_command('input /echo "Nirvana Locked"')
			end
			
		end
		is_valid = true
	elseif command=="ToggleIdle" then
		is_valid = true
		IdleMode:cycle()
		send_command('console_echo "Idle Mode: ['..IdleMode.value..']"')
	elseif command:lower()=="lowhp" then
		-- Use for "Cure 500 HP" objectives in Omen
		equip(sets.lowhp)
		send_command('wait1; input /ma Cure IV <me>')
		return
	elseif command=='idle' then
		is_valid = true
		end

	if not is_valid then
		send_command('Not a valid command for this Gearswap') --If you see this and you are trying to add or edit a new command make sure is_valid = true is part of the if statememnt handling the command
	end
	update_gear()
end

-- Handles Idle sets and sets Favor values based on those sets
function idle()
    if pet.isvalid then
		if IdleMode.value=='DT' then
			equip(sets.aftercast.Perp_DT)
			Currentskill=DTSkill
		elseif string.find(pet.name,'Spirit') then
			equip(sets.aftercast.Spirit)
		elseif IdleMode.value=='PetDT' then
			equip(sets.aftercast.Avatar_DT)
			Currentskill=PetDTSkill
		elseif IdleMode.value=='Refresh' then
			if player.mpp < 50 then
				Currentskill = RefreshSkill
				equip(sets.aftercast.Perp_RefreshSub50)
			else
				Currentskill = RefreshSkill
				equip(sets.aftercast.Perp_Refresh)
			end
		elseif IdleMode.value=='Favor' then
			Currentskill = FavorSkill
			equip(sets.aftercast.Perp_Favor)
		elseif IdleMode.value=='Pet Haste' then
			Currentskill = PetHasteSkill
			equip(sets.aftercast.Perp_DD)
		end
	else
		if IdleMode.value=='DT' then
			equip(sets.aftercast.DT)
		elseif IdleMode.value=='Refresh' then
			if player.mpp < 50 then
				equip(sets.aftercast.Perp_RefreshSub50)
			else
				equip(sets.aftercast.Perp_Refresh)
			end
		elseif IdleMode.value=='DD' then
			equip(sets.aftercast.Perp_Melee)		
		else 	
			equip(sets.aftercast.Idle)
		end
	end
end

--Function Autocalculates best use of Elemental Siphon. Created by Verda
function handle_siphoning()

	if windower.ffxi.get_ability_recasts()[175] > 0 then
		send_command('input /echo Elemental Siphon isn\'t ready!')
		return
	end
	
    if areas.Cities:contains(world.area) then
        add_to_chat(122, 'Cannot use Elemental Siphon in a city area.')
        return
    end
 spirits = S{"LightSpirit", "DarkSpirit", "FireSpirit", "EarthSpirit", "WaterSpirit", "AirSpirit", "IceSpirit", "ThunderSpirit"}
    avatars = S{"Carbuncle", "Fenrir", "Diabolos", "Ifrit", "Titan", "Leviathan", "Garuda", "Shiva", "Ramuh", "Odin", "Alexander", "Cait Sith"}
    local siphonElement
    local stormElementToUse
    local releasedAvatar
    local dontRelease
   
    -- If we already have a spirit out, just use that.
    if pet.isvalid and spirits:contains(pet.name) then
        siphonElement = pet.element
        dontRelease = true
        -- If current weather doesn't match the spirit, but the spirit matches the day, try to cast the storm.
        if player.sub_job == 'SCH' and pet.element == world.day_element and pet.element ~= world.weather_element then
--            if not S{'Light','Dark','Lightning'}:contains(pet.element) then
--                stormElementToUse = pet.element
--            end
	    stormElementToUse = pet.element
        end
    -- If we're subbing /sch, there are some conditions where we want to make sure specific weather is up.
    -- If current (single) weather is opposed by the current day, we want to change the weather to match
    -- the current day, if possible.
    elseif player.sub_job == 'SCH' and world.weather_element ~= 'None' then
        -- We can override single-intensity weather; leave double weather alone, since even if
        -- it's partially countered by the day, it's not worth changing.
        if get_weather_intensity() == 1 then
            -- If current weather is weak to the current day, it cancels the benefits for
            -- siphon.  Change it to the day's weather if possible (+0 to +20%), or any non-weak
            -- weather if not.
            -- If the current weather matches the current avatar's element (being used to reduce
            -- perpetuation), don't change it; just accept the penalty on Siphon.
            if world.weather_element == elements.weak_to[world.day_element] and
                (not pet.isvalid or world.weather_element ~= pet.element) then
                -- We can't cast lightning/dark/light weather, so use a neutral element
--                if S{'Light','Dark','Lightning'}:contains(world.day_element) then
--                    stormElementToUse = 'Wind'
--                else
--                    stormElementToUse = world.day_element
--                end
		stormElementToUse = world.day_element
            end
        end
    end
   
    -- If we decided to use a storm, set that as the spirit element to cast.
    if stormElementToUse then
        siphonElement = stormElementToUse
    elseif world.weather_element ~= 'None' and (get_weather_intensity() == 2 or world.weather_element ~= elements.weak_to[world.day_element]) then
        siphonElement = world.weather_element
    else
        siphonElement = world.day_element
    end
   
    local command = ''
    local releaseWait = 0
    local elementused = ''
	local lagmodedelay = 0
	
	if LagMode.value then lagmodedelay = 2 end
   
    if pet.isvalid and avatars:contains(pet.name) then
        command = command..'input /pet "Release" <me>;wait 1.1;'
        releasedAvatar = pet.name
		if LagMode.value then
			releaseWait = siphondelay + 2  -- Modify release wait. Adds extra time if lag mode is on
		else 
			releaseWait = siphondelay
		end
    end
   
    if stormElementToUse then
        command = command..'input /ma "'..elements.storm_of[stormElementToUse]..'" <me>;wait '..tostring(4+lagmodedelay)..';'
        releaseWait = releaseWait - 4
		elementused = stormElementToUse
    end
   
    if not (pet.isvalid and spirits:contains(pet.name)) then
        command = command..'input /ma "'..elements.spirit_of[siphonElement]..'" <me>;wait '..tostring(4+lagmodedelay)..';'
        releaseWait = releaseWait - 4
		elementused = siphonElement
    end
   
    command = command..'input /ja "Elemental Siphon" <me>;'
    releaseWait = releaseWait - 1
    releaseWait = releaseWait + 0.1
   
    if not dontRelease then
        if releaseWait > 0 then
            command = command..'wait '..tostring(releaseWait)..';'
        else
            command = command..'wait 1.1;'
        end
       
        command = command..'input /pet "Release" <me>;'
    end
   
    if releasedAvatar then
        command = command..'wait 1.1;input /ma "'..releasedAvatar..'" <me>'
    end

    send_command(command)
end
 
 --Updates pet icon on the UI
function pet_update()
	summons:set(summons:contains(pet and pet.name and pet.name:lower() or 'dummy') and (pet and pet.name and pet.name:lower()) or 'blank')
	
	if pet.isvalid and not buffactive['Avatar\'s Favor'] and Autofavor then
		local abil_recasts = windower.ffxi.get_ability_recasts() --Collect recast date
		if abil_recasts[176] == 0 and not NonValidFavor[pet.name] then
			send_command('wait 2; input /ja "Avatar\'s Favor" <me>')
		end
	end
	
	
end

-- Builds UI
function build_UI()
	if NoHud then return end
	--Sets parameters correct if you have RDM sub to display Auto Convert button	
	drawconvert = false
	buttonX = 22.5
	if player.sub_job == 'RDM' then
		drawconvert = true
		buttonX = 0
	end

-- Setting Paramets for the UI when BindMacros is Off to offer a cleaner look with less dead space	
	unboundY = 0
	unboundX = 0
	unboundYCycle = 0
	unboundXCycle = 0
	if not BindMacros then
		unboundY = -362.5
		unboundX = 40
		unboundYCycle = -340
		unboundXCycle = 40
	end
	--Draws Summon Selector
	summ = IconButton{
		x = Xpos,
		y = Ypos,
		var = summons,
		icons = {
			{img = 'SMN/base.png', value = 'blank' },
			{img = 'SMN/cait sith.png', value = 'cait sith'},
			{img = 'SMN/carbuncle.png', value = 'carbuncle'},
			{img = 'SMN/fenrir.png', value = 'fenrir'},
			{img = 'SMN/ifrit.png', value = 'ifrit'},
			{img = 'SMN/titan.png', value = 'titan'},
			{img = 'SMN/leviathan.png', value = 'leviathan'},
			{img = 'SMN/garuda.png', value = 'garuda'},
			{img = 'SMN/shiva.png', value = 'shiva'},
			{img = 'SMN/Ramuh.png', value = 'ramuh'},
			{img = 'SMN/Diabolos.png', value = 'diabolos'},
			{img = 'SMN/atomos.png', value = 'atomos'},
			{img = 'SMN/alexander.png', value = 'alexander'},
			{img = 'SMN/odin.png', value = 'odin'},
		},
		command = function() windower.send_command('gs c smn %s':format(summons.value)) end
	}	
	summ:draw() 

	--Draws Summon Name
	Summonname= PassiveText({
        x = Xpos+50,
        y = Ypos,
        text = '%s',
        align = 'left'},
    function() local pet = windower.ffxi.get_mob_by_target('pet'); return tostring(pet and pet.name or 'No Pet') end
    )
	Summonname:draw()
	
	--Draws PetHP
    PetHP= PassiveText({
        x = Xpos+50,
        y = Ypos+15,
        text = 'HP: %s',
        align = 'left'},
   function() local pet = windower.ffxi.get_mob_by_target('pet'); return tostring(pet and pet.hpp..'%' or 'No Pet') end
    )
	PetHP:draw()	
	
	--Draws PetTP
	PetTP= PassiveText({
        x = Xpos+50,
        y = Ypos+30,
        text = 'TP: %s',
        align = 'left'},
	    function() return windower.ffxi.get_mob_by_target('pet') and pet_tp or 'No Pet' end
    )
	PetTP:draw()
	
	--Draws Favor display
	Favorcheck = PassiveText({
        x = Xpos+130,
        y = Ypos,
		font_size = 12,
		bold = true,
        text = 'Avatar\'s Favor %s',
        align = 'center'},
    function()
		local Displaytext =''
		if Favor == 'On' or not (pet and pet.isvalid) or NonValidFavor[petname()] then 
			if pet and pet.isvalid and favorvalues[pet.name] then
				local favorvalue = determinefavor()
				if favorvalue > 11 then favorvalue = 11 end
				Favorcheck:recolor(255,253,252,250) 
				Favorcheck:restroke(127, 18, 97, 136)
				Displaytext ='Effect \n'..favorvalues[pet.name][favorvalue].Name..' +'..favorvalues[pet.name][favorvalue].value
			else
				Favorcheck:recolor(0, 0, 0, 0) 
				Favorcheck:restroke(0,0,0,0)
			end
		else 
			Favorcheck:recolor(255, 255, 0, 0) 
			Favorcheck:restroke(255,255,255,255)
			Displaytext = 'Off'
		end 
		return Displaytext
	end
    )
	Favorcheck:draw()
	
	--Draws Idle Cycle
	idlecycle= TextCycle{
		x = Xpos+30+unboundXCycle,
		y = Ypos+480+unboundYCycle,
		var = IdleMode,
		align = 'center',
		width = 112,
		command = 'gs c idle'
	}
	idlecycle:draw()
	
	--Draws Pet Accuracy Cycle
	AccCycle= TextCycle{
		x = Xpos+30+unboundXCycle,
		y = Ypos+510+unboundYCycle,
		var = AccMode,
		align = 'center',
		width = 112,
		command = function() windower.send_command('gs c accupdate') end
	}
	AccCycle:draw()
	
	--Draws Melee Mode Cycle
	MeleeCycle= TextCycle{
		x = Xpos+30+unboundXCycle,
		y = Ypos+540+unboundYCycle,
		var = engagedMode,
		align = 'center',
		width = 112,
		command = function() windower.send_command('gs c engagedupdate') end
	}
	MeleeCycle:draw()
	
	--Draws Nirvana Lock button
	nirvanalock = ToggleButton{
		x = Xpos+buttonX+unboundX,
		y = Ypos+430+unboundY,
		var = 'MeleeMode',
		iconUp = 'SMN/nirvanaunlock.png',
		iconDown = 'SMN/nirvanalock.png',
		command = function() windower.send_command('gs c meleemode %s':format(tostring(MeleeMode))) end
	}
	nirvanalock:draw()
	
	--Draws ElementalSiphon button
	ElementalSiphonbutton = FunctionButton{
    x = Xpos+45+buttonX+unboundX,
    y = Ypos+430+unboundY,
    icon = 'SMN/elementalsiphon.png',
    command = function() windower.send_command('gs c siphon') end
}
	ElementalSiphonbutton:draw()
	
	--Draws Autoconvert button
	autoconvert = ToggleButton{
        x = Xpos+90+unboundX,
        y = Ypos+430+unboundY,
        var = atconvert,
        iconDown = 'SMN/convert-AUTO.png',
        iconUp = 'SMN/convert-NO.png',
        command = function() windower.send_command('gs c autoconvert') end
    }
	if drawconvert then	autoconvert:draw() end
	
	--Draws lagmode button
	lagmodetoggle = ToggleButton{
        x = Xpos+135-buttonX+unboundX,
        y = Ypos+430+unboundY,
        var = LagMode,
        iconUp = 'SMN/lagmode-off.png',
        iconDown = 'SMN/lagmode-on.png',
        command = function() windower.send_command('gs c lagmode') end
    }
	lagmodetoggle:draw()
	
	--Draws UI repair button
	repairbutton =  FunctionButton{
    x = Xpos+180-buttonX+unboundX,
    y = Ypos+430+unboundY,
    icon = 'SMN/repair.png',
    command = function() windower.send_command('gs c refreshui') end
}
	repairbutton:draw()
	
	--Draws Assault/Release/Retreat Command Macros
	petcommands = TextTable{
        x = Xpos,
        y = Ypos + 60,
        height = 3,
        pad_y = 0,
        var = base_macros,
        columns = {'text', 'name'},
        auto_update = false
    }
	--Draws Macro hud
	
	macrohud = TextTable{
        x = Xpos,
        y = Ypos + 145,
        auto_height = true,
        pad_y = 0,
        var = current_macros,
        columns = {'numbertext', 'bloodpact', 'name', 'finalmana', 'text', 'colorofmana'},
        auto_update = true
    }
	--Determines if Draw needs to take place.
	if BindMacros then 
        macrohud:draw()
		petcommands:draw()
        macrohud:align_column(4, 'right')
		macrohud:style_column(6, {color={0,0,0,0},stroke_color={0,0,0,0}})
        macrohud:refresh_style()
        macrohud:redraw()
    end
	
	-- Top Divider
	DIV = Divider{
        x = Xpos,
        y = Ypos + 125,
        size = 300
    }
	DIV:draw()
	
	-- Bottom Divier
	DIV2 = Divider{
        x = Xpos,
        y = Ypos + 50,
        size = 300
    }
	DIV2:draw()



end

-- Rebuilds UI and Rebinds macros
function refreshrepair() 

	if NoHud then return end
	summ:undraw() 
	Summonname:undraw()
	PetHP:undraw()
	PetTP:undraw()
	Favorcheck:undraw()
	idlecycle:undraw()
	AccCycle:undraw()
	MeleeCycle:undraw()
	nirvanalock:undraw()
	ElementalSiphonbutton:undraw()
	if drawconvert then	autoconvert:undraw() end
	lagmodetoggle:undraw()
	repairbutton:undraw()
   if BindMacros then  
        macrohud:undraw()
        petcommands:undraw()
    end
	DIV:undraw()
	DIV2:undraw()
	determinemerits()
	send_command('input /echo "Refreshing UI and Macro Elements"')

	build_UI()
if BindMacros then build_keybinds(pet and macros[pet.name] and pet.name or 'None') end


end

-- Function that will release current pet, summon atomos and resummon old pet after
function atomosrun()
	local t = windower.ffxi.get_mob_by_target('t')
	if not (t and bit.band(t.id,0xFF000000) ~= 0) and t.index > 0x400 then
		send_command('input /echo This is not a valid target for Atomos')
		pet_update()
		return
	end
	if windower.ffxi.get_spell_recasts()[847] > 0 then
		pet_update()
		send_command('input /echo Atomos is not ready yet')
		return
	end
	if pet and pet.isvalid then
		lagmodechange = 0
		if LagMode.value then lagmodechange = 1 end
		local previouspet = pet.name
		send_command('input /ja "Release" <me>;wait '..1.5+lagmodechange..';input /ma "Atomos" '..t.id..';wait '..22+lagmodechange..';input /ma "'..previouspet..'" <me>')
	else
		send_command('input /ma "Atomos" '..t.id)
	end


end

-- Function that will release current pet, summon your SP avatar and resummon old pet after. Adjust the 22 in wait to cycle back to avatar quicker if desired.
function spavatar(summonname)

	if not buffactive['Astral Flow'] then
		send_command('input /echo You need Astral Flow to use '..summonname:ucfirst())
		pet_update()
		return
	end
	targetvalue = '<me>'
	if summonname == 'odin' then 
		local t = windower.ffxi.get_mob_by_target('t')
		targetvalue = '<t>' 
		if not (t and bit.band(t.id,0xFF000000) ~= 0) and t.index > 0x400 then
			send_command('input /echo This is not a valid target for Odin')
			pet_update()
			return
		else
			targetvalue = t.id
		end
	end
	if pet and pet.isvalid then
		lagmodechange = 0
	if LagMode.value then lagmodechange = 1 end
		pet_update()
		local previouspet = pet.name
		send_command('input /ja "Release" <me>;wait '..1.5+lagmodechange..';input /ma "'..summonname..'" '.. targetvalue..';wait '..18+lagmodechange..';input /ma "'..previouspet..'" <me>')
	else
		pet_update()
		send_command('input /ma "'..summonname..' '..targetvalue)
	end
	

end

-- Builds Keybinds
function build_keybinds(petname)

    if petname == 'None' then
        for i, v in ipairs(macros[petname]) do
            if(not v.hide) then
                send_command('bind '..v.number..' input /ma '..v.name..' '..v.target)
            end
        end
    else 
        for i, v in ipairs(macros[petname]) do
            if(not v.hide) then
                send_command('bind '..v.number..' input /pet '..v.name..' '..v.target)
            end
        end
    end
  end
--Unbinds summon keybinds
function unbind_keybinds(oldname)

	for i, v in ipairs(macros[oldname]) do
		if(not v.hide) then
			send_command('unbind '..v.number)
		end
	end
end
-- Calculates abilities based on Moon and Time phases (Fenrir and Diabolos)
function avatar_phases(abilityname)

effects ={}
moon_phase = windower.ffxi.get_info().moon_phase + 1
local hour = math.floor(windower.ffxi.get_info().time / 60)
		if hour > 12 then
			hour = 24 - hour
		end

effects['Lunar Cry'] = {
	'Eva. -31 <> Acc. -1',
	'Eva. -26 <> Acc. -6',
	'Eva. -21 <> Acc. -11',
	'Eva. -16 <> Acc. -16',
	'Eva. -11 <> Acc. -21',
	'Eva. -6 <> Acc. -26',
	'Eva. -1 <> Acc. -31',
	'Eva. -6 <> Acc. -26',
	'Eva. -11<> Acc. -21',
	'Eva. -16 <> Acc. -16',
	'Eva. -21 <> Acc. -6',
	'Eva. -26 <> Acc. -1'
}

effects['Ecliptic Howl'] = {
	'Acc. +1 <> Eva. +25',
	'Acc. +5 <> Eva. +21',
	'Acc. +9 <> Eva. +17',
	'Acc. +13 <> Eva. +13',
	'Acc. +17 <> Eva. +9',
	'Acc. +21 <> Eva. +5',
	'Acc. +25 <> Eva. +1',
	'Acc. +21 <> Eva. +5',
	'Acc. +17 <> Eva. +9',
	'Acc. +13 <> Eva. +13',
	'Acc. +9 <> Eva. +17',
	'Acc. +5 <> Eva. +21'
}

effects['Ecliptic Growl'] ={
	'STR/DEX/VIT +1 <> AGI/INT/MND/CHR +7',
	'STR/DEX/VIT +2 <> AGI/INT/MND/CHR +6',
	'STR/DEX/VIT +3 <> AGI/INT/MND/CHR +5',
	'STR/DEX/VIT +4 <> AGI/INT/MND/CHR +4',
	'STR/DEX/VIT +5 <> AGI/INT/MND/CHR +3',
	'STR/DEX/VIT +6 <> AGI/INT/MND/CHR +2',
	'STR/DEX/VIT +7 <> AGI/INT/MND/CHR +1',
	'STR/DEX/VIT +6 <> AGI/INT/MND/CHR +2',
	'STR/DEX/VIT +5 <> AGI/INT/MND/CHR +3',
	'STR/DEX/VIT +4 <> AGI/INT/MND/CHR +4',
	'STR/DEX/VIT +3 <> AGI/INT/MND/CHR +5',
	'STR/DEX/VIT +2 <> AGI/INT/MND/CHR +6'
}




effects['Dream Shroud']= {
	'MAB +13 <> MDB +1',
	'MAB +12 <> MDB +2',
	'MAB +11 <> MDB +3',
	'MAB +10 <> MDB +4',
	'MAB +9 <> MDB +5',
	'MAB +8 <> MDB +6',
	'MAB +7 <> MDB +7',
	'MAB +6 <> MDB +8',
	'MAB +5 <> MDB +9',
	'MAB +4 <> MDB +10',
	'MAB +3 <> MDB +11',
	'MAB +2 <> MDB +12',
	'MAB +1 <> MDB +13',
}

if abilityname == 'Heavenward Howl' then
	if moon_phase == 1 or moon_phase > 6 then
			return 'Enaspir'
		else
			 return 'Endrain'
		end
elseif abilityname =='Dream Shroud' then
	return effects[abilityname][hour +1]
else
	return effects[abilityname][moon_phase]
end


end
--Precast calls this to verify ability name and check for autoconvert
function verifyAbility(t, found)

	for i, row in ipairs(t) do
        if row.name == found then
            return i
        end
    end
end
-- Changes color of SP abilities if Astral Flow is active and then if you have enough mana
function spcolor(cell)
    local bpname = macrohud[cell.row][3].value
    if Spabilities:contains(bpname) and not buffactive['Astral Flow'] then
        macrohud:style_row(cell.row, {color = {255, 127, 127, 127}})
	elseif not (bpname == 'Odin' or bpname == 'Alexander') then
		macrohud:style_row(cell.row, {color = {255,253,252,250}})
		manacolor(cell)
    else
		macrohud:style_row(cell.row, {color = {255,253,252,250}})
		macrohud:style_row(cell.row, {stroke_color = {127, 18, 97, 136}})
    end
    return ''

end
-- Changes color of merit BP colors if you have them unlocked then if you have enough mana for them
function meritbpcolor(cell)
    local bpname = macrohud[cell.row][3].value
    if merits[bpname] > 0 then
        macrohud:style_row(cell.row, {color = {255,253,252,250}})
        manacolor(cell)
    else
        macrohud:style_row(cell.row, {color = {255, 127, 127, 127}})
    end
    return ''
end

--Function to determine if mana is less than mana needed. Updates the macrohud Colors
function manacolor(cell)
    local manacost = macrohud[cell.row][cell.col - 2].value
    if windower.ffxi.get_player().vitals.mp >= (manacost ~= '' and  tonumber(manacost) or 0) then
		macrohud:style_row(cell.row, {color = {255,253,252,250}})
        macrohud:style_row(cell.row, {stroke_color = {127, 18, 97, 136}})
    else
		macrohud:style_row(cell.row, {color = {255,253,252,250}})
        macrohud:style_row(cell.row, {stroke_color = {127, 136, 0, 18}})
    end
    return ''
end

function manavalue(cell)
	local manacost = macros[petname()][cell.row].Mana or false
	if not manacost then return '' end
	if buffactive['Apogee'] then
	manacost = manacost*1.5
	end
	return math.ceil(manacost)
end

--Function to determine the favor value and tiers for the HUD
function determinefavor()
	local head = player.equipment.head	
	local tier = 0
	local tieradd = 0
	if jobpointbonus then tieradd = tieradd +1 end
	
	for i, v in ipairs(favorgear) do
		if head == v.name then
			tieradd = tieradd + v.value
		end
	end
	
	for i, v in ipairs(favortiers) do
		if Currentskill >= v.skill then
			tier = v.tier +1
		else
			return tier+tieradd
		end
	end
	
end
-- Determines Merits and Job point bonuses
function determinemerits()
	--Determine if the player has the 550 Favor gift--
	if windower.ffxi.get_player().job_points['smn']['jp_spent'] > 550 then jobpointbonus = true end
	local meritvalues = windower.ffxi.get_player().merits
	
	merits={
	    ['Meteor Strike'] = meritvalues['meteor_strike'],
        ['Heavenly Strike'] = meritvalues['heavenly_strike'] ,
        ['Wind Blade'] = meritvalues['wind_blade'],
        ['Geocrush'] = meritvalues['geocrush'],
        ['Thunderstorm'] = meritvalues['thunderstorm'],
        ['Grand Fall'] = meritvalues['grand_fall']
	}
	
	if BindMacros then define_macrosets() end
	
end
-- Grabs PetTP` from a packet. 
windower.raw_register_event('incoming chunk', function(id,original,modified,injected,blocked)
    if not injected then
        if id == 0x67 or id == 0x068 then    -- general hp/tp/mp update
            local packet = packets.parse('incoming', original)
            local msg_type = packet['Message Type']
            local msg_len = packet['Message Length']
            pet_idx = packet['Pet Index']
            own_idx = packet['Owner Index']

            if (msg_type == 0x04) and id == 0x067 then
                pet_idx, own_idx = own_idx, pet_idx
            end
            
            if (msg_type == 0x04) then
                if (pet_idx == 0) then
                else
                    pet_tp = packet['Pet TP']
                    pet_mp = packet['Current MP%']  
                end
            end
        end
    end
end )
--When Zoning it recalculates merits and JP bonuses
windower.register_event('zone change', determinemerits)
--Recalculates Merits when you login
windower.register_event('login', determinemerits)
-- Reload gearswap when you change subjobs to clean up UI elements
function sub_job_change(new, old)
    windower.send_command('gs reload')
end

function petname()
    local pet = windower.ffxi.get_mob_by_target('pet')
    return pet and pet.name or 'None'
end
function update_gear() -- needs to be called with gearswap vars loaded

    if player.status == 'Engaged' and engagedMode.value ~= 'Off' then
        equip(sets.engaged[engagedMode.value])
    else
        idle()
    end
end