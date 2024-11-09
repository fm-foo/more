-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

-- MoreCore v0.60 register "vermine"

local sCmd = "vermine";

function onInit()
	CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all", nil, nil, onDiceTotal)
end

function performAction(draginfo, rActor, sParams)
--	Debug.chat("16");
Debug.console("performAction: ", draginfo, rActor, sParams);
  local rRoll = createRoll(sParams);
  ActionsManager.performAction(draginfo, rActor, rRoll);
Debug.console("performAction: ", rRoll);
end   


---
--- This function creates the roll object based on the parameters sent in
---
function createRoll(sParams)
--	Debug.chat("28");
  local rRoll = {};
  rRoll.sType = sCmd;
  rRoll.nMod = 0;
  -- Removed to allow ChatManager.createBaseMessage function to create the right name - active character or player name if no characters are active.
  --rRoll.sUser = User.getUsername();
  rRoll.aDice = {};

  -- Now we check that we have a properly formatted parameter, or we set the sDesc for the roll with a message.

  if not sParams:match("(%d+)%s(.*)") then
    rRoll.sDesc = "Parameters not in correct format. Should be in the format of \"# <desc>\"";
    return rRoll;
  end
  
	local sDesc1, nMod = ModifierStack.getStack(true);
--	Debug.chat("nMod: ", nMod);
	if nMod == 0 then
		nMod = 5; end

	if nMod < 5 then sDifficulty = "Simple Action";
	elseif nMod < 7 then sDifficulty = "Easy Action";
	elseif nMod < 9 then sDifficulty = "Difficult Action";
	elseif nMod < 10 then sDifficulty = "Very Difficult Action";
	else sDifficulty = "Impossible Action";
	end

	local sDice, sDesc = sParams:match("([^%s]+)%s*(.*)");
--	Debug.chat("sDice, sDesc, sParams: ", sDice, sDesc, sParams);
-- Build a table of rolls, split by the + signs between them
	local sDelim = "+"
	local aDielist = StringManager.split(sDice, sDelim, 1);
--	Debug.chat("aDielist: ", aDielist);

	local nDice = 0;
		for k,v in pairs(aDielist) do
			nDice = nDice + v
		--	Debug.chat("nDice: ", nDice);
		end
	

	if nDice <= 0 then
		nDice = 1;
	end	
	sDice = nDice .. "d10";
-- Now roll them
	local aDice = StringManager.convertStringToDice(sDice);

	rRoll.sDesc = sDesc;
	rRoll.aDice = aDice;
	rRoll.nMod = nMod;
	rRoll.sDifficulty = sDifficulty;
	
--	Debug.chat("sDesc: ", sDesc, " aDice: ", aDice, " nMod: ", nMod);
  return rRoll;
end


---
--- This function steps through each die result and checks if it is greater than or equal to the success target number
--- adding to the success count if it is.
---
function countSuccesses(rRoll)
--	Debug.chat("65");
  -- Sort rRoll.aDice table based off a.result (the dice result)
		local nSuccessess = 0;
		for _,v in ipairs(rRoll.aDice) do
	if (v.result >= rRoll.nMod) then
		nSuccessess = nSuccessess + 1;
		end
	--	Debug.chat("nSuccessess: ", nSuccessess);
	end

--	Debug.chat("nSuccessess final: ", nSuccessess);
  
  rRoll.nSuccessess = nSuccessess;
  return rRoll;
end

---
--- This function creates a chat message that displays the results.
---
function createChatMessage(rSource, rRoll)  
--	Debug.chat("85");
  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
    rMessage.dicedisplay = 1; -- display total

  rMessage.text = rMessage.text .. " vs " .. rRoll.sDifficulty .. "\n# Successes = " .. rRoll.nSuccessess;
  
  return rMessage;
end

---
--- This function creates the help text message for output.
---
function createHelpMessage()  
  local rMessage = ChatManager.createBaseMessage(nil, nil);
  rMessage.text = rMessage.text .. "The \"/successes\" command is used to roll a set of dice and report the number of dice that meet or exceed a success target number.\n"; 
  rMessage.text = rMessage.text .. "You can specify the number of dice to roll, the type of dice, and the success target number"; 
  rMessage.text = rMessage.text .. "by supplying the \"/successes\" command with parameters in the format of \"#d# #\", where the first # is the "; 
  rMessage.text = rMessage.text .. "number of dice to be rolled, the second number is the number of dice sides, and the number following the "; 
  rMessage.text = rMessage.text .. "space being the success target number for each dice."; 
  Comm.deliverChatMessage(rMessage);
end

function onDiceTotal( messagedata )
--	Debug.chat("108");
	local sMyTotal = string.match(messagedata.text, "sses...(%d+)");
  Debug.console("onDiceTotal: ", sMyTotal, messagedata);
  return true, tonumber(sMyTotal);
end

---
--- This is the callback that gets triggered after the roll is completed.
---
function onLanded(rSource, rTarget, rRoll)
--	Debug.chat("118");
  rRoll = countSuccesses(rRoll);
Debug.console("performAction: ", rRoll);
  rMessage = createChatMessage(rSource, rRoll);
Debug.console("performAction: ", rMessage);
  rMessage.type = sCmd;
  Comm.deliverChatMessage(rMessage);
end
