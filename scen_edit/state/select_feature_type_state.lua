SelectFeatureTypeState = AbstractState:extends{}

function SelectFeatureTypeState:init(btnSelectFeatureType)
    self.btnSelectFeatureType = btnSelectFeatureType
end

function SelectFeatureTypeState:enterState()
end

function SelectFeatureTypeState:leaveState()
end

function SelectFeatureTypeState:MousePress(x, y, button)
    if button == 1 then
        local result, featureId = Spring.TraceScreenRay(x, y)
        if result == "feature"  then
            CallListeners(self.btnSelectFeatureType.OnSelectFeatureType, SCEN_EDIT.model:GetModelFeatureId(featureId))
        end
    elseif button == 3 then
        SCEN_EDIT.featureManager:SetState(DefaultState())
    end
end
