if GetObjectName(GetMyHero()) ~= "Jax" then return end

if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end

local JaxMenu = Menu("Jax", "Jax")
JaxMenu:SubMenu("Combo", "Combo")
JaxMenu.Combo:Boolean("Q", "Use Q", true)
JaxMenu.Combo:Boolean("W", "Use W", true)
-----------------------------------------------------------------
JaxMenu:SubMenu("Harass", "Harass")
JaxMenu.Harass:Boolean("Q", "Use Q", false)
JaxMenu.Harass:Boolean("W", "Use W", true)
-----------------------------------------------------------------
JaxMenu:SubMenu("LaneClear", "Laneclear")
JaxMenu.Laneclear:Boolean("Q", "Use Q", false)
JaxMenu.Laneclear:Boolean("W", "Use W", false)
-----------------------------------------------------------------
JaxMenu:SubMenu("JungleClear", "JungleClear")
JaxMenu.JungleClear:Boolean("Q", "Use Q", false)
JaxMenu.JungleClear:Boolean("W", "Use W", true)
-----------------------------------------------------------------
JaxMenu:SubMenu("LastHit", "LastHit")
JaxMenu.LastHit:Boolean("W", "Use W", false)
-----------------------------------------------------------------
JaxMenu:SubMenu("Killsteal", "Killsteal")
JaxMenu.Killsteal:Boolean("Q", "Use Q", false)
JaxMenu.Killsteal:Boolean("W", "Use W", true)
-----------------------------------------------------------------
JaxMenu:SubMenu("Drawings", "Drawings")
JaxMenu.Drawings:Boolean("Q", "Draw Q", true)
JaxMenu.Drawings:Boolean("W", "Draw W", true)
JaxMenu.Drawings:Boolean("E", "Draw E", true)
JaxMenu.Drawings:Boolean("R", "Draw R", true)
-----------------------------------------------------------------

OnUpdateBuff(function(unit, buff)
          if unit.isMe then 
          print(buff.Name)
          end
end)

OnTick(function()

	local target = GetCurrentTarget()
	
--Combo--

	if Mix:Mode() == "Combo" then
		if JaxMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 700) then
			CastTargetSpell(target, _Q)
		end
	end
	
--Harass--
	
	if Mix:Mode() == "Harass" then
		if JaxMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 700) then
			CastTargetSpell(target, _Q)
		end
	end
	
--Killsteal--

	for _,enemy in pairs(GetEnemyHeroes()) do
		if JaxMenu.Killsteal.Q:Value() and Ready(_Q) and ValidTarget(enemy, 700) then
			if GetCurrentHP(enemy) + GetDmgShield(enemy) < CalcDamage(myHero, enemy, 30 + 40 * GetCastLevel(myHero, _Q) + GetBonusDmg(myHero),  GetBonusAP(myHero) * 0.6) then
				CastTargetSpell(enemy, _Q)
			end
		else
			if GotBuff(myHero, "JaxEmpowerTwo") > 0 then
				if CalcDamage(myHero, enemy, 30 + 40 * GetCastLevel(myHero, _Q) + GetBonusDmg(myHero),  GetBonusAP(myHero) * 0.6  + (5 + 35 *GetCastLevel(myHero, _W) + GetBonusAP(myHero) * 0.6)) then
					CastTargetSpell(enemy, _Q)
				end
			end
		end
	end
--Laneclear / Jungleclear--
	
	if Mix:Mode() == "Laneclear" then
		for _, mob in pairs(minionManager.objects) do
			if GetTeam(mob) == 300 - GetTeam(myHero) then
				if JaxMenu.Laneclear.Q:Value() and Ready(_Q) and ValidTarget(mob, 700) then
					CastTargetSpell(mob, _Q)
				end
			end
			if GetTeam(mob) == 300 then
				if JaxMenu.Jungleclear:Value() and Ready(_Q) and ValidTarget(mob, 700) then
					CastTargetSpell(mob, _Q)
				end
			end
		end
	end
end)


--Drawings--

OnDraw(function()
	
--Spell Drawings--

	if IsObjectAlive(myHero) then
	
		if JaxMenu.Drawings.Q:Value() then
			if Ready(_Q) then
				DrawCircle(GetOrigin(myHero), 700, 5, 100, ARGB(100, 0, 225, 0))
			else
				DrawCircle(GetOrigin(myHero), 700, 5, 100, ARGB(100, 225, 0, 0))
			end
		end
		if JaxMenu.Drawings.W:Value() then
			if Ready(_W) then
				DrawCircle(GetOrigin(myHero), 200, 5, 100, ARGB(100, 0, 225, 0))
			else
				DrawCircle(GetOrigin(myHero), 200, 5, 100, ARGB(100, 225, 0, 0))
			end
		end
		if JaxMenu.Drawings.E:Value() then
			if Ready(_E) then
				DrawCircle(GetOrigin(myHero), 350, 5, 100, ARGB(100, 0, 225, 0))
			else
				DrawCircle(GetOrigin(myHero), 350, 5, 100, ARGB(100, 225, 0, 0))
			end
		end
		if JaxMenu.Drawings.R:Value() then
			if Ready(_R) then
				DrawCircle(GetOrigin(myHero), 50, 5, 50, ARGB(100, 225, 0, 225))
			else
				DrawCircle(GetOrigin(myHero), 50, 5, 50, ARGB(100, 225, 0, 0))
			end
		end
	end
end)

--W AA Reset--

OnProcessSpellComplete(function(unit,spell)
	local target = GetCurrentTarget()
	if JaxMenu.Combo.W:Value() and unit.isMe and spell.name:lower():find("attack") and spell.target.isHero then
		if Mix:Mode() == "Combo" then
			if Ready(_W) then
				CastSpell(_W)
				DelayAction(function()
					AttackUnit(spell.target)
				end, spell.windUpTime)
			end
		end
	end
	if JaxMenu.Harass.W:Value() and unit.isMe and spell.name:lower():find("attack") and spell.target.isHero then
		if Mix:Mode() == "Harass" then
			if Ready(_W) then
				CastSpell(_W)
				DelayAction(function()
					AttackUnit(spell.target)
				end, spell.windUpTime)
			end
		end
	end
	if JaxMenu.LaneClear.W:Value() and unit.isMe and spell.name:lower():find("attack") and spell.target.isMinion and spell.target.team == 300 - GetTeam(myHero) or spell.target.team == 300 then
		if Mix:Mode() == "LaneClear" then
			if Ready(_W) then
				CastSpell(_W)
				DelayAction(function()
					AttackUnit(spell.target)
				end, spell.windUpTime)
			end
		end
	end
end)
