-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

-- MoreCore v0.60 register "c2mod"

local sCmd = "c2mod";

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
	local sc2cost, sc2name = sParams:match("(%-?%d+)%s*(.*)");
--	Debug.chat("sc2cost: ", sc2cost, " sc2name: ", sc2name);
--	Debug.chat("rActor: ", rActor);
	local nodeWin = rActor.sCreatureNode;
--	Debug.chat("nodeWin: ", nodeWin, " sc2name: ", sc2name);
	local sName = rActor.sName;
	local sModDesc, nMod = ModifierStack.getStack(true);
	--	Debug.chat("sModDesc: ", sModDesc);
	--	Debug.chat("nMod: ", nMod);
	local nTotalCost = tonumber(sc2cost) + nMod;
	--	Debug.chat("nTotalCost: ", nTotalCost);

	rRoll.sDesc = sc2name;
	rRoll.nTotalCost = nTotalCost;
	rRoll.sModDesc = sModDesc;
----	Debug.chat("rRoll: ", rRoll);

--	Debug.console("performAction: ", rRoll);
 
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
    rMessage.dicedisplay = 0; -- display total


--	local nSpellMax = tonumber(DB.getValue(nodeWin .. ".defence"));
----	Debug.chat("nSpellMax: ", nSpellMax);
----	Debug.chat("nodeWin: ", nodeWin);

		nc2Cur = DB.getValue(nodeWin .. ".defence");
	--	Debug.chat("PC nc2Cur: ", nc2Cur);
	
		rMessage.text = sName .. " uses " .. rMessage.text .. " " .. rRoll.sModDesc .. " (cost " .. nTotalCost .. ")";
		nc2Cur = nc2Cur + nTotalCost;
--	--	Debug.chat("nc2Cur: ", tonumber(nc2Cur)); 

		DB.setValue(nodeWin .. ".defence", "number", tonumber(nc2Cur));
	--	Debug.chat("PC nc2Cur SET: ", nc2Cur);

		DB.setValue(nodeWin .. ".defence", "number", tonumber(nc2Cur));

	rMessage.text = rMessage.text .. rRoll.sModDesc;
	Comm.deliverChatMessage(rMessage);
	end   



