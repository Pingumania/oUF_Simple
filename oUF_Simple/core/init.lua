
-- oUF_Simple: core/init
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

L.addonName       = A
L.dragFrames      = {}
L.addonColor      = "00FF3300"
L.addonShortcut   = "ouf_simple"
L.Retail          = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE

--get the config
L.C = oUF_SimpleConfig