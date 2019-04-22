function build_gearsets()
	

	-- Set your merits here. This is used in deciding between Enticer's Pants or Apogee Slacks +1.
	

	
	
	-- ===================================================================================================================
	--		Sets
	-- ===================================================================================================================

	-- Set used for Nirvana lock. Update Elan strap if needed.
	
	
	sets.nirvanal = {
	main = 'Nirvana',
	sub = 'Elan Strap',
	}
	
	-- Put gear hear the will drop your HP -500 Below your idle set. Great for omen objectives. Just type gs c lowhp
	sets.lowhp = {
	head="Apogee Crown +1",
	body={ name="Apo. Dalmatica +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
	legs="Apogee Slacks +1",
	feet="Apogee Pumps +1",
	
	}
	
	
	-- Base Damage Taken Set - Mainly used when IdleMode is "DT"
	sets.DT_Base = {
    main="Nirvana",
    sub="Oneiros Grip",
    ammo="Sancus Sachet +1",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Udug Jacket",
    hands="Inyan. Dastanas +1",
    legs="Inyanga Shalwar +2",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Twilight Torque",
    waist="Fucho-no-Obi",
    left_ear="Ethereal Earring",
    right_ear="Infused Earring",
    left_ring="Paguroidea Ring",
    right_ring="Sheltered Ring",
    back="Solemnity Cape",
}

	sets.precast = {}

	-- Fast Cast
	sets.precast.FC =  {  
	main={ name="Grioavolr", augments={'Enfb.mag. skill +15','INT+5','Mag. Acc.+17',}},
    sub="Niobid Strap",
    ammo="Sancus Sachet +1",
    head="Amalric Coif",
    body="Inyanga Jubbah +2",
    hands={ name="Telchine Gloves", augments={'"Fast Cast"+3',}},
    legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    feet="Regal Pumps +1",
    neck="Twilight Torque",
    waist="Witful Belt",
    left_ear="Loquac. Earring",
    right_ear="Infused Earring",
    left_ring="Weather. Ring",
    right_ring="Kishar Ring",
    back={ name="Campestres's Cape", augments={'Pet: M.Acc.+20 Pet: M.Dmg.+20','"Fast Cast"+10',}},
}

    sets.midcast = {}

	-- BP Timer Gear
    sets.midcast.BP = {
    main={ name="Espiritus", augments={'Summoning magic skill +15','Pet: Mag. Acc.+30','Pet: Damage taken -4%',}},
    sub="Niobid Strap",
    ammo="Sancus Sachet +1",
    head="Beckoner's Horn +1",
    body="Con. Doublet +2",
    hands={ name="Glyphic Bracers", augments={'Inc. Sp. "Blood Pact" magic burst dmg.',}},
    legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    feet={ name="Apogee Pumps", augments={'MP+60','Summoning magic skill +15','Blood Pact Dmg.+7',}},
    neck="Caller's Pendant",
    waist="Lucidity Sash",
    left_ear="Andoaa Earring",
    right_ear="Evans Earring",
    left_ring="Stikini Ring",
    right_ring="Evoker's Ring",
    back={ name="Conveyance Cape", augments={'Summoning magic skill +2','Pet: Enmity+5','Blood Pact Dmg.+4',}},
}

	-- Gear for Elemental Siphon
    sets.midcast.Siphon = {
  
	main={ name="Espiritus", augments={'Summoning magic skill +15','Pet: Mag. Acc.+30','Pet: Damage taken -4%',}},
    sub="Niobid Strap",
    ammo="Sancus Sachet +1",
    head="Beckoner's Horn +1",
    body="Beckoner's Doublet",
    hands="Lamassu Mitts +1",
    legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    feet="Beck. Pigaches",
    neck="Caller's Pendant",
    waist="Lucidity Sash",
    left_ear="Andoaa Earring",
    right_ear="Evans Earring",
    left_ring="Stikini Ring",
    right_ring="Evoker's Ring",
    back={ name="Conveyance Cape", augments={'Summoning magic skill +2','Pet: Enmity+5','Blood Pact Dmg.+4',}},
}
	-- Puts on Zodiac ring if day matches
	sets.midcast.SiphonZodiac = set_combine(sets.midcast.Siphon, { ring1="Zodiac Ring" })

	-- If you have Baayami robe use this set to summon with 100% SID
	sets.midcast.Summon = set_combine(sets.DT_Base, {
	--	body="Baayami Robe +1"
	})
	


	-----JA Gear----
	sets.midcast["Mana Cede"] = { hands="Beckoner's Bracers" }
    sets.midcast["Astral Flow"] = { head="Glyphic Horn" }
	
---------------------------------------------------------------------------------------
------------------------------Blood Pact Damage Gear-----------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
-- If you want to define an accuracy set for any set here just slap make a new set with
-- the same name as the old set set but slap a .Mid at the end of it. If you want to make
-- another even more accurate set slap a .Acc at the end of the new set. 
-- EX sets.pet_midcast.Physical_BP will fire off if I my accuracy set is normally
-- sets.pet_midcast.Physical_BP.Mid will fire off if I set my accuracy mode to Mid
-- If you don't define a .Mid or .Acc it will just default to the next lowest tier
-- IE Acc mode will default to Mid if defined or Normal if not defined
-----------------------------------------------------------------------------------------


-- Leaves the blank, you should never be using them
	sets.pet_midcast = {}
	sets.pet_midcast.Magic_BP = {}

	-- Main physical pact set (Volt Strike, Pred Claws, etc.)
	sets.pet_midcast.Physical_BP =  {
	main="Nirvana",
   --main={ name="Gridarvor", augments={'Pet: Accuracy+70','Pet: Attack+70','Pet: "Dbl. Atk."+15',}},
    sub="Elan Strap",
    ammo="Sancus Sachet +1",
    head={ name="Helios Band", augments={'Pet: Attack+24 Pet: Rng.Atk.+24','Pet: "Dbl. Atk."+8','Blood Pact Dmg.+7',}},
    body="Con. Doublet +2",
    hands={ name="Merlinic Dastanas", augments={'Pet: Attack+13 Pet: Rng.Atk.+13','Blood Pact Dmg.+10','Pet: STR+7','Pet: Mag. Acc.+7',}},
    legs={ name="Apogee Slacks +1", augments={'Pet: STR+20','Blood Pact Dmg.+14','Pet: "Dbl. Atk."+4',}},
    feet={ name="Apogee Pumps +1", augments={'MP+80','Pet: Attack+35','Blood Pact Dmg.+8',}},
    neck="Smn. Collar +1",
    waist="Incarnation Sash",
    left_ear="Gelos Earring",
    right_ear="Lugalbanda Earring",
    left_ring="Varar Ring",
    right_ring="Varar Ring",
    back={ name="Campestres's Cape", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+20 /Mag. Eva.+20','Pet: Haste+10',}},
}

	sets.pet_midcast.Physical_BP.Mid = sets.pet_midcast.Physical_BP

	-- Should swap to higher BP gear here and less Double attack
	sets.pet_midcast.Physical_BP.AM3 = set_combine(sets.pet_midcast.Physical_BP, {
		ear2="Gelos Earring",
		body="Convoker's Doublet +2",
		feet={ name="Apogee Pumps +1", augments={'MP+80','Pet: Attack+35','Blood Pact Dmg.+8',}}
	})

	-- Physical pacts which benefit more from TP than Pet:DA (like single-hit BP)
	sets.pet_midcast.Physical_BP.TP = set_combine(sets.pet_midcast.Physical_BP, {
		ear2="Gelos Earring",
		body="Convoker's Doublet +2",
	--	waist="Regal Belt",
		legs="Enticer's Pants",
		feet={ name="Apogee Pumps +1", augments={'MP+80','Pet: Attack+35','Blood Pact Dmg.+8',}}
	})

	-- You can define two accuracy sets .Mid and .Acc depending on what accuracy levels you want. Just add .Mid or .Acc to end of a new set that you want accuracy on
	sets.pet_midcast.Physical_BP.Mid = set_combine(sets.pet_midcast.Physical_BP, {
	--	head={ name="Apogee Crown +1", augments={'MP+80','Pet: Attack+35','Blood Pact Dmg.+8',}},
		body="Convoker's Doublet +2",
		head="Inyanga Tiara +1",
	--	hands={ name="Merlinic Dastanas", augments={'Pet: Accuracy+28 Pet: Rng. Acc.+28','Blood Pact Dmg.+10','Pet: DEX+9','Pet: Mag. Acc.+9','Pet: "Mag.Atk.Bns."+3',}},
	--feet="Convoker's Pigaches +3"
	})

	-- Base magic pact set
	sets.pet_midcast.Magic_BP_Base = {
    main={ name="Grioavolr", augments={'Blood Pact Dmg.+9','Pet: Mag. Acc.+2','Pet: "Mag.Atk.Bns."+22',}},
    sub="Elan Strap",
    ammo="Sancus Sachet +1",
    head={ name="Apogee Crown +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
    body={ name="Apo. Dalmatica +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
    hands={ name="Merlinic Dastanas", augments={'Pet: Mag. Acc.+17 Pet: "Mag.Atk.Bns."+17','Blood Pact Dmg.+10','Pet: Mag. Acc.+2','Pet: "Mag.Atk.Bns."+15',}},
    legs={ name="Apogee Slacks +1", augments={'Pet: STR+20','Blood Pact Dmg.+14','Pet: "Dbl. Atk."+4',}},
    feet={ name="Apogee Pumps +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
    neck="Smn. Collar +1",
    waist="Mujin Obi",
    left_ear="Gelos Earring",
    right_ear="Lugalbanda Earring",
    left_ring="Varar Ring",
    right_ring="Varar Ring",
    back={ name="Campestres's Cape", augments={'Pet: M.Acc.+20 Pet: M.Dmg.+20','"Fast Cast"+10',}},
}
	
	-- Some magic pacts benefit more from TP than others.
	-- Note: This set will only be used on merit pacts if you have less than 4 merits.
	--       Make sure to update your merit values at the top of this Lua.
	sets.pet_midcast.Magic_BP.TP = set_combine(sets.pet_midcast.Magic_BP_Base, {
		legs="Enticer's Pants",
	})

	-- NoTP set used when you don't need Enticer's
	sets.pet_midcast.Magic_BP.NoTP = set_combine(sets.pet_midcast.Magic_BP_Base, {
		--legs={ name="Apogee Slacks +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}}
		legs='Inyanga Shalwar +2'
	})

	sets.pet_midcast.Magic_BP.TP.Mid = set_combine(sets.pet_midcast.Magic_BP.TP, {
		body="Convoker's Doublet +2",
	})

	sets.pet_midcast.Magic_BP.NoTP.Mid = set_combine(sets.pet_midcast.Magic_BP_NoTP, {
		body="Convoker's Doublet +2",
	})

	-- Hybrid set goes here. You want High BP damage, some accuracy and Magic attack bonus
	sets.pet_midcast['Flaming Crush']= {
	main="Nirvana",
    sub="Elan Strap",
    ammo="Sancus Sachet +1",
    head={ name="Apogee Crown +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
    body="Convoker's Doublet +2",
    hands={ name="Merlinic Dastanas", augments={'Pet: Mag. Acc.+17 Pet: "Mag.Atk.Bns."+17','Blood Pact Dmg.+10','Pet: Mag. Acc.+2','Pet: "Mag.Atk.Bns."+15',}},
    legs={ name="Apogee Slacks +1", augments={'Pet: STR+20','Blood Pact Dmg.+14','Pet: "Dbl. Atk."+4',}},
    feet={ name="Apogee Pumps +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
    neck="Smn. Collar +1",
    waist="Mujin Obi",
    left_ear="Gelos Earring",
    right_ear="Lugalbanda Earring",
    left_ring="Varar Ring",
    right_ring="Varar Ring",
    back={ name="Campestres's Cape", augments={'Pet: M.Acc.+20 Pet: M.Dmg.+20','"Fast Cast"+10',}},
}
	-- Highly recommend making physical accuracy sets for Flaming crush since landing the first hit is super important
	sets.pet_midcast['Flaming Crush'].Mid = set_combine(sets.pet_midcast.FlamingCrush, {
	--	ear2="Kyrene's Earring",
		body="Convoker's Doublet +2",
		--feet="Convoker's Pigaches +3"
	})

	-- Pet: Magic Acc set - Mainly used for debuff pacts like Shock Squall
	sets.pet_midcast.MagicAcc_BP = {
    bmain="Nirvana",
    sub="Elan Strap",
    ammo="Sancus Sachet +1",
    head="Beckoner's Horn +1",
    body="Con. Doublet +2",
    hands={ name="Merlinic Dastanas", augments={'Pet: Mag. Acc.+17 Pet: "Mag.Atk.Bns."+17','Blood Pact Dmg.+10','Pet: Mag. Acc.+2','Pet: "Mag.Atk.Bns."+15',}},
    legs={ name="Apogee Slacks", augments={'Pet: STR+15','Blood Pact Dmg.+13','Pet: "Dbl. Atk."+3',}},
    feet={ name="Apogee Pumps", augments={'MP+60','Summoning magic skill +15','Blood Pact Dmg.+7',}},
    neck="Smn. Collar +1",
    waist="Lucidity Sash",
    left_ear="Gelos Earring",
    right_ear="Lugalbanda Earring",
    left_ring="Stikini Ring",
    right_ring="Evoker's Ring",
    back={ name="Campestres's Cape", augments={'Pet: M.Acc.+20 Pet: M.Dmg.+20','"Fast Cast"+10',}},
}

	sets.pet_midcast.Debuff_Rage = sets.pet_midcast.MagicAcc_BP

	-- Pure summoning magic set, mainly used for buffs like Hastega II.
	sets.pet_midcast.SummoningMagic = {
	main={ name="Espiritus", augments={'Summoning magic skill +15','Pet: Mag. Acc.+30','Pet: Damage taken -4%',}},
    sub="Elan Strap",
    ammo="Sancus Sachet +1",
    head="Beckoner's Horn +1",
    body="Beckoner's Doublet",
    hands="Lamassu Mitts +1",
    legs={ name="Apogee Slacks +1", augments={'Pet: STR+20','Blood Pact Dmg.+14','Pet: "Dbl. Atk."+4',}},
    feet={ name="Apogee Pumps", augments={'MP+60','Summoning magic skill +15','Blood Pact Dmg.+7',}},
    neck="Caller's Pendant",
    waist="Lucidity Sash",
    left_ear="Gelos Earring",
    right_ear="Andoaa Earring",
    left_ring="Stikini Ring",
    right_ring="Evoker's Ring",
    back={ name="Conveyance Cape", augments={'Summoning magic skill +2','Pet: Enmity+5','Blood Pact Dmg.+4',}},
}

	sets.pet_midcast.Buff = sets.pet_midcast.SummoningMagic
	sets.pet_midcast['Perfect Defense'] = sets.pet_midcast.SummongMagic

	-- Healing set, based on Avatars HP
	sets.pet_midcast.Buff_Healing = set_combine(sets.pet_midcast.Magic_BP_Base, {
		main="Nirvana",
	})

	-- These pacts are normally used as nukes, but they're also strong debuffs which are enhanced by smn skill.
	-- Normal will use them in damage mode. Highly recommend setting a .Mid or .Acc for full Magic Accuracy incase you want to land the spell
	-- Just Modify Impact sets and Conflag Strike will follow
	sets.pet_midcast['Impact']= sets.pet_midcast.Magic_BP.TP
	sets.pet_midcast['Conflag Strike']= sets.pet_midcast['Impact']
	
	sets.pet_midcast['Impact'].Mid = set_combine(sets.pet_midcast.SummoningMagic, {
		main="Nirvana",
		head="Convoker's Horn +3",
		ear1="Lugalbanda Earring",
		ear2="Enmerkar Earring"
	})
	
	sets.pet_midcast['Conflag Strike'].Mid = sets.pet_midcast['Impact'].Mid
	sets.pet_midcast['Impact'].Acc= sets.pet_midcast['Impact'].Mid
	sets.pet_midcast['Conflag Strike'].Acc=sets.pet_midcast['Impact'].Acc
	
	

	sets.aftercast = {}
	
-----------------------------------Idle Sets -----------------------------------------------
--------------------------------------------------------------------------------------------
------------Fill out your Summoning Skill manually here for each Idle set-------------------
------------First define your idle sets then toggle between them to update your skill-------
------------This will determine what displays on the HUD for Avatar's Favor-----------------
--------------------------------------------------------------------------------------------
	RefreshSkill = 521
	DTSkill = 494
	FavorSkill = 506
	PetDTSkill = 506
	PetHasteSkill = 521
------------------------------------------------------------------	
	-- Idle set with no avatar out.
	sets.aftercast.Idle = {
    main="Nirvana",
    sub="Elan Strap",
    ammo="Sancus Sachet +1",
    head="Beckoner's Horn +1",
    body="Udug Jacket",
    hands="Asteria Mitts +1",
    legs="Assid. Pants +1",
    feet={ name="Apogee Pumps", augments={'MP+60','Summoning magic skill +15','Blood Pact Dmg.+7',}},
    neck="Twilight Torque",
    waist="Fucho-no-Obi",
    left_ear="Ethereal Earring",
    right_ear="Infused Earring",
    left_ring="Paguroidea Ring",
    right_ring="Sheltered Ring",
    back="Solemnity Cape",
}
		
	sets.aftercast.DT = sets.DT_Base

	-- Many idle sets inherit from this set.
	-- Put common items here so you don't have to repeat them over and over.
	sets.aftercast.Perp_Base = {
	main="Nirvana",
    sub="Elan Strap",
    ammo="Sancus Sachet +1",
    head="Beckoner's Horn +1",
    body={ name="Apo. Dalmatica +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
    hands="Asteria Mitts +1",
    legs="Assid. Pants +1",
    feet={ name="Apogee Pumps", augments={'MP+60','Summoning magic skill +15','Blood Pact Dmg.+7',}},
    neck="Caller's Pendant",
    waist="Isa Belt",
    left_ear="Ethereal Earring",
    right_ear="Infused Earring",
    left_ring="Stikini Ring",
    right_ring="Evoker's Ring",
    back={ name="Campestres's Cape", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+20 /Mag. Eva.+20','Pet: Haste+10',}},
}
	-- Avatar Melee set. Equipped when IdleMode is "Pet Haste' Put Haste / TP Gear here 
	sets.aftercast.Perp_DD = set_combine(sets.aftercast.Perp_Base, {
	--	ear2="Rimeice Earring",
	--	body="Glyphic Doublet +3",
	--	hands={ name="Helios Gloves", augments={'Pet: Accuracy+22 Pet: Rng. Acc.+22','Pet: "Dbl. Atk."+8','Pet: Haste+6',}},
	--	waist="Klouskap Sash",
	--	feet={ name="Helios Boots", augments={'Pet: Accuracy+21 Pet: Rng. Acc.+21','Pet: "Dbl. Atk."+8','Pet: Haste+6',}}
	})
	-- Refresh set with avatar out. Equipped when IdleMode is "Refresh".
	sets.aftercast.Perp_Refresh = set_combine(sets.aftercast.Perp_Base, {
		body={ name="Apo. Dalmatica +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
	})
	-- Puts on Fucho-no-Obi for that sweet latent
	sets.aftercast.Perp_RefreshSub50 = set_combine(sets.aftercast.Perp_Refresh, {
		waist="Fucho-no-obi"
	})
	
	--High favor set (SMN Skill/ Refresh/ Beckoner's head
	sets.aftercast.Perp_Favor = set_combine(sets.aftercast.Perp_Refresh, {
		head="Beckoner's Horn +1",
		ear2="Andoaa Earring",
		ring1="Stikini Ring +1",
		ring2="Evoker's Ring",
		legs="Baayami Slops +1",
		feet="Baayami Sabots +1"
	})
	
	-- Engaged Mode needs to be set to "Melee". Will equip when engaged
	sets.engaged = {}
	-- Default engaged mode set if it is enabled
	sets.engaged.Melee =   {
	head="Beckoner's Horn +1",
    body="Udug Jacket",
    hands="Tali'ah Gages",
    legs="Tali'ah Seraweels",
    feet="Tali'ah Crackows",
    neck="Asperity Necklace",
    waist="Windbuffet Belt",
    left_ear="Telos Earring",
    right_ear="Cessance Earring",
    left_ring="Petrov Ring",
    right_ring="Rajas Ring",
    back={ name="Campestres's Cape", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+20 /Mag. Eva.+20','Pet: Haste+10',}},
}
	--Engaged Mode needs to be TH for this to work. Will equip your TH gear for TH things because you want loot.
	sets.engaged.TH = set_combine(sets.engaged.Melee, {
	waist='Chaac Belt'
	
	})

	-- Pet:DT build. Equipped when IdleMode is "PetDT".
	sets.aftercast.Avatar_DT = {
		main="Nirvana",
		sub="Oneiros Grip",
		ammo="Sancus Sachet +1",
		head="Selenian Cap",
		neck="Summoner's Collar +2",
		ear1="Enmerkar Earring",
		ear2="Handler's Earring +1",
		body={ name="Apo. Dalmatica +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
		hands="Artsieq Cuffs",
		ring1="Stikini Ring +1",
		ring2="Evoker's Ring",
		back={ name="Campestres's Cape", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+20 /Mag. Eva.+20','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10',}},
		waist="Isa Belt",
		legs="Assiduity Pants +1",
		feet={ name="Telchine Pigaches", augments={'Pet: DEF+14','Pet: "Regen"+3','Pet: Damage taken -3%',}}
	}
	
	-- DT build with avatar out. Equipped when IdleMode is "DT".
	sets.aftercast.Perp_DT = set_combine(sets.DT_Base, {
		ear2="Evans Earring",
		body="Udug Jacket",
		waist="Lucidity Sash"
	})

	sets.aftercast.Spirit = sets.aftercast.Perp_Base 
	
	-------------------------------------------------------------------------
	----------------General Spellcasting and Utilit Sets---------------------
	-------------------------------------------------------------------------
	sets.midcast.Cure = {
    main="Tamaxchi",
    sub="Sors Shield",
    ammo="Sancus Sachet +1",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Beckoner's Doublet",
    hands="Inyan. Dastanas +1",
    legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Caller's Pendant",
    waist="Lucidity Sash",
    left_ear="Andoaa Earring",
    right_ear="Evans Earring",
    left_ring="Stikini Ring",
    right_ring="Evoker's Ring",
    back={ name="Conveyance Cape", augments={'Summoning magic skill +2','Pet: Enmity+5','Blood Pact Dmg.+4',}},
}


	sets.midcast.Cursna = {
    main="Tamaxchi",
    sub="Sors Shield",
    ammo="Sancus Sachet +1",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Beckoner's Doublet",
    hands="Inyan. Dastanas +1",
    legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Caller's Pendant",
    waist="Lucidity Sash",
    left_ear="Andoaa Earring",
    right_ear="Evans Earring",
    left_ring="Stikini Ring",
    right_ring="Evoker's Ring",
    back={ name="Conveyance Cape", augments={'Summoning magic skill +2','Pet: Enmity+5','Blood Pact Dmg.+4',}},
}


	sets.midcast.EnmityRecast = set_combine(sets.precast.FC, {
		main="Nirvana",
		ear1="Novia Earring",
		body={ name="Apo. Dalmatica +1", augments={'Summoning magic skill +20','Enmity-6','Pet: Damage taken -4%',}}
	})

	sets.midcast.Enfeeble = {
		main={ name="Gada", augments={'"Fast Cast"+2','MND+13','Mag. Acc.+20','"Mag.Atk.Bns."+14',}},
		sub="Ammurapi Shield",
		head="Inyanga Tiara +2",
		neck="Erra Pendant",
		ear1="Dignitary's Earring",
		ear2="Gwati Earring",
		body="Inyanga Jubbah +2",
		hands="Inyanga Dastanas +2",
		ring1="Stikini Ring +1",
		ring2="Stikini Ring +1",
		back={ name="Campestres's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','Haste+10','Phys. dmg. taken-10%',}},
		waist="Luminary Sash",
		legs="Inyanga Shalwar +2",
		feet="Skaoi Boots"
	}

	sets.midcast.Enhancing = {
		main={ name="Gada", augments={'Enh. Mag. eff. dur. +6','DEX+1','Mag. Acc.+5','"Mag.Atk.Bns."+18','DMG:+4',}},
		sub="Ammurapi Shield",
		head={ name="Telchine Cap", augments={'Pet: "Mag.Atk.Bns."+19','"Elemental Siphon"+25','Enh. Mag. eff. dur. +10',}},
		neck="Incanter's Torque",
		ear1="Andoaa Earring",
		ear2="Augmenting Earring",
		body={ name="Telchine Chas.", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
		hands={ name="Telchine Gloves", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		ring1="Stikini Ring +1",
		ring2="Stikini Ring +1",
		back="Merciful Cape",
		waist="Olympus Sash",
		legs={ name="Telchine Braconi", augments={'"Conserve MP"+4','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Conserve MP"+3','Enh. Mag. eff. dur. +9',}}
	}

	sets.midcast.Stoneskin = set_combine(sets.midcast.Enhancing, {
		neck="Nodens Gorget",
		ear2="Earthcry Earring",
		waist="Siegel Sash",
		--legs="Shedir Seraweels"
	})

	sets.midcast.Nuke = {
		main={ name="Grioavolr", augments={'"Fast Cast"+6','INT+2','"Mag.Atk.Bns."+17',}},
		sub="Niobid Strap",
		head="Inyanga Tiara +2",
		neck="Eddy Necklace",
		ear1="Hecate's Earring",
		ear2="Friomisi Earring",
		body="Witching Robe",
		hands={ name="Merlinic Dastanas", augments={'Pet: Crit.hit rate +2','"Mag.Atk.Bns."+25','"Refresh"+2','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		ring1="Acumen Ring",
		ring2="Strendu Ring",
		back={ name="Campestres's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','Haste+10','Phys. dmg. taken-10%',}},
		waist="Eschan Stone",
		legs="Lengo Pants",
		feet={ name="Merlinic Crackows", augments={'DEX+10','Phys. dmg. taken -2%','"Refresh"+2','Accuracy+3 Attack+3',}}
	}

    sets.midcast["Refresh"] = set_combine(sets.midcast.Enhancing, {
		head="Amalric Coif",
		waist="Gishdubar Sash"
	})

    sets.midcast["Aquaveil"] = set_combine(sets.midcast.Enhancing, {
		main="Vadose Rod",
		head="Amalric Coif"
	})
	
	
-------------------------------------------------------------------------------
------------------Weapon Skill sets--------------------------------------------
-------------------------------------------------------------------------------

	sets.midcast["Garland of Bliss"] = {
	ammo="Sancus Sachet +1",
    head={ name="Merlinic Hood", augments={'"Mag.Atk.Bns."+21','Magic burst dmg.+7%','MND+1','Mag. Acc.+14',}},
    body="Inyanga Jubbah +2",
    hands="Inyan. Dastanas +1",
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+19 "Mag.Atk.Bns."+19','Magic burst dmg.+8%','AGI+1',}},
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Sanctity Necklace",
    waist="Hachirin-no-Obi",
    left_ear="Ishvara Earring",
    right_ear="Friomisi Earring",
    left_ring="Rufescent Ring",
    right_ring="Weather. Ring",
    back={ name="Conveyance Cape", augments={'Summoning magic skill +2','Pet: Enmity+5','Blood Pact Dmg.+4',}},
}

	sets.midcast["Shattersoul"] = {
		head="Convoker's Horn +3",
		neck="Fotia Gorget",
		ear1="Zennaroi Earring",
		ear2="Telos Earring",
		body="Tali'ah Manteel +2",
		hands="Tali'ah Gages +2",
		ring1="Rajas Ring",
		ring2="Varar Ring +1",
		back={ name="Campestres's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10',}},
		waist="Fotia Belt",
		legs={ name="Telchine Braconi", augments={'Accuracy+17','Weapon Skill Acc.+14','Weapon skill damage +3%',}},
		feet="Convoker's Pigaches +3"
	}

	sets.midcast["Cataclysm"] = sets.midcast.Nuke



end
