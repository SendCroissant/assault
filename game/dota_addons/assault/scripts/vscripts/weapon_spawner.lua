
function thisEntity:Spawn()
  local itemName = self:GetName();
  local item = CreateItem(itemName, nil, nil)
  item.spawner = self
  CreateItemOnPositionSync(self:GetAbsOrigin(), item)
end

thisEntity:Spawn()