-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

-- MoreCore v0.60 register "ubiquity"

local sCmd = "ubiquity";

function onInit()
--  CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all");
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

  if not sParams:match("(%d+)d([%dF]*)%s(.*)") then
    rRoll.sDesc = "Parameters not in correct format. Should be in the format of \"#d# <desc>\"";
    return rRoll;
  end
  

	local sDice, sDesc = sParams:match("([^%s]+)%s*(.*)");
--	Debug.chat("sDice, sDesc, sParams: ", sDice, sDesc, sParams);
-- grab the modifier stack, to apply below
	local sDesc1, nMod = ModifierStack.getStack(true);
-- Build a table of rolls, split by the + signs between them
	local sDelim = "+"
	local aDielist = StringManager.split(sDice, sDelim, 1);
--	Debug.chat("aDielist: ", aDielist);
--Loop through the table of rolls.  For each roll, split off and discard the "d#" portion of the roll, leaving only the number of dice to roll.  
	local nDice = 0;
	local i = 1;
	for i =1, #aDielist do
		local sTest = aDielist[i];
		-- get the number of dice from the roll, plus the character "d"
		local sRawnumdie=StringManager.extractPattern(sTest, "(%d+)d");
		-- Get the length of the result.  The next 2 lines could probably be rewritten to work in one line, and not use the "nRawlen" variable.  But life is short, and this works. 
		local nRawlen = sRawnumdie:len();
		-- Cut off the last character (the "d"), now we have the number of dice for this portion of the dice equation.
		local sNumdie = sRawnumdie:sub(1, (nRawlen - 1));
		-- Convert the string representation of the number of dice to a number, and add it to the total number of dice.  
	    local nDie = tonumber(sNumdie);
		nDice = nDice+nDie;
	end;
-- Add the modifier stack to the number of dice to roll. In Ubiquity, modifiers add or subtract from the dice pool.
	nDice = nDice + nMod;
	
	if nDice <= 0 then
	rRoll.sDesc = "0 or negative dice rolled - no successes possible.";
    return rRoll;
  end	
-- Make all the dice d6's.  It really doesn't matter what dice you roll for Ubiquity, as long as there's an even number of successes and failures.  In this code we're defining even numbers as success and odds as failures, so as long as we don't use a d3 we're golden.
	sDice = nDice .. "d6";
-- Now roll them
	local aDice = StringManager.convertStringToDice(sDice);

	rRoll.sDesc = sDesc .. " " .. sDesc1;
	rRoll.aDice = aDice;
  return rRoll;
end


---
--- This function steps through each die result and checks if it is greater than or equal to the success target number
--- adding to the success count if it is.
---
function countEvens(rRoll)
--	Debug.chat("65");
  -- Sort rRoll.aDice table based off a.result (the dice result)
		local nSuccessess = 0;
		for _,v in ipairs(rRoll.aDice) do
	if (v.result % 2 == 0) then
		nSuccessess = nSuccessess + 1;
		end
		Debug.console("nSuccessess: ", nSuccessess);
	end

	Debug.console("nSuccessess final: ", nSuccessess);
  
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

  rMessage.text = rMessage.text .. "\n# Successes = " .. rRoll.nSuccessess;
  
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
  rRoll = countEvens(rRoll);
Debug.console("performAction: ", rRoll);
  rMessage = createChatMessage(rSource, rRoll);
Debug.console("performAction: ", rMessage);
  rMessage.type = sCmd;
  Comm.deliverChatMessage(rMessage);
end
