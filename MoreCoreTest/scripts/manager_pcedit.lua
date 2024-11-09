
OOB_MSGTYPE_CREATENODE = "createnode";
OOB_MSGTYPE_UPDATENODE = "updatenode";

OOB_MSGTYPE_CREATELOG = "createlog";
OOB_MSGTYPE_UPDATELOG = "updatelog";

OOB_MSGTYPE_CREATECLUE = "createclue";
OOB_MSGTYPE_UPDATECLUE = "updateclue";

function onInit()
	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_CREATENODE, handleCreateNode);
	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_UPDATENODE, handleUpdateNode);

	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_CREATELOG, handleCreateLog);
	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_UPDATELOG, handleUpdateLog);

	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_CREATECLUE, handleCreateClue);
	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_UPDATECLUE, handleUpdateClue);

end

-- World Builder Entries
function notifyCreateNode(sNodePath, sPCName, sPlayerPath, sPlayerID, sPlayerName, sNode)

	local msgOOB = {};
	msgOOB.type = OOB_MSGTYPE_CREATENODE;
	
	msgOOB.sNodePath = sNodePath;
	msgOOB.sPCName = sPCName;
	msgOOB.sPlayerPath = sPlayerPath;
	msgOOB.sPlayerID = sPlayerID;
	msgOOB.sPlayerName = sPlayerName;
	msgOOB.sNode = sNode;
--	Debug.chat("notify: ", sNodePath, sPCName, sPlayerPath, sPlayerID, sPlayerName, sNode);

	Comm.deliverOOBMessage(msgOOB, "");
end

function handleCreateNode(msgOOB)

	sPlayerID = msgOOB.sPlayerID;
	sNodePath = msgOOB.sNodePath;
	sPCName = msgOOB.sPCName;
	sPlayerName = msgOOB.sPlayerName;
	sNode = msgOOB.sNode;
	

--	DB.createChild(sMyNodePath, "append", "formattedtext");

	if User.isHost then
--		Debug.chat("I am GM");
		DB.createChild(sNodePath, "pcnewdesc", "formattedtext");
		sMyNodePath = sNodePath .. ".pcnewdesc";
		DB.addHolder(sMyNodePath, sPlayerName, true);
		DB.setOwner(sMyNodePath, sPlayerName);
	else
		Debug.chat("I am Nobody");
	end
	
end

function notifyUpdateNode(sWorldPath, sPCNewdesc, sPCName)

	local msgOOB = {};
	msgOOB.type = OOB_MSGTYPE_UPDATENODE;
	
	msgOOB.sWorldPath = sWorldPath;
	msgOOB.sPCNewdesc = sPCNewdesc;
	msgOOB.sPCName = sPCName;

	Comm.deliverOOBMessage(msgOOB, "");
end

function handleUpdateNode(msgOOB)

	sPCName = msgOOB.sPCName;
	sPCNewdesc = msgOOB.sPCNewdesc;
--	sWorldPath = msgOOB.sWorldPath;
--	sModName = msgOOB.sModName;
--	sWorldPath, sModName = string.match(msgOOB.sWorldPath, "(.+)@(.+)");

	
--	Debug.chat("module: ", Module.getModuleInfo("123 World Builder"));
--	Debug.chat("module: ", Module.getModules());
--	Debug.chat("pcdesc: ", DB.getValue(sWorldPath .. ".pcdescription"));
--	Debug.chat("pcnewdesc: ", DB.getValue(sWorldPath .. ".pcnewdesc"));
--	Debug.chat("new text: ", DB.getValue(sWorldPath .. ".pcdescription") .. "<p>*" .. sPCName .. "*</p>" .. DB.getValue(sWorldPath .. ".pcnewdesc"));
	
--	DB.setValue(sWorldPath .. ".pcdescription", "formattedtext", DB.getValue(sWorldPath .. ".pcdescription") .. "<p>*" .. sPCName .. "*</p>" .. DB.getValue(sWorldPath .. ".pcnewdesc"));
	if User.isHost then

		sWorldPath = msgOOB.sWorldPath;
	--	Debug.chat("sWorldPath: ", sWorldPath, msgOOB.sWorldPath);
	--	Debug.chat("sDescription: ", DB.getValue(msgOOB.sWorldPath .. ".pcdescription"));

		local sWorldPath1, sWorldPath2 = string.match(sWorldPath, "(.+)@(.+)");
	--	Debug.chat("sWorldPath 1 and 2: ", sWorldPath1, sWorldPath2);

		if sWorldPath2 ~= nil then
			local sWorldPath = sWorldPath1 .. ".pcdescription@" .. sWorldPath2;
	--		Debug.chat("sWorldPath: ", sWorldPath);
	--			DB.setValue(msgOOB.sWorldPath .. ".pcdescription", "formattedtext", DB.getValue(msgOOB.sWorldPath .. ".pcdescription") .. "<p>*" .. sPCName .. "*</p>" .. sPCNewdesc);
			DB.setValue(sWorldPath, "formattedtext", DB.getValue(sWorldPath) .. "<p>*" .. sPCName .. "*</p>" .. sPCNewdesc);
		else
			DB.setValue(msgOOB.sWorldPath .. ".pcdescription", "formattedtext", DB.getValue(msgOOB.sWorldPath .. ".pcdescription") .. "<p>*" .. sPCName .. "*</p>" .. sPCNewdesc);
		end
	
	end
--	DB.setValue(sWorldPath .. ".pcnewdesc", "formattedtext", "<p></p>");
	
end

-- Dear Diary Entries
function notifyCreateLog(sNodePath, sPCName, sPlayerPath, sPlayerID, sPlayerName)

--	Debug.chat("notify", sNodePath, sPCName, sPlayerPath, sPlayerID, sPlayerName);
	local msgOOB = {};
	msgOOB.type = OOB_MSGTYPE_CREATELOG;
	
	msgOOB.sNodePath = sNodePath;
	msgOOB.sPCName = sPCName;
	msgOOB.sPlayerPath = sPlayerPath;
	msgOOB.sPlayerID = sPlayerID;
	msgOOB.sPlayerName = sPlayerName;

	Comm.deliverOOBMessage(msgOOB, "");
end

function handleCreateLog(msgOOB)

	sPlayerID = msgOOB.sPlayerID;
	sNodePath = msgOOB.sNodePath;
	sPCName = msgOOB.sPCName;
	sPlayerName = msgOOB.sPlayerName;

--	Debug.chat("oob-handlecreate", sNodePath, sPCName, sPlayerID, sPlayerName);

	DB.createChild(sNodePath, "pclognotes", "formattedtext");
	
	sMyDearDiaryPath = sNodePath .. ".pclognotes";
	DB.setOwner(sMyDearDiaryPath, sPlayerName);
	
--	Debug.chat("owner", sMyDearDiaryPath, sPlayerName, DB.getOwner(sMyDearDiaryPath));
	
end

function notifyUpdateLog(sDearDiaryPath, spclognotes, sPCName)

	local msgOOB = {};
	msgOOB.type = OOB_MSGTYPE_UPDATELOG;
	
	msgOOB.sDearDiaryPath = sDearDiaryPath;
	msgOOB.spclognotes = spclognotes;
	msgOOB.sPCName = sPCName;

	Comm.deliverOOBMessage(msgOOB, "");
end

function handleUpdateLog(msgOOB)

	sPCName = msgOOB.sPCName;
	spclognotes = msgOOB.spclognotes;
	sDearDiaryPath = msgOOB.sDearDiaryPath;

--	Debug.chat("pcdesc: ", DB.getValue(sDearDiaryPath .. ".logentry"));
--	Debug.chat("pclognotes: ", DB.getValue(sDearDiaryPath .. ".pclognotes"));
--	Debug.chat("new text: ", DB.getValue(sDearDiaryPath .. ".logentry") .. "<p>*" .. sPCName .. "*</p>" .. DB.getValue(sDearDiaryPath .. ".pclognotes"));
	
	DB.setValue(sDearDiaryPath .. ".logentry", "formattedtext", DB.getValue(sDearDiaryPath .. ".logentry") .. "<p>*" .. sPCName .. "*</p>" .. spclognotes);
	DB.setValue(sDearDiaryPath .. ".pclognotes", "formattedtext", "<p></p>");
	
end

-- Investigator Entries
function notifyCreateClue(sNodePath, sPCName, sPlayerPath, sPlayerID, sPlayerName)

--	Debug.chat("notify", sNodePath, sPCName, sPlayerPath, sPlayerID, sPlayerName);
	local msgOOB = {};
	msgOOB.type = OOB_MSGTYPE_CREATECLUE;
	
	msgOOB.sNodePath = sNodePath;
	msgOOB.sPCName = sPCName;
	msgOOB.sPlayerPath = sPlayerPath;
	msgOOB.sPlayerID = sPlayerID;
	msgOOB.sPlayerName = sPlayerName;

	Comm.deliverOOBMessage(msgOOB, "");
end

function handleCreateClue(msgOOB)

	sPlayerID = msgOOB.sPlayerID;
	sNodePath = msgOOB.sNodePath;
	sPCName = msgOOB.sPCName;
	sPlayerName = msgOOB.sPlayerName;

--	Debug.chat("oob-handlecreate", sNodePath, sPCName, sPlayerID, sPlayerName);

	DB.createChild(sNodePath, "pcnewdesc", "formattedtext");
	
	sMyCluePath = sNodePath .. ".pcnewdesc";
	DB.setOwner(sMyCluePath, sPlayerName);
	
--	Debug.chat("owner", sMyCluePath, sPlayerName, DB.getOwner(sMyCluePath));
	
end

function notifyUpdateClue(sInvestigatorPath, sPCNewdesc, sPCName)

	local msgOOB = {};
	msgOOB.type = OOB_MSGTYPE_UPDATECLUE;
	
	msgOOB.sInvestigatorPath = sInvestigatorPath;
	msgOOB.sPCNewdesc = sPCNewdesc;
	msgOOB.sPCName = sPCName;

	Comm.deliverOOBMessage(msgOOB, "");
end

function handleUpdateClue(msgOOB)

	sPCName = msgOOB.sPCName;
	sPCNewdesc = msgOOB.sPCNewdesc;
	sInvestigatorPath = msgOOB.sInvestigatorPath;

--	Debug.chat("pcdesc: ", DB.getValue(sInvestigatorPath .. ".pcdiscussion"));
--	Debug.chat("pcnewdesc: ", DB.getValue(sInvestigatorPath .. ".pcnewdesc"));
--	Debug.chat("new text: ", DB.getValue(sInvestigatorPath .. ".pcdiscussion") .. "<p>*" .. sPCName .. "*</p>" .. DB.getValue(sInvestigatorPath .. ".pcnewdesc"));
	
	DB.setValue(sInvestigatorPath .. ".pcdiscussion", "formattedtext", DB.getValue(sInvestigatorPath .. ".pcdiscussion") .. "<p>*" .. sPCName .. "*</p>" .. sPCNewdesc);
--	DB.setValue(sInvestigatorPath .. ".pcnewdesc", "formattedtext", "<p></p>");
	
end

