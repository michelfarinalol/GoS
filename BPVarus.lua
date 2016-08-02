if GetObjectName(GetMyHero()) ~= "Varus" then return end

require("OpenPredict")

VarusMenu = Menu("Varus", "Varus")
VarusMenu:SubMenu("QER", "Cast QER")
VarusMenu.QER:Key("Q", "Cast Q", string.byte("S"))
VarusMenu.QER:Slider("pQ", "Q Pred", 0, 0, 100, 5)
VarusMenu.QER:Key("E", "Cast E", string.byte("F"))
VarusMenu.QER:Slider("pE", "E Pred", 0, 0, 100, 5)
VarusMenu.QER:Key("R", "Cast R", string.byte("G"))
VarusMenu.QER:Slider("pR", "R Pred", 0, 0, 100, 5)

local VarusQ = { delay = 0.1, speed = 1850, width = 70, range = qRange}
local VarusE = { delay = 0.1, speed = 1700, width = 55, range = 925, radius = 275}
local VarusR = { delay = 0.1, speed = 1850, width = 120, range = 1075}

OnTick(function()

	local target = GetCurrentTarget()
	local QPred = GetPrediction(target, VarusQ)
	local EPred = GetCircularAOEPrediction(target, VarusE)
	local RPred = GetPrediction(target, VarusR)
	
	if not IsDead(target) then
	if VarusMenu.QER.Q:Value() and Ready(_Q) and ValidTarget(target, 1625) then
		CastSkillShot(_Q, GetOrigin(myHero))
	end
	if VarusMenu.QER.Q:Value() == false and ValidTarget(target, 1625) and GotBuff(myHero, "VarusQLaunch") then
		if QPred and QPred.hitChance >= (VarusMenu.QER.pQ:Value()/100) then
			CastSkillShot2(_Q, QPred.castPos)
		end
	end
	if VarusMenu.QER.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) and not GotBuff(myHero, "VarusQLaunch") then
		if EPred and EPred.hitChance >= (VarusMenu.QER.pE:Value()/100) then
			CastSkillShot(_E, EPred.castPos)
		end
	end
	if VarusMenu.QER.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero, _R)) and not GotBuff(myHero, "VarusQLaunch") then
		if RPred and RPred.hitChance >= (VarusMenu.QER.pR:Value()/100) then
			CastSkillShot(_R, RPred.castPos)
		end
	end
end
end)
