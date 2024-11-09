-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local sCmd = "weg2";

-- MoreCore v0.60 
function onInit()
Debug.chat("onInit: ");
--  CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all");
  CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all", nil, nil, onDiceTotal)
end

function performAction(draginfo, rActor, sParams)
Debug.chat("performAction: ", draginfo, rActor, sParams);
  local sDice, sDesc = string.match(sParams, "([^%s]+)%s*(.*)");
  local nDice = tonumber(sDice);
  if nDice < 1 or nDice == 'nil' then
    ChatManager.SystemMessage("Usage: /"..sCmd.." [number of dice] [description]");
    return;
  else
    local rRoll = createRoll(nDice, sDesc);
	Debug.console("performAction: rRoll ", rRoll);
    ActionsManager.performAction(draginfo, rActor, rRoll);
  end   
end

---
--- This function creates the roll object based on the parameters sent in
---
function createRoll(nDice, sDesc)
Debug.chat("createRoll, nDice, sDesc: ", nDice, sDesc);
	local nDice = nDice;
	local aDice = {};
	local nCount = nDice;
	while nCount > 1 do
		table.insert(aDice, "d1006"); 
		nCount = nCount - 1;
	end
	while nCount > 0 do
		table.insert(aDice, "d6"); 
		nCount = nCount - 1;
	end

	local sDesc1, nMod = ModifierStack.getStack(true);

	local nTotalDice = nDice + nMod;

	while nMod > 0 do
		table.insert(aDice, "d1006"); 
		nMod = nMod - 1;
	end
  
		Debug.chat("aDice1: ", aDice);

  local rRoll = { };
  rRoll.aDice = aDice;
		Debug.chat("aDice1a: ", rRoll.aDice);
  rRoll.sType = sCmd;
  rRoll.nMod = nMod;
  rRoll.sDesc = sDesc, sDesc1;
  rRoll.nTarget = 0;
  rRoll.nCount = 3;
  rRoll.nDice = nDice;
--- rRoll.sUser = User.getUsername();

--Debug.console("createRoll: ",rRoll);
  
  return rRoll;
end

function onLanded(rSource, rTarget, rRoll)
    Debug.chat("onLanded: ", rSource, rTarget, rRoll);
    Debug.chat("aDice3: ", rRoll.aDice);
    Debug.chat("nDice3: ", rRoll.nDice);

	aDice = rRoll.aDice;
	local nSuccesses = 0;
  -- get saved dice
  local aSavedDice = nil;
  if rRoll.aSavedDice then
    aSavedDice = Json.parse(rRoll.aSavedDice);
    Debug.chat("aSavedDice1: ", aSavedDice);
  else
    aSavedDice = initLastDice(aDice);
    Debug.chat("aSavedDice2: ", aSavedDice);
  end

  local aRerollDice = {};
  local j = 1; -- reRoll dice index
  local k = 1; -- aDice index

	
  for i , v in ipairs (aSavedDice) do
  
	
    Debug.chat("onLanded: last dice ", i, v);
    if v.exploded then
      w = aDice[k]; 
      k = k + 1; -- move on to next die for next time around
      v.result = v.result + w.result;

      if w.result == 6 and w.type == 'd6' then
		Debug.chat("W: ", w);
        aRerollDice[j] = w.type;
        j = j + 1;
        v.exploded = true;
		nSuccesses = nSuccesses +1;
      elseif w.result == 1 and w.type == 'd6' then
 		nSuccesses = nSuccesses -1;
       v.exploded = false;
      elseif w.result > 3 and w.type == 'd6' then
 		nSuccesses = nSuccesses +1;
       v.exploded = false;
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
--	Debug.console("aSavedDice: ", aSavedDice);
--	Debug.console("Result 1: ", rRoll.aDice[1].result);
--	Debug.console("Result 2: ", rRoll.aDice[2].result);
--	Debug.console("Result 3: ", rRoll.aDice[3].result);


			
	  local nTotal = 0;

		Debug.console("Count2: ", count);

		nWEGResult = nTotal + rRoll.nMod;
		sMessage1 = "Result: " .. nWEGResult;
--		Debug.console("sMessage1: ", sMessage1);
	
  end

  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

  rMessage = createChatMessage(rSource, rRoll);
--  rMessage.dicedisplay = 0; -- don't display total
  rMessage.type = "sCmd";
  rMessage.text = rMessage.text .. " - ".. sMessage1 .. "\nSuccesses: " .. nSuccesses;
  Comm.deliverChatMessage(rMessage);

end


function initLastDice(aDice)
	Debug.chat("aDice2: ", aDice);
  aSavedDice = {};
  for i , v in ipairs (aDice) do
    aSavedDice[i] = { type=v.type, result=0, exploded=true };
  end
  return aSavedDice;
end

function orderDiceResults(rRoll)
  -- Sort rRoll.aDice table based off a.result (the dice result)
    table.sort(rRoll.aDice, function(a,b) return a.result<b.result end)
  
  return rRoll;
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
