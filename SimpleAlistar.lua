    if GetObjectName(GetMyHero()) ~= "Alistar" then return end

    require 'OpenPredict'
    require 'Inspired'
    require 'DeftLib'
    require 'DamageLib'

	--local AlistarMenu = MenuConfig("Alistar", "Alistar")
	AlistarMenu = Menu("Alistar", "Alistar")
	AlistarMenu:SubMenu("QWER", "Cast QWER")
	AlistarMenu.QWER:Key("Q", "Cast Q", string.byte("S"))
	AlistarMenu.QWER:Key("cQ", "# of Champs to Cast Q", 1, 1, 5, 1)
	AlistarMenu.QWER:Key("W", "Cast W", string.byte("D"))
	AlistarMenu.QWER:Key("QW", "Use Q+W Combo", string.byte("T"))
	AlistarMenu.QWER:Key("WQ", "W+Q Combo", string.byte("A"))
	AlistarMenu.QWER:Key("E", "Cast E", string.byte("F"))
	AlistarMenu.QWER:Slider("cE", "# Allies to Cast E", 1, 1, 5, 1)
	AlistarMenu.QWER:Key("R", "Cast R", string.byte("G"))
	AlistarMenu.QWER:Boolean:("aR", "Auto Cast R if CC'd", true)
	AlistarMenu.QWER:Slider:("hR", "Current Health % Under to Auto R", 15, 5, 100, 5)
	AlistarMenu.QWER:Slider:("eR", "# of Enemies Around to Auto R", 2, 1, 5, 1)

    AlistarMenu:Menu("Killsteal", "Killsteal")
    AlistarMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)
    AlistarMenu.Killsteal:Boolean("W", "Killsteal with W", true)
    AlistarMenu.Killsteal:Boolean("WQ", "Killsteal with W+Q", true)

    AlistarMenu:Menu("Misc", "Misc")
    if Ignite ~= nil then AlistarMenu.Misc:Boolean("Autoignite", "Auto Ignite", true) end
    AlistarMenu.Misc:Boolean("Eme", "Self-Heal", true)
    AlistarMenu.Misc:Slider("mpEme", "Minimum Mana %", 25, 5, 80, 1)
    AlistarMenu.Misc:Slider("hpEme", "Minimum HP%", 40, 5, 80, 1)
    AlistarMenu.Misc:Boolean("Eally", "Heal Allies", true)
    AlistarMenu.Misc:Slider("mpEally", "Minimum Mana %", 40, 5, 80, 1)
    AlistarMenu.Misc:Slider("hpEally", "Minimum HP %", 35, 5, 80, 1)

    AlistarMenu:Menu("Drawings", "Drawings")
    AlistarMenu.Drawings:Boolean("Q", "Draw Q Range", true)
    AlistarMenu.Drawings:Boolean("W", "Draw W Range", true)
    AlistarMenu.Drawings:Boolean("E", "Draw E Range", true)

    AlistarMenu:Menu("Interrupt", "Interrupt")
    AlistarMenu.Interrupt:Menu("SupportedSpells", "Supported Spells")
    AlistarMenu.Interrupt.SupportedSpells:Boolean("Q", "Use Q", true)
    AlistarMenu.Interrupt.SupportedSpells:Boolean("W", "Use W", true)

    CHANELLING_SPELLS = {
        ["Caitlyn"]                     = {_R},
        ["Katarina"]                    = {_R},
        ["MasterYi"]                    = {_W},
        ["FiddleSticks"]                = {_W, _R},
        ["Galio"]                       = {_R},
        ["Lucian"]                      = {_R},
        ["MissFortune"]                 = {_R},
        ["VelKoz"]                      = {_R},
        ["Nunu"]                        = {_R},
        ["Shen"]                        = {_R},
        ["Karthus"]                     = {_R},
        ["Malzahar"]                    = {_R},
        ["Pantheon"]                    = {_R},
        ["Warwick"]                     = {_R},
        ["Xerath"]                      = {_Q, _R},
        ["Varus"]                       = {_Q},
        ["TahmKench"]                   = {_R},
        ["TwistedFate"]                 = {_R},
        ["Janna"]                       = {_R}
    }

    DelayAction(function()
      local str = {[_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"}
      for i, spell in pairs(CHANELLING_SPELLS) do
        for _,k in pairs(GetEnemyHeroes()) do
            if spell["Name"] == GetObjectName(k) then
            AlistarMenu.Interrupt:Boolean(GetObjectName(k).."Inter", "On "..GetObjectName(k).." "..(type(spell.Spellslot) == 'number' and str[spell.Spellslot]), true)
            end
        end
      end
    end, 1)

    OnProcessSpell(function(target, spell)
        if GetObjectType(target) == Obj_AI_Hero and GetTeam(target) ~= GetTeam(myHero) then
          if CHANELLING_SPELLS[spell.name] then
            if ValidTarget(target, 650) and IsReady(_W) and GetObjectName(target) == CHANELLING_SPELLS[spell.name].Name and AlistarMenu.Interrupt[GetObjectName(target).."Inter"]:Value() and AlistarMenu.Interrupt.SupportedSpells.W:Value() then
            CastTargetSpell(target, _W)
            elseif ValidTarget(target, 365) and IsReady(_Q) and GetObjectName(target) == CHANELLING_SPELLS[spell.name].Name and AlistarMenu.Interrupt[GetObjectName(target).."Inter"]:Value() and AlistarMenu.Interrupt.SupportedSpells.Q:Value() then
            CastSpell(_Q)
            end
          end
        end
    end)

    local target1 = TargetSelector(650, TARGET_LESS_CAST_PRIORITY,DAMAGE_MAGIC, true, false)
	local CCType = {[5] = "Stun", [7] = "Silence", [8] = "Taunt", [9] = "Polymorph", [11] = "Snare", [21] = "Fear", [22] = "Charm", [24] = "Suppression"}

	OnUpdateBuff(function(unit, buff)
		if unit.isMe and CCType[buff.Type] and AlistarMenu.QWER.R:Value() and Ready(_R) and GetPercentHP(myHero) <= AlistarMenu.QWER.hR:Value() and EnemiesAround(myHeroPos(), 1000) >= AlistarMenu.QWER.eR:Value() then
			CastSpell(_R)
		end
	end)

    OnTick(function(myHero)
        local target = GetCurrentTarget()
        local Wtarget = target1:GetTarget()

    --ComboMenu
        --if Mix:Mode() == "Combo" then
    ---AutoQ
    	if IsReady(_Q) and AlistarMenu.QWER.Q:Value() and ValidTarget(target, 365) then
    	CastSpell(_Q)
    	end
    ---AutoW
    	if IsReady(_W) and AlistarMenu.QWER.W:Value() and ValidTarget(Wtarget,650) and GetCurrentMana(myHero) >= GetCastMana(myHero,_W,GetCastLevel(myHero,_W)) then
    	CastTargetSpell(Wtarget, _W)
    	end
    ---AutoWQ
    	if AlistarMenu.QWER.WQ:Value() then
    	if CanUseSpell(myHero, _W) == READY and CanUseSpell(myHero, _Q) == READY and ValidTarget(target, 650) then
    	CastTargetSpell(target, _W)
    	end
    	end
    	if AlistarMenu.Combo.WQ:Value() then
    	local QPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1200,250,260,50,false,true)
    	if CanUseSpell(myHero, _Q) == READY and CanUseSpell(myHero, _W) ~= READY and ValidTarget(target, 365) then
    	CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
    	end
    	end
    ---AutoQW
    	if AlistarMenu.QWER.QW:Value() then
        local QPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1200,250,260,50,false,true)
    	if CanUseSpell(myHero, _Q) == READY and ValidTarget(target, 365) then
    	CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
    	end
    	end
    	if AlistarMenu.QWER.QW:Value() then
    	if CanUseSpell(myHero, _W) == READY and ValidTarget(target, 300) then
    	CastTargetSpell(target, _W)
    	end
    	end

    	if AlistarMenu.QWER.R:Value() then
		if CanUseSpell(myHero, _R) == READY and ValidTarget(target, 1000) then
    	CastSpell(_R)
    	end
    	end


    --HarassMenu
        --if Mix:Mode() == "Harass" and GetPercentMP(myHero) >= AlistarMenu.Harass.Mana:Value() then

    	--if IsReady(_Q) and AlistarMenu.Harass.Q:Value() and ValidTarget(target,365) then
    	--CastSpell(_Q)
    	--end

    	--if IsReady(_W) and IsReady(_Q) and AlistarMenu.Harass.WQ:Value() and ValidTarget(Wtarget,650) and GetCurrentMana(myHero) >= GetCastMana(myHero,_Q,GetCastLevel(myHero,_Q)) + GetCastMana(myHero,_W,GetCastLevel(myHero,_W)) then
    	--CastTargetSpell(Wtarget, _W)
    	--DelayAction(function() CastSpell(_Q) end, math.max(0 , GetDistance(Wtarget) - 500 ) * 0.4 + 25)
    	--end

    	--if AlistarMenu.Harass.QW:Value() then
    	--if CanUseSpell(myHero, _W) == READY and IsInDistance(target, 300) then
    	--CastTargetSpell(target, _W)
    	--end
    	--end
        --end
    --HealMe
        if not IsRecalling(myHero) and AlistarMenu.Misc.Eme:Value() and AlistarMenu.Misc.mpEme:Value() <= GetPercentMP(myHero) and GetMaxHP(myHero)-GetCurrentHP(myHero) > 30+30*GetCastLevel(myHero,_E)+0.2*GetBonusAP(myHero) and GetPercentHP(myHero) <= AlistarMenu.Misc.hpEme:Value() then
        CastSpell(_E)
        end
    --HealAlly
        if not IsRecalling(myHero) and AlistarMenu.Misc.Eally:Value() and AlistarMenu.Misc.mpEally:Value() <= GetPercentMP(myHero) then
          for k,v in pairs(GetAllyHeroes()) do
            if v ~= nil and not IsRecalling(v) and IsObjectAlive(v) and GetDistance(v) <= 575 and GetMaxHP(v)- GetHP(v) < 15+15*GetCastLevel(myHero,_E)+0.1*GetBonusAP(myHero) and GetPercentHP(v) <= AlistarMenu.Misc.hpEally:Value() then
            CastSpell(_E)
            end
          end
        end

        for i,enemy in pairs(GetEnemyHeroes()) do
    --Ignite
    	if Ignite and AlistarMenu.Misc.Autoignite:Value() then
    	if IsReady(Ignite) and 20 * GetLevel(myHero) + 50 > GetHP(enemy) + GetHPRegen(enemy) * 3 and ValidTarget(enemy, 600) then
    	 CastTargetSpell(enemy, Ignite)
    	end
    	end
    --KillSteal
    	if IsReady(_Q) and ValidTarget(enemy, 365) and AlistarMenu.Killsteal.Q:Value() and GetHP2(enemy) < getdmg("Q", enemy) then
    	 CastSpell(_Q)
    	elseif IsReady(_W) and ValidTarget(enemy, 650) and AlistarMenu.Killsteal.W:Value() and GetHP2(enemy) < getdmg("W", enemy) then
    	 CastTargetSpell(enemy, _W)
    	elseif IsReady(_W) and IsReady(_Q) and GetCurrentMana(myHero) >= GetCastMana(myHero, _Q, GetCastLevel(myHero, _Q)) + GetCastMana(myHero, _W, GetCastLevel(myHero, _W)) and ValidTarget(enemy, 650) and AlistarMenu.Killsteal.WQ:Value() and GetHP2(enemy) < getdmg("Q", enemy) + getdmg("W", enemy) then
    	 CastTargetSpell(enemy, _W)
    	DelayAction(function() CastSpell(_Q) end, math.max(0, GetDistance(enemy) - 500) * 0.4 + 25)
    	end

        end

    end)

    --Drawings
    OnDraw(function(myHero)

    	local pos = GetOrigin(myHero)

    	if AlistarMenu.Drawings.Q:Value() then DrawCircle(pos, 365, 1, 25, GoS.Pink) end
    	if AlistarMenu.Drawings.W:Value() then DrawCircle(pos, 650, 1, 25, GoS.Yellow) end
    	if AlistarMenu.Drawings.E:Value() then DrawCircle(pos, 575, 1, 25, GoS.Blue) end

    end)

    AddGapcloseEvent(_Q, 365, false, AlistarMenu)
    AddGapcloseEvent(_W, 650, true, AlistarMenu)

    print("<font color='#af0000'>Alistar</font> | <font color='#00d12d'>Loaded!</font>")
