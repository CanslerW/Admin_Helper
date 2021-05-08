script_name ("Admin Helper")
script_author ("Lucas Cooper")
script_version ("4")

require "lib.moonloader"
local sampev = require 'lib.samp.events'
local imgui = require 'imgui'
local request = require 'requests'
local dir = os.getenv('USERPROFILE') .. '\\Documents\\GTA San Andreas User Files\\SAMP\\chatlogs'
local encoding = require 'encoding', require('inicfg')
local sw, sh = getScreenResolution()
local keys = require 'vkeys'
local main_window_state = imgui.ImBool(false)
local fa = require 'faIcons'
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })
local text_buffer = imgui.ImBuffer(256)
encoding.default = 'CP1251'
u8 = encoding.UTF8
local inicfg = require('inicfg')
local ini = inicfg.load({
    main = {
        InputText1 = u8'���� 1',
        InputText2 = u8'���� 2',
        InputText3 = u8'���� 3',
        InputText4 = u8'���� 4',
        InputText5 = u8'���� 5'
    }}, 'Admin_Helper')
	
strings = {
    '�� ���������',
	'�� ����� ������ ���',
	'������ �������� � ���������',
    '�� �������������',
	'�������������',
	'���',
	'����� ��������� ������ �������� � �� - vk.com/lil_wayne_nigga'
};

local inputBuff = imgui.ImBuffer(ini.main.InputText1, 128)
local inputBuff2= imgui.ImBuffer(ini.main.InputText2, 128)
local inputBuff3 = imgui.ImBuffer(ini.main.InputText3, 128)
local inputBuff4= imgui.ImBuffer(ini.main.InputText4, 128)
local inputBuff5 = imgui.ImBuffer(ini.main.InputText5, 128)

local checked_test = imgui.ImBool(false)
local checked_test_2 = imgui.ImBool(false)
local checked_test_3 = imgui.ImBool(false)

local dialogArr = {"1. ������", "2. �����-������", "3. �������", "4. ���", "5. ����", "6. ������", "7. ���������� ���", "8.������", "9. ���������", "10. ����. �������������", "11. ���.���. ��������", "12. ���.���. ��������", "13. �����. ��������", "14. �����", "15. ������", "16. �������", "17. ������� �������", "18. �������� ��������", "22. �����-45", "23. �����-45 � ����.", "24. ��������� ���", "25. ��������", "26. �����", "27. SPAZ-12", "28. ���-10", "9.��� (MP5)", "30. AK-47", "31. M4A1", "32. ���-9", "33. ����������� �����", "34. ����������� ��������", "35. ���������", "36. �������. ���������", "37. ������", "38. �������", "39. ��������. ����������", "40. ���������", "41. ��������� � �������", "42. ������������", "43. �����������", "44. ���� ������� �������", "45. ����������", "46. �������"}
local dialogStr = ""

for _, str in ipairs(dialogArr) do
    dialogStr = dialogStr .. str .. "\n"
end

local dialogArs = {"1.LSPD", "2. FBI", "3. ������-������� ����", "4. ���.����� �� (�������� ��)", "5. Yakuza", "6. La Cosa Nostra", "7. ����� ��", "8. Biker Club", "9. ����� ��", "10. SFPD", "11. �����������", "12. The Ballas", "13. Los Santos Vagos", "14. ������� �����", "15. Grove Street", "16. San News LS", "17. Varios Los Aztecas", "18. The Rifa", "19. ���������� ������", "20. ����� ��", "21. SASD", "22. ���.����� SF (�������� ��)", "23. Hitmans", "24. ���. ����� LV (�������� ��)", "25. SBO", "26. ����� ��", "27. San News SF", "28. San News LV", "29. �������������", "30. Street Racers"}
local dialogStr1 = ""

for _, str in ipairs(dialogArs) do
    dialogStr1 = dialogStr1 .. str .. "\n"
end

local vehicles = {
	"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perenniel", "Sentinel", "Dumper", "Firetruck", "Trashmaster",
	"Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
	"Esperanto", "Taxi", "Washington", "Bobcat", "Mr Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
	"Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Article Trailer", "Previon",
	"Coach", "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squallo",
	"Seasparrow", "Pizzaboy", "Tram", "Article Trailer 2", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed",
	"Yankee", "Caddy", "Solair", "Topfun Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider",
	"Glendale", "Oceanic", "Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler",
	"ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick",
	"SAN News Maverick", "Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring Racer C", "Sandking",
	"Blista Compact", "Police Maverick", "Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B",
	"Bloodring Banger", "Rancher", "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster",
	"Stuntplane", "Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500",
	"HPV1000", "Cement Truck", "Towtruck", "Fortune", "Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor",
	"Combine Harvester", "Feltzer", "Remington", "Slamvan", "Blade", "Freight (Train)", "Brownstreak (Train)",
	"Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck LA", "Hustler", "Intruder", "Primo", "Cargobob",
	"Tampa", "Sunrise", "Merit", "Utility Van", "Nevada", "Yosemite", "Windsor", "Monster A", "Monster B", "Uranus",
	"Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
	"Freight Flat Trailer (Train)", "Streak Trailer (Train)", "Kart", "Mower", "Dune", "Sweeper", "Broadway",
	"Tornado", "AT400", "DFT-30", "Huntley", "Stafford", "BF-400", "Newsvan", "Tug", "Petrol Trailer", "Emperor",
	"Wayfarer", "Euros", "Hotdog", "Club", "Freight Box Trailer (Train)", "Article Trailer 3", "Andromada", "Dodo",
	"RC Cam", "Launch", "Police Car (LSPD)", "Police Car (SFPD)", "Police Car (LVPD)", "Police Ranger", "Picador", "S.W.A.T.",
	"Alpha", "Phoenix", "Glendale Shit", "Sadler Shit", "Baggage Trailer A", "Baggage Trailer B", "Tug Stairs Trailer", "Boxville", "Farm Trailer"
}

local function getCarId(n)
    for i = 1, #tCarsName do
        if tCarsName[i]:upper():find(n:upper(), 1, true) then
            return i + 399
        end
    end
    return false
end

function imgui.BeforeDrawFrame()
    if fa_font == nil then
        local font_config = imgui.ImFontConfig() -- to use 'imgui.ImFontConfig.new()' on error
        font_config.MergeMode = true
        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fontawesome-webfont.ttf', 14.0, font_config, fa_glyph_ranges)
    end
end


function onQuitGame()

    if not doesDirectoryExist(dir) then createDirectory(dir) end
    
    local name = "Chatlog - " .. os.date("%d.%m %Y") .. ".txt"
    local s = sampGetCurrentServerName()
    
    l1 = (string.len(s) / 2)
    if math.fmod(l1, 2) ~= 0 then l2 = l1 - 0.5 else l2 = l1 end
    
    if doesFileExist(dir .. "\\" .. name) then reading = "a" else reading = "w" end
    
    local f = assert(io.open(os.getenv('USERPROFILE') .. "/Documents/GTA San Andreas User Files/SAMP/chatlogs/" .. name, reading))
    f:write(string.rep("=", 9) .. " " .. s .. " " .. string.rep("=", 9) .. "\n")
    f:write(string.rep("=", 5 + l1) .. " " .. string.match(readChatlog(), "%[(..:..:..)%]") .. " " .. string.rep("=", 5 + l2))
    f:write("\n\n" .. readChatlog() .. "\n\n\n")
    f:close()
    
end

function readChatlog()
    local f = assert(io.open(os.getenv('USERPROFILE') .. "/Documents/GTA San Andreas User Files/SAMP/chatlog.txt", "r"))
    local t = f:read("*all")
    f:close()
        return t
end

function main() -- �������
repeat wait(0) until isSampAvailable()
sampRegisterChatCommand("db1", db1)
sampRegisterChatCommand("cheat", cheat)
sampRegisterChatCommand("bag1", bag1)
sampRegisterChatCommand("antirekl", antirekl)
sampRegisterChatCommand("ah", ah)
sampRegisterChatCommand("dmkpz", dmkpz)
sampRegisterChatCommand("dmzz", dmzz)
sampRegisterChatCommand("dm", dm)
sampRegisterChatCommand("flood", flood)
sampRegisterChatCommand("mat1", mat1)
sampRegisterChatCommand("mat", mat)
sampRegisterChatCommand("mg", mg)
sampRegisterChatCommand("osk", osk)
sampRegisterChatCommand("oskadm", oskadm)
sampRegisterChatCommand("oskrod", oskrod)
sampRegisterChatCommand("trans", trans)
sampRegisterChatCommand("slova", slova)
sampRegisterChatCommand("offrep", offrep)
sampRegisterChatCommand("nrp", nrp)
sampRegisterChatCommand("hp1", hp1)
sampRegisterChatCommand("u", u)
sampRegisterChatCommand("sk", sk)
sampRegisterChatCommand("rk", rk)
sampRegisterChatCommand("pom", pom)
sampRegisterChatCommand("pg", pg)
sampRegisterChatCommand("cr", cr)
sampRegisterChatCommand("guns", cmd_dialog)
sampRegisterChatCommand("fracs", cmd_dialog1)
sampRegisterChatCommand("capsrep", capsrep)
sampRegisterChatCommand('ans', function(arg)
      id, t = arg:match('(%d+)%s(%d+)')
    sampSendChat('/pm '..id..' '..strings[tonumber(t)])
  end)
sampRegisterChatCommand("cr1", cr1)
    sampRegisterChatCommand("cip", function(n)
        if #n == 0 or not tonumber(n) then return sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /cip ID', -1) end
        sampSendChat('/getip '..n)
    end)
sampRegisterChatCommand("vehs", cmd_veh)
sampRegisterChatCommand("vehslist", cmd_vehlist)
sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} ������ ��������...', -1)
sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} ����� ������� ���� ������� �� "J" ��� ��������� /ah', -1)
autoupdate("https://raw.githubusercontent.com/CanslerW/Admin_Helper/master/start.json", '['..string.upper(thisScript().name)..']: ', "https://canslerw.ru")

while true do wait(0)
imgui.Process = main_window_state.v and true
lockPlayerControl(imgui.Process)
if testCheat('j') then -- �������� ��� ������� ������ "������ J"
        ah()
    end
	        local result, button, list, input = sampHasDialogRespond(12) -- /dialog2 (ListBox)

        if result then -- ���� ������ ������
            if button == 1 then -- ���� ������ ������ ������ (�������)
                if list == 0 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 1 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 2 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 3 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 4 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 5 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 6 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
		        elseif list == 7 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 8 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 9 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 10 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 11 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 12 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
				elseif list == 13 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 14 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 15 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 16 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 17 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 18 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
				elseif list == 19 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 20 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 21 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 22 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 23 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 24 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
				elseif list == 25 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 26 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 27 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 28 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 29 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 30 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
				elseif list == 31 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 32 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 33 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 34 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 35 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 36 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
				elseif list == 37 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 38 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 39 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 40 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 41 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                elseif list == 42 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArr[list+1], -1)
                end
            else -- ���� ������ ������ ������ (�������)
                sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}�� ������� ������ ���� ������", -1)
            end
        end
		
			        local result, button, list, input = sampHasDialogRespond(13) -- /dialog2 (ListBox)

        if result then -- ���� ������ ������
            if button == 1 then -- ���� ������ ������ ������ (�������)
           if list == 0 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 1 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 2 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 3 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 4 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 5 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 6 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
		        elseif list == 7 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 8 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 9 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 10 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 11 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 12 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
				elseif list == 13 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 14 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 15 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 16 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 17 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 18 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
				elseif list == 19 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 20 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 21 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 22 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 23 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 24 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
				elseif list == 25 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 26 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 27 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 28 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)
                elseif list == 29 then
                    sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}���������� ������ �������: {FF0000}" .. dialogArs[list+1], -1)

                end
            else -- ���� ������ ������ ������ (�������)
                sampAddChatMessage("{2ed164}[Admin Helper] {FFFFFF}�� ������� ������ ���� �������", -1)
            end
        end
end
end

require('samp.events').onServerMessage = function(color, msg)
    local pName, rIP, nowIP = msg:match('(.+)%[(.+)] IP: {FFFFFF}(.+)')
    if not (pName and rIP and nowIP) then return end
    local response = decodeJson(request.get("http://ip-api.com/json/"..rIP).text)
    sampAddChatMessage('{2ed164}[Admin Helper] {FFA500}REG: ������: {FF0000}'..response.country..'{FFA500}. ������: {FF0000}'..response.regionName, -1)
    sampAddChatMessage('{2ed164}[Admin Helper] {FFA500}REG: �����: {FF0000}'..response.city..'{FFA500}. ���������: {FF0000}'..response.isp, -1)
    local response = decodeJson(request.get("http://ip-api.com/json/"..nowIP).text)
    sampAddChatMessage('{2ed164}[Admin Helper] {FFFFFF}NOW: ������: {FF0000}'..response.country..'{FFFFFF}. ������: {FF0000}'..response.regionName, -1)
    sampAddChatMessage('{2ed164}[Admin Helper] {FFFFFF}NOW: �����: {FF0000}'..response.city..'{FFFFFF}. ���������: {FF0000}'..response.isp, -1)
end

-- ������� ������ �������:

function cmd_vehlist()
   print("���� ������ �����������:")
   sampAddChatMessage("{2ed164}[Admin Helper]:{FFFFFF} ���� ������ ����������� � �������. (������� �� ~)", -1)
   for i, j in pairs(vehicles) do
    print("��������: ".. j ..", ����: ".. i)
	end
end

function cmd_veh(arg)
    if arg == "" then
        sampAddChatMessage("{2ed164}[Admin Helper]:{FFFFFF} ������� ����� ����������.", -1)
	else
		for i = 1, #vehicles do
			if string.find(vehicles[i], arg) then
				sampAddChatMessage("{2ed164}[Admin Helper]:{FFFFFF} ID ����������: {FF0000}" .. vehicles[i] .."{FFFFFF} - {FF0000}" .. i + 399, -1)
				break
			end
			if (i == #vehicles) then
				sampAddChatMessage("{2ed164}[Admin Helper]:{FFFFFF} ������ ���������� �� ������", -1)
			end
		end
    end
end

function cmd_dialog(arg)
    if #arg == 0 then
        sampShowDialog(12, "���� ������", dialogStr, "�������", "�������", 2)
    end
end

function cmd_dialog1(arg)
    if #arg == 0 then
        sampShowDialog(13, "���� �������", dialogStr1, "�������", "�������", 2)
    end
end

function cheat(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/jail " .. id .. " 30 ������������� �����")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /cheat [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� �������� � {FF0000}��������{FFFFFF} �� {FF0000}30 �����{FFFFFF} �� �������: {FF0000}������������� �����', -1)
end)
end
end

function db1(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/jail " .. id .. " 15 ��")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /db1 [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� �������� � {FF0000}��������{FFFFFF} �� {FF0000}15 �����{FFFFFF} �� �������: {FF0000}��', -1)
  end)
end
end

function capsrep(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/mute " .. id .. " 5 caps in /rep")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /capsrep [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� ������ {FF0000}���{FFFFFF} �� {FF0000}5 �����{FFFFFF} �� �������: {FF0000}caps in /rep', -1)
  end)
end
end

function bag1(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/jail " .. id .. " 15 ������")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /bag1 [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� �������� � {FF0000}��������{FFFFFF} �� {FF0000}15 �����{FFFFFF} �� �������: {FF0000}������', -1)
end)
end
end

function antirekl(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/mute " .. id .. " 10 ������������� ����-���� ��� ����� � ����������������")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /antirekl [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� ������ {FF0000}���{FFFFFF} �� {FF0000}10 �����{FFFFFF} �� �������: {FF0000}������������� ����-���� ��� ����� � ����������������', -1)
end)
end
end

function dmkpz(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/jail " .. id .. " 30 �� � ���")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /dmkpz [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� �������� � {FF0000}��������{FFFFFF} �� {FF0000}30 �����{FFFFFF} �� �������: {FF0000}�� � ���', -1)
end)
end
end

function dmzz(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/jail " .. id .. " 25 �� � ��")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /dmzz [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� �������� � {FF0000}��������{FFFFFF} �� {FF0000}25 �����{FFFFFF} �� �������: {FF0000}�� � ��', -1)
end)
end
end

function dm(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/jail " .. id .. " 20 ��")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /dm [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� �������� � {FF0000}��������{FFFFFF} �� {FF0000}20 �����{FFFFFF} �� �������: {FF0000}��', -1)
end)
end
end

function flood(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/mute " .. id .. " 5 ����")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /flood [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� ������ {FF0000}���{FFFFFF} �� {FF0000}5 �����{FFFFFF} �� �������: {FF0000}����', -1)
end)
end
end

function u(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/uval " .. id .. " �� ������������ �������")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /u [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� {FF0000}�������{FFFFFF} �������� �� �������: {FF0000}�� ������������ �������', -1)
end)
end
end

function mat(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/mute " .. id .. " 10 ����������� �������")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /mat [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� ������ {FF0000}���{FFFFFF} �� {FF0000}10 �����{FFFFFF} �� �������: {FF0000}����������� �������', -1)
end)
end
end

function mat1(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/mute " .. id .. " 15 ˸���� �����������")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /mat1 [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� ������ {FF0000}���{FFFFFF} �� {FF0000}15 �����{FFFFFF} �� �������: {FF0000}˸���� �����������', -1)
end)
end
end

function mg(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/mute " .. id .. " 10 �����������")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /mg [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� ������ {FF0000}���{FFFFFF} �� {FF0000}10 �����{FFFFFF} �� �������: {FF0000}�����������', -1)
end)
end
end

function osk(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/mute " .. id .. " 30 ����������� �������")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /osk [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� ������ {FF0000}���{FFFFFF} �� {FF0000}30 �����{FFFFFF} �� �������: {FF0000}����������� �������', -1)
end)
end
end

function oskadm(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/mute " .. id .. " 80 ����������� ���������������")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /oskadm [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� ������ {FF0000}���{FFFFFF} �� {FF0000}80 �����{FFFFFF} �� �������: {FF0000}����������� ���������������', -1)
end)
end
end

function oskrod(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/mute " .. id .. " 180 �����������/���������� ������")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /oskrod [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� ������ {FF0000}���{FFFFFF} �� {FF0000}180 �����{FFFFFF} �� �������: {FF0000}�����������/���������� ������', -1)
end)
end
end

function trans(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/mute " .. id .. " 5 ��������")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /trans [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� ������ {FF0000}���{FFFFFF} �� {FF0000}5 �����{FFFFFF} �� �������: {FF0000}��������', -1)
end)
end
end

function slova(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/mute " .. id .. " 5 ����� ����� ������")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /slova [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� ������ {FF0000}���{FFFFFF} �� {FF0000}5 �����{FFFFFF} �� �������: {FF0000}����� ����� ������', -1)
end)
end
end

function offrep(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/mute " .. id .. " 10 ������ � ������")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /offrep [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� ������ {FF0000}���{FFFFFF} �� {FF0000}10 �����{FFFFFF} �� �������: {FF0000}������ � ������', -1)
end)
end
end

function nrp(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/jail " .. id .. " 20 ˸���� ���-��")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /nrp [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� �������� � {FF0000}��������{FFFFFF} �� {FF0000}20 �����{FFFFFF} �� �������: {FF0000}˸���� ���-��', -1)
end)
end
end

function hp1(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/sethp " .. id .. " 100")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /hp1 [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� ������ ������ 100 ��', -1)
end)
end
end

function rk(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/jail " .. id .. " 10 ��")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /rk [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� �������� � {FF0000}��������{FFFFFF} �� {FF0000}10 �����{FFFFFF} �� �������: {FF0000}��', -1)
end)
end
end

function sk(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/jail " .. id .. " 20 ��")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /sk [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� �������� � {FF0000}��������{FFFFFF} �� {FF0000}20 �����{FFFFFF} �� �������: {FF0000}��', -1)
end)
end
end

function cr(arg)
lua_thread.create(function()
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/acar " .. id .. " 560 1 1")
wait (30)
sampSendChat("/a ����� ������(������) ������ ��� ID ".. id .."")
else
sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
wait (30)
sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /cr [id]', -1)
wait (30)
sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� ������ ������ ��� ��������� {FF0000}Sultan[560]', -1)
end
end)
end

function cr1(arg)
lua_thread.create(function()
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/acar " .. id .. " 560 1 1")
wait (30)
sampAddChatMessage("{2ed164}[Admin Helper]:{FFFFFF} ������� ������ ������(sultan) ������ ��� ID ".. id .."")
else
sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
wait (30)
sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /cr [id]', -1)
wait (30)
sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� ������ ������ ��� ��������� {FF0000}Sultan[560]', -1)
end
end)
end

function pg(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/jail " .. id .. " 20 ��")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /pg [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� �������� � {FF0000}��������{FFFFFF} �� {FF0000}20 �����{FFFFFF} �� �������: {FF0000}��', -1)
end)
end
end

function pom(arg)
if tonumber(arg) then
id = tonumber(arg)
sampSendChat("/kick " .. id .. " ������")
else
  lua_thread.create(function()
  sampAddChatMessage('{2ed164}[Admin Helper]:{FF0000} ERROR', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �������: /pom [id]', -1)
  wait (30)
  sampAddChatMessage('{2ed164}[Admin Helper]:{FFFFFF} �� {FF0000}�������{FFFFFF} �� �������: {FF0000}������', -1)
end)
end
end

function ah(arg)
main_window_state.v = not main_window_state.v
end

function imgui.OnDrawFrame()
    if main_window_state.v then
        local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(1070, 500), imgui.Cond.FirstUseEver)
        imgui.Begin(fa.ICON_PENCIL .. u8"  Admin_Helper | by Lucas_Cooper | vk.com/x202xx", main_window_state)
        imgui.BeginChild("child", imgui.ImVec2(255, 430), true)
        if imgui.Button(u8"�������", imgui.ImVec2(-1, 75)) then menu = 1 end
        if imgui.Button(u8"������ ���������/�������", imgui.ImVec2(-1, 75)) then menu = 2 end
        if imgui.Button(u8"�������� ������", imgui.ImVec2(-1, 75)) then menu = 3 end
        if imgui.Button(u8"�������", imgui.ImVec2(-1, 75)) then menu = 4 end
        if imgui.Button(u8"������", imgui.ImVec2(-1, 75)) then menu = 5 end
        imgui.EndChild()
        imgui.SameLine()
        if menu == 1 then
            imgui.BeginChild("##child1", imgui.ImVec2(780, 450), true)
        if imgui.InputText(u8'##1', inputBuff) then ini.main.InputText1 = inputBuff.v end
        if imgui.Button(u8'��������� �����##1') then
            sampSendChat(u8:decode(inputBuff.v))
        end
        if imgui.InputText(u8'##2', inputBuff2) then ini.main.InputText2 = inputBuff2.v end
        if imgui.Button(u8'��������� �����##2') then
            sampSendChat(u8:decode(inputBuff2.v))
        end
        if imgui.InputText(u8'##3', inputBuff3) then ini.main.InputText3 = inputBuff3.v end
        if imgui.Button(u8'��������� �����##3') then
            sampSendChat(u8:decode(inputBuff3.v))
        end
        if imgui.InputText(u8'##4', inputBuff4) then ini.main.InputText4 = inputBuff4.v end
        if imgui.Button(u8'��������� �����##4') then
            sampSendChat(u8:decode(inputBuff4.v))
        end
        if imgui.InputText(u8'##5', inputBuff5) then ini.main.InputText5 = inputBuff5.v end
        if imgui.Button(u8'��������� �����##5') then
            sampSendChat(u8:decode(inputBuff5.v))
        end
        if imgui.Button(u8'���������') then
            inicfg.save(ini, 'Admin_Helper') end
            imgui.EndChild()
        end
        imgui.SameLine()
        if menu == 2 then
            imgui.BeginChild("##child2", imgui.ImVec2(780, 450), true)
          if imgui.CollapsingHeader(u8'������ ���������� ���� ������ (/mute)') then
    imgui.TextColoredRGB('- ����� ����� ������ - {FF0000}5 �����.')
    imgui.TextColoredRGB('- MetaGaming - {FF0000}10 �����.')
    imgui.TextColoredRGB('- MetaGaming - ����� ���������� - ?, ), :* � ��� ����� - {FF0000}5 �����.')
    imgui.TextColoredRGB('- Flood (3 ���������� ������) - 5 �����. (� ������ ������� - {FF0000}15 �����)')
    imgui.TextColoredRGB('- CapsLock - {FF0000}5 ����� (���������� - ����������� ������ ���������)')
    imgui.TextColoredRGB('- �������� - {FF0000}5 ����� (���������� - ������(OOC)')
    imgui.TextColoredRGB('- ������ � ������ - {FF0000}10 ����� (���������� - 1 ���(/pm ID 4)')
    imgui.TextColoredRGB('- ����������� ������� - {FF0000}10 ����� (���������� - ����������� ������ ���������)')
    imgui.TextColoredRGB('- ˸���� ����������� - {FF0000}15 ����� (���������� - IC ���)')
    imgui.TextColoredRGB('- ����������� ������������� - {FF0000}20-80 �����. (����� � �.� - 20 ���)')
    imgui.TextColoredRGB('- ����������� ������ - {FF0000}180 �����.')
    imgui.TextColoredRGB('- ˸���� ����������� ������� - {FF0000}60 �����.')
    imgui.TextColoredRGB('- ���������� �������� ������������� - {FF0000}10 ����� (���������� � 1 ���(/pm ID 4)).')
    imgui.TextColoredRGB('- ��������������/�� ������ ������� ���������� - {FF0000}10 �����.')
    imgui.TextColoredRGB('- ������ ���� �� �������������� - {FF0000}20 �����. (����� /kick)')
    end
          if imgui.CollapsingHeader(u8'���������� � ��-������ (/jail) � ������ �������������� (/warn)') then
    imgui.TextColoredRGB('- DM �� ������� ������� -{FF0000} 15 �����.')
    imgui.TextColoredRGB('- DM(� ������ ����) �� ������� ������� - {FF0000}25 �����.')
    imgui.TextColoredRGB('- DM(� ������ ����) �� ������� ��������� �� ������� - /jail - {FF0000}30 ����� � ����������� �� ��������')
    imgui.TextColoredRGB('- DB - {FF0000}15 �����.')
    imgui.TextColoredRGB('- Rk - {FF0000}10 �����.')
    imgui.TextColoredRGB('- SK - {FF0000}20 �����.')
    imgui.TextColoredRGB('- PG - {FF0000}20 �����.')
    imgui.TextColoredRGB('- ������������� ���-�������� - {FF0000}Jail �� 30 �����.')
    imgui.TextColoredRGB('- TK - {FF0000}Jail �� 15 �����.')
    imgui.TextColoredRGB('- ������ - {FF0000}Jail �� 20 �����.')
    imgui.TextColoredRGB('- ����� ���� (����� ����������� ��� ����� ������ ���� ��� �� ���������) - {FF0000}jail �� 10 ����� �����������. � ������� ������.')
    imgui.TextColoredRGB('- ���� ����������� �� - {FF0000}warn.')
    end
          if imgui.CollapsingHeader(u8'���������� ��������(/ban)') then
    imgui.TextColoredRGB('- ������� - {FF0000}30 ���� + /banip')
    imgui.TextColoredRGB('- �������������� ��� - {FF0000}30 ����.')
    imgui.TextColoredRGB('- ������� ��� ��������� - {FF0000}30 ����.')
    imgui.TextColoredRGB('- ��������/�������/����� �������� - {FF0000}30 ����')
    imgui.TextColoredRGB(' ���� �������� - {FF0000}iban �� 2033')
    imgui.TextColoredRGB('- ������� ��������� �� �������� ������ - {FF0000}30 ����.')
    imgui.TextColoredRGB('- ����� ������� - {FF0000}5 ����.')
    imgui.TextColoredRGB('- ������������ ����������� ������������� � ������ ����� ������ ���� - {FF0000}5 ����.')
    imgui.TextColoredRGB('- ����������� ������� - {FF0000}30 ����.')
    end
          if imgui.CollapsingHeader(u8'�� ������ ��������� ��������') then
    imgui.TextColoredRGB('- {FF0000}��������.')
    imgui.TextColoredRGB('- {FF0000}������.')
    imgui.TextColoredRGB('- {FF0000}��������� ������������� �������/���������������.')
    imgui.TextColoredRGB('- {FF0000}�������� � ����� ���������.')
    imgui.TextColoredRGB('- {FF0000}������� �� ��.')
    imgui.TextColoredRGB('- {FF0000}�������� ����� �� (���� ����� �� ����� �� ����� ������, � �� ����������� �� ��� ����� � ���)')
    end
          if imgui.CollapsingHeader(u8'������� ������ #1') then
    imgui.TextColoredRGB('- /pm id 1 {FF0000}(�������� �� �������) ')
    imgui.TextColoredRGB('- /pm id 2 {FF0000}(��������� �� �������) ')
    imgui.TextColoredRGB('- /pm id 3 {FF0000}(����� ������')
    imgui.TextColoredRGB('- /pm id 4 {FF0000}(�� ���������) ')
    imgui.TextColoredRGB('- /pm id 5 {FF0000}(������ �� �����)')
    end
          if imgui.CollapsingHeader(u8'������� ������ #2') then
    imgui.TextColoredRGB('- /ans id 1 {FF0000}(�� ���������) ')
    imgui.TextColoredRGB('- /ans id 2 {FF0000}(�� ����� ������ ���) ')
    imgui.TextColoredRGB('- /ans id 3 {FF0000}(������ �������� � ���������)')
    imgui.TextColoredRGB('- /ans id 4 {FF0000}(�� �������������) ')
    imgui.TextColoredRGB('- /ans id 5 {FF0000}(�������������)')
	imgui.TextColoredRGB('- /ans id 6 {FF0000}(���)')
	imgui.TextColoredRGB('- /ans id 7 {FF0000}(����� ��������� ������ �������� � �� - vk.com/lil_wayne_nigga)')
    end
            imgui.EndChild()
        end
        imgui.SameLine()
        if menu == 3 then
            imgui.BeginChild("##child3", imgui.ImVec2(780, 430), true)
 if imgui.CollapsingHeader(u8'- ����') then
    imgui.Text(u8'������������: /cheat ID')
    imgui.Text(u8'�� �������� � �������� �� 30 ����� �� �������: ����')
    end
        if imgui.CollapsingHeader(u8'- ��') then
    imgui.Text(u8'������������: /db1 ID')
    imgui.Text(u8'�� �������� � �������� �� 15 ����� �� �������: ��')
    end
        if imgui.CollapsingHeader(u8'- ������') then
    imgui.Text(u8'������������: /bag1 ID')
    imgui.Text(u8'�� �������� � �������� �� 15 ����� �� �������: ������')
    end
        if imgui.CollapsingHeader(u8'- �� � ���') then
    imgui.Text(u8'������������: /dbkpz ID')
    imgui.Text(u8'�� �������� � �������� �� 30 ����� �� �������: �� � ���')
    end
        if imgui.CollapsingHeader(u8'- �� � ��') then
    imgui.Text(u8'������������: /dmzz ID')
    imgui.Text(u8'�� �������� � �������� �� 25 ����� �� �������: �� � ��')
    end
        if imgui.CollapsingHeader(u8'- ��') then
    imgui.Text(u8'������������: /dm ID')
    imgui.Text(u8'�� �������� � �������� �� 20 ����� �� �������: ��')
    end
        if imgui.CollapsingHeader(u8'- ����') then
    imgui.Text(u8'������������: /flood ID')
    imgui.Text(u8'�� ������ ��� �� 5 ����� �� �������: ����')
    end
        if imgui.CollapsingHeader(u8'- ���� ���') then
    imgui.Text(u8'������������: /u ID')
    imgui.Text(u8'�� ������� �������� �� �������: ���')
    end
        if imgui.CollapsingHeader(u8'- ����������� �������') then
    imgui.Text(u8'������������: /mat ID')
    imgui.Text(u8'�� ������ ��� �� 10 ����� �� �������: ����������� �������')
    end
        if imgui.CollapsingHeader(u8'- ���� � ������') then
    imgui.Text(u8'������������: /capsrep ID')
    imgui.Text(u8'�� ������ ��� �� 5 ����� �� �������: caps in /rep')
    end
        if imgui.CollapsingHeader(u8'- ˸���� �����������') then
    imgui.Text(u8'������������: /mat1 ID')
    imgui.Text(u8'�� ������ ��� �� 15 ����� �� �������: ˸���� �����������')
    end
        if imgui.CollapsingHeader(u8'- �����������') then
    imgui.Text(u8'������������: /mg ID')
    imgui.Text(u8'�� ������ ��� �� 10 ����� �� �������: �����������')
    end
        if imgui.CollapsingHeader(u8'- ����������� �������') then
    imgui.Text(u8'������������: /osk ID')
    imgui.Text(u8'�� ������ ��� �� 30 ����� �� �������: ����������� �������')
    end
        if imgui.CollapsingHeader(u8'- ����������� �������') then
    imgui.Text(u8'������������: /oskadm ID')
    imgui.Text(u8'�� ������ ��� �� 80 ����� �� �������: ����������� �������')
    end
        if imgui.CollapsingHeader(u8'- �����������/���������� ������') then
    imgui.Text(u8'������������: /oskrod ID')
    imgui.Text(u8'�� ������ ��� �� 180 ����� �� �������: �����������/���������� ������')
    end
        if imgui.CollapsingHeader(u8'- ��������') then
    imgui.Text(u8'������������: /trans ID')
    imgui.Text(u8'�� ������ ��� �� 5 ����� �� �������: ��������')
    end
        if imgui.CollapsingHeader(u8'- ����� ����� ������') then
    imgui.Text(u8'������������: /slova ID')
    imgui.Text(u8'�� ������ ��� �� 5 ����� �� �������: ����� ����� ������')
    end
        if imgui.CollapsingHeader(u8'- ˸���� ���-��') then
    imgui.Text(u8'������������: /nrp ID')
    imgui.Text(u8'�� �������� � �������� �� 20 ����� �� �������: ˸���� ���-��')
    end
        if imgui.CollapsingHeader(u8'- ������ 100 �� | �������� � 5+ ������ ������') then
    imgui.Text(u8'������������: /hp1 ID')
    imgui.Text(u8'�� ������ ������ 100 ��')
    end
        if imgui.CollapsingHeader(u8'- ������ ���������') then
    imgui.Text(u8'������������: /cr ID')
    imgui.Text(u8'�� ������ ������ ��� ��������� {FF0000}Sultan[560]')
    imgui.Text(u8'� ��������� ��� ������� "����� ������ ������ ��� ID <ID>"')
    end
        if imgui.CollapsingHeader(u8'- ������') then
    imgui.Text(u8'������������: /pom ID')
    imgui.Text(u8'�� ������� �� �������: ������')
    end
        if imgui.CollapsingHeader(u8'- ��') then
    imgui.Text(u8'������������: /sk ID')
    imgui.Text(u8'�� �������� � �������� �� 20 ����� �� �������: ��')
    end
        if imgui.CollapsingHeader(u8'- ��') then
    imgui.Text(u8'������������: /rk ID')
    imgui.Text(u8'�� �������� � �������� �� 10 ����� �� �������: ��')
    end
        if imgui.CollapsingHeader(u8'- ��') then
    imgui.Text(u8'������������: /pg ID')
    imgui.Text(u8'�� �������� � �������� �� 20 ����� �� �������: ��')
    end
     if imgui.CollapsingHeader(u8'- ID ������') then
    imgui.Text(u8'������������: /guns')
    imgui.Text(u8'���� � ���� ������')
    end
     if imgui.CollapsingHeader(u8'- ID �������') then
    imgui.Text(u8'������������: /fracs')
    imgui.Text(u8'���� � ���� �������')
    end
    if imgui.CollapsingHeader(u8'- ID �����') then
    imgui.Text(u8'������������: /vehs [�������� ������]')
	imgui.Text(u8'������ �����. ������������: /vehslist')
    end
    if imgui.CollapsingHeader(u8'- ���. ������ | �������� � 9+ ������ ������') then
    imgui.Text(u8'������������: /�ip ID')
    end
    if imgui.CollapsingHeader(u8'- ������ ������� | �������� � 8+ ������ ������') then
    imgui.Text(u8'������������: /cr ID')
    imgui.Text(u8'�� �������� ������, ����� ������� � /a ��� �� ������ ������')
    end
    if imgui.CollapsingHeader(u8'- ������ �������(��� /a) | �������� � 8+ ������ ������') then
    imgui.Text(u8'������������: /cr1 ID')
    end
            imgui.EndChild()
        end
        imgui.SameLine()
        if menu == 4 then
            imgui.BeginChild("##chlind4", imgui.ImVec2(780, 450), true)
       if imgui.Button(u8"������� #1", imgui.ImVec2(150,30)) then
          lua_thread.create(function()
              sampSendChat("/aad ������� ���� ����� �������� > /ask | �������� ���� �� Simple Role Play ;)")
                wait (3000)
              sampSendChat("/aad ������������� ���� ����� �����/�������� > /rep | �������� ���� �� Simple Role Play ;)")
                wait (3000)
              sampSendChat("/aad ����� ������? ���������� ���� ��������� ������ �� Simple FM > /play - Simple FM")
          end)
       end
       imgui.Text(u8'- ������� ���� �������/������ ���� �����/����� Simple FM', imgui.SameLine())
       if imgui.Button(u8"������� #2", imgui.ImVec2(150,30)) then
          lua_thread.create(function()
              sampSendChat("/aad ������������, ��������� ������! ������ �������� ��� , ��� ������ ����� � ������ ������� ���������")
                wait (3000)
              sampSendChat("/aad ��� ������� ��������� ������� ��������� �����������: ������ ������� �� ���� �������")
                wait (3000)
              sampSendChat("/aad ����� ������/����� ����� ������� ��������/����������� �� ���� ��������������.")
                wait (3000)
              sampSendChat("/aad �� ������ �� ������� �������� �����: RealDonate/DonateMoney ����� VIP - �������.")
                wait (3000)
              sampSendChat('/aad ��� ��������� ����������, ������� ����� �� ������ "������ �������� ������ ���������"')
          end)
       end
        imgui.Text(u8'- ����� � �������', imgui.SameLine())
       if imgui.Button(u8"������� #3", imgui.ImVec2(150,30)) then
          lua_thread.create(function()
              sampSendChat("/aad ��������� ������, �� ������ ������� ��������� �� ���������� � ����-�������. ���� ����!")
                wait (3000)
              sampSendChat("/aad ����� �������, � ������� ����� 10 �����. �������!!")
          end)
       end
        imgui.Text(u8'- ����� � ���� �������', imgui.SameLine())
       if imgui.Button(u8"������� #3", imgui.ImVec2(150,30)) then
          lua_thread.create(function()
              sampSendChat("/aad ������� ������� ����� ������ � ������ �������� ����� �� ���� ������������� �� ����� Simple FM")
                wait (3000)
              sampSendChat("/aad ����� �� ��������� � ����� ������, �������, ��������, ��������, ���������� ���� � ����� ����")
                wait (3000)
              sampSendChat("/aad ����� ������:��(RealDonate), ���.������ ������ ������ �� ���������, ������� ���������, ���������� ���������� <3")
                wait (3000)
              sampSendChat('/aad ��� ��������� ����������, ������� ����� �� ������ "������ �����"')
          end)
       end
       imgui.Text(u8'- ����� � ����� �������� Simple FM', imgui.SameLine())
            imgui.EndChild()
        end
        if menu == 5 then
        imgui.BeginChild("##chlind5", imgui.ImVec2(780, 450), true)
		if imgui.Checkbox(u8"���������", checked_test) then
          sampSendChat("/chat")
         end
         imgui.SameLine()
		if imgui.Checkbox(u8"��������� SMS", checked_test_2) then
          sampSendChat("/chatsms")
         end
         imgui.SameLine()
    if imgui.Checkbox(u8"��������� �������", checked_test_3) then
          sampSendChat("/dming")
         end
    if imgui.Button(u8"���� ������", imgui.ImVec2(300, 25)) then
	      sampShowDialog(12, "���� ������", dialogStr, "�������", "�������", 2)
          main_window_state.v = false
         end
		 imgui.SameLine()
    if imgui.Button(u8"���� �������", imgui.ImVec2(300, 25)) then
	      sampShowDialog(13, "���� �������", dialogStr1, "�������", "�������", 2)
          main_window_state.v = false
         end
    if imgui.Button(u8"������ ���� ��", imgui.ImVec2(300, 25)) then
           sampSendChat("/hp")
         end
		 imgui.SameLine()
    if imgui.Button(u8"��������� ��� ����", imgui.ImVec2(300, 25)) then
	      sampSendChat("/fuelallcar")
         end
      if imgui.CollapsingHeader(u8'���������') then
        if imgui.CollapsingHeader(u8'��������� � ������') then
           if imgui.Button(u8'������ ��') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, -2026.05, 178.99, 28.84 - 1)
           end
           imgui.SameLine()
           if imgui.Button(u8'������ ��') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 1797.26, 843.42, 10.63 - 1)
           end
           imgui.SameLine()
           if imgui.Button(u8'������ ��') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 1227.05, -1385.15, 13.39 - 1)
           end
        end
        if imgui.CollapsingHeader(u8'��������� � ���.�������') then
           if imgui.Button(u8'���������') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, -2042.63, -96.06, 35.16 - 1)
           end
           if imgui.Button(u8'FBI') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, -2521.53, -610.63, 132.56 - 1)
           end
           if imgui.Button(u8'LSPD') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 1540.55, -1675.55, 13.55 - 1)
           end
           imgui.SameLine()
           if imgui.Button(u8'SASD') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 2233.38, 2454.57, 10.82 - 1)
           end
           imgui.SameLine()
           if imgui.Button(u8'SFPD') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, -1625.13, 668.03, 7.19 - 1)
           end
           if imgui.Button(u8'SBO') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 2504.30, 2397.16, 4.21 - 1)
           end
           if imgui.Button(u8'����� ��') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 2612.17, -2403.08, 13.54 - 1)
           end
           imgui.SameLine()
           if imgui.Button(u8'����� ��') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 137.25, 1927.30, 19.19 - 1)
           end
           imgui.SameLine()
           if imgui.Button(u8'����� ��') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, -1530.67, 496.89, 7.18 - 1)
           end
           if imgui.Button(u8'�������� ��') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 1187.75, -1324.89, 13.56 - 1)
           end
           imgui.SameLine()
           if imgui.Button(u8'�������� ��') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 1606.61, 1833.56, 10.82 - 1)
           end
           imgui.SameLine()
           if imgui.Button(u8'�������� ��') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, -2655.14, 626.82, 14.45 - 1)
           end
           if imgui.Button(u8'����� ��') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 1499.70, -1287.34, 14.44 - 1)
           end
           imgui.SameLine()
           if imgui.Button(u8'����� ��') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 2219.16, 1800.80, 10.82 - 1)
           end
           imgui.SameLine()
           if imgui.Button(u8'����� ��') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, -2758.91, 375.22, 4.34 - 1)
           end
           imgui.SameLine()
           if imgui.Button(u8'�������������') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, -1754.40, 953.89, 24.74 - 1)
           end
         end
        if imgui.CollapsingHeader(u8'��������� ������ �����������') then
           if imgui.Button(u8'�������') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, -1985.69, -1532.13, 128.49 - 1)
           end
           if imgui.Button(u8'Street Racer Club') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, -306.92, 1522.54, 65.36  - 1)
           end
           if imgui.Button(u8'Biker Club') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, -1268.73, 2702.45, 50.06  - 1)
           end
           if imgui.Button(u8'San News LS') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 1657.24, -1697.41, 15.61 - 1)
           end
           imgui.SameLine()
           if imgui.Button(u8'San News LV') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 2127.41, 2362.40, 10.82 - 1)
           end
           imgui.SameLine()
           if imgui.Button(u8'San News SF') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, -1806.91, 540.35, 35.16 - 1)
           end
        end
        if imgui.CollapsingHeader(u8'��������� ���������� �����������') then
           if imgui.Button(u8'Groove Street') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 2491.29, -1676.35, 13.34 - 1)
           end
           imgui.SameLine()
           if imgui.Button(u8'Los Santos Vagos') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 2744.66, -1176.95, 69.40 - 1)
           end
           imgui.SameLine()
           if imgui.Button(u8'Varios Los Aztecas') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 2180.14, -1797.71, 13.36 - 1)
           end
           imgui.SameLine()
           if imgui.Button(u8'The Rifa') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 2769.97, -1914.70, 12.52 - 1)
           end
		   imgui.SameLine()
           if imgui.Button(u8'The Ballas Gang') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 2000.03, -1133.72, 25.33 - 1)
           end
		end
        if imgui.CollapsingHeader(u8'��������� ��������� ���������') then
           if imgui.Button(u8'La Cosa Nostra') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 1473.87, 2773.20, 10.82 - 1)
           end
           imgui.SameLine()
           if imgui.Button(u8'Yakuza') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 1474.16, 2773.29, 10.82 - 1)
           end
           imgui.SameLine()
           if imgui.Button(u8'Russian Mafia') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 960.80, 1734.23, 8.65 - 1)
           end
		end
	    if imgui.CollapsingHeader(u8'��������� ������') then
		if imgui.Button(u8'Alhambra') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 1829.39, -1681.68, 13.55 - 1)
           end
		imgui.SameLine()
		if imgui.Button(u8'������') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, -2622.83, 1409.19, 7.10 - 1)
           end
		if imgui.Button(u8'��������') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 5506.66, 1242.14, 23.19 - 1)
           end
		imgui.SameLine()
		if imgui.Button(u8'��� �� ����') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 437.54, -1964.09, 4.29 - 1)
           end
		imgui.SameLine()
		if imgui.Button(u8'����') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 155.33, -1937.44, 3.77 - 1)
           end
		imgui.SameLine()
		if imgui.Button(u8'��������') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 837.73, -1101.07, 24.30 - 1)
           end
		if imgui.Button(u8'������ ��') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 1021.30, -1129.49, 23.87 - 1)
           end
		imgui.SameLine()
		if imgui.Button(u8'������ ��') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 2032.34, 1008.44, 10.82 - 1)
           end
		if imgui.Button(u8'���� ��') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 1423.67, -1702.19, 13.55 - 1)
           end
		imgui.SameLine()
		if imgui.Button(u8'���� ��') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 2434.86, 2376.16, 10.82 - 1)
           end
		imgui.SameLine()
		if imgui.Button(u8'���� ��') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, -2041.30, 469.50, 35.17 - 1)
           end
		if imgui.Button(u8'��������� ��') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 551.60, -1288.57, 17.25 - 1)
           end
		imgui.SameLine()
		if imgui.Button(u8'��������� ��') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, 2201.94, 1388.84, 10.82 - 1)
           end
		imgui.SameLine()
		if imgui.Button(u8'��������� ��') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, -1973.60, 284.99, 35.17 - 1)
           end
		if imgui.Button(u8'����� ��� ������ #1') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, -505.59, -142.00, 71.91 - 1)
           end
		imgui.SameLine()
		if imgui.Button(u8'����� ��� ������ #2') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, -382.20, 2228.69, 42.09 - 1)
           end
		imgui.SameLine()
		if imgui.Button(u8'����� ��� ������ #3') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, -1301.21, 2505.98, 86.99  - 1)
           end
		imgui.SameLine()
		if imgui.Button(u8'����� ��� ������ #4') then
               local x, y, z = getCharCoordinates(playerPed)
               setCharCoordinates(playerPed, -1434.74, -1522.64, 101.75 - 1)
           end
		end
      end
        imgui.EndChild()
        end
        imgui.End()
    end
end
function imgui.TextColoredRGB(text)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else imgui.Text(u8(w)) end
        end
    end

    render_text(text)
end

function apply_custom_style() -- �����
   imgui.SwitchContext()
   local style = imgui.GetStyle()
   local colors = style.Colors
   local clr = imgui.Col
   local ImVec4 = imgui.ImVec4
   local ImVec2 = imgui.ImVec2

    style.WindowPadding = ImVec2(15, 15)
    style.WindowRounding = 15.0
    style.FramePadding = ImVec2(5, 5)
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
    style.ItemSpacing = ImVec2(12, 8)
    style.ItemInnerSpacing = ImVec2(8, 6)
    style.IndentSpacing = 25.0
    style.ScrollbarSize = 15.0
    style.ScrollbarRounding = 15.0
    style.GrabMinSize = 15.0
    style.GrabRounding = 7.0
    style.ChildWindowRounding = 8.0
    style.FrameRounding = 6.0


      colors[clr.Text] = ImVec4(0.95, 0.96, 0.98, 1.00)
      colors[clr.TextDisabled] = ImVec4(0.36, 0.42, 0.47, 1.00)
      colors[clr.WindowBg] = ImVec4(0.11, 0.15, 0.17, 1.00)
      colors[clr.ChildWindowBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
      colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
      colors[clr.Border] = ImVec4(0.43, 0.43, 0.50, 0.50)
      colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
      colors[clr.FrameBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
      colors[clr.FrameBgHovered] = ImVec4(0.12, 0.20, 0.28, 1.00)
      colors[clr.FrameBgActive] = ImVec4(0.09, 0.12, 0.14, 1.00)
      colors[clr.TitleBg] = ImVec4(0.09, 0.12, 0.14, 0.65)
      colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
      colors[clr.TitleBgActive] = ImVec4(0.08, 0.10, 0.12, 1.00)
      colors[clr.MenuBarBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
      colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.39)
      colors[clr.ScrollbarGrab] = ImVec4(0.20, 0.25, 0.29, 1.00)
      colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00)
      colors[clr.ScrollbarGrabActive] = ImVec4(0.09, 0.21, 0.31, 1.00)
      colors[clr.ComboBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
      colors[clr.CheckMark] = ImVec4(0.28, 0.56, 1.00, 1.00)
      colors[clr.SliderGrab] = ImVec4(0.28, 0.56, 1.00, 1.00)
      colors[clr.SliderGrabActive] = ImVec4(0.37, 0.61, 1.00, 1.00)
      colors[clr.Button] = ImVec4(0.20, 0.25, 0.29, 1.00)
      colors[clr.ButtonHovered] = ImVec4(0.28, 0.56, 1.00, 1.00)
      colors[clr.ButtonActive] = ImVec4(0.06, 0.53, 0.98, 1.00)
      colors[clr.Header] = ImVec4(0.20, 0.25, 0.29, 0.55)
      colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
      colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
      colors[clr.ResizeGrip] = ImVec4(0.26, 0.59, 0.98, 0.25)
      colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
      colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
      colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
      colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
      colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
      colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
      colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
      colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
      colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
      colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
      colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end
apply_custom_style()

-- Author: http://qrlk.me/samp | ����������
--
function autoupdate(json_url, prefix, url)
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  downloadUrlToFile(json_url, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            f:close()
            os.remove(json)
            if updateversion ~= thisScript().version then
              lua_thread.create(function(prefix)
                local dlstatus = require('moonloader').download_status
                local color = -1
                sampAddChatMessage(('{2ed164}[Admin Helper]:{FFFFFF} ���������� ����������. ������� ���������� c{FF0000} v.'..thisScript().version..'{FFFFFF} �� {FF0000}v.'..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('��������� %d �� %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('�������� ���������� ���������.')
                      sampAddChatMessage(('{2ed164}[Admin Helper]:{FFFFFF} ���������� ���������!'), color)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage(('{2ed164}[Admin Helper]:{FF0000} ���������� ������ ��������. �������� ���������� ������..'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              sampAddChatMessage('{2ed164}[Admin Helper]: {FFFFFF}���������� �� ���������. ������ ������{FF0000} v.'..thisScript().version..'', -1)
            end
          end
        else
          sampAddChatMessage('{2ed164}[Admin Helper]: {FFFFFF}�� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end

function imgui.TextQuestion(text) -- �������� ������ (!)
    imgui.TextDisabled('(?)')
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450)
        imgui.TextUnformatted(text)
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end