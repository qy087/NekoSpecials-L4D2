void StartVoteYesNo(int client)
{
	if (!IsValidClient(client))
		return;

	if (!L4D2NativeVote_IsAllowNewVote())
	{
		PrintToChat(client, "投票正在进行中, 暂不能发起新的投票");
		return;
	}

	char buffer[512], sbuffer[512];

	if (StrEqual(VoteMenuItems[client], "tgstat"))
	{
		Format(buffer, sizeof buffer, "多特插件");
		Format(sbuffer, sizeof sbuffer, "%s", !GCvar[CSpecial_PluginStatus].BoolValue ? "开启" : "关闭");
	}
	if (StrEqual(VoteMenuItems[client], "tgrandom"))
	{
		Format(buffer, sizeof buffer, "随机特感");
		Format(sbuffer, sizeof sbuffer, "%s", !GCvar[CSpecial_Random_Mode].BoolValue ? "开启" : "关闭");
	}
	if (StrEqual(VoteMenuItems[client], "tgtanklive"))
	{
		Format(buffer, sizeof buffer, "坦克存活时刷新特感");
		Format(sbuffer, sizeof sbuffer, "%s", !GCvar[CSpecial_Spawn_Tank_Alive].BoolValue ? "开启" : "关闭");
	}
	if (StrEqual(VoteMenuItems[client], "tgtime"))
	{
		Format(buffer, sizeof buffer, "刷特时间为");
		Format(sbuffer, sizeof sbuffer, "%d s", VoteMenuItemValue[client]);
	}
	if (StrEqual(VoteMenuItems[client], "tgnum"))
	{
		Format(buffer, sizeof buffer, "初始刷特数量为");
		Format(sbuffer, sizeof sbuffer, "%d 特", VoteMenuItemValue[client]);
	}
	if (StrEqual(VoteMenuItems[client], "tgadd"))
	{
		Format(buffer, sizeof buffer, "进人增加数量为");
		Format(sbuffer, sizeof sbuffer, "%d 特", VoteMenuItemValue[client]);
	}
	if (StrEqual(VoteMenuItems[client], "tgpnum"))
	{
		Format(buffer, sizeof buffer, "初始玩家数量为");
		Format(sbuffer, sizeof sbuffer, "%d 人", VoteMenuItemValue[client]);
	}
	if (StrEqual(VoteMenuItems[client], "tgpadd"))
	{
		Format(buffer, sizeof buffer, "玩家增加数量为");
		Format(sbuffer, sizeof sbuffer, "%d 人", VoteMenuItemValue[client]);
	}
	if (StrEqual(VoteMenuItems[client], "tgmode"))
	{
		Format(sbuffer, sizeof(sbuffer), "%s", SpecialName[StringToInt(SubMenuVoteItems[client])]);
		Format(buffer, sizeof buffer, "游戏模式为");
	}
	if (StrEqual(VoteMenuItems[client], "tgspawn"))
	{
		Format(sbuffer, sizeof(sbuffer), "%s", SpawnModeName[StringToInt(SubMenuVoteItems[client])]);
		Format(buffer, sizeof buffer, "刷特模式为");
	}

	L4D2NativeVote vote = L4D2NativeVote(VoteYesNoH);
	vote.Initiator	= client;
	vote.SetInfo("更改%s%s", buffer, sbuffer);
	
	int team;
	int clients[1];
	for (int i = 1; i <= MaxClients; i++) {
		if (!IsClientInGame(i) || IsFakeClient(i) || (team = GetClientTeam(i)) < 2 || team > 3)
			continue;

		vote.SetTitle("更改%s:(%s)", buffer, sbuffer);

		clients[0] = i;
		vote.DisplayVote(clients, 1, 20);
	}
}

void VoteYesNoH(L4D2NativeVote vote, VoteAction action, int param1, int param2) {
	switch (action)
	{
		case VoteAction_Start:
		{
			char buffer[128];
			char info[2][64];
			vote.GetInfo(buffer, sizeof buffer);
			ExplodeString(buffer, "//", info, sizeof info, sizeof info[]);

			for (int i = 1; i <= MaxClients; i++) {
				if (IsClientInGame(i) && !IsFakeClient(i)) {
					PrintToChat(i, \x04{blue}%N \x01发起投票 \x05%s", param1, info[0]);
				}
			}
		}

		case VoteAction_PlayerVoted:
			PrintToChatAll("\x04%N \x01已%s", param1, param2 == 1 ? "赞成" : "反对");


		case VoteAction_End:
		{
			if (vote.YesCount > vote.PlayerCount / 2) {
				vote.SetPass("设置中...");
				char buffer[512], sbuffer[512], item[512];
				int	 client = vote.Initiator;
				item		= VoteMenuItems[client];
				if (StrEqual(item, "tgstat"))
				{
					Format(buffer, sizeof buffer, "多特插件");
					Format(sbuffer, sizeof sbuffer, "%s", !GCvar[CSpecial_PluginStatus].BoolValue ? "开启" : "关闭");
					GCvar[CSpecial_PluginStatus].SetBool(!GCvar[CSpecial_PluginStatus].BoolValue);
				}
				if (StrEqual(item, "tgrandom"))
				{
					Format(buffer, sizeof buffer, "随机特感");
					Format(sbuffer, sizeof sbuffer, "%s", !GCvar[CSpecial_Random_Mode].BoolValue ? "开启" : "关闭");
					GCvar[CSpecial_Random_Mode].SetBool(!GCvar[CSpecial_Random_Mode].BoolValue);
				}
				if (StrEqual(item, "tgtanklive"))
				{
					Format(buffer, sizeof buffer, "坦克存活时刷新特感");
					Format(sbuffer, sizeof sbuffer, "%s", !GCvar[CSpecial_Spawn_Tank_Alive].BoolValue ? "开启" : "关闭");
					GCvar[CSpecial_Spawn_Tank_Alive].SetBool(!GCvar[CSpecial_Spawn_Tank_Alive].BoolValue);
				}
				if (StrEqual(item, "tgtime"))
				{
					Format(buffer, sizeof buffer, "刷特时间为");
					Format(sbuffer, sizeof sbuffer, "%d s", VoteMenuItemValue[client]);
					GCvar[CSpecial_Spawn_Time].SetInt(VoteMenuItemValue[client]);
				}
				if (StrEqual(item, "tgnum"))
				{
					Format(buffer, sizeof buffer, "初始刷特数量为");
					Format(sbuffer, sizeof sbuffer, "%d 特", VoteMenuItemValue[client]);
					GCvar[CSpecial_Num].SetInt(VoteMenuItemValue[client]);
				}
				if (StrEqual(item, "tgadd"))
				{
					Format(buffer, sizeof buffer, "进人增加数量为");
					Format(sbuffer, sizeof sbuffer, "%d 特", VoteMenuItemValue[client]);
					GCvar[CSpecial_AddNum].SetInt(VoteMenuItemValue[client]);
				}
				if (StrEqual(item, "tgpnum"))
				{
					Format(buffer, sizeof buffer, "初始玩家数量为");
					Format(sbuffer, sizeof sbuffer, "%d 人", VoteMenuItemValue[client]);
					GCvar[CSpecial_PlayerNum].SetInt(VoteMenuItemValue[client]);
				}
				if (StrEqual(item, "tgpadd"))
				{
					Format(buffer, sizeof buffer, "玩家增加数量为");
					Format(sbuffer, sizeof sbuffer, "%d 人", VoteMenuItemValue[client]);
					GCvar[CSpecial_PlayerAdd].SetInt(VoteMenuItemValue[client]);
				}
				if (StrEqual(item, "tgmode"))
				{
					Format(sbuffer, sizeof(sbuffer), "%s", SpecialName[StringToInt(SubMenuVoteItems[client])]);
					Format(buffer, sizeof buffer, "游戏模式为");

					GCvar[CSpecial_Default_Mode].SetInt(StringToInt(SubMenuVoteItems[client]));

					if (GCvar[CSpecial_Show_Tips].BoolValue)
						NekoSpecials_ShowSpecialsModeTips();

					if (GCvar[CSpecial_Random_Mode].BoolValue)
					{
						GCvar[CSpecial_Random_Mode].SetBool(false);
						PrintToChatAll("\x05%s \x04关闭了随机特感", NEKOTAG);
					}
				}
				if (StrEqual(item, "tgspawn"))
				{
					Format(sbuffer, sizeof(sbuffer), "%s", SpawnModeName[StringToInt(SubMenuVoteItems[client])]);
					Format(buffer, sizeof buffer, "刷特模式为");

					GCvar[CSpecial_Spawn_Mode].SetInt(StringToInt(SubMenuVoteItems[client]));

					PrintToChatAll("\x05%s \x04特感刷新方式更改为 \x03%s刷特模式", NEKOTAG, sbuffer);
				}
				//vote.DisplayPass("投票%s %s 通过!!!", buffer, sbuffer);
	
				cleanplayerchar(client);

				CreateTimer(0.2, Timer_ReloadMenu, GetClientUserId(client));
				for (int i = 1; i <= MaxClients; i++) 
				{
					if (IsClientInGame(i) && !IsFakeClient(i))
					{
						PrintToChat(i, "\x01%s \x05%s", buffer, sbuffer);
					}
				}
			}
			else
				vote.SetFail();
		}
	}
}
