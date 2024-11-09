local sCmd = "vda";

---
--- Initialization
---
function onInit()
  CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, false, "all");
end

---
---	This is the function that is called when the successes slash command is called.
---
function performAction(draginfo, rActor, sParams)
-- Debug.chat("14 performaAction");
	if not sParams or sParams == "" then 
		createHelpMessage();
		return;
	end

	if sParams == "?" or string.lower(sParams) == "help" then
		createHelpMessage();		
	else
		local rRoll = createRoll(sParams);
		ActionsManager.performAction(draginfo, rActor, rRoll);
	end		
end

function createExpRoll(numExp,origDesc)
-- Debug.chat("29 createExpRoll");
	local rRoll = {};
	rRoll.sType = "vda";
	rRoll.sDesc = origDesc
	rRoll.sTens = "Rerolled TENs"
    rRoll.nSize = 10;
	rRoll.nMod = 0;
	rRoll.aDice = {};
	local count = numExp;
	
	-- Set dice into Table.
	while count > 0 do
		table.insert(rRoll.aDice, "d" .. rRoll.nSize);
		count = count - 1;
	end

	return rRoll

end
	
---
--- This function creates the roll object based on the parameters sent in
---
function createRoll(sParams)
-- Debug.chat("53 createRoll");
	local rRoll = {};
	rRoll.sType = "vda";
	rRoll.nSize = 10;
	rRoll.nMod = 0;
	rRoll.aDice = {};
	
    -- Grab discription. 
	local nStart, nEnd, sDicePattern, sDescriptionParam = string.find(sParams, "([^%s]+)%s*(.*)");
	rRoll.sDesc = sDescriptionParam;
	
	if string.find(sDescriptionParam, "Damage" ) then
		rRoll.sTens = "No Reroll"
	end
	
	-- If no target number is specified, we will assume it is 6
    --I don't think this step is needed. 
--    if(not sDicePattern:match("(%d+)s(%d+)") and sDicePattern:match("(%d+)%s*(.*)")) then
--		sDicePattern = sDicePattern .. " 6"
--	end
	
	-- Now we check that we have a properly formatted parameter, or we set the sDesc for the roll with a message.
	if not sDicePattern:match("(%d+)s(%d+)") then
		rRoll.sDesc = "Parameters not in correct format. Should be in the format of \"#s#\"";
		return rRoll;
	end

    -- Grab # in the argument and assign them.
	local sNum, sSuccessLevel = sDicePattern:match("(%d+)s(%d+)");
	local count = tonumber(sNum);
    local nSuccessLevel = tonumber(sSuccessLevel);
    
    -- Set dice into Table.
	while count > 0 do
		table.insert(rRoll.aDice, "d" .. rRoll.nSize);
		
--		-- For d100 rolls, we also need to add a d10 dice for the ones place
--		if sSize == "100" then
--			table.insert(rRoll.aDice, "d10");
--		end
		count = count - 1;
	end
	
    --Pass gathered info. 
	
    rRoll.nSuccessLevel = nSuccessLevel;
    rRoll.nFailLevel = 1;

	return rRoll;
end

---
--- This function steps through each die result and checks if it is greater than or equal to the success target number
--- adding to the success count if it is.
---
function dropDiceResults(rRoll)
-- Debug.chat("110 dropDiceResults");
	local nSuccessLevel = tonumber(rRoll.nSuccessLevel) or 6;
	local nSuccesses = 0;
    local nFailLevel = tonumber(rRoll.nFailLevel);
    local nFails = 0;
    local nPassFailText = "";
    local nResult = 0;
    local nModUpdate = ModifierStack.getSum();
	local nTens = 0;

    --Reset ModStack after use.
    ModifierStack.reset();
	
    --If SuccessLevel is > 9 then remove successes and set successLevel to 9.
    --If SuccessLevel is < 3 set it to 3.
    nSuccessLevel = nSuccessLevel + nModUpdate; --Yes I am using this non-standardly. This is because adding values to the end doesn't makes sense on these types of dice.
    if nSuccessLevel > 10 then
        nSuccessLevel = 10;
    elseif nSuccessLevel < 2 then
        nSuccessLevel = 2;
    end

    --Roll the dice and count up successes and fails
	for k,v in ipairs(rRoll.aDice) do
		if v.result >= nSuccessLevel then
			nSuccesses = nSuccesses + 1;
			rRoll.aDice[k].type = "g10"
		elseif v.result <= nFailLevel then
			nFails = nFails + 1;
			rRoll.aDice[k].type = "r10"
		end
		if v.result == 10 then
			nTens = nTens + 1;
		end
	end
    
    --Calc Result
    nResult = nSuccesses;

    --Set Result Text.
    if nSuccesses <= 0 then
        if nFails > 0 then
            nPassFailText = "Botch!";
        else
            nPassFailText = "Fail";
        end
    else
        nPassFailText = "Success!";
    end
     
     --Pass gathered info. 
	rRoll.successLevel = nSuccessLevel;
	rRoll.successes = nSuccesses;
    rRoll.fails = nFails;
    rRoll.passFailText = nPassFailText;
    rRoll.result = nResult;
	rRoll.failLevel = nFailLevel
    
	return rRoll, nTens;
end

---
--- This function creates a chat message that displays the results.
---
function createChatMessage(rSource, rRoll)	
-- Debug.chat("174 createChatMessage");
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
--	Debug.console("rSource: ");
--	Debug.console(rSource);
--	Debug.console("rMessage: " .. rMessage.text);
	rMessage.text = rMessage.text .. "\nDiff = "..rRoll.successLevel..", Success = " .. rRoll.successes .. ", Fail = " .. rRoll.fails .."\n" .. rRoll.passFailText .. " ("..rRoll.result..")" .. "\n";
	
	local dicelisttmp = {};
	for k,v in pairs (rRoll.aDice) do
		table.insert(dicelisttmp,v);
	end
		
	table.sort(dicelisttmp,diecomp);
		
	rMessage.dice = dicelisttmp;
	
	return rMessage;
end

function diecomp(d1,d2)
  return d1.result<d2.result;
end

function createExpChatMessage(rSource, rRoll)	
-- Debug.chat("199 createExpChatMessage");
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
	local nSuccesses = tonumber(rRoll.successes);
	local aSuccesses = 0;
	local aFails = 0;

	for k,v in ipairs(rRoll.aDice) do
		if v.result >= tonumber(rRoll.successLevel) then
			aSuccesses = aSuccesses + 1;
			rRoll.aDice[k].type = "g10"
		elseif v.result <= tonumber(rRoll.failLevel) then
			aFails = aFails + 1;
			rRoll.aDice[k].type = "r10"
		end
	end

	for k,v in pairs (firstroll) do
		table.insert(rRoll.aDice,v)
	end

	local dicelisttmp = {};
	for k,v in pairs (rRoll.aDice) do
		table.insert(dicelisttmp,v);
	end
		
	table.sort(dicelisttmp,diecomp);
		
	rMessage.dice = dicelisttmp;

	rMessage.text = rMessage.text .. "\nDiff = "..rRoll.successLevel..", Success = " .. rRoll.successes + aSuccesses .. ", Fail = " .. rRoll.fails + aFails .."\n" .. rRoll.passFailText .. " (" .. rRoll.result + aSuccesses .. ")" .. "\n";

--	if aSuccesses > 0 then
--		if aSuccesses == 1 then
--			rMessage.text = rMessage.text .. "\n+" .. aSuccesses .." success from rerolls.\nTotal successes: " .. rRoll.successes + aSuccesses;
--		else
--			rMessage.text = rMessage.text .. "\n+" .. aSuccesses .." successes from rerolls.\nTotal successes: " .. rRoll.successes + aSuccesses;
--		end
--	else
--		rMessage.text = rMessage.text .. "\nTotal success(es): " .. rRoll.successes;
--	end

	return rMessage;
end

---
--- This function creates the help text message for output.
---
function createHelpMessage()	
-- Debug.chat("246 createHelpMessage");
	local rMessage = ChatManager.createBaseMessage(nil, nil);
	rMessage.text = rMessage.text ..    "The \"/vda\" command is used to roll a set of d10s against a Difficulty Number. " ..
                                        "The Result will return the number of Successes. Rolled 10s are exploded once and rolled 1s do not reduce number of Successes. \n"..
										"However, if there are no Successes rolled and at least one of dice comes up as a 1, then it is a Botch. \n"..
                                        "The \"/vda\" command has the format of \"#s#\":\n".. 
                                        "The first # is the number of dice (d10s). The second # is the target Difficulty Number. Example: 5s6 will return a success on any "..
                                        "dice 6+ and will return a fail on any dice with a 1.\n"..
                                        "Lastly, the Modifier Stack works differently for this dice command than normal. A '+1' on the mod stack will increase the Difficulty Number by 1."..
                                        "a '-2' will decrease the difficulty by 2. Example: 5s6 with a Mod of '-2' will return a success on any dice 4+. The Difficulties are limited from 2 to 10.";
	Comm.deliverChatMessage(rMessage);
end

---
--- This is the callback that gets triggered after the roll is completed.
---
function onLanded(rSource, rTarget, rRoll)
-- Debug.chat("263 onLanded");
	if rRoll.sTens == "Rerolled TENs" then
		rMessage = createExpChatMessage(rSource, rRoll);
		rMessage.type = "dice";
		Comm.deliverChatMessage(rMessage);	
	else
		rRoll, nTens = dropDiceResults(rRoll);
		if rRoll.sTens == "No Reroll" then
			nTens = 0
		end
		if nTens > 0 then
			local reRolled = createExpRoll(nTens,rRoll.sDesc);
			reRolled.successLevel = rRoll.successLevel;
			reRolled.successes = rRoll.successes;
			reRolled.fails = rRoll.fails
			reRolled.passFailText = rRoll.passFailText
			reRolled.result = rRoll.result
			reRolled.failLevel = rRoll.failLevel
			firstroll = {}
			firstroll = rRoll.aDice
--			for k,v in pairs (rRoll.aDice) do
--				table.insert(reRolled.firstroll,v)
--			end
			ActionsManager.performAction(draginfo, rActor, reRolled);
		else
			rMessage = createChatMessage(rSource, rRoll);
			rMessage.type = "dice";
			Comm.deliverChatMessage(rMessage);
		end
	end
end