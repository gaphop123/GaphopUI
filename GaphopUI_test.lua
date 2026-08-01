-- STREAMING_CHUNK:Initializing Core Roblox Services and Global Tables...
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

warn("This UI may have bugs. Please report any issues you find.")
warn ("This is a GaphopUI test build. It is not intended for use.")

wait(2)

local loader = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Stratxgy/Roblox-Chams-Highlight/refs/heads/main/Highlight.lua"))() end)
local loader =  loadstring(game:HttpGet("https://raw.githubusercontent.com/Stratxgy/Lua-Speed/refs/heads/main/speed.lua"))()

if not RunService:IsClient() then
return
end

local LocalPlayer = Players.LocalPlayer
local PlayerName = (LocalPlayer and LocalPlayer.Name) or "Player"
local PlayerUserId = (LocalPlayer and LocalPlayer.UserId) or 0

-- Ensure global environment tables exist to prevent nil indexing errors
if type(getgenv) == "function" then
local env = getgenv()
env.speed = env.speed or {}
env.chams = env.chams or {}
end

-- STREAMING_CHUNK:Resolving Safe Parent Container for UI Rendering...
local function GetSafeParent()
if type(gethui) == "function" then
local ok, res = pcall(gethui)
if ok and res then return res end
end

if LocalPlayer then
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not pg then
        pcall(function() pg = LocalPlayer:WaitForChild("PlayerGui", 3) end)
    end
    if pg then return pg end
end

if type(cloneref) == "function" then
    local ok, res = pcall(function() return cloneref(CoreGui) end)
    if ok and res then return res end
end

return CoreGui


end

local ParentUI = GetSafeParent()

-- Clean up any existing instance to prevent duplicates
if ParentUI:FindFirstChild("GaphopUI_Engine") then
ParentUI:FindFirstChild("GaphopUI_Engine"):Destroy()
end

-- STREAMING_CHUNK:Defining Ultimate Library Configurations & Color Palettes...
local GaphopUI = {
Version = "3.0.0 Ultimate Acrylic",
Flags = {},
Themes = {},
CurrentTheme = "Dark",
ToggleKey = Enum.KeyCode.K,
IsOpen = true,
Elements = {},
Connections = {},
WindowInstance = nil,
OpenButton = nil,
NotifyContainer = nil,
AssetFolder = nil,
CallbackRegistry = {},
RGBEnabled = false,
RGBConnection = nil,
CurrentRGBColor = Color3.fromRGB(0, 162, 255),
Icons = {
settings = "⚙",
search = "⌕",
home = "⌂",
close = "x",
x = "x",
minimize = "—",
maximize = "▢",
refresh = "↻",
palette = "◐",
keyboard = "⌨",
sparkles = "✦",
moon = "☾",
sun = "☀",
info = "ⓘ",
bell = "🔔",
menu = "☰",
plus = "+",
minus = "−",
check = "✓",
slider = "▭",
layers = "☰",
cog = "⚙",
chevron = "⌵",
shield = "🛡",
zap = "⚡",
star = "★",
key = "🔑"
}
}

-- MAPPING TRỰC TIẾP LUCIDE ICONS BẰNG SPRITESHEET ĐỂ RENDER HD
GaphopUI.LucideSprites = {
rewind = {16898613699, {48, 48}, {563, 967}},
fuel = {16898613353, {48, 48}, {196, 967}},
squarearrowoutupright = {16898613777, {48, 48}, {967, 514}},
tablecellssplit = {16898613777, {48, 48}, {771, 955}},
gavel = {16898613353, {48, 48}, {967, 808}},
dnaoff = {16898613044, {48, 48}, {453, 967}},
refreshccwdot = {16898613699, {48, 48}, {869, 404}},
bean = {16898612629, {48, 48}, {967, 906}},
arrowuprightfromcircle = {16898612629, {48, 48}, {563, 967}},
tablecolumnssplit = {16898613777, {48, 48}, {967, 808}},
bolt = {16898612819, {48, 48}, {306, 820}},
squareasterisk = {16898613777, {48, 48}, {710, 771}},
feather = {16898613353, {48, 48}, {771, 98}},
alignhorizontaldistributecenter = {16898612629, {48, 48}, {771, 355}},
aligncenter = {16898612629, {48, 48}, {0, 869}},
gripvertical = {16898613509, {48, 48}, {0, 869}},
personstanding = {16898613699, {48, 48}, {563, 771}},
badgeswissfranc = {16898612629, {48, 48}, {771, 857}},
betweenhorizontalend = {16898612819, {48, 48}, {771, 306}},
rotatecw = {16898613699, {48, 48}, {869, 453}},
framer = {16898613353, {48, 48}, {661, 967}},
busfront = {16898612819, {48, 48}, {869, 612}},
shieldellipsis = {16898613777, {48, 48}, {771, 306}},
filelock2 = {16898613353, {48, 48}, {257, 918}},
betweenverticalend = {16898612819, {48, 48}, {257, 820}},
globelock = {16898613509, {48, 48}, {820, 514}},
toggleleft = {16898613869, {48, 48}, {869, 49}},
conciergebell = {16898613044, {48, 48}, {869, 147}},
video = {16898613869, {48, 48}, {355, 967}},
arrowleftsquare = {16898612629, {48, 48}, {196, 820}},
filedown = {16898613353, {48, 48}, {98, 820}},
pictureinpicture = {16898613699, {48, 48}, {257, 869}},
messagessquare = {16898613613, {48, 48}, {306, 869}},
grab = {16898613509, {48, 48}, {514, 820}},
maximize={16898675359,{256,256},{514,514}},
phonecall = {16898613699, {48, 48}, {514, 820}},
chevronupcircle = {16898612819, {48, 48}, {820, 808}},
servercrash = {16898613699, {48, 48}, {918, 955}},
heading3 = {16898613509, {48, 48}, {869, 306}},
squircle = {16898613777, {48, 48}, {820, 759}},
wifioff = {16898613869, {48, 48}, {918, 759}},
sunmedium = {16898613777, {48, 48}, {661, 967}},
ungroup = {16898613869, {48, 48}, {257, 967}},
clouddownload = {16898613044, {48, 48}, {612, 820}},
sigmasquare = {16898613777, {48, 48}, {869, 514}},
folderplus = {16898613353, {48, 48}, {661, 918}},
harddrivedownload = {16898613509, {48, 48}, {918, 0}},
scatterchart = {16898613699, {48, 48}, {196, 967}},
pointer = {16898613699, {48, 48}, {661, 771}},
ligature = {16898613509, {48, 48}, {612, 967}},
chevronsupdown = {16898612819, {48, 48}, {918, 759}},
iterationcw = {16898613509, {48, 48}, {869, 147}},
railsymbol = {16898613699, {48, 48}, {967, 514}},
squarestack = {16898613777, {48, 48}, {453, 869}},
parentheses = {16898613613, {48, 48}, {869, 906}},
bookup2 = {16898612819, {48, 48}, {306, 869}},
flame = {16898613353, {48, 48}, {967, 306}},
chevronsup = {16898612819, {48, 48}, {869, 808}},
chevronrightsquare = {16898612819, {48, 48}, {918, 710}},
squaremousepointer = {16898613777, {48, 48}, {869, 661}},
superscript = {16898613777, {48, 48}, {918, 759}},
signal = {16898613777, {48, 48}, {918, 0}},
filewarning = {16898613353, {48, 48}, {967, 514}},
hexagon = {16898613509, {48, 48}, {967, 0}},
navigation2off = {16898613613, {48, 48}, {918, 612}},
unlock = {16898613869, {48, 48}, {771, 710}},
arrowsupfromline = {16898612629, {48, 48}, {918, 404}},
squareganttchart = {16898613777, {48, 48}, {453, 820}},
squarechevronleft = {16898613777, {48, 48}, {967, 49}},
scaling = {16898613699, {48, 48}, {967, 661}},
inspectionpanel = {16898613509, {48, 48}, {563, 918}},
arrowleftfromline = {16898612629, {48, 48}, {869, 147}},
ship = {16898613777, {48, 48}, {771, 98}},
ticketpercent = {16898613869, {48, 48}, {257, 869}},
arrowrightsquare = {16898612629, {48, 48}, {869, 404}},
calendarclock = {16898612819, {48, 48}, {918, 98}},
x = {16898613869, {48, 48}, {869, 906}},
eye = {16898669897,{256,256},{0,0}},
voicemail = {16898613869, {48, 48}, {869, 710}},
presentation = {16898613699, {48, 48}, {771, 196}},
treepalm = {16898613869, {48, 48}, {820, 612}},
popsicle = {16898613699, {48, 48}, {563, 869}},
captionsoff = {16898612819, {48, 48}, {661, 869}},
alignverticaljustifycenter = {16898612629, {48, 48}, {49, 869}},
theater = {16898613869, {48, 48}, {98, 771}},
tent = {16898613869, {48, 48}, {49, 771}},
repeat1 = {16898613699, {48, 48}, {918, 612}},
stethoscope = {16898613777, {48, 48}, {147, 967}},
screenshareoff = {16898613699, {48, 48}, {771, 906}},
arrowbigup = {16898612629, {48, 48}, {918, 306}},
volumex = {16898613869, {48, 48}, {710, 869}},
mousepointerclick = {16898613613, {48, 48}, {771, 710}},
squarem = {16898613777, {48, 48}, {306, 967}},
harddrive = {16898613509, {48, 48}, {820, 98}},
packageminus = {16898613613, {48, 48}, {771, 808}},
cloud = {16898613044, {48, 48}, {918, 306}},
mousepointersquaredashed = {16898613613, {48, 48}, {710, 771}},
fliphorizontal = {16898613353, {48, 48}, {306, 967}},
alertcircle = {16898612629, {48, 48}, {869, 0}},
unplug = {16898613869, {48, 48}, {710, 771}},
badgecent = {16898612629, {48, 48}, {612, 967}},
checksquare2 = {16898612819, {48, 48}, {820, 759}},
monitorcheck = {16898613613, {48, 48}, {196, 771}},
trello = {16898613869, {48, 48}, {612, 820}},
paintbrush2 = {16898613613, {48, 48}, {967, 404}},
barcharthorizontal = {16898612629, {48, 48}, {710, 967}},
bookplus = {16898612819, {48, 48}, {771, 404}},
torus = {16898613869, {48, 48}, {147, 771}},
panelrightclose = {16898613613, {48, 48}, {453, 967}},
hearthandshake = {16898613509, {48, 48}, {869, 563}},
heart = {16898673271,{256,256},{0,0}},
trees = {16898613869, {48, 48}, {661, 771}},
ham = {16898613509, {48, 48}, {355, 771}},
text = {16898613869, {48, 48}, {771, 98}},
nutoff = {16898613613, {48, 48}, {98, 967}},
beanoff = {16898612629, {48, 48}, {869, 955}},
rat = {16898613699, {48, 48}, {869, 612}},
separatorhorizontal = {16898613699, {48, 48}, {918, 906}},
squarearrowupright = {16898613777, {48, 48}, {820, 661}},
signalzero = {16898613777, {48, 48}, {514, 869}},
citrus = {16898613044, {48, 48}, {306, 820}},
phonemissed = {16898613699, {48, 48}, {771, 98}},
userroundcheck = {16898613869, {48, 48}, {869, 404}},
batterymedium = {16898612629, {48, 48}, {869, 906}},
squareminus = {16898613777, {48, 48}, {918, 612}},
hotel = {16898613509, {48, 48}, {98, 869}},
folderoutput = {16898613353, {48, 48}, {771, 808}},
icecream = {16898613509, {48, 48}, {869, 355}},
menu = {16898613613, {48, 48}, {49, 820}},
arrowupleftsquare = {16898612629, {48, 48}, {710, 820}},
lightbulb = {16898613509, {48, 48}, {918, 196}},
badgehelp = {16898612629, {48, 48}, {147, 967}},
angry = {16898612629, {48, 48}, {257, 918}},
outdent = {16898613613, {48, 48}, {918, 661}},
circledotdashed = {16898613044, {48, 48}, {771, 514}},
speech = {16898613777, {48, 48}, {820, 147}},
cakeslice = {16898612819, {48, 48}, {661, 820}},
gitgraph = {16898613509, {48, 48}, {0, 771}},
armchair = {16898612629, {48, 48}, {820, 147}},
qrcode = {16898613699, {48, 48}, {967, 257}},
copy = {16898613044, {48, 48}, {918, 612}},
goal = {16898613509, {48, 48}, {563, 771}},
trendingdown = {16898613869, {48, 48}, {563, 869}},
haze = {16898613509, {48, 48}, {98, 820}},
nfc = {16898613613, {48, 48}, {612, 918}},
receiptrussianruble = {16898613699, {48, 48}, {514, 967}},
disc = {16898613044, {48, 48}, {661, 967}},
notebooktabs = {16898613613, {48, 48}, {967, 98}},
panelsleftbottom = {16898613613, {48, 48}, {820, 906}},
videotape = {16898613869, {48, 48}, {967, 612}},
sunmoon = {16898613777, {48, 48}, {967, 196}},
calendar = {16898612819, {48, 48}, {355, 918}},
minuscircle = {16898613613, {48, 48}, {869, 98}},
sunset = {16898613777, {48, 48}, {967, 710}},
navigation2 = {16898613613, {48, 48}, {869, 661}},
messagesquareheart = {16898613613, {48, 48}, {771, 147}},
rectangleellipsis = {16898613699, {48, 48}, {820, 196}},
badgeplus = {16898612629, {48, 48}, {918, 710}},
indianrupee = {16898613509, {48, 48}, {710, 771}},
monitordot = {16898613613, {48, 48}, {147, 820}},
delete = {16898613044, {48, 48}, {661, 918}},
clipboardpenline = {16898613044, {48, 48}, {918, 0}},
foldersearch = {16898613353, {48, 48}, {918, 196}},
utensilscrossed = {16898613869, {48, 48}, {918, 147}},
dices = {16898613044, {48, 48}, {918, 710}},
reply = {16898613699, {48, 48}, {612, 918}},
flaskround = {16898613353, {48, 48}, {404, 869}},
pause = {16898613699, {48, 48}, {0, 771}},
shrub = {16898613777, {48, 48}, {306, 820}},
flag = {16898613353, {48, 48}, {98, 918}},
underline = {16898613869, {48, 48}, {820, 404}},
alignhorizontaldistributeend = {16898612629, {48, 48}, {355, 771}},
newspaper = {16898613613, {48, 48}, {661, 869}},
table = {16898613777, {48, 48}, {820, 955}},
movevertical = {16898613613, {48, 48}, {820, 453}},
filepenline = {16898613353, {48, 48}, {612, 820}},
badgerussianruble = {16898612629, {48, 48}, {820, 808}},
radius = {16898613699, {48, 48}, {257, 967}},
loader2 = {16898613509, {48, 48}, {820, 857}},
pilcrow = {16898613699, {48, 48}, {612, 771}},
scanface = {16898613699, {48, 48}, {820, 808}},
spade = {16898613777, {48, 48}, {514, 918}},
bookuser = {16898612819, {48, 48}, {918, 514}},
user = {16898613869,{48,48},{661,869}},
flipvertical = {16898613353, {48, 48}, {918, 612}},
squarearrowdown = {16898613777, {48, 48}, {453, 771}},
circleplus = {16898613044, {48, 48}, {869, 0}},
view = {16898613869, {48, 48}, {918, 661}},
cctv = {16898612819, {48, 48}, {355, 967}},
morehorizontal = {16898613613, {48, 48}, {257, 967}},
filekey2 = {16898613353, {48, 48}, {404, 771}},
pauseoctagon = {16898613699, {48, 48}, {771, 0}},
circlearrowoutdownleft = {16898612819, {48, 48}, {771, 955}},
volume = {16898613869, {48, 48}, {661, 918}},
facebook = {16898613353, {48, 48}, {563, 771}},
octagonalert = {16898613613, {48, 48}, {918, 404}},
panelbottomdashed = {16898613613, {48, 48}, {918, 710}},
booka = {16898612819, {48, 48}, {820, 563}},
alignendvertical = {16898612629, {48, 48}, {820, 306}},
userx2 = {16898613869, {48, 48}, {771, 759}},
chrome = {16898612819, {48, 48}, {820, 857}},
receiptjapaneseyen = {16898613699, {48, 48}, {612, 869}},
rabbit = {16898613699, {48, 48}, {869, 355}},
scissorssquare = {16898613699, {48, 48}, {869, 808}},
checksquare = {16898612819, {48, 48}, {771, 808}},
trainfronttunnel = {16898613869, {48, 48}, {771, 404}},
panelleftdashed = {16898613613, {48, 48}, {661, 967}},
fish = {16898613353, {48, 48}, {869, 147}},
slack = {16898613777, {48, 48}, {0, 918}},
sliders = {16898613777, {48, 48}, {404, 771}},
messagecirclewarning = {16898613613, {48, 48}, {771, 612}},
map = {16898613613, {48, 48}, {306, 771}},
route = {16898613699, {48, 48}, {404, 918}},
arrowupleft = {16898612629, {48, 48}, {661, 869}},
award = {16898612629, {48, 48}, {918, 661}},
messagesquareplus = {16898613613, {48, 48}, {49, 869}},
unfoldhorizontal = {16898613869, {48, 48}, {355, 869}},
areachart = {16898612629, {48, 48}, {869, 98}},
music4 = {16898613613, {48, 48}, {306, 967}},
shieldx = {16898613777, {48, 48}, {514, 820}},
planelanding = {16898613699, {48, 48}, {771, 147}},
disc3 = {16898613044, {48, 48}, {771, 857}},
columns4 = {16898613044, {48, 48}, {710, 771}},
archivex = {16898612629, {48, 48}, {967, 0}},
squaredashedkanban = {16898613777, {48, 48}, {98, 918}},
users2 = {16898613869, {48, 48}, {612, 918}},
shieldoff = {16898613777, {48, 48}, {820, 514}},
compass = {16898613044, {48, 48}, {514, 967}},
vegan = {16898613869, {48, 48}, {967, 355}},
messagecircleplus = {16898613613, {48, 48}, {257, 869}},
stopcircle = {16898613777, {48, 48}, {453, 918}},
nut = {16898613613, {48, 48}, {967, 355}},
search = {16898613699, {48, 48}, {918, 857}},
files = {16898613353, {48, 48}, {771, 710}},
sendtoback = {16898613699, {48, 48}, {820, 955}},
alarmclock = {16898612629, {48, 48}, {257, 820}},
shoppingbasket = {16898613777, {48, 48}, {0, 869}},
send = {16898613699, {48, 48}, {967, 857}},
chevronleftsquare = {16898612819, {48, 48}, {453, 918}},
terminalsquare = {16898613869, {48, 48}, {0, 820}},
wifi = {16898613869, {48, 48}, {869, 808}},
skipback = {16898613777, {48, 48}, {147, 771}},
wraptext = {16898613869, {48, 48}, {869, 857}},
filescan = {16898613353, {48, 48}, {820, 147}},
messagesquaredashed = {16898613613, {48, 48}, {918, 0}},
trophy = {16898613869, {48, 48}, {820, 147}},
umbrella = {16898613869, {48, 48}, {869, 355}},
touchpad = {16898613869, {48, 48}, {49, 869}},
clipboardcopy = {16898613044, {48, 48}, {820, 563}},
pentagon = {16898613699, {48, 48}, {771, 306}},
arrowupfromline = {16898612629, {48, 48}, {820, 710}},
circlechevronup = {16898613044, {48, 48}, {771, 0}},
worm = {16898613869, {48, 48}, {918, 808}},
lampdesk = {16898613509, {48, 48}, {355, 918}},
circlearrowup = {16898612819, {48, 48}, {967, 857}},
zap = {16898613869, {48, 48}, {918, 906}},
boxes = {16898612819, {48, 48}, {196, 771}},
swissfranc = {16898613777, {48, 48}, {820, 857}},
moveleft = {16898613613, {48, 48}, {98, 918}},
chevronup = {16898612819, {48, 48}, {710, 918}},
instagram = {16898613509, {48, 48}, {514, 967}},
pentool = {16898613699, {48, 48}, {820, 0}},
pencilruler = {16898613699, {48, 48}, {0, 820}},
grid2x2 = {16898613509, {48, 48}, {771, 98}},
arrowbigdowndash = {16898612629, {48, 48}, {771, 196}},
clipboardedit = {16898613044, {48, 48}, {771, 612}},
mic = {16898613613, {48, 48}, {820, 612}},
fileminus2 = {16898613353, {48, 48}, {869, 563}},
gitlab = {16898613509, {48, 48}, {820, 257}},
rotate3d = {16898613699, {48, 48}, {147, 918}},
spellcheck = {16898613777, {48, 48}, {196, 771}},
popcorn = {16898613699, {48, 48}, {612, 820}},
blocks = {16898612819, {48, 48}, {49, 820}},
washingmachine = {16898613869, {48, 48}, {918, 710}},
siren = {16898613777, {48, 48}, {771, 147}},
copy = {16898613044,{48,48},{918,612}},
cloudsun = {16898613044, {48, 48}, {0, 967}},
circle = {16898613044, {48, 48}, {771, 355}},
shieldalert = {16898613777, {48, 48}, {49, 771}},
rainbow = {16898613699, {48, 48}, {918, 563}},
separatorvertical = {16898613699, {48, 48}, {869, 955}},
ampersands = {16898612629, {48, 48}, {355, 820}},
usersearch = {16898613869, {48, 48}, {918, 612}},
fence = {16898613353, {48, 48}, {98, 771}},
squareuserround = {16898613777, {48, 48}, {355, 0}},
key = {16898613509, {48, 48}, {404, 771}}
-- some icons are not mapped here because they are not used in GaphopUI, but they can be added if needed
}

-- Mapping GaphopUI internal keywords directly to standard Lucide icons
GaphopUI.LucideSprites.settings = GaphopUI.LucideSprites.sliders or {16898613777, {48, 48}, {404, 771}}
GaphopUI.LucideSprites.close = GaphopUI.LucideSprites.x
GaphopUI.LucideSprites.minimize = GaphopUI.LucideSprites.minuscircle
GaphopUI.LucideSprites.maximize = GaphopUI.LucideSprites.copy or GaphopUI.LucideSprites.copy
GaphopUI.LucideSprites.refresh = GaphopUI.LucideSprites.refreshccwdot
GaphopUI.LucideSprites.palette = GaphopUI.LucideSprites.paintbrush2
GaphopUI.LucideSprites.keyboard = GaphopUI.LucideSprites.terminalsquare
GaphopUI.LucideSprites.sparkles = GaphopUI.LucideSprites.lightbulb
GaphopUI.LucideSprites.moon = GaphopUI.LucideSprites.sunmoon
GaphopUI.LucideSprites.sun = GaphopUI.LucideSprites.sunmedium
GaphopUI.LucideSprites.info = GaphopUI.LucideSprites.badgehelp
GaphopUI.LucideSprites.bell = GaphopUI.LucideSprites.conciergebell
GaphopUI.LucideSprites.plus = GaphopUI.LucideSprites.circleplus
GaphopUI.LucideSprites.minus = GaphopUI.LucideSprites.squareminus or GaphopUI.LucideSprites.minuscircle
GaphopUI.LucideSprites.check = GaphopUI.LucideSprites.checksquare
GaphopUI.LucideSprites.slider = GaphopUI.LucideSprites.sliders
GaphopUI.LucideSprites.layers = GaphopUI.LucideSprites.layers
GaphopUI.LucideSprites.cog = GaphopUI.LucideSprites.settings
GaphopUI.LucideSprites.chevron = GaphopUI.LucideSprites.chevronup
GaphopUI.LucideSprites.shield = GaphopUI.LucideSprites.shieldalert
GaphopUI.LucideSprites.star = GaphopUI.LucideSprites.star
GaphopUI.LucideSprites.house = GaphopUI.LucideSprites.house
GaphopUI.LucideSprites.key = GaphopUI.LucideSprites.key

GaphopUI.Themes = {
Dark = { Background = Color3.fromRGB(16, 17, 23), Card = Color3.fromRGB(25, 27, 38), CardHover = Color3.fromRGB(34, 37, 52), Header = Color3.fromRGB(20, 22, 31), Accent = Color3.fromRGB(0, 162, 255), AccentGlow = Color3.fromRGB(0, 140, 230), Text = Color3.fromRGB(245, 247, 252), SubText = Color3.fromRGB(150, 155, 175), Border = Color3.fromRGB(45, 50, 68), ToggleOn = Color3.fromRGB(0, 162, 255), ToggleOff = Color3.fromRGB(40, 44, 58), SliderBar = Color3.fromRGB(38, 42, 56), InputBackground = Color3.fromRGB(21, 23, 32), Shadow = Color3.fromRGB(0, 0, 0) },
Midnight = { Background = Color3.fromRGB(11, 11, 20), Card = Color3.fromRGB(20, 20, 36), CardHover = Color3.fromRGB(28, 28, 48), Header = Color3.fromRGB(15, 15, 26), Accent = Color3.fromRGB(130, 90, 255), AccentGlow = Color3.fromRGB(110, 70, 230), Text = Color3.fromRGB(245, 245, 255), SubText = Color3.fromRGB(145, 145, 178), Border = Color3.fromRGB(45, 45, 75), ToggleOn = Color3.fromRGB(130, 90, 255), ToggleOff = Color3.fromRGB(32, 32, 52), SliderBar = Color3.fromRGB(32, 32, 55), InputBackground = Color3.fromRGB(16, 16, 28), Shadow = Color3.fromRGB(0, 0, 0) },
CyberNeon = { Background = Color3.fromRGB(10, 12, 18), Card = Color3.fromRGB(18, 22, 32), CardHover = Color3.fromRGB(26, 32, 46), Header = Color3.fromRGB(14, 16, 24), Accent = Color3.fromRGB(255, 0, 128), AccentGlow = Color3.fromRGB(210, 0, 105), Text = Color3.fromRGB(255, 255, 255), SubText = Color3.fromRGB(160, 170, 190), Border = Color3.fromRGB(60, 30, 70), ToggleOn = Color3.fromRGB(255, 0, 128), ToggleOff = Color3.fromRGB(35, 30, 45), SliderBar = Color3.fromRGB(35, 30, 45), InputBackground = Color3.fromRGB(14, 16, 24), Shadow = Color3.fromRGB(0, 0, 0) },
Emerald = { Background = Color3.fromRGB(10, 18, 16), Card = Color3.fromRGB(18, 30, 26), CardHover = Color3.fromRGB(25, 42, 36), Header = Color3.fromRGB(14, 23, 20), Accent = Color3.fromRGB(16, 185, 129), AccentGlow = Color3.fromRGB(10, 150, 105), Text = Color3.fromRGB(240, 250, 245), SubText = Color3.fromRGB(140, 168, 155), Border = Color3.fromRGB(35, 60, 50), ToggleOn = Color3.fromRGB(16, 185, 129), ToggleOff = Color3.fromRGB(28, 45, 38), SliderBar = Color3.fromRGB(28, 45, 38), InputBackground = Color3.fromRGB(14, 24, 20), Shadow = Color3.fromRGB(0, 0, 0) },
Ocean = { Background = Color3.fromRGB(8, 16, 24), Card = Color3.fromRGB(16, 28, 40), CardHover = Color3.fromRGB(24, 38, 54), Header = Color3.fromRGB(12, 22, 32), Accent = Color3.fromRGB(14, 165, 233), AccentGlow = Color3.fromRGB(2, 132, 199), Text = Color3.fromRGB(240, 248, 255), SubText = Color3.fromRGB(135, 162, 182), Border = Color3.fromRGB(32, 56, 78), ToggleOn = Color3.fromRGB(14, 165, 233), ToggleOff = Color3.fromRGB(25, 42, 60), SliderBar = Color3.fromRGB(25, 42, 60), InputBackground = Color3.fromRGB(12, 22, 32), Shadow = Color3.fromRGB(0, 0, 0) },
Light = { Background = Color3.fromRGB(242, 244, 248), Card = Color3.fromRGB(255, 255, 255), CardHover = Color3.fromRGB(245, 247, 252), Header = Color3.fromRGB(235, 238, 245), Accent = Color3.fromRGB(0, 122, 255), AccentGlow = Color3.fromRGB(0, 100, 220), Text = Color3.fromRGB(22, 25, 33), SubText = Color3.fromRGB(110, 115, 130), Border = Color3.fromRGB(215, 220, 232), ToggleOn = Color3.fromRGB(0, 122, 255), ToggleOff = Color3.fromRGB(210, 215, 225), SliderBar = Color3.fromRGB(210, 215, 225), InputBackground = Color3.fromRGB(248, 249, 252), Shadow = Color3.fromRGB(180, 185, 200) },
Bloom = { Background = Color3.fromRGB(248, 241, 244), Card = Color3.fromRGB(255, 250, 252), CardHover = Color3.fromRGB(255, 245, 248), Header = Color3.fromRGB(244, 224, 230), Accent = Color3.fromRGB(242, 146, 177), AccentGlow = Color3.fromRGB(255, 180, 205), Text = Color3.fromRGB(55, 45, 50), SubText = Color3.fromRGB(140, 125, 132), Border = Color3.fromRGB(234, 214, 222), ToggleOn = Color3.fromRGB(242, 146, 177), ToggleOff = Color3.fromRGB(212, 198, 203), SliderBar = Color3.fromRGB(240, 205, 218), InputBackground = Color3.fromRGB(255, 248, 250), Shadow = Color3.fromRGB(225, 190, 205) },
AmberGlow = {
Background      = Color3.fromRGB(24, 20, 14),
Card            = Color3.fromRGB(36, 30, 22),
CardHover       = Color3.fromRGB(46, 38, 28),

Header          = Color3.fromRGB(30, 24, 18),

Accent          = Color3.fromRGB(255, 179, 71),
AccentGlow      = Color3.fromRGB(255, 210, 120),

Text            = Color3.fromRGB(250, 245, 235),
SubText         = Color3.fromRGB(185, 172, 150),

Border          = Color3.fromRGB(72, 58, 42),

ToggleOn        = Color3.fromRGB(255, 179, 71),
ToggleOff       = Color3.fromRGB(58, 48, 36),

SliderBar       = Color3.fromRGB(58, 48, 36),

InputBackground = Color3.fromRGB(28, 23, 18),

Shadow          = Color3.fromRGB(0, 0, 0)
},
Amethyst = {
Background      = Color3.fromRGB(18, 16, 28),
Card            = Color3.fromRGB(28, 24, 42),
CardHover       = Color3.fromRGB(36, 31, 54),

Header          = Color3.fromRGB(23, 20, 34),

Accent          = Color3.fromRGB(168, 120, 255),
AccentGlow      = Color3.fromRGB(205, 175, 255),

Text            = Color3.fromRGB(248, 246, 255),
SubText         = Color3.fromRGB(175, 168, 198),

Border          = Color3.fromRGB(60, 52, 86),

ToggleOn        = Color3.fromRGB(168, 120, 255),
ToggleOff       = Color3.fromRGB(45, 39, 64),

SliderBar       = Color3.fromRGB(45, 39, 64),

InputBackground = Color3.fromRGB(22, 19, 33),

Shadow          = Color3.fromRGB(0, 0, 0)
},
Serenity = {
Background      = Color3.fromRGB(238, 242, 247),
Card            = Color3.fromRGB(247, 250, 253),
CardHover       = Color3.fromRGB(241, 246, 251),

Header          = Color3.fromRGB(228, 235, 243),

Accent          = Color3.fromRGB(77, 145, 205),
AccentGlow      = Color3.fromRGB(140, 190, 235),

Text            = Color3.fromRGB(42, 49, 60),
SubText         = Color3.fromRGB(122, 132, 145),

Border          = Color3.fromRGB(206, 216, 228),

ToggleOn        = Color3.fromRGB(77, 145, 205),
ToggleOff       = Color3.fromRGB(210, 218, 228),

SliderBar       = Color3.fromRGB(210, 218, 228),

InputBackground = Color3.fromRGB(251, 253, 255),

Shadow          = Color3.fromRGB(175, 185, 198)
},
Crimson = {
Background = Color3.fromRGB(24, 16, 18),
Card = Color3.fromRGB(35, 22, 26),
CardHover = Color3.fromRGB(45, 28, 32),
Header = Color3.fromRGB(29, 18, 21),
Accent = Color3.fromRGB(230, 57, 70),
AccentGlow = Color3.fromRGB(255, 120, 130),
Text = Color3.fromRGB(248, 244, 245),
SubText = Color3.fromRGB(176, 156, 160),
Border = Color3.fromRGB(70, 42, 46),
ToggleOn = Color3.fromRGB(230, 57, 70),
ToggleOff = Color3.fromRGB(52, 34, 37),
SliderBar = Color3.fromRGB(52, 34, 37),
InputBackground = Color3.fromRGB(28, 19, 21),
Shadow = Color3.fromRGB(0, 0, 0)
},
Frost = {
Background = Color3.fromRGB(243, 247, 252),
Card = Color3.fromRGB(252, 254, 255),
CardHover = Color3.fromRGB(247, 250, 255),
Header = Color3.fromRGB(232, 240, 247),
Accent = Color3.fromRGB(98, 196, 255),
AccentGlow = Color3.fromRGB(170, 225, 255),
Text = Color3.fromRGB(40, 50, 60),
SubText = Color3.fromRGB(118, 130, 145),
Border = Color3.fromRGB(208, 220, 232),
ToggleOn = Color3.fromRGB(98, 196, 255),
ToggleOff = Color3.fromRGB(214, 224, 233),
SliderBar = Color3.fromRGB(214, 224, 233),
InputBackground = Color3.fromRGB(255, 255, 255),
Shadow = Color3.fromRGB(180, 190, 205)


},
Twilight = {
Background = Color3.fromRGB(20, 18, 28),
Card = Color3.fromRGB(30, 26, 40),
CardHover = Color3.fromRGB(40, 34, 52),
Header = Color3.fromRGB(25, 22, 34),
Accent = Color3.fromRGB(180, 120, 255),
AccentGlow = Color3.fromRGB(220, 170, 255),
Text = Color3.fromRGB(245, 240, 255),
SubText = Color3.fromRGB(160, 150, 180),
Border = Color3.fromRGB(60, 50, 80),
ToggleOn = Color3.fromRGB(180, 120, 255),
ToggleOff = Color3.fromRGB(45, 38, 60),
SliderBar = Color3.fromRGB(45, 38, 60),
InputBackground = Color3.fromRGB(22, 20, 32),
Shadow = Color3.fromRGB(0, 0, 0)
},
Forest = {
Background = Color3.fromRGB(16, 22, 17),
Card = Color3.fromRGB(24, 34, 26),
CardHover = Color3.fromRGB(32, 44, 34),
Header = Color3.fromRGB(20, 28, 22),
Accent = Color3.fromRGB(74, 170, 104),
AccentGlow = Color3.fromRGB(120, 220, 150),
Text = Color3.fromRGB(242, 247, 243),
SubText = Color3.fromRGB(156, 174, 160),
Border = Color3.fromRGB(50, 72, 54),
ToggleOn = Color3.fromRGB(74, 170, 104),
ToggleOff = Color3.fromRGB(38, 52, 40),
SliderBar = Color3.fromRGB(38, 52, 40),
InputBackground = Color3.fromRGB(20, 28, 22),
Shadow = Color3.fromRGB(0, 0, 0)
},
Sunset = {
Background = Color3.fromRGB(255, 243, 236),
Card = Color3.fromRGB(255, 250, 247),
CardHover = Color3.fromRGB(255, 245, 240),
Header = Color3.fromRGB(252, 230, 220),
Accent = Color3.fromRGB(255, 126, 95),
AccentGlow = Color3.fromRGB(255, 180, 145),
Text = Color3.fromRGB(60, 45, 40),
SubText = Color3.fromRGB(148, 125, 118),
Border = Color3.fromRGB(236, 214, 206),
ToggleOn = Color3.fromRGB(255, 126, 95),
ToggleOff = Color3.fromRGB(224, 210, 205),
SliderBar = Color3.fromRGB(224, 210, 205),
InputBackground = Color3.fromRGB(255, 252, 250),
Shadow = Color3.fromRGB(210, 185, 175)
},
Galaxy = {
Background = Color3.fromRGB(9, 12, 25),
Card = Color3.fromRGB(18, 22, 40),
CardHover = Color3.fromRGB(26, 31, 54),
Header = Color3.fromRGB(13, 17, 31),
Accent = Color3.fromRGB(120, 160, 255),
AccentGlow = Color3.fromRGB(170, 205, 255),
Text = Color3.fromRGB(245, 247, 255),
SubText = Color3.fromRGB(150, 165, 190),
Border = Color3.fromRGB(45, 56, 84),
ToggleOn = Color3.fromRGB(120, 160, 255),
ToggleOff = Color3.fromRGB(30, 36, 52),
SliderBar = Color3.fromRGB(30, 36, 52),
InputBackground = Color3.fromRGB(14, 18, 30),
Shadow = Color3.fromRGB(0, 0, 0)
},
Arctic = {
Background = Color3.fromRGB(239, 245, 250),
Card = Color3.fromRGB(250, 253, 255),
CardHover = Color3.fromRGB(245, 250, 254),
Header = Color3.fromRGB(229, 238, 246),
Accent = Color3.fromRGB(72, 182, 255),
AccentGlow = Color3.fromRGB(150, 220, 255),
Text = Color3.fromRGB(35, 46, 58),
SubText = Color3.fromRGB(116, 128, 143),
Border = Color3.fromRGB(204, 217, 230),
ToggleOn = Color3.fromRGB(72, 182, 255),
ToggleOff = Color3.fromRGB(210, 220, 232),
SliderBar = Color3.fromRGB(210, 220, 232),
InputBackground = Color3.fromRGB(252, 254, 255),
Shadow = Color3.fromRGB(175, 190, 205)
},
}

-- STREAMING_CHUNK:Creating Main ScreenGui Container...
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GaphopUI_Engine"
ScreenGui.DisplayOrder = 999999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = true
ScreenGui.Parent = ParentUI

-- STREAMING_CHUNK:Defining Animation Utility Helpers & Smooth Easing Physics...
local function Tween(instance, info, properties)
if not instance then return end
local tween = TweenService:Create(instance, info, properties)
tween:Play()
return tween
end

local function SpringTween(instance, duration, properties, style)
style = style or Enum.EasingStyle.Quart
local info = TweenInfo.new(duration or 0.3, style, Enum.EasingDirection.Out)
return Tween(instance, info, properties)
end

local function CreateRipple(parent, inputPosition)
if not parent then return end
local ripple = Instance.new("Frame")
ripple.Name = "RippleEffect"
ripple.AnchorPoint = Vector2.new(0.5, 0.5)
ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ripple.BackgroundTransparency = 0.75
ripple.ZIndex = (parent.ZIndex or 1) + 10
ripple.ClipsDescendants = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = ripple

local parentAbsPos = parent.AbsolutePosition
local parentAbsSize = parent.AbsoluteSize
local relX = (inputPosition and inputPosition.X or (parentAbsPos.X + parentAbsSize.X/2)) - parentAbsPos.X
local relY = (inputPosition and inputPosition.Y or (parentAbsPos.Y + parentAbsSize.Y/2)) - parentAbsPos.Y

ripple.Position = UDim2.fromOffset(relX, relY)
ripple.Size = UDim2.fromOffset(0, 0)
ripple.Parent = parent

local maxSize = math.max(parentAbsSize.X, parentAbsSize.Y) * 2.5
Tween(ripple, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    Size = UDim2.fromOffset(maxSize, maxSize),
    BackgroundTransparency = 1
})

task.delay(0.5, function()
    if ripple and ripple.Parent then ripple:Destroy() end
end)


end

local function CreateCorner(parent, radius)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, radius or 10)
corner.Parent = parent
return corner
end

local function CreateStroke(parent, color, thickness, transparency)
local stroke = Instance.new("UIStroke")
stroke.Color = color or GaphopUI.Themes[GaphopUI.CurrentTheme].Border
stroke.Thickness = thickness or 1
stroke.Transparency = transparency or 0.6
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = parent
return stroke
end

local function ResolveIconValue(icon, fallback)
if icon == nil or icon == false or icon == 0 then
return fallback or ""
end

if type(icon) == "number" then
    return "rbxassetid://" .. tostring(icon)
end

if type(icon) ~= "string" then
    return fallback or ""
end

local cleaned = icon:lower():gsub("^lucide:", ""):gsub("[%s%-]", "")

-- Priority 1: Lucide ImageRect Icons
if cleaned ~= "" and GaphopUI.LucideSprites and GaphopUI.LucideSprites[cleaned] then
    return GaphopUI.LucideSprites[cleaned]
end

-- Priority 2: Standard Text Emojis
if cleaned ~= "" and GaphopUI.Icons[cleaned] then
    return GaphopUI.Icons[cleaned]
end

if icon:match("^rbxassetid://") or icon:match("^http") or icon:match("^rbxthumb://") then
    return icon
end

return icon


end

function GaphopUI:CreateIcon(parent, icon, size, color, opts)
opts = opts or {}
local theme = opts.Theme or GaphopUI.Themes[GaphopUI.CurrentTheme]
local resolved = ResolveIconValue(icon, opts.Fallback)

-- Detect and render Lucide Icon Sprite Array
if type(resolved) == "table" and resolved[1] and resolved[2] and resolved[3] then
    local image = Instance.new("ImageLabel")
    image.BackgroundTransparency = 1
    image.Size = size or UDim2.fromOffset(20, 20)
    image.Position = opts.Position or UDim2.new()
    image.Image = "rbxassetid://" .. tostring(resolved[1])
    image.ImageRectSize = Vector2.new(resolved[2][1], resolved[2][2])
    image.ImageRectOffset = Vector2.new(resolved[3][1], resolved[3][2])
    image.ImageColor3 = color or Color3.new(1, 1, 1)
    image.Parent = parent
    return image
end

-- Legacy image parsing
if type(resolved) == "string" and (resolved:match("^rbxassetid://") or resolved:match("^http") or resolved:match("^rbxthumb://")) then
    local image = Instance.new("ImageLabel")
    image.BackgroundTransparency = 1
    image.Size = size or UDim2.fromOffset(20, 20)
    image.Position = opts.Position or UDim2.new()
    image.Image = resolved
    image.ImageColor3 = color or Color3.new(1, 1, 1)
    image.Parent = parent
    return image
end

-- Legacy text/emoji icon
local label = Instance.new("TextLabel")
label.BackgroundTransparency = 1
label.Size = size or UDim2.fromOffset(20, 20)
label.Position = opts.Position or UDim2.new()
label.Text = tostring(resolved or "")
label.TextColor3 = color or theme.Text
label.Font = Enum.Font.GothamBold
label.TextSize = opts.TextSize or 14
label.Parent = parent
return label


end

-- STREAMING_CHUNK:RGB Glow Engine Management...
function GaphopUI:ToggleRGB(enabled)
GaphopUI.RGBEnabled = enabled
if GaphopUI.RGBConnection then
GaphopUI.RGBConnection:Disconnect()
GaphopUI.RGBConnection = nil
end

if enabled then
    local hue = 0
    GaphopUI.RGBConnection = RunService.RenderStepped:Connect(function(dt)
        hue = (hue + dt * 0.25) % 1
        local color = Color3.fromHSV(hue, 0.85, 1)
        GaphopUI.CurrentRGBColor = color

        if GaphopUI.WindowInstance then
            local stroke = GaphopUI.WindowInstance:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = color end
        end
    end)
else
    if GaphopUI.WindowInstance then
        local stroke = GaphopUI.WindowInstance:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Color = GaphopUI.Themes[GaphopUI.CurrentTheme].Border end
    end
end


end

-- STREAMING_CHUNK:Config File & Persistence Management...
local function EnsureFolder(folderName)
if type(makefolder) == "function" then
pcall(function() makefolder(folderName) end)
end
end

local function SafeWriteFile(path, content)
pcall(function()
EnsureFolder("GaphopUI")
writefile(path, content)
end)
end

local function SaveConfig()
local payload = {
theme = GaphopUI.CurrentTheme,
toggleKey = GaphopUI.ToggleKey and GaphopUI.ToggleKey.Name or "K",
showMobileButton = GaphopUI.Flags.ShowMobileButton ~= false,
isOpen = GaphopUI.IsOpen,
rgbEnabled = GaphopUI.RGBEnabled,
version = GaphopUI.Version
}
SafeWriteFile("GaphopUI/config.json", HttpService:JSONEncode(payload))
end

local function HexToColor3(hex)
hex = hex:gsub("#", "")
local r = tonumber("0x" .. hex:sub(1, 2)) or 255
local g = tonumber("0x" .. hex:sub(3, 4)) or 255
local b = tonumber("0x" .. hex:sub(5, 6)) or 255
return Color3.fromRGB(r, g, b)
end

local function Color3ToHex(color)
if not color then return "#FFFFFF" end
return string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
end

-- STREAMING_CHUNK:Implementing Smooth Window Dragging Mechanics...
local function MakeDraggable(gui, handle)
local dragging, dragInput, dragStart, startPos
handle = handle or gui

local conn1 = handle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = gui.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

local conn2 = handle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

local conn3 = UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        SpringTween(gui, 0.12, {
            Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        }, Enum.EasingStyle.Sine)
    end
end)

table.insert(GaphopUI.Connections, conn1)
table.insert(GaphopUI.Connections, conn2)
table.insert(GaphopUI.Connections, conn3)


end

-- STREAMING_CHUNK:Constructing Animated Notification Stack System...
local NotifyContainer = Instance.new("Frame")
NotifyContainer.Name = "NotifyContainer"
NotifyContainer.Size = UDim2.new(0, 320, 1, -40)
NotifyContainer.Position = UDim2.new(1, -330, 0, 20)
NotifyContainer.BackgroundTransparency = 1
NotifyContainer.ZIndex = 1000
NotifyContainer.Parent = ScreenGui

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifyLayout.Padding = UDim.new(0, 10)
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyLayout.Parent = NotifyContainer

GaphopUI.NotifyContainer = NotifyContainer

function GaphopUI:Notify(cfg)
cfg = cfg or {}
local titleText = cfg.Title or "Notification"
local contentText = cfg.Content or ""
local duration = cfg.Duration or 4
local imgId = cfg.Image
local theme = GaphopUI.Themes[GaphopUI.CurrentTheme]

local card = Instance.new("Frame")
card.Size = UDim2.new(1, 0, 0, 72)
card.BackgroundColor3 = theme.Card
card.BackgroundTransparency = 0.12
card.Position = UDim2.new(1, 360, 0, 0)
card.ClipsDescendants = true
card.Parent = NotifyContainer

CreateCorner(card, 12)
local stroke = CreateStroke(card, theme.Accent, 1, 0.4)

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 16)
padding.PaddingRight = UDim.new(0, 12)
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingBottom = UDim.new(0, 10)
padding.Parent = card

local iconOffset = 0
if imgId then
    iconOffset = 42
    local resolvedNotify = ResolveIconValue(imgId, nil)
    
    local iconImg = Instance.new("ImageLabel")
    iconImg.Size = UDim2.new(0, 34, 0, 34)
    iconImg.Position = UDim2.new(0, 0, 0.5, -17)
    iconImg.BackgroundTransparency = 1
    
    if type(resolvedNotify) == "table" then
        iconImg.Image = "rbxassetid://" .. tostring(resolvedNotify[1])
        iconImg.ImageRectSize = Vector2.new(resolvedNotify[2][1], resolvedNotify[2][2])
        iconImg.ImageRectOffset = Vector2.new(resolvedNotify[3][1], resolvedNotify[3][2])
        iconImg.ImageColor3 = theme.Text
    else
        iconImg.Image = (type(resolvedNotify) == "number" and "rbxassetid://" .. tostring(resolvedNotify)) or tostring(resolvedNotify)
    end
    
    iconImg.Parent = card
    CreateCorner(iconImg, 8)
end

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -iconOffset, 0, 20)
title.Position = UDim2.new(0, iconOffset, 0, 2)
title.BackgroundTransparency = 1
title.Text = titleText
title.TextColor3 = theme.Text
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = card

local content = Instance.new("TextLabel")
content.Size = UDim2.new(1, -iconOffset, 0, 28)
content.Position = UDim2.new(0, iconOffset, 0, 22)
content.BackgroundTransparency = 1
content.Text = contentText
content.TextColor3 = theme.SubText
content.TextSize = 12
content.Font = Enum.Font.Gotham
content.TextWrapped = true
content.TextXAlignment = Enum.TextXAlignment.Left
content.Parent = card

SpringTween(card, 0.45, { Position = UDim2.new(0, 0, 0, 0) }, Enum.EasingStyle.Back)

local timerBar = Instance.new("Frame")
timerBar.Size = UDim2.new(1, 0, 0, 3)
timerBar.Position = UDim2.new(0, 0, 1, -3)
timerBar.BackgroundColor3 = theme.Accent
timerBar.BorderSizePixel = 0
timerBar.Parent = card

Tween(timerBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
    Size = UDim2.new(0, 0, 0, 3)
})

task.delay(duration, function()
    if card and card.Parent then
        local exitTween = SpringTween(card, 0.35, {
            Position = UDim2.new(1, 360, 0, 0),
            BackgroundTransparency = 1
        }, Enum.EasingStyle.Quart)

        if exitTween then
            exitTween.Completed:Connect(function() card:Destroy() end)
        else
            card:Destroy()
        end
    end
end)


end

-- STREAMING_CHUNK:Building Floating Mobile Button & Window Toggle Logic...
local function IsMobile()
return UserInputService.TouchEnabled
end

local function CreateOpenButton()
if not IsMobile() or GaphopUI.OpenButton then return end

local theme = GaphopUI.Themes[GaphopUI.CurrentTheme]
local btn = Instance.new("TextButton")
btn.Name = "GaphopOpenButton"
btn.Size = UDim2.new(0, 160, 0, 44)
btn.AnchorPoint = Vector2.new(0.5, 0)
btn.Position = UDim2.new(0.5, 0, 0, 16)
btn.BackgroundColor3 = theme.Card
btn.BackgroundTransparency = 0.1
btn.Text = "Open GaphopUI"
btn.TextColor3 = theme.Text
btn.TextSize = 13
btn.Font = Enum.Font.GothamBold
btn.ZIndex = 9999
btn.Visible = not GaphopUI.IsOpen
btn.Parent = ScreenGui

CreateCorner(btn, 18)
CreateStroke(btn, theme.Accent, 1.2, 0.3)
MakeDraggable(btn, btn)

btn.MouseButton1Click:Connect(function(input)
    CreateRipple(btn, input)
    GaphopUI:ToggleUI(true)
end)

GaphopUI.OpenButton = btn


end

function GaphopUI:ToggleUI(forceState)
local shouldOpen = (forceState ~= nil and forceState) or (not GaphopUI.IsOpen)
GaphopUI.IsOpen = shouldOpen

if GaphopUI.WindowInstance then
    if GaphopUI.IsOpen then
        GaphopUI.WindowInstance.Visible = true
        SpringTween(GaphopUI.WindowInstance, 0.4, {
            Size = GaphopUI.WindowInstance:GetAttribute("NormalSize") or UDim2.new(0, 680, 0, 440),
            BackgroundTransparency = 0.15
        }, Enum.EasingStyle.Back)

        if GaphopUI.OpenButton then GaphopUI.OpenButton.Visible = false end
    else
        local tw = SpringTween(GaphopUI.WindowInstance, 0.3, {
            Size = UDim2.new(0, 680, 0, 0),
            BackgroundTransparency = 1
        }, Enum.EasingStyle.Quart)

        if tw then
            tw.Completed:Connect(function()
                if not GaphopUI.IsOpen then GaphopUI.WindowInstance.Visible = false end
            end)
        else
            GaphopUI.WindowInstance.Visible = false
        end

        if IsMobile() and GaphopUI.Flags.ShowMobileButton ~= false then
            if not GaphopUI.OpenButton then CreateOpenButton() end
            if GaphopUI.OpenButton then GaphopUI.OpenButton.Visible = true end
        end
    end
end
SaveConfig()


end

UserInputService.InputBegan:Connect(function(input, gpe)
if not gpe and input.KeyCode == GaphopUI.ToggleKey then
GaphopUI:ToggleUI()
end
end)

-- STREAMING_CHUNK:Theme Dynamic Updating & Live Search Filter Engine...
local function RegisterElement(entry)
if entry then table.insert(GaphopUI.Elements, entry) end
end

local function ApplyThemeToEntry(entry, theme)
if not entry then return end
if entry.Card then entry.Card.BackgroundColor3 = theme.Card end
if entry.Stroke then entry.Stroke.Color = theme.Border end
if entry.Label then entry.Label.TextColor3 = theme.Text end
if entry.SubLabel then entry.SubLabel.TextColor3 = theme.SubText end
if entry.Input then
entry.Input.BackgroundColor3 = theme.InputBackground
entry.Input.TextColor3 = theme.Text
entry.Input.PlaceholderColor3 = theme.SubText
end
if entry.Button then entry.Button.TextColor3 = theme.Text end
if entry.ToggleBg then entry.ToggleBg.BackgroundColor3 = entry.ToggleState and theme.ToggleOn or theme.ToggleOff end
if entry.ToggleKnob then entry.ToggleKnob.BackgroundColor3 = theme.Text end
if entry.SliderTrack then entry.SliderTrack.BackgroundColor3 = theme.SliderBar end
if entry.SliderFill then entry.SliderFill.BackgroundColor3 = theme.Accent end
if entry.ValueLabel then entry.ValueLabel.TextColor3 = theme.SubText end
if entry.DropdownButton then
entry.DropdownButton.BackgroundColor3 = theme.InputBackground
entry.DropdownButton.TextColor3 = theme.Text
end
if entry.BindButton then
entry.BindButton.BackgroundColor3 = theme.InputBackground
entry.BindButton.TextColor3 = theme.Text
end
if entry.ColorDisplay then entry.ColorDisplay.BackgroundColor3 = entry.ColorValue or theme.Text end
end

function GaphopUI:ApplyTheme(themeName)
local theme = GaphopUI.Themes[themeName] or GaphopUI.Themes.Dark
GaphopUI.CurrentTheme = themeName or GaphopUI.CurrentTheme

if GaphopUI.WindowInstance then
    GaphopUI.WindowInstance.BackgroundColor3 = theme.Background
    local topBar = GaphopUI.WindowInstance:FindFirstChild("TopBar")
    if topBar then topBar.BackgroundColor3 = theme.Header end
    local sideBar = GaphopUI.WindowInstance:FindFirstChild("SideBar")
    if sideBar then sideBar.BackgroundColor3 = theme.Card end
end

for _, entry in ipairs(GaphopUI.Elements) do
    ApplyThemeToEntry(entry, theme)
end


end

function GaphopUI:FilterElements(query)
local q = (query or ""):lower()
for _, entry in ipairs(GaphopUI.Elements) do
if entry and entry.Card then
if entry.Type == "search" then
entry.Card.Visible = true
else
local match = (q == "") or (entry.SearchText and string.find(string.lower(entry.SearchText), q, 1, true) ~= nil)
entry.Card.Visible = match
end
end
end
end

-- STREAMING_CHUNK:Constructing Modal Prompt Dialog System...
function GaphopUI:CreatePrompt(cfg)
cfg = cfg or {}
local titleText = cfg.Title or "Confirmation"
local contentText = cfg.Content or "Are you sure you want to proceed?"
local confirmText = cfg.ConfirmText or "Confirm"
local cancelText = cfg.CancelText or "Cancel"
local onConfirm = cfg.OnConfirm or function() end
local onCancel = cfg.OnCancel or function() end
local theme = GaphopUI.Themes[GaphopUI.CurrentTheme]

local overlay = Instance.new("Frame")
overlay.Size = UDim2.fromScale(1, 1)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 1
overlay.ZIndex = 99999999999999
overlay.Parent = ScreenGui

Tween(overlay, TweenInfo.new(0.25), {BackgroundTransparency = 1})

local modal = Instance.new("Frame")
modal.Size = UDim2.new(0, 340, 0, 180)
modal.AnchorPoint = Vector2.new(0.5, 0.5)
modal.Position = UDim2.fromScale(0.5, 0.45)
modal.BackgroundColor3 = theme.Background
modal.BackgroundTransparency = 0.05
modal.Parent = overlay

CreateCorner(modal, 14)
CreateStroke(modal, theme.Accent, 1.2, 0.3)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -24, 0, 24)
title.Position = UDim2.new(0, 12, 0, 14)
title.BackgroundTransparency = 1
title.Text = titleText
title.TextColor3 = theme.Text
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = modal

local content = Instance.new("TextLabel")
content.Size = UDim2.new(1, -24, 0, 50)
content.Position = UDim2.new(0, 12, 0, 44)
content.BackgroundTransparency = 1
content.Text = contentText
content.TextColor3 = theme.SubText
content.TextSize = 12
content.Font = Enum.Font.Gotham
content.TextWrapped = true
content.TextXAlignment = Enum.TextXAlignment.Center
content.Parent = modal

local function CloseModal()
    SpringTween(modal, 0.2, {Position = UDim2.fromScale(0.5, 0.4)}, Enum.EasingStyle.Quart)
    Tween(overlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}).Completed:Connect(function()
        overlay:Destroy()
    end)
end

local confirmBtn = Instance.new("TextButton")
confirmBtn.Size = UDim2.new(0, 140, 0, 36)
confirmBtn.Position = UDim2.new(0, 22, 1, -48)
confirmBtn.BackgroundColor3 = theme.Accent
confirmBtn.Text = confirmText
confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmBtn.Font = Enum.Font.GothamBold
confirmBtn.TextSize = 13
confirmBtn.Parent = modal
CreateCorner(confirmBtn, 8)

confirmBtn.MouseButton1Click:Connect(function(input)
    CreateRipple(confirmBtn, input)
    CloseModal()
    onConfirm()
end)

local cancelBtn = Instance.new("TextButton")
cancelBtn.Size = UDim2.new(0, 140, 0, 36)
cancelBtn.Position = UDim2.new(1, -162, 1, -48)
cancelBtn.BackgroundColor3 = theme.Card
cancelBtn.Text = cancelText
cancelBtn.TextColor3 = theme.Text
cancelBtn.Font = Enum.Font.GothamMedium
cancelBtn.TextSize = 13
cancelBtn.Parent = modal
CreateCorner(cancelBtn, 8)
CreateStroke(cancelBtn, theme.Border, 1, 0.5)

cancelBtn.MouseButton1Click:Connect(function(input)
    CreateRipple(cancelBtn, input)
    CloseModal()
    onCancel()
end)

SpringTween(modal, 0.35, {Position = UDim2.fromScale(0.5, 0.5)}, Enum.EasingStyle.Back)


end

-- STREAMING_CHUNK:Binding UI Component Engine with Spring & Ripple Animations...
local function BindElementMethods(TabObj, page, theme)
TabObj = TabObj or {}

function TabObj:makeButton(cfg)
    cfg = cfg or {}
    local btnName = cfg.Name or "Button"
    local callback = cfg.Callback or function() end

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, 42)
    card.BackgroundColor3 = theme.Card
    card.BackgroundTransparency = 0.3
    card.ClipsDescendants = true
    card.Parent = page

    local stroke = CreateStroke(card, theme.Border, 1, 0.6)
    CreateCorner(card, 8)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = btnName
    btn.TextColor3 = theme.Text
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = card

    btn.MouseEnter:Connect(function()
        SpringTween(card, 0.2, {BackgroundColor3 = theme.CardHover})
    end)
    btn.MouseLeave:Connect(function()
        SpringTween(card, 0.2, {BackgroundColor3 = theme.Card})
    end)
    btn.MouseButton1Click:Connect(function(input)
        CreateRipple(card, input)
        SpringTween(card, 0.1, {Size = UDim2.new(1, -12, 0, 38)}).Completed:Connect(function()
            SpringTween(card, 0.15, {Size = UDim2.new(1, -6, 0, 42)})
        end)
        callback()
    end)

    RegisterElement({Type = "button", Card = card, Stroke = stroke, Button = btn, SearchText = btnName, Page = page})
end
TabObj.CreateButton = TabObj.makeButton
TabObj.AddButton = TabObj.makeButton

function TabObj:makeToggle(cfg)
    cfg = cfg or {}
    local name = cfg.Name or "Toggle"
    local state = cfg.CurrentValue or false
    local flag = cfg.Flag
    local callback = cfg.Callback or function() end

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, 42)
    card.BackgroundColor3 = theme.Card
    card.BackgroundTransparency = 0.3
    card.ClipsDescendants = true
    card.Parent = page

    local stroke = CreateStroke(card, theme.Border, 1, 0.6)
    CreateCorner(card, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = theme.Text
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local switchBg = Instance.new("TextButton")
    switchBg.Size = UDim2.new(0, 44, 0, 22)
    switchBg.Position = UDim2.new(1, -54, 0.5, -11)
    switchBg.BackgroundColor3 = state and theme.ToggleOn or theme.ToggleOff
    switchBg.Text = ""
    switchBg.Parent = card
    CreateCorner(switchBg, 12)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = switchBg
    CreateCorner(knob, 10)

    local function SetToggleState(newState)
        state = newState
        if flag then GaphopUI.Flags[flag] = state end
        SpringTween(switchBg, 0.25, {BackgroundColor3 = state and theme.ToggleOn or theme.ToggleOff})
        SpringTween(knob, 0.25, {Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}, Enum.EasingStyle.Back)
        callback(state)
    end

    switchBg.MouseButton1Click:Connect(function(input)
        CreateRipple(card, input)
        SetToggleState(not state)
    end)
    if flag then GaphopUI.Flags[flag] = state end

    RegisterElement({Type = "toggle", Card = card, Stroke = stroke, Label = label, ToggleBg = switchBg, ToggleKnob = knob, ToggleState = state, SearchText = name, Page = page})
end
TabObj.CreateToggle = TabObj.makeToggle
TabObj.AddToggle = TabObj.makeToggle

function TabObj:makeSlider(cfg)
    cfg = cfg or {}
    local name = cfg.Name or "Slider"
    local range = cfg.Range or {0, 100}
    local minVal, maxVal = range[1] or 0, range[2] or 100
    local val = cfg.CurrentValue or minVal
    local suffix = cfg.Suffix or ""
    local flag = cfg.Flag
    local callback = cfg.Callback or function() end

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, 56)
    card.BackgroundColor3 = theme.Card
    card.BackgroundTransparency = 0.3
    card.ClipsDescendants = false
    card.Parent = page

    local stroke = CreateStroke(card, theme.Border, 1, 0.6)
    CreateCorner(card, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 0, 24)
    label.Position = UDim2.new(0, 12, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = theme.Text
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0, 60, 0, 24)
    valLabel.Position = UDim2.new(1, -72, 0, 4)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(val) .. suffix
    valLabel.TextColor3 = theme.Accent
    valLabel.TextSize = 12
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.Parent = card

    local sliderTrack = Instance.new("Frame")
    sliderTrack.Size = UDim2.new(1, -24, 0, 6)
    sliderTrack.Position = UDim2.new(0, 12, 0, 38)
    sliderTrack.BackgroundColor3 = theme.SliderBar
    sliderTrack.Parent = card
    CreateCorner(sliderTrack, 3)

    local initPercent = (val - minVal) / (maxVal - minVal)
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(math.clamp(initPercent, 0, 1), 0, 1, 0)
    sliderFill.BackgroundColor3 = theme.Accent
    sliderFill.Parent = sliderTrack
    CreateCorner(sliderFill, 3)

    local tooltip = Instance.new("Frame")
    tooltip.Size = UDim2.new(0, 38, 0, 20)
    tooltip.AnchorPoint = Vector2.new(0.5, 1)
    tooltip.Position = UDim2.new(initPercent, 0, 0, -6)
    tooltip.BackgroundColor3 = theme.Header
    tooltip.Visible = false
    tooltip.ZIndex = 20
    tooltip.Parent = sliderTrack
    CreateCorner(tooltip, 4)
    CreateStroke(tooltip, theme.Accent, 1, 0.4)

    local tooltipText = Instance.new("TextLabel")
    tooltipText.Size = UDim2.fromScale(1, 1)
    tooltipText.BackgroundTransparency = 1
    tooltipText.Text = tostring(val)
    tooltipText.TextColor3 = theme.Text
    tooltipText.TextSize = 10
    tooltipText.Font = Enum.Font.GothamBold
    tooltipText.Parent = tooltip

    local dragging = false
    local function UpdateSlider(input)
        local pos = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
        local calculated = math.floor(minVal + (maxVal - minVal) * pos)

        SpringTween(sliderFill, 0.08, { Size = UDim2.new(pos, 0, 1, 0) }, Enum.EasingStyle.Sine)
        tooltip.Position = UDim2.new(pos, 0, 0, -6)
        tooltipText.Text = tostring(calculated)
        valLabel.Text = tostring(calculated) .. suffix

        if flag then GaphopUI.Flags[flag] = calculated end
        callback(calculated)
    end

    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            tooltip.Visible = true
            UpdateSlider(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            tooltip.Visible = false
        end
    end)

    RegisterElement({Type = "slider", Card = card, Stroke = stroke, Label = label, SliderTrack = sliderTrack, SliderFill = sliderFill, ValueLabel = valLabel, SearchText = name, Page = page})
end
TabObj.CreateSlider = TabObj.makeSlider
TabObj.AddSlider = TabObj.makeSlider

function TabObj:makeInput(cfg)
    cfg = cfg or {}
    local name = cfg.Name or "Input"
    local placeholder = cfg.PlaceholderText or "Type here..."
    local callback = cfg.Callback or function() end

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, 42)
    card.BackgroundColor3 = theme.Card
    card.BackgroundTransparency = 0.3
    card.ClipsDescendants = true
    card.Parent = page

    local stroke = CreateStroke(card, theme.Border, 1, 0.6)
    CreateCorner(card, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 150, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = theme.Text
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 160, 0, 26)
    textBox.Position = UDim2.new(1, -172, 0.5, -13)
    textBox.BackgroundColor3 = theme.InputBackground
    textBox.Text = ""
    textBox.PlaceholderText = placeholder
    textBox.TextColor3 = theme.Text
    textBox.PlaceholderColor3 = theme.SubText
    textBox.TextSize = 12
    textBox.Font = Enum.Font.Gotham
    textBox.Parent = card
    CreateCorner(textBox, 6)
    local boxStroke = CreateStroke(textBox, theme.Border, 1, 0.4)

    textBox.Focused:Connect(function()
        SpringTween(boxStroke, 0.2, {Color = theme.Accent, Transparency = 0.1})
    end)
    textBox.FocusLost:Connect(function()
        SpringTween(boxStroke, 0.2, {Color = theme.Border, Transparency = 0.4})
        callback(textBox.Text)
    end)

    RegisterElement({Type = "input", Card = card, Stroke = stroke, Label = label, Input = textBox, SearchText = name, Page = page})
end
TabObj.CreateInput = TabObj.makeInput
TabObj.AddInput = TabObj.makeInput

function TabObj:makeDropdown(cfg)
    cfg = cfg or {}
    local name = cfg.Name or "Dropdown"
    local options = cfg.Options or {}
    local current = cfg.CurrentOption or options[1] or ""
    local flag = cfg.Flag
    local callback = cfg.Callback or function() end

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, 42)
    card.BackgroundColor3 = theme.Card
    card.BackgroundTransparency = 0.3
    card.ClipsDescendants = true
    card.Parent = page

    local stroke = CreateStroke(card, theme.Border, 1, 0.6)
    CreateCorner(card, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 150, 0, 42)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = theme.Text
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local dropBtn = Instance.new("TextButton")
    dropBtn.Size = UDim2.new(0, 150, 0, 26)
    dropBtn.Position = UDim2.new(1, -162, 0, 8)
    dropBtn.BackgroundColor3 = theme.InputBackground
    dropBtn.Text = tostring(current) .. "   " .. GaphopUI.Icons.chevron
    dropBtn.TextColor3 = theme.Text
    dropBtn.TextSize = 12
    dropBtn.Font = Enum.Font.Gotham
    dropBtn.Parent = card
    CreateCorner(dropBtn, 6)

    local isOpen = false
    local dropList = Instance.new("Frame")
    dropList.Size = UDim2.new(1, -24, 0, 0)
    dropList.Position = UDim2.new(0, 12, 0, 46)
    dropList.BackgroundTransparency = 1
    dropList.ClipsDescendants = true
    dropList.Parent = card

    local dropLayout = Instance.new("UIListLayout")
    dropLayout.SortOrder = Enum.SortOrder.LayoutOrder
    dropLayout.Padding = UDim.new(0, 4)
    dropLayout.Parent = dropList

    local function CloseDropdown()
        isOpen = false
        SpringTween(card, 0.3, {Size = UDim2.new(1, -6, 0, 42)}, Enum.EasingStyle.Quart)
        SpringTween(dropList, 0.3, {Size = UDim2.new(1, -24, 0, 0)}, Enum.EasingStyle.Quart)
        dropBtn.Text = tostring(current) .. "   " .. GaphopUI.Icons.chevron
    end

    local function RefreshOptions()
        for _, child in ipairs(dropList:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        local listHeight = 0
        for i, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 24)
            optBtn.BackgroundColor3 = theme.CardHover
            optBtn.BackgroundTransparency = 0.5
            optBtn.Text = tostring(opt)
            optBtn.TextColor3 = theme.Text
            optBtn.TextSize = 12
            optBtn.Font = Enum.Font.Gotham
            optBtn.Parent = dropList
            CreateCorner(optBtn, 4)

            optBtn.MouseButton1Click:Connect(function()
                current = opt
                if flag then GaphopUI.Flags[flag] = current end
                CloseDropdown()
                callback(current)
            end)
            listHeight = listHeight + 28
        end
        if isOpen then
            SpringTween(card, 0.3, {Size = UDim2.new(1, -6, 0, 48 + listHeight)}, Enum.EasingStyle.Quart)
            SpringTween(dropList, 0.3, {Size = UDim2.new(1, -24, 0, listHeight)}, Enum.EasingStyle.Quart)
        end
    end

    RefreshOptions()

    dropBtn.MouseButton1Click:Connect(function(input)
        CreateRipple(dropBtn, input)
        isOpen = not isOpen
        if isOpen then
            RefreshOptions()
            dropBtn.Text = tostring(current) .. "   ▲"
        else
            CloseDropdown()
        end
    end)

    RegisterElement({Type = "dropdown", Card = card, Stroke = stroke, Label = label, DropdownButton = dropBtn, SearchText = name, Page = page})

    -- Return object to allow modifying dropdown options dynamically
    return {
        Refresh = function(newOptions, newCurrent)
            options = newOptions or options
            current = newCurrent or current
            if not table.find(options, current) and #options > 0 then
                current = options[1]
            end
            dropBtn.Text = tostring(current) .. "   " .. (isOpen and "▲" or GaphopUI.Icons.chevron)
            if isOpen then RefreshOptions() end
        end
    }
end
TabObj.CreateDropdown = TabObj.makeDropdown
TabObj.AddDropdown = TabObj.makeDropdown

function TabObj:makeColorPicker(cfg)
    cfg = cfg or {}
    local name = cfg.Name or "Color Picker"
    local defaultColor = cfg.DefaultColor or Color3.fromRGB(255, 255, 255)
    local flag = cfg.Flag
    local callback = cfg.Callback or function() end

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, 42)
    card.BackgroundColor3 = theme.Card
    card.BackgroundTransparency = 0.3
    card.ClipsDescendants = true
    card.Parent = page

    local stroke = CreateStroke(card, theme.Border, 1, 0.6)
    CreateCorner(card, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 150, 0, 42)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = theme.Text
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 40, 0, 24)
    colorBtn.Position = UDim2.new(1, -52, 0.5, -12)
    colorBtn.BackgroundColor3 = defaultColor
    colorBtn.Text = ""
    colorBtn.Parent = card
    CreateCorner(colorBtn, 6)
    CreateStroke(colorBtn, theme.Border, 1, 0.2)

    local isOpen = false
    local pickerHeight = 160

    local pickerFrame = Instance.new("Frame")
    pickerFrame.Size = UDim2.new(1, -24, 0, pickerHeight)
    pickerFrame.Position = UDim2.new(0, 12, 0, 46)
    pickerFrame.BackgroundTransparency = 1
    pickerFrame.Visible = false
    pickerFrame.Parent = card

    local rLabel = Instance.new("TextLabel", pickerFrame)
    rLabel.Size = UDim2.new(0, 15, 0, 20)
    rLabel.Position = UDim2.new(0, 0, 0, 0)
    rLabel.BackgroundTransparency = 1
    rLabel.Text = "R"
    rLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    rLabel.Font = Enum.Font.GothamBold
    rLabel.TextSize = 12

    local rBox = Instance.new("TextBox", pickerFrame)
    rBox.Size = UDim2.new(1, -25, 0, 20)
    rBox.Position = UDim2.new(0, 20, 0, 0)
    rBox.BackgroundColor3 = theme.InputBackground
    rBox.TextColor3 = theme.Text
    rBox.Text = tostring(math.floor(defaultColor.R * 255))
    rBox.Font = Enum.Font.Gotham
    rBox.TextSize = 12
    CreateCorner(rBox, 4)

    local gLabel = Instance.new("TextLabel", pickerFrame)
    gLabel.Size = UDim2.new(0, 15, 0, 20)
    gLabel.Position = UDim2.new(0, 0, 0, 30)
    gLabel.BackgroundTransparency = 1
    gLabel.Text = "G"
    gLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    gLabel.Font = Enum.Font.GothamBold
    gLabel.TextSize = 12

    local gBox = Instance.new("TextBox", pickerFrame)
    gBox.Size = UDim2.new(1, -25, 0, 20)
    gBox.Position = UDim2.new(0, 20, 0, 30)
    gBox.BackgroundColor3 = theme.InputBackground
    gBox.TextColor3 = theme.Text
    gBox.Text = tostring(math.floor(defaultColor.G * 255))
    gBox.Font = Enum.Font.Gotham
    gBox.TextSize = 12
    CreateCorner(gBox, 4)

    local bLabel = Instance.new("TextLabel", pickerFrame)
    bLabel.Size = UDim2.new(0, 15, 0, 20)
    bLabel.Position = UDim2.new(0, 0, 0, 60)
    bLabel.BackgroundTransparency = 1
    bLabel.Text = "B"
    bLabel.TextColor3 = Color3.fromRGB(100, 100, 255)
    bLabel.Font = Enum.Font.GothamBold
    bLabel.TextSize = 12

    local bBox = Instance.new("TextBox", pickerFrame)
    bBox.Size = UDim2.new(1, -25, 0, 20)
    bBox.Position = UDim2.new(0, 20, 0, 60)
    bBox.BackgroundColor3 = theme.InputBackground
    bBox.TextColor3 = theme.Text
    bBox.Text = tostring(math.floor(defaultColor.B * 255))
    bBox.Font = Enum.Font.Gotham
    bBox.TextSize = 12
    CreateCorner(bBox, 4)

    local hexLabel = Instance.new("TextLabel", pickerFrame)
    hexLabel.Size = UDim2.new(0, 30, 0, 20)
    hexLabel.Position = UDim2.new(0, 0, 0, 90)
    hexLabel.BackgroundTransparency = 1
    hexLabel.Text = "HEX"
    hexLabel.TextColor3 = theme.SubText
    hexLabel.Font = Enum.Font.GothamBold
    hexLabel.TextSize = 12

    local hexBox = Instance.new("TextBox", pickerFrame)
    hexBox.Size = UDim2.new(1, -40, 0, 20)
    hexBox.Position = UDim2.new(0, 35, 0, 90)
    hexBox.BackgroundColor3 = theme.InputBackground
    hexBox.TextColor3 = theme.Text
    hexBox.Text = Color3ToHex(defaultColor)
    hexBox.Font = Enum.Font.Gotham
    hexBox.TextSize = 12
    CreateCorner(hexBox, 4)

    local confirmBtn = Instance.new("TextButton", pickerFrame)
    confirmBtn.Size = UDim2.new(1, 0, 0, 26)
    confirmBtn.Position = UDim2.new(0, 0, 0, 125)
    confirmBtn.BackgroundColor3 = theme.Accent
    confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    confirmBtn.Text = "Apply Color"
    confirmBtn.Font = Enum.Font.GothamBold
    confirmBtn.TextSize = 12
    CreateCorner(confirmBtn, 6)

    local currentColor = defaultColor

    local function UpdateColor(newColor)
        currentColor = newColor
        colorBtn.BackgroundColor3 = currentColor
        rBox.Text = tostring(math.floor(currentColor.R * 255))
        gBox.Text = tostring(math.floor(currentColor.G * 255))
        bBox.Text = tostring(math.floor(currentColor.B * 255))
        hexBox.Text = Color3ToHex(currentColor)
        if flag then GaphopUI.Flags[flag] = currentColor end
        callback(currentColor)
    end

    local function ParseRGB()
        local r = tonumber(rBox.Text) or math.floor(currentColor.R * 255)
        local g = tonumber(gBox.Text) or math.floor(currentColor.G * 255)
        local b = tonumber(bBox.Text) or math.floor(currentColor.B * 255)
        r = math.clamp(r, 0, 255)
        g = math.clamp(g, 0, 255)
        b = math.clamp(b, 0, 255)
        UpdateColor(Color3.fromRGB(r, g, b))
    end

    rBox.FocusLost:Connect(ParseRGB)
    gBox.FocusLost:Connect(ParseRGB)
    bBox.FocusLost:Connect(ParseRGB)

    hexBox.FocusLost:Connect(function()
        local col = HexToColor3(hexBox.Text)
        UpdateColor(col)
    end)

    confirmBtn.MouseButton1Click:Connect(function(input)
        CreateRipple(confirmBtn, input)
        ParseRGB()
        isOpen = false
        SpringTween(card, 0.35, {Size = UDim2.new(1, -6, 0, 42)}, Enum.EasingStyle.Quart)
        pickerFrame.Visible = false
    end)

    colorBtn.MouseButton1Click:Connect(function(input)
        CreateRipple(colorBtn, input)
        isOpen = not isOpen
        if isOpen then
            pickerFrame.Visible = true
            SpringTween(card, 0.35, {Size = UDim2.new(1, -6, 0, 42 + pickerHeight + 10)}, Enum.EasingStyle.Quart)
        else
            SpringTween(card, 0.35, {Size = UDim2.new(1, -6, 0, 42)}, Enum.EasingStyle.Quart)
            task.delay(0.2, function()
                if not isOpen then pickerFrame.Visible = false end
            end)
        end
    end)

    if flag then GaphopUI.Flags[flag] = currentColor end

    RegisterElement({Type = "colorpicker", Card = card, Stroke = stroke, Label = label, ColorDisplay = colorBtn, ColorValue = currentColor, SearchText = name, Page = page})
end
TabObj.CreateColorPicker = TabObj.makeColorPicker
TabObj.AddColorPicker = TabObj.makeColorPicker

function TabObj:makeKeybind(cfg)
    cfg = cfg or {}
    local name = cfg.Name or "Keybind"
    local defaultKey = cfg.CurrentKeybind or "None"
    local flag = cfg.Flag
    local holdToInteract = cfg.HoldToInteract or false
    local callback = cfg.Callback or function() end

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, 42)
    card.BackgroundColor3 = theme.Card
    card.BackgroundTransparency = 0.3
    card.ClipsDescendants = true
    card.Parent = page

    local stroke = CreateStroke(card, theme.Border, 1, 0.6)
    CreateCorner(card, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 150, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = theme.Text
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local bindBtn = Instance.new("TextButton")
    bindBtn.Size = UDim2.new(0, 80, 0, 26)
    bindBtn.Position = UDim2.new(1, -92, 0.5, -13)
    bindBtn.BackgroundColor3 = theme.InputBackground
    bindBtn.Text = typeof(defaultKey) == "EnumItem" and defaultKey.Name or tostring(defaultKey)
    bindBtn.TextColor3 = theme.Text
    bindBtn.TextSize = 12
    bindBtn.Font = Enum.Font.GothamBold
    bindBtn.Parent = card
    CreateCorner(bindBtn, 6)
    CreateStroke(bindBtn, theme.Border, 1, 0.4)

    local currentKey = typeof(defaultKey) == "EnumItem" and defaultKey or (defaultKey ~= "None" and Enum.KeyCode[defaultKey] or nil)
    local isBinding = false

    bindBtn.MouseButton1Click:Connect(function()
        isBinding = true
        bindBtn.Text = "..."
        bindBtn.TextColor3 = theme.Accent
    end)

    local function FormatKeyName(key)
        if not key then return "None" end
        local name = key.Name
        if name:match("MouseButton") then
            return name:gsub("MouseButton", "MB")
        end
        return name
    end

    UserInputService.InputBegan:Connect(function(input, gpe)
        if isBinding then
            if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType.Name:match("MouseButton") then
                local key = input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode or input.UserInputType
                
                if key == Enum.KeyCode.Escape or key == Enum.KeyCode.Backspace then
                    currentKey = nil
                    bindBtn.Text = "None"
                else
                    currentKey = key
                    bindBtn.Text = FormatKeyName(currentKey)
                end
                
                bindBtn.TextColor3 = theme.Text
                isBinding = false
                if flag then GaphopUI.Flags[flag] = currentKey end
            end
        elseif not gpe and currentKey then
            local isMatch = false
            if typeof(currentKey) == "EnumItem" then
                if currentKey.EnumType == Enum.KeyCode and input.KeyCode == currentKey then
                    isMatch = true
                elseif currentKey.EnumType == Enum.UserInputType and input.UserInputType == currentKey then
                    isMatch = true
                end
            end
            
            if isMatch then
                if holdToInteract then
                    callback(true)
                else
                    callback()
                end
            end
        end
    end)

    if holdToInteract then
        UserInputService.InputEnded:Connect(function(input, gpe)
            if not gpe and not isBinding and currentKey then
                local isMatch = false
                if typeof(currentKey) == "EnumItem" then
                    if currentKey.EnumType == Enum.KeyCode and input.KeyCode == currentKey then
                        isMatch = true
                    elseif currentKey.EnumType == Enum.UserInputType and input.UserInputType == currentKey then
                        isMatch = true
                    end
                end
                if isMatch then
                    callback(false)
                end
            end
        end)
    end

    if flag then GaphopUI.Flags[flag] = currentKey end
    RegisterElement({Type = "keybind", Card = card, Stroke = stroke, Label = label, BindButton = bindBtn, SearchText = name, Page = page})
end
TabObj.CreateKeybind = TabObj.makeKeybind
TabObj.AddKeybind = TabObj.makeKeybind

function TabObj:makeLabel(cfg)
    cfg = cfg or {}
    local text = cfg.Text or "Label"

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, 36)
    card.BackgroundColor3 = theme.Card
    card.BackgroundTransparency = 0.8
    card.ClipsDescendants = true
    card.Parent = page

    local stroke = CreateStroke(card, theme.Border, 1, 0.8)
    CreateCorner(card, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -24, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = theme.SubText
    label.TextSize = 13
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.Parent = card

    RegisterElement({Type = "label", Card = card, Stroke = stroke, Label = label, SearchText = text, Page = page})
    
    return {
        SetText = function(newText)
            label.Text = tostring(newText)
        end
    }
end
TabObj.CreateLabel = TabObj.makeLabel
TabObj.AddLabel = TabObj.makeLabel

function TabObj:makeParagraph(cfg)
    cfg = cfg or {}
    local titleText = cfg.Title or "Paragraph"
    local contentText = cfg.Content or "Content goes here."

    local card = Instance.new("Frame")
    card.BackgroundColor3 = theme.Card
    card.BackgroundTransparency = 0.5
    card.ClipsDescendants = true
    card.Parent = page

    local stroke = CreateStroke(card, theme.Border, 1, 0.7)
    CreateCorner(card, 8)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -24, 0, 24)
    titleLabel.Position = UDim2.new(0, 12, 0, 6)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = titleText
    titleLabel.TextColor3 = theme.Text
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = card
    
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Position = UDim2.new(0, 12, 0, 32)
    contentLabel.Size = UDim2.new(1, -24, 0, 0)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = contentText
    contentLabel.TextColor3 = theme.SubText
    contentLabel.TextSize = 12
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextYAlignment = Enum.TextYAlignment.Top
    contentLabel.TextWrapped = true
    contentLabel.Parent = card
    
    -- Automatically calculate height based on content
    local function UpdateHeight()
        contentLabel.Size = UDim2.new(1, -24, 0, 500) -- temporary large height to measure
        local textBounds = contentLabel.TextBounds
        contentLabel.Size = UDim2.new(1, -24, 0, textBounds.Y)
        card.Size = UDim2.new(1, -6, 0, 32 + textBounds.Y + 12)
    end
    
    UpdateHeight()

    RegisterElement({Type = "paragraph", Card = card, Stroke = stroke, Label = titleLabel, SubLabel = contentLabel, SearchText = titleText .. " " .. contentText, Page = page})
    
    return {
        SetTitle = function(newTitle)
            titleLabel.Text = tostring(newTitle)
        end,
        SetContent = function(newContent)
            contentLabel.Text = tostring(newContent)
            UpdateHeight()
        end
    }
end
TabObj.CreateParagraph = TabObj.makeParagraph
TabObj.AddParagraph = TabObj.makeParagraph

function TabObj:makeSection(cfg)
    cfg = cfg or {}
    local titleText = cfg.Name or "Section"

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = page
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = theme.Border
    line.BackgroundTransparency = 0.5
    line.Parent = frame
    
    local labelBg = Instance.new("Frame")
    labelBg.BackgroundColor3 = theme.Background
    labelBg.BorderSizePixel = 0
    labelBg.AnchorPoint = Vector2.new(0.5, 0.5)
    labelBg.Position = UDim2.new(0.5, 0, 0.5, 0)
    labelBg.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = titleText
    label.TextColor3 = theme.SubText
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.Parent = labelBg
    
    local bounds = label.TextBounds
    labelBg.Size = UDim2.new(0, bounds.X + 16, 1, 0)
    label.Size = UDim2.new(1, 0, 1, 0)

    RegisterElement({Type = "section", Card = frame, Label = label, SearchText = titleText, Page = page})
end
TabObj.CreateSection = TabObj.makeSection
TabObj.AddSection = TabObj.makeSection

return TabObj


end

-- STREAMING_CHUNK:Building Loading Screen & Key System Verification Engine...
local function CreateKeyWindow(cfg, onVerified)
local theme = GaphopUI.Themes[GaphopUI.CurrentTheme]

local keyOverlay = Instance.new("Frame")
keyOverlay.Size = UDim2.fromScale(1, 1)
keyOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
keyOverlay.BackgroundTransparency = 1
keyOverlay.ZIndex = 999999
keyOverlay.Parent = ScreenGui

Tween(keyOverlay, TweenInfo.new(0.3), {BackgroundTransparency = 0.4})

local keyWindow = Instance.new("Frame")
keyWindow.Size = UDim2.new(0, 420, 0, 260)
keyWindow.AnchorPoint = Vector2.new(0.5, 0.5)
keyWindow.Position = UDim2.fromScale(0.5, 0.45)
keyWindow.BackgroundColor3 = theme.Background
keyWindow.BackgroundTransparency = 0.05
keyWindow.ClipsDescendants = true
keyWindow.Parent = keyOverlay

CreateCorner(keyWindow, 14)
local mainStroke = CreateStroke(keyWindow, theme.Border, 1, 0.3)
MakeDraggable(keyWindow, keyWindow)

if GaphopUI.RGBEnabled then
    local rgbConn = RunService.RenderStepped:Connect(function()
        mainStroke.Color = GaphopUI.CurrentRGBColor
    end)
    keyWindow.Destroying:Connect(function() rgbConn:Disconnect() end)
end

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 50)
topBar.BackgroundColor3 = theme.Header
topBar.BorderSizePixel = 0
topBar.Parent = keyWindow

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -70, 1, 0)
titleLabel.Position = UDim2.new(0, 20, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = cfg.Name or "GaphopUI Key System"
titleLabel.TextColor3 = theme.Text
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, 0, 0, 1)
divider.Position = UDim2.new(0, 0, 1, -1)
divider.BackgroundColor3 = theme.Border
divider.BorderSizePixel = 0
divider.Parent = topBar

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -40, 1, -70)
contentArea.Position = UDim2.new(0, 20, 0, 60)
contentArea.BackgroundTransparency = 1
contentArea.Parent = keyWindow

local descLabel = Instance.new("TextLabel")
descLabel.Size = UDim2.new(1, 0, 0, 40)
descLabel.BackgroundTransparency = 1
descLabel.Text = cfg.description or "Please enter your key to continue."
descLabel.TextColor3 = theme.SubText
descLabel.TextSize = 13
descLabel.Font = Enum.Font.Gotham
descLabel.TextWrapped = true
descLabel.TextXAlignment = Enum.TextXAlignment.Center
descLabel.Parent = contentArea

local inputCard = Instance.new("Frame")
inputCard.Size = UDim2.new(1, 0, 0, 46)
inputCard.Position = UDim2.new(0, 0, 0, 50)
inputCard.BackgroundColor3 = theme.InputBackground
inputCard.Parent = contentArea
CreateCorner(inputCard, 8)
CreateStroke(inputCard, theme.Border, 1, 0.5)

local keyIcon = GaphopUI:CreateIcon(inputCard, "key", UDim2.fromOffset(20, 20), theme.SubText, {Position = UDim2.new(0, 12, 0.5, -10)})

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(1, -44, 1, 0)
keyInput.Position = UDim2.new(0, 44, 0, 0)
keyInput.BackgroundTransparency = 1
keyInput.Text = ""
keyInput.PlaceholderText = "Enter Key Here..."
keyInput.TextColor3 = theme.Text
keyInput.PlaceholderColor3 = theme.SubText
keyInput.TextSize = 14
keyInput.Font = Enum.Font.Gotham
keyInput.TextXAlignment = Enum.TextXAlignment.Left
keyInput.Parent = inputCard

local btnContainer = Instance.new("Frame")
btnContainer.Size = UDim2.new(1, 0, 0, 42)
btnContainer.Position = UDim2.new(0, 0, 0, 115)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = contentArea

local btnLayout = Instance.new("UIListLayout")
btnLayout.FillDirection = Enum.FillDirection.Horizontal
btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
btnLayout.SortOrder = Enum.SortOrder.LayoutOrder
btnLayout.Padding = UDim.new(0, 15)
btnLayout.Parent = btnContainer

local verifyBtn = Instance.new("TextButton")
verifyBtn.Size = UDim2.new(0.45, 0, 1, 0)
verifyBtn.BackgroundColor3 = theme.Accent
verifyBtn.Text = "Verify Key"
verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
verifyBtn.TextSize = 14
verifyBtn.Font = Enum.Font.GothamBold
verifyBtn.Parent = btnContainer
CreateCorner(verifyBtn, 8)

local getBtn
if cfg.grabkeyformsite and cfg.link and cfg.link ~= "" then
    getBtn = Instance.new("TextButton")
    getBtn.Size = UDim2.new(0.45, 0, 1, 0)
    getBtn.BackgroundColor3 = theme.Card
    getBtn.Text = "Get Key"
    getBtn.TextColor3 = theme.Text
    getBtn.TextSize = 14
    getBtn.Font = Enum.Font.GothamMedium
    getBtn.Parent = btnContainer
    CreateCorner(getBtn, 8)
    CreateStroke(getBtn, theme.Border, 1, 0.4)
    
    getBtn.MouseButton1Click:Connect(function(input)
        CreateRipple(getBtn, input)
        local clipOk = pcall(function() setclipboard(cfg.link) end)
        if clipOk then
            GaphopUI:Notify({Title = "Success", Content = "Link copied to clipboard!", Duration = 3})
            getBtn.Text = "Copied!"
            task.delay(2, function() if getBtn then getBtn.Text = "Get Key" end end)
        else
            GaphopUI:Notify({Title = "Link", Content = cfg.link, Duration = 10})
        end
    end)
else
    verifyBtn.Size = UDim2.new(0.8, 0, 1, 0)
end

local verifying = false

local function CheckOnlineKey(enteredKey, url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        return false, "Failed to connect to key server."
    end
    
    local cleanResult = string.gsub(result, "^%s*(.-)%s*$", "%1")
    
    if cleanResult == enteredKey then
        return true
    end
    
    local jsonSuccess, decoded = pcall(function()
        return HttpService:JSONDecode(result)
    end)
    
    if jsonSuccess and type(decoded) == "table" then
        for k, v in pairs(decoded) do
            if tostring(v) == enteredKey then
                return true
            end
        end
    end
    
    return false, "Invalid Key!"
end

local function ProcessVerification()
    if verifying then return end
    verifying = true
    verifyBtn.Text = "Checking..."
    
    local enteredKey = keyInput.Text
    local isValid = false
    local errorMsg = "Invalid Key!"
    
    if enteredKey == "" then
        errorMsg = "Please enter a key."
    elseif not cfg.grabkeyformsite then
        if enteredKey == cfg.pass then
            isValid = true
        end
    else
        if cfg.pass and cfg.pass ~= "" and cfg.pass ~= "nokey" and enteredKey == cfg.pass then
            isValid = true
        else
            isValid, errorMsg = CheckOnlineKey(enteredKey, cfg.link)
        end
    end
    
    if isValid then
        verifyBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 100)
        verifyBtn.Text = "Verified!"
        
        SpringTween(keyWindow, 0.3, {Position = UDim2.fromScale(0.5, 0.4), BackgroundTransparency = 1}, Enum.EasingStyle.Quart)
        Tween(keyOverlay, TweenInfo.new(0.3), {BackgroundTransparency = 1}).Completed:Connect(function()
            keyOverlay:Destroy()
            onVerified()
        end)
    else
        verifyBtn.Text = "Verify Key"
        GaphopUI:Notify({Title = "Error", Content = errorMsg, Duration = 3})
        
        local origPos = keyWindow.Position
        local shakeTween = TweenService:Create(keyWindow, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 4, true), {
            Position = UDim2.new(origPos.X.Scale, origPos.X.Offset + 10, origPos.Y.Scale, origPos.Y.Offset)
        })
        shakeTween:Play()
    end
    
    verifying = false
end

verifyBtn.MouseButton1Click:Connect(function(input)
    CreateRipple(verifyBtn, input)
    ProcessVerification()
end)

keyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        ProcessVerification()
    end
end)

SpringTween(keyWindow, 0.4, {Position = UDim2.fromScale(0.5, 0.5)}, Enum.EasingStyle.Back)


end

function GaphopUI:CreateWindow(cfg)
cfg = cfg or {}
local windowName = cfg.Name or "GaphopUI"
local showText = cfg.ShowText or "V2"
local loadingTitle = cfg.LoadingTitle or "GaphopUI Engine"
local loadingSubtitle = cfg.LoadingSubtitle or "Loading UI..."
local startTheme = cfg.Theme or "Dark"

-- Key system configs
local useKey = cfg.key == true
local grabKey = cfg.grabkeyformsite == true
local keyDesc = cfg.description or "Please enter your key."
local keyLink = cfg.link or ""
local keyPass = cfg.pass or ""

if GaphopUI.Themes[startTheme] then GaphopUI.CurrentTheme = startTheme end
local theme = GaphopUI.Themes[GaphopUI.CurrentTheme]

local overlay = Instance.new("Frame")
overlay.Size = UDim2.fromScale(1, 1)
overlay.BackgroundColor3 = theme.Background
overlay.ZIndex = 9999999
overlay.Parent = ScreenGui

local loadText = Instance.new("TextLabel")
loadText.Size = UDim2.new(1, 0, 0, 40)
loadText.Position = UDim2.fromScale(0, 0.4)
loadText.BackgroundTransparency = 1
loadText.Text = loadingTitle
loadText.TextColor3 = theme.Text
loadText.Font = Enum.Font.GothamBold
loadText.TextSize = 28
loadText.Parent = overlay

local subLoad = Instance.new("TextLabel")
subLoad.Size = UDim2.new(1, 0, 0, 30)
subLoad.Position = UDim2.fromScale(0, 0.48)
subLoad.BackgroundTransparency = 1
subLoad.Text = loadingSubtitle
subLoad.TextColor3 = theme.Accent
subLoad.Font = Enum.Font.Gotham
subLoad.TextSize = 16
subLoad.Parent = overlay

local spinner = Instance.new("ImageLabel")
spinner.Size = UDim2.fromOffset(40, 40)
spinner.Position = UDim2.fromScale(0.5, 0.6)
spinner.AnchorPoint = Vector2.new(0.5, 0.5)
spinner.BackgroundTransparency = 1
local resolvedSpinner = ResolveIconValue("loader2", nil)
if type(resolvedSpinner) == "table" then
    spinner.Image = "rbxassetid://" .. tostring(resolvedSpinner[1])
    spinner.ImageRectSize = Vector2.new(resolvedSpinner[2][1], resolvedSpinner[2][2])
    spinner.ImageRectOffset = Vector2.new(resolvedSpinner[3][1], resolvedSpinner[3][2])
else
    spinner.Image = "rbxassetid://16898613509" -- fallback
end
spinner.ImageColor3 = theme.Text
spinner.Parent = overlay

local spinTween = TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
Tween(spinner, spinTween, {Rotation = 360})

local MainUIBuilder = {}

local function ContinueLoadMainUI()
    Tween(overlay, TweenInfo.new(0.6, Enum.EasingStyle.Quart), {BackgroundTransparency = 1})
    Tween(loadText, TweenInfo.new(0.4), {TextTransparency = 1})
    Tween(subLoad, TweenInfo.new(0.4), {TextTransparency = 1})
    Tween(spinner, TweenInfo.new(0.4), {ImageTransparency = 1}).Completed:Connect(function()
        overlay:Destroy()
    end)

    local MainWindow = Instance.new("Frame")
    MainWindow.Name = "MainWindow"
    MainWindow.Size = UDim2.new(0, 680, 0, 440)
    MainWindow.AnchorPoint = Vector2.new(0.5, 0.5)
    MainWindow.Position = UDim2.fromScale(0.5, 0.5)
    MainWindow.BackgroundColor3 = theme.Background
    MainWindow.BackgroundTransparency = 0.05
    MainWindow.ClipsDescendants = true
    MainWindow.Parent = ScreenGui

    MainWindow:SetAttribute("NormalSize", UDim2.new(0, 680, 0, 440))
    CreateCorner(MainWindow, 14)
    local mainStroke = CreateStroke(MainWindow, theme.Border, 1.2, 0.3)
    MakeDraggable(MainWindow, MainWindow)

    GaphopUI.WindowInstance = MainWindow

    if GaphopUI.RGBEnabled then
        local rgbConn = RunService.RenderStepped:Connect(function()
            mainStroke.Color = GaphopUI.CurrentRGBColor
        end)
        MainWindow.Destroying:Connect(function() rgbConn:Disconnect() end)
    end

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 52)
    TopBar.BackgroundColor3 = theme.Header
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainWindow

    local topDivider = Instance.new("Frame")
    topDivider.Size = UDim2.new(1, 0, 0, 1)
    topDivider.Position = UDim2.new(0, 0, 1, -1)
    topDivider.BackgroundColor3 = theme.Border
    topDivider.BorderSizePixel = 0
    topDivider.Parent = TopBar

    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(0, 200, 1, 0)
    TitleText.Position = UDim2.new(0, 24, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = windowName .. " | " .. showText
    TitleText.TextColor3 = theme.Text
    TitleText.TextSize = 16
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TopBar

    local Controls = Instance.new("Frame")
    Controls.Size = UDim2.new(0, 120, 1, 0)
    Controls.Position = UDim2.new(1, -130, 0, 0)
    Controls.BackgroundTransparency = 1
    Controls.Parent = TopBar

    local ctrlLayout = Instance.new("UIListLayout")
    ctrlLayout.FillDirection = Enum.FillDirection.Horizontal
    ctrlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ctrlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ctrlLayout.Padding = UDim.new(0, 12)
    ctrlLayout.Parent = Controls

    local function MakeControlBtn(iconId)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromOffset(26, 26)
        btn.BackgroundColor3 = theme.CardHover
        btn.BackgroundTransparency = 0.5
        btn.Text = ""
        CreateCorner(btn, 6)
        
        local icon = GaphopUI:CreateIcon(btn, iconId, UDim2.fromOffset(16, 16), theme.SubText, {Position = UDim2.new(0.5, -8, 0.5, -8)})
        
        btn.MouseEnter:Connect(function()
            SpringTween(btn, 0.2, {BackgroundTransparency = 0})
            if icon:IsA("ImageLabel") then SpringTween(icon, 0.2, {ImageColor3 = theme.Text}) else SpringTween(icon, 0.2, {TextColor3 = theme.Text}) end
        end)
        btn.MouseLeave:Connect(function()
            SpringTween(btn, 0.2, {BackgroundTransparency = 0.5})
            if icon:IsA("ImageLabel") then SpringTween(icon, 0.2, {ImageColor3 = theme.SubText}) else SpringTween(icon, 0.2, {TextColor3 = theme.SubText}) end
        end)
        return btn
    end

    local searchBtn = MakeControlBtn("search")
    searchBtn.Parent = Controls
    local minBtn = MakeControlBtn("minimize")
    minBtn.Parent = Controls
    local closeBtn = MakeControlBtn("close")
    closeBtn.Parent = Controls

    minBtn.MouseButton1Click:Connect(function(input)
        CreateRipple(minBtn, input)
        GaphopUI:ToggleUI(false)
    end)

    closeBtn.MouseButton1Click:Connect(function(input)
        CreateRipple(closeBtn, input)
        GaphopUI:CreatePrompt({
            Title = "Exit Module",
            Content = "Are you sure you want to unload GaphopUI?",
            OnConfirm = function()
                SpringTween(MainWindow, 0.35, {Size = UDim2.new(0, 680, 0, 0), BackgroundTransparency = 1}, Enum.EasingStyle.Quart).Completed:Connect(function()
                    ScreenGui:Destroy()
                end)
            end
        })
    end)

    local SideBar = Instance.new("Frame")
    SideBar.Name = "SideBar"
    SideBar.Size = UDim2.new(0, 160, 1, -52)
    SideBar.Position = UDim2.new(0, 0, 0, 52)
    SideBar.BackgroundColor3 = theme.Card
    SideBar.BackgroundTransparency = 0.2
    SideBar.BorderSizePixel = 0
    SideBar.Parent = MainWindow

    local sideDivider = Instance.new("Frame")
    sideDivider.Size = UDim2.new(0, 1, 1, 0)
    sideDivider.Position = UDim2.new(1, -1, 0, 0)
    sideDivider.BackgroundColor3 = theme.Border
    sideDivider.BorderSizePixel = 0
    sideDivider.Parent = SideBar

    local TabList = Instance.new("ScrollingFrame")
    TabList.Size = UDim2.new(1, 0, 1, -20)
    TabList.Position = UDim2.new(0, 0, 0, 10)
    TabList.BackgroundTransparency = 1
    TabList.ScrollBarThickness = 2
    TabList.ScrollBarImageColor3 = theme.Border
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.Parent = SideBar

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 6)
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabListLayout.Parent = TabList

    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabList.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 20)
    end)

    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -160, 1, -52)
    ContentArea.Position = UDim2.new(0, 160, 0, 52)
    ContentArea.BackgroundTransparency = 1
    ContentArea.ClipsDescendants = true
    ContentArea.Parent = MainWindow

    local SearchContainer = Instance.new("Frame")
    SearchContainer.Size = UDim2.new(1, -40, 0, 42)
    SearchContainer.Position = UDim2.new(0, 20, 0, -50)
    SearchContainer.BackgroundColor3 = theme.InputBackground
    SearchContainer.ZIndex = 50
    SearchContainer.Parent = ContentArea
    CreateCorner(SearchContainer, 8)
    local searchStroke = CreateStroke(SearchContainer, theme.Border, 1, 0.4)
    
    local searchIcon = GaphopUI:CreateIcon(SearchContainer, "search", UDim2.fromOffset(20, 20), theme.SubText, {Position = UDim2.new(0, 12, 0.5, -10)})

    local SearchInput = Instance.new("TextBox")
    SearchInput.Size = UDim2.new(1, -50, 1, 0)
    SearchInput.Position = UDim2.new(0, 44, 0, 0)
    SearchInput.BackgroundTransparency = 1
    SearchInput.Text = ""
    SearchInput.PlaceholderText = "Search features..."
    SearchInput.TextColor3 = theme.Text
    SearchInput.PlaceholderColor3 = theme.SubText
    SearchInput.TextSize = 13
    SearchInput.Font = Enum.Font.Gotham
    SearchInput.TextXAlignment = Enum.TextXAlignment.Left
    SearchInput.Parent = SearchContainer

    local searchOpen = false
    searchBtn.MouseButton1Click:Connect(function(input)
        CreateRipple(searchBtn, input)
        searchOpen = not searchOpen
        if searchOpen then
            SpringTween(SearchContainer, 0.3, {Position = UDim2.new(0, 20, 0, 12)}, Enum.EasingStyle.Back)
            SearchInput:CaptureFocus()
        else
            SpringTween(SearchContainer, 0.25, {Position = UDim2.new(0, 20, 0, -50)}, Enum.EasingStyle.Quart)
            SearchInput.Text = ""
            GaphopUI:FilterElements("")
        end
    end)

    SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
        GaphopUI:FilterElements(SearchInput.Text)
    end)

    SearchInput.Focused:Connect(function() SpringTween(searchStroke, 0.2, {Color = theme.Accent, Transparency = 0.2}) end)
    SearchInput.FocusLost:Connect(function() SpringTween(searchStroke, 0.2, {Color = theme.Border, Transparency = 0.4}) end)

    local currentTab = nil
    local FirstTab = nil

    function MainUIBuilder:makeTab(cfg)
        cfg = cfg or {}
        local tabName = cfg.Name or "Tab"
        local iconId = cfg.Icon

        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, -20, 0, 36)
        tabBtn.BackgroundColor3 = theme.Accent
        tabBtn.BackgroundTransparency = 1
        tabBtn.Text = ""
        tabBtn.Parent = TabList
        CreateCorner(tabBtn, 8)

        local iconElement = nil
        local textOffset = 16
        if iconId then
            textOffset = 42
            iconElement = GaphopUI:CreateIcon(tabBtn, iconId, UDim2.fromOffset(18, 18), theme.SubText, {Position = UDim2.new(0, 12, 0.5, -9)})
        end

        local tabLabel = Instance.new("TextLabel")
        tabLabel.Size = UDim2.new(1, -textOffset, 1, 0)
        tabLabel.Position = UDim2.new(0, textOffset, 0, 0)
        tabLabel.BackgroundTransparency = 1
        tabLabel.Text = tabName
        tabLabel.TextColor3 = theme.SubText
        tabLabel.TextSize = 13
        tabLabel.Font = Enum.Font.GothamMedium
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabLabel.Parent = tabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Name = tabName .. "_Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = theme.Border
        Page.Visible = false
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.Parent = ContentArea

        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 16)
        padding.PaddingLeft = UDim.new(0, 20)
        padding.PaddingRight = UDim.new(0, 20)
        padding.PaddingBottom = UDim.new(0, 20)
        padding.Parent = Page

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 10)
        PageLayout.Parent = Page

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 40)
        end)

        if not FirstTab then
            FirstTab = {Btn = tabBtn, Page = Page, Icon = iconElement, Label = tabLabel}
        end

        tabBtn.MouseButton1Click:Connect(function(input)
            CreateRipple(tabBtn, input)
            if currentTab == Page then return end
            
            if currentTab then
                currentTab.Visible = false
            end
            
            for _, child in ipairs(TabList:GetChildren()) do
                if child:IsA("TextButton") then
                    SpringTween(child, 0.2, {BackgroundTransparency = 1})
                    local tLbl = child:FindFirstChildOfClass("TextLabel")
                    if tLbl then SpringTween(tLbl, 0.2, {TextColor3 = theme.SubText, Font = Enum.Font.GothamMedium}) end
                    
                    local img = child:FindFirstChildOfClass("ImageLabel")
                    if img then SpringTween(img, 0.2, {ImageColor3 = theme.SubText}) end
                    
                    local tIco = child:FindFirstChildOfClass("TextLabel")
                    if tIco and tIco ~= tLbl then SpringTween(tIco, 0.2, {TextColor3 = theme.SubText}) end
                end
            end

            currentTab = Page
            Page.Visible = true
            Page.Position = UDim2.new(0, 0, 0, 20)
            Page.GroupTransparency = 1
            SpringTween(Page, 0.35, {Position = UDim2.new(0, 0, 0, 0), GroupTransparency = 0}, Enum.EasingStyle.Quart)

            SpringTween(tabBtn, 0.25, {BackgroundTransparency = 0.85})
            SpringTween(tabLabel, 0.2, {TextColor3 = theme.Accent, Font = Enum.Font.GothamBold})
            
            if iconElement then
                if iconElement:IsA("ImageLabel") then SpringTween(iconElement, 0.2, {ImageColor3 = theme.Accent}) else SpringTween(iconElement, 0.2, {TextColor3 = theme.Accent}) end
            end
        end)

        local TabObj = {}
        BindElementMethods(TabObj, Page, theme)
        return TabObj
    end
    MainUIBuilder.CreateTab = MainUIBuilder.makeTab

    task.delay(0.1, function()
        if FirstTab then
            for _, child in ipairs(TabList:GetChildren()) do
                if child:IsA("TextButton") then child.BackgroundTransparency = 1 end
            end
            currentTab = FirstTab.Page
            FirstTab.Page.Visible = true
            FirstTab.Btn.BackgroundTransparency = 0.85
            FirstTab.Label.TextColor3 = theme.Accent
            FirstTab.Label.Font = Enum.Font.GothamBold
            if FirstTab.Icon then
                 if FirstTab.Icon:IsA("ImageLabel") then FirstTab.Icon.ImageColor3 = theme.Accent else FirstTab.Icon.TextColor3 = theme.Accent end
            end
        end
    end)
end

if useKey then
    task.delay(1, function()
        Tween(spinner, TweenInfo.new(0.4), {ImageTransparency = 1})
        Tween(loadText, TweenInfo.new(0.4), {TextTransparency = 1})
        Tween(subLoad, TweenInfo.new(0.4), {TextTransparency = 1}).Completed:Connect(function()
            overlay.BackgroundTransparency = 1
            CreateKeyWindow(cfg, ContinueLoadMainUI)
        end)
    end)
else
    task.delay(1.5, ContinueLoadMainUI)
end

return MainUIBuilder


end

-- STREAMING_CHUNK:Finalizing GaphopUI Library Environment Output...
GaphopUI.Init = function()
print("GaphopUI " .. GaphopUI.Version .. " Initialized Successfully.")
end

getgenv().GaphopUI = GaphopUI
return GaphopUI
