Menu = {}
Menu.GUI = {}
Menu.buttonCount = 0
Menu.selection = 0
Menu.hidden = true
MenuTitle = "Menu"

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function drawTxt(text, font, centre, x, y, scale, r, g, b, a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 1, 1, -1)
end

function Menu.addButton(name, func,args)

	local yoffset = 0.3
	local xoffset = 0
	local xmin = 0.0
	local xmax = 0.2
	local ymin = 0.05
	local ymax = 0.05
	Menu.GUI[Menu.buttonCount+1] = {}
	Menu.GUI[Menu.buttonCount+1]["name"] = name
	Menu.GUI[Menu.buttonCount+1]["func"] = func
	Menu.GUI[Menu.buttonCount+1]["args"] = args
	Menu.GUI[Menu.buttonCount+1]["active"] = false
	Menu.GUI[Menu.buttonCount+1]["xmin"] = xmin + xoffset
	Menu.GUI[Menu.buttonCount+1]["ymin"] = ymin * (Menu.buttonCount + 0.01) +yoffset
	Menu.GUI[Menu.buttonCount+1]["xmax"] = xmax 
	Menu.GUI[Menu.buttonCount+1]["ymax"] = ymax 
	Menu.buttonCount = Menu.buttonCount+1
end


function Menu.updateSelection() 
	if IsControlJustPressed(1, Keys["DOWN"]) then 
		if(Menu.selection < Menu.buttonCount -1 ) then
			Menu.selection = Menu.selection +1
		else
			Menu.selection = 0
		end		
		PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
	elseif IsControlJustPressed(1, Keys["TOP"]) then
		if(Menu.selection > 0)then
			Menu.selection = Menu.selection -1
		else
			Menu.selection = Menu.buttonCount-1
		end	
		PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
	elseif IsControlJustPressed(1, Keys["NENTER"])  then
		MenuCallFunction(Menu.GUI[Menu.selection +1]["func"], Menu.GUI[Menu.selection +1]["args"])
		PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
	--elseif IsControlJustPressed(1, Keys["BACKSPACE"])  then
	--		MenuCallFunction(Menu.GUI[Menu.selection -1]["func"], Menu.GUI[Menu.selection -1]["args"])
	--		PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
	end
	local iterator = 0
	for id, settings in ipairs(Menu.GUI) do
		Menu.GUI[id]["active"] = false
		if(iterator == Menu.selection ) then
			Menu.GUI[iterator +1]["active"] = true
		end
		iterator = iterator +1
	end
end

function Menu.renderButtons(options)

	Menu:setTitle(options)
	Menu:setSubTitle(options)
	Menu:drawButtons(options)

end


function Menu.renderGUI(options)
	if not Menu.hidden then
		Menu.renderButtons(options)
		Menu.updateSelection()
	end
end

function Menu.renderBox(xMin,xMax,yMin,yMax,color1,color2,color3,color4)
	DrawRect(xMin, yMin,xMax, yMax, color1, color2, color3, color4);
end

function Menu:setTitle(options)
   SetTextFont(1)
   SetTextProportional(0)
   SetTextScale(1.0, 1.0)
   SetTextColour(255, 255, 255, 255)
   SetTextDropShadow(0, 0, 0, 0,255)
   SetTextEdge(1, 0, 0, 0, 255)
   SetTextDropShadow()
   SetTextOutline()
   SetTextCentre(1)
   SetTextEntry("STRING")
   AddTextComponentString(options.menu_title)
   DrawText(options.x, options.y)
end

function Menu:setSubTitle(options)
   SetTextFont(2)
   SetTextProportional(0)
   SetTextScale(options.scale +0.1, options.scale +0.1)
   SetTextColour(255, 255, 255, 255)
   SetTextEntry("STRING")
   AddTextComponentString(options.menu_subtitle)
   DrawRect(options.x,(options.y +0.08),options.width,options.height,options.color_r,options.color_g,options.color_b,150)
   DrawText(options.x - options.width/2 + 0.005, (options.y+ 0.08) - options.height/2 + 0.0028)
   
   SetTextFont(0)
   SetTextProportional(0)
   SetTextScale(options.scale, options.scale)
   SetTextColour(255, 255, 255, 255)
   SetTextDropShadow(0, 0, 0, 0,255)
   SetTextEdge(1, 0, 0, 0, 255)
   SetTextDropShadow()
   SetTextOutline()
   SetTextCentre(0)
   SetTextEntry("STRING")
   AddTextComponentString(options.rightText)
   DrawText((options.x + options.width/2 - 0.0385) , options.y + 0.067)
end


function Menu:drawButtons(options)
	local y = options.y + 0.12

	for id, settings in pairs(Menu.GUI) do
		SetTextFont(0)
		SetTextProportional(0)
		SetTextScale(options.scale, options.scale)
		if(settings["active"]) then
			SetTextColour(0, 0, 0, 255)
		else
			SetTextColour(255, 255, 255, 255)
		end
		SetTextCentre(0)
		SetTextEntry("STRING")
		AddTextComponentString(settings["name"])
		if(settings["active"]) then
			DrawRect(options.x,y,options.width,options.height,255,255,255,255)
		else
			DrawRect(options.x,y,options.width,options.height,0,0,0,150)
		end
		DrawText(options.x - options.width/2 + 0.005, y - 0.04/2 + 0.0028)
		y = y + 0.04
	end
end
