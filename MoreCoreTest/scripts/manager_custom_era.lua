-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local sCmd = "era";

-- MoreCore v0.60 
function onInit()
--  CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all");
	CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all", nil, nil, onDiceTotal)
end

function performAction(draginfo, rActor, sParams)
--	Debug.console("performAction: ", draginfo, rActor, sParams);
  local sDice, sDesc = string.match(sParams, "([^%s]+)%s*(.*)");
	local nSuccesses = 0;
  
  local sModDesc, nMod = ModifierStack.getStack(true);
  
  local sNum, sSize, sTarget = sDice:match("(%d+)d([%dF]+)x(%d+)");
   
   if string.len(sModDesc) > 0 then 
		sDesc = sDesc .. ", " .. sModDesc;
	end
   
  local sDice = tonumber(sNum)+nMod .. "d" .. sSize;
    local rRoll = createRoll(sDice, sDesc);
	rRoll.nTarget = tonumber(sTarget);
	rRoll.nSuccesses = nSuccesses;
--  if sDice == nil or not StringManager.isDiceString(sDice) then
--    ChatManager.SystemMessage("Usage: /"..sCmd.." [dice+modifier] [description]");
--    return;
--  else
--    local rRoll = createRoll(sDice, sDesc);
    ActionsManager.performAction(draginfo, rActor, rRoll);
--  end   
end

function getDieMax(sType)
--	Debug.console("getDieMax: ", sType);
  local sDie = string.match(sType, "d(%d+)");
  if tonumber(sDie) > 1000 then
	tempmax = tonumber(sDie);
	while tempmax > 1000 do
		tempmax = tempmax - 1000;
	end
	else tempmax = tonumber(sDie);
	end
  max = tempmax;
  return max;  
end

function initLastDice(aDice)
  aSavedDice = {};
  for i , v in ipairs (aDice) do
    aSavedDice[i] = { type=v.type, result=0, exploded=true };
  end
  return aSavedDice;
end

function onLanded(rSource, rTarget, rRoll)
--  Debug.console("onLanded: ", rSource, rTarget, rRoll);
  
  local aDice = rRoll.aDice;

  -- get saved dice
  local aSavedDice = nil;
  if rRoll.aSavedDice then
    aSavedDice = Json.parse(rRoll.aSavedDice);
  else
    aSavedDice = initLastDice(aDice);
  end

  local aRerollDice = {};
  local j = 1; -- reRoll dice index
  local k = 1; -- aDice index

  for i , v in ipairs (aSavedDice) do
--    Debug.console("onLanded: last dice ", i, v);
    if v.exploded then
      w = aDice[k]; 
      k = k + 1; -- move on to next die for next time around
      v.result = v.result + w.result;
      if w.result == getDieMax(w.type) then
        aRerollDice[j] = w.type;
        j = j + 1;
        v.exploded = true;
      else
        v.exploded = false;
      end
    end
  end


  	local nTarget = tonumber(rRoll.nTarget) or 0;
	
	for _,v in ipairs(rRoll.aDice) do
		if v.result >= nTarget then
			rRoll.nSuccesses = rRoll.nSuccesses + 1;
		end
--	Debug.chat("v: ", v);
	end
	

--  Debug.chat("2-----------");
--  Debug.chat(rRoll);
--  Debug.chat(rRoll.aSavedDice);
 
  rRoll.aSavedDice = Json.stringify(aSavedDice);

Debug.console("aRerollDice: ",#aRerollDice, aRerollDice);
  if #aRerollDice > 0 then
    rRoll.aDice = aRerollDice;
    ActionsManager.performAction(draginfo, rActor, rRoll);
    return;
  else
    rRoll.aDice = aSavedDice;
  end
--  Debug.chat(rRoll.aDice);
  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
--  rRoll.total = rRoll.nSuccesses;
rMessage.dice.total = rRoll.nSuccesses;

	rMessage.text = rMessage.text .. "\nSuccesses [target " .. rRoll.nTarget .. "] " .. rRoll.nSuccesses;
--  rMessage = createChatMessage(rSource, rRoll);
--  rMessage.type = "dice";
  rMessage.type = sCmd;

  Comm.deliverChatMessage(rMessage);
end


---
--- This function creates the roll object based on the parameters sent in
---
function createRoll(sDice, sDesc)
  local aDice, nMod = StringManager.convertStringToDice(sDice);

  local rRoll = { };
  rRoll.aDice = aDice;
  rRoll.sType = sCmd;
  rRoll.nMod = nMod;
  rRoll.sDesc = sDesc;
  rRoll.nTarget = 0;
  rRoll.nCount = 3;

  
--  Debug.chat("1-----------");
  
--  Debug.chat(aDice);
--  Debug.chat(sCmd);
--  Debug.chat(nMod);
--  Debug.chat(sDesc);
  
  
--- rRoll.sUser = User.getUsername();

--Debug.console("createRoll: ",rRoll);
  
  return rRoll;
end

function onDiceTotal( messagedata )
--	Debug.chat("messagedata: ", messagedata);
	local sMyTotal = string.match(messagedata.text, "]%s(%d+)");
--	Debug.chat("onDiceTotal: ", sMyTotal);
--	Debug.chat("onDiceTotal: ", messagedata.text);
--	Debug.chat("onDiceTotal: ", messagedata);
	return true, tonumber(sMyTotal);
end


---
--- This function creates a chat message that displays the results.
---
function createChatMessage(rSource, rRoll)  
  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
  
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
