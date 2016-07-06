PrintChat(string.format("<font color='#fdfd24'>The Wandering Caretaker - BardBae</font>"))

if GetObjectName(GetMyHero()) ~= "Bard" then return end

require 'DamageLib'
--[[
require	'IPrediction'
]]--
require 'MapPositionGOS'
require 'OpenPredict'

--[[
local bq = { name = "BardQ", objname = "BardQMissile", speed = 1500, delay = 0.25, range = 850, width = 140, collision = false, aoe = false, type = "linear"}
bq.pred = IPrediction.Prediction(bq)
local br = { name = "BardR", objname = "BardR", speed = 2100, delay = 0.5, range = 3400, width = 350, collision = false, aoe = false, type = "circular"}
br.pred = IPrediction.Prediction(br)
]]--

Bard = Menu("Bard", "Bard: Caretaker")
Bard:Menu("Combo", "Combo")
Bard.Combo:Boolean("Q1", "Minion Q Stun or Slow Q on/off", true)
Bard.Combo:Key("Q", "Minion Q Stun or Slow Q", string.byte(" "));
Bard.Combo:Slider("WallS1", "Range Distance  ^", 950, 1, 950, 50)
Bard.Combo:Boolean("QD1", "Range Distance Q", true)
Bard.Combo:Boolean("qks", "KillSteal Q", true)

Bard:Menu("AutoStun", "Auto Stun")
Bard.AutoStun:Boolean("StunQ", "Auto Stun Wall Q", true)
Bard.AutoStun:Boolean("QD", "Bind Range Q", true)
Bard.AutoStun:Slider("WallS", "Bind Range", 450, 1, 500, 50)
Bard.AutoStun:Boolean("StunEnemy", "Stun 2 Enemy bind", true)
Bard.AutoStun:Slider("StunEnemy2", "find 2 Enemy", 2, 1, 2, 1)

Bard:Menu("HAM", "Heal")
Bard.HAM:KeyBinding("HealAlly", "Heal Ally", string.byte(" "));
Bard.HAM:Slider("Heal1", "Ally heal % under hp", 50, 0, 100, 1)
Bard.HAM:KeyBinding("Healme", "Heal Me", string.byte(" "));
Bard.HAM:Slider("Heal2", "Heal Me % under hp", 40, 0, 100, 1)

Bard:Menu("ULT", "TemperedFate Ult")
Bard.ULT:Key("TemperedFate", "Tempered Fate Enemies", string.byte("T"))
Bard.ULT:Slider("R2", "Use R number enemies", 2, 1, 5, 1)

local TargetR = TargetSelector(3500,TARGET_NEAR_MOUSE or TARGET_PRIORITY,DAMAGE_MAGIC,true,false)
local WallS1 = (Bard.Combo.WallS1:Value())
local BardQ = { delay = 0.25, speed = 1500, width = 65, range = 950}
local BardR = { delay = 0.25, speed = 2100, width = 350, range = 3400, radius = 350}

OnTick(function(myHero)
if IsDead(myHero) then return end
Ally()
CastQ()
CastR()
AutoStunWall()
AutoStunEnemy()
KillStealQ()
end)

function AutoStunWall()
local targetQ = GetCurrentTarget()
if Bard.AutoStun.StunQ:Value() then
	for _, targetQ in pairs(GetEnemyHeroes()) do
		if Ready(_Q) and GetDistance(myHero, targetQ) <= 950 and EnemiesAround(GetOrigin(targetQ), 450) and not IsDead(targetQ) or not IsVisible(targetQ) or not IsTargetable(targetQ) then 
				local q = GetPrediction(targetQ, BardQ)
				local QPos = Vector(q)
				local Wall = (Bard.AutoStun.WallS:Value())
				for Stun = 0, Wall, GetHitBox(targetQ) do
					local StunPos = Vector(QPos) + Vector(Vector(QPos) - Vector(myHero)):normalized() *Stun
					if MapPosition:inWall(StunPos) == true then
						if q and q.hitChance >= 0.20 and not q:mCollision(2) then 
						CastSkillShot(_Q, q.castPos)end
					end
				end
			end
		end
	end
end

function AutoStunEnemy()
local targetQ = GetCurrentTarget()
if Bard.AutoStun.StunEnemy:Value() then
	for _, targetQ in pairs(GetEnemyHeroes()) do
		if Ready(_Q) and GetDistance(myHero, targetQ) <= 950 and not IsDead(targetQ) then
			if EnemiesAround(GetOrigin(targetQ), 450) >= Bard.AutoStun.StunEnemy2:Value() then
				local StunEnemy = GetLinearAOEPrediction(targetQ, BardQ)
				if StunEnemy and StunEnemy.hitChance >= 0.25 and StunEnemy:hCollision(2) then
				myHero:CastSpell(_Q, StunEnemy.castPos)end
				end
			end
		end
	end
end

function CastQ()
local targetQ = GetCurrentTarget()
if IOW:Mode() == "Combo" and Bard.Combo.Q1:Value() then
	if Ready(_Q) and ValidTarget(targetQ, WallS1) and Bard.Combo.Q:Value() then
		local QMinion = GetLinearAOEPrediction(targetQ, BardQ)
			if QMinion and QMinion.hitChance >= 0.25 and (QMinion:mCollision(2) or QMinion:mCollision(1)) then
			CastSkillShot(_Q, QMinion.castPos)end
		end
	end
end

function CastR()
local TargetR = TargetR:GetTarget()
	if Bard.ULT.TemperedFate:Value() then
		for _, TargetR in pairs(GetEnemyHeroes()) do
		if Ready(_R) and ValidTarget(TargetR, 3400) and EnemiesAround(GetOrigin(TargetR), 3400) >= Bard.ULT.R2:Value() then
			local RPred = GetCircularAOEPrediction(TargetR, BardR)
			if RPred and RPred.hitChance >= 0.20 then
			CastSkillShot(_R, RPred.castPos)end
			end
		end
	end
end

function KillStealQ()
	if Bard.Combo.qks:Value() then
		for _, target in pairs(GetEnemyHeroes()) do
			if ValidTarget(target, 950) and GetCurrentHP(target) <= getdmg("Q", target) then
				local SQPred = GetLinearAOEPrediction(target, BardQ)
				if SQPred and SQPred.hitChance >= 0.20 then
				CastSkillShot(_Q, SQPred.castPos)end
			end
		end
	end
end

function Ally()
	for _, ally in pairs(GetAllyHeroes()) do
	if Ready(_W) and GetDistance(myHero, ally) <= 800 and GetPercentHP(ally) <= Bard.HAM.Heal1:Value() and Bard.HAM.HealAlly:Value() and not IsDead(ally)then
	ally:Cast(_W, ally)
	end
end
	if Ready(_W) and GetPercentHP(myHero) <= Bard.HAM.Heal2:Value() and Bard.HAM.Healme:Value() then
	myHero:Cast(_W, myHero)
	end
end

OnDraw(function(myHero)
if Bard.AutoStun.QD:Value() then DrawCircle(myHeroPos().x,myHeroPos().y,myHeroPos().z,(Bard.AutoStun.WallS:Value())+Bard.Combo.WallS1:Value(),1,250,GoS.Yellow)end
if Bard.Combo.QD1:Value() then DrawCircle(myHeroPos().x,myHeroPos().y,myHeroPos().z,(Bard.Combo.WallS1:Value()),1,250,GoS.Yellow)end
end)
