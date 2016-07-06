if GetObjectName(GetMyHero()) ~= "Jax" then return end

require("MixLib")

local JaxMenu = Menu("Jax", "Jax")
JaxMenu:SubMenu("Combo", "Combo")
JaxMenu.Combo:Boolean("Q", "Use Q", true)
JaxMenu.Combo:Boolean("W", "Use W", true)
-----------------------------------------------------------------
JaxMenu:SubMenu("Harass", "Harass")
JaxMenu.Harass:Boolean("Q", "Use Q", false)
JaxMenu.Harass:Boolean("W", "Use W", true)
-----------------------------------------------------------------
JaxMenu:SubMenu("Laneclear", "Laneclear")
JaxMenu.Laneclear:Boolean("Q", "Use Q", false)
JaxMenu.Laneclear:Boolean("W", "Use W", false)
-----------------------------------------------------------------
JaxMenu:SubMenu("Jungleclear", "Jungleclear")
JaxMenu.Jungleclear:Boolean("Q", "Use Q", false)
JaxMenu.Jungleclear:Boolean("W", "Use W", true)
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

OnTick(function()

	local target = GetCurrentTarget()
	
--Combo--

	if Mix:Mode() == "Combo" then
		if JaxMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 700) then
			CastTargetSpell(target, _Q)
		end
		if JaxMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 125) then
			CastSpell(_W)
			IOW:ResetAA()
		end
	end
	
--Harass--
	
	if Mix:Mode() == "Harass" then
		if JaxMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 700) then
			CastTargetSpell(target, _Q)
		end
		if JaxMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 125) then
			CastSpell(_W)
			IOW:ResetAA()
		end
	end
	
--Killsteal--

	for _,enemy in pairs(GetEnemyHeroes()) do
		if JaxMenu.Killsteal.Q:Value() and Ready(_Q) and ValidTarget(target, 700) then
			if GetCurrentHP(enemy) + GetDmgShield(enemy) < CalcDamage(myHero, enemy, GetCastLevel(myHero, _Q), 0) * 40 + 30 + GetBonusDmg(myHero) * 1 + GetBonusAP(myHero) * 0.6 then
				CastTargetSpell(enemy, _Q)
			end
		end
		if JaxMenu.Killsteal.W:Value() and Ready(_W) and ValidTarget(target, 125) then
			if GetCurrentHP(enemy) + GetDmgShield(enemy) + GetMagicShield(enemy) < CalcDamage(myHero, enemy, 0, GetCastLevel(myHero, _W)) * 35 + 5 + GetBonusAP(myHero) * 0.6 then
				CastSpell(_W)
				end
			end
		end
		
--Laneclear / Jungleclear--
	
	if Mix:Mode() == "Laneclear" then
		for _, mob in pairs(minionManager.objects) do
			if GetTeam(mob) == MINION_ENEMY then
				if JaxMenu.Laneclear.Q:Value() and Ready(_Q) and ValidTarget(target, 700) then
					CastTargetSpell(target, _Q)
				end
				if JaxMenu.Laneclear.W:Value() and Ready(_W) and ValidTarget(target, 125) then
					CastSpell(_W)
					IOW:ResetAA()
				end
			end
			if GetTeam(mob) == MINION_JUNGLE then
				if JaxMenu.Jungleclear:Value() and Ready(_Q) and ValidTarget(target, 700) then
					CastTargetSpell(target, _Q)
				end
				if JaxMenu.Jungleclear:Value() and Ready(_W) and ValidTarget(target, 125) then
					CastSpell(_W)
				end
			end
		end
	end
end)


--Drawings--

OnDraw(function(myHero)
	
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
