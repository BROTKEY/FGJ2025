extends Node

enum PinecilMenus {
	StartupLogo = 10,                # Showing the startup logo
	CJCCalibration = 11,             # Cold Junction Calibration
	StartupWarnings = 12,            # Startup checks and warnings
	InitialisationDone = 13,         # Special state we use just before we to home screen at first startup. Allows jumping to extra startup states
	HomeScreen = 0,                  # Home/Idle screen that is the main launchpad to other modes
	Soldering = 1,                   # Main soldering operating mode
	SolderingProfile = 6,            # Soldering by following a profile, used for reflow for example
	Sleeping = 3,                    # Sleep state holds iron at lower sleep temp
	Hibernating = 14,                # Like sleeping but keeps heater fully off until woken
	SettingsMenu = 4,                # Settings Menu
	DebugMenuReadout = 5,            # Debug metrics
	TemperatureAdjust = 7,           # Set point temperature adjustment
	UsbPDDebug = 8,                  # USB PD debugging information
	ThermalRunaway = 9,              # Thermal Runaway warning state.

	GameJamHome = 16,                # GameJam Mode
	GameJamTemperatureAdjust = 17,   # GameJam Temperature Adjust
	GameJamShake = 18,               # GameJam Shake Microgame
}
