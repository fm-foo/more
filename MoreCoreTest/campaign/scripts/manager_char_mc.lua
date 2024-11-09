-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--



--
-- CHARACTER SHEET DROPS
--
function resolveRefNode(sRecord)
    local nodeSource = DB.findNode(sRecord);
    if not nodeSource then
        local sRecordSansModule = StringManager.split(sRecord, "@")[1];
        nodeSource = DB.findNode(sRecordSansModule .. "@*");
        if not nodeSource then
            ChatManager.SystemMessage(Interface.getString("char_error_missingrecord"));
        end
    end

    return nodeSource;
end

function addClassDB(nodeChar, sClass, sRecord)

	
local nodeSource = resolveRefNode(sRecord);
    Debug.console("nodeSource2:", nodeSource);
    if not nodeSource then
        return;
    end

	Debug.console("nodeSource name: ", DB.getValue(nodeSource, "name", ""));

--	Debug.console("DB: ", DB.getValue(nodeChar, "pcclasslink", ""));
--	Debug.console("nodeChar1: ", nodeChar);

		DB.setValue(nodeChar, "pcclasslink", "windowreference", sClass, sRecord);
--		Debug.console("setClass!", DB.getValue(DB.getPath(nodeSource) .. ".name"));
		nodeChar.getChild("pcclass").setValue(DB.getValue(nodeSource, "name", ""));
		local nCurLevel = tonumber(DB.getValue(nodeChar, "pcclasslevel", "number"));
		nodeChar.getChild("pcclasslevel").setValue(nCurLevel + 1);
		
end;

function addClassLevel(nodeChar, sClass, sRecord, nLevel)
	local nodeSource = resolveRefNode(sRecord);

		Debug.console("nodeChar: ", nodeChar);
		Debug.console("sClass: ", sClass);
		Debug.console("sRecord: ", sRecord);
	local nLevel = DB.getValue(nodeChar, "pcclasslevel", "number");
		Debug.console("nLevel: ", nLevel);

	if not nodeSource then
		return;
	end
	local nodeActor = nodeChar.getParent().getParent();

	local sClassName = DB.getValue(nodeSource, "name", "");
		Debug.console("sClassName: ", sClassName);
	local sClassDesc = DB.getValue(nodeSource, "classdesc", "");
		Debug.console("sClassDesc: ", sClassDesc);
	local nXPNeeded = 0;

	for _,vAdvancement in pairs(DB.getChildren(nodeSource, "advancement")) do
		Debug.console("vAdvancement: ", vAdvancement);
		Debug.console("nClassLevel: ", DB.getValue(vAdvancement, "pcclasslevel", "number"));
	--	local nClassLevel = vAdvancement.pcclasslevel.getValue();
		local nClassLevel = DB.getValue(vAdvancement, "pcclasslevel", "number");
		if nLevel == nClassLevel then
			nXPNeeded = DB.getValue(vAdvancement, "expneeded", 0);
			sXPEnabled = DB.getValue(vAdvancement, "expneeded_enabled");
			Debug.console("nXPNeeded: ", nXPNeeded, sXPEnabled);
			Debug.console("expneeded: ", nodeChar.getChild("expneeded"));
			DB.setValue(nodeChar, "expneeded", "number", nXPNeeded);
			sHealth = DB.getValue(vAdvancement, "pcclasshealth", 0);
			sHealthEnabled = DB.getValue(vAdvancement, "pcclasshealth_enabled");
			Debug.console("sHealth: ", sHealth, sHealthEnabled);
			sOption1 = DB.getValue(vAdvancement, "pcclassoption1");
			sOptionEnabled1 = DB.getValue(vAdvancement, "pcclassoption1_enabled");
			Debug.console("sOption1: ", sOption1, sOptionEnabled1);
			sOption2 = DB.getValue(vAdvancement, "pcclassoption2");
			sOptionEnabled2 = DB.getValue(vAdvancement, "pcclassoption2_enabled");
			Debug.console("sOption2: ", sOption2, sOptionEnabled2);
			sOption3 = DB.getValue(vAdvancement, "pcclassoption3");
			sOptionEnabled3 = DB.getValue(vAdvancement, "pcclassoption3_enabled");
			Debug.console("sOption3: ", sOption3, sOptionEnabled3);
			sOption4 = DB.getValue(vAdvancement, "pcclassoption4");
			sOptionEnabled4 = DB.getValue(vAdvancement, "pcclassoption4_enabled");
			Debug.console("sOption4: ", sOption4, sOptionEnabled4);
			sOption5 = DB.getValue(vAdvancement, "pcclassoption5");
			sOptionEnabled5 = DB.getValue(vAdvancement, "pcclassoption5_enabled");
			Debug.console("sOption5: ", sOption5, sOptionEnabled5);
			sOption6 = DB.getValue(vAdvancement, "pcclassoption6");
			sOptionEnabled6 = DB.getValue(vAdvancement, "pcclassoption6_enabled");
			Debug.console("sOption6: ", sOption6, sOptionEnabled6);
		end
	end

	DB.setValue(nodeChar, "expneeded", "number", nXPNeeded);

		local sName = DB.getValue(nodeChar, "name", "string");
		Debug.console("sName: ", sName);
		Debug.console("nodeChar: ", nodeChar);

		msg = {font = "msgfont", icon = "crown"};
		msg.text = sName .. " is now a Level " .. nLevel .. " " .. sClass .. " (done)."
		sLevelText = "<b>" .. sName .. " is now a Level " .. nLevel .. " " .. sClass .. "</b> (done)."

		msg.text = msg.text .. "\nYou require " .. nXPNeeded .. " experience for the next level.";
		sLevelText = sLevelText .. "\nYou require " .. nXPNeeded .. " experience for the next level.";

		if sHealthEnabled == 1 then
		msg.text = msg.text .. "\n" .. sHealth;
		sLevelText = sLevelText .. " " .. sHealth;
		end

		if sOptionEnabled1 == 1 then
		msg.text = msg.text .. "\n" .. sOption1;
		sLevelText = sLevelText .. " " .. sOption1;
		end

		if sOptionEnabled2 == 1 then
		msg.text = msg.text .. "\n" .. sOption2;
		sLevelText = sLevelText .. " " .. sOption2;
		end

		if sOptionEnabled3 == 1 then
		msg.text = msg.text .. "\n" .. sOption3;
		sLevelText = sLevelText .. " " .. sOption3;
		end

		if sOptionEnabled4 == 1 then
		msg.text = msg.text .. "\n" .. sOption4;
		sLevelText = sLevelText .. " " .. sOption4;
		end

		if sOptionEnabled5 == 1 then
		msg.text = msg.text .. "\n" .. sOption5;
		sLevelText = sLevelText .. " " .. sOption5;
		end

		if sOptionEnabled6 == 1 then
		msg.text = msg.text .. "\n" .. sOption6;
		sLevelText = sLevelText .. " " .. sOption6;
		end

		local sLog = DB.getValue(nodeChar, "levellog", 0);

		DB.setValue(nodeChar, "levellog", "formattedtext", sLog .. "<p>" .. sLevelText .. "</p>");
		Comm.deliverChatMessage(msg);



end

function addRaceDB(nodeChar, sClass, sRecord)

	
local nodeSource = resolveRefNode(sRecord);
    Debug.console("nodeSource3:", nodeSource);
    if not nodeSource then
        return;
    end

--	Debug.chat("nodeSource name: ", DB.getValue(nodeSource, "name", ""));

		DB.setValue(nodeChar, "pcracelink", "windowreference", sClass, sRecord);
	--	Debug.chat("setRace!", DB.getValue(DB.getPath(nodeSource) .. ".name"));
		nodeChar.getChild("pcrace").setValue(DB.getValue(nodeSource, "name", ""));

-- Add Race stats



			sOption1 = DB.getValue(DB.getPath(nodeSource) .. ".pcraceoption1");
--			Debug.chat("sOption1: ", sOption1);
			sOptionEnabled1 = DB.getValue(DB.getPath(nodeSource) .. ".pcraceoption1_enabled");
--			Debug.chat("sOption1: ", sOption1, sOptionEnabled1);
			sOption2 = DB.getValue(DB.getPath(nodeSource) .. ".pcraceoption2");
--			Debug.chat("sOption2: ", sOption2);
			sOptionEnabled2 = DB.getValue(DB.getPath(nodeSource) .. ".pcraceoption2_enabled");
--			Debug.chat("sOption2: ", sOption2, sOptionEnabled2);
			sOption3 = DB.getValue(DB.getPath(nodeSource) .. ".pcraceoption3");
--			Debug.chat("sOption3: ", sOption3);
			sOptionEnabled3 = DB.getValue(DB.getPath(nodeSource) .. ".pcraceoption3_enabled");
--			Debug.chat("sOption3: ", sOption3, sOptionEnabled3);
			sOption4 = DB.getValue(DB.getPath(nodeSource) .. ".pcraceoption4");
--			Debug.chat("sOption4: ", sOption4);
			sOptionEnabled4 = DB.getValue(DB.getPath(nodeSource) .. ".pcraceoption4_enabled");
--			Debug.chat("sOption4: ", sOption4, sOptionEnabled4);
			sOption5 = DB.getValue(DB.getPath(nodeSource) .. ".pcraceoption5");
			sOptionEnabled5 = DB.getValue(DB.getPath(nodeSource) .. ".pcraceoption5_enabled");
--			Debug.chat("sOption5: ", sOption5, sOptionEnabled5);
			sOption6 = DB.getValue(DB.getPath(nodeSource) .. ".pcraceoption6");
			sOptionEnabled6 = DB.getValue(DB.getPath(nodeSource) .. ".pcraceoption6_enabled");
--			Debug.chat("sOption6: ", sOption6, sOptionEnabled6);

		local sName = DB.getValue(nodeChar, "name", "string");
		Debug.console("sName: ", sName);
		Debug.console("nodeChar: ", nodeChar);

		msg = {font = "msgfont", icon = "crown"};
		msg.text = "We welcome the " .. DB.getValue(DB.getPath(nodeSource) .. ".name") .. " " .. sName;
		sLevelText = "<b>We welcome the " .. DB.getValue(DB.getPath(nodeSource) .. ".name") .. " " .. sName .. ".</b>";

		if sOptionEnabled1 == 1 then
		msg.text = msg.text .. "\n" .. sOption1;
		sLevelText = sLevelText .. " " .. sOption1;
		end

		if sOptionEnabled2 == 1 then
		msg.text = msg.text .. "\n" .. sOption2;
		sLevelText = sLevelText .. " " .. sOption2;
		end

		if sOptionEnabled3 == 1 then
		msg.text = msg.text .. "\n" .. sOption3;
		sLevelText = sLevelText .. " " .. sOption3;
		end

		if sOptionEnabled4 == 1 then
		msg.text = msg.text .. "\n" .. sOption4;
		sLevelText = sLevelText .. " " .. sOption4;
		end

		if sOptionEnabled5 == 1 then
		msg.text = msg.text .. "\n" .. sOption5;
		sLevelText = sLevelText .. " " .. sOption5;
		end

		if sOptionEnabled6 == 1 then
		msg.text = msg.text .. "\n" .. sOption6;
		sLevelText = sLevelText .. " " .. sOption6;
		end

		local sLog = DB.getValue(nodeChar, "levellog", 0);

		DB.setValue(nodeChar, "levellog", "formattedtext", sLog .. "<p>" .. sLevelText .. "</p>");
		Comm.deliverChatMessage(msg);
		
end;



