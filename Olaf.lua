if GetObjectName(GetMyHero()) ~= "Olaf" then return end

local v = 9

GetWebResultAsync("https://raw.githubusercontent.com/wildrelic/GoS/master/Olaf.version", function(num)
	if v < tonumber(num) then
		DownloadFileAsync("https://raw.githubusercontent.com/wildrelic/GoS/master/Olaf.lua", SCRIPT_PATH .. "Olaf.lua", function() PrintChat("[Olaf] Updated") end)
	end
end)

require("OpenPredict")

if FileExist(COMMON_PATH.."MixLib.lua") then
	require('MixLib')
else
	PrintChat("MixLib not found. Please wait for download.")
	DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


--Menu--
OlafMenu = Menu("Olaf", "Olaf")
-----------------------------------------------------------------
OlafMenu:SubMenu("Combo", "Combo")
OlafMenu.Combo:Boolean("Q", "Use Q", true)
OlafMenu.Combo:Boolean("W", "Use W", true)
OlafMenu.Combo:Slider("uW", "Use W under % HP", 75, 0, 100, 5)
OlafMenu.Combo:Boolean("E", "Use E", true)
-----------------------------------------------------------------
OlafMenu:SubMenu("Harass", "Harass")
OlafMenu.Harass:Boolean("Q", "Use Q", true)
OlafMenu.Harass:Boolean("W", "Use W", true)
OlafMenu.Harass:Slider("uW", "Use W under % HP", 75, 0, 100, 5)
OlafMenu.Harass:Boolean("E", "Use E", true)
-----------------------------------------------------------------
OlafMenu:SubMenu("LC", "LaneClear")
OlafMenu.LC:Boolean("Q", "Use Q", true)
OlafMenu.LC:Boolean("W", "Use W", true)
OlafMenu.LC:Boolean("E", "Use E", true)
-----------------------------------------------------------------
OlafMenu:SubMenu("JC", "JungleClear")
OlafMenu.JC:Boolean("Q", "Use Q", true)
OlafMenu.JC:Boolean("W", "Use W", true)
OlafMenu.JC:Boolean("E", "Use E", true)
-----------------------------------------------------------------
OlafMenu:SubMenu("LH", "Last Hit")
OlafMenu.LH:Boolean("Q", "Use Q", false)
OlafMenu.LH:Boolean("E", "Use E", true)
-----------------------------------------------------------------
OlafMenu:SubMenu("KS", "Killsteal")
OlafMenu.KS:Boolean("Q", "Use Q", true)
OlafMenu.KS:Boolean("E", "Use E", true)
-----------------------------------------------------------------
OlafMenu:SubMenu("Ign", "Auto Ignite")
OlafMenu.Ign:Boolean("AIgn", "Use Auto Ignite", true)
-----------------------------------------------------------------
OlafMenu:SubMenu("AutoR", "Auto R")
OlafMenu.AutoR:Boolean("R", "Use R", true)
OlafMenu.AutoR:Slider("hR", "Use R under % HP", 50, 0, 100, 5)
OlafMenu.AutoR:Slider("cR", "Use R around # Enemies", 1, 0, 5, 1)
-----------------------------------------------------------------
OlafMenu:SubMenu("Draw", "Drawings")
OlafMenu.Draw:Boolean("DrawQ", "Draw Q Range", true)
OlafMenu.Draw:Boolean("DrawW", "Draw W", true)
OlafMenu.Draw:Boolean("DrawE", "Draw E Range", true)
OlafMenu.Draw:Boolean("DrawR", "Draw R", true)
OlafMenu.Draw:Boolean("DrawAxe", "Draw Axe Circle", true)
OlafMenu.Draw:Boolean("DrawDMG", "Draw DMG", true)
OlafMenu.Draw:Boolean("MinCirc", "Minion Killable by E", true)
-----------------------------------------------------------------

local OlafQ = {delay = 0.25, speed = 1550, width = 100, range = 1000}
local CCType = {[5] = "Stun", [7] = "Silence", [8] = "Taunt", [9] = "Polymorph", [11] = "Snare", [21] = "Fear", [22] = "Charm", [24] = "Suppression"}

OnUpdateBuff(function(unit, buff)
	if unit.isMe and CCType[buff.Type] and OlafMenu.AutoR.R:Value() and Ready(_R) and GetPercentHP(myHero) <= OlafMenu.AutoR.hR:Value() and EnemiesAround(myHeroPos(), 1000) >= OlafMenu.AutoR.cR:Value() then
		CastSpell(_R)
	end
end)

OnObjectLoad(function(Object)
	if GetObjectBaseName(Object) == "olaf_axe_totem_team_id_green.troy" then
		AxeOlaf = Object
	end
end)

OnCreateObj(function(Object)
	if GetObjectBaseName(Object) == "olaf_axe_totem_team_id_green.troy" then
		AxeOlaf = Object
	end
end)

OnDeleteObj(function(Object)
	if GetObjectBaseName(Object) == "olaf_axe_totem_team_id_green.troy" then
		AxeOlaf = nil
	end
end)

OnTick(function()
	local target = GetCurrentTarget()
	
--Combo--

	if Mix:Mode() == "Combo" then
		if OlafMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 325) then
			CastTargetSpell(target, _E)
			end
		if OlafMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 250) and GetPercentHP(myHero) <= OlafMenu.Harass.uW:Value() then
			CastSpell(_W)
			end
		if OlafMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 1000) then
			local QPred = GetLinearAOEPrediction(target, OlafQ)
			if QPred.hitChance >= 0.3 then
				CastSkillShot(_Q, QPred.castPos)
			end
		end
	end

--Harass--

	if Mix:Mode() == "Harass" then
		if OlafMenu.Harass.E:Value() and Ready(_E) and ValidTarget(target, 325) then
			CastTargetSpell(target, _E)
			end
		if OlafMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 250) and GetPercentHP(myHero) <= OlafMenu.Harass.uW:Value() then
			CastSpell(_W)
			end
		if OlafMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 1000) then
			local QPred = GetLinearAOEPrediction(target, OlafQ)
			if QPred.hitChance >= 0.3 then
				CastSkillShot(_Q, QPred.castPos)
			end
		end
	end

	for _,enemy in pairs(GetEnemyHeroes()) do
	
--Killsteal--
	
		if OlafMenu.KS.Q:Value() and Ready(_Q) and ValidTarget(enemy, 1000) then
			if GetCurrentHP(enemy) + GetDmgShield(enemy) < CalcDamage(myHero, enemy, 25 + 45 * GetCastLevel(myHero, _Q) + GetBonusDmg(myHero), 0) then
				local QPred = GetLinearAOEPrediction(enemy, OlafQ)
				if QPred.hitChance >= 0.3 then
					CastSkillShot(_Q, QPred.castPos)
				end
			end
		end
		if OlafMenu.KS.E:Value() and Ready(_Q) and ValidTarget(enemy, 325) then
			local eDmg = 25 + 45 * GetCastLevel(myHero, _E) + myHero.totalDamage * 0.4
			if GetCurrentHP(enemy) + GetDmgShield(enemy) < eDmg then
				CastTargetSpell(enemy, _E)
			end
		end
		
--Auto Ignite When Killable--
		
		if OlafMenu.Ign.AIgn:Value() then
			if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
				Ignite = SUMMONER_1
				if ValidTarget(enemy, 600) then
					if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
						CastTargetSpell(enemy, Ignite)
					end
				end
			elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
				Ignite = SUMMONER_2
				if ValidTarget(enemy, 600) then
					if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
						CastTargetSpell(enemy, Ignite)
					end
				end
			end
		end
		--if OlafMenu.AutoR.R:Value() and Ready(_R) and GetPercentHP(myHero) <= OlafMenu.AutoR.hR:Value() and EnemiesAround(myHeroPos(), 1000) >= 1 and EnemiesAround(myHeroPos(), 1000) >= OlafMenu.AutoR.cR:Value() and GotBuff(myHero, "rocketgrab2") > 0 or GotBuff(myHero, "charm") > 0 or GotBuff(myHero, "fear") > 0 or GotBuff(myHero, "flee") > 0 or GotBuff(myHero, "snare") > 0 or GotBuff(myHero, "taunt") > 0 or GotBuff(myHero, "suppression") > 0 or GotBuff(myHero, "stun") > 0 or GotBuff(myHero, "summonerexhaust") > 0 then
			--CastSpell(_R)
		--end
	end
	
	for _,mob in pairs(minionManager.objects) do
	
--LaneClear / JungleClear--
	
		if Mix:Mode() == "LaneClear" then
			if GetTeam(mob) == MINION_ENEMY then
				if OlafMenu.LC.E:Value() and Ready(_E) and ValidTarget(mob, 325) then
					local eDmg = 25 + 45 * GetCastLevel(myHero, _E) + GetBaseDamage(myHero) * 0.4
					if GetCurrentHP(mob) + GetDmgShield(mob) < eDmg then
						CastTargetSpell(mob, _E)
						end
					end
				if OlafMenu.LC.W:Value() and Ready(_W) and ValidTarget(mob, 225) then
					CastSpell(_W)
					end
				if OlafMenu.LC.Q:Value() and Ready(_Q) and ValidTarget(mob, 1000) then
					CastSkillShot(_Q, mob)
					end
				end
			if GetTeam(mob) == MINION_JUNGLE then
				if OlafMenu.JC.E:Value() and Ready(_E) and ValidTarget(mob, 325) then
					CastTargetSpell(mob, _E)
					end
				if OlafMenu.JC.W:Value() and Ready(_W) and ValidTarget(mob, 225) then
					CastSpell(_W)
					end
				if OlafMenu.JC.Q:Value() and Ready(_Q) and ValidTarget(mob, 1000) then
					CastSkillShot(_Q, mob)
				end
			end
		end
		
--LastHit--
		
		if Mix:Mode() == "LastHit" then
			if GetTeam(mob) == 300 - GetTeam(myHero) then
				if OlafMenu.LH.E:Value() and Ready(_E) and ValidTarget(mob, 325) then
					local eDmg = 25 + 45 * GetCastLevel(myHero, _E) + GetBaseDamage(myHero) * 0.4
					if GetCurrentHP(mob) + GetDmgShield(mob) < eDmg then
						CastTargetSpell(mob, _E)
					end
				end
				if OlafMenu.LH.Q:Value() and Ready(_Q) and ValidTarget(mob, 1000) then
					if GetCurrentHP(mob) + GetDmgShield(mob) < CalcDamage(myHero, mob, 25 + 45 * GetCastLevel(myHero, _Q) + GetBonusDmg(myHero), 0) then
						CastSkillShot(_Q, mob)
					end
				end
			end
		end
	end
end)

--Drawings--

OnDraw(function()

local qDmg = 25 + 45 * GetCastLevel(myHero, _Q) + GetBonusDmg(myHero)
local eDmg = 25 + 45 * GetCastLevel(myHero, _E) + GetBaseDamage(myHero) * 0.4

	if IsObjectAlive(myHero) then
	
--Axe Drawings--

		if OlafMenu.Draw.DrawAxe:Value() then
			if AxeOlaf then
				DrawCircle(GetOrigin(AxeOlaf), 70, 5, 100, ARGB(100, 0, 0, 255))
			end
		end

--Q Drawings--

		if OlafMenu.Draw.DrawQ:Value() then
			if Ready(_Q) then
				DrawCircle(GetOrigin(myHero), 1000, 5, 100, ARGB(100, 0, 225, 0))
			else
				DrawCircle(GetOrigin(myHero), 1000, 5, 100, ARGB(100, 225, 0, 0))
			end
		end
		
--W Drawings--

		if OlafMenu.Draw.DrawW:Value() then
			if Ready(_W) then
				DrawCircle(GetOrigin(myHero), 200, 5, 100, ARGB(100, 0, 225, 0))
			else
				DrawCircle(GetOrigin(myHero), 200, 5, 100, ARGB(100, 225, 0, 0))
			end
		end
		
--E Drawings--

		if OlafMenu.Draw.DrawE:Value() then
			if Ready(_E) then
				DrawCircle(GetOrigin(myHero), 325, 5, 100, ARGB(100, 0, 225, 0))
			else
				DrawCircle(GetOrigin(myHero), 325, 5, 100, ARGB(100, 225, 0, 0))
			end
		end
		
--R Drawings--

		if OlafMenu.Draw.DrawR:Value() then
			if Ready(_R) then
				DrawCircle(GetOrigin(myHero), 50, 5, 50, ARGB(100, 0, 225, 0))
			else
				DrawCircle(GetOrigin(myHero), 50, 5, 50, ARGB(100, 225, 0, 0))
			end
		end
		
--Dmg Drawings--
		
		if OlafMenu.Draw.DrawDMG:Value() then
			for _, enemy in pairs(GetEnemyHeroes()) do
				if ValidTarget(enemy) then
					if Ready(_Q) and Ready(_E) then
						DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), CalcDamage(myHero, enemy, qDmg, 0), eDmg, GoS.White)
					elseif Ready(_Q) then
						DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), CalcDamage(myHero, enemy, qDmg, 0), 0, GoS.White)
					elseif Ready(_E) then
						DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, eDmg, GoS.White)
					end
				end
			end
		end
		
--Minion Circles--		
		
		if OlafMenu.Draw.MinCirc:Value() then
		local BaseAD = GetBaseDamage(myHero)
		local BonusAD = GetBonusDmg(myHero)
		local eDmg = 25 + 45 * GetCastLevel(myHero, _E) + GetBaseDamage(myHero) * 0.4
			for _, mob in pairs(minionManager.objects) do
				if GetTeam(mob) == 300 - GetTeam(myHero) and ValidTarget(mob, 10000) then
					if GetCurrentHP(mob) < eDmg and Ready (_E) then
						DrawCircle(GetOrigin(mob), 50, 2, 8, ARGB(100, 200, 0, 255))
					end
					if GetCurrentHP(mob) < BaseAD + BonusAD + (BaseAD + BonusAD) * 0.20 and GetCurrentHP(mob) > BaseAD + BonusAD then
						DrawCircle(GetOrigin(mob), 50, 2, 8, ARGB(100, 255, 0, 0))
					elseif GetCurrentHP(mob) < BaseAD + BonusAD then
						DrawCircle(GetOrigin(mob), 50, 2, 8, ARGB(100, 0, 255, 0))
					end
				end
			end
		end
	end
end)
