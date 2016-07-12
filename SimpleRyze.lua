if GetObjectName(GetMyHero()) ~= "Ryze" then return end

require("OpenPredict")

RyzeMenu = Menu("Ryze", "Ryze")
RyzeMenu:SubMenu("QWER", "Cast QWE")
--RyzeMenu.QWER:Boolean("Q", "Cast Q", true)
RyzeMenu.QWER:Key("kQ", "Q Key", string.byte("S"))
RyzeMenu.QWER:Slider("pQ", "Q Pred", 20, 0, 100, 5)
--RyzeMenu.QWER:Boolean("W", "Cast W", true)
RyzeMenu.QWER:Key("kW", "W Key", string.byte("D"))
--RyzeMenu.QWER:Boolean("E", "Cast E", true)
RyzeMenu.QWER:Key("kE", "E Key", string.byte("F"))
--RyzeMenu.QWER:Key("kR" "R Key", string.byte("G"))

local RyzeQ = {delay = 0.25, speed = 1700, width = 50, range = 900}

OnTick(function()

	local target = GetCurrentTarget()
	local QPred = GetPrediction(target, RyzeQ)
	
	if RyzeMenu.QWER.kQ:Value() and Ready(_Q) and ValidTarget(target, 900) then
		if QPred and QPred.hitChance >= (RyzeMenu.QWER.pQ:Value()/100) then
			CastSkillShot(_Q, QPred.castPos)
		end
	end
	if RyzeMenu.QWER.kW:Value() and Ready(_W) and ValidTarget(target, 600) then
		CastTargetSpell(target, _W)
	end
	if RyzeMenu.QWER.kE:Value() and Ready(_E) and ValidTarget(target, 600) then
		CastTargetSpell(target, _E)
	end
end)
