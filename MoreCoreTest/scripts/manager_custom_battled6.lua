-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local sCmd = "battled6";

-- MoreCore v0.60 
function onInit()
--  Debug.console("10:onInit");
  CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all");
end

function performAction(draginfo, rActor, sParams)
--  Debug.console("16:performAction");
  local sDice, sOp, sSave, sDesc = sParams:match("([^%s]+)([<>])(%d+)%s*(.*)")
--	Debug.console("performAction: ", sDice, sOp, sSave, sDesc, rActor);
--  Debug.console("17:performAction");
--  local sDice, sDesc = string.match(sParams, "([^%s]+)%s*(.*)");
--  Debug.console("19:performAction");
  if sDice == nil or not StringManager.isDiceString(sDice) then
--  Debug.console("21:performAction");
    ChatManager.SystemMessage("Usage: /"..sCmd.." [dice+modifier] [description]");
    return;
  else
    local rRoll = createRoll(sDice, sDesc);
	rRoll.sOp = sOp;
	rRoll.sSave = tonumber(sSave);
--	Debug.chat("sOp: ", sOp, " sSave: ", sSave);
--  Debug.console("26:performAction");
--	Debug.console("performAction: rRoll ", rRoll);
    ActionsManager.performAction(draginfo, rActor, rRoll);
  end   
end

function getDieMax(sType)
--  Debug.console("31:getDieMax");
--	Debug.console("getDieMax: ", sType);
  local sDie = string.match(sType, "d(%d+)");
	tempmax = tonumber(sDie)  max = tempmax;
  return max;  
end

function initLastDice(aDice)
--  Debug.console("39:initLastDice");
  aSavedDice = {};
  for i , v in ipairs (aDice) do
    aSavedDice[i] = { type=v.type, result=0, exploded=true };
  end
  return aSavedDice;
end

function onLanded(rSource, rTarget, rRoll)
--  Debug.console("onLanded: ", rSource, rTarget, rRoll);
--  Debug.console("49:onLanded");
  
  local nTotal;
  if nTotal == nil then nTotal = rRoll.nMod; end
  
  local aDice = rRoll.aDice;

  -- get sSaved dice
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
 	nTotal = nTotal + v.result;
   if v.exploded then
      w = aDice[k]; 
      k = k + 1; -- move on to next die for next time around
      v.result = v.result + w.result;
      if w.result == getDieMax(w.type) and aDice[1].result == 6 then
        aRerollDice[j] = w.type;
        j = j + 1;
        v.exploded = true;
      else
        v.exploded = false;
      end
    end
  end

    for _,v in ipairs(rRoll.aDice) do
	nTotal = nTotal + v.result;
	end
	
  rRoll.aSavedDice = Json.stringify(aSavedDice);

-- Debug.console("aRerollDice: ",#aRerollDice, aRerollDice);
  if #aRerollDice > 0 then
    rRoll.aDice = aRerollDice;
    ActionsManager.performAction(draginfo, rActor, rRoll);
    return;
  else
    rRoll.aDice = aSavedDice;
  end

  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);


--	Debug.chat("nTotal: ", nTotal);
--	Debug.chat("rRoll.sOp: ", rRoll.sOp);
--	Debug.chat("rRoll.sSave: ", rRoll.sSave);
	if rRoll.sOp == ">" then
	if nTotal < tonumber(rRoll.sSave) then
--		Debug.console("Failed: ", nTotal);
		sSaveResult = "Failure";
	elseif nTotal >= tonumber(rRoll.sSave) then
--			Debug.console("Success: ", nTotal);
			sSaveResult = "Success";
		end
	elseif rRoll.sOp == "<" then
	if nTotal > tonumber(rRoll.sSave) then
--		Debug.console("Failed: ", nTotal);
		sSaveResult = "Failure";
	elseif nTotal <= tonumber(rRoll.sSave) then
--			Debug.console("Success: ", nTotal);
			sSaveResult = "Success";
		end
	end
--	Debug.chat("sSaveResult: ", sSaveResult);
  rMessage = createChatMessage(rSource, rRoll);
--	Debug.chat("rMessage: ", rMessage);
--	Debug.chat("Msg: ", rMessage.text);
  rMessage.text = rRoll.sDesc .. ", " .. sSaveResult;
  rMessage.type = "dice";
  Comm.deliverChatMessage(rMessage);
end


---
--- This function creates the roll object based on the parameters sent in
---
function createRoll(sDice, sDesc)
--  Debug.console("104:createRoll");

  local aDice, nMod = StringManager.convertStringToDice(sDice);

  local rRoll = { };
  rRoll.aDice = aDice;
  rRoll.sType = sCmd;
  rRoll.nMod = nMod;
  rRoll.sDesc = sDesc;
  rRoll.nTarget = 0;
  rRoll.nCount = 3;
--- rRoll.sUser = User.getUsername();

--Debug.console("createRoll: ",rRoll);
  
  return rRoll;
end

---
--- This function creates a chat message that displays the results.
---
function createChatMessage(rSource, rRoll)  
--  Debug.console("126:createChatMessage");
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
