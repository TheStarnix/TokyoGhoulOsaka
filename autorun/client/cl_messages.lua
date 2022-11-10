local bar = Material( "tkg_osaka/bar.png")
local assaut_mode = false
local WPos = ScrW()/2 - ScrW()/6
local HPos = ScrH()/3 - ScrH()/2 + 10
local isBarDrawingText = false
local whatBarDrawingText = ""
local timeBarDrawingText = 0
local scrwBarDrawingText = 2.9

surface.CreateFont( "TKGOsaka_HUDBarFont", {
	font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 25,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

net.Receive("TKGOsaka_BarDrawText", function()
	timeBarDrawingText = net.ReadUInt(5)
	whatBarDrawingText = net.ReadString()
	scrwBarDrawingText = net.ReadFloat()
	isBarDrawingText = true
end)

function bar_drawtext(time, text)
	timeBarDrawingText = time
	whatBarDrawingText = text
	isBarDrawingText = true
end
local count = 0
hook.Add("HUDPaint", "TKGOsaka_HUDBarText", function()
	if isBarDrawingText then
		draw.RoundedBox(4, ScrW()/2.95, ScrH()/2.73, ScrW()/3, ScrH()/13.5, Color(52, 73, 94, 255))
		surface.SetDrawColor( 255,255,255,255 )
		surface.SetMaterial( bar )
		surface.DrawTexturedRect( ScrW()/3, ScrH()/5.67, ScrW()/2.9, ScrH()/2.2)
		draw.SimpleText(whatBarDrawingText, "TKGOsaka_HUDBarFont", ScrW()/scrwBarDrawingText, ScrH()/2.55, Color(255, 255, 255, 255))
		timer.Simple( timeBarDrawingText, function() isBarDrawingText = false end )
	end
	
	
end)