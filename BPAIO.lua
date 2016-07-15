--Credits to SxcS and Zwei

local v = 0.01

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
	["Darius"] = 		true,
	["Gnar"] = 			true,
	["Illaoi"] = 		true,
	["Khazix"] = 		true,
	["Jinx"] =			true,
	["Leona"] = 		true,
	["Lux"] = 			true,
	["Nami"] =			true,
	["Olaf"] = 			true,
	["Poppy"] =			true,
	["Ryze"] = 			true,
	["Sejuani"] =		true,
	["Shen"] = 			true,
	["Tristana"] =		true,
	["TwistedFate"] = 	true,
	["Vayne"] =			true,
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

function Annie:Draw()
	if IsObjectAlive(myHero) then
		if BPAIO.D.Q:Value() then
			if Ready(_Q) then
				DrawCircle(GetOrigin(myHero), 625, 5, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 625, 5, 100, ARGB(100, 225, 0, 0))
			end
		end
		if BPAIO.D.W:Value() then
			if Ready(_W) then
				DrawCircle(GetOrigin(myHero), 615, 5, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 615, 5, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.E:Value() then
			if Ready(_E) then
				DrawCircle(GetOrigin(myHero), 50, 5, 50, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 50, 5, 50, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.R:Value() then
			if Ready(_R) then
				DrawCircle(GetOrigin(myHero), 600, 5, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 600, 5, 100, ARGB(100, 255, 0, 0))
			end
		end
		for _, mob in pairs(minionManager.objects) do
			if BPAIO.D.QMin:Value() and GetTeam(mob) == MINION_ENEMY and ValidTarget(mob, 3000) then
				if GetCurrentHP(mob) + GetDmgShield(mob) + GetMagicShield >= getdmg("Q", mob, myHero, GetCastLevel(myHero, _Q)) then
					DrawCircle(GetOrigin(mob), 60, 2, 8, ARGB(200, 255, 115, 0))
				end
			end
			if BPAIO.D.AA:Value() then
				if GetCurrentHP(mob) + GetDmgShield(mob) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
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

function Ashe:Draw()
	if IsObjectAlive(myHero) then
		if BPAIO.D.Q:Value() then
			if Ready(_Q) then
				DrawCircle(GetOrigin(myHero), 600, 5, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 600, 5, 100, ARGB(100, 225, 0, 0))
			end
		end
		if BPAIO.D.W:Value() then
			if Ready(_W) then
				DrawCircle(GetOrigin(myHero), 1200, 5, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 1200, 5, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.E:Value() then
			if Ready(_E) then
				DrawCircle(GetOrigin(myHero), 100, 5, 50, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 100, 5, 50, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.R:Value() then
			if Ready(_R) then
				DrawCircle(GetOrigin(myHero), 200, 5, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 200, 5, 100, ARGB(100, 255, 0, 0))
			end
		end
		for _, mob in pairs(minionManager.objects) do
			if BPAIO.D.AA:Value() then
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
BPAIO.QWER:Key("R", "Cast R", String.byte("G"))
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
	if BPAIO.QWER.R:Value() and Ready(_R) and ValidTarget(460) then
		CastTargetSpell(target, _R)
	end
end

function Darius:Draw()
	if IsObjectAlive(myHero) then
		if BPAIO.D.Q:Value() then
			if Ready(_Q) then
				DrawCircle(GetOrigin(myHero), 425, 5, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myhero), 425, 5, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.W:Value() then
			if Ready(_W) then
				DrawCircle(GetOrigin(myHero), 200, 5, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 200, 5, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.E:Value() then
			if Ready(_E) then
				DrawCircle(GetOrigin(myHero), 550, 5, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 550, 5, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.R:Value() then
			if Ready(_R) then
				DrawCircle(GetOrigin(myHero), 460, 5, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 460, 5, 100, ARGB(100, 255, 0, 0))
			end
		end
		for _, mob in pairs(minionManager.objects) do
			if BPAIO.D.AA:Value() then
				if GetCurrentHP(mob) + GetDmgShield(mob) < GetBaseDamage(myHero) + GetBonusDmg(myHero) then
					DrawCircle(GetOrigin(mob), 50, 2, 8, ARGB(200, 255, 255, 255))
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
	if BPAIO.QWER.E:Value() and Ready(_E) and BPAIO(target, 473) and GetCastName(myHero, _E) == "GnarE" and MiniGnar then
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

function Gnar:Draw()
	local MiniGnar = (GotBuff(myHero, "gnartransform") == 0 or GotBuff(myHero, "gnarfuryhigh") == 1)
	local MegaGnar = (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1)
	
	if IsObjectAlive(myHero) then
		if BPAIO.D.Q:Value() then
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
		if BPAIO.D.W:Value() then
			if Ready(_W) and GotBuff(myHero, "gnartransform") == 1 then
				DrawCircle(GetOrigin(myHero), 600, 5, 100, ARGB(100, 255, 0, 0))
			elseif not Ready(_W) and GotBuff(myHero, "gnartransform") == 1 then
				DrawCircle(GetOrigin(myHero), 600, 5, 100, ARGB(100, 0, 255, 0))
			end
		end
		if BPAIO.D.E:Value() then
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
		if BPAIO.D.R:Value() then
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
BPAIO.QWER:Key("R", "R Key", string.byte("G"))

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
OnDraw(function(myHero) self.Tick() end)
end

function Ryze:Tick()
	local RyzeQ = {delay = 0.25, speed = 1700, width = 50, range = 900}
	local target = GetCurrentTarget()
	local QPred = GetPrediction(target, RyzeQ)
	
	if BPAIO.QWER.Q:Value() and Ready(_Q) and ValidTarget(target, 900) then
		if QPred and QPred.hitChance >= (RyzeMenu.QWER.pQ:Value()/100) then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if BPAIO.QWER.W:Value() and Ready(_W) and ValidTarget(target, 600) then
		CastTargetSpell(target, _W)
	end
	if BPAIO.QWER.E:Value() and Ready(_E) and ValidTarget(target, 600) then
		CastTargetSpell(target, _E)
	end
	if BPAIO.QWER.R:Value() and Ready(_R) then
		CastSkillShot(target, _R)
	end
end

function Ryze:Draw()
	if IsObjectAlive(myHero) then
		if BPAIO.D.Q:Value() then
			if Ready(_Q) then
				DrawCircle(GetOrigin(myHero), 900, 5, 100, ARGB(100, 0, 225, 0))
			else
				DrawCircle(GetOrigin(myHero), 900, 5, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.W:Value() then
			if Ready(_W) then
				DrawCircle(GetOrigin(myHero), 600, 5, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 600, 5, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.E:Value() then
			if Ready(_E) then
				DrawCircle(GetOrigin(myHero), 600, 5, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 600, 5, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.R:Value() then
			if Ready(_R) then
				DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _R), 5, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), GetCastRange(myHero, _R), 5, 100, ARGB(100, 255, 0, 0))
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
					if GetCurrentHP(mob) + GetDmgShield(mob) <  getdmg("Q", mob, myHero, GetCastLevel(myHero, _Q)) then
						DrawCircle(GetOrigin(mob), 70, 2, 8, ARGB(200, 0, 0, 255))
					end
				end
				if BPAIO.D.MinE:Value() then
					if GetCurrentHP(mob) + GetDmgShield(mob) <  getdmg("E", mob, myHero, GetCastLevel(myHero, _Q)) then
						DrawCircle(GetOrigin(mob), 60, 2, 8, ARGB(200, 0, 0, 255))
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
BPAIO.QWER:Slider("pQ", "Q Pred", 20, 0, 100, 5)
BPAIO.QWER:Key("E", "Cast Q", string.byte("F"))
BPAIO.QWER:Key("R", "Cast R", string.byte("G"))
BPAIO.QWER:Slider("pR", "Cast R", 20, 0, 100, 5)

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

function Poppy:Draw()
	if IsObjectAlive(myHero) then
		if BPAIO.D.Q:Value() then
			if Ready(_Q) then
				DrawCircle(GetOrigin(myHero), 425, 5, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 425, 5, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.W:Value() then
			if Ready(_W) then
				DrawCircle(GetOrigin(myHero), 400, 5, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 400, 5, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.E:Value() then
			if Ready(_E) then
				DrawCircle(GetOrigin(myHero), 415, 5, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 415, 5, 100, ARGB(100, 255, 0, 0))
			end
		end
		if BPAIO.D.R:Value() then
			if Ready(_R) then
				DrawCircle(GetOrigin(myHero), 390, 5, 100, ARGB(100, 0, 255, 0))
			else
				DrawCircle(GetOrigin(myHero), 390, 5, 100, ARGB(100, 255, 0, 0))
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
