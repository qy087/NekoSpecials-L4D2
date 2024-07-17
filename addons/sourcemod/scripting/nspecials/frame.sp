

public void OnGameFrame()
{
	if (GetGameTime() - CheckGameTime >= NCvar[CSpecial_CheckGame_Time].FloatValue)
	{
		if (NCvar[CSpecial_Check_IsPlayerBiled].BoolValue)
		{
			for (int i = 0; i <= MaxClients; i++)
			{
				if (!IsValidClient(i) || !IsPlayerAlive(i) || GetClientTeam(i) != 2)
					continue;

				if (IsMoreSpecialsAlive() && IsEntityBiled(i))
				{
					int GetRandom = GetRandomInfected(1, 1);
					if (IsValidClient(GetRandom) && IsPlayerAlive(GetRandom))
					{
						ResetFakeClient(GetRandom);
						SetFakeClientAimTarget(GetRandom, i);
					}
				}
			}
		}
		CheckGameTime = GetGameTime();
	}
}