-- STREAMING_CHUNK:Initializing Core Roblox Services and Global Tables...
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

warn("This UI may have bugs. Please report any issues you find.")

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
        chevron = "‌",
        shield = "🛡",
        zap = "⚡",
        star = "★"
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
    squareuserround = {16898613777, {48, 48}, {355, 0}}
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

```lua
-- STREAMING_CHUNK: Constructing Animated Warning Notification Stack System...

local WarnNotifyContainer = Instance.new("Frame")
WarnNotifyContainer.Name = "WarnNotifyContainer"
WarnNotifyContainer.Size = UDim2.new(0, 320, 1, -40)
WarnNotifyContainer.Position = UDim2.new(1, -330, 0, 20)
WarnNotifyContainer.BackgroundTransparency = 1
WarnNotifyContainer.ZIndex = 1000
WarnNotifyContainer.Parent = ScreenGui

local WarnNotifyLayout = Instance.new("UIListLayout")
WarnNotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
WarnNotifyLayout.Padding = UDim.new(0, 10)
WarnNotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
WarnNotifyLayout.Parent = WarnNotifyContainer

GaphopUI.WarnNotifyContainer = WarnNotifyContainer

function GaphopUI:WarnNotify(cfg)
	cfg = cfg or {}

	local titleText = cfg.Title or "Warning"
	local contentText = cfg.Content or ""
	local duration = cfg.Duration or 4
	local imgId = cfg.Image
	local theme = GaphopUI.Themes[GaphopUI.CurrentTheme]

	-- Warning colors
	local warnAccent = cfg.Color or Color3.fromRGB(255, 180, 0)
	local warnText = Color3.fromRGB(255, 220, 130)

	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, 72)
	card.BackgroundColor3 = theme.Card
	card.BackgroundTransparency = 0.12
	card.Position = UDim2.new(1, 360, 0, 0)
	card.ClipsDescendants = true
	card.Parent = WarnNotifyContainer

	CreateCorner(card, 12)

	local stroke = CreateStroke(
		card,
		warnAccent,
		1.5,
		0.25
	)

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 16)
	padding.PaddingRight = UDim.new(0, 12)
	padding.PaddingTop = UDim.new(0, 10)
	padding.PaddingBottom = UDim.new(0, 10)
	padding.Parent = card

	local iconOffset = 42

	-- Warning icon
	local iconImg = Instance.new("ImageLabel")
	iconImg.Size = UDim2.new(0, 34, 0, 34)
	iconImg.Position = UDim2.new(0, 0, 0.5, -17)
	iconImg.BackgroundTransparency = 1

	if imgId then
		local resolvedNotify = ResolveIconValue(imgId, nil)

		if type(resolvedNotify) == "table" then
			iconImg.Image = "rbxassetid://" .. tostring(resolvedNotify[1])
			iconImg.ImageRectSize = Vector2.new(
				resolvedNotify[2][1],
				resolvedNotify[2][2]
			)
			iconImg.ImageRectOffset = Vector2.new(
				resolvedNotify[3][1],
				resolvedNotify[3][2]
			)
			iconImg.ImageColor3 = warnAccent
		else
			iconImg.Image =
				(type(resolvedNotify) == "number"
				and "rbxassetid://" .. tostring(resolvedNotify))
				or tostring(resolvedNotify)

			iconImg.ImageColor3 = warnAccent
		end
	else
		-- Default warning symbol
		iconImg.Image = ""
		iconImg.BackgroundTransparency = 1

		local warningText = Instance.new("TextLabel")
		warningText.Size = UDim2.new(1, 0, 1, 0)
		warningText.BackgroundTransparency = 1
		warningText.Text = "⚠"
		warningText.TextColor3 = warnAccent
		warningText.TextSize = 28
		warningText.Font = Enum.Font.GothamBold
		warningText.TextXAlignment = Enum.TextXAlignment.Center
		warningText.TextYAlignment = Enum.TextYAlignment.Center
		warningText.Parent = iconImg
	end

	iconImg.Parent = card
	CreateCorner(iconImg, 8)

	-- Warning title
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -iconOffset, 0, 20)
	title.Position = UDim2.new(0, iconOffset, 0, 2)
	title.BackgroundTransparency = 1
	title.Text = titleText
	title.TextColor3 = warnText
	title.TextSize = 14
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = card

	-- Warning content
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

	-- Slide in
	SpringTween(
		card,
		0.45,
		{
			Position = UDim2.new(0, 0, 0, 0)
		},
		Enum.EasingStyle.Back
	)

	-- Warning timer bar
	local timerBar = Instance.new("Frame")
	timerBar.Size = UDim2.new(1, 0, 0, 3)
	timerBar.Position = UDim2.new(0, 0, 1, -3)
	timerBar.BackgroundColor3 = warnAccent
	timerBar.BorderSizePixel = 0
	timerBar.Parent = card

	Tween(
		timerBar,
		TweenInfo.new(duration, Enum.EasingStyle.Linear),
		{
			Size = UDim2.new(0, 0, 0, 3)
		}
	)

	-- Slide out
	task.delay(duration, function()
		if card and card.Parent then
			local exitTween = SpringTween(
				card,
				0.35,
				{
					Position = UDim2.new(1, 360, 0, 0),
					BackgroundTransparency = 1
				},
				Enum.EasingStyle.Quart
			)

			if exitTween then
				exitTween.Completed:Connect(function()
					if card then
						card:Destroy()
					end
				end)
			else
				card:Destroy()
			end
		end
	end)
end
```


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
        dropBtn.MouseButton1Click:Connect(function(input)
            CreateRipple(dropBtn, input)
            isOpen = not isOpen
            SpringTween(card, 0.35, {
                Size = UDim2.new(1, -6, 0, isOpen and (48 + #options * 28) or 42)
            }, Enum.EasingStyle.Quart)
        end)

        for i, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, -24, 0, 24)
            optBtn.Position = UDim2.new(0, 12, 0, 42 + (i - 1) * 28)
            optBtn.BackgroundColor3 = theme.InputBackground
            optBtn.Text = tostring(opt)
            optBtn.TextColor3 = theme.SubText
            optBtn.TextSize = 12
            optBtn.Font = Enum.Font.Gotham
            optBtn.Parent = card
            CreateCorner(optBtn, 4)

            optBtn.MouseEnter:Connect(function()
                SpringTween(optBtn, 0.15, {TextColor3 = theme.Text, BackgroundColor3 = theme.CardHover})
            end)
            optBtn.MouseLeave:Connect(function()
                SpringTween(optBtn, 0.15, {TextColor3 = theme.SubText, BackgroundColor3 = theme.InputBackground})
            end)
            optBtn.MouseButton1Click:Connect(function(input)
                CreateRipple(optBtn, input)
                current = opt
                dropBtn.Text = tostring(current) .. "   " .. GaphopUI.Icons.chevron
                isOpen = false
                SpringTween(card, 0.3, {Size = UDim2.new(1, -6, 0, 42)})
                if flag then GaphopUI.Flags[flag] = current end
                callback(current)
            end)
        end

        RegisterElement({Type = "dropdown", Card = card, Stroke = stroke, Label = label, DropdownButton = dropBtn, SearchText = name, Page = page})
    end
    TabObj.CreateDropdown = TabObj.makeDropdown
    TabObj.AddDropdown = TabObj.makeDropdown

    function TabObj:makeKeybind(cfg)
        cfg = cfg or {}
        local name = cfg.Name or "Keybind"
        local currentKey = cfg.CurrentKeybind or Enum.KeyCode.E
        local flag = cfg.Flag
        local callback = cfg.Callback or function() end

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -6, 0, 42)
        card.BackgroundColor3 = theme.Card
        card.BackgroundTransparency = 0.3
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
        bindBtn.Size = UDim2.new(0, 84, 0, 26)
        bindBtn.Position = UDim2.new(1, -96, 0.5, -13)
        bindBtn.BackgroundColor3 = theme.InputBackground
        bindBtn.Text = currentKey.Name
        bindBtn.TextColor3 = theme.Text
        bindBtn.TextSize = 12
        bindBtn.Font = Enum.Font.GothamBold
        bindBtn.Parent = card
        CreateCorner(bindBtn, 6)

        local isBinding = false
        bindBtn.MouseButton1Click:Connect(function()
            isBinding = true
            bindBtn.Text = "..."
            SpringTween(bindBtn, 0.2, {BackgroundColor3 = theme.Accent})
        end)

        UserInputService.InputBegan:Connect(function(input)
            if isBinding and input.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = input.KeyCode
                bindBtn.Text = currentKey.Name
                isBinding = false
                SpringTween(bindBtn, 0.2, {BackgroundColor3 = theme.InputBackground})
                if flag then GaphopUI.Flags[flag] = currentKey end
                callback(currentKey)
            end
        end)

        RegisterElement({Type = "keybind", Card = card, Stroke = stroke, Label = label, BindButton = bindBtn, SearchText = name, Page = page})
    end
    TabObj.CreateKeybind = TabObj.makeKeybind
    TabObj.AddKeybind = TabObj.makeKeybind

    function TabObj:makeColorPicker(cfg)
        cfg = cfg or {}
        local name = cfg.Name or "Color Picker"
        local currentColor = cfg.Color or Color3.fromRGB(255, 255, 255)
        local flag = cfg.Flag
        local callback = cfg.Callback or function() end

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -6, 0, 42)
        card.BackgroundColor3 = theme.Card
        card.BackgroundTransparency = 0.3
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

        local colorDisplay = Instance.new("Frame")
        colorDisplay.Size = UDim2.new(0, 24, 0, 24)
        colorDisplay.Position = UDim2.new(1, -36, 0.5, -12)
        colorDisplay.BackgroundColor3 = currentColor
        colorDisplay.Parent = card
        CreateCorner(colorDisplay, 6)

        local hexInput = Instance.new("TextBox")
        hexInput.Size = UDim2.new(0, 80, 0, 24)
        hexInput.Position = UDim2.new(1, -124, 0.5, -12)
        hexInput.BackgroundColor3 = theme.InputBackground
        hexInput.Text = Color3ToHex(currentColor)
        hexInput.TextColor3 = theme.Text
        hexInput.TextSize = 12
        hexInput.Font = Enum.Font.Gotham
        hexInput.Parent = card
        CreateCorner(hexInput, 6)

        hexInput.FocusLost:Connect(function()
            local success, newColor = pcall(function() return HexToColor3(hexInput.Text) end)
            if success and newColor then
                currentColor = newColor
                colorDisplay.BackgroundColor3 = currentColor
                if flag then GaphopUI.Flags[flag] = currentColor end
                callback(currentColor)
            end
            hexInput.Text = Color3ToHex(currentColor)
        end)

            RegisterElement({Type = "colorpicker", Card = card, Stroke = stroke, Label = label, Input = hexInput, ColorDisplay = colorDisplay, ColorValue = currentColor, SearchText = name, Page = page})
    end
    TabObj.CreateLabel = TabObj.makeLabel
TabObj.AddLabel = TabObj.makeLabel

function TabObj:makeLabel(cfg)
    cfg = cfg or {}

    local title = cfg.Name or "Label"
    local description = cfg.Label or cfg.Description or ""

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, description ~= "" and 56 or 42)
    card.BackgroundColor3 = theme.Card
    card.BackgroundTransparency = 0.3
    card.Parent = page

    local stroke = CreateStroke(card, theme.Border, 1, 0.6)
    CreateCorner(card, 8)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 12, 0, description ~= "" and 5 or 0)
    titleLabel.Size = UDim2.new(1, -24, 0, description ~= "" and 20 or 42)
    titleLabel.Font = Enum.Font.Gotham
    titleLabel.Text = title
    titleLabel.TextColor3 = theme.Text
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextYAlignment = description ~= "" and Enum.TextYAlignment.Bottom or Enum.TextYAlignment.Center
    titleLabel.Parent = card

    local descLabel

    if description ~= "" then
        descLabel = Instance.new("TextLabel")
        descLabel.BackgroundTransparency = 1
        descLabel.Position = UDim2.new(0, 12, 0, 27)
        descLabel.Size = UDim2.new(1, -24, 0, 15)
        descLabel.Font = Enum.Font.Gotham
        descLabel.Text = description
        descLabel.TextColor3 = theme.SubText or Color3.fromRGB(170, 170, 170)
        descLabel.TextSize = 11
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.TextYAlignment = Enum.TextYAlignment.Top
        descLabel.Parent = card
    end

    RegisterElement({
        Type = "label",
        Card = card,
        Stroke = stroke,
        Label = titleLabel,
        Description = descLabel,
        SearchText = title,
        Page = page
    })

    local LabelObj = {}

    function LabelObj:Set(text)
        titleLabel.Text = text
    end

    function LabelObj:SetDescription(text)
        description = text or ""

        if description == "" then
            if descLabel then
                descLabel:Destroy()
                descLabel = nil
            end

            card.Size = UDim2.new(1, -6, 0, 42)
            titleLabel.Position = UDim2.new(0, 12, 0, 0)
            titleLabel.Size = UDim2.new(1, -24, 1, 0)
            titleLabel.TextYAlignment = Enum.TextYAlignment.Center
        else
            if not descLabel then
                descLabel = Instance.new("TextLabel")
                descLabel.BackgroundTransparency = 1
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextColor3 = theme.SubText or Color3.fromRGB(170,170,170)
                descLabel.TextSize = 11
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.TextYAlignment = Enum.TextYAlignment.Top
                descLabel.Parent = card
            end

            card.Size = UDim2.new(1, -6, 0, 56)

            titleLabel.Position = UDim2.new(0, 12, 0, 5)
            titleLabel.Size = UDim2.new(1, -24, 0, 20)
            titleLabel.TextYAlignment = Enum.TextYAlignment.Bottom

            descLabel.Position = UDim2.new(0, 12, 0, 27)
            descLabel.Size = UDim2.new(1, -24, 0, 15)
            descLabel.Text = description
        end
    end

    return LabelObj
end
    TabObj.CreateColorPicker = TabObj.makeColorPicker
    TabObj.AddColorPicker = TabObj.makeColorPicker

    function TabObj:CreateSection(text)
        local secName = type(text) == "table" and (text.Name or text.Title) or tostring(text or "Section")
        local secLabel = Instance.new("TextLabel")
        secLabel.Size = UDim2.new(1, -6, 0, 26)
        secLabel.BackgroundTransparency = 1
        secLabel.Text = secName:upper()
        secLabel.TextColor3 = theme.Accent
        secLabel.TextSize = 11
        secLabel.Font = Enum.Font.GothamBold
        secLabel.TextXAlignment = Enum.TextXAlignment.Left
        secLabel.Parent = page
        RegisterElement({Type = "section", Card = secLabel, Label = secLabel, SearchText = secName, Page = page})
    end
    TabObj.makeSection = TabObj.CreateSection
    TabObj.AddSection = TabObj.CreateSection

    function TabObj:CreateParagraph(cfg)
        cfg = cfg or {}
        local titleText = cfg.Title or cfg.Name or "Paragraph"
        local contentText = cfg.Content or ""

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -6, 0, 60)
        card.BackgroundColor3 = theme.Card
        card.BackgroundTransparency = 0.4
        card.Parent = page

        local stroke = CreateStroke(card, theme.Border, 1, 0.6)
        CreateCorner(card, 8)

        local pTitle = Instance.new("TextLabel")
        pTitle.Size = UDim2.new(1, -20, 0, 22)
        pTitle.Position = UDim2.new(0, 10, 0, 6)
        pTitle.BackgroundTransparency = 1
        pTitle.Text = titleText
        pTitle.TextColor3 = theme.Text
        pTitle.TextSize = 13
        pTitle.Font = Enum.Font.GothamBold
        pTitle.TextXAlignment = Enum.TextXAlignment.Left
        pTitle.Parent = card

        local pContent = Instance.new("TextLabel")
        pContent.Size = UDim2.new(1, -20, 0, 28)
        pContent.Position = UDim2.new(0, 10, 0, 26)
        pContent.BackgroundTransparency = 1
        pContent.Text = contentText
        pContent.TextColor3 = theme.SubText
        pContent.TextSize = 11
        pContent.Font = Enum.Font.Gotham
        pContent.TextWrapped = true
        pContent.TextXAlignment = Enum.TextXAlignment.Left
        pContent.Parent = card

        RegisterElement({Type = "paragraph", Card = card, Stroke = stroke, Label = pTitle, SubLabel = pContent, SearchText = titleText .. " " .. contentText, Page = page})
    end
    TabObj.makeParagraph = TabObj.CreateParagraph
    TabObj.AddParagraph = TabObj.CreateParagraph

    return TabObj
end

-- STREAMING_CHUNK:Building Animated Loading Splash Screen Engine...
local function CreateLoadingScreen(titleText, subtitleText, callback)
    local theme = GaphopUI.Themes[GaphopUI.CurrentTheme]

    local splash = Instance.new("Frame")
    splash.Name = "GaphopLoadingSplash"
    splash.Size = UDim2.new(0, 380, 0, 190)
    splash.Position = UDim2.new(0.5, -190, 0.5, -95)
    splash.BackgroundColor3 = theme.Background
    splash.BackgroundTransparency = 0.05
    splash.ClipsDescendants = true
    splash.ZIndex = 100
    splash.Parent = ScreenGui

    CreateCorner(splash, 16)
    CreateStroke(splash, theme.Accent, 1.5, 0.3)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 35)
    title.BackgroundTransparency = 1
    title.Text = titleText or "GaphopUI Engine"
    title.TextColor3 = theme.Text
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 101
    title.Parent = splash

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, 0, 0, 20)
    sub.Position = UDim2.new(0, 0, 0, 68)
    sub.BackgroundTransparency = 1
    sub.Text = subtitleText or "Loading modules..."
    sub.TextColor3 = theme.SubText
    sub.TextSize = 13
    sub.Font = Enum.Font.Gotham
    sub.ZIndex = 101
    sub.Parent = splash

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(0.75, 0, 0, 4)
    barBg.Position = UDim2.new(0.125, 0, 0, 125)
    barBg.BackgroundColor3 = theme.Card
    barBg.BorderSizePixel = 0
    barBg.ZIndex = 101
    barBg.Parent = splash
    CreateCorner(barBg, 2)

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = theme.Accent
    barFill.BorderSizePixel = 0
    barFill.ZIndex = 102
    barFill.Parent = barBg
    CreateCorner(barFill, 2)

    local fillTween = SpringTween(barFill, 0.8, {
        Size = UDim2.new(1, 0, 1, 0)
    }, Enum.EasingStyle.Quart)

    local cleanedUp = false
    local function FinishLoading()
        if cleanedUp then return end
        cleanedUp = true
        if splash and splash.Parent then
            SpringTween(splash, 0.3, {Size = UDim2.new(0, 400, 0, 0), BackgroundTransparency = 1}).Completed:Connect(function()
                splash:Destroy()
            end)
        end
        if callback then callback() end
    end

    if fillTween then
        fillTween.Completed:Connect(function()
            task.wait(0.1)
            FinishLoading()
        end)
    end
    task.delay(1.0, FinishLoading)
end

-- STREAMING_CHUNK:Constructing Main Window and Dynamic Sliding Tab Indicator...
function GaphopUI:makeWindow(cfg)
    cfg = cfg or {}
    GaphopUI.IsOpen = true

    if GaphopUI.WindowInstance then
        GaphopUI.WindowInstance.Visible = true
        GaphopUI.WindowInstance.BackgroundTransparency = 0.15
        return GaphopUI.WindowInstance
    end

    local winName = cfg.Name or "GaphopUI"
    local windowIcon = cfg.Icon or "sparkles"
    local showText = cfg.ShowText
    local noLoading = cfg.NoLoading or false
    local loadingTitle = cfg.LoadingTitle or "GaphopUI Engine"
    local loadingSub = cfg.LoadingSubtitle or "by Gaphop"

    local toggleKeyStr = cfg.ToggleUIKeybind or "K"
    if Enum.KeyCode[toggleKeyStr] then
        GaphopUI.ToggleKey = Enum.KeyCode[toggleKeyStr]
    else
        GaphopUI.ToggleKey = Enum.KeyCode.K
    end

    local theme = GaphopUI.Themes[GaphopUI.CurrentTheme] or GaphopUI.Themes.Dark

    local WindowObj = {}
    local WindowFrame = Instance.new("Frame")
    WindowFrame.Name = "MainWindow"
    WindowFrame.Size = UDim2.new(0, 680, 0, 440)
    WindowFrame.Position = UDim2.new(0.5, -340, 0.5, -220)
    WindowFrame.BackgroundColor3 = theme.Background
    WindowFrame.BackgroundTransparency = 0.15
    WindowFrame.ClipsDescendants = true
    WindowFrame.Visible = true
    WindowFrame.Parent = ScreenGui

    WindowFrame:SetAttribute("NormalSize", UDim2.new(0, 680, 0, 440))
    WindowFrame:SetAttribute("IsMaximized", false)
    CreateCorner(WindowFrame, 14)
    CreateStroke(WindowFrame, theme.Border, 1.2, 0.5)

    GaphopUI.WindowInstance = WindowFrame

    -- TopBar Header
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 48)
    TopBar.BackgroundColor3 = theme.Header
    TopBar.BackgroundTransparency = 0.3
    TopBar.Parent = WindowFrame
    CreateCorner(TopBar, 14)
    MakeDraggable(WindowFrame, TopBar)

    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(0, 220, 1, 0)
    titleText.Position = UDim2.new(0, 40, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = (showText and (winName .. " · " .. tostring(showText))) or winName
    titleText.TextColor3 = theme.Text
    titleText.TextSize = 15
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = TopBar

    if windowIcon ~= nil then
        GaphopUI:CreateIcon(TopBar, windowIcon, UDim2.new(0, 18, 0, 18), theme.Accent, {
            Theme = theme,
            Position = UDim2.new(0, 14, 0.5, -9),
            TextSize = 14
        })
    end

    local controls = Instance.new("Frame")
    controls.Size = UDim2.new(0, 140, 1, 0)
    controls.Position = UDim2.new(1, -145, 0, 0)
    controls.BackgroundTransparency = 1
    controls.Parent = TopBar

    local controlsLayout = Instance.new("UIListLayout")
    controlsLayout.FillDirection = Enum.FillDirection.Horizontal
    controlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    controlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    controlsLayout.Padding = UDim.new(0, 6)
    controlsLayout.Parent = controls

    local function CreateTopButton(iconData, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 30, 0, 30)
        btn.BackgroundColor3 = theme.Card
        btn.BackgroundTransparency = 0.6
        btn.Text = ""
        btn.Parent = controls
        CreateCorner(btn, 8)

        local icon = GaphopUI:CreateIcon(btn, iconData, UDim2.new(1, 0, 1, 0), theme.SubText, {
            Theme = theme,
            Position = UDim2.new(0, 0, 0, 0),
            TextSize = 13
        })

        btn.MouseEnter:Connect(function()
            SpringTween(btn, 0.2, {BackgroundColor3 = theme.CardHover, BackgroundTransparency = 0.2})
        end)
        btn.MouseLeave:Connect(function()
            SpringTween(btn, 0.2, {BackgroundColor3 = theme.Card, BackgroundTransparency = 0.6})
        end)
        btn.MouseButton1Click:Connect(function(input)
            CreateRipple(btn, input)
            callback()
        end)
        return btn
    end

    -- SideBar & Content Container
    local SideBar = Instance.new("Frame")
    SideBar.Name = "SideBar"
    SideBar.Size = UDim2.new(0, 160, 1, -58)
    SideBar.Position = UDim2.new(0, 10, 0, 52)
    SideBar.BackgroundColor3 = theme.Card
    SideBar.BackgroundTransparency = 0.5
    SideBar.Parent = WindowFrame
    CreateCorner(SideBar, 10)

    local tabList = Instance.new("ScrollingFrame")
    tabList.Size = UDim2.new(1, -12, 1, -12)
    tabList.Position = UDim2.new(0, 6, 0, 6)
    tabList.BackgroundTransparency = 1
    tabList.ScrollBarThickness = 2
    tabList.ScrollBarImageColor3 = theme.Border
    tabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabList.CanvasSize = UDim2.fromOffset(0, 0)
    tabList.Parent = SideBar

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = tabList

    -- Dynamic Sliding Tab Indicator Bar
    local TabIndicator = Instance.new("Frame")
    TabIndicator.Name = "TabIndicator"
    TabIndicator.Size = UDim2.new(1, 0, 0, 36)
    TabIndicator.BackgroundColor3 = theme.Accent
    TabIndicator.BackgroundTransparency = 0.8
    TabIndicator.ZIndex = 2
    TabIndicator.Visible = false
    TabIndicator.Parent = tabList
    CreateCorner(TabIndicator, 8)
    CreateStroke(TabIndicator, theme.Accent, 1, 0.5)

    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabList.CanvasSize = UDim2.fromOffset(0, tabLayout.AbsoluteContentSize.Y + 10)
    end)

    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -190, 1, -58)
    ContentArea.Position = UDim2.new(0, 180, 0, 52)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = WindowFrame

    local Tabs = {}

    -- Settings Tab Page
    local settingsPage = Instance.new("ScrollingFrame")
    settingsPage.Size = UDim2.new(1, -10, 1, -10)
    settingsPage.Position = UDim2.new(0, 5, 0, 5)
    settingsPage.BackgroundTransparency = 1
    settingsPage.Visible = false
    settingsPage.ScrollBarThickness = 3
    settingsPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
    settingsPage.CanvasSize = UDim2.fromOffset(0, 0)
    settingsPage.Parent = ContentArea

    local settingsLayout = Instance.new("UIListLayout")
    settingsLayout.Padding = UDim.new(0, 8)
    settingsLayout.Parent = settingsPage

    settingsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        settingsPage.CanvasSize = UDim2.fromOffset(0, settingsLayout.AbsoluteContentSize.Y + 10)
    end)

    local settingsBtn = CreateTopButton("settings", function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            SpringTween(t.Label, 0.2, {TextColor3 = theme.SubText})
        end
        TabIndicator.Visible = false
        settingsPage.Visible = true
    end)



    local maxBtn = CreateTopButton("maximize", function()
        local isMax = WindowFrame:GetAttribute("IsMaximized")
        local vpSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1200, 800)

        if not isMax then
            WindowFrame:SetAttribute("IsMaximized", true)
            local targetWidth = math.min(860, vpSize.X - 40)
            local targetHeight = math.min(560, vpSize.Y - 40)
            SpringTween(WindowFrame, 0.35, {
                Size = UDim2.new(0, targetWidth, 0, targetHeight),
                Position = UDim2.new(0.5, -targetWidth/2, 0.5, -targetHeight/2)
            }, Enum.EasingStyle.Quart)
        else
            WindowFrame:SetAttribute("IsMaximized", false)
            local norm = WindowFrame:GetAttribute("NormalSize") or UDim2.new(0, 680, 0, 440)
            SpringTween(WindowFrame, 0.35, {
                Size = norm,
                Position = UDim2.new(0.5, -norm.X.Offset/2, 0.5, -norm.Y.Offset/2)
            }, Enum.EasingStyle.Quart)
        end
    end)


    local closeBtn = CreateTopButton("close", function()
        GaphopUI:ToggleUI(false)
    end)

    -- Configure Built-In Settings Controls
    local SettingsEngine = BindElementMethods({}, settingsPage, theme)

    SettingsEngine:makeDropdown({
        Name = "UI Theme",
        Options = {"Dark", "Midnight", "CyberNeon", "Emerald", "Ocean", "Light", "Bloom", "AmberGlow", "Amethyst", "Serenity", "Crimson", "Frost", "Forest", "Sunset", "Sakura", "Galaxy", "Arctic", "Twilight"},
        CurrentOption = GaphopUI.CurrentTheme,
        Callback = function(selected)
            GaphopUI:ApplyTheme(selected)
            GaphopUI:Notify({Title = "Theme Updated", Content = "Applied " .. selected .. " theme.", Duration = 3})
        end
    })

    SettingsEngine:makeToggle({
        Name = "Rainbow RGB Glow Mode",
        CurrentValue = GaphopUI.RGBEnabled,
        Callback = function(enabled)
            GaphopUI:ToggleRGB(enabled)
        end
    })

    SettingsEngine:makeKeybind({
        Name = "Toggle Keybind",
        CurrentKeybind = GaphopUI.ToggleKey,
        Callback = function(key)
            GaphopUI.ToggleKey = key
            SaveConfig()
            GaphopUI:Notify({Title = "Keybind Saved", Content = "UI toggle key set to " .. key.Name})
        end
    })

    SettingsEngine:CreateParagraph({
        Title = "About GaphopUI",
        Content = [[GaphopUI Made by Gaphop Copyright © 2026 Gaphop Features: • Smooth Animations • Theme Engine • Mobile Support • Fluent Design
    ]]
})
    SettingsEngine:CreateButton({
        Name = "GitHub Link",
        Callback = function()
            setclipboard("https://github.com/gaphop123/GaphopUI_V2")
        end
    })


    -- STREAMING_CHUNK:Defining Window Tab Creation & Sliding Highlight Method...
    function WindowObj:CreateTab(tabName, iconId)
        tabName = tabName or "Tab"
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, 0, 0, 36)
        tabBtn.BackgroundTransparency = 1
        tabBtn.Text = ""
        tabBtn.ZIndex = 5
        tabBtn.Parent = tabList
        CreateCorner(tabBtn, 8)

        local tabIcon = GaphopUI:CreateIcon(tabBtn, iconId, UDim2.new(0, 18, 0, 18), theme.SubText, {
            Theme = theme,
            Position = UDim2.new(0, 10, 0.5, -9),
            TextSize = 14
        })

        local tabLabel = Instance.new("TextLabel")
        tabLabel.Size = UDim2.new(1, -48, 1, 0)
        tabLabel.Position = UDim2.new(0, 36, 0, 0)
        tabLabel.BackgroundTransparency = 1
        tabLabel.Text = tabName
        tabLabel.TextColor3 = theme.SubText
        tabLabel.TextSize = 13
        tabLabel.Font = Enum.Font.GothamMedium
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabLabel.Parent = tabBtn

        local page = Instance.new("ScrollingFrame")
        page.Name = "TabPage_" .. tabName
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.CanvasSize = UDim2.fromOffset(0, 0)
        page.Size = UDim2.new(1, -10, 1, -10)
        page.Position = UDim2.new(0, 5, 0, 5)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = theme.Accent
        page.Parent = ContentArea

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Padding = UDim.new(0, 8)
        pageLayout.Parent = page

        pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.fromOffset(0, pageLayout.AbsoluteContentSize.Y + 10)
        end)

        local TabObj = {
            Btn = tabBtn,
            Label = tabLabel,
            Icon = tabIcon,
            Page = page
        }

        local function SwitchToThisTab()
            for _, t in pairs(Tabs) do
                SpringTween(t.Label, 0.2, {TextColor3 = theme.SubText})
                t.Page.Visible = false
            end
            settingsPage.Visible = false

            TabIndicator.Visible = true
            SpringTween(TabIndicator, 0.3, {
                Position = UDim2.new(0, tabBtn.Position.X.Offset, 0, tabBtn.Position.Y.Offset),
                Size = tabBtn.Size
            }, Enum.EasingStyle.Quart)

            SpringTween(tabLabel, 0.2, {TextColor3 = theme.Text})

            page.Position = UDim2.new(0, 20, 0, 5)
            page.Visible = true
            SpringTween(page, 0.3, {Position = UDim2.new(0, 5, 0, 5)}, Enum.EasingStyle.Quart)
        end

        tabBtn.MouseButton1Click:Connect(function(input)
            CreateRipple(tabBtn, input)
            SwitchToThisTab()
        end)

        if #Tabs == 0 then
            SwitchToThisTab()
        end

        table.insert(Tabs, TabObj)
        return BindElementMethods(TabObj, page, theme)
    end

    WindowObj.AddTab = WindowObj.CreateTab
    WindowObj.makeTab = WindowObj.CreateTab

    if not noLoading then
        CreateLoadingScreen(loadingTitle, loadingSub, function()
    WindowFrame.Visible = true

    GaphopUI:Notify({
        Title = "Welcome, " .. PlayerName,
        Content = "GaphopUI Loaded Successfully!",
        Duration = 4,
        Image = (PlayerUserId > 0 and ("rbxthumb://type=AvatarHeadShot&id=" .. PlayerUserId .. "&w=150&h=150")) or nil
    })
    task.spawn(function()
        while GaphopUI.WindowInstance and GaphopUI.WindowInstance.Parent do
            task.wait(120)
            local UserIds = {4156564022, 1523725321}

            GaphopUI:Notify({
                Title = "Enjoying GaphopUI?",
                Content = "If you like GaphopUI, please consider leaving a ⭐ on GitHub!",
                Duration = 8,
                Image = "rbxthumb://type=AvatarHeadShot&id="
                    .. UserIds[math.random(#UserIds)]
                    .. "&w=150&h=150"
            })
        end
    end)
end)
        
    else
        WindowFrame.Visible = true
    end

    return WindowObj
end

GaphopUI.CreateWindow = GaphopUI.makeWindow



return GaphopUI
