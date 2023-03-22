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

public void OnClientPostAdminCheck(int client) {
	
}

public void OnPluginStart() {
	for(int i = 1; i <= MaxClients; i++) {
		if(IsClientInGame(i)) {
			OnClientPostAdminCheck(i);
		}
	}
}