---
--- Initialization
---
function onInit()
	Comm.registerSlashHandler("cstun", processRoll);
	GameSystem.actions["cstun"] = { bUseModStack = false };
	ActionsManager.registerResultHandler("cstun", onRoll);

	-- send launch message
--	local msg = {sender = "", font = "emotefont"};
--	msg.text = "Success count extension for CoreRPG based Rulesets.  v1.0 by Trenloe.  Based on DMFirmy's Drop Lowest extension. Type \"/cstun ?\" for usage.";
--	ChatManager.registerLaunchMessage(msg);
end

---
---	This is the function that is called when the cstun slash command is called.
---
function processRoll(sCommand, sParams)
	if not sParams or sParams == "" then 
		createHelpMessage();
		return;
	end

	if sParams == "?" or string.lower(sParams) == "help" then
		createHelpMessage();		
	else
		local rRoll = createRoll(sParams);
		ActionsManager.roll(nil, nil, rRoll);
	end		
end

---
--- This function creates the roll object based on the parameters sent in
---
function createRoll(sParams)
	local rRoll = {};
	rRoll.sType = "cstun";
	rRoll.nMod = 0;
---	rRoll.sUser = User.getUsername();
	rRoll.aDice = {};
	
	local nStart, nEnd, sDicePattern, sDescriptionParam = string.find(sParams, "([^%s]+)%s*(.*)");
	rRoll.sDesc = sDescriptionParam;

	-- If no target number is specified, we will assume it is 0
	if(not sDicePattern:match("(%d+)d([%dF]*)x(%d+)") and sDicePattern:match("(%d+)d([%dF]+)%s*(.*)")) then
		sDicePattern = sDicePattern .. " 0"
	end
	
	-- Now we check that we have a properly formatted parameter, or we set the sDesc for the roll with a message.
	if not sDicePattern:match("(%d+)d([%dF]*)") then
		rRoll.sDesc = "Parameters not in correct format. Should be in the format of \"#d#\"";
		return rRoll;
	end

	local sNum, sSize = sDicePattern:match("(%d+)d([%dF]+)");
	local count = tonumber(sNum);
	local nBody = tonumber(sNum);

Debug.console("count1: ", count);
Debug.console("nBody1: ", nBody);
	
	while count > 0 do
		table.insert(rRoll.aDice, "d" .. sSize);
		
		-- For d100 rolls, we also need to add a d10 dice for the ones place
		if sSize == "100" then
			  if Interface.getVersion() < 4 then
				table.insert(rRoll.aDice, "d10");
			  end
		end
		count = count - 1;
	end
Debug.console("count2: ", count);
Debug.console("nBody2: ", nBody);

		rRoll.nBody = nBody;
	return rRoll;
end

---
--- This function steps through each die result and checks if it is greater than or equal to the success target number
--- adding to the success count if it is.
---
function dropDiceResults(rRoll)
Debug.console("count3: ", count);
Debug.console("nBody3: ", rRoll.nBody);
	local nBody = tonumber(rRoll.nBody);
Debug.console("nBody4: ", nBody);
	local nAces = 0;
	local nSixes = 0;
	local nStun = 0;
	local nCount = 0;
	Debug.console("nCount1: ", nCount);
	for _,v in ipairs(rRoll.aDice) do
		if v.result == 1 then
			nBody = nBody - 1;
			nAces = nAces + 1;
			nStun = nStun + v.result;
			nCount = nCount + 1;
	Debug.console("nCountAce: ", nCount);
			elseif v.result == 6 then
				nBody = nBody + 1;
				nSixes = nSixes + 1;
				nStun = nStun + v.result;
				nCount = nCount + 1;
	Debug.console("nCount6: ", nCount);
				else
					nBody = nBody;
					nStun = nStun + v.result;
			nCount = nCount + 1;
					Debug.console("nCountOther: ", nCount);
		end
	end
	
	rRoll.nBody = nBody;
	rRoll.nAces = nAces;
	rRoll.nSixes = nSixes;
	rRoll.nStun = nStun;
Debug.console("nBody5: ", nBody);
Debug.console("nAces: ", nAces);
Debug.console("nSixes: ", nSixes);
Debug.console("nStun: ", nStun);

	return rRoll;
end

---
--- This function creates a chat message that displays the results.
---
function createChatMessage(rSource, rRoll)	
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
    rMessage.dicedisplay = 0; -- don't display total
	Debug.console("rSource: ", rSource);
	Debug.console("rRoll: ", rRoll);
	Debug.console("rMessage: " .. rMessage.text);
	rMessage.text = rMessage.text .. "\n[Aces] " .. rRoll.nAces .. " [Sixes] " .. rRoll.nSixes .. "\n[BODY Damage] " .. rRoll.nBody .. "\n[STUN Damage] " .. rRoll.nStun;
	
	return rMessage;
end

---
--- This function creates the help text message for output.
---
function createHelpMessage()	
	local rMessage = ChatManager.createBaseMessage(nil, nil);
	rMessage.text = rMessage.text .. "The \"/successes\" command is used to roll a set of dice and report the number of dice that meet or exceed a success target number.\n"; 
	rMessage.text = rMessage.text .. "You can specify the number of dice to roll, the type of dice, and the success target number"; 
	rMessage.text = rMessage.text .. "by supplying the \"/successes\" command with parameters in the format of \"#d#x#\", where the first # is the "; 
	rMessage.text = rMessage.text .. "number of dice to be rolled, the second number is the number of dice sides, and the number following the "; 
	rMessage.text = rMessage.text .. "x being the success target number for each dice."; 
	Comm.deliverChatMessage(rMessage);
end

---
--- This is the callback that gets triggered after the roll is completed.
---
function onRoll(rSource, rTarget, rRoll)
	rRoll = dropDiceResults(rRoll);
	rMessage = createChatMessage(rSource, rRoll);
	rMessage.type = "dice";
	Comm.deliverChatMessage(rMessage);
end