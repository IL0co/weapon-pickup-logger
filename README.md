# Description

Logs the event of a player picking up a weapon. The specific reason is recorded in the log. There are 4 types of lift:
1. Upon purchase. The player bought a weapon and it stood out to him.
2. When spawning. Issuance of default weapons at spawn (within 1 second after spawn).
3. Issuance by plugin or card. Trigger condition when a weapon spawns and within 1 second it is picked up by the player.
4. Normal lifting. The long-lying gun was simply raised.

# ConVars

- `sm_wpl_log_type 0` - Logging type: 0 - Message, 1 - Action, 2 - Specified file
- `sm_wpl_log_file "addons/sourcemod/logs/wlp.log"` - The file where the logging will be conducted. (directory must be created manually)

# Text in the log
```c
L 03/22/2023 - 22:52:31: [weapon_pickup_logger.smx] Player iLoco<2><STEAM_1:0:104481081><> picked up the weapon weapon_xm1014. Reason for uplift: purchase.
L 03/22/2023 - 22:52:44: [weapon_pickup_logger.smx] Player iLoco<2><STEAM_1:0:104481081><> picked up the weapon weapon_negev. Reason for uplift: issued by map or plugin.
L 03/22/2023 - 23:07:03: [weapon_pickup_logger.smx] Player iLoco<2><STEAM_1:0:104481081><> picked up the weapon weapon_negev. Reason for uplift: just picked.
L 03/22/2023 - 22:47:31: [weapon_pickup_logger.smx] Player iLoco<2><STEAM_1:0:104481081><> picked up the weapon weapon_knife. Reason for uplift: when player spawns.
```

# Configuration errors

- The directory for the file has not been created.
	- Error text: `The file <path> could not be created, either by running a string or there is no directory created.`
	- Solution: create a directory before this file. You don't have to create the file, it will automatically be created.

# Question (Q) - Answer (A)

#### Q: How can these logs be displayed on the WEB?
#### A: Enable `sm_wpl_log_type 1`. Works only if the plugin that sends logs to the WEB works through `OnLogAction`. (can be checked by opening the source of that plugin and searching for `OnLogAction`).
