-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

-- MoreCore v0.60 register "c4mod"

local sCmd = "c4mod";

function onInit()
  CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all");
	CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all", nil, nil, onDiceTotal)
end

function performAction(draginfo, rActor, sParams)
-- Debug.console("performAction: ", draginfo, rActor, sParams);

	local rRoll = {};
	rRoll.sType = sCmd;
	rRoll.nMod = 0;
----	Debug.chat("sParams: ", sParams);
--	Debug.chat("ActorManager: ", ActorManager.getCTNode(rActor));
--	Debug.chat("ActorManager: ", ActorManager.getActor(rActor));
--	Debug.chat("ActorManager: ", ActorManager.getTypeAndNodeName(rActor));
--	Debug.chat("ActorManager: ", ActorManager.getType(rActor));
	local sC4cost, sC4name = sParams:match("(%-?%d+)%s*(.*)");
--	Debug.chat("sC4cost: ", sC4cost, " sC4name: ", sC4name);
--	Debug.chat("rActor: ", rActor);
	local nodeWin = rActor.sCreatureNode;
--	Debug.chat("nodeWin: ", nodeWin, " sC4name: ", sC4name);
	local sName = rActor.sName;
	local sModDesc, nMod = ModifierStack.getStack(true);
	--	Debug.chat("sModDesc: ", sModDesc);
	--	Debug.chat("nMod: ", nMod);
	local nTotalCost = tonumber(sC4cost) + nMod;
	--	Debug.chat("nTotalCost: ", nTotalCost);

	rRoll.sDesc = sC4name;
	rRoll.nTotalCost = nTotalCost;
	rRoll.sModDesc = sModDesc;
----	Debug.chat("rRoll: ", rRoll);

--	Debug.console("performAction: ", rRoll);
 
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
    rMessage.dicedisplay = 0; -- display total


--	local nSpellMax = tonumber(DB.getValue(nodeWin .. ".four"));
----	Debug.chat("nSpellMax: ", nSpellMax);
----	Debug.chat("nodeWin: ", nodeWin);

		nC4Cur = DB.getValue(nodeWin .. ".four");
	--	Debug.chat("PC nC4Cur: ", nC4Cur);
	
		rMessage.text = sName .. " uses " .. rMessage.text .. " " .. rRoll.sModDesc .. " (cost " .. nTotalCost .. ")";
		nC4Cur = nC4Cur + nTotalCost;
--	--	Debug.chat("nC4Cur: ", tonumber(nC4Cur)); 

		DB.setValue(nodeWin .. ".four", "number", tonumber(nC4Cur));
	--	Debug.chat("PC nC4Cur SET: ", nC4Cur);

		DB.setValue(nodeWin .. ".four", "number", tonumber(nC4Cur));

	rMessage.text = rMessage.text .. rRoll.sModDesc;
	Comm.deliverChatMessage(rMessage);
	end   



