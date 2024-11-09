-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local sCmd = "mother2";

-- MoreCore v0.60 
function onInit()
  CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all", nil, nil, onDiceTotal)
  
end

function performAction(draginfo, rActor, sParams)
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
  local rRoll = { };
  rRoll.aDice = {};
  rRoll.sType = sCmd;
  rRoll.nMod = 0;
  local sDesc = "";
  local sDesc1 = "";
  rRoll.nTarget = 0;

	local sDice, sTarget, sDesc = string.match(sParams, "([^%s]+)x(%d+)%s*(.*)");

	local aDice, nMod = StringManager.convertStringToDice(sDice);
	local sDesc1, nMod1 = ModifierStack.getStack(true);

	nTarget = tonumber(sTarget);
	sDesc = sDesc .. ", " .. sDesc1;
	nTarget = nTarget + nMod + nMod1;

	rRoll.nTarget = nTarget;
	rRoll.nMod = nMod + nMod1;
	rRoll.sDesc = sDesc;
	rRoll.aDice = aDice;
  return rRoll;
end



function onLanded(rSource, rTarget, rRoll)
  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
  rRoll = newDiceResults(rRoll);
  rMessage = createChatMessage(rSource, rRoll);
  rMessage.type = sCmd;
  Comm.deliverChatMessage(rMessage);
end

function newDiceResults(rRoll)

	sDesc = rRoll.sDesc;
	local sResult = "";
	local nTotal = 0;
	
    for k,v in ipairs(rRoll.aDice) do
		nTotal = nTotal + v.result;
	end
	nTotal = nTotal * 10;
	
	if nTotal <= nTarget then 
		sResult = "Success";
	else
		sResult = "Failure";
	end

	rRoll.sResult = sResult;
	rRoll.nTotal = nTotal;
	rRoll.sDesc = sDesc;
	
	return rRoll;
end


---
--- This function creates a chat message that displays the results.
---
function createChatMessage(rSource, rRoll)  
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

	local sResult = rRoll.sResult;
	local nMod = rRoll.nMod;
	local nTotal = rRoll.nTotal;

    rMessage.dicedisplay = 1; -- display total

	rMessage.text = rMessage.text .. "\n[Result] " .. nTotal .. " - " .. sResult .. "\n[Target] " .. nTarget;

  return rMessage;
end

function onDiceTotal( messagedata)
	local sTotal = string.match(messagedata.text, "Result]%s(%d+)");
	local nTotal = tonumber(sTotal);
	return true, nTotal;
end

---
--- This function creates the help text message for output.
---
function createHelpMessage()  
  local rMessage = ChatManager.createBaseMessage(nil, nil);
  rMessage.text = rMessage.text .. "Usage: /"..sCmd.." <target> <message>\n"; 
  rMessage.text = rMessage.text .. "The result, along with a message is output to the chat window."; 
  Comm.deliverChatMessage(rMessage);
end
