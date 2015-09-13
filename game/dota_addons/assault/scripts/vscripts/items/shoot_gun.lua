
function Fire(keys)
  local particleName = "particles/weapons/shootgun1.vpcf"
  local item = keys.ability
  local max_dist = item:GetSpecialValueFor('max_dist')
  local caster = keys.caster
  local target = keys.target_points[1] + Vector(0, 0, 64)
  local origin = caster:GetOrigin() + Vector(0, 0, 64)
  local direction = target - origin
  local len = direction:Length2D()
  local scale = max_dist/len
  local vel = direction * Vector(scale, scale, scale)
  local spread = item:GetSpecialValueFor('spread')
  local count = item:GetSpecialValueFor('count')
  local zero = Vector(0, 0, 0)
  local proj = {
    Ability           = item,
    EffectName        = particleName,
    vSpawnOrigin      = origin,
    fDistance         = 1800,
    fStartRadius      = 30,
    fEndRadius        = 30,
    Source            = caster,
    bHasFrontalCone   = true,
    iUnitTargetTeam   = DOTA_UNIT_TARGET_TEAM_BOTH,
    iUnitTargetFlags  = DOTA_UNIT_TARGET_FLAG_NONE,
    iUnitTargetType   = DOTA_UNIT_TARGET_ALL,
    bDeleteOnHit      = true,
    vVelocity         = vel,
    bProvidesVision   = false,
  }

  for i = 1,count do
    local delta = RandomFloat(-spread, spread)
    local nvel = RotatePosition(zero, QAngle(0, delta, 0), vel)
    proj.vVelocity = nvel
    ProjectileManager:CreateLinearProjectile(proj)
  end
end

function Hit(keys)
end
