--Credits to SxcS and Zwei

local v = 0.6

GetWebResultAsync("https://raw.githubusercontent.com/wildrelic/GoS/master/BPAIO.version", function(num)
	if v < tonumber(num) then
		PrintChat("[BPAIO] Update Available. x2 f6 to Update.")
		DownloadFileAsync("https://raw.githubusercontent.com/wildrelic/GoS/master/BPAIO.lua", SCRIPT_PATH .. "BPAIO.lua", function() PrintChat("Enjoy your game!") return end)
	end
end)

require("OpenPredict")
require("DamageLib")

local BPChamps = 
	{
	["Annie"] = 		true, 
	["Ashe"] = 			true,
	["Cassiopeia"] =	true,
	["Darius"] = 		true,
	["Gnar"] = 			true,
	["Illaoi"] = 		true,
	["Irelia"] =		true,
	["Khazix"] = 		true,
	["Jinx"] =			true,
	["Jhin"] =			true,
	["Katarina"] =		true,
	["Leona"] = 		true,
	["Lux"] = 			true,
	["Nami"] =			true,
	["Nasus"]=			true,
	["Olaf"] = 			true,
	["Poppy"] =			true,
	["Ryze"] = 			true,
	["Sejuani"] =		true,
	["Shen"] = 			true,
	["Tristana"] =		true,
	["Vayne"] =			true,
	["XinZhao"]=		true,
	}
	
Callback.Add("Load", function()
	if BPChamps[GetObjectName(myHero)] then
		Start()
		_G[GetObjectName(myHero)]()
		PrintChat(GetObjectName(myHero).." Loaded!")
	else
		PrintChat(GetObjectName(myHero).." Is not supported!")
	end
end)

class "Start"

function Start:__init()
	local myName = myHero.charName
	BPAIO = MenuConfig("BPAIO", "BPAIO "..myName)
end

class "Annie"

function Annie:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Slider("pR", "R Pred", 0, 0, 100, 5)

BPAIO:Menu("D", "Draw")
BPAIO.D:Boolean("Q", "Draw Q", true)
BPAIO.D:Boolean("W", "Draw W", true)
BPAIO.D:Boolean("E", "Draw E", true)
BPAIO.D:Boolean("R", "Draw R", true)
BPAIO.D:Boolean("QMin", "Draw Q Minion Dmg", true)
BPAIO.D:Boolean("AA", "Draw AA Minion Dmg", true)

OnTick(function(myHero) self:Tick() end)
OnDraw(function(myHero) self:Draw() end)
end

function Annie:Tick()
local AnnieR = {delay = 0.25, speed = math.huge, width = 200, range = 600}
local target = GetCurrentTarget()
local RPred = GetCircularAOEPrediction(target, AnnieR)

	if not IsDead(target) then
if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 625) then
		CastTargetSpell(target, _Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, 625) then
		CastSkillShot(_W, GetOrigin(target))
	end
	if BPAIO.QWER.E:Value() and Ready(_E) then
		CastSpell(_E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, 600) then
		if RPred and RPred.hitChance >= (BPAIO.QWER.pR:Value()/100) then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end
end

function Annie:Draw()
	if IsObjectAlive(myHero) then
		if BPAIO.D.Q:Value() then
			if Ready(_Q) then
				DrawCircle(GetOrigin(myHero), 625, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 625, 1, 100, ARGB(100, 225, 0, 0))
			end
		end
		if BPAIO.D.W:Value() then
			if Ready(_W) then
				DrawCircle(GetOrigin(myHero), 625, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 625, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.E:Value() then
			if Ready(_E) then
				DrawCircle(GetOrigin(myHero), 50, 1, 50, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 50, 1, 50, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.R:Value() then
			if Ready(_R) then
				DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		for _, mob in pairs(minionManager.objects) do
			if BPAIO.D.QMin:Value() and GetTeam(mob) == MINION_ENEMY and ValidTarget(mob, 3000) and Ready(_Q) then
				if GetCurrentHP(mob) + GetDmgShield(mob) <= getdmg("Q", mob, myHero, GetCastLevel(myHero, _Q)) then
					DrawCircle(GetOrigin(mob), 60, 2, 8, ARGB(200, 255, 115, 0))
				end
			end
			if BPAIO.D.AA:Value() and GetTeam(mob) == MINION_ENEMY and ValidTarget(mob, 3000)then
				if GetCurrentHP(mob) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
					DrawCircle(GetOrigin(mob), 50, 2, 8, ARGB(200, 255, 255, 255))
				end
			end
		end
	end
end

class "Ashe"

function Ashe:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Slider("pW", "W Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Slider("pR", "R Pred", 0, 0, 100, 5)

BPAIO:Menu("D", "Draw")
BPAIO.D:Boolean("Q", "Draw Q", true)
BPAIO.D:Boolean("W", "Draw W", true)
BPAIO.D:Boolean("E", "Draw E", true)
BPAIO.D:Boolean("R", "Draw R", true)
BPAIO.D:Boolean("AA", "Draw AA Min Dmg", true)

OnTick(function(myHero) self:Tick() end)
OnDraw(function(myHero) self:Draw() end)
end

function Ashe:Tick()
	local target = GetCurrentTarget()
	local AsheW = {delay = 0.25, speed = 2000, range = GetCastRange(myHero, _W), width = 60}
	local AsheR = {delay = 0.25, speed = 1600, range = GetCastRange(myHero, _R), width = 130}
	local WPred = GetPrediction(target, AsheW)
	local RPred = GetPrediction(target, AsheR)
	
	if not IsDead(target) then
	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 1200) then
		CastSpell(_Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, GetCastRange(myHero, _W)) then
		if WPred and WPred.hitChance >= (BPAIO.QWER.pW:Value()/100) then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) then
		if RPred and RPred.hitChance >= (BPAIO.QWER.pR:Value()/100) then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end
end

function Ashe:Draw()
	if IsObjectAlive(myHero) then
		if BPAIO.D.Q:Value() then
			if Ready(_Q) then
				DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 225, 0, 0))
			end
		end
		if BPAIO.D.W:Value() then
			if Ready(_W) then
				DrawCircle(GetOrigin(myHero), 1200, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 1200, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.E:Value() then
			if Ready(_E) then
				DrawCircle(GetOrigin(myHero), 100, 1, 50, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 100, 1, 50, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.R:Value() then
			if Ready(_R) then
				DrawCircle(GetOrigin(myHero), 200, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 200, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		for _, mob in pairs(minionManager.objects) do
			if BPAIO.D.AA:Value() and GetTeam(mob) == MINION_ENEMY and ValidTarget(mob) then
				if GetCurrentHP(mob) + GetDmgShield(mob) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
					DrawCircle(GetOrigin(mob), 50, 2, 8, ARGB(200, 255, 255, 255))
				end
			end
		end
	end
end

class "Darius"

function Darius:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Boolean("ksR", "Auto R When Low", true)

BPAIO:Menu("D", "Draw")
BPAIO.D:Boolean("Q", "Draw Q", true)
BPAIO.D:Boolean("W", "Draw W", true)
BPAIO.D:Boolean("E", "Draw E", true)
BPAIO.D:Boolean("R", "Draw R", true)
BPAIO.D:Boolean("AA", "Draw AA Minion Dmg", true)

OnTick(function(myHero) self:Tick() end)
OnUpdateBuff(function(myHero) self:UpdateBuff() end)
OnRemoveBuff(function(myHero) self:RemoveBuff() end)
OnDraw(function(myHero) self:Draw() end)
end

local rDebuff        = {}

function Darius:UpdateBuff()
  if not unit or not buff then
    return
  end
  if buff.Name:lower() == "dariushemo" and GetTeam(buff) ~= (GetTeam(myHero)) and myHero.type == unit.type then
        rDebuff[unit.networkID] = buff.Count
    end
end

function Darius:RemoveBuff()
  if not unit or not buff then
    return
  end
  if buff.Name:lower() == "dariushemo" and GetTeam(buff) ~= (GetTeam(myHero)) and myHero.type == unit.type then
        rDebuff[unit.networkID] = 0
    end
end

function Darius:Tick()
  local target = GetCurrentTarget()
  if ValidTarget(target, 540) and BPAIO.QWER.E:Value() and not IsInDistance(target, GetRange(myHero)+GetHitBox(myHero)+GetHitBox(target)) and Ready(_E) then
CastSkillShot(_E , GetOrigin(target))
		AttackUnit(target)
      end
	
	if not IsDead(target) then
	if BPAIO.QWER.Q:Value() and Ready(_Q) then
		CastSpell(_Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
		AttackUnit(target)
	end
	  for _, enemy in pairs(GetEnemyHeroes()) do
    if rDebuff ~= nil then 
      local realHP = (GetCurrentHP(enemy) + GetDmgShield(enemy) + (GetHPRegen(enemy) * 0.25))
      local rStacks = rDebuff[enemy.networkID] or 0
      local rDamage = (((GetSpellData(myHero, _R).level * 100) + (GetBonusDmg(myHero) * 0.75)) + (rStacks * ((GetSpellData(myHero, _R).level * 20) + (GetBonusDmg(myHero) * 0.15))))
      if ValidTarget(enemy, 460) and rDamage >= realHP and Ready(_R) and BPAIO.QWER.ksR:Value() then 
        CastTargetSpell(enemy, _R)
      end
    end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, 460) then
		CastTargetSpell(target, _R)
	end
end
end

function Darius:Draw()
	if IsObjectAlive(myHero) then
		if BPAIO.D.Q:Value() then
			if Ready(_Q) then
				DrawCircle(GetOrigin(myHero), 425, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 425, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.W:Value() then
			if Ready(_W) then
				DrawCircle(GetOrigin(myHero), 200, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 200, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.E:Value() then
			if Ready(_E) then
				DrawCircle(GetOrigin(myHero), 550, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 550, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.R:Value() then
			if Ready(_R) then
				DrawCircle(GetOrigin(myHero), 460, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 460, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		for _, mob in pairs(minionManager.objects) do
			if BPAIO.D.AA:Value() then
				if ValidTarget(mob) and GetTeam(mob) == MINION_ENEMY and ValidTarget(mob) then
					if GetCurrentHP(mob) + GetDmgShield(mob) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
						DrawCircle(GetOrigin(mob), 50, 2, 8, ARGB(200, 255, 255, 255))
					end
				end
			end
		end
	end
end

class "Gnar"

function Gnar:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Mini Gnar Q", string.byte("S"))
BPAIO.QWER:Key("MQ", "Cast Mega Gnar Q", string.byte("S"))
BPAIO.QWER:Slider("pQ", "Gnar Q Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("W", "Cast Mega Gnar W", string.byte("D"))
BPAIO.QWER:Slider("pW", "Gnar W Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("E", "Cast Mini Gnar E", string.byte("F"))
BPAIO.QWER:Key("ME", "Cast Mega Gnar E", string.byte("F"))
BPAIO.QWER:Slider("pE", "Gnar E Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

BPAIO:Menu("D", "Draw")
BPAIO.D:Boolean("Q", "Draw Q", true)
BPAIO.D:Boolean("W", "Draw W", true)
BPAIO.D:Boolean("E", "Draw E", true)
BPAIO.D:Boolean("R", "Draw R", true)
BPAIO.D:Boolean("MinQ", "Draw Q Minion", true)
BPAIO.D:Boolean("AA", "Draw AA Min", true)

OnTick(function(myHero) self:Tick() end)
OnDraw(function(myHero) slef:Draw() end)
end

function Gnar:Tick()
	local MiniGnarQ = {delay = 0.25, speed = 1225, width = 60, range = 1200}
	local MegaGnarQ = {delay = 0.5, speed = 2100, width = 90, range = 1150}
	local MegaGnarW = {delay = 0.6, speed = math.huge, width = 80, range = 600}
	local MiniGnarE = {delay = 0, speed = 903, width = 150, range = 473}
	local MegaGnarE = {delay = 0.25, speed = 1000, width = 200, range = 475}
	local target = GetCurrentTarget()
	local mQPred = GetLinearAOEPrediction(target, MiniGnarQ)
	local MQPred = GetPrediction(target, MegaGnarQ)
	local WPred = GetLinearAOEPrediction(target, MegaGnarW)
	local mEPred = GetCircularAOEPrediction(target, MiniGnarE)
	local MEPred = GetCircularAOEPrediction(target, MegaGnarE)
	local MiniGnar = (GotBuff(myHero, "gnartransform") == 0 or GotBuff(myHero, "gnarfuryhigh") == 1)
	local MegaGnar = (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1)
	
	if not IsDead(target) then 
	if BPAIO.QWER.Q:Value() and Ready(_Q) and Ready(_Q) and ValidTarget(target, 1200) and GetCastName(myHero, _Q) == "GnarQ" and MiniGnar then
		if mQPred and mQPred.hitChance >= (BPAIO.p.pQ:Value()/100) then
			CastSkillShot(_Q, mQPred.castPos)
		end
	end
	if BPAIO.QWER.MQ:Value() and Ready(_Q) and ValidTarget(target, 1150) and GetCastName(myHero, _Q) == "GnarBigQ" and MegaGnar then
		if MQPred and MQPred.hitChance >= (BPAIO.p.pQ:Value()/100) then
			CastSkillShot(_Q, MQPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, 600) and GetCastName(myHero, _W) == "GnarBigW" and MegaGnar then
		if WPred and WPred.hitChance >= (BPAIO.p.pW:Value()/100) then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and BPAIO(target, 475) and GetCastName(myHero, _E) == "GnarE" and MiniGnar then
		if mEPred and mEPred.hitChance >= (BPAIO.p.mpE:Value()/100) then
			CastSkillShot(_E, mEPred.castPos)
		end
	end
	if BPAIO.QWER.ME:Value() and ValidTarget(target, 475) and GetCastName(myHero, _E) == "GnarBigE" and MegaGnar then
		if MEPred and MEPred.hitChance >= (BPAIO.p.MpE:Value()/100) then
			CastSkillShot(_E, MEPred.castPos)
		end
	end
end
end

function Gnar:Draw()
	local MiniGnar = (GotBuff(myHero, "gnartransform") == 0 or GotBuff(myHero, "gnarfuryhigh") == 1)
	local MegaGnar = (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1)
	
	if IsObjectAlive(myHero) then
		if BPAIO.D.Q:Value() then
			if Ready(_Q) and GotBuff(myHero, "gnartransform") == 0 then
				DrawCircle(GetOrigin(myHero), 1200, 1, 100, ARGB(100, 0, 255, 0))
			elseif not Ready(_Q) and GotBuff(myHero, "gnartransform") == 0 then
				DrawCircle(GetOrigin(myHero), 1200, 1, 100, ARGB(100, 255, 0, 0))
			elseif Ready (_Q) and (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1) then
				DrawCircle(GetOrigin(myHero), 1150, 1, 100, ARGB(100, 0, 255, 0))
			elseif not Ready(_Q) and (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1) then
				DrawCircle(GetOrigin(myHero), 1150, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.W:Value() then
			if Ready(_W) and GotBuff(myHero, "gnartransform") == 1 then
				DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 255, 0, 0))
			elseif not Ready(_W) and GotBuff(myHero, "gnartransform") == 1 then
				DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 0, 255, 0))
			end
		end
		if BPAIO.D.E:Value() then
			if Ready(_E) and GotBuff(myHero, "gnartransform") == 0 then
				DrawCircle(GetOrigin(myHero), 475, 1, 100, ARGB(100, 0, 255, 0))
			elseif not Ready(_E) and GotBuff(myHero, "gnartransform") == 0 then
				DrawCircle(GetOrigin(myHero), 475, 1, 100, ARGB(100, 255, 0, 0))
			elseif Ready (_E) and (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1) then
				DrawCircle(GetOrigin(myHero), 475, 1, 100, ARGB(100, 0, 255, 0))
			elseif not Ready(_E) and (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1) then
				DrawCircle(GetOrigin(myHero), 475, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.R:Value() then
			if Ready(_R) and GotBuff(myHero, "gnartransform") == 0 then
				DrawCircle(GetOrigin(myHero), 500, 1, 100, ARGB(100, 0, 255, 0))
			elseif not Ready(_R) and GotBuff(myHero, "gnartransform") == 0 then
				DrawCircle(GetOrigin(myHero), 500, 1, 100, ARGB(100, 255, 0, 0))
			elseif Ready (_R) and (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1) then
				DrawCircle(GetOrigin(myHero), 500, 1, 100, ARGB(100, 0, 255, 0))
			elseif not Ready(_R) and (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1) then
				DrawCircle(GetOrigin(myHero), 500, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		for _, mob in pairs(minionManager.objects) do
			if GetTeam(mob) == MINION_ENEMY and ValidTarget(mob, 3000)then
				if BPAIO.D.MinQ:Value() and Ready(_Q) and GetCastName(myHero, _Q) == "GnarQ" and MiniGnar then
					if GetCurrentHP(mob) + GetDmgShield(mob) < CalcDamage(myHero, mob, mQDMG, 0) then
						DrawCircle(GetOrigin(mob), 60, 2, 8, ARGB(200, 255, 115, 0))
					end
				end
				if BPAIO.D.MinQ:Value() and Ready(_Q) and GetCastName(myHero, _Q) == "GnarBigQ" and MegaGnar then
					if GetCurrentHP(mob) + GetDmgShield(mob) < CalcDamage(myHero, mob, MQDMG, 0) then
						DrawCircle(GetOrigin(mob), 60, 2, 8, ARGB(200, 255, 115, 0))
					end
				end
				if BPAIO.D.AA:Value() then
					if GetCurrentHP(mob) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
						DrawCircle(GetOrigin(mob), 50, 2, 8, ARGB(200, 255, 255, 255))
					end
				end
			end
		end
	end
end

class "Ryze"

function Ryze:__init()
BPAIO:Menu("QWER", "Cast QWE")
BPAIO.QWER:Key("Q", "Q Key", string.byte("S"))
BPAIO.QWER:Slider("pQ", "Q Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("W", "W Key", string.byte("D"))
BPAIO.QWER:Key("E", "E Key", string.byte("F"))
BPAIO.QWER:Key("aE", "Auto E Minion", string.byte("Z"))
BPAIO.QWER:Key("aQ", "Q Minion", string.byte("Q"))

BPAIO:Menu("D", "Draw")
BPAIO.D:Boolean("Q", "Draw Q", true)
BPAIO.D:Boolean("W", "Draw W", true)
BPAIO.D:Boolean("E", "Draw E", true)
BPAIO.D:Boolean("Flux", "Draw Flux", true)
BPAIO.D:Boolean("R", "Draw R", true)
BPAIO.D:Boolean("MinQ", "Draw Q Minion", true)
BPAIO.D:Boolean("MinE", "Draw E Minion", true)
BPAIO.D:Boolean("AA", "Draw Minion AA", true)

OnTick(function(myHero) self.Tick() end)
OnDraw(function(myHero) self.Draw() end)
end

function Ryze:Tick()
	local RyzeQ = {delay = 0.25, speed = 1700, width = 50, range = 900}
	local target = GetCurrentTarget()
	local QPred = GetPrediction(target, RyzeQ)
	
	if not IsDead(target) then
	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 900) then
		if QPred and QPred.hitChance >= (BPAIO.QWER.pQ:Value()/100) then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, 600) then
		CastTargetSpell(target, _W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 600) then
		CastTargetSpell(target, _E)
	end
	for _, minion in pairs(minionManager.objects) do
		if GetCurrentHP(minion) + GetDmgShield(minion) < getdmg("E", minion, myHero, GetCastLevel(myHero, _E)) * 0.925 and ValidTarget(minion, 600) and Ready(_E) and BPAIO.QWER.aE:Value() then
			CastTargetSpell(minion, _E)
		end
		if BPAIO.QWER.aQ:Value() and ValidTarget(minion, 900) and Ready(_Q) then
			local QPred2 = GetPrediction(minion, RyzeQ)
			if QPred2 and QPred2.hitChance >= (BPAIO.QWER.pQ:Value()/100) then
				CastSkillShot(_Q, QPred2.castPos)
			end
		end
	end
end
end

function Ryze:Draw()
	if IsObjectAlive(myHero) then
		if BPAIO.D.Q:Value() then
			if Ready(_Q) then
				DrawCircle(GetOrigin(myHero), 950, 1, 100, ARGB(100, 0, 225, 0))
			else
				DrawCircle(GetOrigin(myHero), 950, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.W:Value() then
			if Ready(_W) then
				DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.E:Value() then
			if Ready(_E) then
				DrawCircle(GetOrigin(myHero), 595, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 595, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.R:Value() then
			if Ready(_R) then
				DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _R), 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _R), 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		for _, mob in pairs(minionManager.objects) do
			if GetTeam(mob) == MINION_ENEMY and ValidTarget(mob, 3000)then
				if BPAIO.D.AA:Value() then
					if GetCurrentHP(mob) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
						DrawCircle(GetOrigin(mob), 50, 2, 8, ARGB(200, 255, 255, 255))
					end
				end
				if BPAIO.D.MinQ:Value() then
					if GetCurrentHP(mob) + GetDmgShield(mob) < getdmg("Q", mob, myHero, GetCastLevel(myHero, _Q)) then
						DrawCircle(GetOrigin(mob), 70, 2, 8, ARGB(200, 0, 0, 255))
					end
				end
				if BPAIO.D.MinE:Value() then
					if GetCurrentHP(mob) + GetDmgShield(mob) < getdmg("E", mob, myHero, GetCastLevel(myHero, _Q)) * 0.925 then
						DrawCircle(GetOrigin(mob), 60, 2, 8, ARGB(200, 200, 0, 255))
					end
				end
			end
		end
	end
end

class "Poppy"

function Poppy:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Slider("pQ", "Q Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("E", "Cast Q", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Slider("pR", "Cast R", 0, 0, 100, 5)

BPAIO:Menu("D", "Draw")
BPAIO.D:Boolean("Q", "Draw Q", true)
BPAIO.D:Boolean("W", "Draw W", true)
BPAIO.D:Boolean("E", "Draw E", true)
BPAIO.D:Boolean("R", "Draw R", true)
BPAIO.D:Boolean("A", "Draw AA Min", true)

OnTick(function(myHero) self.Tick() end)
OnDraw(function(myHero) self.Draw() end)
end

function Poppy:Tick()
	local target = GetCurrentTarget()
	local PoppyQ = {delay = 0.5, speed = math.huge, width = 100, range = 430}
	local PoppyR = {delay = 0.25, speed = 1150, width = 100, range = 425}
	local QPred = GetPrediction(target, PoppyQ)
	local RPred = GetLinearAOEPrediction(target, PoppyR)
	
	if not IsDead(target) then
	if BPAIO.QER.Q:Value() and Ready(_Q) and ValidTarget(target, 400) then
		if QPred and QPred.hitChance >= (BPAIO.QER.pQ:Value()/100) then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QER.E:Value() and Ready(_E) and ValidTarget(target, 425) then
		CastTargetSpell(target, _E)
		AttackUnit(target)
		DelayAction(function()
			CastSkillShot(_Q, GetOrigin(target))
		end, .5)
	end
	if BPAIO.QER.R:Value() and Ready(_R) and ValidTarget(target, 400) then
		if RPred and RPred.hitChance >= (BPAIO.QER.pR()/100) then
			CastSkillShot(_R, GetOrigin(myHero))
			DelayAction(function()
				CastSkillShot2(_R, RPred.castPos)
			end, 0.1)
		end
	end
end
end

function Poppy:Draw()
	if IsObjectAlive(myHero) then
		if BPAIO.D.Q:Value() then
			if Ready(_Q) then
				DrawCircle(GetOrigin(myHero), 425, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 425, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.W:Value() then
			if Ready(_W) then
				DrawCircle(GetOrigin(myHero), 400, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 400, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.E:Value() then
			if Ready(_E) then
				DrawCircle(GetOrigin(myHero), 420, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 420, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.R:Value() then
			if Ready(_R) then
				DrawCircle(GetOrigin(myHero), 395, 1, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 395, 1, 100, ARGB(100, 255, 0, 0))
			end
		end
		for _, mob in pairs(minionManager.objects) do
			if GetTeam(mob) == MINION_ENEMY and ValidTarget(mob, 3000)then
				if BPAIO.D.AA:Value() then
					if GetCurrentHP(mob) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
						DrawCircle(GetOrigin(mob), 50, 2, 8, ARGB(200, 255, 255, 255))
					end
				end
			end
		end
	end
end

class "Katarina"

function Katarina:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("aQ", "Q Minions", string.byte("Q"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

BPAIO:Menu("D", "Draw")
BPAIO.D:Boolean("dQ", "Draw Q", true)
BPAIO.D:Boolean("dW", "Draw W", true)
BPAIO.D:Boolean("dE", "Draw E", true)
BPAIO.D:Boolean("dR", "Draw R", true)
BPAIO.D:Boolean("Dmg", "Draw Damage", true)

OnTick(function(myHero) self.Tick() end)
OnDraw(function(myHero) self.Draw() end)
end

function Katarina:Tick()
	local target = GetCurrentTarget()
	
	if not IsDead(target) then
	if BPAIO.QWER.Q:Value() and ValidTarget(target, GetCastRange(myHero, _Q)) and Ready(_Q) then
			CastTargetSpell(target, _Q)
		end
		if BPAIO.QWER.W:Value() and ValidTarget(target, GetCastRange(myHero, _W)) and Ready(_W) then
			CastSpell(_W)
		end
		if BPAIO.QWER.E:Value() and ValidTarget(target, GetCastRange(myHero, _E)) and Ready(_E) then
			CastTargetSpell(target, _E)
		end
		if BPAIO.QWER.R:Value() and Ready(_R) then
			CastSpell(_R)
		end
		for _, minion in pairs(minionManager.objects) do
			if BPAIO.QWER.aQ:Value() and Ready(_Q) and ValidTarget(minion, GetCastRange(myHero, _Q)) and GetTeam(minion) == MINION_ENEMY then
				CastTargetSpell(minion, _Q)
			end
		end
	end
end

function Katarina:Draw()
	if BPAIO.D.dQ:Value() then
		if Ready(_Q) then
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _Q), 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _Q), 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.dW:Value() then
		if Ready(_W) then
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _W), 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _W), 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.dE:Value() then
		if Ready(_E) then
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _E), 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _E), 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.Dmg:Value() then
		for _, enemy in pairs(GetEnemyHeroes()) do
			if ValidTarget(enemy) then
				DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, getdmg("Q", enemy, myHero, GetCastLevel(myHero, _Q)) + getdmg("W", enemy, myHero, GetCastLevel(myHero, _W)) + getdmg("E", enemy, myHero, GetCastLevel(myHero, _E)) + getdmg("R", enemy, myHero, GetCastLevel(myHero, _R)), GoS.White)
			end
		end
	end	
end

class "Nasus"

function Nasus:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q on Champs", string.byte("S"))
BPAIO.QWER:Key("qQ", "Quick Cast Q", string.byte("Q"))
BPAIO.QWER:Key("sQ", "Stack Q Mininon", string.byte("Z"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Slider("pE", "E Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))

BPAIO:Menu("D", "Draw")
BPAIO.D:Boolean("dW", "Draw W", true)
BPAIO.D:Boolean("dE", "Draw E", true)
BPAIO.D:Boolean("AA", "Draw AA Dmg Minion", true)
BPAIO.D:Boolean("cDmg", "Draw Damage Q Champions", true)
BPAIO.D:Boolean("mDmg", "Draw Damage Q Minions", true)

OnTick(function(myHero) self.Tick() end)
OnDraw(function(myHero) self.Draw() end)
end

function Nasus:Tick()
local target = GetCurrentTarget()
local NasusE = { delay = 0.1, speed = math.huge, width = 400, range = 650 }
local EPred = GetCircularAOEPrediction(target, NasusE)
local qdmg = 10 + 20*GetCastLevel(myHero,_Q) + GetBonusDmg(myHero) + GetBaseDamage(myHero) + GetBuffData(myHero,"nasusqstacks").Stacks - 5 -- thanks zwei

	if not IsDead(target) then
	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 325) then
		CastSpell(_Q)
		AttackUnit(target)
	end
	if BPAIO.QWER.qQ:Value() and Ready(_Q) then
		CastSpell(_Q)
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, 600) then
		CastTargetSpell(target, _W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 650) then
		if EPred and EPred.hitChance >= (BPAIO.QWER.pE:Value()/100) then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastSpell(_R)
	end
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if GetCurrentHP(minion) - GetDamagePrediction(minion, GetWindUp(myHero)) < CalcDamage(myHero, minion, qdmg,0) and ValidTarget(minion, 400) and BPAIO.QWER.sQ:Value() and Ready(_Q) then
				CastSpell(_Q)
				AttackUnit(minion)
			end
		end
	end
end
end

function Nasus:Draw()
local qdmg = 10 + 20*GetCastLevel(myHero,_Q) + GetBonusDmg(myHero) + GetBaseDamage(myHero) + GetBuffData(myHero,"nasusqstacks").Stacks - 5 -- thanks zwei

	if BPAIO.D.dW:Value() then
		if Ready(_W) then
			DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.dE:Value() then
		if Ready(_E) then
			DrawCircle(GetOrigin(myHero), 650, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 650, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.cDmg:Value() then
		for _,enemy in pairs(GetEnemyHeroes()) do
			if ValidTarget(enemy) then
				DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), qdmg, 0, GoS.White)
			end
		end
	end
	for _,mob in pairs(minionManager.objects) do
		if BPAIO.D.mDmg:Value() then
			if ValidTarget(mob) and GetTeam(mob) == MINION_ENEMY and GetCurrentHP(mob) < qdmg then
				DrawCircle(GetOrigin(mob), 70, 2, 100, ARGB(255, 150, 0, 230))
			end
		end
		if BPAIO.D.AA:Value() then
			if ValidTarget(mob) and GetTeam(mob) == MINION_ENEMY then
				if GetCurrentHP(mob) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
					DrawCircle(GetOrigin(mob), 60, 2, 8, ARGB(200, 255, 255, 255))
				end
			end
		end
	end
end

class "Tristana"

function Tristana:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("Q"))
BPAIO.QWER:Key("rW", "W Onto Enemy", string.byte("D"))
BPAIO.QWER:Slider("pW", "W Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Boolean("aR", "Auto Cast R", true)

BPAIO:Menu("D", "Draw Stuff")
BPAIO.D:Boolean("W", "Draw W", true)
BPAIO.D:Boolean("E", "Draw E", true)
BPAIO.D:Boolean("R", "Draw R", true)
BPAIO.D:Boolean("AA", "Last Hit Minion", true)
BPAIO.D:Boolean("dR", "R Damage", true)

OnTick(function(myHero) self.Tick() end)
OnDraw(function(myHero) self.Draw() end)
end

function Tristana:Tick()
local target = GetCurrentTarget()
local TrisW = { delay = 0.5, speed = 1500, width = 270, range = 900 }
local WPred = GetCircularAOEPrediction(target, TrisW)

	if not IsDead(target) then
	if Ready(_Q) and BPAIO.QWER.Q:Value() then
		CastSpell(_Q)
	end
	if Ready(_W) and BPAIO.QWER.W:Value() then
		CastSkillShot(_W, GetMousePos())
	end
	if Ready(_W) and BPAIO.QWER.rW:Value() and ValidTarget(target, 900) then
		if WPred and WPred.hitChance >= (BPAIO.QWER.pW:Value()/100) then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) and BPAIO.QWER.E:Value() then
		CastTargetSpell(target, _E)
	end
	if Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) and BPAIO.QWER.R:Value() then
		CastTargetSpell(target, _R)
	end
	for _,enemy in pairs(GetEnemyHeroes()) do
		if Ready(_R) and ValidTarget(enemy, GetCastRange(myHero, _R)) and BPAIO.QWER.aR:Value() and GetCurrentHP(enemy) + GetDmgShield(enemy) + GetMagicShield(enemy) < getdmg("R", enemy, myHero, GetCastLevel(myHero, _R)) then
			CastTargetSpell(enemy, _R)
		end
	end
end
end

function Tristana:Draw()

	if BPAIO.D.W:Value() then
		if Ready(_W) then
			DrawCircle(GetOrigin(myHero), 900, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 900, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.E:Value() then
		if Ready(_E) then
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _E), 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _E), 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.R:Value() then
		if Ready(_R) then
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _R), 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _R), 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	for _,mob in pairs(minionManager.objects) do
		if BPAIO.D.AA:Value() then
			if ValidTarget(mob) and GetTeam(mob) == MINION_ENEMY then
				if GetCurrentHP(mob) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
					DrawCircle(GetOrigin(mob), 60, 2, 8, ARGB(200, 255, 255, 255))
				end
			end
		end
	end
	for _,enemy in pairs(GetEnemyHeroes()) do
		if BPAIO.D.dR:Value() and Ready(_R) and ValidTarget(enemy) then
			DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, getdmg("R", enemy, myHero, GetCastLevel(myHero, _R)), GoS.White)
		end
	end
end

class "XinZhao"

function XinZhao:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Slider("eR", "Auto R at # Enemies", 3, 1, 5, 1)

BPAIO:Menu("D", "Draw Stuff")
BPAIO.D:Boolean("E", "E Range", true)
BPAIO.D:Boolean("R", "R Range", true)
BPAIO.D:Boolean("Dmg", "Draw Dmg", true)
BPAIO.D:Boolean("AA", "AA Dmg to Min", true)

OnTick(function(myHero) self.Tick() end)
OnDraw(function(myHero) self.Draw() end)
end

function XinZhao:Tick()
local target = GetCurrentTarget()

	if not IsDead(target) then
	if Ready(_Q) and BPAIO.QWER.Q:Value() then
		CastSpell(_Q)
	end
	if Ready(_W) and BPAIO.QWER.W:Value() then
		CastSpell(_W)
	end
	if Ready(_E) and ValidTarget(target, 600) and BPAIO.QWER.E:Value() then
		CastTargetSpell(target, _E)
		DelayAction(function()
			CastSpell(_W)
			DelayAction(function()
				CastSpell(_Q)
			end, 0.01)
		end, 0.01)
	end
	if Ready(_R) and ValidTarget(target, 500) and BPAIO.QWER.R:Value() then
		CastSpell(_R)
	end
	for _,enemy in pairs(GetEnemyHeroes()) do
		if Ready(_R) and EnemiesAround(myHero, 500) >= BPAIO.QWER.eR:Value() then
			CastSpell(_R)
		end
	end
end
end

function XinZhao:Draw()

	if BPAIO.D.E:Value() then
		if Ready(_E) then
			DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.R:Value() then
		if Ready(_R) then
			DrawCircle(GetOrigin(myHero), 500, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 500, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	for _, enemy in pairs(GetEnemyHeroes()) do
		if BPAIO.D.Dmg:Value() and ValidTarget(enemy) then
			DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), getdmg("R", enemy, myHero, GetCastLevel(myHero, _R)), getdmg("E", enemy, myHero, GetCastLevel(myHero, _E)), GoS.White)
		end
	end
	for _,mob in pairs(minionManager.objects) do
		if BPAIO.D.AA:Value() then
			if ValidTarget(mob) and GetTeam(mob) == MINION_ENEMY then
				if GetCurrentHP(mob) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
					DrawCircle(GetOrigin(mob), 60, 2, 8, ARGB(200, 255, 255, 255))
				end
			end
		end
	end
end

class "Irelia"

function Irelia:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q on Champ", string.byte("S"))
BPAIO.QWER:Key("mQ", "Cast Q on Min", string.byte("Q"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("sE", "Stun w/ E", string.byte("Z"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Slider("pR", "R Pred", 0, 0, 100, 5)

BPAIO:Menu("D", "Draw Stuff")
BPAIO.D:Boolean("Q", "Draw Q", true)
BPAIO.D:Boolean("mQ", "Draw Q Min Dmg", true)
BPAIO.D:Boolean("E", "Draw E", true)
BPAIO.D:Boolean("R", "Draw R", true)
BPAIO.D:Boolean("AA", "Draw AA on Min", true)

OnTick(function(myHero) self.Tick() end)
OnDraw(function(myHero) self.Draw() end)
end

function Irelia:Tick()
local target = GetCurrentTarget()
local IreliaR = { delay = 0, speed = 1600, width = 65, range = 1000 }
local RPred = GetPrediction(target, IreliaR)

	if not IsDead(target) then
	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 650) then
		CastTargetSpell(target, _Q)
	end
	for _, minion in pairs(minionManager.objects) do
		if BPAIO.QWER.mQ:Value() and Ready(_Q) and ValidTarget(minion, 650) and GetTeam(minion) == MINION_ENEMY and GetCurrentHP(minion) < getdmg("Q", minion, myHero, GetCastLevel(myHero, _Q)) then
			CastTargetSpell(minion, _Q)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) then
		CastSpell(_W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 425) then
		CastTargetSpell(target, _E)
	end
	if BPAIO.QWER.sE:Value() and Ready(_E) and ValidTarget(target, 425) and GetCurrentHP(target) >= GetCurrentHP(myHero) then
		CastTargetSpell(target, _E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, 1000) then
		if RPred and RPred.hitChance >= (BPAIO.QWER.pR:Value()/100) then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end
end

function Irelia:Draw()
	if BPAIO.D.Q:Value() then
		if Ready(_Q) then
			DrawCircle(GetOrigin(myHero), 650, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 650, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	for _, minion in pairs(minionManager.objects) do
		if BPAIO.D.mQ:Value() and Ready(_Q) and GetTeam(minion) == MINION_ENEMY and ValidTarget(minion) then
			if GetCurrentHP(minion) < getdmg("Q", minion, myHero, GetCastLevel(myHero, _Q)) then
				DrawCircle(GetOrigin(minion), 50, 2, 100, ARGB(255, 0, 0, 255))
			end
		end
		if BPAIO.D.AA:Value() and GetTeam(minion) == MINION_ENEMY and ValidTarget(minion) then
			if GetCurrentHP(minion) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
				DrawCircle(GetOrigin(minion), 60, 2, 100, ARGB(255, 255, 255, 255))
			end
		end
	end
	if BPAIO.D.E:Value() then
		if Ready(_E) then
			DrawCircle(GetOrigin(myHero), 425, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 425, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.R:Value() then
		if Ready(_R) then
			DrawCircle(GetOrigin(myHero), 1000, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 1000, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
end

class "Cassiopeia"

function Cassiopeia:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("mQ", "Cast Q on Min", string.byte("Z"))
BPAIO.QWER:Slider("pQ", "Q Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Slider("pW", "W Pred", 0, 0, 100, 0)
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("mE", "Last Hit w/ E", string.byte("Q"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Slider("pR", "R Pred", 0, 0, 100, 0)

BPAIO:Menu("D", "Draw Stuff")
BPAIO.D:Boolean("Q", "Draw Q", true)
BPAIO.D:Boolean("W", "Draw W", true)
BPAIO.D:Boolean("E", "Draw E", true)
BPAIO.D:Boolean("R", "Draw R", true)
BPAIO.D:Boolean("AA", "Draw AA", true)
BPAIO.D:Boolean("mE", "Draw E on Min", true)

OnTick(function(myHero) self.Tick() end)
OnDraw(function(myHero) self.Draw() end)
end

function Cassiopeia:Tick()
local target = GetCurrentTarget()
local CassQ = { delay = 0.75, speed = math.huge, width = 150, range = 850 }
local CassW = { delay = nil, speed = math.huge, width = 160, range = 900 }
local CassR = { delay = 0.6, speed = math.huge, width = 150, range = 850 }
local QPred = GetCircularAOEPrediction(target, CassQ)
local WPred = GetCircularAOEPrediction(target, CassW)
local RPred = GetCircularAOEPrediction(target, CassR)
	
	if not IsDead(target) then
	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 850) then
		if QPred and QPred.hitChance >= (BPAIO.QWER.pQ:Value()/100) then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	for _, minion in pairs(minionManager.objects) do
		if BPAIO.QWER.mE:Value() and Ready(_E) and ValidTarget(minion, 700) and GetTeam(minion) == MINION_ENEMY and GetCurrentHP(minion) < getdmg("E", minion, myHero, GetCastLevel(myHero, _E)) then
			CastTargetSpell(minion, _E)
		end
		if BPAIO.QWER.mQ:Value() and Ready(_Q) and ValidTarget(minion, 850) and GetTeam(minion) == MINION_ENEMY then
			local QPred2 = GetCircularAOEPrediction(minion, CassQ)
			if QPred2 and QPred2.hitChance >= (BPAIO.QWER.pQ:Value()/100) then
				CastSkillShot(_Q, QPred2.castPos)
			end
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, 900) then
		if WPred and WPred.hitChance >= (BPAIO.QWER.pW:Value()/100) then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 700) then
		CastTargetSpell(target, _E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, 850) then
		if RPred and RPred.hitChance >= (BPAIO.QWER.pR:Value()/100) then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end
end

function Cassiopeia:Draw()
	if BPAIO.D.Q:Value() then
		if Ready(_Q) then
			DrawCircle(GetOrigin(myHero), 840, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 840, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.W:Value() then
		if Ready(_W) then
			DrawCircle(GetOrigin(myHero), 900, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 900, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.E:Value() then
		if Ready(_E) then
			DrawCircle(GetOrigin(myHero), 700, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 700, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.R:Value() then
		if Ready(_R) then
			DrawCircle(GetOrigin(myHero), 850, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 850, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	for _, minion in pairs(minionManager.objects) do
		if BPAIO.D.AA:Value() and GetTeam(minion) == MINION_ENEMY and ValidTarget(minion) then
			if GetCurrentHP(minion) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
				DrawCircle(GetOrigin(minion), 60, 2, 100, ARGB(255, 255, 255, 255))
			end
		end
		if BPAIO.D.mE:Value() and GetTeam(minion) == MINION_ENEMY and ValidTarget(minion) then
			if GetCurrentHP(minion) < getdmg("E", minion, myHero, GetCastLevel(myHero, _E)) then
				DrawCircle(GetOrigin(minion), 70, 2, 100, ARGB(255, 150, 80, 160))
			end
		end
	end
end

class "Jhin"

function Jhin:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("mQ", "Cast Q on Min", string.byte("Z"))
BPAIO.QWER:Key("W", "Cast W", string.byte("D"))
BPAIO.QWER:Slider("pW", "W Pred", 0, 0, 100, 5)
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Slider("pE", "Cast E", 0, 0, 100, 5)
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Slider("pR", "R Pred", 0, 0, 100, 0)

BPAIO:Menu("D", "Draw Stuff")
BPAIO.D:Boolean("Q", "Draw Q", true)
BPAIO.D:Boolean("mQ", "Draw Q Min", true)
BPAIO.D:Boolean("W", "Draw W", true)
BPAIO.D:Boolean("E", "Draw E", true)
BPAIO.D:Boolean("R", "Draw R", true)
BPAIO.D:Boolean("AA", "Draw AA on Min", true)

OnTick(function(myHero) self.Tick() end)
OnDraw(function(myHero) self.Draw() end)
end

function Jhin:Tick()
local target = GetCurrentTarget()
local JhinW = { delay = 0.75, speed = 5000, width = 40, range = 2500 }
local JhinE = { delay = 0.75, speed = 1000, width = 260, range = 750 }
local JhinR = { delay = 0.25, speed = 5000, width = 80, range = 3000 }
local WPred = GetPrediction(target, JhinW)
local EPred = GetPrediction(target, JhinE)
local RPred = GetPrediction(target, JhinR)

	if not IsDead(target) then
	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 550) then
		CastTargetSpell(target, _Q)
	end
	for _, minion in pairs(minionManager.objects) do
		if BPAIO.QWER.mQ:Value() and Ready(_Q) and GetTeam(minion) == MINION_ENEMY and ValidTarget(minion, 550) and GetCurrentHP(minion) < getdmg("Q", minion, myHero, GetCastLevel(myHero, _Q)) then
			CastTargetSpell(minion, _Q)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, 2500) then
		if WPred and WPred.hitChance >= (BPAIO.QWER.pW:Value()/100) then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 750) then
		if EPred and EPred.hitChance >= (BPAIO.QWER.pE:Value()/100) then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(target, 3500) then
		if RPred and RPred.hitChance >= (BPAIO.QWER.pR:Value()/100) then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end
end

function Jhin:Draw()
	if BPAIO.D.Q:Value() then
		if Ready(_Q) then
			DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 600, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.W:Value() then
		if Ready(_W) then
			DrawCircle(GetOrigin(myHero), 2500, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 2500, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.E:Value() then
		if Ready(_E) then
			DrawCircle(GetOrigin(myHero), 750, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 750, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.R:Value() then
		if Ready(_R) then
			DrawCircle(GetOrigin(myHero), 3500, 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), 3500, 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	for _, minion in pairs(minionManager.objects) do
		if BPAIO.D.AA:Value() and GetTeam(minion) == MINION_ENEMY and ValidTarget(minion) then
			if GetCurrentHP(minion) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
				DrawCircle(GetOrigin(minion), 60, 2, 100, ARGB(255, 255, 255, 255))
			end
		end
		if BPAIO.D.mQ:Value() and GetTeam(minion) == MINION_ENEMY and ValidTarget(minion) and Ready(_Q) then
			if GetCurrentHP(minion) < getdmg("Q", minion, myHero, GetCastLevel(myHero, _Q)) then
				DrawCircle(GetOrigin(minion), 70, 2, 100, ARGB(255, 230, 40, 170))
			end
		end
	end
end

class "Vayne"

function Vayne:__init()
BPAIO:Menu("QWER", "Cast QWER")
BPAIO.QWER:Key("Q", "Cast Q", string.byte("S"))
BPAIO.QWER:Key("E", "Cast E", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
--BPAIO.QWER:Key("AA", "Last Hit Min", string.byte("Q"))

BPAIO:Menu("D", "Draw Stuff")
BPAIO.D:Boolean("Q", "Draw Q", true)
BPAIO.D:Boolean("E", "Draw E", true)
BPAIO.D:Boolean("AA", "Draw AA on Min", true)

OnTick(function(myHero) self.Tick() end)
OnDraw(function(myHero) self.Draw() end)
end

function Vayne:Tick()
local target = GetCurrentTarget()

	if not IsDead(target) then
	if BPAIO.QWER.Q:Value() and Ready(_Q) then
		CastSkillShot(_Q, GetMousePos())
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 550) then
		CastTargetSpell(target, _E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastSpell(_R)
	end
	--for _, minion in pairs(minionManager.objects) do
		--if BPAIO.QWER.AA:Value() and GetTeam(minion) == MINION_ENEMY and ValidTarget(minion, 550) then
			---if GetCurrentHP(minion) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
				--AttackUnit(minion)
			--end
		--end
	--end
end
end

function Vayne:Draw()
	if BPAIO.D.Q:Value() then
		if Ready(_Q) then
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _Q), 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _Q), 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	if BPAIO.D.E:Value() then
		if Ready(_E) then
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _E), 1, 100, ARGB(100, 0, 255, 0))
		else
			DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _E), 1, 100, ARGB(100, 255, 0, 0))
		end
	end
	for _, minion in pairs(minionManager.objects) do
		if BPAIO.D.AA:Value() and GetTeam(minion) == MINION_ENEMY and ValidTarget(minion) then
			if GetCurrentHP(minion) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
				DrawCircle(GetOrigin(minion), 60, 2, 100, ARGB(255, 255, 255, 255))
			end
		end
	end
end
