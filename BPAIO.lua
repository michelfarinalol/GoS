--Credits to SxcS and Zwei

local v = 0.01

GetWebResultAsync("https://raw.githubusercontent.com/wildrelic/GoS/master/BPAIO.version", function(num)
	if v < tonumber(num) then
		PrintChat("[BPAIO] Update Available. x2 f6 to Update.")
		DownloadFileAsync("https://raw.githubusercontent.com/wildrelic/GoS/master/BPAIO.lua", SCRIPT_PATH .. "BPAIO.lua", function() PrintChat("Enjoy your game!") return end)
	end
end)

require("OpenPredict")

local BPChamps = 
	{
	["Annie"] = 		true, 
	["Ashe"] = 			true,
	["Darius"] = 		true,
	["Gnar"] = 			true,
	["Illaoi"] = 		true,
	["Khazix"] = 		true,
	["Jinx"] =			true,
	["Leona"] = 		true,
	["Lux"] = 			true,
	["Nami"] =			true,
	["Olaf"] = 			true,
	["Poppy"] =			true,
	["Ryze"] = 			true,
	["Sejuani"] =		true,
	["Shen"] = 			true,
	["Tristana"] =		true,
	["TwistedFate"] = 	true,
	["Varus"] = 		true,
	["Vayne"] =			true,
	}
	
Callback.Add("Load", function()
	if BPChamps[GetObjectName(myHero)] then
		Start()
		_G[GetObjectName(myHero)]()
		PrintChat(GetObjectName(myHero).." Loaded!")
	else
		PrintChat(GetObjectName(myHero).." Is not supported!")
	end
end)

class "Start"

function Start:__init()
	local myName = myHero.charName
	ConfigMenu = MenuConfig("BPAIO", "BPAIO")
		ConfigMenu:Menu("Champ", "BPAIO "..myName)
end

class "Annie"

function Annie:__init()
