if GetObjectName(GetMyHero()) ~= "Ekko" then PrintChat(" "..GetObjectName(myHero).." Is Not Supported !") return end

require('OpenPredict')

--Combo
Ekko = Menu("Ekko", "Ekko")
Ekko:Menu("Combo", "Combo")
Ekko.Combo:Boolean("CQ", "Use Q", true)
Ekko.Combo:Slider("CQH", "HitChance", 20, 0, 100, 1)
Ekko.Combo:Slider("CQM", "Q Mana", 50, 0, 100, 1)
Ekko.Combo:Boolean("CW", "Use W Enemy", true)
Ekko.Combo:Slider("CWH", "HitChance", 20, 0, 100, 1)
Ekko.Combo:Slider("CWM", "W Mana", 50, 0, 100, 1)
Ekko.Combo:Slider("CWE", "W Enemy Hit", 1, 0, 5, 1)
Ekko.Combo:Boolean("CE", "Use E", true)
Ekko.Combo:Slider("CEM", "E Mana", 50, 0, 100, 1)
--Misc
Ekko:Menu("Misc", "Misc")
Ekko.Misc:Boolean("UR", "Auto R Low Hp", true)
Ekko.Misc:Slider("URH", "Hp To Ult", 10, 0, 100, 1)
Ekko.Misc:Boolean("HER", "Auto R If enemies", true)
Ekko.Misc:Slider("HERX", "Enemies To Hit ", 1, 0, 5, 1)
--Killsteal
Ekko:Menu("Killsteal", "Killsteal")
Ekko.Killsteal:Boolean("KR", "Killsteal R", true)
--Ekko.Killsteal:Slider("KRE", "Enemies Hit", 1, 0, 5, 1)
--Drawings
Ekko:Menu("Drawings", "Drawings")
Ekko.Drawings:Boolean("DQER", "Draw QER DMG", true)



--R
OnObjectLoad(function(Object) 

  if GetObjectBaseName(Object) == "Ekko" then
  twin = Object
  end

end)


OnCreateObj(function(Object) 

  if GetObjectBaseName(Object) == "Ekko" then
  twin = Object
  end
  
end)

OnDeleteObj(function(Object) 

  
  if GetObjectBaseName(Object) == "Ekko_Base_R_TrailEnd.troy" then
  twin = nil
  end

end)

-- R Position and DMG draw 
OnDraw(function(myHero)
local pos = GetOrigin(myHero)
local myHeroPos = GetOrigin(myHero)
local t = GetCurrentTarget()
  if twin then
  DrawCircle(GetOrigin(twin),350,2,100,ARGB(255, 0, 255, 0))
  end
    if Ekko.Drawings.DQER:Value() and ValidTarget(t, 1500) then

	    if CanUseSpell(myHero,_Q) == READY then
         QDMG = CalcDamage(myHero, t, 0, (15*GetCastLevel(myHero,_Q)+15+(0.1*(GetBonusAP(myHero)))))
        else
         QDMG = 0	
        end
        if CanUseSpell(myHero,_Q) == READY then
         QDMG2 = CalcDamage(myHero, t, 0, (25*GetCastLevel(myHero,_Q)+25+(0.6*(GetBonusAP(myHero)))))
        else
         QDMG2 = 0	
        end
        if CanUseSpell(myHero,_E) == READY then
         EDMG = CalcDamage(myHero, t, 0, (30*GetCastLevel(myHero,_E)+30+(0.2*(GetBonusAP(myHero)))))
        else
         EDMG = 0	
        end
        if CanUseSpell(myHero,_R) == READY then
         RDMG = CalcDamage(myHero, t, 0, (150*GetCastLevel(myHero,_R)+150+(1.3*(GetBonusAP(myHero)))))
        else
         RDMG = 0
        end
        DrawDmgOverHpBar(t,GetCurrentHP(t),QDMG+RDMG+EDMG+QDMG2,0,0xffffff00)
    end    
 
end)



OnTick(function(myHero)
if IOW:Mode() == "Combo" then
     local t = GetCurrentTarget()
     local myHeroPos = GetOrigin(myHero)
     local mousePos = GetMousePos()
     local q = { delay = 0.25, speed = 1000, width = 60, range = 950 }
     local pI = GetPrediction(t, q)


        if Ekko.Combo.CQ:Value() and GetPercentMP(myHero) >= Ekko.Combo.CQM:Value() and ValidTarget(t, 550) then      
            if CanUseSpell(myHero,_Q) == READY and pI and pI.hitChance >= (Ekko.Combo.CQH:Value()/100) then
             CastSkillShot(_Q, pI.castPos)
            end
        end
         local w = { delay = 3.750, speed = 1000, width = 250, range = 1600 }
         local pI = GetPrediction(t, w)
        if Ekko.Combo.CW:Value() and GetPercentMP(myHero) >= Ekko.Combo.CWM:Value() and ValidTarget(t, 1500) then
            if CanUseSpell(myHero,_W) == READY and pI and pI.hitChance >= (Ekko.Combo.CWH:Value()/100) then
             CastSkillShot(_W, pI.castPos)
            end
        end

         local e = { delay = 0.25, speed = 1050, width = 60, range = 950 }
         local pI = GetPrediction(t, e)
        if Ekko.Combo.CE:Value() and GetPercentMP(myHero) >= Ekko.Combo.CEM:Value() and ValidTarget(t, 900) then
            if CanUseSpell(myHero,_E) == READY then
            CastSkillShot(_E, mousePos.x, mousePos.y, mousePos.z)
            end
        end       
    end
local t = GetCurrentTarget()    
    --Misc
    if CanUseSpell(myHero,_R) == READY and Ekko.Misc.UR:Value() and GetPercentHP(myHero) <= Ekko.Misc.URH:Value() then
     CastSpell(_R)
    end
    if twin and IsReady(_R) and Ekko.Misc.HER:Value() then
        if EnemiesAround(GetOrigin(twin), 300) >= Ekko.Misc.HERX:Value() and IsObjectAlive(t) then
         CastSpell(_R)
        end
    end
    --Killsteal
    for i,e in pairs(GetEnemyHeroes()) do
    	if CanUseSpell(myHero,_R) == READY and IsObjectAlive(e) and EnemiesAround(GetOrigin(twin), 300) >= 1 and Ekko.Killsteal.KR:Value() and GetCurrentHP(e) < CalcDamage(myHero, e, 0, (150*GetCastLevel(myHero,_R)+150+(1.3*(GetBonusAP(myHero))))) then
         CastSpell(_R)
        end
   end
end)       
