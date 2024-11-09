-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local sCmd = "rk";

-- MoreCore v0.60 
function onInit()
--  CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all");
  CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all", nil, nil, onDiceTotal)
end

function performAction(draginfo, rActor, sParams)
--Debug.chat("performAction: ", draginfo, rActor, sParams);
  local sDice, sKeep, sDesc = string.match(sParams, "([^%s]+)[xk](%d+)%s*(.*)");
--	Debug.chat("performAction: ", sDice, sKeep, sDesc);

  if sDice == nil or not StringManager.isDiceString(sDice) then
    ChatManager.SystemMessage("Usage: /"..sCmd.." [#d#x#] [description]");
    return;
  else
	sDice = sDice .. "x" .. sKeep;
--	Debug.chat("sDice: ", sDice);
    local rRoll = createRoll(sDice, sDesc);
	rRoll.sKeep = sKeep;
	Debug.console("performAction: rRoll ", rRoll);
    ActionsManager.performAction(draginfo, rActor, rRoll);
  end   
end

---
--- This function creates the roll object based on the parameters sent in
---
function createRoll(sDice, sDesc)
  local sDice, sKeep = string.match(sDice, "([^%s]+)[xk](%d+)");
  local aDice, nMod = StringManager.convertStringToDice(sDice);
--	Debug.chat("sKeep: ", sKeep);
  local rRoll = { };
  rRoll.aDice = aDice;
  rRoll.sType = sCmd;
  rRoll.nMod = nMod;
  rRoll.sDesc = sDesc;
  rRoll.nTarget = 0;
  rRoll.nCount = 3;

  rRoll.sKeep = sKeep;

--Debug.console("createRoll: ",rRoll);
--	Debug.chat("sKeep: ", rRoll.sKeep);
  return rRoll;
end

function getDieMax(sType)
Debug.console("getDieMax: ", sType);
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

function onDiceTotal( messagedata)
--	Debug.chat("onDiceTotal: ", messagedata);
	local sMyTotal = string.match(messagedata.text, "Total:%s(%d+)");
--	Debug.chat("onDiceTotal: ", sMyTotal, messagedata);
  return true, tonumber(sMyTotal);

end


function onLanded(rSource, rTarget, rRoll)
--	Debug.chat("onLanded1: ", rSource);
--	Debug.chat("onLanded2: ", rTarget);
--	Debug.chat("onLanded3: ", rRoll);
  
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
    Debug.console("onLanded: last dice ", i, v);
    if v.exploded then
      w = aDice[k]; 
      k = k + 1; -- move on to next die for next time around
      v.result = v.result + w.result;
      if w.result == 0 then
        v.exploded = false;
	  elseif w.result == getDieMax(w.type) then
        aRerollDice[j] = w.type;
        j = j + 1;
        v.exploded = true;
      else
        v.exploded = false;
      end
    end
  end


  rRoll.aSavedDice = Json.stringify(aSavedDice);

Debug.console("aRerollDice: ",#aRerollDice, aRerollDice);
  if #aRerollDice > 0 then
    rRoll.aDice = aRerollDice;
    ActionsManager.performAction(draginfo, rActor, rRoll);
    return;
  else
    rRoll.aDice = aSavedDice;
  end



  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

    table.sort(rRoll.aDice, function(a,b) return a.result>b.result end)

  nTotal = 0;
  k = 1;
  for i , v in ipairs (aDice) do
	while k <= tonumber(rRoll.sKeep) do 
--  --	Debug.chat("dice ", i, v, k);
--  --	Debug.chat("v.result: ", v.result);
	
	nTotal = nTotal + rRoll.aDice[k].result;
	rRoll.aDice[k].type = "d200" .. max;
      k = k + 1; -- move on to next die for next time around
	end
  end
  --  --	Debug.chat("nTotal: ", nTotal);
	
  rMessage = createChatMessage(rSource, rRoll);
  rMessage.nTotal = nTotal;
  rMessage.text = rMessage.text .. "\rTotal: " .. rMessage.nTotal;
  rMessage.type = sCmd;
--	Debug.chat("154");
  Comm.deliverChatMessage(rMessage);
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
