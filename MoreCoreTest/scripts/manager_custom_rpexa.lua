local sCmd = "rpexa";

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

---
--- This function creates the roll object based on the parameters sent in
---
function createRoll(sParams)
	local rRoll = {};
	rRoll.sType = "rpexa";
	rRoll.nSize = 10;
	rRoll.nMod = 0;
	rRoll.aDice = {};
	
    -- Grab discription. 
	local nStart, nEnd, sDicePattern, sDescriptionParam = string.find(sParams, "([^%s]+)%s*(.*)");
	rRoll.sDesc = sDescriptionParam;
	
	if string.find(sDescriptionParam, "Damage" ) then
		isDamageRoll = 1
	else
		isDamageRoll = 0
	end
	
	-- If no target number is specified, we will assume it is 7
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

	return rRoll, isDamageRoll;
end

---
--- This function steps through each die result and checks if it is greater than or equal to the success target number
--- adding to the success count if it is.
---
function dropDiceResults(rRoll, isDamageRoll)
	local nSuccessLevel = tonumber(rRoll.nSuccessLevel) or 7; --Standard difficulty in Exalted is 7
	local nSuccesses = 0;
    local nFailLevel = tonumber(rRoll.nFailLevel);
    local nFails = 0;
    local nPassFailText = "";
    local nResult = 0;
    local nModUpdate = ModifierStack.getSum();

    --Reset ModStack after use.
    ModifierStack.reset();
	
    --If SuccessLevel is > 10 then remove successes and set successLevel to 10.
    --If SuccessLevel is < 2 set it to 2.
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
		if (v.result == 10) and (isDamageRoll == 0) then
			nSuccesses = nSuccesses + 1; --In Exalted rolled 10s are counted as two successess.
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
    
	return rRoll
end

---
--- This function creates a chat message that displays the results.
---
function createChatMessage(rSource, rRoll)	
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
--	Debug.console("rSource: ");
--	Debug.console(rSource);
--	Debug.console("rMessage: " .. rMessage.text);
	rMessage.text = rMessage.text .. "\nDiff = "..rRoll.successLevel..", Success = " .. rRoll.successes .. "\n" .. rRoll.passFailText .. " ("..rRoll.result..")" .. "\n";
	
	local dicelisttmp = {};
	for k,v in pairs (rRoll.aDice) do
		table.insert(dicelisttmp,v);
	end
		
--	table.sort(dicelisttmp,diecomp);
		
	rMessage.dice = dicelisttmp;
	
	return rMessage;
end

function diecomp(d1,d2)
  return d1.result<d2.result;
end

---
--- This function creates the help text message for output.
---
function createHelpMessage()	
	local rMessage = ChatManager.createBaseMessage(nil, nil);
	rMessage.text = rMessage.text ..    "The \"/rpexa\" command is used to roll a set of d10s against a Difficulty Number. " ..
                                        "The Result will return the number of Successes. Rolled 10s are counted as two Successes and rolled 1s do not reduce number of Successes. \n"..
										"However, if there are no Successes rolled and at least one of the dice comes up as a 1, then it is a Botch. \n"..
                                        "The \"/rpexa\" command has the format of \"#s#\":\n".. 
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
		rRoll = dropDiceResults(rRoll, isDamageRoll);
		rMessage = createChatMessage(rSource, rRoll);
		rMessage.type = "dice";
		Comm.deliverChatMessage(rMessage);
end