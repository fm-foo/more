-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local sCmd = "vaesen";

-- MoreCore v0.60 
function onInit()
  CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all", nil, nil, onDiceTotal)
  
end

function performAction(draginfo, rActor, sParams)
--	Debug.chat("performAction: ");
--Debug.console("performAction: ", draginfo, rActor, sParams);

  if sParams == "?" or string.lower(sParams) == "help" then
    createHelpMessage();    
  else
    local rRoll = createRoll(sParams);
--Debug.console("performAction: rRoll ", rRoll);
    ActionsManager.performAction(draginfo, rActor, rRoll);
  end   

end

function newDiceResults(rRoll)
--	Debug.chat("newDiceResults: ");
	local nSuccesses = 0;
	
	
	for _,v in ipairs(rRoll.aDice) do
		if v.result == 6 then
			nSuccesses = nSuccesses + 1;
		end
	end
	
	rRoll.rollover = nSuccesses;
--	Debug.chat("rRoll.aDice: ", rRoll.aDice);
--	Debug.chat("rRoll: ", rRoll);
	
	return rRoll;
end


function onLanded(rSource, rTarget, rRoll)
--	Debug.chat("onLanded: ", rSource, rTarget);
  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
  rRoll = newDiceResults(rRoll);
  rMessage = createChatMessage(rSource, rRoll);
  rMessage.type = sCmd;
  Comm.deliverChatMessage(rMessage);
end

function onDiceTotal( messagedata)
--  Debug.chat("onDiceTotal: ", messagedata);
	local sMyTotal = string.match(messagedata.text, "Successes]%s(%d+)");
	local nMyTotal = tonumber(sMyTotal);
--  local sGarbage, sSuccesses = string.match(messagedata.text, "([^[Successes]])%s*[Successes]%s*([^%s])%s*");
--  Debug.chat("sGarbage, sSuccesses: ", sGarbage, sSuccesses);
--  nSuccesses = tonumber(sSuccesses);
  return true, nMyTotal;
end

---
--- This function creates the roll object based on the parameters sent in
---
function createRoll(sParams)
--  Debug.chat("createRoll(sParams): ");
  local rRoll = { };
  rRoll.aDice = {};
  rRoll.sType = sCmd;
  rRoll.nMod = 0;
  rRoll.sDesc = "";
  rRoll.nTarget = 0;
--- rRoll.sUser = User.getUsername();

	local sDice, sDesc = string.match(sParams, "([^%s]+)%s*(.*)");
	rRoll.sDesc = sDescriptionParam;

	local aDice, nMod = StringManager.convertStringToDice(sDice);
--	local aFinalDice = {};
--	Debug.chat("aDice, nMod: ", aDice, nMod);
--	Debug.chat("aFinalDice: ", aFinalDice);

	local nDicePoolTotal = 0;
	local nDicePoolPlus = 0;
	local nDicePoolMinus = 0;
	for k,v in ipairs(aDice) do
--		Debug.chat("v.result: ", v.result, v);
		if v == "d6" then
			nDicePoolPlus = nDicePoolPlus + 1;
		elseif v == "-d6" then
			nDicePoolMinus = nDicePoolMinus + 1;
		end
--		Debug.chat("nDicePoolTotal: ", nDicePoolTotal);
	end

	nDicePoolTotal = nDicePoolPlus - nDicePoolMinus;
--	Debug.chat("nDicePoolTotals: ", nDicePoolPlus, nDicePoolMinus, nDicePoolTotal);
	local sDesc1, nMod = ModifierStack.getStack(true);

	nDicePoolTotal = nDicePoolTotal + nMod;
	if nDicePoolTotal < 1 then nDicePoolTotal = 1; end
--		Debug.chat("nDicePoolTotal1 ", nDicePoolTotal);



	aDice = {};
	i =  nDicePoolTotal;
	while i > 0 do
		table.insert(aDice, "d6");
		i = i - 1;
	end;
--	Debug.chat("aFinalDice: ", aDice);

  if sTarget then
    rRoll.nTarget = tonumber(sTarget);
    rRoll.sDesc = sDescriptionParam .. ", " .. sDesc1;
	else
		rRoll.sDesc = sParams .. ", " .. sDesc1;
  end
--Debug.console("createRoll: ",rRoll);
  
  rRoll.nDicePoolPlus = nDicePoolPlus;
  rRoll.nDicePoolMinus = nDicePoolMinus;
  rRoll.nDicePoolTotal = nDicePoolTotal;
  rRoll.nMod = nMod;
  rRoll.aDice = aDice;
  return rRoll;
end

---
--- This function creates a chat message that displays the results.
---
function createChatMessage(rSource, rRoll)  
  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

	local nDicePoolPlus = rRoll.nDicePoolPlus;
	local nDicePoolMinus = rRoll.nDicePoolMinus;
	local nDicePoolTotal = rRoll.nDicePoolTotal;
	local nMod = rRoll.nMod;

    local nSuccesses = 0;
    local nFails = 0;
    for k,v in ipairs(rRoll.aDice) do
        if v.result == 6 then
            nSuccesses = nSuccesses + 1;
			rRoll.aDice[k].type = "d2006";
        else nFails = nFails + 1;
        end
    end
	
    rMessage.dicedisplay = 1; -- display total

	if nDicePoolTotal == nil or nDicePoolTotal == 0 then 
		    rMessage.text = rMessage.text .. "\n[Successes] ".. nSuccesses .." [Push Dice Pool] ".. nFails;
	else 
			rMessage.text = rMessage.text .. "\n[Dice+] ".. nDicePoolPlus .." [Dice-] ".. nDicePoolMinus .." [Mod] ".. nMod;
			rMessage.text = rMessage.text .. "\n[Successes] ".. nSuccesses .." [Push Dice Pool] ".. nFails;
	end
	rMessage.nSuccesses = nSuccesses;

--	Debug.chat("rMessage: ", rMessage);
  return rMessage;
end

---
--- This function creates the help text message for output.
---
function createHelpMessage()  
  local rMessage = ChatManager.createBaseMessage(nil, nil);
  rMessage.text = rMessage.text .. "Usage: /"..sCmd.." <target> <message>\n"; 
  rMessage.text = rMessage.text .. "The \"/"..sCmd.."\" command is used to roll 3d10, ordering the results as m, C & M. "; 
  rMessage.text = rMessage.text .. "C accepts modifiers from the Modifier box. An optional target number can be provided which will be compared to C. A double or triple 1 is a fumble and a double or triple 10 is a critical success. "; 
  rMessage.text = rMessage.text .. "The result, along with a message is output to the chat window."; 
  Comm.deliverChatMessage(rMessage);
end
