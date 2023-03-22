#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <cstrike>

#pragma newdecls required
#pragma semicolon 1

public Plugin myinfo = {
	name = "Weapon Pickup Logger",
	author = "iLoco",
	version = "1.2.0",
	description = "Logs weapon pickup events.",
	url = "https://github.com/IL0co/weapon-pickup-logger",
};

enum LogType {
	LogType_Message = 0,
	LogType_Action = 1,
}

LogType logType;
int offsetWeaponDefIndex;
CSWeaponID lastBuyedWeapon;
int entitySpawnTime[2048];

stock CSWeaponID GetWeaponID(int weapon) {
	return CS_ItemDefIndexToID(GetEntData(weapon, offsetWeaponDefIndex));
}

public void OnSDKHook_WeaponEquip_Post(int client, int weapon) {
	CSWeaponID weaponId = GetWeaponID(weapon);
	int time = GetTime() - 1;

	char className[64], reason[32];
	GetEntityClassname(weapon, className, sizeof className);

	if(weaponId == lastBuyedWeapon) {
		reason = "purchase";
		lastBuyedWeapon = CSWeapon_NONE;
	} else if(entitySpawnTime[client] >= time) {
		reason = "when player spawns";
	} else if(entitySpawnTime[weapon] >= time) {
		reason = "issued by map or plugin";
	} else {
		reason = "just picked";
	}

	switch(logType) {
		case LogType_Message: {
			LogMessage("Player %L picked up the weapon %s. Reason for uplift: %s.", client, className, reason);
		}
		case LogType_Action: {
			LogAction(client, -1, "Player %L picked up the weapon %s. Reason for uplift: %s.", client, className, reason);
		}
	}
}

public void OnSDKHook_PlayerSpawn_Pre(int client) {
	entitySpawnTime[client] = GetTime();
}

public void OnClientPostAdminCheck(int client) {
	SDKHook(client, SDKHook_WeaponEquipPost, OnSDKHook_WeaponEquip_Post);
	SDKHook(client, SDKHook_Spawn, OnSDKHook_PlayerSpawn_Pre);
}

public void OnConVarChanged_LogType(ConVar cvar, const char[] oldValue, const char[] newValue) {
	logType = view_as<LogType>(cvar.IntValue);
}

public void OnPluginStart() {
	offsetWeaponDefIndex = FindSendPropInfo("CBaseCombatWeapon", "m_iItemDefinitionIndex");

	for(int i = 1; i <= MaxClients; i++) {
		if(IsClientInGame(i)) {
			OnClientPostAdminCheck(i);
		}
	}

	ConVar cvar = CreateConVar("sm_wpl_log_type", "0", "Logging type: 0 - Message, 1 - Action", _, true, 0.0, true, 1.0);
	cvar.AddChangeHook(OnConVarChanged_LogType);
	OnConVarChanged_LogType(cvar, "", "");
}

public void OnEntityCreated(int entity, const char[] className) {
	if(entity > MaxClients && entity < 2048) {
		entitySpawnTime[entity] = GetTime();
	}
}

public Action CS_OnBuyCommand(int client, const char[] alias) {
	lastBuyedWeapon = CS_AliasToWeaponID(alias);
	
	return Plugin_Continue;
}