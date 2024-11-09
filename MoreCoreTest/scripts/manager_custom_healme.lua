-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local sCmd = "healme";

-- MoreCore v0.60 
function onInit()
  CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all");
end

function performAction(draginfo, rActor, sParams)
--	Debug.console("performAction: ", draginfo, rActor, sParams);
  if not sParams or sParams == "" then 
    sParams = "1d6";
  end

  if sParams == "?" or string.lower(sParams) == "help" then
    createHelpMessage();    
  else
    local rRoll = createRoll(sParams);
 	rRoll.sWho = rActor.sCreatureNode;
	-- Debug.chat("rRoll.sWho: ", rRoll.sWho);
   ActionsManager.performAction(draginfo, rActor, rRoll);
  end   

end

---
--- This function creates the roll object based on the parameters sent in
---
function createRoll(sParams)
  local rRoll = {};
  rRoll.sType = sCmd;
  rRoll.nMod = 0;
  rRoll.aDice = {};
  rRoll.aDropped = {};
  
	local nStart, nEnd, sDicePattern, sDescriptionParam = string.find(sParams, "([^%s]+)%s*(.*)");
	rRoll.sDesc = sDescriptionParam;
	-- Debug.chat("sParams: ", sParams);
	-- Debug.chat("sDicePattern: ", sDicePattern, "sDescriptionParam", sDescriptionParam);
	

	local aDice = StringManager.convertStringToDice(sDicePattern);
	-- Debug.chat("aDice: ", aDice);
	local sMod = string.match(sDicePattern, "+(%d+)");
	-- Debug.chat("sMod: ", sMod);
	local nMod = tonumber(sMod);
	-- Debug.chat("sMod: ", sMod);

  local aRulesetDice = Interface.getDice();
  local aFinalDice = {};
  local aNonStandardResults = {};
  for k,v in ipairs(aDice) do
    if StringManager.contains(aRulesetDice, v) then
      table.insert(aFinalDice, v);
    elseif v:sub(1,1) == "-" and StringManager.contains(aRulesetDice, v:sub(2)) then
      table.insert(aFinalDice, v);
    else
      local sSign, sDieSides = v:match("^([%-%+]?)[dD]([%dF]+)");
      if sDieSides then
        local nResult;
        if sDieSides == "F" then
          local nRandom = math.random(3);
          if nRandom == 1 then
            nResult = -1;
          elseif nRandom == 3 then
            nResult = 1;
          end
        else
          local nDieSides = tonumber(sDieSides) or 0;
          nResult = math.random(nDieSides);
        end
        
        if sSign == "-" then
          nResult = 0 - nResult;
        end
        
        nMod = nMod + nResult;
        table.insert(aNonStandardResults, string.format(" [%s=%d]", v, nResult));
      end
    end
  end



  if #aNonStandardResults > 0 then
    sDesc = sDesc .. table.concat(aNonStandardResults, "");
  end
  

 local rRoll = { sType = sCmd, sDesc = rRoll.sDesc, aDice = aFinalDice, nMod = nMod, sWho = rRoll.sWho };
	-- Debug.chat("rRoll: ", rRoll);
 return(rRoll);
  
end


function onLanded(rSource, rTarget, rRoll)
Debug.console("onLanded: ", rSource, rTarget, rRoll);
  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
  rRoll = getDiceResults(rRoll);
  rMessage = createChatMessage(rSource, rRoll);
  rMessage.type = "dice";
  Comm.deliverChatMessage(rMessage);
end


---

function getDiceResults(rRoll)
nTotal = 0;
	
    for _,v in ipairs(rRoll.aDice) do
	nTotal = nTotal + v.result;
	-- Debug.chat("v.result: ", v.result);
	end
	nTotal = nTotal + rRoll.nMod;
	-- Debug.chat("nTotal: ", nTotal);

--	Debug.console("sSaveResult: ", sSaveResult);

  rRoll.aTotal = nTotal;
  rRoll.aSave = save;
  rRoll.aSaveResult = sSaveResult;
  -- Debug.chat("rRoll: ", rRoll);
  return rRoll;
end
---
--- This function creates a chat message that displays the results.
---
function createChatMessage(rSource, rRoll)  
  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

	local sMyNode = rRoll.sWho..".wounds";
	local nCurrWounds = tonumber(DB.getValue(sMyNode, "number", 0 ));
	-- Debug.chat("nCurrWounds: ", nCurrWounds);
	local nNewWounds = nCurrWounds - rRoll.aTotal;
	if nNewWounds < 0 then nNewWounds = 0; end
	-- Debug.chat("nNewWounds: ", nNewWounds);
	DB.setValue(sMyNode, "number", nNewWounds );

	if tonumber(DB.getValue(sMyNode, "number", 0 )) == 0 then
		rMessage.text = rMessage.text .. "\n[Fully Healed] " .. rRoll.aTotal;
	else
		rMessage.text = rMessage.text .. "\n[Health Restored] " .. rRoll.aTotal;
	end
	
    rMessage.dicedisplay = 0; -- don't display total
  
    rMessage.text = rMessage.text;

  return rMessage;
end

---
--- This function creates the help text message for output.
---
function createHelpMessage()  
  local rMessage = ChatManager.createBaseMessage(nil, nil);
  rMessage.text = rMessage.text .. "The \"/"..sCmd.."\" command is used to roll a set of dice, removing a number of the lowest results.\n"; 
  rMessage.text = rMessage.text .. "You can specify the number of dice to roll, the type of dice, and the number of results to be dropped "; 
  rMessage.text = rMessage.text .. "by supplying the \"/rolld\" command with parameters in the format of \"#d#x#\", where the first # is the "; 
  rMessage.text = rMessage.text .. "number of dice to be rolled, the second number is the number of dice sides, and the number following the "; 
  rMessage.text = rMessage.text .. "x being the number of results to be dropped.\n"; 
  rMessage.text = rMessage.text .. "If no parameters are supplied, the default parameters of \"4d6x1\" are used."; 
  Comm.deliverChatMessage(rMessage);
end
