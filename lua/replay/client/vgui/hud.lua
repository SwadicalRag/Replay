local function initialiseVGUI()
	local blurMat = Material("pp/blurscreen")
	local function blur(pnl,factor)
		surface.SetMaterial(blurMat)
		surface.SetDrawColor(0,0,0,150)

		local x,y = pnl:LocalToScreen(0,0)
		for i=1,factor do
			blurMat:SetFloat("$blur",i/5*factor)
			blurMat:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(-x,-y,ScrW(),ScrH())
		end
	end

	surface.CreateFont("Replay_SlightlyLessLargeLMAO",{
		font = "DermaLarge",
		size = 18,
		weight = 200,
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
	})

	if IsValid(Replay.VGUIPanel) then Replay.VGUIPanel:Remove() end
	local Panel = vgui.Create("DPanel")
	Replay.VGUIPanel = Panel
	Panel:SetSize(300,100)
	Panel:SetPos(ScrW()-300,0)
	Panel.control_alpha = 0
	Panel:SetAlpha(Panel.control_alpha)
	Panel.Paint = function(self,w,h)
	    if(Replay:mStatus()) then
	        self.control_alpha = math.min(255,self.control_alpha + FrameTime()*300)
			self:SetAlpha(self.control_alpha)
	    elseif(self.control_alpha ~= 0) then
	        self.control_alpha = math.max(0,self.control_alpha - FrameTime()*600)
			self:SetAlpha(self.control_alpha)
	    end
		blur(self,6)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,150))

		draw.DrawText("Replay: active","DermaLarge",150,5,Color(255,255,255),TEXT_ALIGN_CENTER)
		draw.DrawText((((Replay:getDirection() == 1) and "Forwarding") or "Rewinding").." at a "..Replay:getSpeed().."x timescale","Replay_SlightlyLessLargeLMAO",150,45,Color(255,255,255),TEXT_ALIGN_CENTER)
		draw.DrawText(("T-%.1fs/%.1fs [%d/%d]"):format(Replay.recorderObject.activeFrame*engine.TickInterval(),#Replay.recorderObject.data*engine.TickInterval(),Replay.recorderObject.activeFrame,#Replay.recorderObject.data),"Replay_SlightlyLessLargeLMAO",150,70,Color(255,255,255),TEXT_ALIGN_CENTER)
	end

	Replay.VGUIInitialised = true
end

hook.Add("InitPostEntity","ReplayVGUIstart",initialiseVGUI)

if Replay.VGUIInitialised then
	initialiseVGUI()
end
