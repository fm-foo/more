-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

-- MoreCore v0.60 register "c5mod"

local sCmd = "c5mod";

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
	local sc5cost, sc5name = sParams:match("(%-?%d+)%s*(.*)");
--	Debug.chat("sc5cost: ", sc5cost, " sc5name: ", sc5name);
--	Debug.chat("rActor: ", rActor);
	local nodeWin = rActor.sCreatureNode;
--	Debug.chat("nodeWin: ", nodeWin, " sc5name: ", sc5name);
	local sName = rActor.sName;
	local sModDesc, nMod = ModifierStack.getStack(true);
	--	Debug.chat("sModDesc: ", sModDesc);
	--	Debug.chat("nMod: ", nMod);
	local nTotalCost = tonumber(sc5cost) + nMod;
	--	Debug.chat("nTotalCost: ", nTotalCost);

	rRoll.sDesc = sc5name;
	rRoll.nTotalCost = nTotalCost;
	rRoll.sModDesc = sModDesc;
----	Debug.chat("rRoll: ", rRoll);

--	Debug.console("performAction: ", rRoll);
 
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
    rMessage.dicedisplay = 0; -- display total


--	local nSpellMax = tonumber(DB.getValue(nodeWin .. ".five"));
----	Debug.chat("nSpellMax: ", nSpellMax);
----	Debug.chat("nodeWin: ", nodeWin);

		nc5Cur = DB.getValue(nodeWin .. ".five");
	--	Debug.chat("PC nc5Cur: ", nc5Cur);
	
		rMessage.text = sName .. " uses " .. rMessage.text .. " " .. rRoll.sModDesc .. " (cost " .. nTotalCost .. ")";
		nc5Cur = nc5Cur + nTotalCost;
--	--	Debug.chat("nc5Cur: ", tonumber(nc5Cur)); 

		DB.setValue(nodeWin .. ".five", "number", tonumber(nc5Cur));
	--	Debug.chat("PC nc5Cur SET: ", nc5Cur);

		DB.setValue(nodeWin .. ".five", "number", tonumber(nc5Cur));

	rMessage.text = rMessage.text .. rRoll.sModDesc;
	Comm.deliverChatMessage(rMessage);
	end   



