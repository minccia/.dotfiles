-------------------------------------------------------------------------------
-------------------------IMPORTS-----------------------------------------------
-------------------------------------------------------------------------------

-- Base XMonad Imports
import XMonad
import Data.Monoid
import Data.Ratio
import System.Exit

-- Window Manipulation
import XMonad.Actions.CycleWS
import XMonad.Actions.WindowBringer
import XMonad.Actions.RotSlaves
import XMonad.Actions.MouseGestures

-- Xmobar Imports
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.Minimize
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers

-- XMonad Layout Imports
import XMonad.Layout.Spacing
import XMonad.Layout.Stoppable
import XMonad.Layout.Renamed 
import qualified XMonad.Layout.NoBorders as BO 

-- XMonad Config Imports
import XMonad.Util.SpawnOnce
import XMonad.Util.Run
import XMonad.Util.EZConfig
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-------------------------------------------------------------------------------
-------------------------VARIABLES-----------------------------------------
-------------------------------------------------------------------------------

myTerminal      = "urxvtc"
myFont          = "xft:JetBrainsMonoNL:pixelsize:12:antialias=true:hinting=true"
myModMask       =  mod4Mask

-------------------------------------------------------------------------------
-------------------------BORDERS-----------------------------------------------
-------------------------------------------------------------------------------

myBorderWidth         =  2
myNormalBorderColor   =  "#000000"
myFocusedBorderColor  = "#ecefe9"

-------------------------------------------------------------------------------
-------------------------MISCELLANEOUS-----------------------------------------
-------------------------------------------------------------------------------

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

myClickJustFocuses :: Bool
myClickJustFocuses = True

myWorkspaces    = ["1","2","3","4","5"]

numPadKeys = [ xK_KP_End,  xK_KP_Down,  xK_KP_Page_Down,  -- 1, 2, 3
               
               xK_KP_Left, xK_KP_Begin, xK_KP_Right,      -- 4, 5, 6
   
               xK_KP_Home, xK_KP_Up,    xK_KP_Page_Up,    -- 7, 8, 9

               xK_KP_Insert] -- 0
 
-------------------------------------------------------------------------------
-------------------------KEYBINDINGS-------------------------------------------
-------------------------------------------------------------------------------

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm,               xK_Return), spawn $ XMonad.terminal conf)
    
    -- launch dmenu
    , ((modm,               xK_space   ), spawn "dmenu_run -fn 'Cozette-10' -nb '#000000' -nf '#ecefe9' -sb '#3c3c4c' -sf '#ecefe9' &")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_i     ), spawn "gmrun")

    -- close focused window
    , ((modm,               xK_c    ), kill)

    , ((modm .|. shiftMask, xK_c), spawn "xkill")

     -- Rotate through the available layout algorithms
    , ((modm,               xK_KP_Right ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_p ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_KP_Page_Down     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_9), windows W.swapMaster )

    -- Shrink the master area
    , ((modm,               xK_Down ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_Up     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_KP_Home ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_KP_Up ), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    -- My Keybindings

-------------------------------------------------------------------------------
---------------------CUSTOM KEYBINDINGS----------------------------------------
-------------------------------------------------------------------------------
   
   -- Volume Up
   ,  ((modm,          xK_8 ), spawn "amixer -D pulse sset Master 5%+")
   
   -- Volume Down
   , ((modm,          xK_7 ), spawn "amixer -D pulse sset Master 5%-")
   
   -- Print Whole Screen
   , ((0, xK_Print ), spawn "scrot '%Y-%m-%d-%S_$wx$h.png' -e 'mv $f ~/Pictures/' ")

   -- Toggle xmobar
   , ((modm,          xK_b ), sendMessage ToggleStruts)

   -- Dmenu Script to Logout, Shutdown, Reboot or Lock Screen
   , ((modm,          xK_y ), spawn "dm-logout")

   -- Window Manipulation
   -- Move window to the next workspace
   , ((modm,          xK_Right), shiftToNext >> nextWS)

   -- Move window to the previous workspace
   , ((modm,          xK_Left ), shiftToPrev >> prevWS)

   -- Rotate all windows except the master window
   -- and keep focus in place

   , ((modm,          xK_KP_Page_Up ), rotSlavesUp)

   -- Dmenu script to go to window
   , ((modm,           xK_KP_Left ), gotoMenu)

   -- Dmenu script to bring window to you
   , ((modm,           xK_KP_Begin ), bringMenu)
     ]
    ++

    --
    -- mod-[1..5], Switch to workspace N
    -- mod-shift-[1..5], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_5]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

-------------------------------------------------------------------------------
-------------------------MOUSE BINDINGS----------------------------------------
-------------------------------------------------------------------------------

-- Mouse bindings: default actions bound to mouse events

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    , ((modm .|. shiftMask, button1), (\w -> shiftToPrev >> prevWS))  
    
    , ((modm .|. shiftMask, button3), (\w -> shiftToNext >> nextWS))                                   
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

-------------------------------------------------------------------------------
-------------------------LAYOUTS-----------------------------------------------
-------------------------------------------------------------------------------

myLayout = BO.lessBorders BO.Never $ avoidStruts (stoppable tiled ||| stoppable Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = spacingRaw True (Border 0 3 3 3) True (Border 3 3 3 3) True $ Tall nmaster delta ratio
     full = renamed [Replace "Full"]
          $ BO.noBorders(Full)

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

-------------------------------------------------------------------------------
-------------------------WINDOW RULES------------------------------------------
-------------------------------------------------------------------------------

-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS

myManageHook = composeAll [
      manageDocks,
            isFullscreen --> doFullFloat,
            className =? "Org.gnome.Nautilus" --> doFloat,
            className =? "Firefox"            --> doFullFloat,
            className =? "leagueclientux.exe" --> doFloat,
            className =? "Lutris"             --> doFloat,
            className =? "URxvt"              --> doRectFloat (W.RationalRect (1 % 4) (1 % 4) (1 % 2) (1 % 2))
                                                            ]
                                                            
             

-------------------------------------------------------------------------------
-------------------------EVENT HANDLING----------------------------------------
-------------------------------------------------------------------------------

myEventHook = fullscreenEventHook

-------------------------------------------------------------------------------
-------------------------STATUS BARS AND LOGGING-------------------------------
-------------------------------------------------------------------------------

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
--myLogHook = dynamicLog >> updatePointer (0.5, 0.5) (0, 0)
myLogHook = dynamicLog

-------------------------------------------------------------------------------
-------------------------STARTUP HOOK------------------------------------------
-------------------------------------------------------------------------------
--
myStartupHook = do

         spawnPipe "feh --bg-fill ~/stuff/wallpapers/black.png &" -- Set background with feh 
         spawnOnce "picom -b &"
         spawnOnce "urxvtd -q -f -o"
         spawnOnce "nvm use 18.12.0"
         spawnOnce "source ~/.config/zsh/.zshrc"
         spawnOnce "xrandr --output eDP-1 --brightness 0.20" --Set default screen brightness
         spawnOnce "ruby ~/xinput-solver/touchpad.rb"
-------------------------------------------------------------------------------
-------------------------END OF FILE-------------------------------------------
-------------------------------------------------------------------------------

-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
  xmproc <- spawnPipe "xmobar -x 0 /home/dulis/.config/xmobar/xmobarrc"
  xmonad $ docks defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
