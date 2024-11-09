-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local sCmd = "lfgluck";

-- MoreCore v0.60 
function onInit()
  CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all");
end

function performAction(draginfo, rActor, sParams)
Debug.console("performAction: ", draginfo, rActor, sParams);
  if not sParams or sParams == "" then 
    sParams = "1d20x10";
  end

  if sParams == "?" or string.lower(sParams) == "help" then
    createHelpMessage();    
  else
    local rRoll = createRoll(sParams);
    ActionsManager.performAction(draginfo, rActor, rRoll);
  end   

end


function onLanded(rSource, rTarget, rRoll)
Debug.console("onLanded: ", rRoll);
Debug.console("onLanded: ", rSource);
Debug.console("onLanded: ", rTarget);
  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
  rRoll = getDiceResults(rRoll);
  rMessage = createChatMessage(rSource, rRoll);
  rMessage.type = "dice";
  Comm.deliverChatMessage(rMessage);
end


---
--- This function creates the roll object based on the parameters sent in
---
---
--- This function first sorts the dice rolls in ascending order, then it splits
--- the dice results into kept and dropped dice, and stores them as rRoll.aDice
--- and rRoll.aDropped.
---
function getDiceResults(rRoll)
nTotal = 0;
	myChar = rRoll.myChar;
	nMaxLuck = rRoll.nMaxLuck;
	myLuck = DB.getValue(myChar .. ".curluck");
	nMinLuck = math.ceil(tonumber(DB.getValue(myChar .. ".pcclasslevel"))/2);
--	Debug.chat("nMinLuck: ", nMinLuck)	;


Debug.console("myChar: ", myChar)	;
Debug.console("myLuck: ", myLuck)	;
Debug.console("nMaxLuck: ", nMaxLuck)	;

	
	
  local save = tonumber(rRoll.save);
	Debug.console("Save (dropresults): ", save);
	
	
    for _,v in ipairs(rRoll.aDice) do


	nTotal = nTotal + v.result;
	Debug.console("rRoll.nMod 1: ", rRoll.nMod);
	end

	d20result = nTotal;
	Debug.console("d20result: ", d20result);

	save = save + rRoll.nMod;
	if save > 20 then save = 20;
	end

	Debug.console("rRoll.nMod 1a: ", rRoll.nMod, " d20result: ", d20result);


	if d20result == 20 then
		Debug.console("Terrible Failure: ", nTotal);
		sSaveResult = "Terrible Failure";
		
	elseif nTotal > save*1.5 then
		Debug.console("Terrible Failure: ", nTotal);
		sSaveResult = "Terrible Failure";
		
	elseif nTotal > save then
		Debug.console("Failure: ", nTotal);
		sSaveResult = "Failure";
		
	elseif nTotal <= nMinLuck then
		Debug.console("Great Success: ", nTotal);
		sSaveResult = "Great Success - Luck Spent";
			if save <= nMinLuck then 
				DB.setValue(myChar .. ".curluck", "number", nMinLuck);
			else
				DB.setValue(myChar .. ".curluck", "number", myLuck-1);
			end
		
	elseif nTotal <= save then
		Debug.console("Success: ", nTotal);
		sSaveResult = "Success - Luck Spent";
			if save <= nMinLuck then 
				DB.setValue(myChar .. ".curluck", "number", nMinLuck);
			else
				DB.setValue(myChar .. ".curluck", "number", myLuck-1);
			end
		end

	Debug.console("sSaveResult: ", sSaveResult);

  rRoll.aTotal = nTotal;
  rRoll.aSave = save;
  rRoll.aSaveResult = sSaveResult;
  
  return rRoll;
end
---
--- This function creates a chat message that displays the results.
---
function createChatMessage(rSource, rRoll)  
  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

  
    rMessage.text = rMessage.text .. "\n[Luck Roll - Target " .. rRoll.aSave .. "]\n[" .. rRoll.aSaveResult .. "] " .. rRoll.aTotal;

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
