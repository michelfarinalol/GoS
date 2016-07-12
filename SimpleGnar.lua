if GetObjectName(GetMyHero()) ~= "Gnar" then return end

require("OpenPredict")

GnarMenu = Menu("Gnar", "Gnar")
GnarMenu:SubMenu("QWE", "Cast QWE")
GnarMenu.QWE:Key("Q", "Cast Mini Gnar Q", string.byte("S"))
GnarMenu.QWE:Key("MQ", "Cast Mega Gnar Q", string.byte("S"))
GnarMenu.QWE:Slider("pQ", "Gnar Q Pred", 20, 0, 100, 5)
GnarMenu.QWE:Key("W", "Cast Mega Gnar W", string.byte("D"))
GnarMenu.QWE:Slider("pW", "Gnar W Pred", 20, 0, 100, 5)
GnarMenu.QWE:Key("E", "Cast Mini Gnar E", string.byte("F"))
GnarMenu.QWE:Key("ME", "Cast Mega Gnar E", string.byte("F"))
GnarMenu.QWE:Slider("pE", "Gnar E Pred", 20, 0, 100, 5)

local MiniGnarQ = {delay = 0.25, speed = 1225, width = 60, range = 1200}
local MegaGnarQ = {delay = 0.5, speed = 2100, width = 90, range = 1150}
local MegaGnarW = {delay = 0.6, speed = math.huge, width = 80, range = 600}
local MiniGnarE = {delay = 0, speed = 903, width = 150, range = 473}
local MegaGnarE = {delay = 0.25, speed = 1000, width = 200, range = 475}

OnTick(function()
	local target = GetCurrentTarget()
	local mQPred = GetLinearAOEPrediction(target, MiniGnarQ)
	local MQPred = GetPrediction(target, MegaGnarQ)
	local WPred = GetLinearAOEPrediction(target, MegaGnarW)
	local mEPred = GetCircularAOEPrediction(target, MiniGnarE)
	local MEPred = GetCircularAOEPrediction(target, MegaGnarE)
	local MiniGnar = (GotBuff(myHero, "gnartransform") == 0 or GotBuff(myHero, "gnarfuryhigh") == 1)
	local MegaGnar = (GotBuff(myHero, "gnartransformsoon") == 1 or GotBuff(myHero, "gnartransform") == 1)
	
	if GnarMenu.QWE.Q:Value() and Ready(_Q) and Ready(_Q) and ValidTarget(target, 1200) and GetCastName(myHero, _Q) == "GnarQ" and MiniGnar then
		if mQPred and mQPred.hitChance >= (GnarMenu.p.pQ:Value()/100) then
			CastSkillShot(_Q, mQPred.castPos)
		end
	end
	if GnarMenu.QWE.MQ:Value() and Ready(_Q) and ValidTarget(target, 1150) and GetCastName(myHero, _Q) == "GnarBigQ" and MegaGnar then
		if MQPred and MQPred.hitChance >= (GnarMenu.p.pQ:Value()/100) then
			CastSkillShot(_Q, MQPred.castPos)
		end
	end
	if GnarMenu.QWE.W:Value() and Ready(_W) and ValidTarget(target, 600) and GetCastName(myHero, _W) == "GnarBigW" and MegaGnar then
		if WPred and WPred.hitChance >= (GnarMenu.p.pW:Value()/100) then
			CastSkillShot(_W, WPred.castPos)
		end
	end
	if GnarMenu.QWE.E:Value() and Ready(_E) and ValidTarget(target, 473) and GetCastName(myHero, _E) == "GnarE" and MiniGnar then
		if mEPred and mEPred.hitChance >= (GnarMenu.p.mpE:Value()/100) then
			CastSkillShot(_E, mEPred.castPos)
		end
	end
	if GnarMenu.QWE.ME:Value() and ValidTarget(target, 475) and GetCastName(myHero, _E) == "GnarBigE" and MegaGnar then
		if MEPred and MEPred.hitChance >= (GnarMenu.p.MpE:Value()/100) then
			CastSkillShot(_E, MEPred.castPos)
		end
	end
end)
