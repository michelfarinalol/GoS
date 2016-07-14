--Credits to SxcS and Zwei

local v = 0.01

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
