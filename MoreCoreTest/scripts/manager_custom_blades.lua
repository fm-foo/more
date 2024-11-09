-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local sCmd = "blades";

-- MoreCore v0.60 
function onInit()
  CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all", nil, nil, onDiceTotal)
  
end

function performAction(draginfo, rActor, sParams)
----	Debug.chat("performAction: ");
--Debug.console("performAction: ", draginfo, rActor, sParams);

  if sParams == "?" or string.lower(sParams) == "help" then
    createHelpMessage();    
  else
    local rRoll = createRoll(sParams);
--Debug.console("performAction: rRoll ", rRoll);
    ActionsManager.performAction(draginfo, rActor, rRoll);
  end   

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
--	Debug.chat("sDice, sDesc: ", sDice, sDesc);
	rRoll.sDesc = sDescriptionParam;

	local aDice, nMod = StringManager.convertStringToDice(sDice);
--	Debug.chat("aDice, nMod: ", aDice, nMod);
--	local aFinalDice = {};
----	Debug.chat("aDice, nMod: ", aDice, nMod);
----	Debug.chat("aFinalDice: ", aFinalDice);

	if nMod == 0 then 
		aDice = {"d6","d6"};
	else 
		aDice = {};
		i =  nMod;
		while i > 0 do
			table.insert(aDice, "d6");
			i = i - 1;
		end;
	end

--	Debug.chat("aFinalDice: ", aDice);

  if sTarget then
    rRoll.nTarget = tonumber(sTarget);
    rRoll.sDesc = sDescriptionParam .. ", " .. sDesc;
	else
		rRoll.sDesc = sDesc;
  end
--	Debug.console("createRoll: ",rRoll);
  
  rRoll.nMod = nMod;
  rRoll.aDice = aDice;
  return rRoll;
end


function newDiceResults(rRoll)
----	Debug.chat("newDiceResults: ");
--Debug.chat("onLanded: ", rRoll);
	local nSuccesses = 0;
	local nPartials = 0;
	local nMod = rRoll.nMod;
--	local k = 0;
	
	if nMod == 0 then
--	--	Debug.chat("Disadvantage onLanded");
		table.sort(rRoll.aDice, function(a,b) return a.result<b.result end)
			if rRoll.aDice[1].result == 6 then
				nSuccesses = 1;
				rRoll.aDice[1].type = "d2006";
			elseif rRoll.aDice[1].result > 3 then
				nPartials = 1;
				rRoll.aDice[1].type = "d6";
			else
				rRoll.aDice[1].type = "d1006";
			end
		rRoll.aDice[2].type = "d3006";
	else
--	--	Debug.chat("Dice");
		table.sort(rRoll.aDice, function(a,b) return a.result<b.result end)
		for k,v in ipairs(rRoll.aDice) do
	--	--	Debug.chat("k: ", k);
--			while k < tonumber(nMod) do 
--				k = k + 1;
		--	--	Debug.chat("k: ", k);
				if v.result == 6 then
					rRoll.aDice[k].type = "d2006";
					nSuccesses = nSuccesses + 1;
			--	--	Debug.chat("d2006 ", rRoll.aDice[k].result, k);
				elseif v.result > 3 then
					nPartials = nPartials + 1;
					rRoll.aDice[k].type = "d6";
			--	--	Debug.chat("d6 ", rRoll.aDice[k].result, k);
				else
					rRoll.aDice[k].type = "d1006";
			--	--	Debug.chat("d1006 ", rRoll.aDice[k].result, k);
				end
--			end
		end
	end
	
	rRoll.nSuccesses = nSuccesses;
	rRoll.nPartials = nPartials;
--	Debug.chat("nSuccesses: ", nSuccesses);
--	Debug.chat("nPartials: ", nPartials);
	
	return rRoll;
end


function onLanded(rSource, rTarget, rRoll)
----	Debug.chat("onLanded: ", rSource, rTarget);
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
--- This function creates a chat message that displays the results.
---
function createChatMessage(rSource, rRoll)  
  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

--	local nMod = rRoll.nMod;
	local nMod = 0;

    local nSuccesses = rRoll.nSuccesses;
    local nPartials = rRoll.nPartials;

    rMessage.diemodifier = nil;  -- dont display modifiers

    rMessage.dicedisplay = 0; -- dont display total

	if nSuccesses == 1 then 
		    rMessage.text = rMessage.text .. "\nFull Success";
	elseif nSuccesses > 1 then 
		    rMessage.text = rMessage.text .. "\nCritical Success";
	elseif nPartials >= 1 then 
		    rMessage.text = rMessage.text .. "\nPartial Success";
	else 
		    rMessage.text = rMessage.text .. "\nFailure";
	end
	rMessage.nSuccesses = nSuccesses;

----	Debug.chat("rMessage: ", rMessage);
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
