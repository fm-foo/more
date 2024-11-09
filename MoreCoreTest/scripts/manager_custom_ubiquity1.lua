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
function createRoll1(sParams)
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
	Debug.chat("sDice", sDice);

  if sDice:match("(%d+)d6+(%d+)d6+(%d+)d6") then
    nCount1, nCount2, nCount3 = sParams:match("(%d+)d6+(%d+)d6+(%d+)d6");
	Debug.chat("match3: ", nCount1, nCount2, nCount3);
  elseif sDice:match("(%d+)d6+(%d+)d6") then
    nCount1, nCount2 = sParams:match("(%d+)d6+(%d+)d6");
	nCount3 = 0;
	Debug.chat("match2: ", nCount1, nCount2, nCount3);
  elseif sDice:match("(%d+)d6") then
    nCount1 = sParams:match("(%d+)d6");
	nCount2 = 0;
	nCount3 = 0;
	Debug.chat("match1: ", nCount1, nCount2, nCount3);
  else
	Debug.chat("no match1");
  end


	local sDesc1, nMod = ModifierStack.getStack(true);

	local sDice = sDice .. "+" .. nMod .. "d6";
	local aDice = StringManager.convertStringToDice(sDice);

	rRoll.sDesc = sDesc .. " " .. sDesc1;
	Debug.chat("rRoll.sDesc", rRoll.sDesc);
	Debug.chat("aDice", aDice);
	Debug.chat("nMod", nMod);

	rRoll.aDice = aDice;
  return rRoll;
end

function createRoll(sParams)
  local rRoll = {};
  rRoll.sType = sCmd;
  rRoll.nMod = 0;
  rRoll.aDice = {};
  
   if sParams:match("([^%s+]+)+([^%s+]+)+([^%s+]+)%s(.*)") then
-- 	Debug.chat("three");
	sCount1, sCount2, sCount3, sDesc = sParams:match("([^%s+]+)+([^%s+]+)+([^%s+]+)%s(.*)");
	nCount1 = tonumber(sCount1);
	nCount2 = tonumber(sCount2);
	nCount3 = tonumber(sCount3);
--	Debug.chat("three: ", nCount1, nCount2, nCount3, sDesc);
   elseif sParams:match("([^%s+]+)+([^%s+]+)%s(.*)") then
--	Debug.chat("two");
	sCount1, sCount2, sDesc = sParams:match("([^%s+]+)+([^%s+]+)%s(.*)");
	nCount1 = tonumber(sCount1);
	nCount2 = tonumber(sCount2);
	nCount3 = 0;
--	Debug.chat("two: ", nCount1, nCount2, nCount3, sDesc);
   elseif sParams:match("([^%s+]+)%s(.*)") then
--	Debug.chat("one");
	sCount1, sDesc = sParams:match("([^%s+]+)%s(.*)");
	nCount1 = tonumber(sCount1);
	nCount2 = 0;
	nCount3 = 0;
--	Debug.chat("one: ", nCount1, nCount2, nCount3, sDesc);
   end
 
	nCount = nCount1+nCount2+nCount3;
--	Debug.chat("nCount", nCount);

	local sDesc1, nMod = ModifierStack.getStack(true);
	nDice = nCount+nMod;
	sDice = nDice.. "d6";
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
