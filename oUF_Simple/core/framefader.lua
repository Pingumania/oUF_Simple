
-- oUF_Simple: core/framefader
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Functions
-----------------------------

local function FaderOnFinished(self)
  --print("FaderOnFinished",self.__owner:GetName(),self.finAlpha)
  self.__owner:SetAlpha(self.finAlpha)
end

local function FaderOnUpdate(self)
  --print("FaderOnUpdate",self.__owner:GetName(),self.__animFrame:GetAlpha())
  self.__owner:SetAlpha(self.__animFrame:GetAlpha())
end

local function CreateFaderAnimation(frame)
  if frame.fader then return end
  local animFrame = CreateFrame("Frame",nil,frame)
  animFrame.__owner = frame
  frame.fader = animFrame:CreateAnimationGroup()
  frame.fader.__owner = frame
  frame.fader.__animFrame = animFrame
  frame.fader.direction = nil
  frame.fader.setToFinalAlpha = false
  frame.fader.anim = frame.fader:CreateAnimation("Alpha")
  frame.fader:HookScript("OnFinished", FaderOnFinished)
  frame.fader:HookScript("OnUpdate", FaderOnUpdate)
end

local function StartFadeIn(frame)
  if frame.fader.direction == "in" then return end
  frame.fader:Pause()
  frame.fader.anim:SetFromAlpha(frame.faderConfig.fadeOutAlpha or 0)
  frame.fader.anim:SetToAlpha(frame.faderConfig.fadeInAlpha or 1)
  frame.fader.anim:SetDuration(frame.faderConfig.fadeInDuration or 0.3)
  frame.fader.anim:SetSmoothing(frame.faderConfig.fadeInSmooth or "OUT")
  --start right away
  frame.fader.anim:SetStartDelay(frame.faderConfig.fadeInDelay or 0)
  frame.fader.finAlpha = frame.faderConfig.fadeInAlpha
  frame.fader.direction = "in"
  frame.fader:Play()
end

local function StartFadeOut(frame)
  if frame.fader.direction == "out" then return end
  frame.fader:Pause()
  frame.fader.anim:SetFromAlpha(frame.faderConfig.fadeInAlpha or 1)
  frame.fader.anim:SetToAlpha(frame.faderConfig.fadeOutAlpha or 0)
  frame.fader.anim:SetDuration(frame.faderConfig.fadeOutDuration or 0.3)
  frame.fader.anim:SetSmoothing(frame.faderConfig.fadeOutSmooth or "OUT")
  --wait for some time before starting the fadeout
  frame.fader.anim:SetStartDelay(frame.faderConfig.fadeOutDelay or 0)
  frame.fader.finAlpha = frame.faderConfig.fadeOutAlpha
  frame.fader.direction = "out"
  frame.fader:Play()
end

local function IsMouseOverFrame(frame)
  if MouseIsOver(frame) then return true end
  if not SpellFlyout:IsShown() then return false end
  if not SpellFlyout.__faderParent then return false end
  if SpellFlyout.__faderParent == frame and MouseIsOver(SpellFlyout) then return true end
  return false
end

local function FrameHandler(frame)
  if IsMouseOverFrame(frame) then
    StartFadeIn(frame)
  else
    StartFadeOut(frame)
  end
end

local function OnShow(self)
  if self.fader then
    StartFadeIn(self)
  end
end

local function OnHide(self)
  if self.fader then
    StartFadeOut(self)
  end
end

local function CreateFrameFader(frame, faderConfig)
  if frame.faderConfig then return end
  frame.faderConfig = faderConfig
  CreateFaderAnimation(frame)
  if faderConfig.trigger and faderConfig.trigger == "OnShow" then
    frame:HookScript("OnShow", OnShow)
    --I know setting the alpha on a hidden frame does not really make sense but we need to set the fader to "out"
    --sadly a delay on the OnHide is impossible. we get the benefit of the fadeIn though.
    frame:HookScript("OnHide", OnHide)
  else
    frame:EnableMouse(true)
    frame:HookScript("OnEnter", FrameHandler)
    frame:HookScript("OnLeave", FrameHandler)
    FrameHandler(frame)
  end
end
L.F.CreateFrameFader = CreateFrameFader