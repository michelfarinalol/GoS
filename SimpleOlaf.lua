if GetObjectName(GetMyHero()) ~= "Olaf" then return end

require("OpenPredict")

OlafMenu = Menu("Olaf", "Olaf")
OlafMenu:SubMenu("QE", "Cast QE")
OlafMenu.QE:Key("Q", "Cast Q", string.byte("S"))
OlafMenu.QE:Slider("pQ", "Q Prediction", 20, 0, 100, 5)
OlafMenu.QE:Key("E", "Cast E", string.byte("F"))

local OlafQ = {delay = 0.25, speed = 1550, width = 100, range = GetCastRange(myHero, _Q)}

OnTick(function()

	local target = GetCurrentTarget()
	local QPred = GetLinearAOEPrediction(target, OlafQ)
	
	if OlafMenu.QE.Q:Value() and Ready(_Q) and ValidTarget(target, GetCastRange(myHero, _Q)) then
		if QPred and QPred.hitChance >= (OlafMenu.QE.pQ:Value()/100) then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if OlafMenu.QE.E:Value() and Ready(_E) and ValidTarget(target, GetCastRange(myHero, _E)) then
		CastTargetSpell(target, _E)
	end
end)
