local function RespX(x) return x/1920*ScrW() end
local function RespY(y) return y/1080*ScrH() end

local menu_base = Material( "tkg_osaka/tkg_menu/menu_base_V2.png")  

function OsakaTKG.Menu(text, title_x_pos)
	local frame = vgui.Create("DFrame")
	frame:SetSize(RespX(500),RespY(540))
	frame:SetPos(RespX(710),RespY(1000))
	frame:SetTitle("")
	frame:SetDraggable(true)
	frame:ShowCloseButton(false)
	frame:MakePopup()
	frame:SetAlpha(0)

    frame:AlphaTo(255, 0.2, 0, nil)
    frame:MoveTo(ScrW() / 2 - frame:GetWide() / 2, ScrH() / 2 - frame:GetTall() / 2, 0.5, 0, -1, nil)

	frame.Paint = function(s,w,h)
		surface.SetDrawColor( 255,255,255,255 )
		surface.SetMaterial( menu_base )
		surface.DrawTexturedRect( RespX(0), RespY(0), RespX(500), RespY(530))
	end

	local closeButton = vgui.Create("DButton", frame)
	--closeButton:SetImage( "tkg_osaka/tkg_menu/close_button_V2.png" )
	closeButton:AlignTop(24)
	closeButton:AlignRight(-5)
	closeButton:SetText("")
	closeButton:SetSize(RespX(55), RespY(35))
	closeButton.DoClick = function()
		surface.PlaySound("osaka_sound_tkg/osaka_exit.mp3")
		frame:Remove()
	end
	closeButton.Paint = function()
		draw.SimpleText("X", "Font_3", 0, 0, Color(175,15,15,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end

	local menuButton = vgui.Create("DImageButton", frame)
	menuButton:SetImage( "tkg_osaka/tkg_menu/home_button_V2.png" )
	menuButton:AlignTop(20)
	menuButton:AlignLeft(25)
	menuButton:SetSize(RespX(45), RespY(45))

	local textMenu = vgui.Create("DLabel", frame)
	textMenu:SetPos(title_x_pos, 23)
	textMenu:SetFont("Font_2")
	textMenu:SetText(text)
	textMenu:SetColor(color_white)
	textMenu:SizeToContents()

	local dPanel = vgui.Create("DPanel", frame)
	dPanel:Dock(FILL)
	dPanel:DockMargin(5, 30, 5, 5)
	dPanel:SetPaintBackground(false)

	return frame, menuButton, dPanel, closeButton

end