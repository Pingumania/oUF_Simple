
-- oUF_SimpleConfig: nameplate
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- NamePlateCallback
-----------------------------

local function NamePlateCallback(...)
  print(...)
end
--L.C.NamePlateCallback = NamePlateCallback

-----------------------------
-- NamePlateCVars
-----------------------------

local cvars = {
  nameplateMinScale         = 1,
  nameplateMaxScale         = 1,
  nameplateMinScaleDistance = 0,
  nameplateMaxScaleDistance = 40,
  nameplateGlobalScale      = 1,
  NamePlateHorizontalScale  = 1,
  NamePlateVerticalScale    = 1,
  nameplateSelfScale        = 1,
  nameplateSelectedScale    = 1,
  nameplateLargerScale      = 1.2,
  nameplateShowFriendlyNPCs = 0,
  nameplateMinAlpha         = 0.5,
  nameplateMaxAlpha         = 0.5,
  nameplateMinAlphaDistance = 0,
  nameplateMaxAlphaDistance = 40,
  nameplateSelectedAlpha    = 1
}

L.C.NamePlateCVars = cvars

-----------------------------
-- NamePlateConfig
-----------------------------

local buff_whitelist = {}
buff_whitelist[277242] = true --infest
buff_whitelist[209859] = true --bolster

--custom filter for nameplate Buffs
local function CustomFilterBuffs(...)
  local element, unit, button, name, texture, count, debuffType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll, timeMod, effect1, effect2, effect3 = ...
  return buff_whitelist[spellID] or nameplateShowSelf or nameplateShowAll or (caster == "player" or caster == "pet" or caster == "vehicle")
end

--custom filter for nameplate debuffs
local function CustomFilterDebuffs(...)
  local element, unit, button, name, texture, count, debuffType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll, timeMod, effect1, effect2, effect3 = ...
  return nameplateShowSelf or nameplateShowAll or (caster == "player" or caster == "pet" or caster == "vehicle")
end

L.C.nameplate = {
  enabled = false,
  size = {130,26},
  point = {"CENTER"}, --relative to the nameplate base!
  scale = 1*UIParent:GetScale()*L.C.globalscale,--nameplates are not part of uiparent, they must be multiplied by uiparent scale!
  --healthbar
  healthbar = {
    --health and absorb bar cannot be disabled, they match the size of the frame
    colorTapping = true,
    colorReaction = true,
    colorClass = true,
    colorHealth = true,
    colorThreat = true,
    colorThreatInvers = true,
    frequentUpdates = true,
    name = {
      enabled = true,
      points = {
        {"LEFT",2,0},
        {"RIGHT",-2,0},
      },
      size = 15,
      align = "CENTER",
      tag = "[oUF_SimpleConfig:classification][difficulty][name]|r",
    },
    debuffHighlight = true,
  },
  --raidmark
  raidmark = {
    enabled = true,
    size = {18,18},
    point = {"CENTER","TOP",0,4},
  },
  --castbar
  castbar = {
    enabled = true,
    size = {130,26},
    point = {"TOP","BOTTOM",0,-5},
    name = {
      enabled = true,
      points = {
        {"LEFT",2,0},
        {"RIGHT",-2,0},
      },
      size = 15,
    },
    icon = {
      enabled = true,
      size = {26,26},
      point = {"RIGHT","LEFT",-6,0},
    },
  },
  --buffs
  buffs = {
    enabled = true,
    point = {"BOTTOM","TOP",0,32},
    num = 10,
    cols = 4,
    size = 32,
    spacing = 5,
    initialAnchor = "BOTTOMLEFT",
    growthX = "RIGHT",
    growthY = "UP",
    disableCooldown = true,
    filter = "HELPFUL|INCLUDE_NAME_PLATE_ONLY",
    CustomFilter = CustomFilterBuffs
  },
  --debuffs
  debuffs = {
    enabled = true,
    point = {"BOTTOMLEFT","TOPLEFT",0,5},
    num = 5,
    cols = 5,
    size = 22,
    spacing = 5,
    initialAnchor = "BOTTOMLEFT",
    growthX = "RIGHT",
    growthY = "UP",
    disableCooldown = false,
    filter = "HARMFUL|INCLUDE_NAME_PLATE_ONLY",
    CustomFilter = CustomFilterDebuffs
  },
}