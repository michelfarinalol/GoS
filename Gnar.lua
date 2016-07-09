if GetObjectName(GetmyHero()) ~= "Gnar" then return end

local v = 0.1

GetWebResultAsync("https://raw.githubusercontent.com/wildrelic/GoS/master/Gnar.version", function(num)
	if v < tonumber(num) then
		PrintChat("[Gnar] Update Available. x2 f6 to Update.")
		DownloadFileAsync("https://raw.githubusercontent.com/wildrelic/GoS/master/Gnar.lua", SCRIPT_PATH .. "Gnar.lua", function() PrintChat("Enjoy your game!") return end)
	end
end)

require("OpenPredict")
require("MapPositionGos")
require("DamageLib")

if FileExist(COMMON_PATH.."MixLib.lua") then
	require('MixLib')
else
	PrintChat("MixLib not found. Please wait for download.")
	DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end

--Menu--
GnarMenu = Menu("Gnar", "Gnar")
-----------------------------------------------------------------
GnarMenu:SubMenu("Combo", "Combo")
GnarMenu.Combo:Boolean("Q", "Use Mini Gnar Q", true)
GnarMenu.Combo:Boolean("MQ", "Use Mega Gnar Q", true)
GnarMenu.Combo:Boolean("mQ", "Use Mini Gnar Q Through Minions", true)
GnarMenu.Combo:Boolean("W", "Use Mega Gnar W", true)
GnarMenu.Combo:Boolean("mE", "Use Mini Gnar E", true)
GnarMenu.Combo:Boolean("ekmE", "Use Mini Gnar E if Target Killable", false)
GnarMenu.Combo:Slider("cmE", "Use Mini Gnar E Around # of Enemies", 1, 0, 5, 1)
GnarMenu.Combo:Slider("hmE", "Use Mini Gnar E Under % Gnar Health", 75, 0, 100, 5)
GnarMenu.Combo:Boolean("E", "Use Mega Gnar E", true)
GnarMenu.Combo:Boolean("R", "Use R", true)
GnarMenu.Combo:Slider("eR", "Use R Only on # of Enemies", 2, 1, 5, 1)
GnarMenu.Combo:Boolean("aR", "Auto Use R", true)
GnarMenu.Combo:Slider("aeR", "Auto Use R on # of Enemies", 3, 1, 5, 1)
-----------------------------------------------------------------
GnarMenu:SubMenu("Harass", "Harass")
GnarMenu.Harass:Boolean("Q", "Use Mini Gnar Q", true)
GnarMenu.Harass:Boolean("MQ", "Use Mega Gnar Q", true)
GnarMenu.Harass:Boolean("mQ", "Use Mini Gnar Q through Minions", true)
GnarMenu.Harass:Boolean("W", "Use Mega Gnar W", true)
GnarMenu.Harass:Boolean("E", "Use Mega Gnar E", true)
GnarMenu.Harass:Boolean("mE", "Use Mini Gnar E", true)
-----------------------------------------------------------------
GnarMenu:SubMenu("LC", "LaneClear")
GnarMenu.LC:Boolean("Q", "Use Mini Gnar Q", true)
GnarMenu.LC:Boolean("MQ", "Use Mega Gnar Q", true)
GnarMenu.LC:Boolean("W", "Use Mega Gnar W", true)
GnarMenu.LC:Boolean("E", "Use Mega Gnar E", true)
-----------------------------------------------------------------
GnarMenu:SubMenu("JC", "JungleClear")
GnarMenu.JC:Boolean("Q", "Use Mini Gnar Q", true)
GnarMenu.JC:Boolean("MQ", "Use Mega Gnar Q", true)
GnarMenu.JC:Boolean("W", "Use Mega Gnar W", true)
GnarMenu.JC:Boolean("E", "Use Mega Gnar E", false)
-----------------------------------------------------------------
GnarMenu:SubMenu("LH", "LastHit")
GnarMenu.LH:Boolean("Q", "Use Mini Gnar Q", true)
GnarMenu.LH:Boolean("MQ", "Use Mega Gnar Q", true)
GnarMenu.LH:Boolean("W", "Use Mega Gnar W", false)
GnarMenu.LH:Boolean("E", "Use Mega Gnar E", false)
-----------------------------------------------------------------
GnarMenu:SubMenu("KS", "Killsteal")
GnarMenu.KS:Boolean("Q", "Use Mini Gnar Q", true)
GnarMenu.KS:Boolean("MQ", "Use Mega Gnar Q", true)
GnarMenu.KS:Boolean("W", "Use Mega Gnar W", true)
GnarMenu.KS:Boolean("E", "Use Mega Gnar E", false)
GnarMenu.KS:Boolean("R", "Use R", false)
-----------------------------------------------------------------
GnarMenu:SubMenu("p", "Prediction")
GnarMenu.p:Slider("mpQ", "Mini Gnar Q Hitchance", 20, 0, 100, 5)
GnarMenu.p:Slider("MpQ", "Mega Gnar Q Hitchance", 20, 0, 100, 5)
GnarMenu.p:Slider("pW", "Mega Gnar W Hitchance", 20, 0, 100, 5)
GnarMenu.p:Slider("mpE", "Mini Gnar E Hitchance", 20, 0, 100, 5)
GnarMenu.p:Slider("MpE", "Mega Gnar E Hitchance", 20, 0, 100, 5)
GnarMenu.p:Slider("pR", "Gnar R Hitchance", 20, 0, 100, 5)
-----------------------------------------------------------------
GnarMenu:SubMenu("Draw", "Drawings")
GnarMenu.Draw:Boolean("Q", "Draw Q Range", true)
GnarMenu.Draw:Boolean("W", "Draw W Range", true)
GnarMenu.Draw:Boolean("E", "Draw E Range", true)
GnarMenu.Draw:Boolean("R", "Draw R Range", true)
GnarMenu.Draw:Boolean("DrawQ", "Draw Mega Gnar Q Rock", true)
GnarMenu.Draw:Boolean("DrawDMG", "Draw DMG", true)
GnarMenu.Draw:Boolean("MinQCirc", "Minion Killable by Q", true)
GnarMenu.Draw:Boolean("MinAACirc", "Minion Killable by AA", true)
-----------------------------------------------------------------
