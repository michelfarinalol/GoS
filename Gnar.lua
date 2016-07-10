if GetObjectName(GetMyHero()) ~= "Gnar" then return end

local v = 0.18

GetWebResultAsync("https://raw.githubusercontent.com/wildrelic/GoS/master/Gnar.version", function(num)
	if v < tonumber(num) then
		PrintChat("[Gnar] Update Available. x2 f6 to Update.")
		DownloadFileAsync("https://raw.githubusercontent.com/wildrelic/GoS/master/Gnar.lua", SCRIPT_PATH .. "Gnar.lua", function() PrintChat("Enjoy your game!") return end)
	end
end)

require("OpenPredict")
require("MapPositionGos")
require("DamageLib")

if FileExist(COMMON_PATH.."MixLib.lua") then
	require('MixLib')
else
	PrintChat("MixLib not found. Please wait for download.")
	DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end

--Menu--
GnarMenu = Menu("Gnar", "Gnar")
-----------------------------------------------------------------
GnarMenu:SubMenu("Combo", "Combo")
GnarMenu.Combo:Boolean("Q", "Use Mini Gnar Q", true)
GnarMenu.Combo:Boolean("mQ", "Mini Gnar Q Through Minions", true)
GnarMenu.Combo:Boolean("MQ", "Use Mega Gnar Q", true)
GnarMenu.Combo:Boolean("W", "Use Mega Gnar W", true)
--GnarMenu.Combo:Boolean("mE", "Use Mini Gnar E", false)
--GnarMenu.Combo:Boolean("ekmE", "Use Mini Gnar E if Killable", false)
--GnarMenu.Combo:Slider("cmE", "Use Mini Gnar E Around # of Enemies", 1, 0, 5, 1)
--GnarMenu.Combo:Slider("hmE", "Use Mini Gnar E Above % Gnar Health", 75, 0, 100, 5)
GnarMenu.Combo:Boolean("tE", "Use E When Transforming", true)
GnarMenu.Combo:Boolean("E", "Use Mega Gnar E", true)
GnarMenu.Combo:Boolean("R", "Use R", true)
GnarMenu.Combo:Slider("eR", "Use R Only on # of Enemies", 2, 1, 5, 1)
GnarMenu.Combo:Boolean("aR", "Auto Use R", true)
GnarMenu.Combo:Slider("aeR", "Auto Use R on # of Enemies", 3, 1, 5, 1)
-----------------------------------------------------------------
GnarMenu:SubMenu("Harass", "Harass")
GnarMenu.Harass:Boolean("Q", "Use Mini Gnar Q", true)
GnarMenu.Harass:Boolean("mQ", "Use Mini Gnar Q through Minions", true)
GnarMenu.Harass:Boolean("MQ", "Use Mega Gnar Q", true)
GnarMenu.Harass:Boolean("W", "Use Mega Gnar W", true)
GnarMenu.Harass:Boolean("E", "Use Mega Gnar E", true)
GnarMenu.Harass:Boolean("mE", "Use Mini Gnar E", true)
-----------------------------------------------------------------
GnarMenu:SubMenu("LC", "LaneClear")
GnarMenu.LC:Boolean("Q", "Use Mini Gnar Q", true)
GnarMenu.LC:Boolean("MQ", "Use Mega Gnar Q", true)
GnarMenu.LC:Boolean("W", "Use Mega Gnar W", true)
GnarMenu.LC:Boolean("E", "Use Mega Gnar E", false)
-----------------------------------------------------------------
GnarMenu:SubMenu("JC", "JungleClear")
GnarMenu.JC:Boolean("Q", "Use Mini Gnar Q", true)
GnarMenu.JC:Boolean("MQ", "Use Mega Gnar Q", true)
GnarMenu.JC:Boolean("W", "Use Mega Gnar W", true)
GnarMenu.JC:Boolean("E", "Use Mega Gnar E", false)
-----------------------------------------------------------------
GnarMenu:SubMenu("LH", "LastHit")
GnarMenu.LH:Boolean("Q", "Use Mini Gnar Q", true)
GnarMenu.LH:Boolean("MQ", "Use Mega Gnar Q", false)
GnarMenu.LH:Boolean("W", "Use Mega Gnar W", false)
GnarMenu.LH:Boolean("E", "Use Mega Gnar E", false)
-----------------------------------------------------------------
GnarMenu:SubMenu("KS", "Killsteal")
GnarMenu.KS:Boolean("Q", "Use Mini Gnar Q", true)
GnarMenu.KS:Boolean("MQ", "Use Mega Gnar Q", true)
GnarMenu.KS:Boolean("W", "Use Mega Gnar W", true)
GnarMenu.KS:Boolean("E", "Use Mega Gnar E", false)
GnarMenu.KS:Boolean("R", "Use R", false)
-----------------------------------------------------------------
GnarMenu:SubMenu("p", "Prediction")
GnarMenu.p:Slider("mpQ", "Mini Gnar Q Hitchance", 20, 0, 100, 5)
GnarMenu.p:Slider("MpQ", "Mega Gnar Q Hitchance", 20, 0, 100, 5)
GnarMenu.p:Slider("pW", "Mega Gnar W Hitchance", 20, 0, 100, 5)
GnarMenu.p:Slider("mpE", "Mini Gnar E Hitchance", 20, 0, 100, 5)
GnarMenu.p:Slider("MpE", "Mega Gnar E Hitchance", 20, 0, 100, 5)
GnarMenu.p:Slider("pR", "Gnar R Hitchance", 20, 0, 100, 5)
-----------------------------------------------------------------
GnarMenu:SubMenu("Draw", "Drawings")
GnarMenu.Draw:Boolean("Q", "Draw Q Range", true)
GnarMenu.Draw:Boolean("W", "Draw W Range", true)
GnarMenu.Draw:Boolean("E", "Draw E Range", true)
GnarMenu.Draw:Boolean("R", "Draw R Range", true)
--GnarMenu.Draw:Boolean("DrawQ1", "Draw Mini Gnar Q", true)
GnarMenu.Draw:Boolean("DrawQ2", "Draw Mega Gnar Q Rock", true)
--GnarMenu.Draw:Boolean("DrawDMG", "Draw DMG", true)
GnarMenu.Draw:Boolean("MinQCirc", "Minion Killable by Q", true)
GnarMenu.Draw:Boolean("MinAACirc", "Minion Killable by AA", true)
-----------------------------------------------------------------

--OnProcessSpell(function(unit,spellProc)
--if unit.isMe then
--print(spellProc.name)
--end
--end)

--OnCreateObj(function(Object)
--if Object.isSpell and Object.spellOwner.isMe then
--print(Object.spellName)
--end
--end)

--OnUpdateBuff(function(unit, buff)
--if unit.isMe then
--print(buff.Name)
--end
--end)

local MiniGnarQ = {delay = 0.25, speed = 1225, width = 60, range = 1200}
local MegaGnarQ = {delay = 0.5, speed = 2100, width = 90, range = 1150}
local MegaGnarW = {delay = 0.6, speed = math.huge, width = 80, range = 600}
local MiniGnarE = {delay = 0, speed = 903, width = 150, range = 473}
local MegaGnarE = {delay = 0.25, speed = 1000, width = 200, range = 475}
local MegaGnarR = {delay = 0.25, speed = math.huge, width = 500, range = 0}

OnObjectLoad(function(Object)
	--if GetObjectBaseName(Object) == "Gnar_Base_Q_mis.troy" then
		--mGnarQ = Object
	--end
	--if GetObjectBaseName(Object) == "Gnar_Base_Q_mis.troy" then
		--mGnarQ2 = Object
	--end
	if GetObjectBaseName(Object) == "GnarBig_Base_Q_Rock_Ground.troy" then
		MGnarQ = Object
	end
end)

OnCreateObj(function(Object)
	--if GetObjectBaseName(Object) == "Gnar_Base_Q_mis.troy" then
		--mGnarQ = Object
	--end
	--if GetObjectBaseName(Object) == "Gnar_Base_Q_mis.troy" then
		--mGnarQ2 = Object
	--end
	if GetObjectBaseName(Object) == "GnarBig_Base_Q_Rock_Ground.troy" then
		MGnarQ = Object
	end
end)

OnDeleteObj(function(Object)
	--if GetObjectBaseName(Object) == "Gnar_Base_Q_mis.troy" then
		--mGnarQ = nil
	--end
	--if GetObjectBaseName(Object) == "Gnar_Base_Q_mis.troy" then
		--mGnarQ2 = nil
	--end
	if GetObjectBaseName(Object) == "GnarBig_Base_Q_Rock_Ground.troy" then
		MGnarQ = nil
	end
end)

OnTick(function()
	local target = GetCurrentTarget()
	local mQPred = GetLinearAOEPrediction(target, MiniGnarQ)
	local MQPred = GetPrediction(target, MegaGnarQ)
	local WPred = GetLinearAOEPrediction(target, MegaGnarW)
	local mEPred = GetCircularAOEPrediction(target, MiniGnarE)
	local MEPred = GetCircularAOEPrediction(target, MegaGnarE)
	local RPred = GetCircularAOEPrediction(target, MegaGnarR)
	local MiniGnar = (GotBuff(myHero, "gnartransform") == 0 or GotBuff(myHero, "gnarfuryhigh") == 1)
	local MegaGnar = (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1)
		
	if Mix:Mode() == "Combo" then
		if GnarMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 1200) and not IsDead(target) and GetCastName(myHero, _Q) == "GnarQ" and MiniGnar then
			if mQPred and mQPred.hitChance >= (GnarMenu.p.mpQ:Value()/100) and not mQPred:mCollision(1) and not mQPred:hCollision(1) then
				CastSkillShot(_Q, mQPred.castPos)
			end
		--elseif GnarMenu.Combo.Q:Value() and GnarMenu.Combo.mQ:Value() and Ready(_Q) and ValidTarget(target, 1200) and GetCastName(myHero, _Q) == "GnarQ" and (GotBuff(myHero, "gnartransform") == 0 or GotBuff(myHero, "gnarfuryhigh") == 1) then
			--if mQPred and mQPred.hitChance >= (GnarMenu.p.mpQ:Value()/100) and (mQPred:mCollision(2) or mQPred:hCollision(1)) then
				--CastSkillShot(_Q, mQPred.castPos)
			--end
		end
		if GnarMenu.Combo.MQ:Value() and Ready(_Q) and ValidTarget(target, 1150) and not IsDead(target) and GetCastName(myHero, _Q) == "GnarBigQ" and MegaGnar then
			if MQPred and MQPred.hitChance >= (GnarMenu.p.MpQ:Value()/100) and not mQPred:mCollision(1) and not mQPred:hCollision(1) then
				CastSkillShot(_Q, MQPred.castPos)
			end
		end
		if GnarMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 600) and not IsDead(target) and GetCastName(myHero, _W) == "GnarBigW" and MegaGnar then
			if WPred and WPred.hitChance >= (GnarMenu.p.pW:Value()/100) then
				CastSkillShot(_W, WPred.castPos)
			end
		end
		--if GnarMenu.Combo.mE:Value() and Ready(_E) and ValidTarget(target, 473) and GetCastName(myHero, _E) == "GnarE"
		--if GnarMenu.Combo.tE:Value() and Ready(_E) and ValidTarget(target, 475) and GetCastName(myHero, _E) == "GnarBigE" and GotBuff(myHero, "gnartransformsoon") == 1 and GetCurrentMana(myHero) >= 100 then
			--if MEPred and MEPred.hitChance >= (GnarMenu.p.MpE:Value()/100) then
				--CastSkillShot(_E, MEPred.castPos)
			--end
		--end
		if GnarMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 475) and not IsDead(target) and GetCastName(myHero, _E) == "GnarBigE" and GotBuff(myHero, "gnartransform") == 1 then
			if MEPred and MEPred.hitChance >= (GnarMenu.p.MpE:Value()/100) then
				CastSkillShot(_E, MEPred.castPos)
			end
		end
	end
	if Mix:Mode() == "Harass" then
		if GnarMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 1200) and not IsDead(target) and GetCastName(myHero, _Q) == "GnarQ" and MiniGnar then
			if mQPred and mQPred.hitChance >= (GnarMenu.p.mpQ:Value()/100) and not mQPred:mCollision(1) and not mQPred:hCollision(1) then
				CastSkillShot(_Q, mQPred.castPos)
			end
		--elseif GnarMenu.Harass.Q:Value() and GnarMenu.Harass.mQ:Value() and Ready(_Q) and ValidTarget(target, 1200) and GetCastName(myHero, _Q) == "GnarQ" and (GotBuff(myHero, "gnartransform") == 0 or GotBuff(myHero, "gnarfuryhigh") == 1) then
			--if mQPred and mQPred.hitChance >= (GnarMenu.p.mpQ:Value()/100) and (mQPred:mCollision(2) or mQPred:hCollision(1)) then
				--CastSkillShot(_Q, mQPred.castPos)
			--end
		end
		if GnarMenu.Harass.MQ:Value() and Ready(_Q) and ValidTarget(target, 1150) and not IsDead(target) and GetCastName(myHero, _Q) == "GnarBigQ" and MegaGnar then
			if MQPred and MQPred.hitChance >= (GnarMenu.p.MpQ:Value()/100) and not MQPred:mCollision(1) and not MQPred:hCollision(1) then
				CastSkillShot(_Q, MQPred.castPos)
			end
		end
		if GnarMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 600) and not IsDead(target) and GetCastName(myHero, _W) == "GnarBigW" and MegaGnar then
			if WPred and WPred.hitChance >= (GnarMenu.p.MpW:Value()/100) then
				CastSkillShot(_W, WPred.castPos)
			end
		end
		if GnarMenu.Harass.E:Value() and Ready(_E) and ValidTarget(target, 475) and not IsDead(target) and GetCastName(myHero, _E) == "GnarBigE" and (GotBuff(myHero, "gnartransform") == 1) then
			if MEPred and MEPred.hitChance >= (GnarMenu.p.MpE:Value()/100) then
				CastSkillShot(_E, MEPred.castPos)
			end
		end
	end
	for _,mob in pairs(minionManager.objects) do
		if Mix:Mode() == "LaneClear" then
			if GetTeam(mob) == MINION_ENEMY then
				if GnarMenu.LC.Q:Value() and Ready(_Q) and ValidTarget(mob, 1200) and not IsDead(mob) and GetCastName(myHero, _Q) == "GnarQ" and MiniGnar then
					if (GetCurrentHP(mob) + GetDmgShield(mob) < CalcDamage(myHero, mob, -30 + 30 * GetCastLevel(myHero, _Q) + myHero.totalDamage * 1.15, 0)) and not mQPred:mCollision(1) and not mQPred:hCollision(1) then
						CastSkillShot(_Q, mob)
					end
				--elseif GnarMenu.LC.Q:Value() and Ready(_Q) and ValidTarget(mob, 1200) and GetCastName(myHero, _Q) == "GnarQ" and (GotBuff(myHero, "gnartransform") == 0 or GotBuff(myHero, "gnarfuryhigh") ==1) and (mQPred:mCollision(2) or mQPred:hCollision(1)) then
					--if GetCurrentHP(mob) + GetDmgShield(mob) < CalcDamage(myHero, mob, -30 + 30 * GetCastLevel(myHero, _Q) + myHero.totalDamage * 1.15 * 0.5, 0) then
						--CastSkillShot(_Q, mob)
					--end
				end
				if GnarMenu.LC.MQ:Value() and Ready(_Q) and ValidTarget(mob, 1150) and not IsDead(mob) and GetCastName(myHero, _Q) == "GnarBigQ" and MegaGnar then
					CastSkillShot(_Q, mob)
				end
				if GnarMenu.LC.W:Value() and Ready(_W) and ValidTarget(mob, 600) and not IsDead(mob) and GetCastName(myHero, _W) == "GnarBigW" and MegaGnar then
					CastSkillShot(_W, mob)
				end
				if GnarMenu.LC.E:Value() and Ready(_E) and ValidTarget(mob, 475) and not IsDead(mob) and GetCastName(myHero, _E) == "GnarBigE" and GotBuff(myHero, "gnartransform") == 1 then
					CastSkillShot(_E, mob)
				end
			end
			if GetTeam(mob) == MINION_JUNGLE then
				if GnarMenu.JC.Q:Value() and Ready(_Q) and ValidTarget(mob, 1200) and not IsDead(mob) and GetCastName(myHero, _Q) == "GnarQ" and MiniGnar then
					CastSkillShot(_Q, mob)
				end
				if GnarMenu.JC.MQ:Value() and Ready(_Q) and ValidTarget(mob, 1150) and not IsDead(mob) and GetCastName(myHero, _Q) == "GnarBigQ" and MegaGnar then
					CastSkillShot(_Q, mob)
				end
				if GnarMenu.JC.W:Value() and Ready(_W) and ValidTarget(mob, 600) and not IsDead(mob) and GetCastName(myHero, _W) == "GnarBigW" and MegaGnar then
					CastSkillShot(_W, mob)
				end
				if GnarMenu.JC.E:Value() and Ready(_E) and ValidTarget(mob, 475) and not IsDead(mob) and GetCastName(myHero, _W) == "GnarBigW" and GotBuff(myHero, "gnartransform") == 1 then
					CastSkillShot(_E, mob)
					end
				end
			end
		if Mix:Mode() == "LastHit" then
			if GetTeam(mob) == MINION_ENEMY then
				if GnarMenu.LH.Q:Value() and Ready(_Q) and ValidTarget(mob, 1200) and not IsDead(mob) and GetCastName(myHero, _Q) == "GnarQ" and MiniGnar then
					if (GetCurrentHP(mob) + GetDmgShield(mob) < CalcDamage(myHero, mob, -30 + 30 * GetCastLevel(myHero, _Q) + myHero.totalDamage * 1.15, 0)) and not mQPred:mCollision(1) and not mQPred:hCollision(1) then
						CastSkillShot(_Q, mob)
					end
				elseif GnarMenu.LH.Q:Value() and Ready(_Q) and ValidTarget(mob, 1200) and not IsDead(mob) and GetCastName(myHero, _Q) == "GnarQ" and MiniGnar then
					if (GetCurrentHP(mob) + GetDmgShield(mob) < CalcDamage(myHero, mob, -30 + 30 * GetCastLevel(myHero, _Q) + myHero.totalDamage * 1.15 * 0.5, 0)) and (mQPred:mCollision(2) or mQPred:hCollision(1)) then
						CastSkillShot(_Q, mob)
					end
				end
				if GnarMenu.LH.MQ:Value() and Ready(_Q) and ValidTarget(mob, 1150) and not IsDead(mob) and GetCastName(myHero, _Q) == "GnarBigQ" and MegaGnar then
					if GetCurrentHP(mob) + GetDmgShield(mob) < CalcDamage(myHero, mob, -35 + 40 * GetCastLevel(myHero, _Q) + myHero.totalDamage * 1.2, 0) and not MQPred:mCollision(1) and not MQPred:hCollision(1) then
						CastSkillShot(_Q, mob)
					end
				end
				if GnarMenu.LH.W:Value() and Ready(_W) and ValidTarget(mob, 600) and not IsDead(mob) and GetCastName(myHero, _W) == "GnarBigW" and MegaGnar then
					if GetCurrentHP(mob) + GetDmgShield(mob) < CalcDamage(myHero, mob, 5 + 20 * GetCastLevel(myHero, _W) + myHero.totalDamage, 0) then
						CastSkillShot(_W, mob)
					end
				end
				if GnarMenu.LH.E:Value() and Ready(_E) and ValidTarget(mob, 475) and not IsDead(mob) and GetCastName(myHero, _E) == "GnarBigE" and GotBuff(myHero, "gnartransform") == 1 then
					if GetCurrentHP(mob) + GetDmgShield(mob) < CalcDamage(myHero, mob, -20 + 40 * GetCastLevel(myHero, _E) + GetMaxHP(myHero) * 0.06, 0) then
						CastSkillShot(_E, mob)
					end
				end
			end
		end
	end
	for _,enemy in pairs(GetEnemyHeroes()) do	
		if GnarMenu.KS.Q:Value() and Ready(_Q) and ValidTarget(enemy) and not IsDead(enemy) and GetCastName(myHero, _Q) == "GnarQ" and MiniGnar then
			if GetCurrentHP(enemy) + GetDmgShield(enemy) < CalcDamage(myHero, enemy, -30 + 30 * GetCastLevel(myHero, _Q) + myHero.totalDamage * 1.15, 0) then
				if mQPred and mQPred.hitChance >= (GnarMenu.p.mpQ:Value()/100) and not mQPred:mCollision(1) and not mQPred:hCollision(1) then
					CastSkillShot(_Q, mQPred.castPos)
				end
			end
		end
		if GnarMenu.KS.MQ:Value() and Ready(_Q) and ValidTarget(enemy) and not IsDead(enemy) and GetCastName(myHero, _Q) == "GnarBigQ" and MegaGnar then
			if GetCurrentHP(enemy) + GetDmgShield(enemy) < CalcDamage(myHero, enemy, -35 + 40 * GetCastLevel(myHero, _Q) + myHero.totalDamage * 1.2, 0) then
				if MQPred and MQPred.hitChance >= (GnarMenu.p.MpQ:Value()/100) and not MQPred:mCollision(1) and not MQPred:hCollision(1) then
					CastSkillShot(_Q, MQPred.castPos)
				end
			end
		end
		if GnarMenu.KS.W:Value() and Ready(_W) and ValidTarget(enemy) and not IsDead(enemy) and GetCastName(myHero, _W) == "GnarBigW" and (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1) then
			if GetCurrentHP(enemy) + GetDmgShield(enemy) < CalcDamage(myHero, enemy, 5 + 20 * GetCastLevel(myHero, _W) + myHero.totalDamage, 0) then
				if MWPred and MWPred.hitChance >= (GnarMenu.p.MpW:Value()/100) then
					CastSkillShot(_Q, MWPred.castPos)
				end
			end
		end
		if GnarMenu.KS.E:Value() and Ready(_E) and ValidTarget(enemy) and not IsDead(enemy) and GetCastName(myHero, _E) == "GnarBigE" and MegaGnar then
			if GetCurrentHP(enemy) + GetDmgShield(enemy) < CalcDamage(myHero, enemy, -20 + 40 * GetCastLevel(myHero, _E) + GetMaxHP(myHero) * 0.06, 0) then
				if MEPred and MEPred.hitChance >= (GnarMenu.p.MpE:Value()/100) then
					CastSkillShot(_Q, MEPred.castPos)
				end
			end
		end
		--if GnarMenu.Combo.aR:Value() and GnarMenu.Combo.aeR:Value() and Ready(_R) and (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1) then
			--local aRPred = GetCircularAOEPrediction(enemy, MegaGnarR)
			--local RPos = Vector(aRPred)
			--for Stun = 0, 590, GetHitBox(enemy) do
				
	end
end)

OnDraw(function()
	local MiniGnar = (GotBuff(myHero, "gnartransform") == 0 or GotBuff(myHero, "gnarfuryhigh") == 1)
	local MegaGnar = (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1)

	if IsObjectAlive(myHero) then
		--if GnarMenu.Draw.DrawQ1:Value() then
			--if mGnarQ then
				--DrawCircle(GetOrigin(mGnarQ), 70, 5, 100, ARGB(255, 0, 0, 255))
			--end
		--end
		--if GnarMenu.Draw.DrawQ1:Value() then
			--if mGnarQ2 then
				--DrawCircle(GetOrigin(mGnarQ2), 70, 5, 100, ARGB(255, 0, 0, 255))
			--end
		--end
		if GnarMenu.Draw.DrawQ2:Value() then
			if MGnarQ then
				DrawCircle(GetOrigin(MGnarQ), 90, 5, 100, ARGB(225, 0, 0, 255))
			end
		end
		if GnarMenu.Draw.Q:Value() then
			if Ready(_Q) and GotBuff(myHero, "gnartransform") == 0 then
				DrawCircle(GetOrigin(myHero), 1200, 5, 100, ARGB(100, 0, 255, 0))
			elseif not Ready(_Q) and GotBuff(myHero, "gnartransform") == 0 then
				DrawCircle(GetOrigin(myHero), 1200, 5, 100, ARGB(100, 255, 0, 0))
			elseif Ready (_Q) and (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1) then
				DrawCircle(GetOrigin(myHero), 1150, 5, 100, ARGB(100, 0, 255, 0))
			elseif not Ready(_Q) and (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1) then
				DrawCircle(GetOrigin(myHero), 1150, 5, 100, ARGB(100, 255, 0, 0))
			end
		end
		if GnarMenu.Draw.W:Value() then
			if Ready(_W) and GotBuff(myHero, "gnartransform") == 1 then
				DrawCircle(GetOrigin(myHero), 600, 5, 100, ARGB(100, 255, 0, 0))
			elseif not Ready(_W) and GotBuff(myHero, "gnartransform") == 1 then
				DrawCircle(GetOrigin(myHero), 600, 5, 100, ARGB(100, 0, 255, 0))
			end
		end
		if GnarMenu.Draw.E:Value() then
			if Ready(_E) and GotBuff(myHero, "gnartransform") == 0 then
				DrawCircle(GetOrigin(myHero), 475, 5, 100, ARGB(100, 0, 255, 0))
			elseif not Ready(_E) and GotBuff(myHero, "gnartransform") == 0 then
				DrawCircle(GetOrigin(myHero), 475, 5, 100, ARGB(100, 255, 0, 0))
			elseif Ready (_E) and (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1) then
				DrawCircle(GetOrigin(myHero), 475, 5, 100, ARGB(100, 0, 255, 0))
			elseif not Ready(_E) and (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1) then
				DrawCircle(GetOrigin(myHero), 475, 5, 100, ARGB(100, 255, 0, 0))
			end
		end
		if GnarMenu.Draw.R:Value() then
			if Ready(_R) and GotBuff(myHero, "gnartransform") == 0 then
				DrawCircle(GetOrigin(myHero), 500, 5, 100, ARGB(100, 0, 255, 0))
			elseif not Ready(_R) and GotBuff(myHero, "gnartransform") == 0 then
				DrawCircle(GetOrigin(myHero), 500, 5, 100, ARGB(100, 255, 0, 0))
			elseif Ready (_R) and (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1) then
				DrawCircle(GetOrigin(myHero), 500, 5, 100, ARGB(100, 0, 255, 0))
			elseif not Ready(_R) and (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1) then
				DrawCircle(GetOrigin(myHero), 500, 5, 100, ARGB(100, 255, 0, 0))
			end
		end
		for _, mob in pairs(minionManager.objects) do
			if GetTeam(mob) == MINION_ENEMY and ValidTarget(mob, 5000)then
				if GnarMenu.Draw.MinQCirc:Value() and Ready(_Q) and MiniGnar then
					if GetCurrentHP(mob) + GetDmgShield(mob) < CalcDamage(myHero, mob, -30 + 30 * GetCastLevel(myHero, _Q) + myHero.totalDamage * 1.15, 0) then
						DrawCircle(GetOrigin(mob), 60, 2, 8, ARGB(200, 255, 115, 0))
					end
				end
				if GnarMenu.Draw.MinQCirc:Value() and Ready(_Q) and MegaGnar then
					if GetCurrentHP(mob) + GetDmgShield(mob) < CalcDamage(myHero, mob, -35 + 40 * GetCastLevel(myHero, _Q) + myHero.totalDamage * 1.2, 0) then
						DrawCircle(GetOrigin(mob), 60, 2, 8, ARGB(200, 255, 115, 0))
					end
				end
				if GnarMenu.Draw.MinAACirc:Value() then
					if GetCurrentHP(mob) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
						DrawCircle(GetOrigin(mob), 50, 2, 8, ARGB(200, 255, 255, 255))
					end
				end
			end
		end
	end
end)
