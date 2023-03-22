#include <sourcemod>
#include <sdkhooks>
#include <sdktools>

#pragma newdecls required
#pragma semicolon 1

public Plugin myinfo = {
	name = "Weapon Pickup Logger",
	author = "iLoco",
	version = "1.0.0",
	description = "Logs weapon pickup events.",
	url = "https://github.com/IL0co/weapon-pickup-logger",
};

public void OnSDKHook_WeaponEquip_Post(int client, any weapon) {
	char classname[64];
	GetEntityClassname(weapon, classname, sizeof classname);

	LogMessage("Player %L picked up the weapon %s.", client, classname);
}

public void OnClientPostAdminCheck(int client) {
	SDKHook(client, SDKHook_WeaponEquipPost, OnSDKHook_WeaponEquip_Post);
}

public void OnPluginStart() {
	for(int i = 1; i <= MaxClients; i++) {
		if(IsClientInGame(i)) {
			OnClientPostAdminCheck(i);
		}
	}
}