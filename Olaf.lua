if GetObjectName(GetMyHero()) ~= "Olaf" then return end

local v = 3

GetWebResultAsync("https://raw.githubusercontent.com/wildrelic/GoS/master/Olaf.version", function(num)
	if v < tonumber(num) then
		DownloadFileAsync("https://raw.githubusercontent.com/wildrelic/GoS/master/Olaf.lua", SCRIPT_PATH .. "Olaf.lua", function() PrintChat("[Olaf] Updated") end)
	end
end)

require("OpenPredict")
require("Analytics")

if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end

Analytics("Olaf.lua", "wildrelic", true)

--Menu--
OlafMenu = Menu("Olaf", "Olaf")
-----------------------------------------------------------------
OlafMenu:SubMenu("Combo", "Combo")
OlafMenu.Combo:Boolean("Q", "Use Q", true)
OlafMenu.Combo:Boolean("W", "Use W", true)
OlafMenu.Combo:Slider("uW", "Use W at % HP", 75, 5, 100, 5)
OlafMenu.Combo:Boolean("E", "Use E", true)
-----------------------------------------------------------------
OlafMenu:SubMenu("Harass", "Harass")
OlafMenu.Harass:Boolean("Q", "Use Q", true)
OlafMenu.Harass:Boolean("W", "Use W", true)
OlafMenu.Harass:Slider("uW", "Use W at % HP", 75, 5, 100, 5)
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
OlafMenu:SubMenu("Draw", "Drawings")
OlafMenu.Draw:Boolean("DrawQ", "Draw Q Range", true)
OlafMenu.Draw:Boolean("DrawE", "Draw E Range", true)
OlafMenu.Draw:Boolean("DrawAxe", "Draw Axe Circle", true)
-----------------------------------------------------------------

local OlafQ = {delay = 0.25, speed = 1550, width = 100, range = 1000}

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
		if OlafMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 250) and GetPercent(myHero) <= OlafMenu.Harass.uW:Value() then
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
		if OlafMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 250) and GetPercent(myHero) <= OlafMenu.Harass.uW:Value() then
			CastSpell(_W)
			end
		if OlafMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 1000) then
			local QPred = GetLinearAOEPrediction(target, OlafQ)
			if QPred.hitChance >= 0.3 then
				CastSkillShot(_Q, QPred.castPos)
			end
		end
	end
	
--Killsteal--

	for _,enemy in pairs(GetEnemyHeroes()) do
		if OlafMenu.KS.Q:Value() and Ready(_Q) and ValidTarget(enemy, 1000) then
			if GetCurrentHP(enemy) + GetDmgShield(enemy) < CalcDamage(myHero, enemy, 25 + 45 * GetCastLevel(myHero, _Q), 0) + GetBonusDmg(myHero) * 1 then
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
	end
	
--LaneClear / JungleClear--

	if Mix:Mode() == "LaneClear" then
		for _, mob in pairs(minionManager.objects) do
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
	end
	
--LastHit--
	
	if Mix:Mode() == "LastHit" then
		for _, mob in pairs(minionManager.objects) do
			if GetTeam(mob) == MINION_ENEMY then
				if OlafMenu.LH.E:Value() and Ready(_E) and ValidTarget(mob, 325) then
					local eDmg = 25 + 45 * GetCastLevel(myHero, _E) + GetBaseDamage(myHero) * 0.4
					if GetCurrentHP(mob) + GetDmgShield(mob) < eDmg then
						CastTargetSpell(mob, _E)
					end
				end
				if OlafMenu.LH.Q:Value() and Ready(_Q) and ValidTarget(mob, 1000) then
					if GetCurrentHP(mob) + GetDmgShield(mob) < CalcDamage(myHero, mob, GetCastLevel(myHero, _Q) * 45 + 25, 0) + GetBonusDmg(myHero) * 1 then
						CastSkillShot(_Q, mob)
					end
				end
			end
		end
	end
end)

--Drawings--

OnDraw(function(myHero)

--Axe Drawings--

	if OlafMenu.Draw.DrawAxe:Value() then
		if AxeOlaf then
			DrawCircle(GetOrigin(AxeOlaf), 70, 5, 100, ARGB(100, 0, 0, 255))
		end
	end

	if IsObjectAlive(myHero) then
	
--Q Drawings--

		if OlafMenu.Draw.DrawQ:Value() then
			if Ready(_Q) then
				DrawCircle(GetOrigin(myHero), 1000, 5, 100, ARGB(100, 0, 225, 0))
			else
				DrawCircle(GetOrigin(myHero), 1000, 5, 100, ARGB(100, 225, 0, 0))
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
	end
end)
