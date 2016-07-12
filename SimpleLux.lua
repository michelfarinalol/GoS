if GetObjectName(GetMyHero()) ~= "Lux" then return end

require("OpenPredict")

LuxMenu = Menu("Lux", "Lux")
LuxMenu:SubMenu("QWER", "QWER")
LuxMenu.QWER:Key("Q", "Cast Q", string.byte("S"))
LuxMenu.QWER:Slider("pQ", "Q Pred", 20, 0, 100, 5)
--LuxMenu.QWER:Key("W", "Cast W", string.byte("D"))
--LuxMenu.QWER:Slider("pW", "W Pred", 20, 0, 100, 5)
LuxMenu.QWER:Key("E", "Cast E", string.byte("F"))
LuxMenu.QWER:Slider("pE", "E Pred", 20, 0, 100, 5)
LuxMenu.QWER:Key("R", "Cast R", string.byte("G"))
LuxMenu.QWER:Slider("pR", "R Pred", 20, 0, 100, 5)

local LuxQ = {delay = 0.25, speed = 1200, width = 70, range = GetCastRange(myHero, _Q)}
--local LuxW = {delay = 0.25, speed = 1400, width = 100, range = 1075}
local LuxE = {delay = 0.25, speed = 1300, width = 350, range = GetCastRange(myHero, _E)}
local LuxR = {delay = 1.00, speed = math.huge, width = 190, range = GetCastRange(myHero, _R)}

OnTick(function()

	local target = GetCurrentTarget()
	local QPred = GetPrediction(target, LuxQ)
	--local WPred = GetPrediction()
	local EPred = GetPrediction(target, LuxE)
	local RPred = GetPrediction(target, LuxR)
	
	if LuxMenu.QWER.Q:Value() and ValidTarget(target, GetCastRange(myHero, _Q)) and Ready(_Q) then
		if QPred and QPred.hitChance >= (LuxMenu.QWER.pQ:Value()/100) then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if LuxMenu.QWER.E:Value() and ValidTarget(target, GetCastRange(myHero, _E)) and Ready(_E) then
		if EPred and EPred.hitChance >= (LuxMenu.QWER.pE:Value()/100) then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if LuxMenu.QWER.R:Value() and ValidTarget(target, GetCastRange(myHero, _R)) and Ready(_R) then
		if RPred and RPred.hitChance >= (LuxMenu.QWER.pR:Value()/100) then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end)
