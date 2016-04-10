--Duby: Lets allow the clients to recieve the vote system and make a lovely vote box for it.


Votemap = {}
Votemap.Maps = {}


function Votemap:ToggleMenu( bl )

	if ( !bl ) then
		if ( Votemap.Menu ) then
			Votemap.Menu:SetVisible( false )
			Votemap.Menu = nil
		end
		
		return
	end

	local w, h = ScrW(), ScrH()
	
	Votemap.Menu = vgui.Create("DFrame")
	Votemap.Menu:SetTitle("")
	Votemap.Menu:SetSize(400, 400)
	--Votemap.Menu:SetVisible(false)
	--Votemap.Menu:Center()
	Votemap.Menu:SetPos(w * 0.41, h * 0.84)
	Votemap.Menu:MakePopup()
	Votemap.Menu:SetKeyBoardInputEnabled()
	Votemap.Menu:ShowCloseButton(false)
	Votemap.Menu:SetDraggable(false)
	Votemap.Menu.Paint = function()
		surface.SetDrawColor(0,0,0,0)	
	end
	


	Votemap.Menu.ListView = vgui.Create("DListView", Votemap.Menu)
	--Votemap.Menu.ListView:SetSize( 250, 270 )
	Votemap.Menu.ListView:SetSize( 200, 100 )
	Votemap.Menu.ListView:SetPos( 75, 30 )
	Votemap.Menu.ListView:AddColumn( "Map" )
	Votemap.Menu.ListView:AddColumn( "Votes" )
	Votemap.Menu.ListView:SetMultiSelect( false )

	for k,v in pairs(Votemap.Maps) do
		Votemap.Menu.ListView:AddLine(k, v)
	end

	Votemap.Menu.ListView:SortByColumn( 1 )
	Votemap.Menu.ListView:SetSortable( false )


	Votemap.Menu.VoteButton = vgui.Create("DButton", Votemap.Menu)
	Votemap.Menu.VoteButton:SetText("Vote")
	Votemap.Menu.VoteButton:SetSize( 200, 30 )
	--Votemap.Menu.VoteButton:SetPos( 100, 325 )
	Votemap.Menu.VoteButton:SetPos( 75, 140 )
	Votemap.Menu.VoteButton.DoClick = function( pnl )
		
		local selected = Votemap.Menu.ListView:GetSelectedLine()
		
		if ( !selected ) then
			chat.AddText( Color(255, 0,0), "Invalid line selected !" )
			return
		end

		local line = Votemap.Menu.ListView:GetLine(selected)

		if ( !line ) then
			chat.AddText( Color(255, 0,0), "Invalid line selected !" )
			return
		end

		local map = line:GetValue(1)

		if ( !map ) then
			chat.AddText( Color(255, 0,0), "Invalid selected map !" )
			return
		end

		net.Start("Votemap.Vote")
		net.WriteString( map )
		net.SendToServer()

	end

end

usermessage.Hook( "Votemap.Votes", function( um )
	
	local map = um:ReadString()
	local votes = um:ReadFloat()
	local ply = um:ReadEntity()

	Votemap.Maps[map] = votes

	if ( !Votemap.Menu or !Votemap.Menu.ListView ) then
		return
	end
	
	local maplist = Votemap.Menu.ListView:GetLines()
	
	for i=1, #maplist do
		local name = Votemap.Menu.ListView:GetLine(i)
		
		if ( name:GetColumnText(1) == map ) then
			name:SetColumnText(2, tostring(votes))
		end

	end

	if ( !ply.VotedOnce ) then
		chat.AddText( Color(0,128,128), "[Votemap] ", Color(128, 128,128), ply:Nick() .. " Voted for: ", Color( 255, 0, 0 ), map, Color( 128, 128, 128 ), " with ", Color( 255, 0, 0 ), tostring(votes), Color( 128, 128, 128 ), " votes." ) 
		ply.VotedOnce = true
	end

end)

net.Receive( "Votemap.Maps", function( l )
	
	local json = net.ReadString()
	local tbl = util.JSONToTable( json )

	Votemap.Maps = tbl
	Votemap:ToggleMenu(true)
	MsgN("[Votemap] Started Voting !")

end)