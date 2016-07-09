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
